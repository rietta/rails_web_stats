#!/bin/env ruby
# Run Log Analysis for Ruby on Rails Website
# Copyright 2012 Rietta Inc. All Rights Reserved.
# Licensed under the terms of the BSD License.
#
# Assumptions
# ~/logs/
#   production.log
#   http_access_log
#   


require 'rubygems'
#require "active_support/core_ext"

#
#
#
def check_for_and_create_directory(wanted_directory)
  # Check if the analysis directory exists
  unless File.exists?(wanted_directory) && File.directory?(wanted_directory)
    Dir::mkdir wanted_directory
  end
  raise "Could not access or create output directory #{wanted_directory}" unless File.exists?(wanted_directory) && File.directory?(wanted_directory)
  raise "The output directory exists, but this proccess's user doesn't have write permission to #{wanted_directory}" unless File.writable?(wanted_directory)
end # check_for_and_create_directory

#
#
#
def request_log_analyzer(files_to_process)
  if nil == files_to_process || files_to_process.empty?
    puts '# No log files to process'
  else
    files_to_process.each do |a|
      log_cmd = "request-log-analyzer #{a[:input_file]} --silent --output #{a[:format]} --file #{a[:output_file]}"
      puts "Running '#{log_cmd}'"
      exec(log_cmd)
      puts "\n"
    end
  end
end # request_log_analyzer

#
#
#
def analyze_log_directory(directory_path, server_log_name = "httpd_access_log", rails_log_name = "production.log", output_directory_name = "request_analysis")
  
  #
  # Show time, make sure the directories exist
  #
  raise "Log directory #{directory_path} does not exist" unless File.exists?(directory_path) && File.directory?(directory_path)
  
  #
  # Check that the log files exist
  #
  server_log_file_path = File.expand_path(File.join(directory_path, server_log_name))
  rails_log_file_path = File.expand_path(File.join(directory_path, rails_log_name))
  log_count = 0
  log_count += 1 if File.exists?(server_log_file_path) && File.readable?(server_log_file_path)
  log_count += 1 if File.exists?(rails_log_file_path) && File.readable?(rails_log_file_path)
  
  raise "None of the log files were found or readable in #{directory_path}" unless log_count > 0
  
  # Queue up the output directory's parent path
  check_for_and_create_directory(File.join(directory_path, output_directory_name))
  
  # Queue up the output directory
  output_directory_path = File.join(directory_path, output_directory_name, Time.new.year.to_s)
  check_for_and_create_directory(output_directory_path)
  
  month_name = Time.new.strftime("%B").downcase
  output_directory_path = File.join(output_directory_path, month_name)
  check_for_and_create_directory(output_directory_path)
    
  #
  # Run the analyzer
  #
  files_to_process = Array.new
  
  # Web Server Log
  if (File.exists?(server_log_file_path))
    files_to_process.push({
             :input_file => server_log_file_path,
             :output_file => File.expand_path(File.join(output_directory_path, 'web_server_analysis.html')),
             :format => :html
            })
  end
  
  # Rails Log
  if (File.exists?(rails_log_file_path))
    files_to_process.push({
             :input_file => rails_log_file_path,
             :output_file => File.expand_path(File.join(output_directory_path, 'rails_analysis.html')),
             :format => :html
            })
  end
  
  # puts files_to_process.to_json
  request_log_analyzer(files_to_process)
end # analyze_log_directory



####################################
## Command Line Interface
####################################

puts "\n# Arguments #{ARGV.length}\n"
if ARGV.empty?
  log_directory_path = Dir.pwd
elsif ARGV.length == 1
  log_directory_path = ARGV.pop
else
  puts "Usage: analyze_logs log_directory_path"
  exit 0
end

puts "Specified directory #{log_directory_path}"
analyze_log_directory(log_directory_path)

