Tableize
========

Installation
------------
First, install the gem
    gem install tableize

In an initializer, include the `Tableize` module
    ActionView::Base.send(:include, Tableize)

Usage
-----
The simplest scenario
    table_for Post, @posts do |t|
      t.column "Title", :title
      t.column "Author", :author
    end

Is the same as

    table_for Post, @posts do |t|
      t.columns :title, :author
    end

Both examples generate the following html

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

### Few defaults
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

### Advanced features
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

### Configuration
`Tableize` can me customized in an initializer.

    Tableize::Configuration.configure do |config|
      [...]
    end

#### Options
Here are the defaults used in the first example.

* table_options
This option let you set default values for all your tables. It must be a lambda that returns a hash. The lambda receive one argument, which is the resource class, when available.

    config.table_options = lambda do |resource_class|
      {
        :class => "#{resource_class.model_name.tableize}"
      }
    end

* th_options
This option let you set default values for all your th cells. It must be a lambda that returns a hash. The lambda receive two arguments; the field name and it's value type.

    config.th_options = lambda do |field, type|
      {
        :class => [field, type].compact.map{ |a| a.to_s.underscore }
      }
    end

* tr_options
This option let you set default values for all your rows. It must be a lambda that returns a hash. The lambda receive the resource as a single argument.

    config.tr_options = lambda do |resource|
      {
        :class => "#{resource.class.model_name.underscore}_#{resource.id}"
      }
    end

#### Custom column
Let's suppose you are doing an admin section and that you always need a column to display the resource's name with a link to that resource's show page.

The following would work, but it's pretty long if you need to do that all the time.

    table_for do |t|
      t.column "Title" do |resource|
        resource.title
      end
    end

What about your own column type?

    config.custom_column :title, :html => {:class => "titleized"} do |column|
      column.th :class => "title_th" do |resource_class|
        resource_class.human_attribute_name(:title)
      end

      column.td :class => "title_td" do |resource|
        resource.title
      end
    end

Having this in your configuration file, you can now do this

    table_for do |t|
      t.title
    end

This will produce the following html

    <table class="posts titleized">
        <thead>
            <tr>
                <th class="title string title_th">Title</th>
            </tr>
        </thead>
        <tbody>
            <tr class="post_1">
                <td class="title_td">Hello World!</td>
            </tr>
        </tbody>
    </table>
