1 pragma solidity ^0.4.13;
2 
3 
4 contract DSAuthority {
5     function canCall(
6         address src, address dst, bytes4 sig
7     ) public view returns (bool);
8 }
9 
10 contract DSAuthEvents {
11     event LogSetAuthority (address indexed authority);
12     event LogSetOwner     (address indexed owner);
13 }
14 
15 contract DSAuth is DSAuthEvents {
16     DSAuthority  public  authority;
17     address      public  owner;
18 
19     function DSAuth() public {
20         owner = msg.sender;
21         emit LogSetOwner(msg.sender);
22     }
23 
24     function setOwner(address owner_)
25         public
26         auth
27     {
28         owner = owner_;
29         emit LogSetOwner(owner);
30     }
31 
32     function setAuthority(DSAuthority authority_)
33         public
34         auth
35     {
36         authority = authority_;
37         emit LogSetAuthority(authority);
38     }
39 
40     modifier auth {
41         require(isAuthorized(msg.sender, msg.sig));
42         _;
43     }
44 
45     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
46         if (src == address(this)) {
47             return true;
48         } else if (src == owner) {
49             return true;
50         } else if (authority == DSAuthority(0)) {
51             return false;
52         } else {
53             return authority.canCall(src, this, sig);
54         }
55     }
56 }
57 
58 
59 contract DSNote {
60     event LogNote(
61         bytes4   indexed  sig,
62         address  indexed  guy,
63         bytes32  indexed  foo,
64         bytes32  indexed  bar,
65         uint              wad,
66         bytes             fax
67     ) anonymous;
68 
69     modifier note {
70         bytes32 foo;
71         bytes32 bar;
72 
73         assembly {
74             foo := calldataload(4)
75             bar := calldataload(36)
76         }
77 
78         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
79 
80         _;
81     }
82 }
83 
84 
85 contract DSStop is DSNote, DSAuth {
86 
87     bool public stopped;
88 
89     modifier stoppable {
90         require(!stopped);
91         _;
92     }
93     function stop() public auth note {
94         stopped = true;
95     }
96     function start() public auth note {
97         stopped = false;
98     }
99 
100 }
101 
102 
103 contract ERC20Events {
104     event Approval(address indexed src, address indexed guy, uint wad);
105     event Transfer(address indexed src, address indexed dst, uint wad);
106 }
107 
108 contract ERC20 is ERC20Events {
109     function totalSupply() public view returns (uint);
110     function balanceOf(address guy) public view returns (uint);
111     function allowance(address src, address guy) public view returns (uint);
112 
113     function approve(address guy, uint wad) public returns (bool);
114     function transfer(address dst, uint wad) public returns (bool);
115     function transferFrom(
116         address src, address dst, uint wad
117     ) public returns (bool);
118 }
119 
120 
121 contract DSMath {
122     function add(uint x, uint y) internal pure returns (uint z) {
123         require((z = x + y) >= x);
124     }
125     function sub(uint x, uint y) internal pure returns (uint z) {
126         require((z = x - y) <= x);
127     }
128     function mul(uint x, uint y) internal pure returns (uint z) {
129         require(y == 0 || (z = x * y) / y == x);
130     }
131 
132     function min(uint x, uint y) internal pure returns (uint z) {
133         return x <= y ? x : y;
134     }
135     function max(uint x, uint y) internal pure returns (uint z) {
136         return x >= y ? x : y;
137     }
138     function imin(int x, int y) internal pure returns (int z) {
139         return x <= y ? x : y;
140     }
141     function imax(int x, int y) internal pure returns (int z) {
142         return x >= y ? x : y;
143     }
144 
145     uint constant WAD = 10 ** 18;
146     uint constant RAY = 10 ** 27;
147 
148     function wmul(uint x, uint y) internal pure returns (uint z) {
149         z = add(mul(x, y), WAD / 2) / WAD;
150     }
151     function rmul(uint x, uint y) internal pure returns (uint z) {
152         z = add(mul(x, y), RAY / 2) / RAY;
153     }
154     function wdiv(uint x, uint y) internal pure returns (uint z) {
155         z = add(mul(x, WAD), y / 2) / y;
156     }
157     function rdiv(uint x, uint y) internal pure returns (uint z) {
158         z = add(mul(x, RAY), y / 2) / y;
159     }
160 
161     // This famous algorithm is called "exponentiation by squaring"
162     // and calculates x^n with x as fixed-point and n as regular unsigned.
163     //
164     // It's O(log n), instead of O(n) for naive repeated multiplication.
165     //
166     // These facts are why it works:
167     //
168     //  If n is even, then x^n = (x^2)^(n/2).
169     //  If n is odd,  then x^n = x * x^(n-1),
170     //   and applying the equation for even x gives
171     //    x^n = x * (x^2)^((n-1) / 2).
172     //
173     //  Also, EVM division is flooring and
174     //    floor[(n-1) / 2] = floor[n / 2].
175     //
176     function rpow(uint x, uint n) internal pure returns (uint z) {
177         z = n % 2 != 0 ? x : RAY;
178 
179         for (n /= 2; n != 0; n /= 2) {
180             x = rmul(x, x);
181 
182             if (n % 2 != 0) {
183                 z = rmul(z, x);
184             }
185         }
186     }
187 }
188 
189 
190 contract DSTokenBase is ERC20, DSMath {
191     uint256                                            _supply;
192     mapping (address => uint256)                       _balances;
193     mapping (address => mapping (address => uint256))  _approvals;
194 
195     function DSTokenBase(uint supply) public {
196         _balances[msg.sender] = supply;
197         _supply = supply;
198     }
199 
200     function totalSupply() public view returns (uint) {
201         return _supply;
202     }
203     function balanceOf(address src) public view returns (uint) {
204         return _balances[src];
205     }
206     function allowance(address src, address guy) public view returns (uint) {
207         return _approvals[src][guy];
208     }
209 
210     function transfer(address dst, uint wad) public returns (bool) {
211         return transferFrom(msg.sender, dst, wad);
212     }
213 
214     function transferFrom(address src, address dst, uint wad)
215         public
216         returns (bool)
217     {
218         if (src != msg.sender) {
219             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
220         }
221 
222         _balances[src] = sub(_balances[src], wad);
223         _balances[dst] = add(_balances[dst], wad);
224 
225         emit Transfer(src, dst, wad);
226 
227         return true;
228     }
229 
230     function approve(address guy, uint wad) public returns (bool) {
231         _approvals[msg.sender][guy] = wad;
232 
233         emit Approval(msg.sender, guy, wad);
234 
235         return true;
236     }
237 }
238 
239 
240 contract DSToken is DSTokenBase(0), DSStop {
241 
242     string  public  symbol = "";
243     string   public  name = "";
244     uint256  public  decimals = 18; // standard token precision. override to customize
245 
246     function DSToken(
247         string symbol_,
248         string name_
249     ) public {
250         symbol = symbol_;
251         name = name_;
252     }
253 
254     event Mint(address indexed guy, uint wad);
255     event Burn(address indexed guy, uint wad);
256 
257     function setName(string name_) public auth {
258         name = name_;
259     }
260 
261     function approve(address guy) public stoppable returns (bool) {
262         return super.approve(guy, uint(-1));
263     }
264 
265     function approve(address guy, uint wad) public stoppable returns (bool) {
266         return super.approve(guy, wad);
267     }
268 
269     function transferFrom(address src, address dst, uint wad)
270         public
271         stoppable
272         returns (bool)
273     {
274         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
275             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
276         }
277 
278         _balances[src] = sub(_balances[src], wad);
279         _balances[dst] = add(_balances[dst], wad);
280 
281         emit Transfer(src, dst, wad);
282 
283         return true;
284     }
285 
286     function push(address dst, uint wad) public {
287         transferFrom(msg.sender, dst, wad);
288     }
289     function pull(address src, uint wad) public {
290         transferFrom(src, msg.sender, wad);
291     }
292     function move(address src, address dst, uint wad) public {
293         transferFrom(src, dst, wad);
294     }
295 
296     function mint(uint wad) public {
297         mint(msg.sender, wad);
298     }
299     function burn(uint wad) public {
300         burn(msg.sender, wad);
301     }
302     function mint(address guy, uint wad) public auth stoppable {
303         _balances[guy] = add(_balances[guy], wad);
304         _supply = add(_supply, wad);
305         emit Mint(guy, wad);
306     }
307     function burn(address guy, uint wad) public auth stoppable {
308         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
309             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
310         }
311 
312         _balances[guy] = sub(_balances[guy], wad);
313         _supply = sub(_supply, wad);
314         emit Burn(guy, wad);
315     }
316 }