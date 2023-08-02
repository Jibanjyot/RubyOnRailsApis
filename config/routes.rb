# config/routes.rb
Rails.application.routes.draw do
  root 'todo#index'
  get '/api/article/all', to: 'articles#all'
  post '/api/add/article', to: 'articles#create'
  put '/api/edit/article/:id', to: 'articles#edit_article'
  delete '/api/delete/article/:id', to: 'articles#delete_article'
  get '/api/article/', to: 'articles#get_articles'
  get '/articles/filterByAuthor/:authorId', to: 'articles#filter_by_author'
  get '/articles/filter_by_dates', to: 'articles#filter_by_dates'
  get '/articles/sort', to: 'articles#sort'
  get '/articles/search', to: 'articles#search'
  post '/articles/upload', to: 'articles#upload'

  # add author
  post '/api/author/add', to: 'authors#create'
  post '/api/author/signIn', to: 'authors#sign_in'

  # send emails
  post '/emails/custom', to: 'authors#send_custom_email'
end
