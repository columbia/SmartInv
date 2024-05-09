1 // hevm: flattened sources of src/spell.sol
2 pragma solidity >=0.4.23;
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
66 ////// lib/ds-note/src/note.sol
67 /// note.sol -- the `note' modifier, for logging calls as events
68 
69 // This program is free software: you can redistribute it and/or modify
70 // it under the terms of the GNU General Public License as published by
71 // the Free Software Foundation, either version 3 of the License, or
72 // (at your option) any later version.
73 
74 // This program is distributed in the hope that it will be useful,
75 // but WITHOUT ANY WARRANTY; without even the implied warranty of
76 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
77 // GNU General Public License for more details.
78 
79 // You should have received a copy of the GNU General Public License
80 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
81 
82 /* pragma solidity >=0.4.23; */
83 
84 contract DSNote {
85     event LogNote(
86         bytes4   indexed  sig,
87         address  indexed  guy,
88         bytes32  indexed  foo,
89         bytes32  indexed  bar,
90         uint256           wad,
91         bytes             fax
92     ) anonymous;
93 
94     modifier note {
95         bytes32 foo;
96         bytes32 bar;
97         uint256 wad;
98 
99         assembly {
100             foo := calldataload(4)
101             bar := calldataload(36)
102             wad := callvalue
103         }
104 
105         emit LogNote(msg.sig, msg.sender, foo, bar, wad, msg.data);
106 
107         _;
108     }
109 }
110 
111 ////// src/spell.sol
112 // spell.sol - An un-owned object that performs one action one time only
113 
114 // Copyright (C) 2017, 2018 DappHub, LLC
115 
116 // This program is free software: you can redistribute it and/or modify
117 // it under the terms of the GNU General Public License as published by
118 // the Free Software Foundation, either version 3 of the License, or
119 // (at your option) any later version.
120 
121 // This program is distributed in the hope that it will be useful,
122 // but WITHOUT ANY WARRANTY; without even the implied warranty of
123 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
124 // GNU General Public License for more details.
125 
126 // You should have received a copy of the GNU General Public License
127 // along with this program. If not, see <http://www.gnu.org/licenses/>.
128 
129 /* pragma solidity >=0.4.23; */
130 
131 /* import "ds-exec/exec.sol"; */
132 /* import "ds-note/note.sol"; */
133 
134 contract DSSpell is DSExec, DSNote {
135     address public whom;
136     uint256 public mana;
137     bytes   public data;
138     bool    public done;
139 
140     constructor(address whom_, uint256 mana_, bytes memory data_) public {
141         whom = whom_;
142         mana = mana_;
143         data = data_;
144     }
145     // Only marked 'done' if CALL succeeds (not exceptional condition).
146     function cast() public note {
147         require(!done, "ds-spell-already-cast");
148         exec(whom, data, mana);
149         done = true;
150     }
151 }