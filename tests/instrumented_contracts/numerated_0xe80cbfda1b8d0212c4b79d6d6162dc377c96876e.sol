1 pragma solidity 0.4.24;
2 
3 contract VIPs {
4     address[] VIP;
5     address constant private Admin = 0x92Bf51aB8C48B93a96F8dde8dF07A1504aA393fD;
6     
7     
8     function AddVIP(address NewVIP){
9     require(msg.sender==Admin);
10     if (msg.sender==Admin){
11         VIP.push(NewVIP);
12     }
13     }
14     
15     
16     function RemoveVIP(address RemoveAddress){
17         require (msg.sender==Admin);
18         if (msg.sender==Admin){
19         uint L=VIP.length;
20         for (uint k=0; k<L; k++){
21             if (VIP[k]==RemoveAddress){
22                 delete VIP[k];
23             }
24         }
25         }
26     }
27          
28          
29     function IsVIP(address Address)returns(uint Multiplier){
30         uint L=VIP.length;
31         uint count=0;
32         for (uint k=0; k<L; k++){
33             if (VIP[k]==Address){
34                 count=1;
35             }
36         }
37         if (count==0){
38             Multiplier=1;
39         }else{
40             Multiplier=0;
41         }
42     }
43     
44     
45 }