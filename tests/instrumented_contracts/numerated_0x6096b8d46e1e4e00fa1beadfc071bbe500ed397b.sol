1 pragma solidity 0.4.24;
2 
3 contract Fees {
4     uint FIWDATM;
5     uint FIWNTM;
6     address constant private Admin = 0x92Bf51aB8C48B93a96F8dde8dF07A1504aA393fD;
7     
8     
9     function FeeDATM(uint FeeInWeiDATM){
10     require(msg.sender==Admin);
11     if (msg.sender==Admin){
12         FIWDATM=FeeInWeiDATM;
13     }
14     }
15     
16     
17     function GetFeeDATM()returns(uint){
18         return FIWDATM;
19     }
20     
21     
22     function FeeNTM(uint FeeInWeiNTM){
23     require(msg.sender==Admin);
24     if (msg.sender==Admin){
25         FIWNTM=FeeInWeiNTM;
26     }
27     }
28     
29     function GetFeeNTM()returns(uint){
30         return FIWNTM;
31     }
32 }