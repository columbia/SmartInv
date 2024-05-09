1 // Copyright (C) 2017-2020 Maker Ecosystem Growth Holdings, INC.
2 
3 // This program is free software: you can redistribute it and/or modify
4 // it under the terms of the GNU Affero General Public License as published by
5 // the Free Software Foundation, either version 3 of the License, or
6 // (at your option) any later version.
7 //
8 // This program is distributed in the hope that it will be useful,
9 // but WITHOUT ANY WARRANTY; without even the implied warranty of
10 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
11 // GNU Affero General Public License for more details.
12 //
13 // You should have received a copy of the GNU Affero General Public License
14 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
15 
16 pragma solidity >=0.5.10;
17 
18 contract LibNote {
19   event LogNote(
20     bytes4   indexed sig,
21     address  indexed usr,
22     bytes32  indexed arg1,
23     bytes32  indexed arg2,
24     bytes data
25   ) anonymous;
26 
27   modifier note {
28     _;
29     assembly {
30     // log an 'anonymous' event with a constant 6 words of calldata
31     // and four indexed topics: selector, caller, arg1 and arg2
32       let mark := msize()                         // end of memory ensures zero
33       mstore(0x40, add(mark, 288))                // update free memory pointer
34       mstore(mark, 0x20)                          // bytes type data offset
35       mstore(add(mark, 0x20), 224)                // bytes size (padded)
36       calldatacopy(add(mark, 0x40), 0, 224)       // bytes payload
37       log4(
38       mark, 288, // calldata
39       shl(224, shr(224, calldataload(0))), // msg.sig
40       caller(), // msg.sender
41       calldataload(4), // arg1
42       calldataload(36)                        // arg2
43       )
44     }
45   }
46 }
47 
48 contract MedianWSTETHUSD is LibNote {
49   mapping(address => uint) public wards;
50 
51   function rely(address usr) external note auth {wards[usr] = 1;}
52 
53   function deny(address usr) external note auth {wards[usr] = 0;}
54   modifier auth {
55     require(wards[msg.sender] == 1, "Median/not-authorized");
56     _;
57   }
58 
59   uint128        val;
60   uint32  public age;
61   bytes32 public constant wat = "WSTETHUSD";
62   uint256 public bar = 1;
63 
64   // Authorized oracles, set by an auth
65   mapping(address => uint256) public orcl;
66 
67   // Permitted contracts, set by an auth
68   mapping(address => uint256) public bud;
69 
70   // Mapping for at most 256 oracles
71   mapping(uint8 => address) public slot;
72 
73   modifier toll {
74     require(bud[msg.sender] == 1, "Median/contract-not-whitelisted");
75     _;
76   }
77 
78   event LogMedianPrice(uint256 val, uint256 age);
79 
80   //Set type of Oracle
81   constructor() public {
82     wards[msg.sender] = 1;
83   }
84 
85   function read() external view toll returns (uint256) {
86     require(val > 0, "Median/invalid-price-feed");
87     return val;
88   }
89 
90   function peek() external view toll returns (uint256, bool) {
91     return (val, val > 0);
92   }
93 
94   function recover(uint256 val_, uint256 age_, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
95     return ecrecover(
96       keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(abi.encodePacked(val_, age_, wat)))),
97       v, r, s
98     );
99   }
100 
101   function poke(
102     uint256[] calldata val_, uint256[] calldata age_,
103     uint8[] calldata v, bytes32[] calldata r, bytes32[] calldata s) external
104   {
105     require(val_.length == bar, "Median/bar-too-low");
106 
107     uint256 bloom = 0;
108     uint256 last = 0;
109     uint256 zzz = age;
110 
111     for (uint i = 0; i < val_.length; i++) {
112       // Validate the values were signed by an authorized oracle
113       address signer = recover(val_[i], age_[i], v[i], r[i], s[i]);
114       // Check that signer is an oracle
115       require(orcl[signer] == 1, "Median/invalid-oracle");
116       // Price feed age greater than last medianizer age
117       require(age_[i] > zzz, "Median/stale-message");
118       // Check for ordered values
119       require(val_[i] >= last, "Median/messages-not-in-order");
120       last = val_[i];
121       // Bloom filter for signer uniqueness
122       uint8 sl = uint8(uint256(signer) >> 152);
123       require((bloom >> sl) % 2 == 0, "Median/oracle-already-signed");
124       bloom += uint256(2) ** sl;
125     }
126 
127     val = uint128(val_[val_.length >> 1]);
128     age = uint32(block.timestamp);
129 
130     emit LogMedianPrice(val, age);
131   }
132 
133   function lift(address[] calldata a) external note auth {
134     for (uint i = 0; i < a.length; i++) {
135       require(a[i] != address(0), "Median/no-oracle-0");
136       uint8 s = uint8(uint256(a[i]) >> 152);
137       require(slot[s] == address(0), "Median/signer-already-exists");
138       orcl[a[i]] = 1;
139       slot[s] = a[i];
140     }
141   }
142 
143   function drop(address[] calldata a) external note auth {
144     for (uint i = 0; i < a.length; i++) {
145       orcl[a[i]] = 0;
146       slot[uint8(uint256(a[i]) >> 152)] = address(0);
147     }
148   }
149 
150   function setBar(uint256 bar_) external note auth {
151     require(bar_ > 0, "Median/quorum-is-zero");
152     require(bar_ % 2 != 0, "Median/quorum-not-odd-number");
153     bar = bar_;
154   }
155 
156   function kiss(address a) external note auth {
157     require(a != address(0), "Median/no-contract-0");
158     bud[a] = 1;
159   }
160 
161   function kiss(address[] calldata a) external note auth {
162     for (uint i = 0; i < a.length; i++) {
163       require(a[i] != address(0), "Median/no-contract-0");
164       bud[a[i]] = 1;
165     }
166   }
167 
168   function diss(address a) external note auth {
169     bud[a] = 0;
170   }
171 
172   function diss(address[] calldata a) external note auth {
173     for (uint i = 0; i < a.length; i++) {
174       bud[a[i]] = 0;
175     }
176   }
177 }