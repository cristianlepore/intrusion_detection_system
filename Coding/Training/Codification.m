% RICORDARSI DI CAMBIARE IL NOME AI DATASET PRIMA DI ESEGUIRE LO SCRIPT

% Pulisco il workspace
% close all;
% clear variables;

% Carico il dataset
% load('nlsKDD.mat');

% Prendo la lunghezza della singola colonna
% colmn=KDDTest{:,2};
% 
% % *********************QUESTO DATASET IMPIEGA 4 MINUTI*********************
% % Faccio la codifica del campo Protocol_type
% for i=1:length(colmn)
%     if(KDDTest{i,2}=="tcp")
%         KDDTest{i,2}="1";
%     elseif (KDDTest{i,2}=="udp")
%         KDDTest{i,2}="2";
%     elseif (KDDTest{i,2}=="icmp")
%         KDDTest{i,2}="3";
%     end
%     str2double(KDDTest{i,2});
% end

% *********************QUESTO DATASET IMPIEGA 8 MINUTI*********************

% colmn=KDDTest{:,2};

% Faccio la codifica del campo Flag
% for i=1:length(colmn)
%     if(KDDTest{i,4}=="OTH")
%         KDDTest{i,4}="5";
%     elseif (KDDTest{i,4}=="REJ")
%         KDDTest{i,4}="6";
%     elseif (KDDTest{i,4}=="RSTO")
%         KDDTest{i,4}="7";
%     elseif(KDDTest{i,4}=="RSTOS0")
%         KDDTest{i,4}="8";
%     elseif (KDDTest{i,4}=="RSTR")
%         KDDTest{i,4}="9";
%     elseif (KDDTest{i,4}=="S0")
%         KDDTest{i,4}="10";
%     elseif(KDDTest{i,4}=="S1")
%         KDDTest{i,4}="11";
%     elseif (KDDTest{i,4}=="S2")
%         KDDTest{i,4}="12";
%     elseif (KDDTest{i,4}=="S3")
%         KDDTest{i,4}="13";
%     elseif(KDDTest{i,4}=="SF")
%         KDDTest{i,4}="14";
%     elseif (KDDTest{i,4}=="SH")
%         KDDTest{i,4}="15";
%     end
%     str2double(KDDTest{i,4});
% end

% *********************QUESTO DATASET IMPIEGA 25 MINUTI*********************
% clear variables;
% close all;
% 
% load('intermediate.mat');
% colmn=KDDTest{:,2};
% 
% % Faccio la codifica del campo Flag
% for i=1:length(colmn)
%     if(KDDTest{i,3}=="IRC")
%         KDDTest{i,3}="16";
%     elseif (KDDTest{i,3}=="X11")
%         KDDTest{i,3}="17";
%     elseif (KDDTest{i,3}=="Z39_50")
%         KDDTest{i,3}="18";
%     elseif (KDDTest{i,3}=="auth")
%         KDDTest{i,3}="19";
%     elseif (KDDTest{i,3}=="bgp")
%         KDDTest{i,3}="20";
%     elseif (KDDTest{i,3}=="courier")
%         KDDTest{i,3}="21";
%     elseif (KDDTest{i,3}=="csnet_ns")
%         KDDTest{i,3}="22";
%     elseif (KDDTest{i,3}=="ctf")
%         KDDTest{i,3}="23";
%     elseif (KDDTest{i,3}=="daytime")
%         KDDTest{i,3}="24";
%     elseif (KDDTest{i,3}=="discard")
%         KDDTest{i,3}="25";
%     elseif (KDDTest{i,3}=="domain")
%         KDDTest{i,3}="26";
%     elseif (KDDTest{i,3}=="domain_u")
%         KDDTest{i,3}="27";
%     elseif (KDDTest{i,3}=="echo")
%         KDDTest{i,3}="28";
%     elseif (KDDTest{i,3}=="eco_i")
%         KDDTest{i,3}="29";
%     elseif (KDDTest{i,3}=="ecr_i")
%         KDDTest{i,3}="30";
%     elseif (KDDTest{i,3}=="efs")
%         KDDTest{i,3}="31";
%     elseif (KDDTest{i,3}=="exec")
%         KDDTest{i,3}="32";
%     elseif (KDDTest{i,3}=="finger")
%         KDDTest{i,3}="33";
%     elseif (KDDTest{i,3}=="ftp")
%         KDDTest{i,3}="34";
%     elseif (KDDTest{i,3}=="ftp_data")
%         KDDTest{i,3}="35";
%     elseif (KDDTest{i,3}=="gopher")
%         KDDTest{i,3}="36";
%     elseif (KDDTest{i,3}=="hostnames")
%         KDDTest{i,3}="37";
%     elseif (KDDTest{i,3}=="http")
%         KDDTest{i,3}="38";
%     elseif (KDDTest{i,3}=="http_443")
%         KDDTest{i,3}="39";
%     elseif (KDDTest{i,3}=="imap4")
%         KDDTest{i,3}="40";
%     elseif (KDDTest{i,3}=="iso_tsap")
%         KDDTest{i,3}="41";
%     elseif (KDDTest{i,3}=="klogin")
%         KDDTest{i,3}="42";
%     elseif (KDDTest{i,3}=="kshell")
%         KDDTest{i,3}="43";
%     elseif (KDDTest{i,3}=="ldap")
%         KDDTest{i,3}="44";
%     elseif (KDDTest{i,3}=="link")
%         KDDTest{i,3}="45";
%     elseif (KDDTest{i,3}=="login")
%         KDDTest{i,3}="46";
%     elseif (KDDTest{i,3}=="mtp")
%         KDDTest{i,3}="47";
%     elseif (KDDTest{i,3}=="name")
%         KDDTest{i,3}="48";
%     elseif (KDDTest{i,3}=="netbios_dgm")
%         KDDTest{i,3}="49";
%     elseif (KDDTest{i,3}=="netbios_ns")
%         KDDTest{i,3}="50";
%     elseif (KDDTest{i,3}=="netbios_ssn")
%         KDDTest{i,3}="51";
%     elseif (KDDTest{i,3}=="netstat")
%         KDDTest{i,3}="52";
%     elseif (KDDTest{i,3}=="nnsp")
%         KDDTest{i,3}="53";
%     elseif (KDDTest{i,3}=="nntp")
%         KDDTest{i,3}="54";
%     elseif (KDDTest{i,3}=="ntp_u")
%         KDDTest{i,3}="55";
%     elseif (KDDTest{i,3}=="other")
%         KDDTest{i,3}="56";
%     elseif (KDDTest{i,3}=="pm_dump")
%         KDDTest{i,3}="57";
%     elseif (KDDTest{i,3}=="pop_2")
%         KDDTest{i,3}="58";
%     elseif (KDDTest{i,3}=="pop_3")
%         KDDTest{i,3}="59";
%     elseif (KDDTest{i,3}=="printer")
%         KDDTest{i,3}="60";
%     elseif (KDDTest{i,3}=="private")
%         KDDTest{i,3}="61";
%     elseif (KDDTest{i,3}=="red_i")
%         KDDTest{i,3}="62";
%     elseif (KDDTest{i,3}=="remote_job")
%         KDDTest{i,3}="63";
%     elseif (KDDTest{i,3}=="rje")
%         KDDTest{i,3}="64";
%     elseif (KDDTest{i,3}=="shell")
%         KDDTest{i,3}="65";
%     elseif (KDDTest{i,3}=="smtp")
%         KDDTest{i,3}="66";
%     elseif (KDDTest{i,3}=="sql_net")
%         KDDTest{i,3}="67";
%     elseif (KDDTest{i,3}=="ssh")
%         KDDTest{i,3}="68";
%     elseif (KDDTest{i,3}=="sunrpc")
%         KDDTest{i,3}="69";
%     elseif (KDDTest{i,3}=="supdup")
%         KDDTest{i,3}="70";
%     elseif (KDDTest{i,3}=="systat")
%         KDDTest{i,3}="71";
%     elseif (KDDTest{i,3}=="telnet")
%         KDDTest{i,3}="72";
%     elseif (KDDTest{i,3}=="tim_i")
%         KDDTest{i,3}="73";
%     elseif (KDDTest{i,3}=="time")
%         KDDTest{i,3}="74";
%     elseif (KDDTest{i,3}=="urp_i")
%         KDDTest{i,3}="75";
%     elseif (KDDTest{i,3}=="uucp")
%         KDDTest{i,3}="76";
%     elseif (KDDTest{i,3}=="uucp_path")
%         KDDTest{i,3}="77";
%     elseif (KDDTest{i,3}=="vmnet")
%         KDDTest{i,3}="78";
%     elseif (KDDTest{i,3}=="whois")
%         KDDTest{i,3}="79";
%     elseif (KDDTest{i,3}=="http_8001")
%         KDDTest{i,3}="80";
%     elseif (KDDTest{i,3}=="urh_i")
%         KDDTest{i,3}="81";
%     elseif (KDDTest{i,3}=="aol")
%         KDDTest{i,3}="82";
%     elseif (KDDTest{i,3}=="http_2784")
%         KDDTest{i,3}="83";
%     elseif (KDDTest{i,3}=="tftp_u")
%         KDDTest{i,3}="84";
%     elseif (KDDTest{i,3}=="harvest")
%         KDDTest{i,3}="85";
%     end
%     str2double(KDDTest{i,3});
% end
% 

colmn=KDDTest{:,42};
% Creo la colonna aggiuntiva delle categorie di attacco
Y=zeros(length(colmn),5);

% Faccio la codifica delle etichette
for i=1:length(colmn)
    if(KDDTest{i,42}=="back")
        Y(i,1)=0;
        Y(i,2)=1;
        Y(i,3)=0;
        Y(i,4)=0;
        Y(i,5)=0;
    elseif (KDDTest{i,42}=="buffer_overflow")
        Y(i,1)=0;
        Y(i,2)=0;
        Y(i,3)=0;
        Y(i,4)=0;
        Y(i,5)=1;
    elseif (KDDTest{i,42}=="ftp_write")
        Y(i,1)=0;
        Y(i,2)=0;
        Y(i,3)=0;
        Y(i,4)=1;
        Y(i,5)=0;
    elseif (KDDTest{i,42}=="guess_passwd")
        Y(i,1)=0;
        Y(i,2)=0;
        Y(i,3)=0;
        Y(i,4)=1;
        Y(i,5)=0;
    elseif (KDDTest{i,42}=="imap")
        Y(i,1)=0;
        Y(i,2)=0;
        Y(i,3)=0;
        Y(i,4)=1;
        Y(i,5)=0;
    elseif (KDDTest{i,42}=="ipsweep")
        Y(i,1)=0;
        Y(i,2)=0;
        Y(i,3)=1;
        Y(i,4)=0;
        Y(i,5)=0;
    elseif (KDDTest{i,42}=="multihop")
        Y(i,1)=0;
        Y(i,2)=0;
        Y(i,3)=0;
        Y(i,4)=1;
        Y(i,5)=0;
    elseif (KDDTest{i,42}=="neptune")
        Y(i,1)=0;
        Y(i,2)=1;
        Y(i,3)=0;
        Y(i,4)=0;
        Y(i,5)=0;
    elseif (KDDTest{i,42}=="nmap")
        Y(i,1)=0;
        Y(i,2)=0;
        Y(i,3)=1;
        Y(i,4)=0;
        Y(i,5)=0;
    elseif (KDDTest{i,42}=="normal")
        Y(i,1)=1;
        Y(i,2)=0;
        Y(i,3)=0;
        Y(i,4)=0;
        Y(i,5)=0;
    elseif (KDDTest{i,42}=="pod")
        Y(i,1)=0;
        Y(i,2)=1;
        Y(i,3)=0;
        Y(i,4)=0;
        Y(i,5)=0;
    elseif (KDDTest{i,42}=="portsweep")
        Y(i,1)=0;
        Y(i,2)=0;
        Y(i,3)=1;
        Y(i,4)=0;
        Y(i,5)=0;
    elseif (KDDTest{i,42}=="rootkit")
        Y(i,1)=0;
        Y(i,2)=0;
        Y(i,3)=0;
        Y(i,4)=0;
        Y(i,5)=1;
    elseif (KDDTest{i,42}=="satan")
        Y(i,1)=0;
        Y(i,2)=0;
        Y(i,3)=1;
        Y(i,4)=0;
        Y(i,5)=0;
    elseif (KDDTest{i,42}=="smurf")
        Y(i,1)=0;
        Y(i,2)=1;
        Y(i,3)=0;
        Y(i,4)=0;
        Y(i,5)=0;
    elseif (KDDTest{i,42}=="teardrop")
        Y(i,1)=0;
        Y(i,2)=1;
        Y(i,3)=0;
        Y(i,4)=0;
        Y(i,5)=0;
    elseif (KDDTest{i,42}=="warezclient")
        Y(i,1)=0;
        Y(i,2)=0;
        Y(i,3)=0;
        Y(i,4)=1;
        Y(i,5)=0;
    elseif (KDDTest{i,42}=="warezmaster")
        Y(i,1)=0;
        Y(i,2)=0;
        Y(i,3)=0;
        Y(i,4)=1;
        Y(i,5)=0;
    elseif (KDDTest{i,42}=="land")
        Y(i,1)=0;
        Y(i,2)=1;
        Y(i,3)=0;
        Y(i,4)=0;
        Y(i,5)=0;
    elseif (KDDTest{i,42}=="loadmodule")
        Y(i,1)=0;
        Y(i,2)=0;
        Y(i,3)=0;
        Y(i,4)=0;
        Y(i,5)=1;
    elseif (KDDTest{i,42}=="phf")
        Y(i,1)=0;
        Y(i,2)=0;
        Y(i,3)=0;
        Y(i,4)=1;
        Y(i,5)=0;
    elseif (KDDTest{i,42}=="spy")
        Y(i,1)=0;
        Y(i,2)=0;
        Y(i,3)=0;
        Y(i,4)=1;
        Y(i,5)=0;
    elseif (KDDTest{i,42}=="perl")
        Y(i,1)=0;
        Y(i,2)=0;
        Y(i,3)=0;
        Y(i,4)=0;
        Y(i,5)=1;
    elseif (KDDTest{i,42}=="apache2")
        Y(i,1)=0;
        Y(i,2)=1;
        Y(i,3)=0;
        Y(i,4)=0;
        Y(i,5)=0;
    elseif (KDDTest{i,42}=="httptunnel")
        Y(i,1)=0;
        Y(i,2)=0;
        Y(i,3)=0;
        Y(i,4)=1;
        Y(i,5)=0;
    elseif (KDDTest{i,42}=="mailbomb")
        Y(i,1)=0;
        Y(i,2)=1;
        Y(i,3)=0;
        Y(i,4)=0;
        Y(i,5)=0;
    elseif (KDDTest{i,42}=="mscan")
        Y(i,1)=0;
        Y(i,2)=0;
        Y(i,3)=1;
        Y(i,4)=0;
        Y(i,5)=0;
    elseif (KDDTest{i,42}=="named")
        Y(i,1)=0;
        Y(i,2)=0;
        Y(i,3)=0;
        Y(i,4)=1;
        Y(i,5)=0;
    elseif (KDDTest{i,42}=="processtable")
        Y(i,1)=0;
        Y(i,2)=1;
        Y(i,3)=0;
        Y(i,4)=0;
        Y(i,5)=0;
    elseif (KDDTest{i,42}=="ps")
        Y(i,1)=0;
        Y(i,2)=0;
        Y(i,3)=0;
        Y(i,4)=0;
        Y(i,5)=1;
    elseif (KDDTest{i,42}=="saint")
        Y(i,1)=0;
        Y(i,2)=0;
        Y(i,3)=1;
        Y(i,4)=0;
        Y(i,5)=0;
    elseif (KDDTest{i,42}=="sendmail")
        Y(i,1)=0;
        Y(i,2)=0;
        Y(i,3)=0;
        Y(i,4)=1;
        Y(i,5)=0;
    elseif (KDDTest{i,42}=="snmpgetattack")
        Y(i,1)=0;
        Y(i,2)=0;
        Y(i,3)=0;
        Y(i,4)=1;
        Y(i,5)=0;
    elseif (KDDTest{i,42}=="snmpguess")
        Y(i,1)=0;
        Y(i,2)=0;
        Y(i,3)=0;
        Y(i,4)=1;
        Y(i,5)=0;
    elseif (KDDTest{i,42}=="sqlattack")
        Y(i,1)=0;
        Y(i,2)=0;
        Y(i,3)=0;
        Y(i,4)=0;
        Y(i,5)=1;
    elseif (KDDTest{i,42}=="udpstorm")
        Y(i,1)=0;
        Y(i,2)=1;
        Y(i,3)=0;
        Y(i,4)=0;
        Y(i,5)=0;
    elseif (KDDTest{i,42}=="worm")
        Y(i,1)=0;
        Y(i,2)=1;
        Y(i,3)=0;
        Y(i,4)=0;
        Y(i,5)=0;
    elseif (KDDTest{i,42}=="xlock")
        Y(i,1)=0;
        Y(i,2)=0;
        Y(i,3)=0;
        Y(i,4)=1;
        Y(i,5)=0;
    elseif (KDDTest{i,42}=="xsnoop")
        Y(i,1)=0;
        Y(i,2)=0;
        Y(i,3)=0;
        Y(i,4)=1;
        Y(i,5)=0;
    elseif (KDDTest{i,42}=="xterm")
        Y(i,1)=0;
        Y(i,2)=0;
        Y(i,3)=0;
        Y(i,4)=0;
        Y(i,5)=1;
    end
end

% writetable(KDDTest,dataset);