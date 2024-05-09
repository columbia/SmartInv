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
16 contract DSAuthEvents {
17     event LogSetAuthority (address indexed authority);
18     event LogSetOwner     (address indexed owner);
19 }
20 
21 contract DSAuth is DSAuthEvents {
22     address      public  authority;
23     address      public  owner;
24 
25     constructor() public {
26         owner = msg.sender;
27         emit LogSetOwner(msg.sender);
28     }
29 
30     function setOwner(address owner_)
31         public
32         onlyOwner
33     {
34         owner = owner_;
35         emit LogSetOwner(owner);
36     }
37 
38     function setAuthority(address authority_)
39         public
40         onlyOwner
41     {
42         authority = authority_;
43         emit LogSetAuthority(address(authority));
44     }
45 
46     modifier auth {
47         require(isAuthorized(msg.sender), "ds-auth-unauthorized");
48         _;
49     }
50 
51     modifier onlyOwner {
52         require(isOwner(msg.sender), "ds-auth-non-owner");
53         _;
54     }
55 
56     function isOwner(address src) public view returns (bool) {
57         return bool(src == owner);
58     }
59 
60     function isAuthorized(address src) internal view returns (bool) {
61         if (src == address(this)) {
62             return true;
63         } else if (src == owner) {
64             return true;
65         } else if (authority == address(0)) {
66             return false;
67         } else if (src == authority) {
68             return true;
69         } else {
70             return false;
71         }
72     }
73 }
74 
75 contract DSMath {
76     function add(uint x, uint y) internal pure returns (uint z) {
77         require((z = x + y) >= x, "ds-math-add-overflow");
78     }
79     function sub(uint x, uint y) internal pure returns (uint z) {
80         require((z = x - y) <= x, "ds-math-sub-underflow");
81     }
82     function mul(uint x, uint y) internal pure returns (uint z) {
83         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
84     }
85 }
86 
87 contract DSNote {
88     event LogNote(
89         bytes4   indexed  sig,
90         address  indexed  guy,
91         bytes32  indexed  foo,
92         bytes32  indexed  bar,
93         uint256           wad,
94         bytes             fax
95     ) anonymous;
96 
97     modifier note {
98         bytes32 foo;
99         bytes32 bar;
100         uint256 wad;
101 
102         assembly {
103             foo := calldataload(4)
104             bar := calldataload(36)
105             wad := callvalue
106         }
107 
108         emit LogNote(msg.sig, msg.sender, foo, bar, wad, msg.data);
109 
110         _;
111     }
112 }
113 
114 contract DSStop is DSNote, DSAuth {
115     bool public stopped;
116 
117     modifier stoppable {
118         require(!stopped, "ds-stop-is-stopped");
119         _;
120     }
121     function stop() public onlyOwner note {
122         stopped = true;
123     }
124     function start() public onlyOwner note {
125         stopped = false;
126     }
127 }
128 
129 contract ERC20Events {
130     event Approval(address indexed src, address indexed guy, uint wad);
131     event Transfer(address indexed src, address indexed dst, uint wad);
132 }
133 
134 contract ERC20 is ERC20Events {
135     function totalSupply() public view returns (uint);
136     function balanceOf(address guy) public view returns (uint);
137     function allowance(address src, address guy) public view returns (uint);
138 
139     function approve(address guy, uint wad) public returns (bool);
140     function transfer(address dst, uint wad) public returns (bool);
141     function transferFrom(address src, address dst, uint wad) public returns (bool);
142 }
143 
144 contract DSTokenBase is ERC20, DSMath {
145     uint256                                            _supply;
146     mapping (address => uint256)                       _balances;
147     mapping (address => mapping (address => uint256))  _approvals;
148 
149     constructor(uint supply) public {
150         _supply = supply;
151     }
152 
153     function totalSupply() public view returns (uint) {
154         return _supply;
155     }
156     function balanceOf(address src) public view returns (uint) {
157         return _balances[src];
158     }
159     function allowance(address src, address guy) public view returns (uint) {
160         return _approvals[src][guy];
161     }
162 
163     function transfer(address dst, uint wad) public returns (bool) {
164         return transferFrom(msg.sender, dst, wad);
165     }
166 
167     function transferFrom(address src, address dst, uint wad)
168         public
169         returns (bool)
170     {
171         if (src != msg.sender) {
172             require(_approvals[src][msg.sender] >= wad, "ds-token-insufficient-approval");
173             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
174         }
175 
176         require(_balances[src] >= wad, "ds-token-insufficient-balance");
177         _balances[src] = sub(_balances[src], wad);
178         _balances[dst] = add(_balances[dst], wad);
179 
180         emit Transfer(src, dst, wad);
181 
182         return true;
183     }
184 
185     function approve(address guy, uint wad) public returns (bool) {
186         _approvals[msg.sender][guy] = wad;
187 
188         emit Approval(msg.sender, guy, wad);
189 
190         return true;
191     }
192 }
193 
194 contract DSToken is DSTokenBase(0), DSStop {
195 
196     bytes32  public  name = "";
197     bytes32  public  symbol;
198     uint256  public  decimals = 18;
199 
200     constructor(bytes32 symbol_) public {
201         symbol = symbol_;
202     }
203 
204     event Mint(address indexed guy, uint wad);
205     event Burn(address indexed guy, uint wad);
206 
207     function setName(bytes32 name_) public onlyOwner {
208         name = name_;
209     }
210 
211     function approvex(address guy) public stoppable returns (bool) {
212         return super.approve(guy, uint(-1));
213     }
214 
215     function approve(address guy, uint wad) public stoppable returns (bool) {
216         require(_approvals[msg.sender][guy] == 0 || wad == 0); //take care of re-approve.
217         return super.approve(guy, wad);
218     }
219 
220     function transferFrom(address src, address dst, uint wad)
221         public
222         stoppable
223         returns (bool)
224     {
225         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
226             require(_approvals[src][msg.sender] >= wad, "ds-token-insufficient-approval");
227             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
228         }
229 
230         require(_balances[src] >= wad, "ds-token-insufficient-balance");
231         _balances[src] = sub(_balances[src], wad);
232         _balances[dst] = add(_balances[dst], wad);
233 
234         emit Transfer(src, dst, wad);
235 
236         return true;
237     }
238 
239     function mint(address guy, uint wad) public auth stoppable {
240         _mint(guy, wad);
241     }
242 
243     function burn(address guy, uint wad) public auth stoppable {
244         _burn(guy, wad);
245     }
246 
247     function _mint(address guy, uint wad) internal {
248         _balances[guy] = add(_balances[guy], wad);
249         _supply = add(_supply, wad);
250         emit Mint(guy, wad);
251     }
252 
253     function _burn(address guy, uint wad) internal {
254         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
255             require(_approvals[guy][msg.sender] >= wad, "ds-token-insufficient-approval");
256             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
257         }
258 
259         require(_balances[guy] >= wad, "ds-token-insufficient-balance");
260         _balances[guy] = sub(_balances[guy], wad);
261         _supply = sub(_supply, wad);
262         emit Burn(guy, wad);
263     }
264 }