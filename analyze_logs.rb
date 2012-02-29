#!/bin/env ruby
# Run Log Analysis for Ruby on Rails Website
#
# Assumptions
# ~/logs/
#   production.log
#   http_access_log
#   

def check_for_and_create_directory(wanted_directory)
  # Check if the analysis directory exists
  unless File.exists?(wanted_directory) && File.directory?(wanted_directory)
    Dir::mkdir(wanted_directory)
  end
  raise "Could not access or create output directory #{wanted_directory}" unless File.exists?(wanted_directory) && File.directory?(wanted_directory)
  raise "The output directory exists, but this proccess's user doesn't have write permission to #{wanted_directory}" unless File.writable?(wanted_directory)
end # check_for_and_create_directory

def analyze_log_directory(directory_path, server_log_name = "httpd_access_log", rails_log_name = "production.log", output_directory_name = "request_analysis")
  
  #
  # Show time, make sure the directories exist
  #
  raise "Log directory #{directory_path} does not exist" unless File.exists?(directory_path) && File.directory?(directory_path)
   
  # Queue up the output directory's parent path
  check_for_and_create_directory(File.join(directory_path, output_directory_name))
  
  # Queue up the output directory
  output_directory_path = File.join(directory_path, output_directory_name, Time.new.year
  check_and_queue_up_directories(output_directory_path)
  
  month_name = Time.new.strftime("%B").downcase
  output_directory_path = File.join(output_directory_path, month_name)
  check_and_queue_up_directories(output_directory_path)
  
  #
  # Queue up the year directory
  # 
  
  #
  # Run the analyzer
  #
  
end # analyze_log_folder