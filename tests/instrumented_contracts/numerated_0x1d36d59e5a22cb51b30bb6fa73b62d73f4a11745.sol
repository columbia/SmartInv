1 /// median.sol
2 
3 // Copyright (C) 2017-2020 Maker Ecosystem Growth Holdings, INC.
4 
5 // This program is free software: you can redistribute it and/or modify
6 // it under the terms of the GNU Affero General Public License as published by
7 // the Free Software Foundation, either version 3 of the License, or
8 // (at your option) any later version.
9 //
10 // This program is distributed in the hope that it will be useful,
11 // but WITHOUT ANY WARRANTY; without even the implied warranty of
12 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
13 // GNU Affero General Public License for more details.
14 //
15 // You should have received a copy of the GNU Affero General Public License
16 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
17 
18 pragma solidity >=0.5.10;
19 
20 contract LibNote {
21     event LogNote(
22         bytes4   indexed  sig,
23         address  indexed  usr,
24         bytes32  indexed  arg1,
25         bytes32  indexed  arg2,
26         bytes             data
27     ) anonymous;
28 
29     modifier note {
30         _;
31         assembly {
32             // log an 'anonymous' event with a constant 6 words of calldata
33             // and four indexed topics: selector, caller, arg1 and arg2
34             let mark := msize()                         // end of memory ensures zero
35             mstore(0x40, add(mark, 288))              // update free memory pointer
36             mstore(mark, 0x20)                        // bytes type data offset
37             mstore(add(mark, 0x20), 224)              // bytes size (padded)
38             calldatacopy(add(mark, 0x40), 0, 224)     // bytes payload
39             log4(mark, 288,                           // calldata
40                  shl(224, shr(224, calldataload(0))), // msg.sig
41                  caller(),                              // msg.sender
42                  calldataload(4),                     // arg1
43                  calldataload(36)                     // arg2
44                 )
45         }
46     }
47 }
48 
49 contract Median is LibNote {
50 
51     // --- Auth ---
52     mapping (address => uint) public wards;
53     function rely(address usr) external note auth { wards[usr] = 1; }
54     function deny(address usr) external note auth { wards[usr] = 0; }
55     modifier auth {
56         require(wards[msg.sender] == 1, "Median/not-authorized");
57         _;
58     }
59 
60     uint128        val;
61     uint32  public age;
62     bytes32 public constant wat = "BALUSD"; // You want to change this every deploy
63     uint256 public bar = 1;
64 
65     // Authorized oracles, set by an auth
66     mapping (address => uint256) public orcl;
67 
68     // Whitelisted contracts, set by an auth
69     mapping (address => uint256) public bud;
70 
71     // Mapping for at most 256 oracles
72     mapping (uint8 => address) public slot;
73 
74     modifier toll { require(bud[msg.sender] == 1, "Median/contract-not-whitelisted"); _;}
75 
76     event LogMedianPrice(uint256 val, uint256 age);
77 
78     //Set type of Oracle
79     constructor() public {
80         wards[msg.sender] = 1;
81     }
82 
83     function read() external view toll returns (uint256) {
84         require(val > 0, "Median/invalid-price-feed");
85         return val;
86     }
87 
88     function peek() external view toll returns (uint256,bool) {
89         return (val, val > 0);
90     }
91 
92     function recover(uint256 val_, uint256 age_, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
93         return ecrecover(
94             keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(abi.encodePacked(val_, age_, wat)))),
95             v, r, s
96         );
97     }
98 
99     function poke(
100         uint256[] calldata val_, uint256[] calldata age_,
101         uint8[] calldata v, bytes32[] calldata r, bytes32[] calldata s) external
102     {
103         require(val_.length == bar, "Median/bar-too-low");
104 
105         uint256 bloom = 0;
106         uint256 last = 0;
107         uint256 zzz = age;
108 
109         for (uint i = 0; i < val_.length; i++) {
110             // Validate the values were signed by an authorized oracle
111             address signer = recover(val_[i], age_[i], v[i], r[i], s[i]);
112             // Check that signer is an oracle
113             require(orcl[signer] == 1, "Median/invalid-oracle");
114             // Price feed age greater than last medianizer age
115             require(age_[i] > zzz, "Median/stale-message");
116             // Check for ordered values
117             require(val_[i] >= last, "Median/messages-not-in-order");
118             last = val_[i];
119             // Bloom filter for signer uniqueness
120             uint8 sl = uint8(uint256(signer) >> 152);
121             require((bloom >> sl) % 2 == 0, "Median/oracle-already-signed");
122             bloom += uint256(2) ** sl;
123         }
124 
125         val = uint128(val_[val_.length >> 1]);
126         age = uint32(block.timestamp);
127 
128         emit LogMedianPrice(val, age);
129     }
130 
131     function lift(address[] calldata a) external note auth {
132         for (uint i = 0; i < a.length; i++) {
133             require(a[i] != address(0), "Median/no-oracle-0");
134             uint8 s = uint8(uint256(a[i]) >> 152);
135             require(slot[s] == address(0), "Median/signer-already-exists");
136             orcl[a[i]] = 1;
137             slot[s] = a[i];
138         }
139     }
140 
141     function drop(address[] calldata a) external note auth {
142        for (uint i = 0; i < a.length; i++) {
143             orcl[a[i]] = 0;
144             slot[uint8(uint256(a[i]) >> 152)] = address(0);
145        }
146     }
147 
148     function setBar(uint256 bar_) external note auth {
149         require(bar_ > 0, "Median/quorum-is-zero");
150         require(bar_ % 2 != 0, "Median/quorum-not-odd-number");
151         bar = bar_;
152     }
153 
154     function kiss(address a) external note auth {
155         require(a != address(0), "Median/no-contract-0");
156         bud[a] = 1;
157     }
158 
159     function diss(address a) external note auth {
160         bud[a] = 0;
161     }
162 
163     function kiss(address[] calldata a) external note auth {
164         for(uint i = 0; i < a.length; i++) {
165             require(a[i] != address(0), "Median/no-contract-0");
166             bud[a[i]] = 1;
167         }
168     }
169 
170     function diss(address[] calldata a) external note auth {
171         for(uint i = 0; i < a.length; i++) {
172             bud[a[i]] = 0;
173         }
174     }
175 }