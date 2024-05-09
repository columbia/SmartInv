1 pragma solidity ^0.5.9;
2 contract sproof {
3     event lockHashEvent(address indexed from, bytes32 indexed hash);
4     
5     address payable owner;
6 
7 
8     mapping(address => bool) sproofAccounts;
9 
10     uint  costToLockHash = 0;
11 
12     constructor() public {
13         owner = msg.sender;
14     }
15 
16     function addSproofAccount(address _addr) public{
17         require(msg.sender == owner);
18         sproofAccounts[_addr] = true;
19     }
20     
21       function updateOwner(address payable newOwner) public{
22         require(msg.sender == owner);
23         owner = newOwner;
24     }
25     
26      function removeSproofAccount(address _addr) public{
27         require(msg.sender == owner);
28         sproofAccounts[_addr] = false;
29     }
30 
31 
32     function setCost (uint newCostToLockHash) public {
33         require (msg.sender == owner);
34         costToLockHash = newCostToLockHash;
35     }
36     
37    function getCost() public view returns(uint)  {
38         return costToLockHash;
39     }
40 
41     function lockHash(bytes32 hash) public payable{
42         if(sproofAccounts[msg.sender] != true)
43             require(msg.value >= costToLockHash);
44         emit lockHashEvent(msg.sender, hash);
45     }
46     
47     
48     function lockHashProxy(address _addr, bytes32 hash, uint8 v, bytes32 r, bytes32 s) public payable {
49         require(ecrecover(hash, v, r, s) == _addr);
50         if (sproofAccounts[msg.sender] != true)
51             require(msg.value >= costToLockHash);
52         emit lockHashEvent(_addr, hash);
53     }
54  
55     function lockHashesProxy(address [] memory _addresses, bytes32 [] memory hashes, uint8[] memory vs, bytes32 [] memory rs, bytes32 [] memory ss) public payable {
56 
57         if (sproofAccounts[msg.sender] != true)
58             require(msg.value >= _addresses.length*costToLockHash);
59 
60         for (uint i=0; i < _addresses.length; i++) {
61             require(ecrecover(hashes[i], vs[i], rs[i], ss[i]) == _addresses[i]);
62             emit lockHashEvent(_addresses[i], hashes[i]);
63         }
64     }
65 
66     function payout() public{
67         require (msg.sender == owner);
68         owner.transfer(address(this).balance);
69     }
70 }