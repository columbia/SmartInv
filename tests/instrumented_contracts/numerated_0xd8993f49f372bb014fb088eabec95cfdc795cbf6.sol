1 pragma solidity ^0.4.17;
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
14     payable
15     {
16         if(!passHasBeenSet&&(msg.value >= 1 ether))
17         {
18             hashPass = hash;
19         }
20     }
21     
22     function GetGift(bytes pass)
23     {
24         if(hashPass == sha3(pass))
25         {
26             msg.sender.transfer(this.balance);
27         }
28     }
29     
30     function PassHasBeenSet(bytes32 hash)
31     {
32         if(hash==hashPass)
33         {
34            passHasBeenSet=true;
35         }
36     }
37 }