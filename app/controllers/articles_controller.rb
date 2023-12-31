class ArticlesController < ApplicationController
    skip_before_action :verify_authenticity_token
    def all
        render json: Article.all
    end

    def create
        @article = Article.new(title: params[:title],content:params[:content],author_id:params[:authorId])
        if params[:image].present?
          @article.image.attach(params[:image])
          image_url = url_for(@article.image) if @article.image.attached?
          puts image_url
        end
         
        if @article.save
          render json: {message:"Created",image_url: url_for(@article.image)}, status: :created
        else
          render json: { errors: @article.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def edit_article
        @article = Article.find(params[:id])
        article_params = JSON.parse(request.body.read)
        if @article.update(article_params)
            render json: @article, status: :ok
        else
            render json: @article.errors, status: :unprocessable_entity
        end
    end

    def delete_article
        @article = Article.find(params[:id])
        if @article.destroy
            render json: { message: 'Article was successfully deleted.' }, status: :ok
        else
            render json: { error: 'Unable to delete the article.' }, status: :unprocessable_entity
        end
    end

    def get_articles
        per_page = params[:perPage] || 10
        page = params[:page] || 1

        offset = (page.to_i - 1) * per_page.to_i
        @articles = Article.offset(offset).limit(per_page)
        total_count = Article.count

        render json: {
            articles: @articles,
            total_count: total_count
        }
    end

    def filter_by_author
        if params[:authorId].present?
            author = Author.find_by(id: params[:authorId])
            unless author
                render json: { error: 'Author not found' }, status: :not_found
                return
            end
        
            @articles = author.articles
        else
            @articles = Article.all
        end
        
        render json: @articles
    end 

    def filter_by_dates
        if params[:start_date].present? && params[:end_date].present?
          start_date = Date.parse(params[:start_date])
          end_date = Date.parse(params[:end_date])
    
          @articles = Article.where(published_at: start_date..end_date)
        else
          @articles = Article.all
        end
    
        render json: @articles
    end

    def sort
        if params[:sort] == 'asc'
          @articles = Article.order(published_at: :asc)
        elsif params[:sort] == 'desc'
          @articles = Article.order(published_at: :desc)
        else
          @articles = Article.all
        end
    
        render json: @articles
    end
    
    def search
        if params[:search].present?
          search_query = params[:search].strip.downcase
          
          where_clause = "lower(title) LIKE '%"+search_query+"%' OR lower(content) LIKE '%"+search_query+"%'"
          # Find articles that match the search query in title, description, or tags
          @articles = Article.where(where_clause)
        else
          @articles = Article.all
        end
    
        render json: @articles
    end

    def upload
        if params[:file].present?
        
          file = params[:file]
          file_blob = ActiveStorage::Blob.create_and_upload!(
            io: file,
            filename: file.original_filename,
            content_type: file.content_type,
            service_name: :custom_files
          )
    
          render json: { message: "File uploaded successfully", file_url: url_for(file_blob) }, status: :created
        else
          render json: { error: "No file attached" }, status: :unprocessable_entity
        end
      end
end

