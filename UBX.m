
 %% Setup
 %set serialport com to port ublox is hooked up to - line 18
 %ublox should be outputting mon-rf, nav-pvt, nav-sat, nav-sig, navclock,
 %navtimebds, navtimegal,namtimeglo,navtimegps
 %set while loops to desired runtime: true for both is infinite, 24 hour
 %saving and recording
 
 %% IMPORTANT
 %When runnig for first time after pluggin ublox in, let the ublox warm up
 %while plugged in for at least two minutes, otherwise program will fail after
 %a couple minutes
 %if program does fail after a couple minutes, just restart- it will run
 %normally
 %% Recording
clc
clear
clear s
runtime = tic;
s = serialport("COM3",115200);% set to com port ublox is connected to
fprintf('A MON-RF, NAV-PVT, NAV-SAT, and NAV-SIG message should display once a minute. \n');
fprintf('Check to make sure all four messages display after 1 minute: otherwise one could be disabled in Ucenter \n \n');
%while loop that loops every 24 hours- has plotting at the end
while true %toc(runtime)< less than total runtime  true is infinte
%data is cleared for next 24 hours
clearvars -except s

%keeps track of how many times each message was received
pvtcount=0;
rfcount=0;
satcount=0;
sigcount=0;
bdscount = 0;
glocount = 0;
gpscount = 0;
clockcount = 0;
galcount = 0;
beforerf = 0;
beforepvt = 0;
beforesat = 0;
beforesig = 0;
%allocating for each message
allocationamount = 86400;
rf(allocationamount).rawlength = uint16(0);
pvt(allocationamount).length2=int16(0);
sat(allocationamount).length=uint16(0);
sig(allocationamount).length = uint16(0);
navclock(allocationamount).length = uint16(0);
bdstime(allocationamount).length = uint16(0);
glotime(allocationamount).length = uint16(0);
gpstime(allocationamount).length = uint16(0);
galtime(allocationamount).length = uint16(0);
for i = 1:allocationamount
rf(i).rawlength=uint16(0);
rf(i).version = uint8(0);
rf(i).blocks = uint8(0);
rf(i).reserved1=uint8([0,0]);
rf(i).blockid=uint8([0,0]);
rf(i).flags=int8([0,0]);
rf(i).antstatus=uint8([0,0]);
rf(i).antpower=uint8([0,0]);
rf(i).poststatus=uint32([0,0]);
rf(i).reserved2=uint8([0,0]);
rf(i).reserved3=uint8([0,0]);
rf(i).reserved4=uint8([0,0]);
rf(i).reserved5=uint8([0,0]);
rf(i).noiseperms=uint16([0,0]);
rf(i).agccnt=uint16([0,0]);
rf(i).jamind=uint8([0,0]);
rf(i).ofsi=int8([0,0]);
rf(i).magi=uint8([0,0]);
rf(i).ofsq=int8([0,0]);
rf(i).magq=uint8([0,0]);
rf(i).reserved6=uint8([0,0]);
rf(i).reserved7=uint8([0,0]);
rf(i).reserved8=uint8([0,0]);
rf(i).cka=uint8(0);
rf(i).ckb=uint8(0);

pvt(i).length2=int16(0);
pvt(i).itow=uint32(0);
pvt(i).year=uint16(0);
pvt(i).month=uint8(0);
pvt(i).day=uint8(0);
pvt(i).hour=uint8(0);
pvt(i).min=uint8(0);
pvt(i).sec=uint8(0);
pvt(i).valid=uint8(0);
pvt(i).tacc=uint32(0);
pvt(i).nano=int32(0);
pvt(i).fixtype=uint8(0);
pvt(i).flags1=uint8(0);
pvt(i).flags2=uint8(0);
pvt(i).numsv=uint8(0);
pvt(i).lon=int32(0);
pvt(i).lat=int32(0);
pvt(i).height=int32(0);
pvt(i).hmsl=int32(0);
pvt(i).hacc=uint32(0);
pvt(i).vacc=uint32(0);
pvt(i).veln=int32(0);
pvt(i).vele=int32(0);
pvt(i).veld=int32(0);
pvt(i).gspeed=int32(0);
pvt(i).headmot=int32(0);
pvt(i).sacc=uint32(0);
pvt(i).headacc=uint32(0);
pvt(i).pdop=uint16(0);
pvt(i).flags3=uint8(0);
pvt(i).reserved4=uint8(0);
pvt(i).reserved5=uint8(0);
pvt(i).reserved6=uint8(0);
pvt(i).reserved7=uint8(0);
pvt(i).reserved8=uint8(0);
pvt(i).headveh=int32(0);
pvt(i).magdec=int16(0);
pvt(i).magacc=uint16(0);
pvt(i).cka=uint8(0);
pvt(i).ckb=uint8(0);
pvt(i).clocks = 0;

sat(i).length=uint16(0);
sat(i).itow=uint32(0);
sat(i).version=uint8(0);
sat(i).numsat=uint8(0);
sat(i).reserved1=uint8(0);
sat(i).reserved2=uint8(0);
sat(i).gnssid=uint8(zeros(1,75));
sat(i).satid=uint8(zeros(1,75));
sat(i).cno=uint8(zeros(1,75));
sat(i).elev=int8(zeros(1,75));
sat(i).azim=int16(zeros(1,75));
sat(i).preres=int16(zeros(1,75));
sat(i).flags=uint32(zeros(1,75));
sat(i).cka=uint8(0); 
sat(i).ckb=uint8(0);

sig(i).length = uint16(0);
sig(i).itow = uint32(0);
sig(i).version = uint8(0);
sig(i).numsigs = uint8(0);
sig(i).reserved1 = uint16(0);
sig(i).gnssid = uint8(zeros(1,150));
sig(i).svid = uint8(zeros(1,150));
sig(i).sigid = uint8(zeros(1,150));
sig(i).freqid = uint8(zeros(1,150));
sig(i).prres = int16(zeros(1,150));
sig(i).cno = uint8(zeros(1,150));
sig(i).qual = uint8(zeros(1,150));
sig(i).corsour = uint8(zeros(1,150));
sig(i).ionmod = uint8(zeros(1,150));
sig(i).flags = uint16(zeros(1,150));
sig(i).reserved2 = uint32(zeros(1,150));
sig(i).cka = uint8(0);
sig(i).a = uint8(0);
sig(i).ckb = uint8(0);
sig(i).b = uint8(0);

navclock(i).length = uint16(0);
navclock(i).itow = uint32(0);
navclock(i).bias = int32(0);
navclock(i).drift = int32(0);
navclock(i).timeaccuracy = uint32(0);
navclock(i).frequencyaccuracy = uint32(0);
navclock(i).cka = uint8(0);
navclock(i).ckb = uint8(0);
navclock(i).a = uint8(0);
navclock(i).b = uint8(0);

bdstime(i).length = uint16(0);
bdstime(i).itow = uint32(0);
bdstime(i).bdstow = uint32(0);
bdstime(i).ftow = int32(0);
bdstime(i).week = int16(0);
bdstime(i).leaps = int8(0);
bdstime(i).flags = uint8(0);
bdstime(i).timeaccuracy = uint32(0);
bdstime(i).cka = uint8(0);
bdstime(i).ckb = uint8(0);
bdstime(i).a = uint8(0);
bdstime(i).b = uint8(0);

galtime(i).length = uint16(0);
galtime(i).itow = uint32(0);
galtime(i).galtow = uint32(0);
galtime(i).ftow = int32(0);
galtime(i).week = int16(0);
galtime(i).leaps = int8(0);
galtime(i).flags = uint8(0);
galtime(i).timeaccuracy = uint32(0);
galtime(i).cka = uint8(0);
galtime(i).ckb = uint8(0);
galtime(i).a = uint8(0);
galtime(i).b = uint8(0);

glotime(i).length = uint16(0);
glotime(i).itow = uint32(0);
glotime(i).tod = uint32(0);
glotime(i).ftod = int32(0);
glotime(i).days = uint16(0);
glotime(i).years = uint8(0);
glotime(i).flags = uint8(0);
glotime(i).timeaccuracy = uint32(0);
glotime(i).cka = uint8(0);
glotime(i).ckb = uint8(0);
glotime(i).a = uint8(0);
glotime(i).b = uint8(0);

gpstime(i).length = uint16(0);
gpstime(i).itow = uint32(0);
gpstime(i).ftow = int32(0);
gpstime(i).week = int16(0);
gpstime(i).leaps = int8(0);
gpstime(i).flags = uint8(0);
gpstime(i).timeaccuracy = uint32(0);
gpstime(i).cka = uint8(0);
gpstime(i).ckb = uint8(0);
gpstime(i).a = uint8(0);
gpstime(i).b = uint8(0);


end
%while loop for data receiving- breaks at end utc day boundary
tic
while true %toc<(saving and plotting interval)  true is 24 hours
    
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
                
                %packet is used for checksum
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
                   %chekcsum calculations
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
             end %if id end  monrf
        end %if class end
        
        if class == 1%class name of nav 
            id = read(s,1,"uint8");
            
            if id == 34 %id of nav-clock
                clockcount = clockcount + 1;
                
                navclock(clockcount).length = read(s,1,"uint16");
                navclock(clockcount).itow = read(s,1,"uint32");
                navclock(clockcount).bias = read(s,1,"int32");
                navclock(clockcount).drift = read(s,1,"int32");
                navclock(clockcount).timeaccuracy = read(s,1,"uint32");
                navclock(clockcount).frequencyaccuracy = read(s,1,"uint32");
                navclock(clockcount).cka = read(s,1,"uint8");
                navclock(clockcount).ckb = read(s,1,"uint8");
                packetclock(1) = class;
                packetclock(2) = id;
                packetclock(3:4) = typecast(uint16(navclock(clockcount).length),"uint8");
                packetclock(5:8) = typecast(uint32(navclock(clockcount).itow),"uint8");
                packetclock(9:12) = typecast(int32(navclock(clockcount).bias),"uint8");
                packetclock(13:16) = typecast(int32(navclock(clockcount).drift),"uint8");
                packetclock(17:20) = typecast(uint32(navclock(clockcount).timeaccuracy),"uint8");
                packetclock(21:24) = typecast(uint32(navclock(clockcount).frequencyaccuracy),"uint8");
               
                
                a =0;
                b =0;
                for i = 1:24
                a=a+packetclock(i);
                b=b+a;  
                a = a-(floor(a/255)*256);
                b = b-(floor(b/255)*256);
                end                 

                if navclock(clockcount).ckb>128 && b~= navclock(clockcount).ckb
                 b=b+256;
                end
                navclock(clockcount).a=a;
                navclock(clockcount).b=b;            
            end
            
            if id == 36 %time bds
                bdscount = bdscount +1;
                bdstime(bdscount).length = read(s,1,"uint16");
                bdstime(bdscount).itow = read(s,1,"uint32");
                bdstime(bdscount).bdstow = read(s,1,"uint32");
                bdstime(bdscount).ftow = read(s,1,"int32");
                bdstime(bdscount).week = read(s,1,"int16");
                bdstime(bdscount).leaps = read(s,1,"int8");
                bdstime(bdscount).flags = read(s,1,"uint8");
                bdstime(bdscount).timeaccuracy = read(s,1,"uint32");
                bdstime(bdscount).cka = read(s,1,"uint8");
                bdstime(bdscount).ckb = read(s,1,"uint8");
                
            end
            
            if id == 37
                galcount = galcount+1;
                galtime(galcount).length = read(s,1,"uint16");
                galtime(galcount).itow = read(s,1,"uint32");
                galtime(galcount).galtow = read(s,1,"uint32");
                galtime(galcount).ftow = read(s,1,"int32");
                galtime(galcount).week = read(s,1,"int16");
                galtime(galcount).leaps = read(s,1,"int8");
                galtime(galcount).flags = read(s,1,"uint8");
                galtime(galcount).timeaccuracy = read(s,1,"uint32");
                galtime(galcount).cka = read(s,1,"uint8");
                galtime(galcount).ckb = read(s,1,"uint8");
            end
            
            if id == 35
                glocount = glocount+1;
                glotime(glocount).length = read(s,1,"uint16");
                glotime(glocount).itow = read(s,1,"uint32");
                glotime(glocount).tod = read(s,1,"uint32");
                glotime(glocount).ftod = read(s,1,"int32");
                glotime(glocount).days = read(s,1,"uint16");
                glotime(glocount).years = read(s,1,"uint8");
                glotime(glocount).flags = read(s,1,"uint8");
                glotime(glocount).timeaccuracy = read(s,1,"uint32");
                glotime(glocount).cka = read(s,1,"uint8");
                glotime(glocount).ckb = read(s,1,"uint8");
            end
            
            if id == 32
                gpscount = gpscount+1;
                gpstime(gpscount).length = read(s,1,"uint16");
                gpstime(gpscount).itow = read(s,1,"uint32");
                gpstime(gpscount).ftow = read(s,1,"int32");
                gpstime(gpscount).week = read(s,1,"int16");
                gpstime(gpscount).leaps = read(s,1,"int8");
                gpstime(gpscount).flags = read(s,1,"uint8");
                gpstime(gpscount).timeaccuracy = read(s,1,"uint32");
                gpstime(gpscount).cka = read(s,1,"uint8");
                gpstime(gpscount).ckb = read(s,1,"uint8");
            end
            
            
            
            
            
            
            
            
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
                x=clock;
                systime1(pvtcount,1) = x(6);
                systime2(pvtcount,1) = x(5);
                pvt(pvtcount).clocks = x(5:6);
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
                
                
                %checksum calculations
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
            
            
            if id == 53 %nav-sat is parsed and stored here
                
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
                
                %checksum calculations
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
            
            if id == 67 %nav-sig is parsed and stored
                sigcount = sigcount+1;
                packetsig(1) = class;
                packetsig(2) = id;
                
                sig(sigcount).length = read(s,1,'uint16');
                packetsig(3:4)=typecast(uint16(sig(sigcount).length),"uint8");
                sig(sigcount).itow = read(s,1,'uint32');
                packetsig(5:8)=typecast(uint32(sig(sigcount).itow),"uint8");
                sig(sigcount).version =read(s,1,'uint8');
                packetsig(9)= sig(sigcount).version;
                sig(sigcount).numsigs = read(s,1,'uint8');
                packetsig(10)= sig(sigcount).numsigs;
                sig(sigcount).reserved1 = read(s,1,'uint16');
                packetsig(11:12)=typecast(uint16(sig(sigcount).reserved1),"uint8");
                
                for j = 1:sig(sigcount).numsigs
                    sig(sigcount).gnssid(j) = read(s,1,'uint8');
                    packetsig(12+((j-1)*16)+1)=sig(sigcount).gnssid(j);
                    sig(sigcount).svid(j) = read(s,1,'uint8');
                    packetsig(12+((j-1)*16)+2)=sig(sigcount).svid(j);
                    sig(sigcount).sigid(j) = read(s,1,'uint8');
                    packetsig(12+((j-1)*16)+3)=sig(sigcount).sigid(j);
                    sig(sigcount).freqid(j) = read(s,1,'uint8');
                    packetsig(12+((j-1)*16)+4)=sig(sigcount).freqid(j);
                    sig(sigcount).prres(j) = read(s,1,'int16');
                    packetsig(12+((j-1)*16)+5:12+((j-1)*16)+6)=typecast(int16(sig(sigcount).prres(j)),"uint8");
                    sig(sigcount).cno(j) = read(s,1,'uint8');
                    packetsig(12+((j-1)*16)+7)=sig(sigcount).cno(j);
                    sig(sigcount).qual(j) = read(s,1,'uint8');
                    packetsig(12+((j-1)*16)+8)=sig(sigcount).qual(j);
                    sig(sigcount).corsour(j) = read(s,1,'uint8');
                    packetsig(12+((j-1)*16)+9)=sig(sigcount).corsour(j);
                    sig(sigcount).ionmod(j) = read(s,1,'uint8');
                    packetsig(12+((j-1)*16)+10)=sig(sigcount).ionmod(j);
                    sig(sigcount).flags(j) = read(s,1,'uint16');
                    packetsig(12+((j-1)*16)+11:12+((j-1)*16)+12)=typecast(uint16(sig(sigcount).flags(j)),"uint8");
                    sig(sigcount).reserved2(j) = read(s,1,'uint32');
                    packetsig(12+((j-1)*16)+13:12+((j-1)*16)+16)=typecast(uint32(sig(sigcount).reserved2(j)),"uint8");
                end
                sig(sigcount).cka = read(s,1,'uint8');
                sig(sigcount).ckb = read(s,1,'uint8');
                
                %checksum calculations
                a =0;
                 b =0;
                 for i =1:(12+(sig(sigcount).numsigs*16))
                   a=a+packetsig(i);
                   b=b+a;   
                  a = a-(floor(a/255)*256);
                   b = b-(floor(b/255)*256);
                 end    
                 
                   
                 if sig(sigcount).ckb>128 && b~=sig(sigcount).ckb
                    b=b+256;
                 end
                 
                 sig(sigcount).a=a;
                 sig(sigcount).b=b;
                 
            end % if id end
        end %if class end nav
         
        
    end %if header2 end
end %if header1 end
if (mod(rfcount,60) == 2) && (rfcount ~= beforerf)
    beforerf = rfcount;
    agccheck1 = double(rf(rfcount).agccnt(1))/81.91;   
    agccheck2 = double(rf(rfcount).agccnt(2))/81.91;   
    fprintf('MON-RF: AGC(%%): %4.2f(High Band), %4.2f(Low Band) \n \n',agccheck1, agccheck2);   
end
if (mod(pvtcount,60) == 2) && (pvtcount ~= beforepvt)
    beforepvt = pvtcount;
    fprintf('NAV_PVT: UTC: %02d:%02d:%02d \n',pvt(pvtcount).hour, pvt(pvtcount).min, pvt(pvtcount).sec);
end
if (mod(satcount,60) == 2) && (satcount ~= beforesat)
    beforesat = satcount;
    satcheck = sat(satcount).numsat;
    fprintf('NAV_SAT: #Sats: %d \n',satcheck);
end
if (mod(sigcount,60) == 2) && (sigcount ~= beforesig)
    beforesig = sigcount;
    sigcheck = sig(sigcount).numsigs;
    fprintf('NAV_SIG: #Sigs: %d \n',sigcheck);
end
% %checking to see if day boundary was crossed or 12-13 hour boundary
% 
     if pvtcount > 5 
         before = pvtcount-1;
%         if (pvt(before).hour == 11) && pvt(pvtcount).hour == 12
%             break
%         end
%     
        if pvtcount ~=0 && pvtcount ~=1 && (pvt(pvtcount).day ~= pvt(before).day)
             break
        end
     
    end
end %end of while loop for data receiving







datalength = rfcount-1;%datalength to be used for plotting
clocks = strings(datalength,1);

%creating time vector for plot axis
for i =1:datalength
clocks(i) = pvt(i).hour + ":" + pvt(i).min + ":" + pvt(i).sec;
end
%creating names for files and plots
dataname = sprintf('%d-%d-%d_Data', pvt(1).year,pvt(1).month,pvt(1).day);
save(dataname,'rf','sat','pvt','sig','navclock','galtime','glotime','bdstime','gpstime');
name2="Date: "+num2str(pvt(1).year)+"/"+num2str(pvt(1).month)+"/"+num2str(pvt(1).day);


%%  Plotting 
%first figure-satellite data and receiver data
figure1 = figure(1);
set(figure1,'Position',[10,10,1900,1000])
t1 = tiledlayout(3,2,'TileSpacing', 'none');
sgtitle(t1,name2);

%agc
agc=double(vertcat(rf(1:datalength).agccnt))/81.91;
agc1 = agc(:,1);
agc2 = agc(:,2);
nexttile([1,2])
yyaxis left
plot(agc1,'-o');
xticks([1,floor(datalength/3),floor(2*datalength/3),datalength]);
xticklabels({clocks(1),clocks(floor(datalength/3)),clocks(floor(2*datalength/3)),clocks(datalength)});
ylim([min(agc1)-5,max(agc1)+4]);
xlim([1,datalength]);
title("AGC")
xlabel("UTC Time");
ylabel("AGC Percent");
yyaxis right
plot(agc2,'-o');
ylim([min(agc2)-4,max(agc2)+5]);
grid on
legend('High Band','Low Band','Location','southeastoutside');

%cw
cw = vertcat(rf(1:datalength).jamind)/2.55;
cw1 = cw(:,1);
cw2 = cw(:,2);
nexttile
yyaxis left
plot(cw1,'-o');
xticks([1,floor(datalength/3),floor(2*datalength/3),datalength]);
xticklabels({clocks(1),clocks(floor(datalength/3)),clocks(floor(2*datalength/3)),clocks(datalength)});
ylim([min(cw1)-1,max(cw1)+1]);
xlim([1,datalength]);
title("CW Jamming");
xlabel("UTC Time");
ylabel("Jamming Percent");
yyaxis right
ylim([min(cw2)-1,max(cw2)+1]);
plot(cw2,'-o');
grid on
legend('High Band','Low Band','Location','southeastoutside');

%lat lon height
nexttile([2,1])
lat = double(vertcat(pvt.lat))*10^(-7);
lon = double(vertcat(pvt.lon))*10^(-7);
height = vertcat(pvt.height)/1000;
cartx = zeros(datalength);
carty = zeros(datalength);
cartz = zeros(datalength);
for i = 1:datalength
    [cartx(i),carty(i),cartz(i)] = geo2cart(lat(i),lon(i),height(i),5);
end
avgx = mean(cartx);
avgy = mean(carty);
avgz = mean(cartz);
cartx = cartx - avgx;
carty = carty - avgy;
cartz = cartz - avgz;
plot3(cartx,carty,cartz,'-o')

xlabel('X Distance from Mean (m)');
ylabel('Y Distance from Mean (m)');
zlabel('Z Distance from Mean (m)');
grid on

sub0 = sprintf('Cartesian Coordinates  Mean X,Y,Z: %.1f, %.1f, %.1f', avgx(1), avgy(1), avgz(1));
title(sub0);

% %latitude
% lat = double(vertcat(pvt.lat))*10^(-7);
% nexttile
% plot(lat(1:datalength),'-o');
% xticks([1,floor(datalength/3),floor(2*datalength/3),datalength]);
% xticklabels({clocks(1),clocks(floor(datalength/3)),clocks(floor(2*datalength/3)),clocks(datalength)});
% ylim auto;%([min(lat(1:datalength))-(1/1000),max(lat(1:datalength))+(1/1000)]);
% xlim([1,datalength]);
% title("Latitude");
% xlabel("UTC Time");
% ylabel("Degrees");
% grid on

% %longitude
% lon = double(vertcat(pvt.lon))*10^(-7);
% nexttile
% plot(lon(1:datalength),'-o');
% xticks([1,floor(datalength/3),floor(2*datalength/3),datalength]);
% xticklabels({clocks(1),clocks(floor(datalength/3)),clocks(floor(2*datalength/3)),clocks(datalength)});
% ylim auto;%([min(lon(1:datalength))-(1/1000),max(lon(1:datalength))+(1/1000)]);
% xlim([1,datalength]);
% title("Longitude");
% xlabel("UTC Time");
% ylabel("Degrees");
% grid on

% %height
% height = vertcat(pvt.height)/1000;
% nexttile
% plot(height(1:datalength),'-o');
% xticks([1,floor(datalength/3),floor(2*datalength/3),datalength]);
% xticklabels({clocks(1),clocks(floor(datalength/3)),clocks(floor(2*datalength/3)),clocks(datalength)});
% ylim([min(height(1:datalength))-1,max(height(1:datalength))+1]);
% xlim([1,datalength]);
% title("Meters Above Ellipsoid");
% xlabel("UTC Time");
% ylabel("Meters");
% grid on

%num sats
sv1 = vertcat(sat.numsat);
sv = sv1(1:datalength,1);
gps = zeros(datalength,1);

sbas = zeros(datalength,1);
gal = zeros(datalength,1);
bds = zeros(datalength,1);
qzss = zeros(datalength,1);
glo = zeros(datalength,1);
sbascount = 1;
sbasid = zeros(1,3);
sbascno = zeros(datalength,3);

sbasaz = zeros(datalength,3);

sbasel = zeros(datalength,3);

gps1 = zeros(datalength,1);
gps2 = zeros(datalength,1);
gal1 = zeros(datalength,1);
gal2 = zeros(datalength,1);
bds1 = zeros(datalength,1);
bds2 = zeros(datalength,1);
glo1 = zeros(datalength,1);
glo2 = zeros(datalength,1);

%have to go through nav-sat and count satellites for each epoch
for i = 1:datalength

    for j= 1:sat(i).numsat
        if sat(i).gnssid(j) == 0
            gps(i) = gps(i) + 1;
        end
        if sat(i).gnssid(j) == 1
            sbas(i) = sbas(i) + 1;
            if sat(i).satid(j) == sbasid(1,1)
                sbascno(i,1) = sat(i).cno(j);
                sbasaz(i,1) = sat(i).azim(j);
                sbasel(i,1) = sat(i).elev(j);
            elseif sat(i).satid(j) == sbasid(1,2)
                sbascno(i,2) = sat(i).cno(j);
                sbasaz(i,2) = sat(i).azim(j);
                sbasel(i,2) = sat(i).elev(j);
            elseif sat(i).satid(j) == sbasid(1,3)
                sbascno(i,3) = sat(i).cno(j);
                sbasaz(i,3) = sat(i).azim(j);
                sbasel(i,3) = sat(i).elev(j);
            else
                sbasid(1,sbascount) = sat(i).satid(j);
                sbascount = sbascount + 1;
                sbascno(i,sbascount) = sat(i).cno(j);
                sbasaz(i,sbascount) = sat(i).azim(j);
                sbasel(i,sbascount) = sat(i).elev(j);
            end

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
    %goes through to find highest cno for each signal and epoch
    for j = 1:sig(i).numsigs
        if sig(i).gnssid(j) == 0
            if sig(i).sigid(j) == 0
                if sig(i).cno(j) > gps1(i)
                    gps1(i) = sig(i).cno(j);
                end
            end
            if sig(i).sigid(j) == 3
                if sig(i).cno(j) > gps2(i)
                    gps2(i) = sig(i).cno(j);
                end
            end
        end
        if sig(i).gnssid(j) == 2
            if sig(i).sigid(j) == 0 
                if sig(i).cno(j) > gal1(i)
                    gal1(i) = sig(i).cno(j);
                end
            end
            if sig(i).sigid(j) == 6 
                if sig(i).cno(j) > gal2(i)
                    gal2(i) = sig(i).cno(j);
                end
            end
        end
        if sig(i).gnssid(j) == 3
            if sig(i).sigid(j) == 0 
                if sig(i).cno(j) > bds1(i)
                    bds1(i) = sig(i).cno(j);
                end
            end
            if sig(i).sigid(j) == 2 
                if sig(i).cno(j) > bds2(i)
                    bds2(i) = sig(i).cno(j);
                end
            end
        end
        if sig(i).gnssid(j) == 6
            if sig(i).sigid(j) == 0 
                if sig(i).cno(j) > glo1(i)
                    glo1(i) = sig(i).cno(j);
                end
            end
            if sig(i).sigid(j) == 2
                if sig(i).cno(j) > glo2(i)
                    glo2(i) = sig(i).cno(j);
                end
            end
        end
    end
end %end of for i:datalength

%mean,max,min,std calculations
gpsmean=mean(gps);
gpsmax = max(gps);
gpsmin = min(gps);
gpsstd = std(gps);

sbasmean = mean(sbas);
sbasmax = max(sbas);
sbasmin = min(sbas);
sbasstd = std(sbas);

galmean = mean(gal);
galmax = max(gal);
galmin = min(gal);
galstd = std(gal);

bdsmean = mean(bds);
bdsmax = max(bds);
bdsmin = min(bds);
bdsstd = std(bds);

qzssmean = mean(qzss);
qzssmax = max(qzss);
qzssmin = min(qzss);
qzssstd = std(qzss);

glomean = mean(glo);
glomax = max(glo);
glomin = min(glo);
glostd = std(glo);
%creating subtitle with mean,max,min,std
sub2 = "GPS(" + round(gpsmax,2) + ", " + round(gpsmin,2) + ", " + round(gpsmean,2) + ", " + round(gpsstd,2) + ")   SBAS(" + round(sbasmax,2) + ", " + round(sbasmin,2) + ", " + round(sbasmean,2) + ", " + round(sbasstd,2) +  ")   GALILEO(" + round(galmax,2) + ", " + round(galmin,2) + ", " + round(galmean,2) + ", " + round(galstd,2) + ")   BEIDOU(" + round(bdsmax,2) + ", " + round(bdsmin,2) + ", " + round(bdsmean,2) + ", " + round(bdsstd,2) + ")   QZSS(" + round(qzssmax,2) + ", " + round(qzssmin,2) + ", " + round(qzssmean,2) + ", " + round(qzssstd,2) + ")   GLONASS(" + round(glomax,2) + ", " + round(glomin,2) + ", " + round(glomean,2) + ", " + round(glostd,2) + ")";
sub1 = "Constellation(Max,Min,Mean,Std):";
sub = {sub1,sub2};
subtitle(t1,sub);

%number of sats
nexttile
plot(sv,'-o');
xticks([1,floor(datalength/3),floor(2*datalength/3),datalength]);
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

%% Figure 2

figure2 = figure(2);

hourvec = vertcat(pvt(2:datalength).hour);
secondvec = vertcat(pvt(2:datalength).sec);
minvec = vertcat(pvt(2:datalength).min);
dayvec = vertcat(pvt(2:datalength).day);
monthvec = vertcat(pvt(2:datalength).month);
yearvec = vertcat(pvt(2:datalength).year);
timevector = datetime(yearvec, monthvec, dayvec, hourvec, minvec, secondvec, 'Format', 'HH:mm:ss');

sbasel(sbascno==0)=nan;
sbasaz(sbascno==0)=nan;
sbascno(sbascno==0)=nan;

sbasmat = [sbasel(2:datalength,1:3), sbasaz(2:datalength,1:3), sbascno(2:datalength,1:3)];
sbas1 = sprintf('S%d', sbasid(1));
sbas2 = sprintf('S%d', sbasid(2));
sbas3 = sprintf('S%d', sbasid(3));
sbas4 = sprintf('S%d ', sbasid(1));
sbas5 = sprintf('S%d ', sbasid(2));
sbas6 = sprintf('S%d ', sbasid(3));
sbas7 = sprintf(' S%d', sbasid(1));
sbas8 = sprintf(' S%d', sbasid(2));
sbas9 = sprintf(' S%d', sbasid(3));
vars = {sbas1,sbas2,sbas3,sbas4,sbas5,sbas6,sbas7,sbas8,sbas9};
timetable = array2timetable(sbasmat, 'RowTimes', timevector,'VariableNames', vars);
stack = stackedplot(timetable,{{sbas1,sbas2,sbas3},{sbas4,sbas5,sbas6},{sbas7,sbas8,sbas9}});
set(figure2,'Position',[10,10,1900,1000]);
sbastitle = name2 + " SBAS";
sgtitle(sbastitle);
stack.DisplayLabels = {'Elevation','Azimuth','CNO'};
stack.Marker = ('o');




% plot(sbasel(2:datalength,1),'o');
% xticks([1,floor(datalength/3),floor(2*datalength/3),datalength]);
% xticklabels({clocks(1),clocks(floor(datalength/3)),clocks(floor(2*datalength/3)),clocks(datalength)});
% ylim auto % ([min(min(sbasel(2:datalength,1:3)))-1,max(sbasel(:))+1]);
% xlim([1,datalength]);
% title("SBAS Elevation");
% xlabel("UTC Time");
% ylabel("Degrees");
% hold on
% plot(sbasel(:,2),'o');
% plot(sbasel(:,3),'o');
% hold off
% grid on
% legend("S"+sbasid(1),"S"+sbasid(2),"S"+sbasid(3), 'Location','southeastoutside');
% 
% 
% %sbas sno
% 
% nexttile
% 
% plot(sbascno(2:datalength,1),'o');
% xticks([1,floor(datalength/3),floor(2*datalength/3),datalength]);
% xticklabels({clocks(1),clocks(floor(datalength/3)),clocks(floor(2*datalength/3)),clocks(datalength)});
% ylim auto%([min(min(sbascno(2:datalength,1:3)))-1,max(sbascno(:))+1]);
% xlim([1,datalength]);
% title("SBAS CNO");
% xlabel("UTC Time");
% ylabel("dBHz");
% hold on
% plot(sbascno(:,2),'o');
% plot(sbascno(:,3),'o');
% hold off
% grid on
% legend("S"+sbasid(1),"S"+sbasid(2),"S"+sbasid(3), 'Location','southeastoutside');
% 
% %sbas azimuth
% nexttile
% plot(sbasaz(2:datalength,1),'o');
% xticks([1,floor(datalength/3),floor(2*datalength/3),datalength]);
% xticklabels({clocks(1),clocks(floor(datalength/3)),clocks(floor(2*datalength/3)),clocks(datalength)});
% ylim auto % ([min(min(sbasaz(2:datalength,1:3)))-1,max(sbasaz(:))+1]);
% xlim([1,datalength]);
% title("SBAS Azimuth");
% xlabel("UTC Time");
% ylabel("Degrees");
% hold on
% plot(sbasaz(:,2),'o');
% plot(sbasaz(:,3),'o');
% hold off
% grid on
% legend("S"+sbasid(1),"S"+sbasid(2),"S"+sbasid(3), 'Location','southeastoutside');
 %% Figure 3

figure3 = figure(3);
tiledlayout(figure3,2,2);
set(figure3,'Position',[10,10,1900,1000]);
timetitle = name2 + " Time";
sgtitle(timetitle);

%pc clock
nexttile
nanos = vertcat(pvt(1:datalength).nano);
correctnano = abs(nanos)/1000000000;
seconds = vertcat(pvt(1:datalength).sec);
minutes = vertcat(pvt(1:datalength).min);
receivertime = (double(minutes)*60)+double(seconds)+double(correctnano);

comptime = vertcat(pvt(1:datalength).clocks);
cseconds = comptime(:,2);
cminutes = comptime(:,1);
correcttime = cseconds + cminutes*60;
timedifference = double(receivertime)-correcttime;
timedifference(abs(timedifference)>3500)=nan;
timedifference(1:200) = nan;
plot(timedifference(1:datalength),'o');
xticks([1,floor(datalength/3),floor(2*datalength/3),datalength]);
xticklabels({clocks(1),clocks(floor(datalength/3)),clocks(floor(2*datalength/3)),clocks(datalength)});
ylim auto;
xlim([1,datalength]);
title("System and GNSS Time Difference");
xlabel("UTC Time");
ylabel("Seconds");
grid on

%nav clock plot
nexttile([2,1]);
bias = vertcat(navclock(2:datalength).bias);
drift = vertcat(navclock(2:datalength).drift);
timeacc = vertcat(navclock(2:datalength).timeaccuracy);
freqacc = vertcat(navclock(2:datalength).frequencyaccuracy);
timematrix = [bias,drift,timeacc,freqacc];
timetable2 = array2timetable(timematrix, 'RowTimes', timevector);

stack1 = stackedplot(timetable2);

stack1.DisplayLabels = {'Bias (ns*10^5)','Drift (ns/s)','Time Accuracy Estimate (ns)', 'Frequency Accuracy Estimate (ps/s)'};
stack1.Marker = ('o');


nexttile
bdstacc = vertcat(bdstime(2:datalength).timeaccuracy);
galtacc = vertcat(galtime(2:datalength).timeaccuracy);
glotacc = vertcat(glotime(2:datalength).timeaccuracy);
gpstacc = vertcat(gpstime(2:datalength).timeaccuracy);

plot(gpstacc,'-o');
hold on
plot(galtacc,'-x');
plot(glotacc,'-s');
plot(bdstacc,'-+');
xticks([1,floor(datalength/3),floor(2*datalength/3),datalength]);
xticklabels({clocks(1),clocks(floor(datalength/3)),clocks(floor(2*datalength/3)),clocks(datalength)});
ylim auto;
title("Constellation Time Accuracy");
xlabel("UTC Time");
ylabel("Nanoseconds");
legend('GPS','GALILEO','GLONASS','BeiDou');
grid on

%% agc vs cno
%% agc vs cno
figure4 = figure(4);

set(figure4,'Position',[10,10,1900,1000]);
sgtitle(name2);

%high band
subplot(2,2,1)
scatter(gps1,agc1)
hold on
scatter(gal1,agc1,'x')
scatter(bds1,agc1,'s')
scatter(glo1,agc1,'+')
hold off
title("AGC vs CNO HIGH BAND")
ylabel("AGC Percent");
xlabel("CNO (dBHz)");
yl = ylim;
xl = xlim;
ylim([0,yl(2)+10]);
xlim([0,xl(2)+10]);
grid on
legend('GPS L1','Galileo E1 C','Beidou B1','GLONASS L1');


%low band
subplot(2,2,2)
scatter(gps2,agc2)
hold on
scatter(gal2,agc2,'x')
scatter(bds2,agc2,'s')
scatter(glo2,agc2,'+')

title("AGC vs CNO LOW BAND")
ylabel("AGC Percent");
xlabel("CNO (dBHz)");
yl = ylim;
xl = xlim;
ylim([0,yl(2)+10]);
xlim([0,xl(2)+10]);
grid on
legend('GPS L5','Galileo E5 bQ','Beidou B2','GLONASS L2');



subplot(2,2,3)
cnovec = [gps1;glo1;gal1;bds1];
agcvec = [agc1;agc1;agc1;agc1];
histvect = [cnovec,agcvec];
hist3(histvect,'CDataMode','auto','Ctrs',{0:5:xl(2)+10 0:5:yl(2)+10});
xlabel('CN0 (dBHz)');
ylabel('AGC Percent');
title('High Band');
colorbar
view(2)



subplot(2,2,4)
cnovec = [gps2;glo2;gal2;bds2];
agcvec = [agc2;agc2;agc2;agc2];
histvect = [cnovec,agcvec];
hist3(histvect,'CDataMode','auto','Ctrs',{0:5:xl(2)+10 0:5:yl(2)+10});
xlabel('CN0 (dBHz)');
ylabel('AGC Percent');
title('Low Band');
colorbar
view(2)

%legend('High Band','Low Band','Location','southeastoutside');
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
fig1name = sprintf('%d-%d-%d_AGC,Nav,Sat_Info', pvt(1).year,pvt(1).month,pvt(1).day);
fig2name = sprintf('%d-%d-%d_SBAS_Info', pvt(1).year,pvt(1).month,pvt(1).day);
fig3name = sprintf('%d-%d-%d_Time_Info', pvt(1).year,pvt(1).month,pvt(1).day);
fig4name = sprintf('%d-%d-%d_AGC_vs_CNO', pvt(1).year,pvt(1).month,pvt(1).day);
saveas(figure1,fig1name,'fig');
saveas(figure1,fig1name,'jpg');
saveas(figure2,fig2name,'fig');
saveas(figure2,fig2name,'jpg');
saveas(figure3,fig3name,'fig');
saveas(figure3,fig3name,'jpg');
saveas(figure4,fig4name,'fig');
saveas(figure4,fig4name,'jpg');

%saveas(figure3,name,'fig');
%saveas(figure3,name,'jpg');
end
clear s
