print "Please input a file name:"
name = gets.strip

lines = File::open( name + ".markdown" ).read

i = 0

# lines.each do |line|
while lines.include?("```") 
 	if i.even?
  		lines.sub!( "```", "{% highlight ruby %}" )
  		i += 1
  	else
  		lines.sub!( "```", "{% end highlight %}" )
  		i += 1
  	end
end

p lines

File.open( name + ".markdown", "w") { |file| file << lines }

# 		if i.even?
# 			line = "{% highlight ruby %}"
# 			i += 1
# 		else
# 			line = "{% endhighlight %}"
# 			i += 1
# 		end
# 	end
# end

# p lines

#File.open( name + ".markdown","w" ) do |f|
#	f.write(lines)
#end


