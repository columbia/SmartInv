1 pragma solidity 0.4.24;
2 
3 contract EthmoFees {
4     uint FIWEthmoDeploy;
5     uint FIWEthmoMint;
6     address constant private Admin = 0x92Bf51aB8C48B93a96F8dde8dF07A1504aA393fD;
7     
8     
9     function FeeEthmoDeploy(uint FeeInWeiDeploy){
10     require(msg.sender==Admin);
11     if (msg.sender==Admin){
12         FIWEthmoDeploy=FeeInWeiDeploy;
13     }
14     }
15     
16     
17     function GetFeeEthmoDeploy()returns(uint){
18         return FIWEthmoDeploy;
19     }
20     
21     
22     function FeeEthmoMint(uint FeeInWeiMint){
23     require(msg.sender==Admin);
24     if (msg.sender==Admin){
25         FIWEthmoMint=FeeInWeiMint;
26     }
27     }
28     
29     function GetFeeEthmoMint()returns(uint){
30         return FIWEthmoMint;
31     }
32 }