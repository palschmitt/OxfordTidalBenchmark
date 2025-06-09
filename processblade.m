function [globaldata, bladedata]=processblade(casename,bladeno)
  Origin=[10 4.246 6.1]
  radius=0.8
  #hack to extract position and forces from vtk file
  cmd=['head -n 49 ',casename,'/postProcessing/actuatorLines/0/VTK/turbine.blade',bladeno,'_000000000099.vtk  | tail -n 44 > positions.txt']
  system(cmd)
  pos=load('positions.txt');
  cmd=['head -n 145 ',casename,'/postProcessing/actuatorLines/0/VTK/turbine.blade',bladeno,'_000000000099.vtk  | tail -n 44 > forces.txt']
  system(cmd)
  forces=load('forces.txt');
  #Correct for density
  forces=forces*1000;


  #Calculate section length, mid section distance from origin and force/length in matrix_type
  #Correct Offset
  pos=pos-Origin;
  sectionlength=diff(pos);
  sectiondist=vecnorm((pos(1:end-1,:)+0.5*sectionlength),2,2);
  sectiondistnormed=sectiondist/radius;
  #Evaluate roation angle
  phi=vectorAngle([0 1],pos(end,1:3)(2:3))
  #Interpolate forces to midsection
  sectionforces=(forces(1:end-1,:)+0.5*diff(forces))
  #Global Moment is force cross hubdistance vector
  globalmoment=sum(cross(sectionforces,pos(1:end-1,:)+0.5*sectionlength));
  globalforces=sum(forces);
  #Correct for axis names
  globaldata=[globalforces(:,1) globalforces(:,3) globalforces(:,2)  globalmoment(:,1) globalmoment(:,3) globalmoment(:,2)]
  #divide by section length
  sectionforcespermeter=sectionforces./vecnorm(sectionlength,2,2);
  #Transform forces to tangential and radial component
  transformedsectionforces=transformVector(sectionforces(:,2:3),[[cos(phi) sin(phi)];[-sin(phi) cos(phi)]])
  transformedsectionforcespermeter=transformVector(sectionforcespermeter(:,2:3),[[cos(phi) sin(phi)];[-sin(phi) cos(phi)]])
  #evaluate section moment

  bladeforces=[sectionforcespermeter(:,1) transformedsectionforcespermeter(:,1) transformedsectionforcespermeter(:,2)]
  blademoment=[bladeforces(:,2).*sectiondist bladeforces(:,1).*sectiondist bladeforces(:,3).*sectiondist]
  bladedata=[sectiondistnormed bladeforces blademoment]
  endfunction
