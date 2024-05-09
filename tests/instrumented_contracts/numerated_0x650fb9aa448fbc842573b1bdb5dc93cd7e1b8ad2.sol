1 // hevm: flattened sources of src/burner.sol
2 pragma solidity ^0.4.24;
3 
4 ////// lib/ds-guard/lib/ds-auth/src/auth.sol
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
16 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
17 
18 /* pragma solidity ^0.4.23; */
19 
20 contract DSAuthority {
21     function canCall(
22         address src, address dst, bytes4 sig
23     ) public view returns (bool);
24 }
25 
26 contract DSAuthEvents {
27     event LogSetAuthority (address indexed authority);
28     event LogSetOwner     (address indexed owner);
29 }
30 
31 contract DSAuth is DSAuthEvents {
32     DSAuthority  public  authority;
33     address      public  owner;
34 
35     constructor() public {
36         owner = msg.sender;
37         emit LogSetOwner(msg.sender);
38     }
39 
40     function setOwner(address owner_)
41         public
42         auth
43     {
44         owner = owner_;
45         emit LogSetOwner(owner);
46     }
47 
48     function setAuthority(DSAuthority authority_)
49         public
50         auth
51     {
52         authority = authority_;
53         emit LogSetAuthority(authority);
54     }
55 
56     modifier auth {
57         require(isAuthorized(msg.sender, msg.sig));
58         _;
59     }
60 
61     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
62         if (src == address(this)) {
63             return true;
64         } else if (src == owner) {
65             return true;
66         } else if (authority == DSAuthority(0)) {
67             return false;
68         } else {
69             return authority.canCall(src, this, sig);
70         }
71     }
72 }
73 
74 ////// lib/ds-guard/src/guard.sol
75 // guard.sol -- simple whitelist implementation of DSAuthority
76 
77 // Copyright (C) 2017  DappHub, LLC
78 
79 // This program is free software: you can redistribute it and/or modify
80 // it under the terms of the GNU General Public License as published by
81 // the Free Software Foundation, either version 3 of the License, or
82 // (at your option) any later version.
83 
84 // This program is distributed in the hope that it will be useful,
85 // but WITHOUT ANY WARRANTY; without even the implied warranty of
86 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
87 // GNU General Public License for more details.
88 
89 // You should have received a copy of the GNU General Public License
90 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
91 
92 /* pragma solidity ^0.4.23; */
93 
94 /* import "ds-auth/auth.sol"; */
95 
96 contract DSGuardEvents {
97     event LogPermit(
98         bytes32 indexed src,
99         bytes32 indexed dst,
100         bytes32 indexed sig
101     );
102 
103     event LogForbid(
104         bytes32 indexed src,
105         bytes32 indexed dst,
106         bytes32 indexed sig
107     );
108 }
109 
110 contract DSGuard is DSAuth, DSAuthority, DSGuardEvents {
111     bytes32 constant public ANY = bytes32(uint(-1));
112 
113     mapping (bytes32 => mapping (bytes32 => mapping (bytes32 => bool))) acl;
114 
115     function canCall(
116         address src_, address dst_, bytes4 sig
117     ) public view returns (bool) {
118         bytes32 src = bytes32(src_);
119         bytes32 dst = bytes32(dst_);
120 
121         return acl[src][dst][sig]
122             || acl[src][dst][ANY]
123             || acl[src][ANY][sig]
124             || acl[src][ANY][ANY]
125             || acl[ANY][dst][sig]
126             || acl[ANY][dst][ANY]
127             || acl[ANY][ANY][sig]
128             || acl[ANY][ANY][ANY];
129     }
130 
131     function permit(bytes32 src, bytes32 dst, bytes32 sig) public auth {
132         acl[src][dst][sig] = true;
133         emit LogPermit(src, dst, sig);
134     }
135 
136     function forbid(bytes32 src, bytes32 dst, bytes32 sig) public auth {
137         acl[src][dst][sig] = false;
138         emit LogForbid(src, dst, sig);
139     }
140 
141     function permit(address src, address dst, bytes32 sig) public {
142         permit(bytes32(src), bytes32(dst), sig);
143     }
144     function forbid(address src, address dst, bytes32 sig) public {
145         forbid(bytes32(src), bytes32(dst), sig);
146     }
147 
148 }
149 
150 contract DSGuardFactory {
151     mapping (address => bool)  public  isGuard;
152 
153     function newGuard() public returns (DSGuard guard) {
154         guard = new DSGuard();
155         guard.setOwner(msg.sender);
156         isGuard[guard] = true;
157     }
158 }