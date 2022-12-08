C-----------------------------------------------------------------------
C  nek5000 user-file template
C
C  user specified routines:
C     - userbc : boundary conditions
C     - useric : initial conditions
C     - uservp : variable properties
C     - userf  : local acceleration term for fluid
C     - userq  : local source term for scalars
C     - userchk: general purpose routine for checking errors etc.
C
C-----------------------------------------------------------------------
      subroutine uservp(ix,iy,iz,eg) ! set variable properties
      include 'SIZE'
      include 'TOTAL'
      include 'NEKUSE'

      return
      end
c-----------------------------------------------------------------------
      subroutine userf(ix,iy,iz,eg) ! set acceleration term
c
c     Note: this is an acceleration term, NOT a force!
c     Thus, ffx will subsequently be multiplied by rho(x,t).
c
      include 'SIZE'
      include 'TOTAL'
      include 'NEKUSE'

      ffx=0.
      ffy=0.
      ffz=0.

      return
      end
c-----------------------------------------------------------------------
      subroutine userq(ix,iy,iz,eg) ! set source term
      include 'SIZE'
      include 'TOTAL'
      include 'NEKUSE'

      qvol   = 0.0
      source = 0.0

      return
      end
c-----------------------------------------------------------------------
      subroutine userbc(ix,iy,iz,f,eg) ! set up boundary conditions

c     NOTE: This routine may or may not be called by every processor

      include 'SIZE'
      include 'TOTAL'
      include 'NEKUSE'

      return
      end
c-----------------------------------------------------------------------
      subroutine useric(ix,iy,iz,eg) ! set up initial conditions
      include 'SIZE'
      include 'TOTAL'
      include 'NEKUSE'

      integer e,eg

      ux   = sin(x)*cos(y)*cos(z)
      uy   = -cos(x)*sin(y)*cos(z)
      uz   = 0.0

      return
      end
c-----------------------------------------------------------------------
      subroutine userchk
      include 'SIZE'
      include 'TOTAL'

      integer ntot
      common /SCRNS/ w1 (lx1*ly1*lz1*lelv),
     &               w2 (lx1*ly1*lz1*lelv),
     &               omg(lx1*ly1*lz1*lelv,ldim)

      character*80 fnames(3)
      character*128 file_name
      logical exist
      real w1, w2, omg
      real sum_e1, sum_e2, vv, oo, e1, e2
      real period_save, t_last_save
      save t_last_save

      period_save = real(UPARAM(2))

      file_name = 'spatial_mean.csv'

      if (istep.eq.0) then
         inquire(file=file_name, exist=exist)   
         if (.not. exist) then
            if (nid.eq.0) then
               open(10, File=file_name, position='append')
               write(10,*) '# Time, Energy, Enstrophy'
               close(10)
            endif
          endif
      endif

      if (istep.eq.0) then
         ntot=nx1*ny1*nz1*nelv   
         t_last_save = time
      endif

c      if (.false.) then
c         call blank(fnames,size(fnames)*80)
c         fnames(1) ='rs6tgv0.f00001'
c         fnames(2) ='rs6tgv0.f00002'
c         fnames(3) ='rs6tgv0.f00003'
c         call full_restart(fnames,3) ! replace istep=0,1,..
c      endif
c
c      iostep_full = iostep
c      call full_restart_save(iostep_full)
     
      if ((floor(time/period_save)).gt.(floor(t_last_save/
     &period_save))) then
      
         t_last_save = time
      
         sum_e1 = 0.
         sum_e2 = 0.
         call curl(omg,vx,vy,vz,.false.,w1,w2)
         do i = 1,ntot
            vv = vx(i,1,1,1)**2 + vy(i,1,1,1)**2 + vz(i,1,1,1)**2
            oo = omg(i,1)**2 + omg(i,2)**2 + omg(i,3)**2
            sum_e1 = sum_e1 + vv*bm1(i,1,1,1)
            sum_e2 = sum_e2 + oo*bm1(i,1,1,1)
         enddo
         e1 = 0.5 * glsum(sum_e1,1) / volvm1
         e2 = 0.5 * glsum(sum_e2,1) / volvm1
         if (nid.eq.0) then
            write(6,2) time, e1, e2
  2         format(1p3e13.4,' monitor')
  
            open(10, File=file_name, position='append')
            write(10,'(F22.15,A,F22.15,A,F22.15)') time,',',e1,',',e2
            close(10)
         endif
      endif

      return
      end
c-----------------------------------------------------------------------
      subroutine usrdat()   ! This routine to modify element vertices
      include 'SIZE'
      include 'TOTAL'

      return
      end
c-----------------------------------------------------------------------
      subroutine usrdat2()  ! This routine to modify mesh coordinates
      include 'SIZE'
      include 'TOTAL'

      return
      end
c-----------------------------------------------------------------------
      subroutine usrdat3()
      include 'SIZE'
      include 'TOTAL'

      return
      end
c-----------------------------------------------------------------------
