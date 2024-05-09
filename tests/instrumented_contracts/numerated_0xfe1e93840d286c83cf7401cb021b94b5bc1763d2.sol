1 // hevm: flattened sources of src/median.sol
2 
3 pragma solidity >=0.5.10;
4 
5 ////// src/median.sol
6 /// median.sol
7 
8 // Copyright (C) 2017-2020 Maker Ecosystem Growth Holdings, INC.
9 
10 // This program is free software: you can redistribute it and/or modify
11 // it under the terms of the GNU Affero General Public License as published by
12 // the Free Software Foundation, either version 3 of the License, or
13 // (at your option) any later version.
14 //
15 // This program is distributed in the hope that it will be useful,
16 // but WITHOUT ANY WARRANTY; without even the implied warranty of
17 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
18 // GNU Affero General Public License for more details.
19 //
20 // You should have received a copy of the GNU Affero General Public License
21 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
22 
23 /* pragma solidity >=0.5.10; */
24 
25 contract LibNote {
26     event LogNote(
27         bytes4   indexed  sig,
28         address  indexed  usr,
29         bytes32  indexed  arg1,
30         bytes32  indexed  arg2,
31         bytes             data
32     ) anonymous;
33 
34     modifier note {
35         _;
36         assembly {
37             // log an 'anonymous' event with a constant 6 words of calldata
38             // and four indexed topics: selector, caller, arg1 and arg2
39             let mark := msize()                         // end of memory ensures zero
40             mstore(0x40, add(mark, 288))              // update free memory pointer
41             mstore(mark, 0x20)                        // bytes type data offset
42             mstore(add(mark, 0x20), 224)              // bytes size (padded)
43             calldatacopy(add(mark, 0x40), 0, 224)     // bytes payload
44             log4(mark, 288,                           // calldata
45                  shl(224, shr(224, calldataload(0))), // msg.sig
46                  caller(),                              // msg.sender
47                  calldataload(4),                     // arg1
48                  calldataload(36)                     // arg2
49                 )
50         }
51     }
52 }
53 
54 contract Median is LibNote {
55 
56     // --- Auth ---
57     mapping (address => uint) public wards;
58     function rely(address usr) external note auth { wards[usr] = 1; }
59     function deny(address usr) external note auth { wards[usr] = 0; }
60     modifier auth {
61         require(wards[msg.sender] == 1, "Median/not-authorized");
62         _;
63     }
64 
65     uint128        val;
66     uint32  public age;
67     bytes32 public constant wat = "ethusd"; // You want to change this every deploy
68     uint256 public bar = 1;
69 
70     // Authorized oracles, set by an auth
71     mapping (address => uint256) public orcl;
72 
73     // Whitelisted contracts, set by an auth
74     mapping (address => uint256) public bud;
75 
76     // Mapping for at most 256 oracles
77     mapping (uint8 => address) public slot;
78 
79     modifier toll { require(bud[msg.sender] == 1, "Median/contract-not-whitelisted"); _;}
80 
81     event LogMedianPrice(uint256 val, uint256 age);
82 
83     //Set type of Oracle
84     constructor() public {
85         wards[msg.sender] = 1;
86     }
87 
88     function read() external view toll returns (uint256) {
89         require(val > 0, "Median/invalid-price-feed");
90         return val;
91     }
92 
93     function peek() external view toll returns (uint256,bool) {
94         return (val, val > 0);
95     }
96 
97     function recover(uint256 val_, uint256 age_, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
98         return ecrecover(
99             keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(abi.encodePacked(val_, age_, wat)))),
100             v, r, s
101         );
102     }
103 
104     function poke(
105         uint256[] calldata val_, uint256[] calldata age_,
106         uint8[] calldata v, bytes32[] calldata r, bytes32[] calldata s) external
107     {
108         require(val_.length == bar, "Median/bar-too-low");
109 
110         uint256 bloom = 0;
111         uint256 last = 0;
112         uint256 zzz = age;
113 
114         for (uint i = 0; i < val_.length; i++) {
115             // Validate the values were signed by an authorized oracle
116             address signer = recover(val_[i], age_[i], v[i], r[i], s[i]);
117             // Check that signer is an oracle
118             require(orcl[signer] == 1, "Median/invalid-oracle");
119             // Price feed age greater than last medianizer age
120             require(age_[i] > zzz, "Median/stale-message");
121             // Check for ordered values
122             require(val_[i] >= last, "Median/messages-not-in-order");
123             last = val_[i];
124             // Bloom filter for signer uniqueness
125             uint8 sl = uint8(uint256(signer) >> 152);
126             require((bloom >> sl) % 2 == 0, "Median/oracle-already-signed");
127             bloom += uint256(2) ** sl;
128         }
129 
130         val = uint128(val_[val_.length >> 1]);
131         age = uint32(block.timestamp);
132 
133         emit LogMedianPrice(val, age);
134     }
135 
136     function lift(address[] calldata a) external note auth {
137         for (uint i = 0; i < a.length; i++) {
138             require(a[i] != address(0), "Median/no-oracle-0");
139             uint8 s = uint8(uint256(a[i]) >> 152);
140             require(slot[s] == address(0), "Median/signer-already-exists");
141             orcl[a[i]] = 1;
142             slot[s] = a[i];
143         }
144     }
145 
146     function drop(address[] calldata a) external note auth {
147        for (uint i = 0; i < a.length; i++) {
148             orcl[a[i]] = 0;
149             slot[uint8(uint256(a[i]) >> 152)] = address(0);
150        }
151     }
152 
153     function setBar(uint256 bar_) external note auth {
154         require(bar_ > 0, "Median/quorum-is-zero");
155         require(bar_ % 2 != 0, "Median/quorum-not-odd-number");
156         bar = bar_;
157     }
158 
159     function kiss(address a) external note auth {
160         require(a != address(0), "Median/no-contract-0");
161         bud[a] = 1;
162     }
163 
164     function diss(address a) external note auth {
165         bud[a] = 0;
166     }
167 
168     function kiss(address[] calldata a) external note auth {
169         for(uint i = 0; i < a.length; i++) {
170             require(a[i] != address(0), "Median/no-contract-0");
171             bud[a[i]] = 1;
172         }
173     }
174 
175     function diss(address[] calldata a) external note auth {
176         for(uint i = 0; i < a.length; i++) {
177             bud[a[i]] = 0;
178         }
179     }
180 }
181 
182 contract MedianMATICUSD is Median {
183     bytes32 public constant wat = "MATICUSD";
184 
185     function recover(uint256 val_, uint256 age_, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
186         return ecrecover(
187             keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(abi.encodePacked(val_, age_, wat)))),
188             v, r, s
189         );
190     }
191 }