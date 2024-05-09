1 pragma solidity ^0.4.21;
2 
3 
4 contract DSAuthority {
5     function canCall(
6         address src, address dst, bytes4 sig
7     ) public view returns (bool);
8 }
9 
10 
11 contract DSAuthEvents {
12     event LogSetAuthority (address indexed authority);
13     event LogSetOwner     (address indexed owner);
14 }
15 
16 
17 contract DSAuth is DSAuthEvents {
18     DSAuthority  public  authority;
19     address      public  owner;
20 
21     function DSAuth() public {
22         owner = msg.sender;
23         LogSetOwner(msg.sender);
24     }
25 
26     function setOwner(address owner_)
27     public
28     auth
29     {
30         owner = owner_;
31         LogSetOwner(owner);
32     }
33 
34     function setAuthority(DSAuthority authority_)
35     public
36     auth
37     {
38         authority = authority_;
39         LogSetAuthority(authority);
40     }
41 
42     modifier auth {
43         require(isAuthorized(msg.sender, msg.sig));
44         _;
45     }
46 
47     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
48         if (src == address(this)) {
49             return true;
50         } else if (src == owner) {
51             return true;
52         } else if (authority == DSAuthority(0)) {
53             return false;
54         } else {
55             return authority.canCall(src, this, sig);
56         }
57     }
58 }
59 
60 
61 contract DSMath {
62     function add(uint x, uint y) internal pure returns (uint z) {
63         require((z = x + y) >= x);
64     }
65     function sub(uint x, uint y) internal pure returns (uint z) {
66         require((z = x - y) <= x);
67     }
68     function mul(uint x, uint y) internal pure returns (uint z) {
69         require(y == 0 || (z = x * y) / y == x);
70     }
71 
72     function min(uint x, uint y) internal pure returns (uint z) {
73         return x <= y ? x : y;
74     }
75     function max(uint x, uint y) internal pure returns (uint z) {
76         return x >= y ? x : y;
77     }
78     function imin(int x, int y) internal pure returns (int z) {
79         return x <= y ? x : y;
80     }
81     function imax(int x, int y) internal pure returns (int z) {
82         return x >= y ? x : y;
83     }
84 
85     uint constant WAD = 10 ** 18;
86     uint constant RAY = 10 ** 27;
87 
88     function wmul(uint x, uint y) internal pure returns (uint z) {
89         z = add(mul(x, y), WAD / 2) / WAD;
90     }
91     function rmul(uint x, uint y) internal pure returns (uint z) {
92         z = add(mul(x, y), RAY / 2) / RAY;
93     }
94     function wdiv(uint x, uint y) internal pure returns (uint z) {
95         z = add(mul(x, WAD), y / 2) / y;
96     }
97     function rdiv(uint x, uint y) internal pure returns (uint z) {
98         z = add(mul(x, RAY), y / 2) / y;
99     }
100 
101     // This famous algorithm is called "exponentiation by squaring"
102     // and calculates x^n with x as fixed-point and n as regular unsigned.
103     //
104     // It's O(log n), instead of O(n) for naive repeated multiplication.
105     //
106     // These facts are why it works:
107     //
108     //  If n is even, then x^n = (x^2)^(n/2).
109     //  If n is odd,  then x^n = x * x^(n-1),
110     //   and applying the equation for even x gives
111     //    x^n = x * (x^2)^((n-1) / 2).
112     //
113     //  Also, EVM division is flooring and
114     //    floor[(n-1) / 2] = floor[n / 2].
115     //
116     function rpow(uint x, uint n) internal pure returns (uint z) {
117         z = n % 2 != 0 ? x : RAY;
118 
119         for (n /= 2; n != 0; n /= 2) {
120             x = rmul(x, x);
121 
122             if (n % 2 != 0) {
123                 z = rmul(z, x);
124             }
125         }
126     }
127 }
128 
129 
130 contract DSExec {
131     function tryExec( address target, bytes calldata, uint value)
132     internal
133     returns (bool call_ret)
134     {
135         return target.call.value(value)(calldata);
136     }
137     function exec( address target, bytes calldata, uint value)
138     internal
139     {
140         if(!tryExec(target, calldata, value)) {
141             revert();
142         }
143     }
144 
145     // Convenience aliases
146     function exec( address t, bytes c )
147     internal
148     {
149         exec(t, c, 0);
150     }
151     function exec( address t, uint256 v )
152     internal
153     {
154         bytes memory c; exec(t, c, v);
155     }
156     function tryExec( address t, bytes c )
157     internal
158     returns (bool)
159     {
160         return tryExec(t, c, 0);
161     }
162     function tryExec( address t, uint256 v )
163     internal
164     returns (bool)
165     {
166         bytes memory c; return tryExec(t, c, v);
167     }
168 }
169 
170 
171 contract DSNote {
172     event LogNote(
173         bytes4   indexed  sig,
174         address  indexed  guy,
175         bytes32  indexed  foo,
176         bytes32  indexed  bar,
177         uint              wad,
178         bytes             fax
179     ) anonymous;
180 
181     modifier note {
182         bytes32 foo;
183         bytes32 bar;
184 
185         assembly {
186             foo := calldataload(4)
187             bar := calldataload(36)
188         }
189 
190         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
191 
192         _;
193     }
194 }
195 
196 
197 contract DSStop is DSNote, DSAuth {
198 
199     bool public stopped;
200 
201     modifier stoppable {
202         require(!stopped);
203         _;
204     }
205     function stop() public auth note {
206         stopped = true;
207     }
208     function start() public auth note {
209         stopped = false;
210     }
211 
212 }
213 
214 
215 contract ERC20Events {
216     event Approval(address indexed src, address indexed guy, uint wad);
217     event Transfer(address indexed src, address indexed dst, uint wad);
218 }
219 
220 
221 contract ERC20 is ERC20Events {
222     function totalSupply() public view returns (uint);
223     function balanceOf(address guy) public view returns (uint);
224     function allowance(address src, address guy) public view returns (uint);
225 
226     function approve(address guy, uint wad) public returns (bool);
227     function transfer(address dst, uint wad) public returns (bool);
228     function transferFrom(
229         address src, address dst, uint wad
230     ) public returns (bool);
231 }
232 
233 
234 contract DSTokenBase is ERC20, DSMath {
235     uint256                                            _supply;
236     mapping (address => uint256)                       _balances;
237     mapping (address => mapping (address => uint256))  _approvals;
238 
239     function DSTokenBase(uint supply) public {
240         _balances[msg.sender] = supply;
241         _supply = supply;
242     }
243 
244     function totalSupply() public view returns (uint) {
245         return _supply;
246     }
247     function balanceOf(address src) public view returns (uint) {
248         return _balances[src];
249     }
250     function allowance(address src, address guy) public view returns (uint) {
251         return _approvals[src][guy];
252     }
253 
254     function transfer(address dst, uint wad) public returns (bool) {
255         return transferFrom(msg.sender, dst, wad);
256     }
257 
258     function transferFrom(address src, address dst, uint wad)
259     public
260     returns (bool)
261     {
262         if (src != msg.sender) {
263             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
264         }
265 
266         _balances[src] = sub(_balances[src], wad);
267         _balances[dst] = add(_balances[dst], wad);
268 
269         Transfer(src, dst, wad);
270 
271         return true;
272     }
273 
274     function approve(address guy, uint wad) public returns (bool) {
275         _approvals[msg.sender][guy] = wad;
276 
277         Approval(msg.sender, guy, wad);
278 
279         return true;
280     }
281 }
282 
283 
284 
285 contract DSToken is DSTokenBase(0), DSStop {
286 
287     bytes32  public  symbol;
288     uint256  public  decimals = 18; // standard token precision. override to customize
289 
290     function DSToken(bytes32 symbol_) public {
291         symbol = symbol_;
292     }
293 
294     event Mint(address indexed guy, uint wad);
295     event Burn(address indexed guy, uint wad);
296 
297     function approve(address guy) public stoppable returns (bool) {
298         return super.approve(guy, uint(-1));
299     }
300 
301     function approve(address guy, uint wad) public stoppable returns (bool) {
302         return super.approve(guy, wad);
303     }
304 
305     function transferFrom(address src, address dst, uint wad)
306         public
307         stoppable
308         returns (bool)
309     {
310         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
311             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
312         }
313 
314         _balances[src] = sub(_balances[src], wad);
315         _balances[dst] = add(_balances[dst], wad);
316 
317         Transfer(src, dst, wad);
318 
319         return true;
320     }
321 
322     function push(address dst, uint wad) public {
323         transferFrom(msg.sender, dst, wad);
324     }
325     function pull(address src, uint wad) public {
326         transferFrom(src, msg.sender, wad);
327     }
328     function move(address src, address dst, uint wad) public {
329         transferFrom(src, dst, wad);
330     }
331 
332     function mint(uint wad) public {
333         mint(msg.sender, wad);
334     }
335     function burn(uint wad) public {
336         burn(msg.sender, wad);
337     }
338     function mint(address guy, uint wad) public auth stoppable {
339         _balances[guy] = add(_balances[guy], wad);
340         _supply = add(_supply, wad);
341         Mint(guy, wad);
342     }
343     function burn(address guy, uint wad) public auth stoppable {
344         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
345             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
346         }
347 
348         _balances[guy] = sub(_balances[guy], wad);
349         _supply = sub(_supply, wad);
350         Burn(guy, wad);
351     }
352 
353     // Optional token name
354     bytes32   public  name = "";
355 
356     function setName(bytes32 name_) public auth {
357         name = name_;
358     }
359 }