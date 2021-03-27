require './savefiles.rb'

class Game
  include SAVEFILES
  def initialize(name,available_guesses = 10,word = String.new,chosen_correct_characters = Array.new(12,'_'),chosen_wrong_characters = Array.new)
    @name = name
    @available_guesses = available_guesses
    @word = word
    @chosen_wrong_characters = chosen_wrong_characters
    @chosen_correct_characters = chosen_correct_characters
  end

  def get_random_word
    word = String.new
    flag = true
    file = File.open('5desk.txt','r')
    contents = file.readlines
    while flag do
      random_number = rand(0..contents.length-1)
      word = contents[random_number].strip()
      if word.length>4 && word.length<13
        flag = false
      else  
        flag = true
      end
    end
    return word
  end
  def get_cleansed_input
    flag = true
    while flag
      word = gets.chomp.to_s
      if word.length>1
        flag = true
        puts "Enter a single letter!!!"
      elsif word.length<1
        flag = true
        puts "Enter a letter!!!"
      else
        flag = false
      end
    end
    return word.downcase
  end
  def get_user_guess
    puts "Enter your desired guess: "
    guessed_letter = get_cleansed_input
    guessed_correct = false
    if @word.include? guessed_letter
      for i in 0..@word.length-1
        if @word[i]==guessed_letter && @chosen_correct_characters[i] == '_'
          guessed_correct = true
          @chosen_correct_characters[i] = guessed_letter
          return guessed_correct
        end
      end
    else
      @available_guesses -= 1
      @chosen_wrong_characters.push(guessed_letter) unless @chosen_wrong_characters.include? guessed_letter
    end
    return guessed_correct
  end
  def print_custom
    s = String.new
    for i in 0..@word.length-1
      s += "#{@chosen_correct_characters[i]} "
    end
    return s.strip
  end
  def print_result(res)
    if res
      puts "Your choice is correct, the resulting string is #{print_custom}"
    else
      puts "Your choice is incorrect, the resulting string is #{print_custom}"
    end
    puts "Your remaining wrong chances are : #{@available_guesses}"
    if @chosen_wrong_characters.empty?
      puts "You havent chosen any letter wrong"
    else
      puts "The wrong letters you have chosen are : #{@chosen_wrong_characters.join(" ")}"
    end  
  end

  def save_check
    save_performed = false
    puts "Do you want to save the file?[y/n]"
    char = gets.chomp.to_s
    if char == 'y'
      save_file
      save_performed = true
    end
    return save_performed
  end

  def equality_check
    return @word == @chosen_correct_characters[0..@word.length-1].join('')
  end
  def game_end
    return @available_guesses==0 || equality_check
  end
  def start
    @word = get_random_word.downcase if @word == String.new
    until game_end 
      print_result(get_user_guess)
      unless game_end
        kek = save_check
        puts "Save successful" if kek
      end
    end
    if equality_check
      puts "You have won congratulations"
    else
      puts "You lost loser"
    end
  end
end
