Tableize
========

Installation
------------
    gem install tableize

Usage
-----
#### Basic
    table_for Post, @posts do |t|
        t.column "Title", :title
        t.column "Author", :author
    end

Is the same as:

    table_for do |t|
        t.columns :title, :author
    end

Both examples generate the following html:

    <table class="posts">
        <thead>
            <tr>
                <th class="title string">Title</th>
                <th class="author string">Author</th>
            </tr>
        </thead>
        <tbody>
            <tr class="post_1">
                <td>Hello World!</td>
                <td>Christian Blais</td>
            </tr>
        </tbody>
    </table>

#### Few defaults
* Inherited Resources

    By default, `Tableize` will search for both `resource_class` and `collection` methods. So you don't have to specify them each time, unless
    of course you want to override the default behavior. That being said, the following code produces the exact same output as the basic example
    above.

        table_for do |t|
            t.column "Title", :title
            t.column "Author", :author
        end

* I18n

    By default, `Tableize` will try to internationalise your attribute, so you don't have to name each of your column. So, assuming my
    model responds to `human_attribute_name`, the following example still produces the exact same output.

        table_for do |t|
            t.column :title
            t.column :author
        end

* Columns

    `Tableize` responds to `defaults` method, which will create a column for each public attribute of your model. Use it like this:

        table_for do |t|
            t.defaults
        end

* Multiple columns, one line

        table_for do |t|
            t.columns :title, :author
        end

#### Advanced features
* Lambdas

    You can use lambdas if you want to have a custom column.

        table_for do |t|
            t.column "Title" do |post|
                post.title + "!"
            end
        end

    You can also specify a method to be called before the yield.

        table_for do |t|
            t.column "Title", :title do |title|
                title + "!"
            end
        end

* Extras

    Let's say `author` is a relation, and you want to show his first name and last name as two separate columns. The following would works:

        table_for do |t|
            t.column "First name", :author do |author|
                author.first_name
            end
            t.column "Last name", :author do |author|
                author.last_name
            end
        end

    But the above code triggers the `author` method twice. In order to avoid that, you could use the `extra` method, which will be executed only
    once per row, yielding the result alongside the resource in each block. You can use more than one extra without any problem.

        table_for do |t|
            t.extra do |post|
                post.author
            end

            t.column "First name" do |post, author|
                author.first_name
            end
            t.column "Last name" do |post, author|
                author.last_name
            end
        end

* Hashes

    `Tableize` also accepts hashes instead of regular collections. Use it the same way.

        collection = [{:title => "Hello World", "author" => "Christian Blais"}]

        table_for Post, collection do |t|
            t.column :title
            t.column "author"
        end