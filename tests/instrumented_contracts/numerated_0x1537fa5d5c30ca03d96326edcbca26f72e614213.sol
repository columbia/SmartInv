1 // hevm: flattened sources of src/fix.sol
2 pragma solidity >=0.4.23 >=0.5.0;
3 
4 ////// lib/ds-exec/src/exec.sol
5 // exec.sol - base contract used by anything that wants to do "untyped" calls
6 
7 // Copyright (C) 2019 Maker
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
22 /* pragma solidity >=0.4.23; */
23 
24 contract DSExec {
25     function tryExec( address target, bytes memory data, uint value)
26              internal
27              returns (bool ok)
28     {
29         assembly {
30             ok := call(gas, target, value, add(data, 0x20), mload(data), 0, 0)
31         }
32     }
33     function exec( address target, bytes memory data, uint value)
34              internal
35     {
36         if(!tryExec(target, data, value)) {
37             revert("ds-exec-call-failed");
38         }
39     }
40 
41     // Convenience aliases
42     function exec( address t, bytes memory c )
43         internal
44     {
45         exec(t, c, 0);
46     }
47     function exec( address t, uint256 v )
48         internal
49     {
50         bytes memory c; exec(t, c, v);
51     }
52     function tryExec( address t, bytes memory c )
53         internal
54         returns (bool)
55     {
56         return tryExec(t, c, 0);
57     }
58     function tryExec( address t, uint256 v )
59         internal
60         returns (bool)
61     {
62         bytes memory c; return tryExec(t, c, v);
63     }
64 }
65 
66 ////// src/fix.sol
67 // fix.sol - change authorities
68 
69 // Copyright (C) 2019 Mariano Conti, MakerDAO
70 
71 // This program is free software: you can redistribute it and/or modify
72 // it under the terms of the GNU General Public License as published by
73 // the Free Software Foundation, either version 3 of the License, or
74 // (at your option) any later version.
75 
76 // This program is distributed in the hope that it will be useful,
77 // but WITHOUT ANY WARRANTY; without even the implied warranty of
78 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
79 // GNU General Public License for more details.
80 
81 // You should have received a copy of the GNU General Public License
82 // along with this program. If not, see <http://www.gnu.org/licenses/>.
83 
84 /* pragma solidity >=0.5.0; */
85 
86 /* import "ds-exec/exec.sol"; */
87 
88 contract Fix is DSExec {
89 
90     address constant public MOM    = 0xF2C5369cFFb8Ea6284452b0326e326DbFdCb867C; // SaiMom
91     address constant public TOP    = 0x9b0ccf7C8994E19F39b2B4CF708e0A7DF65fA8a3; // SaiTop
92     address constant public PIP    = 0x729D19f657BD0614b4985Cf1D82531c67569197B; // Pip
93     address constant public PEP    = 0x5C1fc813d9c1B5ebb93889B3d63bA24984CA44B7; // Pep
94     address constant public MKRUSD = 0x99041F808D598B782D5a3e498681C2452A31da08; // MKR/USD
95     
96     address constant public CHIEF  = 0x9eF05f7F6deB616fd37aC3c959a2dDD25A54E4F5; // New Chief
97     
98     bool public done;
99 
100     function cast() public {
101         require(!done);
102 
103         bytes memory data = abi.encodeWithSignature("setAuthority(address)", CHIEF);
104         
105         exec(MOM, data, 0);
106         exec(TOP, data, 0);
107         
108         exec(PIP, data, 0);
109         exec(PEP, data, 0);
110         
111         exec(MKRUSD, data, 0);
112 
113         done = true;
114     }
115 }