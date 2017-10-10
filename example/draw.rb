require "vips"

a = Vips::Image.new_from_file "/home/john/pics/k2.jpg"

n_lines = 1000

a = a.destructive do |image|
    n_lines.times do |i|
        image.draw_line 255, 
            i * image.width.fdiv(n_lines), image.height,
            0, i * image.height.fdiv(n_lines)
    end
end

a.write_to_file "x.jpg"
