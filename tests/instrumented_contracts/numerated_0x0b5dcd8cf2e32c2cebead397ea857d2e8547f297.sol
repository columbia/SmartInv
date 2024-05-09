1 pragma solidity ^0.4.11;
2 
3 contract accessControlled {
4     address public owner;
5     mapping (address => bool) public registrator;
6     
7     function accessControlled() {
8         registrator[msg.sender] = true;
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13         if ( msg.sender != owner ) throw;
14         _;
15     }
16 
17     modifier onlyRegistrator {
18         if ( !registrator[msg.sender] ) throw;
19         _;
20     }
21     
22     function transferOwnership( address newOwner ) onlyOwner {
23         owner = newOwner;
24     }
25 
26     function updateRegistratorStatus( address registratorAddress, bool status ) onlyOwner {
27         registrator[registratorAddress] = status;
28     }
29 
30 }
31 
32 
33 contract OriginalMyDocAuthenticity is accessControlled {
34     
35   mapping (string => uint) private authenticity;
36 
37   function storeAuthenticity(string sha256) onlyRegistrator {
38     if (checkAuthenticity(sha256) == 0) {
39         authenticity[sha256] = now;
40     }   
41   }
42 
43   function checkAuthenticity(string sha256) constant returns (uint) {
44     return authenticity[sha256];
45   }
46 }