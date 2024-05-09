1 // This program is free software: you can redistribute it and/or modify
2 // it under the terms of the GNU General Public License as published by
3 // the Free Software Foundation, either version 3 of the License, or
4 // (at your option) any later version.
5 
6 // This program is distributed in the hope that it will be useful,
7 // but WITHOUT ANY WARRANTY; without even the implied warranty of
8 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
9 // GNU General Public License for more details.
10 
11 // You should have received a copy of the GNU General Public License
12 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
13 
14 pragma solidity ^0.5.2;
15 
16 contract IDSToken {
17     function mint(address dst, uint wad) public;
18     function burn(address dst, uint wad) public;
19     function transfer(address dst, uint wad) public returns (bool);
20     function transferFrom(address src, address dst, uint wad) public returns (bool);
21 }
22 
23 contract DSAuthEvents {
24     event LogSetAuthority (address indexed authority);
25     event LogSetOwner     (address indexed owner);
26 }
27 
28 contract DSAuth is DSAuthEvents {
29     address      public  authority;
30     address      public  owner;
31 
32     constructor() public {
33         owner = msg.sender;
34         emit LogSetOwner(msg.sender);
35     }
36 
37     function setOwner(address owner_)
38         public
39         onlyOwner
40     {
41         owner = owner_;
42         emit LogSetOwner(owner);
43     }
44 
45     function setAuthority(address authority_)
46         public
47         onlyOwner
48     {
49         authority = authority_;
50         emit LogSetAuthority(address(authority));
51     }
52 
53     modifier auth {
54         require(isAuthorized(msg.sender), "ds-auth-unauthorized");
55         _;
56     }
57 
58     modifier onlyOwner {
59         require(isOwner(msg.sender), "ds-auth-non-owner");
60         _;
61     }
62 
63     function isOwner(address src) public view returns (bool) {
64         return bool(src == owner);
65     }
66 
67     function isAuthorized(address src) internal view returns (bool) {
68         if (src == address(this)) {
69             return true;
70         } else if (src == owner) {
71             return true;
72         } else if (authority == address(0)) {
73             return false;
74         } else if (src == authority) {
75             return true;
76         } else {
77             return false;
78         }
79     }
80 }
81 
82 contract DSNote {
83     event LogNote(
84         bytes4   indexed  sig,
85         address  indexed  guy,
86         bytes32  indexed  foo,
87         bytes32  indexed  bar,
88         uint256           wad,
89         bytes             fax
90     ) anonymous;
91 
92     modifier note {
93         bytes32 foo;
94         bytes32 bar;
95         uint256 wad;
96 
97         assembly {
98             foo := calldataload(4)
99             bar := calldataload(36)
100             wad := callvalue
101         }
102 
103         emit LogNote(msg.sig, msg.sender, foo, bar, wad, msg.data);
104 
105         _;
106     }
107 }
108 
109 contract DSStop is DSNote, DSAuth {
110     bool public stopped;
111 
112     modifier stoppable {
113         require(!stopped, "ds-stop-is-stopped");
114         _;
115     }
116     function stop() public onlyOwner note {
117         stopped = true;
118     }
119     function start() public onlyOwner note {
120         stopped = false;
121     }
122 }
123 
124 contract MakerProxy is DSStop {
125 
126     IDSToken private _dstoken;
127 
128     mapping (address => bool) public makerList;
129 
130     event AddMakerList(address indexed spender);
131     event DelMakerList(address indexed spender);
132 
133     constructor(address usdxToken) public {
134         _dstoken = IDSToken(usdxToken);
135     }
136 
137     modifier isMaker {
138         require(makerList[msg.sender] == true, "not in MakerList");
139         _;
140     }
141 
142     function addMakerList(address guy) public auth {
143         require(guy != address(0));
144         makerList[guy] = true;
145         emit AddMakerList(guy);
146     }
147 
148     function delMakerList(address guy) public auth {
149         require(guy != address(0));
150         delete makerList[guy];
151         emit DelMakerList(guy);
152     }
153 
154     function checkMakerList(address guy) public view returns (bool) {
155         require(guy != address(0));
156         return bool(makerList[guy]);
157     }
158 
159     function mint(address dst, uint wad) public auth stoppable {
160         _dstoken.mint(address(this), wad);
161         _dstoken.transfer(dst, wad);
162     }
163 
164     function burnx(address dst, uint wad) public isMaker stoppable {
165         require(dst != address(this)); //except proxy itself
166         _dstoken.transferFrom(dst, address(this), wad);
167         _dstoken.burn(address(this), wad);
168     }
169 
170     function burn(uint wad) public isMaker stoppable {
171         _dstoken.transferFrom(msg.sender, address(this), wad);
172         _dstoken.burn(address(this), wad);
173     }
174 }