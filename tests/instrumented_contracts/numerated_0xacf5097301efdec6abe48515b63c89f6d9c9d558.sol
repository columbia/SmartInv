1 // spell.sol - An un-owned object that performs one action one time only
2 
3 // Copyright (C) 2017, 2018 DappHub, LLC
4 
5 // This program is free software: you can redistribute it and/or modify
6 // it under the terms of the GNU General Public License as published by
7 // the Free Software Foundation, either version 3 of the License, or
8 // (at your option) any later version.
9 
10 // This program is distributed in the hope that it will be useful,
11 // but WITHOUT ANY WARRANTY; without even the implied warranty of
12 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
13 // GNU General Public License for more details.
14 
15 // You should have received a copy of the GNU General Public License
16 // along with this program. If not, see <http://www.gnu.org/licenses/>.
17 
18 pragma solidity >=0.4.23;
19 
20 // exec.sol - base contract used by anything that wants to do "untyped" calls
21 
22 // Copyright (C) 2017  DappHub, LLC
23 
24 // This program is free software: you can redistribute it and/or modify
25 // it under the terms of the GNU General Public License as published by
26 // the Free Software Foundation, either version 3 of the License, or
27 // (at your option) any later version.
28 
29 // This program is distributed in the hope that it will be useful,
30 // but WITHOUT ANY WARRANTY; without even the implied warranty of
31 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
32 // GNU General Public License for more details.
33 
34 // You should have received a copy of the GNU General Public License
35 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
36 
37 pragma solidity >=0.4.23;
38 
39 contract DSExec {
40     function tryExec( address target, bytes memory data, uint value)
41              internal
42              returns (bool ok)
43     {
44         assembly {
45             ok := call(gas, target, value, add(data, 0x20), mload(data), 0, 0)
46         }
47     }
48     function exec( address target, bytes memory data, uint value)
49              internal
50     {
51         if(!tryExec(target, data, value)) {
52             revert("ds-exec-call-failed");
53         }
54     }
55 
56     // Convenience aliases
57     function exec( address t, bytes memory c )
58         internal
59     {
60         exec(t, c, 0);
61     }
62     function exec( address t, uint256 v )
63         internal
64     {
65         bytes memory c; exec(t, c, v);
66     }
67     function tryExec( address t, bytes memory c )
68         internal
69         returns (bool)
70     {
71         return tryExec(t, c, 0);
72     }
73     function tryExec( address t, uint256 v )
74         internal
75         returns (bool)
76     {
77         bytes memory c; return tryExec(t, c, v);
78     }
79 }
80 
81 /// note.sol -- the `note' modifier, for logging calls as events
82 
83 // This program is free software: you can redistribute it and/or modify
84 // it under the terms of the GNU General Public License as published by
85 // the Free Software Foundation, either version 3 of the License, or
86 // (at your option) any later version.
87 
88 // This program is distributed in the hope that it will be useful,
89 // but WITHOUT ANY WARRANTY; without even the implied warranty of
90 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
91 // GNU General Public License for more details.
92 
93 // You should have received a copy of the GNU General Public License
94 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
95 
96 pragma solidity >=0.4.23;
97 
98 contract DSNote {
99     event LogNote(
100         bytes4   indexed  sig,
101         address  indexed  guy,
102         bytes32  indexed  foo,
103         bytes32  indexed  bar,
104         uint256           wad,
105         bytes             fax
106     ) anonymous;
107 
108     modifier note {
109         bytes32 foo;
110         bytes32 bar;
111         uint256 wad;
112 
113         assembly {
114             foo := calldataload(4)
115             bar := calldataload(36)
116             wad := callvalue
117         }
118 
119         emit LogNote(msg.sig, msg.sender, foo, bar, wad, msg.data);
120 
121         _;
122     }
123 }
124 
125 contract DSSpell is DSExec, DSNote {
126     address public whom;
127     uint256 public mana;
128     bytes   public data;
129     bool    public done;
130 
131     constructor(address whom_, uint256 mana_, bytes memory data_) public {
132         whom = whom_;
133         mana = mana_;
134         data = data_;
135     }
136     // Only marked 'done' if CALL succeeds (not exceptional condition).
137     function cast() public note {
138         require(!done, "ds-spell-already-cast");
139         exec(whom, data, mana);
140         done = true;
141     }
142 }
143 
144 contract DSSpellBook {
145     function make(address whom, uint256 mana, bytes memory data) public returns (DSSpell) {
146         return new DSSpell(whom, mana, data);
147     }
148 }