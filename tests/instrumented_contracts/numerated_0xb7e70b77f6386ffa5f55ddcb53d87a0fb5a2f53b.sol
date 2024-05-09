1 // Copyright (C) 2020 Centrifuge
2 // This program is free software: you can redistribute it and/or modify
3 // it under the terms of the GNU Affero General Public License as published by
4 // the Free Software Foundation, either version 3 of the License, or
5 // (at your option) any later version.
6 //
7 // This program is distributed in the hope that it will be useful,
8 // but WITHOUT ANY WARRANTY; without even the implied warranty of
9 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
10 // GNU Affero General Public License for more details.
11 //
12 // You should have received a copy of the GNU Affero General Public License
13 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
14 
15 pragma solidity >=0.5.15 <0.6.0;
16 
17 // Copyright (C) Centrifuge 2020, based on MakerDAO dss https://github.com/makerdao/dss
18 //
19 // This program is free software: you can redistribute it and/or modify
20 // it under the terms of the GNU Affero General Public License as published by
21 // the Free Software Foundation, either version 3 of the License, or
22 // (at your option) any later version.
23 //
24 // This program is distributed in the hope that it will be useful,
25 // but WITHOUT ANY WARRANTY; without even the implied warranty of
26 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
27 // GNU Affero General Public License for more details.
28 //
29 // You should have received a copy of the GNU Affero General Public License
30 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
31 
32 pragma solidity >=0.5.15 <0.6.0;
33 /// note.sol -- the `note' modifier, for logging calls as events
34 
35 // This program is free software: you can redistribute it and/or modify
36 // it under the terms of the GNU General Public License as published by
37 // the Free Software Foundation, either version 3 of the License, or
38 // (at your option) any later version.
39 
40 // This program is distributed in the hope that it will be useful,
41 // but WITHOUT ANY WARRANTY; without even the implied warranty of
42 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
43 // GNU General Public License for more details.
44 
45 // You should have received a copy of the GNU General Public License
46 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
47 
48 pragma solidity >=0.4.23;
49 
50 contract DSNote {
51     event LogNote(
52         bytes4   indexed  sig,
53         address  indexed  guy,
54         bytes32  indexed  foo,
55         bytes32  indexed  bar,
56         uint256           wad,
57         bytes             fax
58     ) anonymous;
59 
60     modifier note {
61         bytes32 foo;
62         bytes32 bar;
63         uint256 wad;
64 
65         assembly {
66             foo := calldataload(4)
67             bar := calldataload(36)
68             wad := callvalue()
69         }
70 
71         _;
72 
73         emit LogNote(msg.sig, msg.sender, foo, bar, wad, msg.data);
74     }
75 }
76 
77 contract Auth is DSNote {
78     mapping (address => uint) public wards;
79     function rely(address usr) public auth note { wards[usr] = 1; }
80     function deny(address usr) public auth note { wards[usr] = 0; }
81     modifier auth { require(wards[msg.sender] == 1); _; }
82 }
83 
84 contract MemberlistLike {
85     function updateMember(address usr, uint validUntil) public;
86     function updateMembers(address[] memory users, uint validUntil) public;
87 }
88 
89 // Wrapper contract for permission restriction on the memberlists.
90 contract MemberAdmin is Auth {
91     constructor() public {
92         wards[msg.sender] = 1;
93     }
94 
95     // Admins can manipulate memberlists, but have to be added and can be removed by any ward on the MemberAdmin contract
96     mapping (address => uint) public admins;
97 
98     modifier admin { require(admins[msg.sender] == 1); _; }
99 
100     function relyAdmin(address usr) public auth note { admins[usr] = 1; }
101     function denyAdmin(address usr) public auth note { admins[usr] = 0; }
102 
103     function updateMember(address list, address usr, uint validUntil) public admin {
104         MemberlistLike(list).updateMember(usr, validUntil);
105     }
106 
107     function updateMembers(address list, address[] memory users, uint validUntil) public admin {
108         MemberlistLike(list).updateMembers(users, validUntil);
109     }
110 }