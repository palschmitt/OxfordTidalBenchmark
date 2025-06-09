#Read vtk and csv files and write submission data for Oxford Benchmark Cases
clear all
close all
pkg load matgeom

#Find all relevant cases
basecase=glob('?\.??') #basemesh

lambdas=str2num(cell2mat(basecase))
#finecase=glob('?\.??fine') #finemesh

Globaldata=zeros(length(basecase), 8)
for i=1:length(basecase)
  casename=basecase{i}
  [b1globaldata, b1bladedata]=processblade(casename,'1');
  [b2globaldata, b2bladedata]=processblade(casename,'2');
  [b3globaldata, b2bladedata]=processblade(casename,'3');
  #Extract global Power and Drag coefficient on turbine
  cmd=['grep Power   ',casename,'/log.potentialFreeSurfaceFoamsrc | cut -d " " -f 5 | tail -n 100 > cp.txt']
  system(cmd)
  cp=load('cp.txt');
  cmd=['grep drag   ',casename,'/log.potentialFreeSurfaceFoamsrc | cut -d " " -f 6 | tail -n 100 > ct.txt']
  system(cmd)
  ct=load('ct.txt');
  #Assemble global force and moments and coefficients
  Globaldata(i,:) =[b1globaldata+b2globaldata+b3globaldata mean(ct) mean(cp)];
endfor



#####Repeat with fine mesh
finecase=glob('?\.??fine') #finemesh
Globaldatafine=zeros(length(finecase), 9)
for i=1:length(finecase)
  casename=finecase{i}
  [b1globaldata, b1bladedata]=processblade(casename,'1');
  [b2globaldata, b2bladedata]=processblade(casename,'2');
  [b3globaldata, b3bladedata]=processblade(casename,'2');
  #Extract global Power and Drag coefficient on turbine
  cmd=['grep Power   ',casename,'/log.potentialFreeSurfaceFoamsrc | cut -d " " -f 5 | tail -n 100 > cp.txt']
  system(cmd)
  cp=load('cp.txt');
  cmd=['grep drag   ',casename,'/log.potentialFreeSurfaceFoamsrc | cut -d " " -f 6 | tail -n 100 > ct.txt']
  system(cmd)
  ct=load('ct.txt');
  #Assemble global force and moments and coefficients
  Globaldatafine(i,:) =[i b1globaldata+b2globaldata+b3globaldata mean(ct) mean(cp)];
  #Write into correct files
  dlmwrite (["./DataSubmission/QUBMRG/ALFEA/Low_Turbulence_Cases/forcemoment_dists_clean_0",num2str(i,"%02.0f") ,".txt"],b1bladedata ,"precision","%.3f", "delimiter", "\t ", "newline", "\n")

endfor
dlmwrite (["./DataSubmission/QUBMRG/ALFEA/Low_Turbulence_Cases/integrated_vars.txt"],Globaldatafine ,"precision","%.3g", "delimiter", "\t ", "newline", "\n")

##Hub test
hubcase=glob('?\.??hub') #hub AL
Globaldatahub=zeros(length(hubcase), 8)
for i=1:length(hubcase)
  casename=hubcase{i}
  [b1globaldata, b1bladedata]=processblade(casename,'1');
  [b2globaldata, b2bladedata]=processblade(casename,'2');
  [b3globaldata, b3bladedata]=processblade(casename,'2');
  #Extract global Power and Drag coefficient on turbine
  cmd=['grep Power   ',casename,'/log.potentialFreeSurfaceFoamsrc | cut -d " " -f 5 | tail -n 100 > cp.txt']
  system(cmd)
  cp=load('cp.txt');
  cmd=['grep drag   ',casename,'/log.potentialFreeSurfaceFoamsrc | cut -d " " -f 6 | tail -n 100 > ct.txt']
  system(cmd)
  ct=load('ct.txt');
  #Assemble global force and moments and coefficients
  Globaldatahub(i,:) =[b1globaldata+b2globaldata+b3globaldata mean(ct) mean(cp)];
endfor


#Control plots
figure
plot(lambdas,Globaldata(:,end))
hold on
plot(lambdas,Globaldatafine(:,end))
plot(lambdas,Globaldatahub(:,end))
ylabel('C_p')
xlabel('\lambda')
legend('Orig','Fine','Hub')
figure
plot(lambdas,Globaldata(:,end-1))
hold on
plot(lambdas,Globaldatafine(:,end-1))
plot(lambdas,Globaldatahub(:,end-1))
ylabel('C_t')
xlabel('\lambda')
legend('Orig','Fine','Hub')
