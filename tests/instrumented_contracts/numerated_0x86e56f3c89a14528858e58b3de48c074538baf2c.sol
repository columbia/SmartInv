1 pragma solidity ^0.4.23;
2 
3 contract DSAuthority {
4     function canCall(
5         address src, address dst, bytes4 sig
6     ) public view returns (bool);
7 }
8 
9 contract DSAuthEvents {
10     event LogSetAuthority (address indexed authority);
11     event LogSetOwner     (address indexed owner);
12 }
13 
14 contract DSAuth is DSAuthEvents {
15     DSAuthority  public  authority;
16     address      public  owner;
17 
18     constructor() public {
19         owner = msg.sender;
20         emit LogSetOwner(msg.sender);
21     }
22 
23     function setOwner(address owner_)
24         public
25         auth
26     {
27         owner = owner_;
28         emit LogSetOwner(owner);
29     }
30 
31     function setAuthority(DSAuthority authority_)
32         public
33         auth
34     {
35         authority = authority_;
36         emit LogSetAuthority(authority);
37     }
38 
39     modifier auth {
40         require(isAuthorized(msg.sender, msg.sig));
41         _;
42     }
43 
44     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
45         if (src == address(this)) {
46             return true;
47         } else if (src == owner) {
48             return true;
49         } else if (authority == DSAuthority(0)) {
50             return false;
51         } else {
52             return authority.canCall(src, this, sig);
53         }
54     }
55 }
56 
57 contract DSNote {
58     event LogNote(
59         bytes4   indexed  sig,
60         address  indexed  guy,
61         bytes32  indexed  foo,
62         bytes32  indexed  bar,
63         uint              wad,
64         bytes             fax
65     ) anonymous;
66 
67     modifier note {
68         bytes32 foo;
69         bytes32 bar;
70 
71         assembly {
72             foo := calldataload(4)
73             bar := calldataload(36)
74         }
75 
76         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
77 
78         _;
79     }
80 }
81 
82 contract DSStop is DSNote, DSAuth {
83 
84     bool public stopped;
85 
86     modifier stoppable {
87         require(!stopped);
88         _;
89     }
90     function stop() public auth note {
91         stopped = true;
92     }
93     function start() public auth note {
94         stopped = false;
95     }
96 
97 }
98 
99 contract ERC20Events {
100     event Approval(address indexed src, address indexed guy, uint wad);
101     event Transfer(address indexed src, address indexed dst, uint wad);
102 }
103 
104 contract ERC20 is ERC20Events {
105     function totalSupply() public view returns (uint);
106     function balanceOf(address guy) public view returns (uint);
107     function allowance(address src, address guy) public view returns (uint);
108 
109     function approve(address guy, uint wad) public returns (bool);
110     function transfer(address dst, uint wad) public returns (bool);
111     function transferFrom(
112         address src, address dst, uint wad
113     ) public returns (bool);
114 }
115 
116 contract DSMath {
117     function add(uint x, uint y) internal pure returns (uint z) {
118         require((z = x + y) >= x);
119     }
120     function sub(uint x, uint y) internal pure returns (uint z) {
121         require((z = x - y) <= x);
122     }
123     function mul(uint x, uint y) internal pure returns (uint z) {
124         require(y == 0 || (z = x * y) / y == x);
125     }
126 
127     function min(uint x, uint y) internal pure returns (uint z) {
128         return x <= y ? x : y;
129     }
130     function max(uint x, uint y) internal pure returns (uint z) {
131         return x >= y ? x : y;
132     }
133     function imin(int x, int y) internal pure returns (int z) {
134         return x <= y ? x : y;
135     }
136     function imax(int x, int y) internal pure returns (int z) {
137         return x >= y ? x : y;
138     }
139 
140     uint constant WAD = 10 ** 18;
141     uint constant RAY = 10 ** 27;
142 
143     function wmul(uint x, uint y) internal pure returns (uint z) {
144         z = add(mul(x, y), WAD / 2) / WAD;
145     }
146     function rmul(uint x, uint y) internal pure returns (uint z) {
147         z = add(mul(x, y), RAY / 2) / RAY;
148     }
149     function wdiv(uint x, uint y) internal pure returns (uint z) {
150         z = add(mul(x, WAD), y / 2) / y;
151     }
152     function rdiv(uint x, uint y) internal pure returns (uint z) {
153         z = add(mul(x, RAY), y / 2) / y;
154     }
155 
156     // This famous algorithm is called "exponentiation by squaring"
157     // and calculates x^n with x as fixed-point and n as regular unsigned.
158     //
159     // It's O(log n), instead of O(n) for naive repeated multiplication.
160     //
161     // These facts are why it works:
162     //
163     //  If n is even, then x^n = (x^2)^(n/2).
164     //  If n is odd,  then x^n = x * x^(n-1),
165     //   and applying the equation for even x gives
166     //    x^n = x * (x^2)^((n-1) / 2).
167     //
168     //  Also, EVM division is flooring and
169     //    floor[(n-1) / 2] = floor[n / 2].
170     //
171     function rpow(uint x, uint n) internal pure returns (uint z) {
172         z = n % 2 != 0 ? x : RAY;
173 
174         for (n /= 2; n != 0; n /= 2) {
175             x = rmul(x, x);
176 
177             if (n % 2 != 0) {
178                 z = rmul(z, x);
179             }
180         }
181     }
182 }
183 
184 
185 contract DSTokenBase is ERC20, DSMath {
186     uint256                                            _supply;
187     mapping (address => uint256)                       _balances;
188     mapping (address => mapping (address => uint256))  _approvals;
189 
190     constructor(uint supply) public {
191         _balances[msg.sender] = supply;
192         _supply = supply;
193     }
194 
195     function totalSupply() public view returns (uint) {
196         return _supply;
197     }
198     function balanceOf(address src) public view returns (uint) {
199         return _balances[src];
200     }
201     function allowance(address src, address guy) public view returns (uint) {
202         return _approvals[src][guy];
203     }
204 
205     function transfer(address dst, uint wad) public returns (bool) {
206         return transferFrom(msg.sender, dst, wad);
207     }
208 
209     function transferFrom(address src, address dst, uint wad)
210         public
211         returns (bool)
212     {
213         if (src != msg.sender) {
214             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
215         }
216 
217         _balances[src] = sub(_balances[src], wad);
218         _balances[dst] = add(_balances[dst], wad);
219 
220         emit Transfer(src, dst, wad);
221 
222         return true;
223     }
224 
225     function approve(address guy, uint wad) public returns (bool) {
226         _approvals[msg.sender][guy] = wad;
227 
228         emit Approval(msg.sender, guy, wad);
229 
230         return true;
231     }
232 }
233 
234 contract DSToken is DSTokenBase(0), DSStop {
235 
236     bytes32  public  symbol;
237     uint256  public  decimals = 18; // standard token precision. override to customize
238 
239     constructor(bytes32 symbol_) public {
240         symbol = symbol_;
241     }
242 
243     event Mint(address indexed guy, uint wad);
244     event Burn(address indexed guy, uint wad);
245 
246     function approve(address guy) public stoppable returns (bool) {
247         return super.approve(guy, uint(-1));
248     }
249 
250     function approve(address guy, uint wad) public stoppable returns (bool) {
251         return super.approve(guy, wad);
252     }
253 
254     function transferFrom(address src, address dst, uint wad)
255         public
256         stoppable
257         returns (bool)
258     {
259         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
260             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
261         }
262 
263         _balances[src] = sub(_balances[src], wad);
264         _balances[dst] = add(_balances[dst], wad);
265 
266         emit Transfer(src, dst, wad);
267 
268         return true;
269     }
270 
271     function push(address dst, uint wad) public {
272         transferFrom(msg.sender, dst, wad);
273     }
274     function pull(address src, uint wad) public {
275         transferFrom(src, msg.sender, wad);
276     }
277     function move(address src, address dst, uint wad) public {
278         transferFrom(src, dst, wad);
279     }
280 
281     function mint(uint wad) public {
282         mint(msg.sender, wad);
283     }
284     function burn(uint wad) public {
285         burn(msg.sender, wad);
286     }
287     function mint(address guy, uint wad) public auth stoppable {
288         _balances[guy] = add(_balances[guy], wad);
289         _supply = add(_supply, wad);
290         emit Mint(guy, wad);
291     }
292     function burn(address guy, uint wad) public auth stoppable {
293         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
294             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
295         }
296 
297         _balances[guy] = sub(_balances[guy], wad);
298         _supply = sub(_supply, wad);
299         emit Burn(guy, wad);
300     }
301 
302     // Optional token name
303     bytes32   public  name = "";
304 
305     function setName(bytes32 name_) public auth {
306         name = name_;
307     }
308 }
309 
310 /// @title ERC223ReceivingContract - Standard contract implementation for compatibility with ERC223 tokens.
311 interface ERC223ReceivingContract {
312 
313     /// @dev Function that is called when a user or another contract wants to transfer funds.
314     /// @param _from Transaction initiator, analogue of msg.sender
315     /// @param _value Number of tokens to transfer.
316     /// @param _data Data containig a function signature and/or parameters
317     function tokenFallback(address _from, uint256 _value, bytes _data) public;
318 
319 
320     /// @dev For ERC20 backward compatibility, same with above tokenFallback but without data.
321     /// The function execution could fail, but do not influence the token transfer.
322     /// @param _from Transaction initiator, analogue of msg.sender
323     /// @param _value Number of tokens to transfer.
324     //  function tokenFallback(address _from, uint256 _value) public;
325 }
326 
327 /// @dev The token controller contract must implement these functions
328 contract TokenController {
329     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
330     /// @param _owner The address that sent the ether to create tokens
331     /// @return True if the ether is accepted, false if it throws
332     function proxyPayment(address _owner) payable public returns (bool);
333 
334     /// @notice Notifies the controller about a token transfer allowing the
335     ///  controller to react if desired
336     /// @param _from The origin of the transfer
337     /// @param _to The destination of the transfer
338     /// @param _amount The amount of the transfer
339     /// @return False if the controller does not authorize the transfer
340     function onTransfer(address _from, address _to, uint _amount) public returns (bool);
341 
342     /// @notice Notifies the controller about an approval allowing the
343     ///  controller to react if desired
344     /// @param _owner The address that calls `approve()`
345     /// @param _spender The spender in the `approve()` call
346     /// @param _amount The amount in the `approve()` call
347     /// @return False if the controller does not authorize the approval
348     function onApprove(address _owner, address _spender, uint _amount) public returns (bool);
349 }
350 
351 
352 contract Controlled {
353     /// @notice The address of the controller is the only address that can call
354     ///  a function with this modifier
355     modifier onlyController { if (msg.sender != controller) throw; _; }
356 
357     address public controller;
358 
359     constructor() public { controller = msg.sender;}
360 
361     /// @notice Changes the controller of the contract
362     /// @param _newController The new controller of the contract
363     function changeController(address _newController) onlyController {
364         controller = _newController;
365     }
366 }
367 
368 interface ApproveAndCallFallBack {
369     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
370 }
371 
372 interface ERC223 {
373     function transfer(address to, uint amount, bytes data) public returns (bool ok);
374 
375     function transferFrom(address from, address to, uint256 amount, bytes data) public returns (bool ok);
376 
377     event ERC223Transfer(address indexed from, address indexed to, uint amount, bytes data);
378 
379     event ReceivingContractTokenFallbackFailed(address indexed from, address indexed to, uint amount);
380 }
381 
382 contract RING is DSToken("RING"), ERC223, Controlled {
383 
384     constructor() public {
385         setName("Evolution Land Global Token");
386     }
387 
388     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
389     ///  is approved by `_from`
390     /// @param _from The address holding the tokens being transferred
391     /// @param _to The address of the recipient
392     /// @param _amount The amount of tokens to be transferred
393     /// @return True if the transfer was successful
394     function transferFrom(address _from, address _to, uint256 _amount
395     ) public returns (bool success) {
396         // Alerts the token controller of the transfer
397         if (isContract(controller)) {
398             if (!TokenController(controller).onTransfer(_from, _to, _amount))
399                throw;
400         }
401 
402         success = super.transferFrom(_from, _to, _amount);
403 
404         if (success && isContract(_to))
405         {
406             // ERC20 backward compatiability
407             if(!_to.call(bytes4(keccak256("tokenFallback(address,uint256)")), _from, _amount)) {
408                 // do nothing when error in call in case that the _to contract is not inherited from ERC223ReceivingContract
409                 // revert();
410                 // bytes memory empty;
411 
412                 emit ReceivingContractTokenFallbackFailed(_from, _to, _amount);
413 
414                 // Even the fallback failed if there is such one, the transfer will not be revert since "revert()" is not called.
415             }
416         }
417     }
418 
419     /*
420      * ERC 223
421      * Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
422      */
423     function transferFrom(address _from, address _to, uint256 _amount, bytes _data)
424         public
425         returns (bool success)
426     {
427         // Alerts the token controller of the transfer
428         if (isContract(controller)) {
429             if (!TokenController(controller).onTransfer(_from, _to, _amount))
430                throw;
431         }
432 
433         require(super.transferFrom(_from, _to, _amount));
434 
435         if (isContract(_to)) {
436             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
437             receiver.tokenFallback(_from, _amount, _data);
438         }
439 
440         emit ERC223Transfer(_from, _to, _amount, _data);
441 
442         return true;
443     }
444 
445     /*
446      * ERC 223
447      * Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
448      * https://github.com/ethereum/EIPs/issues/223
449      * function transfer(address _to, uint256 _value, bytes _data) public returns (bool success);
450      */
451     /// @notice Send `_value` tokens to `_to` from `msg.sender` and trigger
452     /// tokenFallback if sender is a contract.
453     /// @dev Function that is called when a user or another contract wants to transfer funds.
454     /// @param _to Address of token receiver.
455     /// @param _amount Number of tokens to transfer.
456     /// @param _data Data to be sent to tokenFallback
457     /// @return Returns success of function call.
458     function transfer(
459         address _to,
460         uint256 _amount,
461         bytes _data)
462         public
463         returns (bool success)
464     {
465         return transferFrom(msg.sender, _to, _amount, _data);
466     }
467 
468     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
469     ///  its behalf. This is a modified version of the ERC20 approve function
470     ///  to be a little bit safer
471     /// @param _spender The address of the account able to transfer the tokens
472     /// @param _amount The amount of tokens to be approved for transfer
473     /// @return True if the approval was successful
474     function approve(address _spender, uint256 _amount) returns (bool success) {
475         // Alerts the token controller of the approve function call
476         if (isContract(controller)) {
477             if (!TokenController(controller).onApprove(msg.sender, _spender, _amount))
478                 throw;
479         }
480         
481         return super.approve(_spender, _amount);
482     }
483 
484     function mint(address _guy, uint _wad) auth stoppable {
485         super.mint(_guy, _wad);
486 
487         emit Transfer(0, _guy, _wad);
488     }
489     function burn(address _guy, uint _wad) auth stoppable {
490         super.burn(_guy, _wad);
491 
492         emit Transfer(_guy, 0, _wad);
493     }
494 
495     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
496     ///  its behalf, and then a function is triggered in the contract that is
497     ///  being approved, `_spender`. This allows users to use their tokens to
498     ///  interact with contracts in one function call instead of two
499     /// @param _spender The address of the contract able to transfer the tokens
500     /// @param _amount The amount of tokens to be approved for transfer
501     /// @return True if the function call was successful
502     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
503     ) returns (bool success) {
504         if (!approve(_spender, _amount)) throw;
505 
506         ApproveAndCallFallBack(_spender).receiveApproval(
507             msg.sender,
508             _amount,
509             this,
510             _extraData
511         );
512 
513         return true;
514     }
515 
516     /// @dev Internal function to determine if an address is a contract
517     /// @param _addr The address being queried
518     /// @return True if `_addr` is a contract
519     function isContract(address _addr) constant internal returns(bool) {
520         uint size;
521         if (_addr == 0) return false;
522         assembly {
523             size := extcodesize(_addr)
524         }
525         return size>0;
526     }
527 
528     /// @notice The fallback function: If the contract's controller has not been
529     ///  set to 0, then the `proxyPayment` method is called which relays the
530     ///  ether and creates tokens as described in the token controller contract
531     function ()  payable {
532         if (isContract(controller)) {
533             if (! TokenController(controller).proxyPayment.value(msg.value)(msg.sender))
534                 throw;
535         } else {
536             throw;
537         }
538     }
539 
540 //////////
541 // Safety Methods
542 //////////
543 
544     /// @notice This method can be used by the controller to extract mistakenly
545     ///  sent tokens to this contract.
546     /// @param _token The address of the token contract that you want to recover
547     ///  set to 0 in case you want to extract ether.
548     function claimTokens(address _token) onlyController {
549         if (_token == 0x0) {
550             controller.transfer(address(this).balance);
551             return;
552         }
553 
554         ERC20 token = ERC20(_token);
555         uint balance = token.balanceOf(this);
556         token.transfer(controller, balance);
557 
558         emit ClaimedTokens(_token, controller, balance);
559     }
560 
561 ////////////////
562 // Events
563 ////////////////
564 
565     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
566 }