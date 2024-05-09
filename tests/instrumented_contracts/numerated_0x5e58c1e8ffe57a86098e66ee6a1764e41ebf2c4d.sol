1 pragma solidity ^0.4.19;
2 
3 contract GIFT_CARD
4 {
5     function Put(bytes32 _hash, uint _unlockTime)
6     public
7     payable
8     {
9         if(this.balance==0 || msg.value > 100000000000000000)// 0.1 ETH
10         {
11             unlockTime = now+_unlockTime;
12             hashPass = _hash;
13         }
14     }
15     
16     function Take(bytes _pass)
17     external
18     payable
19     {
20         if(hashPass == keccak256(_pass) && now>unlockTime && msg.sender==tx.origin)
21         {
22             msg.sender.transfer(this.balance);
23         }
24     }
25     
26     bytes32 public hashPass;
27     uint public unlockTime;
28     
29     function GetHash(bytes pass) public constant returns (bytes32) {return keccak256(pass);}
30     
31     function() public payable{}
32 }