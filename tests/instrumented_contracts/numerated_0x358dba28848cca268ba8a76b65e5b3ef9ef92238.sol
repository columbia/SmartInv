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
310  /*
311  * Contract that is working with ERC223 tokens
312  * https://github.com/ethereum/EIPs/issues/223
313  */
314 
315 /// @title ERC223ReceivingContract - Standard contract implementation for compatibility with ERC223 tokens.
316 contract ERC223ReceivingContract {
317 
318     /// @dev Function that is called when a user or another contract wants to transfer funds.
319     /// @param _from Transaction initiator, analogue of msg.sender
320     /// @param _value Number of tokens to transfer.
321     /// @param _data Data containig a function signature and/or parameters
322     function tokenFallback(address _from, uint256 _value, bytes _data) public;
323 
324 }
325 
326 /// @dev The token controller contract must implement these functions
327 contract TokenController {
328     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
329     /// @param _owner The address that sent the ether to create tokens
330     /// @return True if the ether is accepted, false if it throws
331     function proxyPayment(address _owner, bytes4 sig, bytes data) payable public returns (bool);
332 
333     /// @notice Notifies the controller about a token transfer allowing the
334     ///  controller to react if desired
335     /// @param _from The origin of the transfer
336     /// @param _to The destination of the transfer
337     /// @param _amount The amount of the transfer
338     /// @return False if the controller does not authorize the transfer
339     function onTransfer(address _from, address _to, uint _amount) public returns (bool);
340 
341     /// @notice Notifies the controller about an approval allowing the
342     ///  controller to react if desired
343     /// @param _owner The address that calls `approve()`
344     /// @param _spender The spender in the `approve()` call
345     /// @param _amount The amount in the `approve()` call
346     /// @return False if the controller does not authorize the approval
347     function onApprove(address _owner, address _spender, uint _amount) public returns (bool);
348 }
349 
350 contract ApproveAndCallFallBack {
351     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
352 }
353 
354 contract ERC223 {
355     function transfer(address to, uint amount, bytes data) public returns (bool ok);
356 
357     function transferFrom(address from, address to, uint256 amount, bytes data) public returns (bool ok);
358 
359     event ERC223Transfer(address indexed from, address indexed to, uint amount, bytes data);
360 }
361 
362 contract GOLD is DSToken("GOLD"), ERC223 {
363     address public controller;
364 
365     constructor() public {
366         setName("Evolution Land Gold");
367         controller = msg.sender;
368     }
369 
370 //////////
371 // Controller Methods
372 //////////
373     /// @notice Changes the controller of the contract
374     /// @param _newController The new controller of the contract
375     function changeController(address _newController) auth {
376         controller = _newController;
377     }
378 
379     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
380     ///  is approved by `_from`
381     /// @param _from The address holding the tokens being transferred
382     /// @param _to The address of the recipient
383     /// @param _amount The amount of tokens to be transferred
384     /// @return True if the transfer was successful
385     function transferFrom(address _from, address _to, uint256 _amount
386     ) public returns (bool success) {
387         // Alerts the token controller of the transfer
388         if (isContract(controller)) {
389             if (!TokenController(controller).onTransfer(_from, _to, _amount))
390                revert();
391         }
392 
393         success = super.transferFrom(_from, _to, _amount);
394     }
395 
396     /*
397      * ERC 223
398      * Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
399      */
400     function transferFrom(address _from, address _to, uint256 _amount, bytes _data)
401         public
402         returns (bool success)
403     {
404         // Alerts the token controller of the transfer
405         if (isContract(controller)) {
406             if (!TokenController(controller).onTransfer(_from, _to, _amount))
407                revert();
408         }
409 
410         require(super.transferFrom(_from, _to, _amount));
411 
412         if (isContract(_to)) {
413             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
414             receiver.tokenFallback(_from, _amount, _data);
415         }
416 
417         emit ERC223Transfer(_from, _to, _amount, _data);
418 
419         return true;
420     }
421 
422     /*
423      * ERC 223
424      * Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
425      * https://github.com/ethereum/EIPs/issues/223
426      * function transfer(address _to, uint256 _value, bytes _data) public returns (bool success);
427      */
428     /// @notice Send `_value` tokens to `_to` from `msg.sender` and trigger
429     /// tokenFallback if sender is a contract.
430     /// @dev Function that is called when a user or another contract wants to transfer funds.
431     /// @param _to Address of token receiver.
432     /// @param _amount Number of tokens to transfer.
433     /// @param _data Data to be sent to tokenFallback
434     /// @return Returns success of function call.
435     function transfer(
436         address _to,
437         uint256 _amount,
438         bytes _data)
439         public
440         returns (bool success)
441     {
442         return transferFrom(msg.sender, _to, _amount, _data);
443     }
444 
445     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
446     ///  its behalf. This is a modified version of the ERC20 approve function
447     ///  to be a little bit safer
448     /// @param _spender The address of the account able to transfer the tokens
449     /// @param _amount The amount of tokens to be approved for transfer
450     /// @return True if the approval was successful
451     function approve(address _spender, uint256 _amount) returns (bool success) {
452         // Alerts the token controller of the approve function call
453         if (isContract(controller)) {
454             if (!TokenController(controller).onApprove(msg.sender, _spender, _amount))
455                 revert();
456         }
457         
458         return super.approve(_spender, _amount);
459     }
460 
461     function issue(address _to, uint256 _amount) public auth stoppable {
462         mint(_to, _amount);
463     }
464 
465     function destroy(address _from, uint256 _amount) public auth stoppable {
466         // do not require allowance
467 
468         _balances[_from] = sub(_balances[_from], _amount);
469         _supply = sub(_supply, _amount);
470         emit Burn(_from, _amount);
471         emit Transfer(_from, 0, _amount);
472     }
473 
474     function mint(address _guy, uint _wad) auth stoppable {
475         super.mint(_guy, _wad);
476 
477         emit Transfer(0, _guy, _wad);
478     }
479     function burn(address _guy, uint _wad) auth stoppable {
480         super.burn(_guy, _wad);
481 
482         emit Transfer(_guy, 0, _wad);
483     }
484 
485     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
486     ///  its behalf, and then a function is triggered in the contract that is
487     ///  being approved, `_spender`. This allows users to use their tokens to
488     ///  interact with contracts in one function call instead of two
489     /// @param _spender The address of the contract able to transfer the tokens
490     /// @param _amount The amount of tokens to be approved for transfer
491     /// @return True if the function call was successful
492     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
493     ) returns (bool success) {
494         if (!approve(_spender, _amount)) revert();
495 
496         ApproveAndCallFallBack(_spender).receiveApproval(
497             msg.sender,
498             _amount,
499             this,
500             _extraData
501         );
502 
503         return true;
504     }
505 
506     /// @dev Internal function to determine if an address is a contract
507     /// @param _addr The address being queried
508     /// @return True if `_addr` is a contract
509     function isContract(address _addr) constant internal returns(bool) {
510         uint size;
511         if (_addr == 0) return false;
512         assembly {
513             size := extcodesize(_addr)
514         }
515         return size>0;
516     }
517 
518     /// @notice The fallback function: If the contract's controller has not been
519     ///  set to 0, then the `proxyPayment` method is called which relays the
520     ///  ether and creates tokens as described in the token controller contract
521     function ()  payable {
522         if (isContract(controller)) {
523             if (! TokenController(controller).proxyPayment.value(msg.value)(msg.sender, msg.sig, msg.data))
524                 revert();
525         } else {
526             revert();
527         }
528     }
529 
530 //////////
531 // Safety Methods
532 //////////
533 
534     /// @notice This method can be used by the owner to extract mistakenly
535     ///  sent tokens to this contract.
536     /// @param _token The address of the token contract that you want to recover
537     ///  set to 0 in case you want to extract ether.
538     function claimTokens(address _token) auth {
539         if (_token == 0x0) {
540             address(msg.sender).transfer(address(this).balance);
541             return;
542         }
543 
544         ERC20 token = ERC20(_token);
545         uint balance = token.balanceOf(this);
546         token.transfer(address(msg.sender), balance);
547 
548         emit ClaimedTokens(_token, address(msg.sender), balance);
549     }
550 
551 ////////////////
552 // Events
553 ////////////////
554 
555     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
556 }