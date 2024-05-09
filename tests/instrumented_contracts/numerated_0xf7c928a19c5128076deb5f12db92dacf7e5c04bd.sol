1 // (c) Dai Foundation, 2017
2 
3 pragma solidity ^0.4.15;
4 
5 contract DSAuthority {
6     function canCall(
7         address src, address dst, bytes4 sig
8     ) public view returns (bool);
9 }
10 
11 contract DSAuthEvents {
12     event LogSetAuthority (address indexed authority);
13     event LogSetOwner     (address indexed owner);
14 }
15 
16 contract DSAuth is DSAuthEvents {
17     DSAuthority  public  authority;
18     address      public  owner;
19 
20     function DSAuth() public {
21         owner = msg.sender;
22         LogSetOwner(msg.sender);
23     }
24 
25     function setOwner(address owner_)
26         public
27         auth
28     {
29         owner = owner_;
30         LogSetOwner(owner);
31     }
32 
33     function setAuthority(DSAuthority authority_)
34         public
35         auth
36     {
37         authority = authority_;
38         LogSetAuthority(authority);
39     }
40 
41     modifier auth {
42         require(isAuthorized(msg.sender, msg.sig));
43         _;
44     }
45 
46     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
47         if (src == address(this)) {
48             return true;
49         } else if (src == owner) {
50             return true;
51         } else if (authority == DSAuthority(0)) {
52             return false;
53         } else {
54             return authority.canCall(src, this, sig);
55         }
56     }
57 }
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
78         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
79 
80         _;
81     }
82 }
83 
84 contract DSStop is DSNote, DSAuth {
85 
86     bool public stopped;
87 
88     modifier stoppable {
89         require(!stopped);
90         _;
91     }
92     function stop() public auth note {
93         stopped = true;
94     }
95     function start() public auth note {
96         stopped = false;
97     }
98 
99 }
100 
101 contract ERC20 {
102     function totalSupply() public view returns (uint supply);
103     function balanceOf( address who ) public view returns (uint value);
104     function allowance( address owner, address spender ) public view returns (uint _allowance);
105 
106     function transfer( address to, uint value) public returns (bool ok);
107     function transferFrom( address from, address to, uint value) public returns (bool ok);
108     function approve( address spender, uint value ) public returns (bool ok);
109 
110     event Transfer( address indexed from, address indexed to, uint value);
111     event Approval( address indexed owner, address indexed spender, uint value);
112 }
113 
114 contract DSMath {
115     function add(uint x, uint y) internal pure returns (uint z) {
116         require((z = x + y) >= x);
117     }
118     function sub(uint x, uint y) internal pure returns (uint z) {
119         require((z = x - y) <= x);
120     }
121     function mul(uint x, uint y) internal pure returns (uint z) {
122         require(y == 0 || (z = x * y) / y == x);
123     }
124 
125     function min(uint x, uint y) internal pure returns (uint z) {
126         return x <= y ? x : y;
127     }
128     function max(uint x, uint y) internal pure returns (uint z) {
129         return x >= y ? x : y;
130     }
131     function imin(int x, int y) internal pure returns (int z) {
132         return x <= y ? x : y;
133     }
134     function imax(int x, int y) internal pure returns (int z) {
135         return x >= y ? x : y;
136     }
137 
138     uint constant WAD = 10 ** 18;
139     uint constant RAY = 10 ** 27;
140 
141     function wmul(uint x, uint y) internal pure returns (uint z) {
142         z = add(mul(x, y), WAD / 2) / WAD;
143     }
144     function rmul(uint x, uint y) internal pure returns (uint z) {
145         z = add(mul(x, y), RAY / 2) / RAY;
146     }
147     function wdiv(uint x, uint y) internal pure returns (uint z) {
148         z = add(mul(x, WAD), y / 2) / y;
149     }
150     function rdiv(uint x, uint y) internal pure returns (uint z) {
151         z = add(mul(x, RAY), y / 2) / y;
152     }
153 
154     // This famous algorithm is called "exponentiation by squaring"
155     // and calculates x^n with x as fixed-point and n as regular unsigned.
156     //
157     // It's O(log n), instead of O(n) for naive repeated multiplication.
158     //
159     // These facts are why it works:
160     //
161     //  If n is even, then x^n = (x^2)^(n/2).
162     //  If n is odd,  then x^n = x * x^(n-1),
163     //   and applying the equation for even x gives
164     //    x^n = x * (x^2)^((n-1) / 2).
165     //
166     //  Also, EVM division is flooring and
167     //    floor[(n-1) / 2] = floor[n / 2].
168     //
169     function rpow(uint x, uint n) internal pure returns (uint z) {
170         z = n % 2 != 0 ? x : RAY;
171 
172         for (n /= 2; n != 0; n /= 2) {
173             x = rmul(x, x);
174 
175             if (n % 2 != 0) {
176                 z = rmul(z, x);
177             }
178         }
179     }
180 }
181 
182 contract DSTokenBase is ERC20, DSMath {
183     uint256                                            _supply;
184     mapping (address => uint256)                       _balances;
185     mapping (address => mapping (address => uint256))  _approvals;
186 
187     function DSTokenBase(uint supply) public {
188         _balances[msg.sender] = supply;
189         _supply = supply;
190     }
191 
192     function totalSupply() public view returns (uint) {
193         return _supply;
194     }
195     function balanceOf(address src) public view returns (uint) {
196         return _balances[src];
197     }
198     function allowance(address src, address guy) public view returns (uint) {
199         return _approvals[src][guy];
200     }
201 
202     function transfer(address dst, uint wad) public returns (bool) {
203         return transferFrom(msg.sender, dst, wad);
204     }
205 
206     function transferFrom(address src, address dst, uint wad)
207         public
208         returns (bool)
209     {
210         if (src != msg.sender) {
211             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
212         }
213 
214         _balances[src] = sub(_balances[src], wad);
215         _balances[dst] = add(_balances[dst], wad);
216 
217         Transfer(src, dst, wad);
218 
219         return true;
220     }
221 
222     function approve(address guy, uint wad) public returns (bool) {
223         _approvals[msg.sender][guy] = wad;
224 
225         Approval(msg.sender, guy, wad);
226 
227         return true;
228     }
229 }
230 
231 contract DSToken is DSTokenBase(0), DSStop {
232 
233     mapping (address => mapping (address => bool)) _trusted;
234 
235     bytes32  public  symbol;
236     uint256  public  decimals = 18; // standard token precision. override to customize
237 
238     function DSToken(bytes32 symbol_) public {
239         symbol = symbol_;
240     }
241 
242     event Trust(address indexed src, address indexed guy, bool wat);
243     event Mint(address indexed guy, uint wad);
244     event Burn(address indexed guy, uint wad);
245 
246     function trusted(address src, address guy) public view returns (bool) {
247         return _trusted[src][guy];
248     }
249     function trust(address guy, bool wat) public stoppable {
250         _trusted[msg.sender][guy] = wat;
251         Trust(msg.sender, guy, wat);
252     }
253 
254     function approve(address guy, uint wad) public stoppable returns (bool) {
255         return super.approve(guy, wad);
256     }
257     function transferFrom(address src, address dst, uint wad)
258         public
259         stoppable
260         returns (bool)
261     {
262         if (src != msg.sender && !_trusted[src][msg.sender]) {
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
274     function push(address dst, uint wad) public {
275         transferFrom(msg.sender, dst, wad);
276     }
277     function pull(address src, uint wad) public {
278         transferFrom(src, msg.sender, wad);
279     }
280     function move(address src, address dst, uint wad) public {
281         transferFrom(src, dst, wad);
282     }
283 
284     function mint(uint wad) public {
285         mint(msg.sender, wad);
286     }
287     function burn(uint wad) public {
288         burn(msg.sender, wad);
289     }
290     function mint(address guy, uint wad) public auth stoppable {
291         _balances[guy] = add(_balances[guy], wad);
292         _supply = add(_supply, wad);
293         Mint(guy, wad);
294     }
295     function burn(address guy, uint wad) public auth stoppable {
296         if (guy != msg.sender && !_trusted[guy][msg.sender]) {
297             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
298         }
299 
300         _balances[guy] = sub(_balances[guy], wad);
301         _supply = sub(_supply, wad);
302         Burn(guy, wad);
303     }
304 
305     // Optional token name
306     bytes32   public  name = "";
307 
308     function setName(bytes32 name_) public auth {
309         name = name_;
310     }
311 }
312 
313 contract Redeemer {
314     ERC20   public from;
315     DSToken public to;
316     uint    public undo_deadline;
317     function Redeemer(ERC20 from_, DSToken to_, uint undo_deadline_) public {
318         from = from_;
319         to = to_;
320         undo_deadline = undo_deadline_;
321     }
322     function redeem() public {
323         var wad = from.balanceOf(msg.sender);
324         require(from.transferFrom(msg.sender, this, wad));
325         to.push(msg.sender, wad);
326     }
327     function undo() public {
328         var wad = to.balanceOf(msg.sender);
329         require(now < undo_deadline);
330         require(from.transfer(msg.sender, wad));
331         to.pull(msg.sender, wad);
332     }
333 }