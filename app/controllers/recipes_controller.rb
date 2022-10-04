class RecipesController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :invalid
    before_action :authorize

    def index
        user = User.find(session[:user_id])
        recipes = user.recipes
        render json: recipes, status: :created
    end

    def create
        user = User.find(session[:user_id])
        recipe = Recipe.new(recipe_params)
        user.recipes << recipe
        recipe.save!
        render json: recipe, status: :created
    end

    private

    def authorize
        render json: { errors: ['Not authorized'] }, status: :unauthorized unless session.include? :user_id
    end
    
    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete, :user_id)
    end

    def invalid(invalid)
        render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end
end
