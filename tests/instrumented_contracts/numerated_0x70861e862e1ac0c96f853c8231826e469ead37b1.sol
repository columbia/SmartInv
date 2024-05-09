1 pragma solidity >=0.5.0 <0.6.0;
2 
3 /// @dev The token controller contract must implement these functions
4 contract TokenController {
5     /// @notice Notifies the controller about a token transfer allowing the
6     ///  controller to react if desired
7     /// @param _from The origin of the transfer
8     /// @param _fromBalance Original token balance of _from address
9     /// @param _amount The amount of the transfer
10     /// @return The adjusted transfer amount filtered by a specific token controller.
11     function onTokenTransfer(address _from, uint _fromBalance, uint _amount) public returns(uint);
12 }
13 
14 
15 contract DSAuthority {
16     function canCall(
17         address src, address dst, bytes4 sig
18     ) public view returns (bool);
19 }
20 
21 contract DSAuthEvents {
22     event LogSetAuthority (address indexed authority);
23     event LogSetOwner     (address indexed owner);
24 }
25 
26 contract DSAuth is DSAuthEvents {
27     DSAuthority  public  authority;
28     address      public  owner;
29 
30     constructor() public {
31         owner = msg.sender;
32         emit LogSetOwner(msg.sender);
33     }
34 
35     function setOwner(address owner_)
36         public
37         auth
38     {
39         owner = owner_;
40         emit LogSetOwner(owner);
41     }
42 
43     function setAuthority(DSAuthority authority_)
44         public
45         auth
46     {
47         authority = authority_;
48         emit LogSetAuthority(address(authority));
49     }
50 
51     modifier auth {
52         require(isAuthorized(msg.sender, msg.sig), "ds-auth-unauthorized");
53         _;
54     }
55 
56     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
57         if (src == address(this)) {
58             return true;
59         } else if (src == owner) {
60             return true;
61         } else if (authority == DSAuthority(0)) {
62             return false;
63         } else {
64             return authority.canCall(src, address(this), sig);
65         }
66     }
67 }
68 
69 
70 contract DSNote {
71     event LogNote(
72         bytes4   indexed  sig,
73         address  indexed  guy,
74         bytes32  indexed  foo,
75         bytes32  indexed  bar,
76         uint256           wad,
77         bytes             fax
78     ) anonymous;
79 
80     modifier note {
81         bytes32 foo;
82         bytes32 bar;
83         uint256 wad;
84 
85         assembly {
86             foo := calldataload(4)
87             bar := calldataload(36)
88             wad := callvalue
89         }
90 
91         emit LogNote(msg.sig, msg.sender, foo, bar, wad, msg.data);
92 
93         _;
94     }
95 }
96 
97 
98 contract ERC20 {
99     function totalSupply() public view returns (uint supply);
100     function balanceOf( address who ) public view returns (uint value);
101     function allowance( address owner, address spender ) public view returns (uint _allowance);
102 
103     function transfer( address to, uint value) public returns (bool ok);
104     function transferFrom( address from, address to, uint value) public returns (bool ok);
105     function approve( address spender, uint value) public returns (bool ok);
106 
107     event Transfer( address indexed from, address indexed to, uint value);
108     event Approval( address indexed owner, address indexed spender, uint value);
109 }
110 
111 
112 
113 
114 
115 contract DSMath {
116     function add(uint x, uint y) internal pure returns (uint z) {
117         require((z = x + y) >= x, "ds-math-add-overflow");
118     }
119     function sub(uint x, uint y) internal pure returns (uint z) {
120         require((z = x - y) <= x, "ds-math-sub-underflow");
121     }
122     function mul(uint x, uint y) internal pure returns (uint z) {
123         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
124     }
125 
126     function min(uint x, uint y) internal pure returns (uint z) {
127         return x <= y ? x : y;
128     }
129     function max(uint x, uint y) internal pure returns (uint z) {
130         return x >= y ? x : y;
131     }
132     function imin(int x, int y) internal pure returns (int z) {
133         return x <= y ? x : y;
134     }
135     function imax(int x, int y) internal pure returns (int z) {
136         return x >= y ? x : y;
137     }
138 
139     uint constant WAD = 10 ** 18;
140     uint constant RAY = 10 ** 27;
141 
142     function wmul(uint x, uint y) internal pure returns (uint z) {
143         z = add(mul(x, y), WAD / 2) / WAD;
144     }
145     function rmul(uint x, uint y) internal pure returns (uint z) {
146         z = add(mul(x, y), RAY / 2) / RAY;
147     }
148     function wdiv(uint x, uint y) internal pure returns (uint z) {
149         z = add(mul(x, WAD), y / 2) / y;
150     }
151     function rdiv(uint x, uint y) internal pure returns (uint z) {
152         z = add(mul(x, RAY), y / 2) / y;
153     }
154 
155     // This famous algorithm is called "exponentiation by squaring"
156     // and calculates x^n with x as fixed-point and n as regular unsigned.
157     //
158     // It's O(log n), instead of O(n) for naive repeated multiplication.
159     //
160     // These facts are why it works:
161     //
162     //  If n is even, then x^n = (x^2)^(n/2).
163     //  If n is odd,  then x^n = x * x^(n-1),
164     //   and applying the equation for even x gives
165     //    x^n = x * (x^2)^((n-1) / 2).
166     //
167     //  Also, EVM division is flooring and
168     //    floor[(n-1) / 2] = floor[n / 2].
169     //
170     function rpow(uint x, uint n) internal pure returns (uint z) {
171         z = n % 2 != 0 ? x : RAY;
172 
173         for (n /= 2; n != 0; n /= 2) {
174             x = rmul(x, x);
175 
176             if (n % 2 != 0) {
177                 z = rmul(z, x);
178             }
179         }
180     }
181 }
182 
183 
184 
185 
186 
187 
188 contract DSStop is DSNote, DSAuth {
189     bool public stopped;
190 
191     modifier stoppable {
192         require(!stopped, "ds-stop-is-stopped");
193         _;
194     }
195     function stop() public auth note {
196         stopped = true;
197     }
198     function start() public auth note {
199         stopped = false;
200     }
201 }
202 
203 
204 
205 contract Managed {
206     /// @notice The address of the manager is the only address that can call
207     ///  a function with this modifier
208     modifier onlyManager { require(msg.sender == manager); _; }
209 
210     address public manager;
211 
212     constructor() public { manager = msg.sender;}
213 
214     /// @notice Changes the manager of the contract
215     /// @param _newManager The new manager of the contract
216     function changeManager(address _newManager) public onlyManager {
217         manager = _newManager;
218     }
219     
220     /// @dev Internal function to determine if an address is a contract
221     /// @param _addr The address being queried
222     /// @return True if `_addr` is a contract
223     function isContract(address _addr) view internal returns(bool) {
224         uint size = 0;
225         assembly {
226             size := extcodesize(_addr)
227         }
228         return size > 0;
229     }
230 }
231 
232 
233 
234 
235 
236 
237 contract ControllerManager is DSAuth {
238     address[] public controllers;
239     
240     function addController(address _ctrl) public auth {
241         require(_ctrl != address(0));
242         controllers.push(_ctrl);
243     }
244     
245     function removeController(address _ctrl) public auth {
246         for (uint idx = 0; idx < controllers.length; idx++) {
247             if (controllers[idx] == _ctrl) {
248                 controllers[idx] = controllers[controllers.length - 1];
249                 controllers.length -= 1;
250                 return;
251             }
252         }
253     }
254     
255     // Return the adjusted transfer amount after being filtered by all token controllers.
256     function onTransfer(address _from, uint _fromBalance, uint _amount) public returns(uint) {
257         uint adjustedAmount = _amount;
258         for (uint i = 0; i < controllers.length; i++) {
259             adjustedAmount = TokenController(controllers[i]).onTokenTransfer(_from, _fromBalance, adjustedAmount);
260             require(adjustedAmount <= _amount, "TokenController-isnot-allowed-to-lift-transfer-amount");
261             if (adjustedAmount == 0) return 0;
262         }
263         return adjustedAmount;
264     }
265 }
266 
267 
268 contract DOSToken is ERC20, DSMath, DSStop, Managed {
269     string public constant name = 'DOS Network Token';
270     string public constant symbol = 'DOS';
271     uint256 public constant decimals = 18;
272     uint256 private constant MAX_SUPPLY = 1e9 * 1e18; // 1 billion total supply
273     uint256 private _supply = MAX_SUPPLY;
274     
275     mapping (address => uint256) _balances;
276     mapping (address => mapping (address => uint256))  _approvals;
277     
278     constructor() public {
279         _balances[msg.sender] = _supply;
280         emit Transfer(address(0), msg.sender, _supply);
281     }
282 
283     function totalSupply() public view returns (uint) {
284         return _supply;
285     }
286     
287     function balanceOf(address src) public view returns (uint) {
288         return _balances[src];
289     }
290     
291     function allowance(address src, address guy) public view returns (uint) {
292         return _approvals[src][guy];
293     }
294 
295     function transfer(address dst, uint wad) public returns (bool) {
296         return transferFrom(msg.sender, dst, wad);
297     }
298 
299     function transferFrom(address src, address dst, uint wad) public stoppable returns (bool) {
300         require(_balances[src] >= wad, "token-insufficient-balance");
301 
302         // Adjust token transfer amount if necessary.
303         if (isContract(manager)) {
304             wad = ControllerManager(manager).onTransfer(src, _balances[src], wad);
305             require(wad > 0, "transfer-disabled-by-ControllerManager");
306         }
307 
308         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
309             require(_approvals[src][msg.sender] >= wad, "token-insufficient-approval");
310             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
311         }
312 
313         _balances[src] = sub(_balances[src], wad);
314         _balances[dst] = add(_balances[dst], wad);
315 
316         emit Transfer(src, dst, wad);
317 
318         return true;
319     }
320 
321     function approve(address guy) public stoppable returns (bool) {
322         return approve(guy, uint(-1));
323     }
324 
325     function approve(address guy, uint wad) public stoppable returns (bool) {
326         // To change the approve amount you first have to reduce the addresses`
327         //  allowance to zero by calling `approve(_guy, 0)` if it is not
328         //  already 0 to mitigate the race condition described here:
329         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
330         require((wad == 0) || (_approvals[msg.sender][guy] == 0));
331         
332         _approvals[msg.sender][guy] = wad;
333 
334         emit Approval(msg.sender, guy, wad);
335 
336         return true;
337     }
338 
339     function burn(uint wad) public {
340         burn(msg.sender, wad);
341     }
342     
343     function mint(address guy, uint wad) public auth stoppable {
344         _balances[guy] = add(_balances[guy], wad);
345         _supply = add(_supply, wad);
346         require(_supply <= MAX_SUPPLY, "Total supply overflow");
347         emit Transfer(address(0), guy, wad);
348     }
349     
350     function burn(address guy, uint wad) public auth stoppable {
351         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
352             require(_approvals[guy][msg.sender] >= wad, "token-insufficient-approval");
353             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
354         }
355 
356         require(_balances[guy] >= wad, "token-insufficient-balance");
357         _balances[guy] = sub(_balances[guy], wad);
358         _supply = sub(_supply, wad);
359         emit Transfer(guy, address(0), wad);
360     }
361     
362     /// @notice Ether sent to this contract won't be returned, thank you.
363     function () external payable {}
364 
365     /// @notice This method can be used by the owner to extract mistakenly
366     ///  sent tokens to this contract.
367     /// @param _token The address of the token contract that you want to recover
368     ///  set to 0 in case you want to extract ether.
369     function claimTokens(address _token, address payable _dst) public auth {
370         if (_token == address(0)) {
371             _dst.transfer(address(this).balance);
372             return;
373         }
374 
375         ERC20 token = ERC20(_token);
376         uint balance = token.balanceOf(address(this));
377         token.transfer(_dst, balance);
378     }
379 }