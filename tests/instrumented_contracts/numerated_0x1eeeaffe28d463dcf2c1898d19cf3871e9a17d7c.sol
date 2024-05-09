1 pragma solidity ^0.4.24;
2 
3 contract SNOVToken {
4     function transfer(address _to, uint256 _value) public returns (bool success);
5 }
6 
7 contract MultiOwnable {
8 
9     mapping(address => bool) ownerMap;
10     address[] public owners;
11 
12     event OwnerAdded(address indexed _newOwner);
13     event OwnerRemoved(address indexed _oldOwner);
14 
15     modifier onlyOwner() {
16         require(isOwner(msg.sender));
17         _;
18     }
19 
20     constructor() public {
21         // Add default owner
22         address owner = msg.sender;
23         ownerMap[owner] = true;
24         owners.push(owner);
25     }
26 
27     function ownerCount() public constant returns (uint256) {
28         return owners.length;
29     }
30 
31     function isOwner(address owner) public constant returns (bool) {
32         return ownerMap[owner];
33     }
34 
35     function addOwner(address owner) public onlyOwner returns (bool) {
36         if (!isOwner(owner) && owner != 0) {
37             ownerMap[owner] = true;
38             owners.push(owner);
39 
40             emit OwnerAdded(owner);
41             return true;
42         } else return false;
43     }
44 
45     function removeOwner(address owner) public onlyOwner returns (bool) {
46         if (isOwner(owner)) {
47             ownerMap[owner] = false;
48             for (uint i = 0; i < owners.length - 1; i++) {
49                 if (owners[i] == owner) {
50                     owners[i] = owners[owners.length - 1];
51                     break;
52                 }
53             }
54             owners.length -= 1;
55 
56             emit OwnerRemoved(owner);
57             return true;
58         } else return false;
59     }
60 }
61 
62 contract MultiTransfer is MultiOwnable {
63     
64     function MultiTransaction(address _tokenAddress, address[] _addresses, uint256[] _values) public onlyOwner {
65         SNOVToken token = SNOVToken(_tokenAddress);
66         for (uint256 i = 0; i < _addresses.length; i++) {
67             token.transfer(_addresses[i], _values[i]);
68         }
69     }
70 }