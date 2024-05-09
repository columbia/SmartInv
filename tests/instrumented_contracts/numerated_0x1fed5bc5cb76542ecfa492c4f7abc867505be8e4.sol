1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract RigidBit
4 {
5     address public owner;
6 
7     struct Storage
8     {
9         uint timestamp;
10     }
11     mapping(bytes32 => Storage) s;
12 
13     constructor() public
14     {
15         owner = msg.sender;
16     }
17 
18     modifier onlyOwner
19     {
20         require(msg.sender == owner);
21         _;
22     }
23 
24     function transferOwnership(address _newOwner) public onlyOwner
25     {
26         owner = _newOwner;
27     }
28 
29     function getHash(bytes32 hash) public view returns(uint)
30     {
31         return s[hash].timestamp;
32     }
33     
34     function storeHash(bytes32 hash) public onlyOwner
35     {
36         assert(s[hash].timestamp == 0);
37 
38         s[hash].timestamp = now;
39     }
40 }