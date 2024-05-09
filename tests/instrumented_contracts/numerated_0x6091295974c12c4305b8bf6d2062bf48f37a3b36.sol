1 // hevm: flattened sources of src/spell.sol
2 pragma solidity ^0.4.23;
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
107 ////// src/spell.sol
108 // spell.sol - An un-owned object that performs one action one time only
109 
110 // Copyright (C) 2017, 2018 DappHub, LLC
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
125 /* pragma solidity ^0.4.23; */
126 
127 /* import 'ds-exec/exec.sol'; */
128 /* import 'ds-note/note.sol'; */
129 
130 contract DSSpell is DSExec, DSNote {
131     address public whom;
132     uint256 public mana;
133     bytes   public data;
134     bool    public done;
135 
136     constructor(address whom_, uint256 mana_, bytes data_) public {
137         whom = whom_;
138         mana = mana_;
139         data = data_;
140     }
141     // Only marked 'done' if CALL succeeds (not exceptional condition).
142     function cast() public note {
143         require( !done );
144         exec(whom, data, mana);
145         done = true;
146     }
147 }