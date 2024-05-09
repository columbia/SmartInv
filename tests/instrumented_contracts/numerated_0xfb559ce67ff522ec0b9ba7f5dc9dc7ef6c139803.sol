1 pragma solidity ^0.4.25;
2 
3 contract DSNote {
4     event LogNote(
5         bytes4   indexed  sig,
6         address  indexed  guy,
7         bytes32  indexed  foo,
8         bytes32  indexed  bar,
9         uint              wad,
10         bytes             fax
11     ) anonymous;
12 
13     modifier note {
14         bytes32 foo;
15         bytes32 bar;
16 
17         assembly {
18             foo := calldataload(4)
19             bar := calldataload(36)
20         }
21 
22         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
23 
24         _;
25     }
26 }
27 
28 contract DSAuthority {
29     function canCall(
30         address src, address dst, bytes4 sig
31     ) public view returns (bool);
32 }
33 
34 contract DSAuthEvents {
35     event LogSetAuthority (address indexed authority);
36     event LogSetOwner     (address indexed owner);
37 }
38 
39 contract DSAuth is DSAuthEvents {
40     DSAuthority  public  authority;
41     address      public  owner;
42 
43     constructor() public {
44         owner = msg.sender;
45         emit LogSetOwner(msg.sender);
46     }
47 
48     function setOwner(address owner_)
49         public
50         auth
51     {
52         owner = owner_;
53         emit LogSetOwner(owner);
54     }
55 
56     function setAuthority(DSAuthority authority_)
57         public
58         auth
59     {
60         authority = authority_;
61         emit LogSetAuthority(authority);
62     }
63 
64     modifier auth {
65         require(isAuthorized(msg.sender, msg.sig));
66         _;
67     }
68 
69     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
70         if (src == address(this)) {
71             return true;
72         } else if (src == owner) {
73             return true;
74         } else if (authority == DSAuthority(0)) {
75             return false;
76         } else {
77             return authority.canCall(src, this, sig);
78         }
79     }
80 }
81 
82 contract DSStop is DSNote, DSAuth {
83     bool public stopped;
84 
85     modifier stoppable {
86         require(!stopped);
87         _;
88     }
89 
90     function stop() public auth note {
91         stopped = true;
92     }
93 
94     function start() public auth note {
95         stopped = false;
96     }
97 }
98 
99 contract DSMath {
100     function add(uint x, uint y) internal pure returns (uint z) {
101         require((z = x + y) >= x);
102     }
103     function sub(uint x, uint y) internal pure returns (uint z) {
104         require((z = x - y) <= x);
105     }
106     function mul(uint x, uint y) internal pure returns (uint z) {
107         require(y == 0 || (z = x * y) / y == x);
108     }
109 
110     function min(uint x, uint y) internal pure returns (uint z) {
111         return x <= y ? x : y;
112     }
113     function max(uint x, uint y) internal pure returns (uint z) {
114         return x >= y ? x : y;
115     }
116     function imin(int x, int y) internal pure returns (int z) {
117         return x <= y ? x : y;
118     }
119     function imax(int x, int y) internal pure returns (int z) {
120         return x >= y ? x : y;
121     }
122 
123     uint constant WAD = 10 ** 18;
124     uint constant RAY = 10 ** 27;
125 
126     function wmul(uint x, uint y) internal pure returns (uint z) {
127         z = add(mul(x, y), WAD / 2) / WAD;
128     }
129     function rmul(uint x, uint y) internal pure returns (uint z) {
130         z = add(mul(x, y), RAY / 2) / RAY;
131     }
132     function wdiv(uint x, uint y) internal pure returns (uint z) {
133         z = add(mul(x, WAD), y / 2) / y;
134     }
135     function rdiv(uint x, uint y) internal pure returns (uint z) {
136         z = add(mul(x, RAY), y / 2) / y;
137     }
138 
139     function rpow(uint x, uint n) internal pure returns (uint z) {
140         z = n % 2 != 0 ? x : RAY;
141 
142         for (n /= 2; n != 0; n /= 2) {
143             x = rmul(x, x);
144 
145             if (n % 2 != 0) {
146                 z = rmul(z, x);
147             }
148         }
149     }
150 }
151 
152 contract ERC20Events {
153     event Approval(address indexed src, address indexed guy, uint wad);
154     event Transfer(address indexed src, address indexed dst, uint wad);
155 }
156 
157 contract ERC20 is ERC20Events {
158     function totalSupply() public view returns (uint);
159     function balanceOf(address guy) public view returns (uint);
160     function allowance(address src, address guy) public view returns (uint);
161 
162     function approve(address guy, uint wad) public returns (bool);
163     function transfer(address dst, uint wad) public returns (bool);
164     function transferFrom(
165         address src, address dst, uint wad
166     ) public returns (bool);
167 }
168 
169 contract DSTokenBase is ERC20, DSMath {
170     uint256                                            _supply;
171     mapping (address => uint256)                       _balances;
172     mapping (address => mapping (address => uint256))  _approvals;
173 
174     constructor(uint supply) public {
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
189     function transfer(address dst, uint wad) public returns (bool) {
190         return transferFrom(msg.sender, dst, wad);
191     }
192 
193     function transferFrom(address src, address dst, uint wad)
194         public
195         returns (bool)
196     {
197         if (src != msg.sender) {
198             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
199         }
200 
201         _balances[src] = sub(_balances[src], wad);
202         _balances[dst] = add(_balances[dst], wad);
203 
204         emit Transfer(src, dst, wad);
205 
206         return true;
207     }
208 
209     function approve(address guy, uint wad) public returns (bool) {
210         _approvals[msg.sender][guy] = wad;
211 
212         emit Approval(msg.sender, guy, wad);
213 
214         return true;
215     }
216 }
217 
218 contract PROB is DSTokenBase(0), DSStop {
219     bytes32  public  name = "";
220     bytes32  public  symbol = "PROB";
221     uint256  public  decimals = 18;
222 
223     event Mint(address indexed guy, uint wad);
224     event Burn(address indexed guy, uint wad);
225 
226     function approve(address guy) public stoppable returns (bool) {
227         return super.approve(guy, uint(-1));
228     }
229 
230     function approve(address guy, uint wad) public stoppable returns (bool) {
231         return super.approve(guy, wad);
232     }
233 
234     function transferFrom(address src, address dst, uint wad)
235         public
236         stoppable
237         returns (bool)
238     {
239         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
240             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
241         }
242 
243         _balances[src] = sub(_balances[src], wad);
244         _balances[dst] = add(_balances[dst], wad);
245 
246         emit Transfer(src, dst, wad);
247 
248         return true;
249     }
250 
251     function push(address dst, uint wad) public {
252         transferFrom(msg.sender, dst, wad);
253     }
254     function pull(address src, uint wad) public {
255         transferFrom(src, msg.sender, wad);
256     }
257     function move(address src, address dst, uint wad) public {
258         transferFrom(src, dst, wad);
259     }
260 
261     function mint(uint wad) public {
262         mint(msg.sender, wad);
263     }
264     function burn(uint wad) public {
265         burn(msg.sender, wad);
266     }
267     function mint(address guy, uint wad) public auth stoppable {
268         _balances[guy] = add(_balances[guy], wad);
269         _supply = add(_supply, wad);
270         emit Mint(guy, wad);
271     }
272     function burn(address guy, uint wad) public auth stoppable {
273         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
274             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
275         }
276 
277         _balances[guy] = sub(_balances[guy], wad);
278         _supply = sub(_supply, wad);
279         emit Burn(guy, wad);
280     }
281 
282     function setName(bytes32 name_) public auth {
283         name = name_;
284     }
285 }