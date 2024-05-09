1 pragma solidity ^0.4.18;
2 
3 contract UserRegistryInterface {
4   event AddAddress(address indexed who);
5   event AddIdentity(address indexed who);
6 
7   function knownAddress(address _who) public constant returns(bool);
8   function hasIdentity(address _who) public constant returns(bool);
9   function systemAddresses(address _to, address _from) public constant returns(bool);
10 }
11 
12 contract MultiOwners {
13 
14     event AccessGrant(address indexed owner);
15     event AccessRevoke(address indexed owner);
16     
17     mapping(address => bool) owners;
18     address public publisher;
19 
20     function MultiOwners() public {
21         owners[msg.sender] = true;
22         publisher = msg.sender;
23     }
24 
25     modifier onlyOwner() { 
26         require(owners[msg.sender] == true);
27         _; 
28     }
29 
30     function isOwner() public constant returns (bool) {
31         return owners[msg.sender] ? true : false;
32     }
33 
34     function checkOwner(address maybe_owner) public constant returns (bool) {
35         return owners[maybe_owner] ? true : false;
36     }
37 
38     function grant(address _owner) onlyOwner public {
39         owners[_owner] = true;
40         AccessGrant(_owner);
41     }
42 
43     function revoke(address _owner) onlyOwner public {
44         require(_owner != publisher);
45         require(msg.sender != _owner);
46 
47         owners[_owner] = false;
48         AccessRevoke(_owner);
49     }
50 }
51 
52 contract UserRegistry is MultiOwners, UserRegistryInterface {
53   mapping (address => bool) internal addresses;
54   mapping (address => bool) internal identities;
55   mapping (address => bool) internal system;
56 
57   function addAddress(address _who) onlyOwner public returns(bool) {
58     require(!knownAddress(_who));
59     addresses[_who] = true;
60     AddAddress(_who);
61     return true;
62   }
63 
64   function addSystem(address _address) onlyOwner public returns(bool) {
65     system[_address] = true;
66     return true;
67   }
68 
69   function addIdentity(address _who) onlyOwner public returns(bool) {
70     require(!hasIdentity(_who));
71     if(!addresses[_who]) {
72       addresses[_who] = true;
73       AddAddress(_who);
74     }
75     identities[_who] = true;
76     AddIdentity(_who);
77     return true;
78   }
79   
80   function knownAddress(address _who) public constant returns(bool) {
81     return addresses[_who];
82   }
83 
84   function hasIdentity(address _who) public constant returns(bool) {
85     return knownAddress(_who) && identities[_who];
86   }
87 
88   function systemAddress(address _where) public constant returns(bool) {
89     return system[_where];
90   }
91 
92   function systemAddresses(address _to, address _from) public constant returns(bool) {
93     return systemAddress(_to) || systemAddress(_from);
94   }
95 }