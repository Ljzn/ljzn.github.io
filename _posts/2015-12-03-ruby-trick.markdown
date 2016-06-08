---
layout: post
title:  "Ruby小技巧之1～11"
date:   2015-12-03 19:39:02 +0700
categories: [tricks]
---

>来自best-ruby.com

### 数字字母混合进制
{% highlight ruby %}
"1az".next
#=> "1ba"

"1aaz".next
#=> "1aba"
{% endhighlight %}

### 联想数组
{% highlight ruby %}
aa = [ %w[Someone 1],
      %w[Bla 2]]

p aa.assoc("Someone")
p aa.assoc("Bla")

# Result:
# ["Someone", "1"]
# ["Bla", "2"]

p aa.rassoc("1")
p aa.rassoc("2")

# Result:
# ["Someone", "1"]
# ["Bla", "2"]
{% endhighlight %}

### 退出时执行
{% highlight ruby %}
#Basic use
puts 'script start'
at_exit do
  puts 'inside at_exit method for the first time'
end

#anywhere in your code again
at_exit do
  puts 'inside at_exit method for the second time'
end
puts "script end"

#Result:
#script start
#script end
#inside at_exit method for the second time
#inside at_exit method for the first time

#Own exception crash logger
at_exit do
  if $! # If the program exits due to an exception
    puts 'Exiting'

    #you can also print log to a file
    #you can send notification to another app
  end
end

#Logging error anywhere when program exit

(Thread.current[:errors] ||= []) << 'Any error message goes here'
#or
def log_error(error_message)
  (Thread.current[:errors] ||= []) << "#{error_message}"
end

#Now, log all the errors
at_exit do
  File.open('errors.txt', 'a') do |file|
    (Thread.current[:errors] ||= []).each do |error|
      file.puts error
    end
  end
end
{% endhighlight %}

### 自动嵌套
{% highlight ruby %}
deep = Hash.new { |hash,key| hash[key] = Hash.new(&hash.default_proc) }

deep[:a][:b][:c][:d] = 42
p deep

# Result:
# {:a=>{:b=>{:c=>{:d=>42}}}}
{% endhighlight %}

### 块能包块
{% highlight ruby %}
var = :var
object = Object.new

object.define_singleton_method(:show_var_and_block) do |&block|
  p [var, block]
end

object.show_var_and_block { :block }

# Result:
# [:var, #<Proc:0x007ffd6c038128@./blocks_can_take_blocks.rb:8>]
{% endhighlight %}

### 线程冒泡错误提示
{% highlight ruby %}
Thread.abort_on_exception = true

Thread.new do
  fail 'Ops, we cannot continue'
end

loop do
  sleep
end

# Result:
# ./bubbling_up_thread_errors.rb:4:in `block in <main>': Ops, we cannot continue (RuntimeError)
{% endhighlight %}

### 范围情景选择
{% highlight ruby %}
age = rand(1..100)
p age

case age
  when -Float::INFINITY..20
    p 'You are too young'
  when 21..64
    p 'You are at the right age'
  when 65..Float::INFINITY
    p 'You are too old'
end

# Result:
# 55
# "You are at the right age"
{% endhighlight %}

### 罗列所有对象
{% highlight ruby %}
require 'pp'

pp ObjectSpace.count_objects

# Result:
# {:TOTAL=>30163,
#  :FREE=>1007,
#  :T_OBJECT=>39,
#  :T_CLASS=>534,
#  :T_MODULE=>24,
#  :T_FLOAT=>4,
#  :T_STRING=>9290,
#  :T_REGEXP=>70,
#  :T_ARRAY=>2231,
#  :T_HASH=>53,
#  :T_STRUCT=>1,
#  :T_BIGNUM=>2,
#  :T_FILE=>14,
#  :T_DATA=>966,
#  :T_MATCH=>1,
#  :T_COMPLEX=>1,
#  :T_NODE=>15896,
#  :T_ICLASS=>30}
{% endhighlight %}

### 循环
{% highlight ruby %}
ring = %w[one two three].cycle

p ring.take(5)

# Result:
# ["one", "two", "three", "one", "two"]
{% endhighlight %}

### 读出数据
{% highlight ruby %}
puts DATA.read

__END__
Hey oh!
Hey oh!
{% endhighlight %}

### 最简单的数据库
{% highlight ruby %}
require 'pstore'

db = PStore.new('mydatabase.pstore')

db.transaction do
  db['people1'] = 'Someone'
  db['money1'] = 400
end

db.transaction do
  db['people2'] = 'Someone2'
  db['money2'] = 300
end

db.transaction(true) do
  p 'People %p' % db['people1']
  p 'Money %p' % db['money1']
  p "SECOND PERSON"
  p 'People %p' % db['people2']
  p 'Money %p' % db['money2']
end

# Result:
# "People \"Someone\""
# "Money 400"
# "SECOND PERSON"
# "People \"Someone2\""
# "Money 300"
{% endhighlight %}
