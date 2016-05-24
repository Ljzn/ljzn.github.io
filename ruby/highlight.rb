print "Please input a file name:"
name = gets.strip

lines = File::open( name + ".markdown" ).read

i = 0

while lines.include?("```") 
 	if i.even?
  		lines.sub!( "```", "{% highlight ruby %}" )
  		i += 1
  	else
  		lines.sub!( "```", "{% endhighlight %}" )
  		i += 1
  	end
end

p lines

File.open( name + ".markdown", "w") { |file| file << lines }



