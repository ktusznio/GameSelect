require 'rubygems'
require 'dm-core'
require 'dm-types'
require 'dm-migrations'
require 'dm-validations'
require 'game'

# display logger
DataMapper::Logger.new($stdout, :debug)
