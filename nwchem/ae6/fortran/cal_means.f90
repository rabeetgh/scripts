program cal_error
      implicit none
        integer :: i
        real::a(7), a_ref, me, mae, sme, smae, ae
        character(len=15) :: atom

        !===================================================================================#
        open(unit=1,file='ae6.list')
        open(unit=2,file='ae6.tex')
        read(1,*); read(1,*); read(1,*)
        write(*,102)
        do i=1, 6
           read(1,*)atom, a, ae, a_ref
           me  = ae-a_ref
           sme = sme + (ae-a_ref)
           mae = abs(ae-a_ref)
           smae = smae + abs(ae-a_ref)
           write(*,101)atom, a, ae, a_ref, me, mae
        end do
        write(*,*)'ME',sme/6.0
        write(*,*)'MAE',smae/6.0

        100 format(A15,2x,'&',1x, 7(F8.5,1x,'&',1x),F8.5,1x,'&',9x,'\\')
        101 format(A15,2x,'&',1x, 10(F12.5,1x,'&',1x),F12.5,'\\')
        102 format('Mole',13x,'&',5x, "E",8x,'&',2x, "1Electron",3x,'&',4x,"Coulomb",3x,'&',5x, "Ex",7x,'&',6x, "Ec",6x,'&',6x,&
        "E_NN",4x,'&',5x, "EA",7x,'&',6x,"AE",6x,'&',4x,"Ref",7x,'&',6x,"DF",6x,'&',8x,"DAF",4x,'\\')

      end program cal_error
