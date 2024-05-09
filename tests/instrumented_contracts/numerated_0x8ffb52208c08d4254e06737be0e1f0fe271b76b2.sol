1 // hevm: flattened sources of src/update.sol
2 pragma solidity ^0.4.24;
3 
4 ////// lib/ds-exec/src/exec.sol
5 // exec.sol - base contract used by anything that wants to do "untyped" calls
6 
7 // Copyright (C) 2017  DappHub, LLC
8 
9 // This program is free software: you can redistribute it and/or modify
10 // it under the terms of the GNU General Public License as published by
11 // the Free Software Foundation, either version 3 of the License, or
12 // (at your option) any later version.
13 
14 // This program is distributed in the hope that it will be useful,
15 // but WITHOUT ANY WARRANTY; without even the implied warranty of
16 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
17 // GNU General Public License for more details.
18 
19 // You should have received a copy of the GNU General Public License
20 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
21 
22 /* pragma solidity ^0.4.23; */
23 
24 contract DSExec {
25     function tryExec( address target, bytes calldata, uint value)
26              internal
27              returns (bool call_ret)
28     {
29         return target.call.value(value)(calldata);
30     }
31     function exec( address target, bytes calldata, uint value)
32              internal
33     {
34         if(!tryExec(target, calldata, value)) {
35             revert();
36         }
37     }
38 
39     // Convenience aliases
40     function exec( address t, bytes c )
41         internal
42     {
43         exec(t, c, 0);
44     }
45     function exec( address t, uint256 v )
46         internal
47     {
48         bytes memory c; exec(t, c, v);
49     }
50     function tryExec( address t, bytes c )
51         internal
52         returns (bool)
53     {
54         return tryExec(t, c, 0);
55     }
56     function tryExec( address t, uint256 v )
57         internal
58         returns (bool)
59     {
60         bytes memory c; return tryExec(t, c, v);
61     }
62 }
63 
64 ////// lib/ds-note/src/note.sol
65 /// note.sol -- the `note' modifier, for logging calls as events
66 
67 // This program is free software: you can redistribute it and/or modify
68 // it under the terms of the GNU General Public License as published by
69 // the Free Software Foundation, either version 3 of the License, or
70 // (at your option) any later version.
71 
72 // This program is distributed in the hope that it will be useful,
73 // but WITHOUT ANY WARRANTY; without even the implied warranty of
74 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
75 // GNU General Public License for more details.
76 
77 // You should have received a copy of the GNU General Public License
78 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
79 
80 /* pragma solidity ^0.4.23; */
81 
82 contract DSNote {
83     event LogNote(
84         bytes4   indexed  sig,
85         address  indexed  guy,
86         bytes32  indexed  foo,
87         bytes32  indexed  bar,
88         uint              wad,
89         bytes             fax
90     ) anonymous;
91 
92     modifier note {
93         bytes32 foo;
94         bytes32 bar;
95 
96         assembly {
97             foo := calldataload(4)
98             bar := calldataload(36)
99         }
100 
101         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
102 
103         _;
104     }
105 }
106 
107 ////// src/update.sol
108 // DaiUpdate.sol - increase debt ceiling and update oracles
109 
110 // Copyright (C) 2018 DappHub, LLC
111 
112 // This program is free software: you can redistribute it and/or modify
113 // it under the terms of the GNU General Public License as published by
114 // the Free Software Foundation, either version 3 of the License, or
115 // (at your option) any later version.
116 
117 // This program is distributed in the hope that it will be useful,
118 // but WITHOUT ANY WARRANTY; without even the implied warranty of
119 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
120 // GNU General Public License for more details.
121 
122 // You should have received a copy of the GNU General Public License
123 // along with this program. If not, see <http://www.gnu.org/licenses/>.
124 
125 /* pragma solidity ^0.4.24; */
126 
127 /* import "ds-exec/exec.sol"; */
128 /* import "ds-note/note.sol"; */
129 
130 contract DaiUpdate is DSExec, DSNote {
131 
132     uint256 constant public CAP    = 100000000 * 10 ** 18; // 100,000,000 DAI
133     address constant public MOM    = 0xF2C5369cFFb8Ea6284452b0326e326DbFdCb867C; // SaiMom
134     address constant public PIP    = 0x40C449c0b74eA531371290115296e7E28b99cf0f; // ETH/USD OSM
135     address constant public PEP    = 0x5C1fc813d9c1B5ebb93889B3d63bA24984CA44B7; // MKR/USD OSM
136     address constant public MKRUSD = 0x99041F808D598B782D5a3e498681C2452A31da08; // MKR/USD Medianizer
137     address constant public FEED1  = 0xa3E22729A22a8fFEdccBbD614B7430615976E463; // New MKR Feed 1
138     address constant public FEED2  = 0x1ec3140C163b6fee00833Ba8ae30A7ba12201063; // New MKR Feed 2
139 
140     bool public done;
141 
142     function run() public note {
143         require(!done);
144         // increase cap to 100,000,000
145         exec(MOM, abi.encodeWithSignature("setCap(uint256)", CAP), 0);
146        
147         // set PIP to be the new ETH/USD OSM
148         exec(MOM, abi.encodeWithSignature("setPip(address)", PIP), 0);
149         
150         // set PEP to be the new MKR/USD OSM
151         exec(MOM, abi.encodeWithSignature("setPep(address)", PEP), 0);
152 
153         // Set 2 new feeds for MKR/USD Medianizer
154         exec(MKRUSD, abi.encodeWithSignature("set(address)", FEED1), 0);
155         exec(MKRUSD, abi.encodeWithSignature("set(address)", FEED2), 0);
156         
157         // Set MKR/USD Medianizer to be 3/5 feeds
158         exec(MKRUSD, abi.encodeWithSignature("setMin(uint96)", 3), 0);
159 
160         done = true;
161     }
162 }