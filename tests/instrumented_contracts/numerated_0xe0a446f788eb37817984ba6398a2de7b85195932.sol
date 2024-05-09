1 pragma solidity >=0.5.0 <0.6.0;
2 
3 /// @dev The token controller contract must implement these functions
4 contract TokenController {
5     /// @notice Notifies the controller about a token transfer allowing the
6     ///  controller to react if desired
7     /// @param _from The origin of the transfer
8     /// @param _to The destination of the transfer
9     /// @param _amount The amount of the transfer
10     /// @return The adjusted transfer amount filtered by a specific token controller.
11     function onTokenTransfer(address _from, address _to, uint _amount) public returns(uint);
12 
13     /// @notice Notifies the controller about an approval allowing the
14     ///  controller to react if desired
15     /// @param _owner The address that calls `approve()`
16     /// @param _spender The spender in the `approve()` call
17     /// @param _amount The amount in the `approve()` call
18     /// @return The adjusted approve amount filtered by a specific token controller.
19     function onTokenApprove(address _owner, address _spender, uint _amount) public returns(uint);
20 }
21 
22 
23 contract DSAuthority {
24     function canCall(
25         address src, address dst, bytes4 sig
26     ) public view returns (bool);
27 }
28 
29 contract DSAuthEvents {
30     event LogSetAuthority (address indexed authority);
31     event LogSetOwner     (address indexed owner);
32 }
33 
34 contract DSAuth is DSAuthEvents {
35     DSAuthority  public  authority;
36     address      public  owner;
37 
38     constructor() public {
39         owner = msg.sender;
40         emit LogSetOwner(msg.sender);
41     }
42 
43     function setOwner(address owner_)
44         public
45         auth
46     {
47         owner = owner_;
48         emit LogSetOwner(owner);
49     }
50 
51     function setAuthority(DSAuthority authority_)
52         public
53         auth
54     {
55         authority = authority_;
56         emit LogSetAuthority(address(authority));
57     }
58 
59     modifier auth {
60         require(isAuthorized(msg.sender, msg.sig), "ds-auth-unauthorized");
61         _;
62     }
63 
64     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
65         if (src == address(this)) {
66             return true;
67         } else if (src == owner) {
68             return true;
69         } else if (authority == DSAuthority(0)) {
70             return false;
71         } else {
72             return authority.canCall(src, address(this), sig);
73         }
74     }
75 }
76 
77 
78 contract DSNote {
79     event LogNote(
80         bytes4   indexed  sig,
81         address  indexed  guy,
82         bytes32  indexed  foo,
83         bytes32  indexed  bar,
84         uint256           wad,
85         bytes             fax
86     ) anonymous;
87 
88     modifier note {
89         bytes32 foo;
90         bytes32 bar;
91         uint256 wad;
92 
93         assembly {
94             foo := calldataload(4)
95             bar := calldataload(36)
96             wad := callvalue
97         }
98 
99         emit LogNote(msg.sig, msg.sender, foo, bar, wad, msg.data);
100 
101         _;
102     }
103 }
104 
105 
106 contract ERC20 {
107     function totalSupply() public view returns (uint supply);
108     function balanceOf( address who ) public view returns (uint value);
109     function allowance( address owner, address spender ) public view returns (uint _allowance);
110 
111     function transfer( address to, uint value) public returns (bool ok);
112     function transferFrom( address from, address to, uint value) public returns (bool ok);
113     function approve( address spender, uint value) public returns (bool ok);
114 
115     event Transfer( address indexed from, address indexed to, uint value);
116     event Approval( address indexed owner, address indexed spender, uint value);
117 }
118 
119 
120 
121 
122 
123 contract DSMath {
124     function add(uint x, uint y) internal pure returns (uint z) {
125         require((z = x + y) >= x, "ds-math-add-overflow");
126     }
127     function sub(uint x, uint y) internal pure returns (uint z) {
128         require((z = x - y) <= x, "ds-math-sub-underflow");
129     }
130     function mul(uint x, uint y) internal pure returns (uint z) {
131         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
132     }
133 
134     function min(uint x, uint y) internal pure returns (uint z) {
135         return x <= y ? x : y;
136     }
137     function max(uint x, uint y) internal pure returns (uint z) {
138         return x >= y ? x : y;
139     }
140     function imin(int x, int y) internal pure returns (int z) {
141         return x <= y ? x : y;
142     }
143     function imax(int x, int y) internal pure returns (int z) {
144         return x >= y ? x : y;
145     }
146 
147     uint constant WAD = 10 ** 18;
148     uint constant RAY = 10 ** 27;
149 
150     function wmul(uint x, uint y) internal pure returns (uint z) {
151         z = add(mul(x, y), WAD / 2) / WAD;
152     }
153     function rmul(uint x, uint y) internal pure returns (uint z) {
154         z = add(mul(x, y), RAY / 2) / RAY;
155     }
156     function wdiv(uint x, uint y) internal pure returns (uint z) {
157         z = add(mul(x, WAD), y / 2) / y;
158     }
159     function rdiv(uint x, uint y) internal pure returns (uint z) {
160         z = add(mul(x, RAY), y / 2) / y;
161     }
162 
163     // This famous algorithm is called "exponentiation by squaring"
164     // and calculates x^n with x as fixed-point and n as regular unsigned.
165     //
166     // It's O(log n), instead of O(n) for naive repeated multiplication.
167     //
168     // These facts are why it works:
169     //
170     //  If n is even, then x^n = (x^2)^(n/2).
171     //  If n is odd,  then x^n = x * x^(n-1),
172     //   and applying the equation for even x gives
173     //    x^n = x * (x^2)^((n-1) / 2).
174     //
175     //  Also, EVM division is flooring and
176     //    floor[(n-1) / 2] = floor[n / 2].
177     //
178     function rpow(uint x, uint n) internal pure returns (uint z) {
179         z = n % 2 != 0 ? x : RAY;
180 
181         for (n /= 2; n != 0; n /= 2) {
182             x = rmul(x, x);
183 
184             if (n % 2 != 0) {
185                 z = rmul(z, x);
186             }
187         }
188     }
189 }
190 
191 
192 
193 
194 
195 
196 contract DSStop is DSNote, DSAuth {
197     bool public stopped;
198 
199     modifier stoppable {
200         require(!stopped, "ds-stop-is-stopped");
201         _;
202     }
203     function stop() public auth note {
204         stopped = true;
205     }
206     function start() public auth note {
207         stopped = false;
208     }
209 }
210 
211 
212 
213 contract Managed {
214     /// @notice The address of the manager is the only address that can call
215     ///  a function with this modifier
216     modifier onlyManager { require(msg.sender == manager); _; }
217 
218     address public manager;
219 
220     constructor() public { manager = msg.sender;}
221 
222     /// @notice Changes the manager of the contract
223     /// @param _newManager The new manager of the contract
224     function changeManager(address _newManager) public onlyManager {
225         manager = _newManager;
226     }
227     
228     /// @dev Internal function to determine if an address is a contract
229     /// @param _addr The address being queried
230     /// @return True if `_addr` is a contract
231     function isContract(address _addr) view internal returns(bool) {
232         uint size = 0;
233         assembly {
234             size := extcodesize(_addr)
235         }
236         return size > 0;
237     }
238 }
239 
240 
241 
242 
243 
244 
245 contract ControllerManager is DSAuth {
246     address[] public controllers;
247     
248     function addController(address _ctrl) public auth {
249         require(_ctrl != address(0));
250         controllers.push(_ctrl);
251     }
252     
253     function removeController(address _ctrl) public auth {
254         for (uint idx = 0; idx < controllers.length; idx++) {
255             if (controllers[idx] == _ctrl) {
256                 controllers[idx] = controllers[controllers.length - 1];
257                 controllers.length -= 1;
258                 return;
259             }
260         }
261     }
262     
263     // Return the adjusted transfer amount after being filtered by all token controllers.
264     function onTransfer(address _from, address _to, uint _amount) public returns(uint) {
265         uint adjustedAmount = _amount;
266         for (uint i = 0; i < controllers.length; i++) {
267             adjustedAmount = TokenController(controllers[i]).onTokenTransfer(_from, _to, adjustedAmount);
268             require(adjustedAmount <= _amount, "TokenController-isnot-allowed-to-lift-transfer-amount");
269             if (adjustedAmount == 0) return 0;
270         }
271         return adjustedAmount;
272     }
273 
274     // Return the adjusted approve amount after being filtered by all token controllers.
275     function onApprove(address _owner, address _spender, uint _amount) public returns(uint) {
276         uint adjustedAmount = _amount;
277         for (uint i = 0; i < controllers.length; i++) {
278             adjustedAmount = TokenController(controllers[i]).onTokenApprove(_owner, _spender, adjustedAmount);
279             require(adjustedAmount <= _amount, "TokenController-isnot-allowed-to-lift-approve-amount");
280             if (adjustedAmount == 0) return 0;
281         }
282         return adjustedAmount;
283     }
284 }
285 
286 
287 contract DOSToken is ERC20, DSMath, DSStop, Managed {
288     string public constant name = 'DOS Network Token';
289     string public constant symbol = 'DOS';
290     uint256 public constant decimals = 18;
291     uint256 private constant MAX_SUPPLY = 1e9 * 1e18; // 1 billion total supply
292     uint256 private _supply = MAX_SUPPLY;
293     
294     mapping (address => uint256) _balances;
295     mapping (address => mapping (address => uint256))  _approvals;
296     
297     constructor() public {
298         _balances[msg.sender] = _supply;
299         emit Transfer(address(0), msg.sender, _supply);
300     }
301 
302     function totalSupply() public view returns (uint) {
303         return _supply;
304     }
305     
306     function balanceOf(address src) public view returns (uint) {
307         return _balances[src];
308     }
309     
310     function allowance(address src, address guy) public view returns (uint) {
311         return _approvals[src][guy];
312     }
313 
314     function transfer(address dst, uint wad) public returns (bool) {
315         return transferFrom(msg.sender, dst, wad);
316     }
317 
318     function transferFrom(address src, address dst, uint wad) public stoppable returns (bool) {
319         require(_balances[src] >= wad, "token-insufficient-balance");
320 
321         // Adjust token transfer amount if necessary.
322         if (isContract(manager)) {
323             wad = ControllerManager(manager).onTransfer(src, dst, wad);
324             require(wad > 0, "transfer-disabled-by-ControllerManager");
325         }
326 
327         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
328             require(_approvals[src][msg.sender] >= wad, "token-insufficient-approval");
329             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
330         }
331 
332         _balances[src] = sub(_balances[src], wad);
333         _balances[dst] = add(_balances[dst], wad);
334 
335         emit Transfer(src, dst, wad);
336 
337         return true;
338     }
339 
340     function approve(address guy) public stoppable returns (bool) {
341         return approve(guy, uint(-1));
342     }
343 
344     function approve(address guy, uint wad) public stoppable returns (bool) {
345         // To change the approve amount you first have to reduce the addresses`
346         //  allowance to zero by calling `approve(_guy, 0)` if it is not
347         //  already 0 to mitigate the race condition described here:
348         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
349         require((wad == 0) || (_approvals[msg.sender][guy] == 0));
350 
351         // Adjust token approve amount if necessary.
352         if (isContract(manager)) {
353             wad = ControllerManager(manager).onApprove(msg.sender, guy, wad);
354             require(wad > 0, "approve-disabled-by-ControllerManager");
355         }
356         
357         _approvals[msg.sender][guy] = wad;
358 
359         emit Approval(msg.sender, guy, wad);
360 
361         return true;
362     }
363 
364     function burn(uint wad) public {
365         burn(msg.sender, wad);
366     }
367     
368     function mint(address guy, uint wad) public auth stoppable {
369         _balances[guy] = add(_balances[guy], wad);
370         _supply = add(_supply, wad);
371         require(_supply <= MAX_SUPPLY, "Total supply overflow");
372         emit Transfer(address(0), guy, wad);
373     }
374     
375     function burn(address guy, uint wad) public auth stoppable {
376         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
377             require(_approvals[guy][msg.sender] >= wad, "token-insufficient-approval");
378             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
379         }
380 
381         require(_balances[guy] >= wad, "token-insufficient-balance");
382         _balances[guy] = sub(_balances[guy], wad);
383         _supply = sub(_supply, wad);
384         emit Transfer(guy, address(0), wad);
385     }
386     
387     /// @notice Ether sent to this contract won't be returned, thank you.
388     function () external payable {}
389 
390     /// @notice This method can be used by the owner to extract mistakenly
391     ///  sent tokens to this contract.
392     /// @param _token The address of the token contract that you want to recover
393     ///  set to 0 in case you want to extract ether.
394     function claimTokens(address _token, address payable _dst) public auth {
395         if (_token == address(0)) {
396             _dst.transfer(address(this).balance);
397             return;
398         }
399 
400         ERC20 token = ERC20(_token);
401         uint balance = token.balanceOf(address(this));
402         token.transfer(_dst, balance);
403     }
404 }