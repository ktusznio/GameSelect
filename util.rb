
def import_from_file(filename)
  f = File.new(filename)

  while (name = f.gets)
    g = Game.new(:name => name)
    g.save
  end
end
