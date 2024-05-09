1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 
3 /// DssAutoLine.sol
4 
5 // Copyright (C) 2018-2020 Maker Ecosystem Growth Holdings, INC.
6 
7 // This program is free software: you can redistribute it and/or modify
8 // it under the terms of the GNU Affero General Public License as published by
9 // the Free Software Foundation, either version 3 of the License, or
10 // (at your option) any later version.
11 //
12 // This program is distributed in the hope that it will be useful,
13 // but WITHOUT ANY WARRANTY; without even the implied warranty of
14 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
15 // GNU Affero General Public License for more details.
16 //
17 // You should have received a copy of the GNU Affero General Public License
18 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
19 
20 pragma solidity ^0.6.11;
21 
22 interface VatLike {
23     function ilks(bytes32) external view returns (uint256, uint256, uint256, uint256, uint256);
24     function Line() external view returns (uint256);
25     function file(bytes32, uint256) external;
26     function file(bytes32, bytes32, uint256) external;
27 }
28 
29 contract DssAutoLine {
30     /*** Data ***/
31     struct Ilk {
32         uint256   line;  // Max ceiling possible                                               [rad]
33         uint256    gap;  // Max Value between current debt and line to be set                  [rad]
34         uint48     ttl;  // Min time to pass before a new increase                             [seconds]
35         uint48    last;  // Last block the ceiling was updated                                 [blocks]
36         uint48 lastInc;  // Last time the ceiling was increased compared to its previous value [seconds]
37     }
38 
39     mapping (bytes32 => Ilk)     public ilks;
40     mapping (address => uint256) public wards;
41 
42     VatLike immutable public vat;
43 
44     /*** Events ***/
45     event Rely(address indexed usr);
46     event Deny(address indexed usr);
47     event Setup(bytes32 indexed ilk, uint256 line, uint256 gap, uint256 ttl);
48     event Remove(bytes32 indexed ilk);
49     event Exec(bytes32 indexed ilk, uint256 line, uint256 lineNew);
50 
51     /*** Init ***/
52     constructor(address vat_) public {
53         vat = VatLike(vat_);
54         wards[msg.sender] = 1;
55         emit Rely(msg.sender);
56     }
57 
58     /*** Math ***/
59     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
60         require((z = x + y) >= x);
61     }
62     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
63         require((z = x - y) <= x);
64     }
65     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
66         require(y == 0 || (z = x * y) / y == x);
67     }
68     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
69         return x <= y ? x : y;
70     }
71 
72     /*** Administration ***/
73 
74     /**
75         @dev Add or update an ilk
76         @param ilk    Collateral type (ex. ETH-A)
77         @param line   Collateral maximum debt ceiling that can be configured [RAD]
78         @param gap    Amount of collateral to step [RAD]
79         @param ttl    Minimum time between increase [seconds]
80     */
81     function setIlk(bytes32 ilk, uint256 line, uint256 gap, uint256 ttl) external auth {
82         require(ttl  < uint48(-1), "DssAutoLine/invalid-ttl");
83         require(line > 0,          "DssAutoLine/invalid-line");
84         ilks[ilk] = Ilk(line, gap, uint48(ttl), 0, 0);
85         emit Setup(ilk, line, gap, ttl);
86     }
87 
88     /**
89         @dev Remove an ilk
90         @param ilk    Collateral type (ex. ETH-A)
91     */
92     function remIlk(bytes32 ilk) external auth {
93         delete ilks[ilk];
94         emit Remove(ilk);
95     }
96 
97     function rely(address usr) external auth {
98         wards[usr] = 1;
99         emit Rely(usr);
100     }
101 
102     function deny(address usr) external auth {
103         wards[usr] = 0;
104         emit Deny(usr);
105     }
106 
107     modifier auth {
108         require(wards[msg.sender] == 1, "DssAutoLine/not-authorized");
109         _;
110     }
111 
112     /*** Auto-Line Update ***/
113     // @param  _ilk  The bytes32 ilk tag to adjust (ex. "ETH-A")
114     // @return       The ilk line value as uint256
115     function exec(bytes32 _ilk) external returns (uint256) {
116         (uint256 Art, uint256 rate,, uint256 line,) = vat.ilks(_ilk);
117         uint256 ilkLine = ilks[_ilk].line;
118 
119         // Return if the ilk is not enabled
120         if (ilkLine == 0) return line;
121 
122         // 1 SLOAD
123         uint48 ilkTtl     = ilks[_ilk].ttl;
124         uint48 ilkLast    = ilks[_ilk].last;
125         uint48 ilkLastInc = ilks[_ilk].lastInc;
126         //
127 
128         // Return if there was already an update in the same block
129         if (ilkLast == block.number) return line;
130 
131         // Calculate collateral debt
132         uint256 debt = mul(Art, rate);
133 
134         uint256 ilkGap  = ilks[_ilk].gap;
135 
136         // Calculate new line based on the minimum between the maximum line and actual collateral debt + gap
137         uint256 lineNew = min(add(debt, ilkGap), ilkLine);
138 
139         // Short-circuit if there wasn't an update or if the time since last increment has not passed
140         if (lineNew == line || lineNew > line && block.timestamp < add(ilkLastInc, ilkTtl)) return line;
141 
142         // Set collateral debt ceiling
143         vat.file(_ilk, "line", lineNew);
144         // Set general debt ceiling
145         vat.file("Line", add(sub(vat.Line(), line), lineNew));
146 
147         // Update lastInc if it is an increment in the debt ceiling
148         // and update last whatever the update is
149         if (lineNew > line) {
150             // 1 SSTORE
151             ilks[_ilk].lastInc = uint48(block.timestamp);
152             ilks[_ilk].last    = uint48(block.number);
153             //
154         } else {
155             ilks[_ilk].last    = uint48(block.number);
156         }
157 
158         emit Exec(_ilk, line, lineNew);
159 
160         return lineNew;
161     }
162 }