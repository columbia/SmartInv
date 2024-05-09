1 pragma solidity ^0.4.17;
2 
3 contract ExtendData {
4     
5    struct User {
6         bytes32 username;
7         bool verified;
8     }
9 
10     modifier onlyOwners {
11         require(owners[msg.sender]);
12         _;
13     }
14 
15     mapping(bytes32 => address) usernameToAddress;
16     mapping(bytes32 => address) queryToAddress;
17     mapping(address => mapping(bytes32 => uint)) tips;
18     mapping(address => mapping(bytes32 => uint)) lastTip;
19     mapping(bytes32 => uint) balances;
20     mapping(address => User) users;   
21     mapping(address => bool) owners;
22     
23     function ExtendData() public {
24         owners[msg.sender] = true;
25     }
26     
27     //getters
28     function getAddressForUsername(bytes32 _username) public constant onlyOwners returns (address) {
29         return usernameToAddress[_username];
30     }
31 
32     function getAddressForQuery(bytes32 _queryId) public constant onlyOwners returns (address) {
33         return queryToAddress[_queryId];
34     }
35     
36     function getBalanceForUser(bytes32 _username) public constant onlyOwners returns (uint) {
37         return balances[_username];
38     }
39     
40     function getUserVerified(address _address) public constant onlyOwners returns (bool) {
41         return users[_address].verified;
42     }
43     
44     function getUserUsername(address _address) public constant onlyOwners returns (bytes32) {
45         return users[_address].username;
46     }
47 
48     function getTip(address _from, bytes32 _to) public constant onlyOwners  returns (uint) {
49         return tips[_from][_to];
50     }
51   
52     function getLastTipTime(address _from, bytes32 _to) public constant onlyOwners returns (uint) {
53         return lastTip[_from][_to];
54     }
55 
56     //setters
57     function setQueryIdForAddress(bytes32 _queryId, address _address) public onlyOwners {
58         queryToAddress[_queryId] = _address;
59     }
60    
61     function setBalanceForUser(bytes32 _username, uint _balance) public onlyOwners {
62         balances[_username] = _balance;
63     }
64  
65     function setUsernameForAddress(bytes32 _username, address _address) public onlyOwners {
66         usernameToAddress[_username] = _address;
67     }
68 
69     function setVerified(address _address) public onlyOwners {
70         users[_address].verified = true;
71     }
72 
73     function addTip(address _from, bytes32 _to, uint _tip) public onlyOwners {
74         tips[_from][_to] += _tip;
75         balances[_to] += _tip;
76         lastTip[_from][_to] = now;     
77     }
78 
79     function addUser(address _address, bytes32 _username) public onlyOwners {
80         users[_address] = User({
81                 username: _username,
82                 verified: false
83             });
84     }
85 
86     function removeTip(address _from, bytes32 _to) public onlyOwners {
87         balances[_to] -= tips[_from][_to];
88         tips[_from][_to] = 0;
89     }
90     
91     //owner modification
92     function addOwner(address _address) public onlyOwners {
93         owners[_address] = true;
94     }
95     
96     function removeOwner(address _address) public onlyOwners {
97         owners[_address] = false;
98     }
99 }