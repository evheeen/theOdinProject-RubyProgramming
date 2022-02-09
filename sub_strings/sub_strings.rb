# frozen_string_literal: true

def substrings(text, dictionary)
  answer = Hash.new(0)

  dictionary.each do |word|
    text.chars.each { |text_word| answer[word] += 1 if text_word.downcase[word] }
  end

  answer
end

dictionary = %w[below down go going horn how howdy it i low own part partner sit']

substrings('below', dictionary)
# => {"below"=>1, "low"=>1}

puts substrings("Howdy partner, sit down! How's it going?", dictionary)
# => {"down"=>1, "go"=>1, "going"=>1, "how"=>2, "howdy"=>1, "it"=>2,
#     "i"=>3, "own"=>1, "part"=>1, "partner"=>1, "sit"=>1}
