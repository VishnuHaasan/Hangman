require 'yaml'
module SAVEFILES
  def save_file
    Dir.mkdir('saves') unless Dir.exist? 'saves'
    flag = true
    while flag
      filename = get_file_name
      if File.exist?("saves/#{filename}.yml")
        puts "A savefile with the samename already exists, do you want to overwrite it?[y/n]"
        char = gets.chomp
        if char == 'y'
          save_overwrite(filename)
          flag = false
        else
          puts "Then,Enter another name: "
        end
      else
        save_the_file(filename)
        flag = false
      end
    end
  end

  def SAVEFILES.showfiles
    arr = Dir.children('saves')
    puts "The savefiles available to load are: "
    arr.each_with_index do |ele,idx|
      puts "#{idx+1}. #{ele}"
    end
  end

  def save_overwrite(filename)
    File.delete("saves/#{filename}.yml")
    save_the_file(filename)
  end
  def save_the_file(filename)
    File.open("saves/#{filename}.yml",'w'){ |file| file.write(get_data.to_yaml)}
  end

  def get_file_name
    puts "Enter the name of the savefile you would like to create: "
    name = gets.chomp.to_s
    return name
  end
  def get_data
    yaml_contents = {
                    'name' => @name,
                    'word' => @word,
                    'available_guesses' => @available_guesses,
                    'chosen_wrong_characters' => @chosen_wrong_characters,
                    'chosen_correct_characters' => @chosen_correct_characters
                    }
    return yaml_contents
  end

  def SAVEFILES.get_load_file_name
    puts "Enter the number of the file you wish to load: "
    n = gets.chomp.to_i
    return Dir.children('saves')[n-1].strip
  end
  def SAVEFILES.load_game
    showfiles
    filename = get_load_file_name
    save_data = YAML.load(File.read("saves/#{filename}"))
    return save_data
  end
  def doit
    load_game
  end
end