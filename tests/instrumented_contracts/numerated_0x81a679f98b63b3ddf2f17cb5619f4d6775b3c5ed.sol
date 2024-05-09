1 // Verified using https://dapp.tools
2 
3 // hevm: flattened sources of src/median.sol
4 pragma solidity >=0.4.23 >=0.5.10;
5 
6 ////// src/median.sol
7 /* pragma solidity >=0.5.10; */
8 
9 contract LibNote {
10     event LogNote(
11         bytes4   indexed  sig,
12         address  indexed  usr,
13         bytes32  indexed  arg1,
14         bytes32  indexed  arg2,
15         bytes             data
16     ) anonymous;
17 
18     modifier note {
19         _;
20         assembly {
21             // log an 'anonymous' event with a constant 6 words of calldata
22             // and four indexed topics: selector, caller, arg1 and arg2
23             let mark := msize                         // end of memory ensures zero
24             mstore(0x40, add(mark, 288))              // update free memory pointer
25             mstore(mark, 0x20)                        // bytes type data offset
26             mstore(add(mark, 0x20), 224)              // bytes size (padded)
27             calldatacopy(add(mark, 0x40), 0, 224)     // bytes payload
28             log4(mark, 288,                           // calldata
29                  shl(224, shr(224, calldataload(0))), // msg.sig
30                  caller,                              // msg.sender
31                  calldataload(4),                     // arg1
32                  calldataload(36)                     // arg2
33                 )
34         }
35     }
36 }
37 
38 contract Median is LibNote {
39 
40     // --- Auth ---
41     mapping (address => uint) public wards;
42     function rely(address usr) external note auth { wards[usr] = 1; }
43     function deny(address usr) external note auth { wards[usr] = 0; }
44     modifier auth {
45         require(wards[msg.sender] == 1, "Median/not-authorized");
46         _;
47     }
48 
49     uint128        val;
50     uint32  public age;
51     bytes32 public constant wat = "ethusd"; // You want to change this every deploy
52     uint256 public bar = 1;
53 
54     // Authorized oracles, set by an auth
55     mapping (address => uint256) public orcl;
56 
57     // Whitelisted contracts, set by an auth
58     mapping (address => uint256) public bud;
59 
60     // Mapping for at most 256 oracles
61     mapping (uint8 => address) public slot;
62 
63     modifier toll { require(bud[msg.sender] == 1, "Median/contract-not-whitelisted"); _;}
64 
65     event LogMedianPrice(uint256 val, uint256 age);
66 
67     //Set type of Oracle
68     constructor() public {
69         wards[msg.sender] = 1;
70     }
71 
72     function read() external view toll returns (uint256) {
73         require(val > 0, "Median/invalid-price-feed");
74         return val;
75     }
76 
77     function peek() external view toll returns (uint256,bool) {
78         return (val, val > 0);
79     }
80 
81     function recover(uint256 val_, uint256 age_, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
82         return ecrecover(
83             keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(abi.encodePacked(val_, age_, wat)))),
84             v, r, s
85         );
86     }
87 
88     function poke(
89         uint256[] calldata val_, uint256[] calldata age_,
90         uint8[] calldata v, bytes32[] calldata r, bytes32[] calldata s) external
91     {
92         require(val_.length == bar, "Median/bar-too-low");
93 
94         uint256 bloom = 0;
95         uint256 last = 0;
96         uint256 zzz = age;
97 
98         for (uint i = 0; i < val_.length; i++) {
99             // Validate the values were signed by an authorized oracle
100             address signer = recover(val_[i], age_[i], v[i], r[i], s[i]);
101             // Check that signer is an oracle
102             require(orcl[signer] == 1, "Median/invalid-oracle");
103             // Price feed age greater than last medianizer age
104             require(age_[i] > zzz, "Median/stale-message");
105             // Check for ordered values
106             require(val_[i] >= last, "Median/messages-not-in-order");
107             last = val_[i];
108             // Bloom filter for signer uniqueness
109             uint8 sl = uint8(uint256(signer) >> 152);
110             require((bloom >> sl) % 2 == 0, "Median/oracle-already-signed");
111             bloom += uint256(2) ** sl;
112         }
113 
114         val = uint128(val_[val_.length >> 1]);
115         age = uint32(block.timestamp);
116 
117         emit LogMedianPrice(val, age);
118     }
119 
120     function lift(address[] calldata a) external note auth {
121         for (uint i = 0; i < a.length; i++) {
122             require(a[i] != address(0), "Median/no-oracle-0");
123             uint8 s = uint8(uint256(a[i]) >> 152);
124             require(slot[s] == address(0), "Median/signer-already-exists");
125             orcl[a[i]] = 1;
126             slot[s] = a[i];
127         }
128     }
129 
130     function drop(address[] calldata a) external note auth {
131        for (uint i = 0; i < a.length; i++) {
132             orcl[a[i]] = 0;
133             slot[uint8(uint256(a[i]) >> 152)] = address(0);
134        }
135     }
136 
137     function setBar(uint256 bar_) external note auth {
138         require(bar_ > 0, "Median/quorum-is-zero");
139         require(bar_ % 2 != 0, "Median/quorum-not-odd-number");
140         bar = bar_;
141     }
142 
143     function kiss(address a) external note auth {
144         require(a != address(0), "Median/no-contract-0");
145         bud[a] = 1;
146     }
147 
148     function diss(address a) external note auth {
149         bud[a] = 0;
150     }
151 
152     function kiss(address[] calldata a) external note auth {
153         for(uint i = 0; i < a.length; i++) {
154             require(a[i] != address(0), "Median/no-contract-0");
155             bud[a[i]] = 1;
156         }
157     }
158 
159     function diss(address[] calldata a) external note auth {
160         for(uint i = 0; i < a.length; i++) {
161             bud[a[i]] = 0;
162         }
163     }
164 }
165 
166 contract MedianETHBTC is Median {
167     bytes32 public constant wat = "ETHBTC";
168 
169     function recover(uint256 val_, uint256 age_, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
170         return ecrecover(
171             keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(abi.encodePacked(val_, age_, wat)))),
172             v, r, s
173         );
174     }
175 }
