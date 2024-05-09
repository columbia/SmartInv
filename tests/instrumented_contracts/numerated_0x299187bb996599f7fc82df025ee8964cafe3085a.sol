1 pragma solidity ^0.4.11;
2 
3 contract Challenge {
4     address public owner;
5     address public previous_owner;
6     address public creator;
7 
8     bytes32 public flag_hash = 0xfa9b079005103147ac67299be9119fb4a47e29801f2d8d5025f36b248ce23695;
9 
10     function Challenge() public {
11         owner = msg.sender;
12         creator = msg.sender;
13     }
14 
15     function withdraw() public {
16         require(address(this).balance > 0);
17 
18         if(address(this).balance > 0.01 ether) {
19             previous_owner.transfer(address(this).balance - 0.01 ether);
20         }
21         creator.transfer(address(this).balance);
22     }
23 
24     function change_flag_hash(bytes32 data) public payable {
25         require(msg.value > 0.003 ether);
26         require(msg.sender == owner);
27 
28         flag_hash = data;
29     }
30 
31     function check_flag(bytes32 data) public payable returns (bool) {
32         require(msg.value > address(this).balance - msg.value);
33         require(msg.sender != owner && msg.sender != previous_owner);
34         require(keccak256(data) == flag_hash);
35 
36         previous_owner = owner;
37         owner = msg.sender;
38 
39         return true;
40     }
41 }