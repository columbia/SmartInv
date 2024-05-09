1 pragma solidity ^0.4.17;
2 
3 // ----------------------------------------------------------------------------
4 // Devery Presale Whitelist
5 //
6 // Deployed to : 0x38E330C4330e743a4D82D93cdC826bAe78C6E7A6
7 //
8 // Enjoy.
9 //
10 // (c) BokkyPooBah / Bok Consulting Pty Ltd for Devery 2017. The MIT Licence.
11 // ----------------------------------------------------------------------------
12 
13 
14 // ----------------------------------------------------------------------------
15 // Owned contract
16 // ----------------------------------------------------------------------------
17 contract Owned {
18 
19     // ------------------------------------------------------------------------
20     // Current owner, and proposed new owner
21     // ------------------------------------------------------------------------
22     address public owner;
23     address public newOwner;
24 
25     // ------------------------------------------------------------------------
26     // Constructor - assign creator as the owner
27     // ------------------------------------------------------------------------
28     function Owned() public {
29         owner = msg.sender;
30     }
31 
32 
33     // ------------------------------------------------------------------------
34     // Modifier to mark that a function can only be executed by the owner
35     // ------------------------------------------------------------------------
36     modifier onlyOwner {
37         require(msg.sender == owner);
38         _;
39     }
40 
41 
42     // ------------------------------------------------------------------------
43     // Owner can initiate transfer of contract to a new owner
44     // ------------------------------------------------------------------------
45     function transferOwnership(address _newOwner) public onlyOwner {
46         newOwner = _newOwner;
47     }
48 
49 
50     // ------------------------------------------------------------------------
51     // New owner has to accept transfer of contract
52     // ------------------------------------------------------------------------
53     function acceptOwnership() public {
54         require(msg.sender == newOwner);
55         OwnershipTransferred(owner, newOwner);
56         owner = newOwner;
57         newOwner = 0x0;
58     }
59     event OwnershipTransferred(address indexed _from, address indexed _to);
60 }
61 
62 
63 // ----------------------------------------------------------------------------
64 // Administrators
65 // ----------------------------------------------------------------------------
66 contract Admined is Owned {
67 
68     // ------------------------------------------------------------------------
69     // Mapping of administrators
70     // ------------------------------------------------------------------------
71     mapping (address => bool) public admins;
72 
73     // ------------------------------------------------------------------------
74     // Add and delete adminstrator events
75     // ------------------------------------------------------------------------
76     event AdminAdded(address addr);
77     event AdminRemoved(address addr);
78 
79 
80     // ------------------------------------------------------------------------
81     // Modifier for functions that can only be executed by adminstrator
82     // ------------------------------------------------------------------------
83     modifier onlyAdmin() {
84         require(admins[msg.sender] || owner == msg.sender);
85         _;
86     }
87 
88 
89     // ------------------------------------------------------------------------
90     // Owner can add a new administrator
91     // ------------------------------------------------------------------------
92     function addAdmin(address addr) public onlyOwner {
93         admins[addr] = true;
94         AdminAdded(addr);
95     }
96 
97 
98     // ------------------------------------------------------------------------
99     // Owner can remove an administrator
100     // ------------------------------------------------------------------------
101     function removeAdmin(address addr) public onlyOwner {
102         delete admins[addr];
103         AdminRemoved(addr);
104     }
105 }
106 
107 
108 // ----------------------------------------------------------------------------
109 // Devery Presale Whitelist
110 // ----------------------------------------------------------------------------
111 contract DeveryPresaleWhitelist is Admined {
112 
113     // ------------------------------------------------------------------------
114     // Administrators can add until sealed
115     // ------------------------------------------------------------------------
116     bool public sealed;
117 
118     // ------------------------------------------------------------------------
119     // The whitelist of accounts and max contribution
120     // ------------------------------------------------------------------------
121     mapping(address => uint) public whitelist;
122 
123     // ------------------------------------------------------------------------
124     // Events
125     // ------------------------------------------------------------------------
126     event Whitelisted(address indexed addr, uint max);
127 
128 
129     // ------------------------------------------------------------------------
130     // Constructor
131     // ------------------------------------------------------------------------
132     function DeveryPresaleWhitelist() public {
133     }
134 
135 
136     // ------------------------------------------------------------------------
137     // Add to whitelist
138     // ------------------------------------------------------------------------
139     function add(address addr, uint max) public onlyAdmin {
140         require(!sealed);
141         require(addr != 0x0);
142         whitelist[addr] = max;
143         Whitelisted(addr, max);
144     }
145 
146 
147     // ------------------------------------------------------------------------
148     // Add batch to whitelist
149     // ------------------------------------------------------------------------
150     function multiAdd(address[] addresses, uint[] max) public onlyAdmin {
151         require(!sealed);
152         require(addresses.length != 0);
153         require(addresses.length == max.length);
154         for (uint i = 0; i < addresses.length; i++) {
155             require(addresses[i] != 0x0);
156             whitelist[addresses[i]] = max[i];
157             Whitelisted(addresses[i], max[i]);
158         }
159     }
160 
161 
162     // ------------------------------------------------------------------------
163     // After sealing, no more whitelisting is possible
164     // ------------------------------------------------------------------------
165     function seal() public onlyOwner {
166         require(!sealed);
167         sealed = true;
168     }
169 
170 
171     // ------------------------------------------------------------------------
172     // Don't accept ethers - no payable modifier
173     // ------------------------------------------------------------------------
174     function () public {
175     }
176 }