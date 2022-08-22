class GamesController < ApplicationController
  require "json"
  require "open-uri"

  def new
    alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    @letters = []
    10.times do
      rand_letter = alphabet.sample
      @letters.push(rand_letter)
    end
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    word_info_serialized = URI.open(url).read
    word_info = JSON.parse(word_info_serialized)
    valid = word_info['found']
    if valid && letters_included?(@letters, @word)
      @result = "Congratulations! #{@word} is a valid English word"
    elsif !valid && letters_included?(@letters, @word)
      @result = "Sorry but #{@word} does not appear to be a valid English word..."
    else
      @result = "Sorry but #{@word} can't be built out of #{@letters}"
    end
  end

  private

  def letters_included?(letters, word)
    word.upcase.chars.all? { |letter| letters.count(letter) >= word.upcase.count(letter) }
  end
end
