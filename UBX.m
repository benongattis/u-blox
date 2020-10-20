
clc
clear
clear s
 runtime = tic;
 s = serialport("COM7",9600);
 pvtcount=0;
rfcount=0;
satcount=0;

while toc(runtime)<2
clear rf pvt sat
pvtcount=0;
rfcount=0;
satcount=0;
% rf(84600).rawlength = uint16(0);
% pvt(84600).length2=int16(0);
% sat(84600).length=uint16(0);
% for i = 1:86400
% rf(i).rawlength=uint16(0);
% rf(i).version = uint8(0);
% rf(i).blocks = uint8(0);
% rf(i).reserved1=uint8([0,0]);
% rf(i).blockid=uint8([0,0]);
% rf(i).flags=int8([0,0]);
% rf(i).antstatus=uint8([0,0]);
% rf(i).antpower=uint8([0,0]);
% rf(i).poststatus=uint32([0,0]);
% rf(i).reserved2=uint8([0,0]);
% rf(i).reserved3=uint8([0,0]);
% rf(i).reserved4=uint8([0,0]);
% rf(i).reserved5=uint8([0,0]);
% rf(i).noiseperms=uint16([0,0]);
% rf(i).agccnt=uint16([0,0]);
% rf(i).jamind=uint8([0,0]);
% rf(i).ofsi=int8([0,0]);
% rf(i).magi=uint8([0,0]);
% rf(i).ofsq=int8([0,0]);
% rf(i).magq=uint8([0,0]);
% rf(i).reserved6=uint8([0,0]);
% rf(i).reserved7=uint8([0,0]);
% rf(i).reserved8=uint8([0,0]);
% rf(i).cka=uint8(0);
% rf(i).ckb=uint8(0);
% 
% pvt(i).length2=int16(0);
% pvt(i).itow=uint32(0);
% pvt(i).year=uint16(0);
% pvt(i).month=uint8(0);
% pvt(i).day=uint8(0);
% pvt(i).hour=uint8(0);
% pvt(i).min=uint8(0);
% pvt(i).sec=uint8(0);
% pvt(i).valid=uint8(0);
% pvt(i).tacc=uint32(0);
% pvt(i).nano=int32(0);
% pvt(i).fixtype=uint8(0);
% pvt(i).flags1=uint8(0);
% pvt(i).flags2=uint8(0);
% pvt(i).numsv=uint8(0);
% pvt(i).lon=int32(0);
% pvt(i).lat=int32(0);
% pvt(i).height=int32(0);
% pvt(i).hmsl=int32(0);
% pvt(i).hacc=uint32(0);
% pvt(i).vacc=uint32(0);
% pvt(i).veln=int32(0);
% pvt(i).vele=int32(0);
% pvt(i).veld=int32(0);
% pvt(i).gspeed=int32(0);
% pvt(i).headmot=int32(0);
% pvt(i).sacc=uint32(0);
% pvt(i).headacc=uint32(0);
% pvt(i).pdop=uint16(0);
% pvt(i).flags3=uint8(0);
% pvt(i).reserved4=uint8(0);
% pvt(i).reserved5=uint8(0);
% pvt(i).reserved6=uint8(0);
% pvt(i).reserved7=uint8(0);
% pvt(i).reserved8=uint8(0);
% pvt(i).headveh=int32(0);
% pvt(i).magdec=int16(0);
% pvt(i).magacc=uint16(0);
% pvt(i).cka=uint8(0);
% pvt(i).ckb=uint8(0);
% 
% sat(i).length=uint16(0);
% sat(i).itow=uint32(0);
% sat(i).version=uint8(0);
% sat(i).numsat=uint8(0);
% sat(i).reserved1=uint8(0);
% sat(i).reserved2=uint8(0);
% sat(i).gnssid=uint8(zeros(1,75));
% sat(i).satid=uint8(zeros(1,75));
% sat(i).cno=uint8(zeros(1,75));
% sat(i).elev=int8(zeros(1,75));
% sat(i).azim=int16(zeros(1,75));
% sat(i).preres=int16(zeros(1,75));
% sat(i).flags=uint32(zeros(1,75));
% sat(i).cka=uint8(0); 
% sat(i).ckb=uint8(0);
% end

tic
while toc<3600
packetrf(56)= double(zeros);
packetpvt(96)=double(zeros);

header1 = read(s,1,'uint8');
if header1 == 181
    header2 = read(s,1,"uint8");
    if header2 == 98
        class = read(s,1,"uint8");
        
        if class == 10%class name of mon rf            
             id = read(s,1,"uint8");      
             if id == 56%id name of mon rf
                 %this is where mon rf is parsed and stored     
                 packetrf(1)=class;
                 packetrf(2)=id;
                 rfcount = rfcount+1;%counts how many times mon rf has been recorded                 
                 rf(rfcount).rawlength = read(s,1,"uint16"); 
                 packetrf(3:4)=typecast(uint16(rf(rfcount).rawlength),"uint8");
                 rf(rfcount).version = read(s,1,"uint8");
                 packetrf(5) = rf(rfcount).version;
                 rf(rfcount).blocks = read(s,1,"uint8");
                 packetrf(6)=rf(rfcount).blocks;
                 rf(rfcount).reserved1 = read(s,2,"uint8");
                 packetrf(7:8)=rf(rfcount).reserved1;
                 for j = 1:rf(rfcount).blocks
                     rf(rfcount).blockid(j)= read(s,1,"uint8");
                     rf(rfcount).flags(j) = read(s,1,"int8");
                     rf(rfcount).antstatus(j) = read(s,1,"uint8");
                     rf(rfcount).antpower(j) = read(s,1,"uint8");
                     rf(rfcount).poststatus(j) = read(s,1,"uint32");
                     rf(rfcount).reserved2(j) = read(s,1,"uint8");
                     rf(rfcount).reserved3(j) = read(s,1,"uint8");
                     rf(rfcount).reserved4(j) = read(s,1,"uint8");
                     rf(rfcount).reserved5(j) = read(s,1,"uint8");
                     rf(rfcount).noiseperms(j) = read(s,1,"uint16");
                     rf(rfcount).agccnt(j) = read(s,1,"uint16");
                     rf(rfcount).jamind(j) = read(s,1,"uint8");
                     rf(rfcount).ofsi(j) = read(s,1,"int8"); 
                     rf(rfcount).magi(j) = read(s,1,"uint8");
                     rf(rfcount).ofsq(j) = read(s,1,"int8");
                     rf(rfcount).magq(j) = read(s,1,"uint8");
                     rf(rfcount).reserved6(j) = read(s,1,"uint8");
                     rf(rfcount).reserved7(j) = read(s,1,"uint8");
                     rf(rfcount).reserved8(j) = read(s,1,"uint8");
                end %for blocks end
                rf(rfcount).cka = read(s,1,"uint8");
                rf(rfcount).ckb = read(s,1,"uint8");
                packetrf(9)=rf(rfcount).blockid(1);
                packetrf(10)=typecast(int8(rf(rfcount).flags(1)),"uint8");
                packetrf(11)= rf(rfcount).antstatus(1);
                packetrf(12)= rf(rfcount).antpower(1);
                packetrf(13:16)=typecast(uint32(rf(rfcount).poststatus(1)),"uint8");
                packetrf(17)=rf(rfcount).reserved2(1);
                packetrf(18)=rf(rfcount).reserved3(1);
                packetrf(19)=rf(rfcount).reserved4(1);
                packetrf(20)=rf(rfcount).reserved5(1);
                packetrf(21:22)=typecast(uint16(rf(rfcount).noiseperms(1)),"uint8");
                packetrf(23:24)=typecast(uint16(rf(rfcount).agccnt(1)),"uint8");
                packetrf(25) = rf(rfcount).jamind(1);
                packetrf(26)=typecast(int8(rf(rfcount).ofsi(1)),"uint8");
                packetrf(27)=rf(rfcount).magi(1);
                packetrf(28)=typecast(int8(rf(rfcount).ofsq(1)),"uint8");
                packetrf(29)=rf(rfcount).magq(1);
                packetrf(30)=rf(rfcount).reserved6(1);
                packetrf(31)=rf(rfcount).reserved7(1);
                packetrf(32)=rf(rfcount).reserved8(1);
                packetrf(33)=rf(rfcount).blockid(2);
                packetrf(34)=typecast(int8(rf(rfcount).flags(2)),"uint8");
                packetrf(35)= rf(rfcount).antstatus(2);
                packetrf(36)= rf(rfcount).antpower(2);
                packetrf(37:40)=typecast(uint32(rf(rfcount).poststatus(2)),"uint8");
                packetrf(41)=rf(rfcount).reserved2(2);
                packetrf(42)=rf(rfcount).reserved3(2);
                packetrf(43)=rf(rfcount).reserved4(2);
                packetrf(44)=rf(rfcount).reserved5(2);
                packetrf(45:46)=typecast(uint16(rf(rfcount).noiseperms(2)),"uint8");
                packetrf(47:48)=typecast(uint16(rf(rfcount).agccnt(2)),"uint8");
                packetrf(49) = rf(rfcount).jamind(2);
                packetrf(50)=typecast(int8(rf(rfcount).ofsi(2)),"uint8");
                packetrf(51)=rf(rfcount).magi(2);
                packetrf(52)=typecast(int8(rf(rfcount).ofsq(2)),"uint8");
                packetrf(53)=rf(rfcount).magq(2);
                packetrf(54)=rf(rfcount).reserved6(2);
                packetrf(55)=rf(rfcount).reserved7(2);
                packetrf(56)=rf(rfcount).reserved8(2);
        
                 a =0;
                 b =0;
                 for i =1:56 
                   a=a+packetrf(i);
                   b=b+a;  
                   a = a-(floor(a/255)*256);
                    b = b-(floor(b/255)*256);
                 end                 
                   
                 if rf(rfcount).ckb>128 && b~=rf(rfcount).ckb
                     b=b+256;
                 end
                 rf(rfcount).a=a;
                 rf(rfcount).b=b;                
             end %if id endmonrf
        end %if class end
        
        if class == 1%class name of nav 
            id = read(s,1,"uint8");
                        
            if id == 7%id name of nav pvt
                %this is where nav pvt is parsed and stored
                
                pvtcount = pvtcount+1;%allows proper indexing
                packetpvt(1)=class;
                packetpvt(2)=id;
                pvt(pvtcount).length2 = read(s,1,"int16");
                packetpvt(3:4)=typecast(int16(pvt(pvtcount).length2),"uint8");
                pvt(pvtcount).itow = read(s,1,"uint32");
                packetpvt(5:8)=typecast(uint32(pvt(pvtcount).itow),"uint8");
                pvt(pvtcount).year = read(s,1,"uint16");
                packetpvt(9:10)=typecast(uint16(pvt(pvtcount).year),"uint8");
                pvt(pvtcount).month = read(s,1,"uint8");
                packetpvt(11)=pvt(pvtcount).month;
                pvt(pvtcount).day = read(s,1,"uint8");
                packetpvt(12)=pvt(pvtcount).day;
                pvt(pvtcount).hour = read(s,1,"uint8");
                packetpvt(13)=pvt(pvtcount).hour;
                pvt(pvtcount).min = read(s,1,"uint8");
                packetpvt(14)=pvt(pvtcount).min;
                pvt(pvtcount).sec = read(s,1,"uint8");
                packetpvt(15)=pvt(pvtcount).sec;
                pvt(pvtcount).valid = read(s,1,"uint8");
                packetpvt(16)=pvt(pvtcount).valid;
                pvt(pvtcount).tacc = read(s,1,"uint32");
                packetpvt(17:20)=typecast(uint32(pvt(pvtcount).tacc),"uint8");
                pvt(pvtcount).nano = read(s,1,"int32");
                packetpvt(21:24)=typecast(int32(pvt(pvtcount).nano),"uint8");
                pvt(pvtcount).fixtype = read(s,1,"uint8");
                packetpvt(25)=pvt(pvtcount).fixtype;
                pvt(pvtcount).flags1 = read(s,1,"uint8");
                packetpvt(26)=pvt(pvtcount).flags1;
                pvt(pvtcount).flags2 = read(s,1,"uint8");
                packetpvt(27)=pvt(pvtcount).flags2;
                pvt(pvtcount).numsv = read(s,1,"uint8");
                packetpvt(28)=pvt(pvtcount).numsv;
                pvt(pvtcount).lon = read(s,1,"int32");
                packetpvt(29:32)=typecast(int32(pvt(pvtcount).lon),"uint8");
                pvt(pvtcount).lat = read(s,1,"int32");
                packetpvt(33:36)=typecast(int32(pvt(pvtcount).lat),"uint8");
                pvt(pvtcount).height = read(s,1,"int32");
                packetpvt(37:40)=typecast(int32(pvt(pvtcount).height),"uint8");
                pvt(pvtcount).hmsl = read(s,1,"int32");
                packetpvt(41:44)=typecast(int32(pvt(pvtcount).hmsl),"uint8");
                pvt(pvtcount).hacc = read(s,1,"uint32");
                packetpvt(45:48)=typecast(uint32(pvt(pvtcount).hacc),"uint8");
                pvt(pvtcount).vacc = read(s,1,"uint32");
                packetpvt(49:52)=typecast(uint32(pvt(pvtcount).vacc),"uint8");
                pvt(pvtcount).veln = read(s,1,"int32");
                packetpvt(53:56)=typecast(int32(pvt(pvtcount).veln),"uint8");
                pvt(pvtcount).vele = read(s,1,"int32");
                packetpvt(57:60)=typecast(int32(pvt(pvtcount).vele),"uint8");
                pvt(pvtcount).veld = read(s,1,"int32");
                packetpvt(61:64)=typecast(int32(pvt(pvtcount).veld),"uint8");
                pvt(pvtcount).gspeed = read(s,1,"int32");
                packetpvt(65:68)=typecast(int32(pvt(pvtcount).gspeed),"uint8");
                pvt(pvtcount).headmot = read(s,1,"int32");
                packetpvt(69:72)=typecast(int32(pvt(pvtcount).headmot),"uint8");
                pvt(pvtcount).sacc  = read(s,1,"uint32");
                packetpvt(73:76)=typecast(uint32(pvt(pvtcount).sacc),"uint8");
                pvt(pvtcount).headacc = read(s,1,"uint32");
                packetpvt(77:80)=typecast(uint32(pvt(pvtcount).headacc),"uint8");
                pvt(pvtcount).pdop = read(s,1,"uint16");
                packetpvt(81:82)=typecast(uint16(pvt(pvtcount).pdop),"uint8");
                pvt(pvtcount).flags3 = read(s,1,"uint8");
                packetpvt(83)=pvt(pvtcount).flags3;
                pvt(pvtcount).reserved4 = read(s,1,"uint8");
                pvt(pvtcount).reserved5 = read(s,1,"uint8");
                pvt(pvtcount).reserved6 = read(s,1,"uint8");
                pvt(pvtcount).reserved7 = read(s,1,"uint8");
                pvt(pvtcount).reserved8 = read(s,1,"uint8");
                packetpvt(84)=pvt(pvtcount).reserved4;
                packetpvt(85)=pvt(pvtcount).reserved5;
                packetpvt(86)=pvt(pvtcount).reserved6;
                packetpvt(87)=pvt(pvtcount).reserved7;
                packetpvt(88)=pvt(pvtcount).reserved8;
                
                pvt(pvtcount).headveh = read(s,1,"int32");
                packetpvt(89:92)=typecast(int32(pvt(pvtcount).headveh),"uint8");
                pvt(pvtcount).magdec = read(s,1,"int16");
                packetpvt(93:94)=typecast(int16(pvt(pvtcount).magdec),"uint8");
                pvt(pvtcount).magacc = read(s,1,"uint16");
                packetpvt(95:96)=typecast(uint16(pvt(pvtcount).magacc),"uint8");
                pvt(pvtcount).cka = read(s,1,"uint8");
                pvt(pvtcount).ckb = read(s,1,"uint8");
                
                 a =0;
                 b =0;

                 for i =1:96 
                   a=a+packetpvt(i);
                   b=b+a;   
                   a = a-(floor(a/255)*256);
                   b = b-(floor(b/255)*256);
                 end    
                 
                   
                 if pvt(pvtcount).ckb>128 && b~=pvt(pvtcount).ckb
                     b=b+256;
                 end
                 
                 pvt(pvtcount).a=a;
                 pvt(pvtcount).b=b;
                
                
            end %if id end nav pvt
            
            
            if id == 53
                packetsat(1)=class;
                packetsat(2)=id;
                satcount = satcount+1;
                sat(satcount).length = read(s,1,'uint16');
                packetsat(3:4)=typecast(uint16(sat(satcount).length),"uint8");
                sat(satcount).itow = read(s,1,'uint32');
                packetsat(5:8)=typecast(uint32(sat(satcount).itow),"uint8");
                sat(satcount).version = read(s,1,'uint8');
                packetsat(9)= sat(satcount).version;
                sat(satcount).numsat = read(s,1,'uint8');
                packetsat(10)= sat(satcount).numsat;
                sat(satcount).reserved1 = read(s,1,'uint8');
                packetsat(11)= sat(satcount).reserved1;
                sat(satcount).reserved2 = read(s,1,'uint8');
                packetsat(12)= sat(satcount).reserved2;
                for j = 1:sat(satcount).numsat
                    sat(satcount).gnssid(j) = read(s,1,'uint8');
                    sat(satcount).satid(j) = read(s,1,'uint8');
                    sat(satcount).cno(j) = read(s,1,'uint8');
                    sat(satcount).elev(j) = read(s,1,'int8');
                    sat(satcount).azim(j) = read(s,1,'int16');
                    sat(satcount).preres(j) = read(s,1,'int16');
                    sat(satcount).flags(j) = read(s,1,'uint32');
                    
                    packetsat(12+((j-1)*12)+1)=sat(satcount).gnssid(j);
                    packetsat(12+((j-1)*12)+2)=sat(satcount).satid(j);
                    packetsat(12+((j-1)*12)+3)= sat(satcount).cno(j);
                    packetsat(12+((j-1)*12)+4) = typecast(int8(sat(satcount).elev(j)),"uint8");
                    packetsat(12+((j-1)*12)+5:12+((j-1)*12)+6)=typecast(int16(sat(satcount).azim(j)),"uint8");
                    packetsat(12+((j-1)*12)+7:12+((j-1)*12)+8)=typecast(int16(sat(satcount).preres(j)),"uint8");
                    packetsat(12+((j-1)*12)+9:12+((j-1)*12)+12)=typecast(uint32(sat(satcount).flags(j)),"uint8");
                    
                end
                sat(satcount).cka = read(s,1,'uint8');
                sat(satcount).ckb = read(s,1,'uint8');
                 a =0;
                 b =0;
                 for i =1:(12+(sat(satcount).numsat*12))
                   a=a+packetsat(i);
                   b=b+a;   
                  a = a-(floor(a/255)*256);
                   b = b-(floor(b/255)*256);
                 end    
                 
                   
                 if sat(satcount).ckb>128 && b~=sat(satcount).ckb
                    b=b+256;
                 end
                 
                 sat(satcount).a=a;
                 sat(satcount).b=b;
            end%if id end nav sat
            
        end %if class end nav
         
        
    end %if header2 end
end %if header1 end
before = pvtcount-1;

  if pvtcount ~=0 && pvtcount ~=1 && (pvt(pvtcount).day ~= pvt(before).day)
      break
  end
end %end of while loop







datalength = rfcount-1;
clocks = strings(datalength,1);
for i =1:datalength
clocks(i) = pvt(i).hour + ":" + pvt(i).min + ":" + pvt(i).sec;
end
name = "Date_"+num2str(pvt(1).year)+"_"+num2str(pvt(1).month)+"_"+num2str(pvt(1).day)+"_"+num2str(pvt(1).hour)+"_"+num2str(pvt(1).min)+"_"+num2str(pvt(1).sec);
%save(name,'rf','sat','pvt');
name2="Date:"+num2str(pvt(1).year)+"/"+num2str(pvt(1).month)+"/"+num2str(pvt(1).day)+" "+num2str(pvt(1).hour)+":"+num2str(pvt(1).min)+":"+num2str(pvt(1).sec);


%%  Plotting 
figure1 = tiledlayout(3,2);
sgtitle(name2);
%agc
agc=vertcat(rf(1:datalength).agccnt)/81.91;
agc1 = agc(:,1);
agc2 = agc(:,2);
nexttile
plot(agc1,'-o');
xticks([0,floor(datalength/3),floor(2*datalength/3),datalength]);
xticklabels({clocks(1),clocks(floor(datalength/3)),clocks(floor(2*datalength/3)),clocks(datalength)});
ylim([40,80]);
xlim([1,datalength]);
title("AGC")
xlabel("UTC Time");
ylabel("AGC Percent");
hold on
plot(agc2,'-o');
hold off
grid on
legend('High Band','Low Band','Location','southeastoutside');

%cw
cw = vertcat(rf(1:datalength).jamind)/2.55;
cw1 = cw(:,1);
cw2 = cw(:,2);
nexttile
plot(cw1,'-o');
xticks([0,floor(datalength/3),floor(2*datalength/3),datalength]);
xticklabels({clocks(1),clocks(floor(datalength/3)),clocks(floor(2*datalength/3)),clocks(datalength)});
ylim([0,25]);
xlim([1,datalength]);
title("CW Jamming");
xlabel("UTC Time");
ylabel("Jamming Percent");
hold on;
plot(cw2,'-o');
hold off
grid on
legend('High Band','Low Band','Location','southeastoutside');
%latitude
lat = vertcat(pvt.lat)*10^(-7);
nexttile
plot(lat,'-o');
xticks([0,floor(datalength/3),floor(2*datalength/3),datalength]);
xticklabels({clocks(1),clocks(floor(datalength/3)),clocks(floor(2*datalength/3)),clocks(datalength)});
ylim([min(lat),max(lat)]);
xlim([1,datalength]);
title("Latitude");
xlabel("UTC Time");
ylabel("Degrees");
grid on
%longitude
lon = vertcat(pvt.lon)*10^(-7);
nexttile
plot(lon,'-o');
xticks([0,floor(datalength/3),floor(2*datalength/3),datalength]);
xticklabels({clocks(1),clocks(floor(datalength/3)),clocks(floor(2*datalength/3)),clocks(datalength)});
ylim([min(lon),max(lon)]);
xlim([1,datalength]);
title("Longitude");
xlabel("UTC Time");
ylabel("Degrees");
grid on
%height
height = vertcat(pvt.height)/1000;
nexttile;
plot(height,'-o');
xticks([0,floor(datalength/3),floor(2*datalength/3),datalength]);
xticklabels({clocks(1),clocks(floor(datalength/3)),clocks(floor(2*datalength/3)),clocks(datalength)});
ylim([min(height),max(height)]);
xlim([1,datalength]);
title("Meters Above Ellipsoid");
xlabel("UTC Time");
ylabel("Meters");
grid on


%num sats
sv1 = vertcat(sat.numsat);
sv = sv1(1:datalength,1);
gps = zeros(datalength,1);
sbas = zeros(datalength,1);
gal = zeros(datalength,1);
bds = zeros(datalength,1);
qzss = zeros(datalength,1);
glo = zeros(datalength,1);
for i = 1:datalength
    for j= 1:sat(i).numsat
        if sat(i).gnssid(j) == 0
            gps(i) = gps(i) + 1;
        end
        if sat(i).gnssid(j) == 1
            sbas(i) = sbas(i) + 1;
        end
        if sat(i).gnssid(j) == 2
            gal(i) = gal(i) + 1;
        end
        if sat(i).gnssid(j) == 3
            bds(i) = bds(i) + 1;
        end
        if sat(i).gnssid(j) == 5
            qzss(i) = qzss(i) + 1;
        end
        if sat(i).gnssid(j) == 6
            glo(i) = glo(i) + 1;
        end
        
    end      
end
nexttile
plot(sv,'-o');

xticks([0,floor(datalength/3),floor(2*datalength/3),datalength]);
xticklabels({clocks(1),clocks(floor(datalength/3)),clocks(floor(2*datalength/3)),clocks(datalength)});
ylim([0,max(sv)+1]);
xlim([1,datalength]);
title("Number of Satellites Used");
xlabel("UTC Time");
ylabel("#Satellites");
hold on
plot(gps,'-o');
plot(sbas,'-o');
plot(gal,'-o');
plot(bds,'-o');
plot(qzss,'-o');
plot(glo,'-o');
hold off
grid on
legend('Total','GPS','SBAS','Galileo','BeiDou','QZSS','GLONASS', 'Location','southeastoutside');


%cno sats
%num of sats with CNo >50dB-Hz (in green), num of sats with 40 dB-Hz <CNo <=50 dB-Hz (in blue),
%num of sats with 30 dB-Hz <CNo <=40 dB-Hz (in yellow); num of sats with CNo <=30 dB-Hz (in yellow)

% green = zeros(datalength,1);
% blue = zeros(datalength,1);
% yellow = zeros(datalength,1);
% red = zeros(datalength,1);
% 
% for i =1:datalength
%     for j = 1:length(sat(i).cno)
%         cno = sat(i).cno(j);
%         if cno>50
%             green(i)= green(i)+1; 
%         elseif (cno <=50) && (cno > 40)
%             blue(i) = blue(i)+1;
%         elseif (cno <=40) && (cno>30)
%             yellow(i) = yellow(i)+1;
%         else
%             red(i) = red(i)+1;
%         end
%     end
% end
% 
% nexttile
% plot(green,'-o','color','green');
% hold on
% plot(blue,'-o','color','blue')
% plot(yellow,'-o','color','yellow')
% plot(red,'-o','color','red');
% hold off
% xticks([0,floor(datalength/3),floor(2*datalength/3),datalength]);
% xticklabels({clocks(1),clocks(floor(datalength/3)),clocks(floor(2*datalength/3)),clocks(datalength)});
% ylim([0,30]);
% title("# of Satellites in CNO Range");
% xlabel("UTC Time");
% ylabel("# of Satellites");
% legend('>50','50>40','40>30','30>','Location','southeastoutside');
% grid on
% 
% %elev sat
% %num of sats >45deg ele in green; num of sats with ele angle in [15-45] in yellow; 
% %num of sats with ele angle below 15deg in red
% green = zeros(datalength,1);
% yellow = zeros(datalength,1);
% red = zeros(datalength,1);
% 
% for i = 1:datalength
%     for j = 1:length(sat(i).elev)
%         elev = sat(i).elev(j);
%         if elev > 45
%             green(i) = green(i)+1;
%         elseif (elev <=45) && (elev >15)
%             yellow(i)=yellow(i)+1;
%         else 
%             red(i) = red(i)+1;
%         end
%     end
% end
% 
% nexttile
% plot(green,'-o','color','green');
% hold on
% plot(yellow,'-o','color','yellow')
% plot(red,'-o','color','red');
% 
% hold off
% xticks([0,floor(datalength/3),floor(2*datalength/3),datalength]);
% xticklabels({clocks(1),clocks(floor(datalength/3)),clocks(floor(2*datalength/3)),clocks(datalength)});
% ylim([0,40]);
% title("# of Satellites in Degree Range");
% ylabel("# of Satellites");
% xlabel("UTC Time");
% legend('>45','45>15','15>','Location','southeastoutside');
% grid on

% saveas(figure1,name,'fig');
% saveas(figure1,name,'jpg');
end
