1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // GazeCoin Crowdsale Bonus List
5 //
6 // Deployed to : 
7 //
8 // Enjoy.
9 //
10 // (c) BokkyPooBah / Bok Consulting Pty Ltd for GazeCoin 2017. The MIT Licence.
11 // ----------------------------------------------------------------------------
12 
13 
14 // ----------------------------------------------------------------------------
15 // Owned contract
16 // ----------------------------------------------------------------------------
17 contract Owned {
18     address public owner;
19     address public newOwner;
20 
21     event OwnershipTransferred(address indexed _from, address indexed _to);
22 
23     modifier onlyOwner {
24         require(msg.sender == owner);
25         _;
26     }
27 
28     function Owned() public {
29         owner = msg.sender;
30     }
31     function transferOwnership(address _newOwner) public onlyOwner {
32         newOwner = _newOwner;
33     }
34     function acceptOwnership() public {
35         require(msg.sender == newOwner);
36         OwnershipTransferred(owner, newOwner);
37         owner = newOwner;
38         newOwner = address(0);
39     }
40 }
41 
42 
43 // ----------------------------------------------------------------------------
44 // Admin
45 // ----------------------------------------------------------------------------
46 contract Admined is Owned {
47     mapping (address => bool) public admins;
48 
49     event AdminAdded(address addr);
50     event AdminRemoved(address addr);
51 
52     modifier onlyAdmin() {
53         require(admins[msg.sender] || owner == msg.sender);
54         _;
55     }
56 
57     function addAdmin(address _addr) public onlyOwner {
58         require(!admins[_addr]);
59         admins[_addr] = true;
60         AdminAdded(_addr);
61     }
62     function removeAdmin(address _addr) public onlyOwner {
63         require(admins[_addr]);
64         delete admins[_addr];
65         AdminRemoved(_addr);
66     }
67 }
68 
69 
70 // ----------------------------------------------------------------------------
71 // Bonus list - Tiers 1, 2 and 3, with 0 as disabled
72 // ----------------------------------------------------------------------------
73 contract GazeCoinBonusList is Admined {
74     bool public sealed;
75     mapping(address => uint) public bonusList;
76 
77     event AddressListed(address indexed addr, uint tier);
78 
79     function GazeCoinBonusList() public {
80     }
81     function add(address[] addresses, uint tier) public onlyAdmin {
82         require(!sealed);
83         require(addresses.length != 0);
84         for (uint i = 0; i < addresses.length; i++) {
85             require(addresses[i] != address(0));
86             if (bonusList[addresses[i]] != tier) {
87                 bonusList[addresses[i]] = tier;
88                 AddressListed(addresses[i], tier);
89             }
90         }
91     }
92     function remove(address[] addresses) public onlyAdmin {
93         require(!sealed);
94         require(addresses.length != 0);
95         for (uint i = 0; i < addresses.length; i++) {
96             require(addresses[i] != address(0));
97             if (bonusList[addresses[i]] != 0) {
98                 bonusList[addresses[i]] = 0;
99                 AddressListed(addresses[i], 0);
100             }
101         }
102     }
103     function seal() public onlyOwner {
104         require(!sealed);
105         sealed = true;
106     }
107     function () public {
108         revert();
109     }
110 }