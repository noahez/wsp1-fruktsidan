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
   get '/fruits/new' do
    ap @fruits
    erb(:"fruits/new")
  end
  get '/fruits/:id/edit' do |id|
    @fruit = db.execute('SELECT * FROM products WHERE id=?',id).first
    ap @fruit
    erb(:"fruits/edit")
  end
  get '/fruits/:id' do | id |
    @fruit = db.execute('SELECT * FROM products WHERE id=?',id).first 
    ap @fruit
    erb(:"fruits/show")
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
    db.execute('INSERT INTO products (name , tastiness , description) VALUES (?,?,?)', [frukt_namn , frukt_score , frukt_bes])
    redirect("fruits")
  end
  post '/fruits/:id/update'do |id|
    ap params
    frukt_ny_namn = params["ny_name"]
    fruky_ny_desc = params["ny_desc"]
    db.execute('UPDATE products SET name = ?, description = ? WHERE id = ?', [frukt_ny_namn , fruky_ny_desc, id])
    redirect("fruits")
  end
 
end

