# frozen_string_literal: true

class GraphqlController < ApplicationController
  # protect_from_forgery with: :null_session # opcjonalnie, jeśli masz CSRF

  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    result = BudgetBuddySchema.execute(
      query,
      variables: variables,
      context: {
        current_user: current_user_from_token
      },
      operation_name: operation_name
    )
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?
    handle_error_in_development(e)
  end

  private

  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [ { message: e.message, backtrace: e.backtrace } ], data: {} }, status: 500
  end

  def current_user_from_token
    token = request.headers["Authorization"]&.split(" ")&.last
    return nil if token.blank?

    decoded = JsonWebToken.decode(token)
    User.find_by(id: decoded[:user_id]) if decoded
  rescue
    nil
  end
end
