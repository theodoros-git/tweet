class UserController < ApplicationController
  def signup
		render "user/signup", layout: false
	end
	## Inscription
	def signup_form
		@user = User.new(user_params)
		if @user.save
			flash[:register_success] = "Vous vous êtes inscrit avec succès. Veuillez donc vous connecter. Merci"
			redirect_to '/'
		else
			flash[:register_errors] = @user.errors.full_messages
			redirect_to '/users/sign_up'
		end
	end
	## Connection
	def login
		@user = User.find_by(email:login_params[:email])
		if @user && @user.authenticate(login_params[:password])
			flash[:login_success] = "Connection réussie"
			session[:current_user_id] = @user.id
      		redirect_to '/users/dashboard'
	    else
	        flash[:login_errors] = "Identifiants incorrects"
	        redirect_to '/'
	    end
	end
  def dashboard
		@posts = Post.all
		@users = User.all
		render "user/dashboard", layout: "layout"
	end

  def new_publication
		@publication = Post.new
		render "user/new_post", layout: "layout"
	end

  def new_publication_form
		@publication = Post.new(pub_params)
		render "user/new_pub_confirm", layout: "layout"
	end
	def destroy_pub
		@publication = Post.find(params[:id])
	  @publication.destroy
	  flash[:pub_destroy] = "Post supprimé avec succès"
	  redirect_to '/users/dashboard'
	end
	def destroy
	  session[:current_user_id] = nil
	  flash[:notice_logout] = "Déconnection réussie"
	  redirect_to '/'
	end
	def edit
		@publication = Post.find(params[:id])
		render "user/edit", layout: "layout"
	end
	def editform
		@publication = Post.find(params[:id])
		if @publication.update(pub_params)
			flash[:pub_update] = "Post mis à jour avec succès"
			redirect_to '/users/dashboard'
		else
			flash[:pub_update_errors] = @publication.errors.full_messages
  			redirect_to users_edit_path(@publication)
  		end
	end
  def new_publication_confirmation
		@publication = Post.new(pub_params)
		render "user/new_pub_confirm", layout: "layout"
	end
	def new_publication_confirmation_form
		@publication = Post.new(pub_params)
		@publication.user_id = session[:current_user_id]
		if @publication.save
			flash[:pub_success] = "Post publié avec succès"
			redirect_to '/users/dashboard'
		else
			flash[:pub_errors] = @publication.errors.full_messages
			redirect_to '/users/new_publication'
		end
	end
  def profil
		@user = User.find(session[:current_user_id])
		render "user/profil", layout: "layout"
	end
  private

		def user_params
			params.require(:user).permit(:name, :email, :password)
		end

		def login_params
        params.require(:login).permit(:email, :password )
    end

    def pub_params
        params.require(:post).permit(:content)
    end
    def comment_params
        params.require(:commentaire).permit(:content)
    end
end
