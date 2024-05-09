1 pragma solidity ^0.4.13;
2 
3 // File: contracts/Owned.sol
4 
5 contract Owned {
6     address owner;
7 
8     modifier onlyOwner() {
9         require(msg.sender == owner);
10         _;
11     }
12 
13     function Owned() public {
14         owner = msg.sender;
15     }
16 
17     function transferOwnership(address newOwner) public onlyOwner() {
18         require(newOwner != 0x0);
19         owner = newOwner;
20     }
21 }
22 
23 // File: contracts/Notarize.sol
24 
25 contract Notarize is Owned {
26     
27     mapping(bytes32 => uint) public notaryBook;
28     uint public notaryBookSize;
29 
30     event RecordAdded(bytes32 hash, uint timestamp);
31 
32     function notarize(bytes32 _hash, uint _timestamp) public onlyOwner {
33         require(!isNotarized(_hash));
34         notaryBook[_hash] = _timestamp;
35         notaryBookSize++;
36         RecordAdded(_hash, _timestamp);
37     }
38 
39     function isNotarized(bytes32 _hash) public view returns(bool) {
40         return (notaryBook[_hash] > 0);
41     }
42 
43     function getTimestamp(bytes32 _hash) public view returns(uint) {
44         return notaryBook[_hash];
45     }
46 }