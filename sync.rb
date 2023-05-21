# frozen_string_literal: true

require 'git'
require 'fileutils'
require 'yaml'

def move_with_overwrite(src_dir, dest_dir)
	Dir.glob(File.join(src_dir, '**', '*')).each do |src_file|
	  dest_file = File.join(dest_dir, src_file.sub(src_dir + '/', ''))
	  FileUtils.mkdir_p(File.dirname(dest_file))
	  FileUtils.rm(dest_file) if File.exist?(dest_file)
	  FileUtils.mv(src_file, dest_file)
	end
  end

def load_requirements_file(path)	
	# load requirements from file
	reqs = YAML.load_file(path)
	
	reqs.each do |k, v|
		repo = v["repo"]
		src_folder = v["src_folder"]
		dest_folder = v["dest_folder"]
		# clone repo
		if Dir.exists? "#{k}"
			FileUtils.remove_dir "#{k}"
		end
		Git.clone(repo)
		# `git clone --no-checkout #{repo} && cd #{k} && git sparse-checkout init --cone && git sparse-checkout set #{src_folder}`
		# recurse if more addons
		load_requirements_file "#{k}/addons.yaml" if File.exists? "#{k}/addons.yaml"
		# move folder
		FileUtils.mkdir_p "#{dest_folder}" unless Dir.exists? "#{dest_folder}" # make dir if it doesnt already exist
		move_with_overwrite "#{k}/#{src_folder}", "#{dest_folder}/"
		# remove repo
		FileUtils.remove_dir "#{k}"
	end
end

load_requirements_file "addons.yaml"
