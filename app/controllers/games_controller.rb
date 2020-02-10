# frozen_string_literal: true

require 'open-uri'
require 'json'

# controller for the games
class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(8)
  end

  def score
    @attempt = params[:word].upcase
    @letters = params[:letters]
    @answer = if english_word?(@attempt) == false
                "Sorry but #{@attempt} does not seem to be an english word"
              elsif word_exist?(@attempt) == false
                "sorry but #{@attempt} cannot be build out of #{@letters}"
              else
                "Congratulations #{@attempt} is a valid english word!"
              end
  end

  private

  def english_word?(word)
    @result_s = open("https://wagon-dictionary.herokuapp.com/#{word}").read
    @result = JSON.parse(@result_s)
    @result['found']
  end

  def word_exist?(word)
    word.split('').all? do |letter|
      word.count(letter) <= @letters.count(letter)
    end
  end
end
