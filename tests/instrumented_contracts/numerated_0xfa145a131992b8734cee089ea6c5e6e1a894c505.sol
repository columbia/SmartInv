1 pragma solidity ^0.4.13;
2 
3 contract ZCHMath {
4     function add(uint x, uint y) internal pure returns (uint z) {
5         require((z = x + y) >= x);
6     }
7     function sub(uint x, uint y) internal pure returns (uint z) {
8         require((z = x - y) <= x);
9     }
10     function mul(uint x, uint y) internal pure returns (uint z) {
11         require(y == 0 || (z = x * y) / y == x);
12     }
13 
14     function min(uint x, uint y) internal pure returns (uint z) {
15         return x <= y ? x : y;
16     }
17     function max(uint x, uint y) internal pure returns (uint z) {
18         return x >= y ? x : y;
19     }
20     function imin(int x, int y) internal pure returns (int z) {
21         return x <= y ? x : y;
22     }
23     function imax(int x, int y) internal pure returns (int z) {
24         return x >= y ? x : y;
25     }
26 
27     uint constant WAD = 10 ** 18;
28     uint constant RAY = 10 ** 27;
29 
30     function wmul(uint x, uint y) internal pure returns (uint z) {
31         z = add(mul(x, y), WAD / 2) / WAD;
32     }
33     function rmul(uint x, uint y) internal pure returns (uint z) {
34         z = add(mul(x, y), RAY / 2) / RAY;
35     }
36     function wdiv(uint x, uint y) internal pure returns (uint z) {
37         z = add(mul(x, WAD), y / 2) / y;
38     }
39     function rdiv(uint x, uint y) internal pure returns (uint z) {
40         z = add(mul(x, RAY), y / 2) / y;
41     }
42 
43     function rpow(uint x, uint n) internal pure returns (uint z) {
44         z = n % 2 != 0 ? x : RAY;
45 
46         for (n /= 2; n != 0; n /= 2) {
47             x = rmul(x, x);
48 
49             if (n % 2 != 0) {
50                 z = rmul(z, x);
51             }
52         }
53     }
54 }
55 
56 contract ZCHAuthority {
57     function canCall(
58         address src, address ZCH, bytes4 sig
59     ) public view returns (bool);
60 }
61 
62 contract ZCHAuthEvents {
63     event LogSetAuthority (address indexed authority);
64     event LogSetOwner     (address indexed owner);
65 }
66 
67 contract ZCHAuth is ZCHAuthEvents {
68     ZCHAuthority  public  authority;
69     address      public  owner;
70 
71     function ZCHAuth() public {
72         owner = msg.sender;
73         LogSetOwner(msg.sender);
74     }
75 
76     function setOwner(address owner_)
77         public
78         auth
79     {
80         owner = owner_;
81         LogSetOwner(owner);
82     }
83 
84     function setAuthority(ZCHAuthority authority_)
85         public
86         auth
87     {
88         authority = authority_;
89         LogSetAuthority(authority);
90     }
91 
92     modifier auth {
93         require(isAuthorized(msg.sender, msg.sig));
94         _;
95     }
96 
97     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
98         if (src == address(this)) {
99             return true;
100         } else if (src == owner) {
101             return true;
102         } else if (authority == ZCHAuthority(0)) {
103             return false;
104         } else {
105             return authority.canCall(src, this, sig);
106         }
107     }
108 }
109 
110 contract ZCHNote {
111     event LogNote(
112         bytes4   indexed  sig,
113         address  indexed  guy,
114         bytes32  indexed  foo,
115         bytes32  indexed  bar,
116         uint              wad,
117         bytes             fax
118     ) anonymous;
119 
120     modifier note {
121         bytes32 foo;
122         bytes32 bar;
123 
124         assembly {
125             foo := calldataload(4)
126             bar := calldataload(36)
127         }
128 
129         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
130 
131         _;
132     }
133 }
134 
135 contract ZCHStop is ZCHNote, ZCHAuth {
136 
137     bool public stopped;
138 
139     modifier stoppable {
140         require(!stopped);
141         _;
142     }
143     function stop() public auth note {
144         stopped = true;
145     }
146     function start() public auth note {
147         stopped = false;
148     }
149 
150 }
151 
152 contract ERC20Events {
153     event Approval(address indexed src, address indexed guy, uint wad);
154     event Transfer(address indexed src, address indexed ZCH, uint wad);
155 }
156 
157 contract ERC20 is ERC20Events {
158     function totalSupply() public view returns (uint);
159     function balanceOf(address guy) public view returns (uint);
160     function allowance(address src, address guy) public view returns (uint);
161 
162     function approve(address guy, uint wad) public returns (bool);
163     function transfer(address ZCH, uint wad) public returns (bool);
164     function transferFrom(
165         address src, address ZCH, uint wad
166     ) public returns (bool);
167 }
168 
169 contract ZCHTokenBase is ERC20, ZCHMath {
170     uint256                                            _supply;
171     mapping (address => uint256)                       _balances;
172     mapping (address => mapping (address => uint256))  _approvals;
173 
174     function ZCHTokenBase(uint supply) public {
175         _balances[msg.sender] = supply;
176         _supply = supply;
177     }
178 
179     function totalSupply() public view returns (uint) {
180         return _supply;
181     }
182     function balanceOf(address src) public view returns (uint) {
183         return _balances[src];
184     }
185     function allowance(address src, address guy) public view returns (uint) {
186         return _approvals[src][guy];
187     }
188 
189     function transfer(address ZCH, uint wad) public returns (bool) {
190         return transferFrom(msg.sender, ZCH, wad);
191     }
192 
193     function transferFrom(address src, address ZCH, uint wad)
194         public
195         returns (bool)
196     {
197         if (src != msg.sender) {
198             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
199         }
200 
201         _balances[src] = sub(_balances[src], wad);
202         _balances[ZCH] = add(_balances[ZCH], wad);
203 
204         Transfer(src, ZCH, wad);
205 
206         return true;
207     }
208 
209     function approve(address guy, uint wad) public returns (bool) {
210         _approvals[msg.sender][guy] = wad;
211 
212         Approval(msg.sender, guy, wad);
213 
214         return true;
215     }
216 }
217 
218 contract ZCHToken is ZCHTokenBase(0), ZCHStop {
219 
220     bytes32  public  symbol;
221     uint256  public  decimals = 2; // standard token precision. override to customize
222 
223     function ZCHToken(bytes32 symbol_) public {
224         symbol = symbol_;
225     }
226 
227     event Mint(address indexed guy, uint wad);
228     event Burn(address indexed guy, uint wad);
229 
230     function approve(address guy) public stoppable returns (bool) {
231         return super.approve(guy, uint(-1));
232     }
233 
234     function approve(address guy, uint wad) public stoppable returns (bool) {
235         return super.approve(guy, wad);
236     }
237 
238     function transferFrom(address src, address ZCH, uint wad)
239         public
240         stoppable
241         returns (bool)
242     {
243         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
244             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
245         }
246 
247         _balances[src] = sub(_balances[src], wad);
248         _balances[ZCH] = add(_balances[ZCH], wad);
249 
250         Transfer(src, ZCH, wad);
251 
252         return true;
253     }
254 
255     function push(address ZCH, uint wad) public {
256         transferFrom(msg.sender, ZCH, wad);
257     }
258     function pull(address src, uint wad) public {
259         transferFrom(src, msg.sender, wad);
260     }
261     function move(address src, address ZCH, uint wad) public {
262         transferFrom(src, ZCH, wad);
263     }
264 
265     function mint(uint wad) public {
266         mint(msg.sender, wad);
267     }
268     function burn(uint wad) public {
269         burn(msg.sender, wad);
270     }
271     function mint(address guy, uint wad) public auth stoppable {
272         _balances[guy] = add(_balances[guy], wad);
273         _supply = add(_supply, wad);
274         Mint(guy, wad);
275     }
276     function burn(address guy, uint wad) public auth stoppable {
277         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
278             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
279         }
280 
281         _balances[guy] = sub(_balances[guy], wad);
282         _supply = sub(_supply, wad);
283         Burn(guy, wad);
284     }
285 
286     // Optional token name
287     bytes32   public  name = "";
288 
289     function setName(bytes32 name_) public auth {
290         name = name_;
291     }
292 }