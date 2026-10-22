require 'debug'
require "awesome_print"

class App < Sinatra::Base
    register Sinatra::Reloader

    def db
      return @db if @db

      @db = SQLite3::Database.new(DB_PATH)
      @db.results_as_hash = true

      return @db
    end
  get '/fruits' do
    @fruits = db.execute('SELECT * FROM products')
   ap @fruits
  erb(:"fruits/index")

  # Ruby koden för vad som ska vara i HTTP response här
  end
 get '/categories' do
  @categories = db.execute('SELECT * FROM categories')
  ap @categories
  erb(:"categories/index")
end

get '/categories/:id'do |id|
  @fruits = db.execute('SELECT * FROM products 
						   WHERE category_id=?', id)
               ap @fruits
  @category = db.execute('SELECT * FROM categories 
							   WHERE id=?',id).first

erb(:"categories/show")
end



   get '/fruits/new' do
     @categories = db.execute('SELECT * FROM categories')
    ap @fruits
    erb(:"fruits/new")
  end
get '/fruits/:id' do | id |
  @fruit = db.execute('SELECT * FROM products 
						   WHERE id=?', id).first
  @category = db.execute('SELECT * FROM categories 
							   WHERE id=?',
							   @fruit['category_id']).first
  ap @fruit
  ap @category
  erb(:"fruits/show")
end

  get '/fruits/:id/edit' do |id|
    @fruit = db.execute('SELECT * FROM products WHERE id=?',id).first
    @categories = db.execute("SELECT * FROM categories")
    ap @fruit
    erb(:"fruits/edit")
  end

  post '/fruits/:id/delete' do | id |
    db.execute('DELETE FROM products WHERE id=?' , id)
    redirect("/fruits")
  end

  post '/fruits' do
    ap params
   frukt_namn = params["frukt_namn"]
   frukt_bes = params["frukt_bes"]
   frukt_score = params["frukt_score"]
   frukt_categori = params["category_id"]
    db.execute('INSERT INTO products (name , tastiness , description, category_id) VALUES (?,?,?,?)', [frukt_namn , frukt_score , frukt_bes, frukt_categori])
    redirect("fruits")
  end
  post '/fruits/:id/update'do |id|
    ap params
    frukt_ny_namn = params["ny_name"]
    fruky_ny_desc = params["ny_desc"]
    fruky_ny_score = params["ny_score"]
    fruky_ny_category = params["category_id"]
    db.execute('UPDATE products SET name = ?,tastiness = ? ,description = ?,category_id= ?   WHERE id = ?', [frukt_ny_namn ,fruky_ny_score, fruky_ny_desc ,fruky_ny_category, id])
    redirect("fruits")
  end
 
end

