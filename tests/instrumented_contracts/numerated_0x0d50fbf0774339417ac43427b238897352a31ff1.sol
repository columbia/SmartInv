1 pragma solidity >=0.5.10;
2 
3 contract LibNote {
4     event LogNote(
5         bytes4   indexed  sig,
6         address  indexed  usr,
7         bytes32  indexed  arg1,
8         bytes32  indexed  arg2,
9         bytes             data
10     ) anonymous;
11 
12     modifier note {
13         _;
14         assembly {
15             // log an 'anonymous' event with a constant 6 words of calldata
16             // and four indexed topics: selector, caller, arg1 and arg2
17             let mark := msize                         // end of memory ensures zero
18             mstore(0x40, add(mark, 288))              // update free memory pointer
19             mstore(mark, 0x20)                        // bytes type data offset
20             mstore(add(mark, 0x20), 224)              // bytes size (padded)
21             calldatacopy(add(mark, 0x40), 0, 224)     // bytes payload
22             log4(mark, 288,                           // calldata
23                  shl(224, shr(224, calldataload(0))), // msg.sig
24                  caller,                              // msg.sender
25                  calldataload(4),                     // arg1
26                  calldataload(36)                     // arg2
27                 )
28         }
29     }
30 }
31 
32 contract Median is LibNote {
33 
34     // --- Auth ---
35     mapping (address => uint) public wards;
36     function rely(address usr) external note auth { wards[usr] = 1; }
37     function deny(address usr) external note auth { wards[usr] = 0; }
38     modifier auth {
39         require(wards[msg.sender] == 1, "Median/not-authorized");
40         _;
41     }
42 
43     uint128        val;
44     uint32  public age;
45     bytes32 public constant wat = "ethusd"; // You want to change this every deploy
46     uint256 public bar = 1;
47 
48     // Authorized oracles, set by an auth
49     mapping (address => uint256) public orcl;
50 
51     // Whitelisted contracts, set by an auth
52     mapping (address => uint256) public bud;
53 
54     // Mapping for at most 256 oracles
55     mapping (uint8 => address) public slot;
56 
57     modifier toll { require(bud[msg.sender] == 1, "Median/contract-not-whitelisted"); _;}
58 
59     event LogMedianPrice(uint256 val, uint256 age);
60 
61     //Set type of Oracle
62     constructor() public {
63         wards[msg.sender] = 1;
64     }
65 
66     function read() external view toll returns (uint256) {
67         require(val > 0, "Median/invalid-price-feed");
68         return val;
69     }
70 
71     function peek() external view toll returns (uint256,bool) {
72         return (val, val > 0);
73     }
74 
75     function recover(uint256 val_, uint256 age_, uint8 v, bytes32 r, bytes32 s) public pure returns (address) {
76         return ecrecover(
77             keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(abi.encodePacked(val_, age_, wat)))),
78             v, r, s
79         );
80     }
81 
82     function poke(
83         uint256[] calldata val_, uint256[] calldata age_,
84         uint8[] calldata v, bytes32[] calldata r, bytes32[] calldata s) external
85     {
86         require(val_.length == bar, "Median/bar-too-low");
87 
88         uint256 bloom = 0;
89         uint256 last = 0;
90         uint256 zzz = age;
91 
92         for (uint i = 0; i < val_.length; i++) {
93             // Validate the values were signed by an authorized oracle
94             address signer = recover(val_[i], age_[i], v[i], r[i], s[i]);
95             // Check that signer is an oracle
96             require(orcl[signer] == 1, "Median/invalid-oracle");
97             // Price feed age greater than last medianizer age
98             require(age_[i] > zzz, "Median/stale-message");
99             // Check for ordered values
100             require(val_[i] >= last, "Median/messages-not-in-order");
101             last = val_[i];
102             // Bloom filter for signer uniqueness
103             uint8 sl = uint8(uint256(signer) >> 152);
104             require((bloom >> sl) % 2 == 0, "Median/oracle-already-signed");
105             bloom += uint256(2) ** sl;
106         }
107 
108         val = uint128(val_[val_.length >> 1]);
109         age = uint32(block.timestamp);
110 
111         emit LogMedianPrice(val, age);
112     }
113 
114     function lift(address[] calldata a) external note auth {
115         for (uint i = 0; i < a.length; i++) {
116             require(a[i] != address(0), "Median/no-oracle-0");
117             uint8 s = uint8(uint256(a[i]) >> 152);
118             require(slot[s] == address(0), "Median/signer-already-exists");
119             orcl[a[i]] = 1;
120             slot[s] = a[i];
121         }
122     }
123 
124     function drop(address[] calldata a) external note auth {
125        for (uint i = 0; i < a.length; i++) {
126             orcl[a[i]] = 0;
127             slot[uint8(uint256(a[i]) >> 152)] = address(0);
128        }
129     }
130 
131     function setBar(uint256 bar_) external note auth {
132         require(bar_ > 0, "Median/quorum-is-zero");
133         require(bar_ % 2 != 0, "Median/quorum-not-odd-number");
134         bar = bar_;
135     }
136 
137     function kiss(address a) external note auth {
138         require(a != address(0), "Median/no-contract-0");
139         bud[a] = 1;
140     }
141 
142     function diss(address a) external note auth {
143         bud[a] = 0;
144     }
145 
146     function kiss(address[] calldata a) external note auth {
147         for(uint i = 0; i < a.length; i++) {
148             require(a[i] != address(0), "Median/no-contract-0");
149             bud[a[i]] = 1;
150         }
151     }
152 
153     function diss(address[] calldata a) external note auth {
154         for(uint i = 0; i < a.length; i++) {
155             bud[a[i]] = 0;
156         }
157     }
158 }
159 
160 contract MedianBTCRUB is Median {
161     bytes32 public constant wat = "BTCRUB";
162 
163     function recover(uint256 val_, uint256 age_, uint8 v, bytes32 r, bytes32 s) public pure returns (address) {
164         return ecrecover(
165             keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(abi.encodePacked(val_, age_, wat)))),
166             v, r, s
167         );
168     }
169 }