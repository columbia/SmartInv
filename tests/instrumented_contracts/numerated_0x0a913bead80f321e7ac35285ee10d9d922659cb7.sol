1 pragma solidity >=0.5.0 <0.6.0;
2 
3 contract DSAuthority {
4     function canCall(
5         address src, address dst, bytes4 sig
6     ) public view returns (bool);
7 }
8 
9 
10 contract DSAuthEvents {
11     event LogSetAuthority (address indexed authority);
12     event LogSetOwner     (address indexed owner);
13 }
14 
15 
16 contract DSAuth is DSAuthEvents {
17     DSAuthority  public  authority;
18     address      public  owner;
19 
20     constructor() public {
21         owner = msg.sender;
22         emit LogSetOwner(msg.sender);
23     }
24 
25     function setOwner(address owner_)
26         public
27         auth
28     {
29         owner = owner_;
30         emit LogSetOwner(owner);
31     }
32 
33     function setAuthority(DSAuthority authority_)
34         public
35         auth
36     {
37         authority = authority_;
38         emit LogSetAuthority(address(authority));
39     }
40 
41     modifier auth {
42         require(isAuthorized(msg.sender, msg.sig), "ds-auth-unauthorized");
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
54             return authority.canCall(src, address(this), sig);
55         }
56     }
57 }
58 
59 
60 contract DSNote {
61     event LogNote(
62         bytes4   indexed  sig,
63         address  indexed  guy,
64         bytes32  indexed  foo,
65         bytes32  indexed  bar,
66         uint256           wad,
67         bytes             fax
68     ) anonymous;
69 
70     modifier note {
71         bytes32 foo;
72         bytes32 bar;
73         uint256 wad;
74 
75         assembly {
76             foo := calldataload(4)
77             bar := calldataload(36)
78             wad := callvalue
79         }
80 
81         emit LogNote(msg.sig, msg.sender, foo, bar, wad, msg.data);
82 
83         _;
84     }
85 }
86 
87 
88 contract ERC20 {
89     function totalSupply() public view returns (uint supply);
90     function balanceOf( address who ) public view returns (uint value);
91     function allowance( address owner, address spender ) public view returns (uint _allowance);
92 
93     function transfer( address to, uint value) public returns (bool ok);
94     function transferFrom( address from, address to, uint value) public returns (bool ok);
95     function approve( address spender, uint value) public returns (bool ok);
96 
97     event Transfer( address indexed from, address indexed to, uint value);
98     event Approval( address indexed owner, address indexed spender, uint value);
99 }
100 
101 
102 contract DSMath {
103     function add(uint x, uint y) internal pure returns (uint z) {
104         require((z = x + y) >= x, "ds-math-add-overflow");
105     }
106     function sub(uint x, uint y) internal pure returns (uint z) {
107         require((z = x - y) <= x, "ds-math-sub-underflow");
108     }
109     function mul(uint x, uint y) internal pure returns (uint z) {
110         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
111     }
112 
113     function min(uint x, uint y) internal pure returns (uint z) {
114         return x <= y ? x : y;
115     }
116     function max(uint x, uint y) internal pure returns (uint z) {
117         return x >= y ? x : y;
118     }
119     function imin(int x, int y) internal pure returns (int z) {
120         return x <= y ? x : y;
121     }
122     function imax(int x, int y) internal pure returns (int z) {
123         return x >= y ? x : y;
124     }
125 
126     uint constant WAD = 10 ** 18;
127     uint constant RAY = 10 ** 27;
128 
129     function wmul(uint x, uint y) internal pure returns (uint z) {
130         z = add(mul(x, y), WAD / 2) / WAD;
131     }
132     function rmul(uint x, uint y) internal pure returns (uint z) {
133         z = add(mul(x, y), RAY / 2) / RAY;
134     }
135     function wdiv(uint x, uint y) internal pure returns (uint z) {
136         z = add(mul(x, WAD), y / 2) / y;
137     }
138     function rdiv(uint x, uint y) internal pure returns (uint z) {
139         z = add(mul(x, RAY), y / 2) / y;
140     }
141 
142     // This famous algorithm is called "exponentiation by squaring"
143     // and calculates x^n with x as fixed-point and n as regular unsigned.
144     //
145     // It's O(log n), instead of O(n) for naive repeated multiplication.
146     //
147     // These facts are why it works:
148     //
149     //  If n is even, then x^n = (x^2)^(n/2).
150     //  If n is odd,  then x^n = x * x^(n-1),
151     //   and applying the equation for even x gives
152     //    x^n = x * (x^2)^((n-1) / 2).
153     //
154     //  Also, EVM division is flooring and
155     //    floor[(n-1) / 2] = floor[n / 2].
156     //
157     function rpow(uint x, uint n) internal pure returns (uint z) {
158         z = n % 2 != 0 ? x : RAY;
159 
160         for (n /= 2; n != 0; n /= 2) {
161             x = rmul(x, x);
162 
163             if (n % 2 != 0) {
164                 z = rmul(z, x);
165             }
166         }
167     }
168 }
169 
170 
171 contract DSStop is DSNote, DSAuth {
172     bool public stopped;
173 
174     modifier stoppable {
175         require(!stopped, "ds-stop-is-stopped");
176         _;
177     }
178     function stop() public auth note {
179         stopped = true;
180     }
181     function start() public auth note {
182         stopped = false;
183     }
184 }
185 
186 
187 contract Managed {
188     /// @notice The address of the manager is the only address that can call
189     ///  a function with this modifier
190     modifier onlyManager { require(msg.sender == manager); _; }
191 
192     address public manager;
193 
194     constructor() public { manager = msg.sender;}
195 
196     /// @notice Changes the manager of the contract
197     /// @param _newManager The new manager of the contract
198     function changeManager(address _newManager) public onlyManager {
199         manager = _newManager;
200     }
201     
202     /// @dev Internal function to determine if an address is a contract
203     /// @param _addr The address being queried
204     /// @return True if `_addr` is a contract
205     function isContract(address _addr) view internal returns(bool) {
206         uint size = 0;
207         assembly {
208             size := extcodesize(_addr)
209         }
210         return size > 0;
211     }
212 }
213 
214 
215 contract ControllerManager {
216     function onTransfer(address _from, address _to, uint _amount) public returns(uint);
217 }
218 
219 
220 contract DOSToken is ERC20, DSMath, DSStop, Managed {
221     string public constant name = 'DOS Network Token';
222     string public constant symbol = 'DOS';
223     uint256 public constant decimals = 18;
224     uint256 private constant MAX_SUPPLY = 95 * 1e7 * 1e18; // 950 million total supply, as 50 million was burnt.
225     uint256 private _supply = MAX_SUPPLY;
226     
227     mapping (address => uint256) _balances;
228     mapping (address => mapping (address => uint256))  _approvals;
229     
230     constructor() public {
231         _balances[msg.sender] = _supply;
232         emit Transfer(address(0), msg.sender, _supply);
233     }
234 
235     function totalSupply() public view returns (uint) {
236         return _supply;
237     }
238     
239     function balanceOf(address src) public view returns (uint) {
240         return _balances[src];
241     }
242     
243     function allowance(address src, address guy) public view returns (uint) {
244         return _approvals[src][guy];
245     }
246 
247     function transfer(address dst, uint wad) public returns (bool) {
248         return transferFrom(msg.sender, dst, wad);
249     }
250 
251     function transferFrom(address src, address dst, uint wad) public stoppable returns (bool) {
252         require(_balances[src] >= wad, "token-insufficient-balance");
253 
254         if (isContract(manager)) {
255             wad = ControllerManager(manager).onTransfer(src, dst, wad);
256             if (wad == 0) return false;
257         }
258 
259         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
260             require(_approvals[src][msg.sender] >= wad, "token-insufficient-approval");
261             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
262         }
263 
264         _balances[src] = sub(_balances[src], wad);
265         _balances[dst] = add(_balances[dst], wad);
266 
267         emit Transfer(src, dst, wad);
268 
269         return true;
270     }
271 
272     function approve(address guy) public returns (bool) {
273         return approve(guy, uint(-1));
274     }
275 
276     function approve(address guy, uint wad) public stoppable returns (bool) {
277         _approvals[msg.sender][guy] = wad;
278         emit Approval(msg.sender, guy, wad);
279         return true;
280     }
281 
282     function burn(uint wad) public {
283         burn(msg.sender, wad);
284     }
285     
286     function burn(address guy, uint wad) public stoppable {
287         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
288             require(_approvals[guy][msg.sender] >= wad, "token-insufficient-approval");
289             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
290         }
291 
292         require(_balances[guy] >= wad, "token-insufficient-balance");
293         _balances[guy] = sub(_balances[guy], wad);
294         _supply = sub(_supply, wad);
295         emit Transfer(guy, address(0), wad);
296     }
297     
298     /// @notice Ether sent to this contract will be returned.
299     function () external {}
300 
301     /// @notice This method can be used by the owner to extract mistakenly
302     ///  sent tokens to this contract.
303     /// @param _token The address of the token contract that you want to recover
304     function rescueTokens(address _token, address _dst) public auth {
305         ERC20 token = ERC20(_token);
306         uint balance = token.balanceOf(address(this));
307         token.transfer(_dst, balance);
308     }
309 }