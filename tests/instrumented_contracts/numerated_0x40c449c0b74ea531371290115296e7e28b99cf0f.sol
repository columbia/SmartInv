1 // hevm: flattened sources of src/osm.sol
2 pragma solidity ^0.4.24;
3 
4 ////// lib/ds-stop/lib/ds-auth/src/auth.sol
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
74 ////// lib/ds-stop/lib/ds-note/src/note.sol
75 /// note.sol -- the `note' modifier, for logging calls as events
76 
77 // This program is free software: you can redistribute it and/or modify
78 // it under the terms of the GNU General Public License as published by
79 // the Free Software Foundation, either version 3 of the License, or
80 // (at your option) any later version.
81 
82 // This program is distributed in the hope that it will be useful,
83 // but WITHOUT ANY WARRANTY; without even the implied warranty of
84 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
85 // GNU General Public License for more details.
86 
87 // You should have received a copy of the GNU General Public License
88 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
89 
90 /* pragma solidity ^0.4.23; */
91 
92 contract DSNote {
93     event LogNote(
94         bytes4   indexed  sig,
95         address  indexed  guy,
96         bytes32  indexed  foo,
97         bytes32  indexed  bar,
98         uint              wad,
99         bytes             fax
100     ) anonymous;
101 
102     modifier note {
103         bytes32 foo;
104         bytes32 bar;
105 
106         assembly {
107             foo := calldataload(4)
108             bar := calldataload(36)
109         }
110 
111         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
112 
113         _;
114     }
115 }
116 
117 ////// lib/ds-stop/src/stop.sol
118 /// stop.sol -- mixin for enable/disable functionality
119 
120 // Copyright (C) 2017  DappHub, LLC
121 
122 // This program is free software: you can redistribute it and/or modify
123 // it under the terms of the GNU General Public License as published by
124 // the Free Software Foundation, either version 3 of the License, or
125 // (at your option) any later version.
126 
127 // This program is distributed in the hope that it will be useful,
128 // but WITHOUT ANY WARRANTY; without even the implied warranty of
129 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
130 // GNU General Public License for more details.
131 
132 // You should have received a copy of the GNU General Public License
133 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
134 
135 /* pragma solidity ^0.4.23; */
136 
137 /* import "ds-auth/auth.sol"; */
138 /* import "ds-note/note.sol"; */
139 
140 contract DSStop is DSNote, DSAuth {
141 
142     bool public stopped;
143 
144     modifier stoppable {
145         require(!stopped);
146         _;
147     }
148     function stop() public auth note {
149         stopped = true;
150     }
151     function start() public auth note {
152         stopped = false;
153     }
154 
155 }
156 
157 ////// src/osm.sol
158 /// osm.sol - oracle security module
159 
160 // Copyright (C) 2018  DappHub, LLC
161 
162 // This program is free software: you can redistribute it and/or modify
163 // it under the terms of the GNU General Public License as published by
164 // the Free Software Foundation, either version 3 of the License, or
165 // (at your option) any later version.
166 
167 // This program is distributed in the hope that it will be useful,
168 // but WITHOUT ANY WARRANTY; without even the implied warranty of
169 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
170 // GNU General Public License for more details.
171 
172 // You should have received a copy of the GNU General Public License
173 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
174 
175 /* pragma solidity ^0.4.24; */
176 
177 /* import "ds-auth/auth.sol"; */
178 /* import "ds-stop/stop.sol"; */
179 // import "ds-value/value.sol";
180 
181 interface DSValue {
182     function peek() external returns (bytes32,bool);
183     function read() external returns (bytes32);
184 }
185 
186 contract OSM is DSAuth, DSStop {
187     DSValue public src;
188     
189     uint16 constant ONE_HOUR = uint16(3600);
190 
191     uint16 public hop = ONE_HOUR;
192     uint64 public zzz;
193 
194     struct Feed {
195         uint128 val;
196         bool    has;
197     }
198 
199     Feed cur;
200     Feed nxt;
201 
202     event LogValue(bytes32 val);
203     
204     constructor (DSValue src_) public {
205         src = src_;
206         (bytes32 wut, bool ok) = src_.peek();
207         if (ok) {
208             cur = nxt = Feed(uint128(wut), ok);
209             zzz = prev(era());
210         }
211     }
212 
213     function era() internal view returns (uint) {
214         return block.timestamp;
215     }
216 
217     function prev(uint ts) internal view returns (uint64) {
218         return uint64(ts - (ts % hop));
219     }
220 
221     function step(uint16 ts) external auth {
222         require(ts > 0);
223         hop = ts;
224     }
225 
226     function void() external auth {
227         cur = nxt = Feed(0, false);
228         stopped = true;
229     }
230 
231     function pass() public view returns (bool ok) {
232         return era() >= zzz + hop;
233     }
234 
235     function poke() external stoppable {
236         require(pass());
237         (bytes32 wut, bool ok) = src.peek();
238         cur = nxt;
239         nxt = Feed(uint128(wut), ok);
240         zzz = prev(era());
241         emit LogValue(bytes32(cur.val));
242     }
243 
244     function peek() external view returns (bytes32,bool) {
245         return (bytes32(cur.val), cur.has);
246     }
247 
248     function peep() external view returns (bytes32,bool) {
249         return (bytes32(nxt.val), nxt.has);
250     }
251 
252     function read() external view returns (bytes32) {
253         require(cur.has);
254         return (bytes32(cur.val));
255     }
256 }