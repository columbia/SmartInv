1 pragma solidity ^0.4.21;
2 
3 // This program is free software: you can redistribute it and/or modify
4 // it under the terms of the GNU General Public License as published by
5 // the Free Software Foundation, either version 3 of the License, or
6 // (at your option) any later version.
7 
8 // This program is distributed in the hope that it will be useful,
9 // but WITHOUT ANY WARRANTY; without even the implied warranty of
10 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
11 // GNU General Public License for more details.
12 
13 // You should have received a copy of the GNU General Public License
14 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
15 
16 contract DSAuthority {
17     function canCall(
18         address src, address dst, bytes4 sig
19     ) public view returns (bool);
20 }
21 
22 contract DSAuthEvents {
23     event LogSetAuthority (address indexed authority);
24     event LogSetOwner     (address indexed owner);
25 }
26 
27 contract DSAuth is DSAuthEvents {
28     DSAuthority  public  authority;
29     address      public  owner;
30 
31     function DSAuth() public {
32         owner = msg.sender;
33         LogSetOwner(msg.sender);
34     }
35 
36     function setOwner(address owner_)
37         public
38         auth
39     {
40         owner = owner_;
41         LogSetOwner(owner);
42     }
43 
44     function setAuthority(DSAuthority authority_)
45         public
46         auth
47     {
48         authority = authority_;
49         LogSetAuthority(authority);
50     }
51 
52     modifier auth {
53         require(isAuthorized(msg.sender, msg.sig));
54         _;
55     }
56 
57     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
58         if (src == address(this)) {
59             return true;
60         } else if (src == owner) {
61             return true;
62         } else if (authority == DSAuthority(0)) {
63             return false;
64         } else {
65             return authority.canCall(src, this, sig);
66         }
67     }
68 }
69 
70 // Copyright (C) 2017  DappHub, LLC
71 
72 // This program is free software: you can redistribute it and/or modify
73 // it under the terms of the GNU General Public License as published by
74 // the Free Software Foundation, either version 3 of the License, or
75 // (at your option) any later version.
76 
77 // This program is distributed in the hope that it will be useful,
78 // but WITHOUT ANY WARRANTY; without even the implied warranty of
79 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
80 // GNU General Public License for more details.
81 
82 // You should have received a copy of the GNU General Public License
83 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
84 
85 contract DSRoles is DSAuth, DSAuthority
86 {
87     mapping(address=>bool) _root_users;
88     mapping(address=>bytes32) _user_roles;
89     mapping(address=>mapping(bytes4=>bytes32)) _capability_roles;
90     mapping(address=>mapping(bytes4=>bool)) _public_capabilities;
91 
92     function getUserRoles(address who)
93         public
94         view
95         returns (bytes32)
96     {
97         return _user_roles[who];
98     }
99 
100     function getCapabilityRoles(address code, bytes4 sig)
101         public
102         view
103         returns (bytes32)
104     {
105         return _capability_roles[code][sig];
106     }
107 
108     function isUserRoot(address who)
109         public
110         view
111         returns (bool)
112     {
113         return _root_users[who];
114     }
115 
116     function isCapabilityPublic(address code, bytes4 sig)
117         public
118         view
119         returns (bool)
120     {
121         return _public_capabilities[code][sig];
122     }
123 
124     function hasUserRole(address who, uint8 role)
125         public
126         view
127         returns (bool)
128     {
129         bytes32 roles = getUserRoles(who);
130         bytes32 shifted = bytes32(uint256(uint256(2) ** uint256(role)));
131         return bytes32(0) != roles & shifted;
132     }
133 
134     function canCall(address caller, address code, bytes4 sig)
135         public
136         view
137         returns (bool)
138     {
139         if( isUserRoot(caller) || isCapabilityPublic(code, sig) ) {
140             return true;
141         } else {
142             bytes32 has_roles = getUserRoles(caller);
143             bytes32 needs_one_of = getCapabilityRoles(code, sig);
144             return bytes32(0) != has_roles & needs_one_of;
145         }
146     }
147 
148     function BITNOT(bytes32 input) internal pure returns (bytes32 output) {
149         return (input ^ bytes32(uint(-1)));
150     }
151 
152     function setRootUser(address who, bool enabled)
153         public
154         auth
155     {
156         _root_users[who] = enabled;
157     }
158 
159     function setUserRole(address who, uint8 role, bool enabled)
160         public
161         auth
162     {
163         bytes32 last_roles = _user_roles[who];
164         bytes32 shifted = bytes32(uint256(uint256(2) ** uint256(role)));
165         if( enabled ) {
166             _user_roles[who] = last_roles | shifted;
167         } else {
168             _user_roles[who] = last_roles & BITNOT(shifted);
169         }
170     }
171 
172     function setPublicCapability(address code, bytes4 sig, bool enabled)
173         public
174         auth
175     {
176         _public_capabilities[code][sig] = enabled;
177     }
178 
179     function setRoleCapability(uint8 role, address code, bytes4 sig, bool enabled)
180         public
181         auth
182     {
183         bytes32 last_roles = _capability_roles[code][sig];
184         bytes32 shifted = bytes32(uint256(uint256(2) ** uint256(role)));
185         if( enabled ) {
186             _capability_roles[code][sig] = last_roles | shifted;
187         } else {
188             _capability_roles[code][sig] = last_roles & BITNOT(shifted);
189         }
190 
191     }
192 
193 }