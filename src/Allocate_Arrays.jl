module Allocate_Arrays

   allocate(xfinal(1:size_x*size_y))

   ! Allocate 2D contiguous arrays x and x0
   allocate(x(0:size_total_x-1,0:size_total_y-1))
   allocate(x0(0:size_total_x-1,0:size_total_y-1))

   ! Allocate coordinates of processes
   allocate(xs(0:nproc-1))
   allocate(xe(0:nproc-1))
   allocate(ys(0:nproc-1))
   allocate(ye(0:nproc-1))

end
