1 pragma solidity ^0.4.13;
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
18     function DSAuth() public {
19         owner = msg.sender;
20         LogSetOwner(msg.sender);
21     }
22 
23     function setOwner(address owner_)
24         public
25         auth
26     {
27         owner = owner_;
28         LogSetOwner(owner);
29     }
30 
31     function setAuthority(DSAuthority authority_)
32         public
33         auth
34     {
35         authority = authority_;
36         LogSetAuthority(authority);
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
76         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
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
99 contract ERC20 {
100     function totalSupply() public view returns (uint supply);
101     function balanceOf( address who ) public view returns (uint value);
102     function allowance( address owner, address spender ) public view returns (uint _allowance);
103 
104     function transfer( address to, uint value) public returns (bool ok);
105     function transferFrom( address from, address to, uint value) public returns (bool ok);
106     function approve( address spender, uint value ) public returns (bool ok);
107 
108     event Transfer( address indexed from, address indexed to, uint value);
109     event Approval( address indexed owner, address indexed spender, uint value);
110 }
111 
112 contract DSMath {
113     function add(uint x, uint y) internal pure returns (uint z) {
114         require((z = x + y) >= x);
115     }
116     function sub(uint x, uint y) internal pure returns (uint z) {
117         require((z = x - y) <= x);
118     }
119     function mul(uint x, uint y) internal pure returns (uint z) {
120         require(y == 0 || (z = x * y) / y == x);
121     }
122 
123     function min(uint x, uint y) internal pure returns (uint z) {
124         return x <= y ? x : y;
125     }
126     function max(uint x, uint y) internal pure returns (uint z) {
127         return x >= y ? x : y;
128     }
129     function imin(int x, int y) internal pure returns (int z) {
130         return x <= y ? x : y;
131     }
132     function imax(int x, int y) internal pure returns (int z) {
133         return x >= y ? x : y;
134     }
135 
136     uint constant WAD = 10 ** 18;
137     uint constant RAY = 10 ** 27;
138 
139     function wmul(uint x, uint y) internal pure returns (uint z) {
140         z = add(mul(x, y), WAD / 2) / WAD;
141     }
142     function rmul(uint x, uint y) internal pure returns (uint z) {
143         z = add(mul(x, y), RAY / 2) / RAY;
144     }
145     function wdiv(uint x, uint y) internal pure returns (uint z) {
146         z = add(mul(x, WAD), y / 2) / y;
147     }
148     function rdiv(uint x, uint y) internal pure returns (uint z) {
149         z = add(mul(x, RAY), y / 2) / y;
150     }
151 
152     // This famous algorithm is called "exponentiation by squaring"
153     // and calculates x^n with x as fixed-point and n as regular unsigned.
154     //
155     // It's O(log n), instead of O(n) for naive repeated multiplication.
156     //
157     // These facts are why it works:
158     //
159     //  If n is even, then x^n = (x^2)^(n/2).
160     //  If n is odd,  then x^n = x * x^(n-1),
161     //   and applying the equation for even x gives
162     //    x^n = x * (x^2)^((n-1) / 2).
163     //
164     //  Also, EVM division is flooring and
165     //    floor[(n-1) / 2] = floor[n / 2].
166     //
167     function rpow(uint x, uint n) internal pure returns (uint z) {
168         z = n % 2 != 0 ? x : RAY;
169 
170         for (n /= 2; n != 0; n /= 2) {
171             x = rmul(x, x);
172 
173             if (n % 2 != 0) {
174                 z = rmul(z, x);
175             }
176         }
177     }
178 }
179 
180 contract DSTokenBase is ERC20, DSMath {
181     uint256                                            _supply;
182     mapping (address => uint256)                       _balances;
183     mapping (address => mapping (address => uint256))  _approvals;
184 
185     function DSTokenBase(uint supply) public {
186         _balances[msg.sender] = supply;
187         _supply = supply;
188     }
189 
190     function totalSupply() public view returns (uint) {
191         return _supply;
192     }
193     function balanceOf(address src) public view returns (uint) {
194         return _balances[src];
195     }
196     function allowance(address src, address guy) public view returns (uint) {
197         return _approvals[src][guy];
198     }
199 
200     function transfer(address dst, uint wad) public returns (bool) {
201         return transferFrom(msg.sender, dst, wad);
202     }
203 
204     function transferFrom(address src, address dst, uint wad)
205         public
206         returns (bool)
207     {
208         if (src != msg.sender) {
209             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
210         }
211 
212         _balances[src] = sub(_balances[src], wad);
213         _balances[dst] = add(_balances[dst], wad);
214 
215         Transfer(src, dst, wad);
216 
217         return true;
218     }
219 
220     function approve(address guy, uint wad) public returns (bool) {
221         _approvals[msg.sender][guy] = wad;
222 
223         Approval(msg.sender, guy, wad);
224 
225         return true;
226     }
227 }
228 
229 contract DSToken is DSTokenBase(0), DSStop {
230 
231     mapping (address => mapping (address => bool)) _trusted;
232 
233     bytes32  public  symbol;
234     uint256  public  decimals = 18; // standard token precision. override to customize
235 
236     function DSToken(bytes32 symbol_) public {
237         symbol = symbol_;
238     }
239 
240     event Trust(address indexed src, address indexed guy, bool wat);
241     event Mint(address indexed guy, uint wad);
242     event Burn(address indexed guy, uint wad);
243 
244     function trusted(address src, address guy) public view returns (bool) {
245         return _trusted[src][guy];
246     }
247     function trust(address guy, bool wat) public stoppable {
248         _trusted[msg.sender][guy] = wat;
249         Trust(msg.sender, guy, wat);
250     }
251 
252     function approve(address guy, uint wad) public stoppable returns (bool) {
253         return super.approve(guy, wad);
254     }
255     function transferFrom(address src, address dst, uint wad)
256         public
257         stoppable
258         returns (bool)
259     {
260         if (src != msg.sender && !_trusted[src][msg.sender]) {
261             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
262         }
263 
264         _balances[src] = sub(_balances[src], wad);
265         _balances[dst] = add(_balances[dst], wad);
266 
267         Transfer(src, dst, wad);
268 
269         return true;
270     }
271 
272     function push(address dst, uint wad) public {
273         transferFrom(msg.sender, dst, wad);
274     }
275     function pull(address src, uint wad) public {
276         transferFrom(src, msg.sender, wad);
277     }
278     function move(address src, address dst, uint wad) public {
279         transferFrom(src, dst, wad);
280     }
281 
282     function mint(uint wad) public {
283         mint(msg.sender, wad);
284     }
285     function burn(uint wad) public {
286         burn(msg.sender, wad);
287     }
288     function mint(address guy, uint wad) public auth stoppable {
289         _balances[guy] = add(_balances[guy], wad);
290         _supply = add(_supply, wad);
291         Mint(guy, wad);
292     }
293     function burn(address guy, uint wad) public auth stoppable {
294         if (guy != msg.sender && !_trusted[guy][msg.sender]) {
295             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
296         }
297 
298         _balances[guy] = sub(_balances[guy], wad);
299         _supply = sub(_supply, wad);
300         Burn(guy, wad);
301     }
302 
303     // Optional token name
304     bytes32   public  name = "";
305 
306     function setName(bytes32 name_) public auth {
307         name = name_;
308     }
309 }
310 
311 /// @title ERC223ReceivingContract - Standard contract implementation for compatibility with ERC223 tokens.
312 contract ERC223ReceivingContract {
313 
314     /// @dev Function that is called when a user or another contract wants to transfer funds.
315     /// @param _from Transaction initiator, analogue of msg.sender
316     /// @param _value Number of tokens to transfer.
317     /// @param _data Data containig a function signature and/or parameters
318     function tokenFallback(address _from, uint256 _value, bytes _data) public;
319 
320 
321     /// @dev For ERC20 backward compatibility, same with above tokenFallback but without data.
322     /// The function execution could fail, but do not influence the token transfer.
323     /// @param _from Transaction initiator, analogue of msg.sender
324     /// @param _value Number of tokens to transfer.
325     //  function tokenFallback(address _from, uint256 _value) public;
326 }
327 
328 /// @dev The token controller contract must implement these functions
329 contract TokenController {
330     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
331     /// @param _owner The address that sent the ether to create tokens
332     /// @return True if the ether is accepted, false if it throws
333     function proxyPayment(address _owner) payable public returns(bool);
334 
335     /// @notice Notifies the controller about a token transfer allowing the
336     ///  controller to react if desired
337     /// @param _from The origin of the transfer
338     /// @param _to The destination of the transfer
339     /// @param _amount The amount of the transfer
340     /// @return False if the controller does not authorize the transfer
341     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
342 
343     /// @notice Notifies the controller about an approval allowing the
344     ///  controller to react if desired
345     /// @param _owner The address that calls `approve()`
346     /// @param _spender The spender in the `approve()` call
347     /// @param _amount The amount in the `approve()` call
348     /// @return False if the controller does not authorize the approval
349     function onApprove(address _owner, address _spender, uint _amount) public returns(bool);
350 }
351 
352 contract Controlled {
353     /// @notice The address of the controller is the only address that can call
354     ///  a function with this modifier
355     modifier onlyController { if (msg.sender != controller) throw; _; }
356 
357     address public controller;
358 
359     function Controlled() { controller = msg.sender;}
360 
361     /// @notice Changes the controller of the contract
362     /// @param _newController The new controller of the contract
363     function changeController(address _newController) onlyController {
364         controller = _newController;
365     }
366 }
367 
368 contract ApproveAndCallFallBack {
369     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
370 }
371 
372 contract ERC223 {
373     function transfer(address to, uint amount, bytes data) public returns (bool ok);
374 
375     function transferFrom(address from, address to, uint256 amount, bytes data) public returns (bool ok);
376 
377     function transfer(address to, uint amount, bytes data, string custom_fallback) public returns (bool ok);
378 
379     function transferFrom(address from, address to, uint256 amount, bytes data, string custom_fallback) public returns (bool ok);
380 
381     event ERC223Transfer(address indexed from, address indexed to, uint amount, bytes data);
382 
383     event ReceivingContractTokenFallbackFailed(address indexed from, address indexed to, uint amount);
384 }
385 
386 contract AGT is DSToken("AGT"), ERC223, Controlled {
387 
388     function AGT() {
389         setName("Genesis Token of ATNIO");
390     }
391 
392     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
393     ///  is approved by `_from`
394     /// @param _from The address holding the tokens being transferred
395     /// @param _to The address of the recipient
396     /// @param _amount The amount of tokens to be transferred
397     /// @return True if the transfer was successful
398     function transferFrom(address _from, address _to, uint256 _amount
399     ) public returns (bool success) {
400         // Alerts the token controller of the transfer
401         if (isContract(controller)) {
402             if (!TokenController(controller).onTransfer(_from, _to, _amount))
403                throw;
404         }
405 
406         success = super.transferFrom(_from, _to, _amount);
407 
408         if (success && isContract(_to))
409         {
410             // ERC20 backward compatiability
411             if(!_to.call(bytes4(keccak256("tokenFallback(address,uint256)")), _from, _amount)) {
412                 // do nothing when error in call in case that the _to contract is not inherited from ERC223ReceivingContract
413                 // revert();
414                 // bytes memory empty;
415 
416                 ReceivingContractTokenFallbackFailed(_from, _to, _amount);
417 
418                 // Even the fallback failed if there is such one, the transfer will not be revert since "revert()" is not called.
419             }
420         }
421     }
422 
423     /*
424      * ERC 223
425      * Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
426      */
427     function transferFrom(address _from, address _to, uint256 _amount, bytes _data)
428         public
429         returns (bool success)
430     {
431         // Alerts the token controller of the transfer
432         if (isContract(controller)) {
433             if (!TokenController(controller).onTransfer(_from, _to, _amount))
434                throw;
435         }
436 
437         require(super.transferFrom(_from, _to, _amount));
438 
439         if (isContract(_to)) {
440             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
441             receiver.tokenFallback(_from, _amount, _data);
442         }
443 
444         ERC223Transfer(_from, _to, _amount, _data);
445 
446         return true;
447     }
448 
449     /*
450      * ERC 223
451      * Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
452      * https://github.com/ethereum/EIPs/issues/223
453      * function transfer(address _to, uint256 _value, bytes _data) public returns (bool success);
454      */
455     /// @notice Send `_value` tokens to `_to` from `msg.sender` and trigger
456     /// tokenFallback if sender is a contract.
457     /// @dev Function that is called when a user or another contract wants to transfer funds.
458     /// @param _to Address of token receiver.
459     /// @param _amount Number of tokens to transfer.
460     /// @param _data Data to be sent to tokenFallback
461     /// @return Returns success of function call.
462     function transfer(
463         address _to,
464         uint256 _amount,
465         bytes _data)
466         public
467         returns (bool success)
468     {
469         return transferFrom(msg.sender, _to, _amount, _data);
470     }
471 
472     /*
473      * ERC 223
474      * Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
475      */
476     function transferFrom(address _from, address _to, uint256 _amount, bytes _data, string _custom_fallback)
477         public
478         returns (bool success)
479     {
480         // Alerts the token controller of the transfer
481         if (isContract(controller)) {
482             if (!TokenController(controller).onTransfer(_from, _to, _amount))
483                throw;
484         }
485 
486         require(super.transferFrom(_from, _to, _amount));
487 
488         if (isContract(_to)) {
489             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
490             receiver.call.value(0)(bytes4(keccak256(_custom_fallback)), _from, _amount, _data);
491         }
492 
493         ERC223Transfer(_from, _to, _amount, _data);
494 
495         return true;
496     }
497 
498     /*
499      * ERC 223
500      * Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
501      */
502     function transfer(
503         address _to, 
504         uint _amount, 
505         bytes _data, 
506         string _custom_fallback)
507         public 
508         returns (bool success)
509     {
510         return transferFrom(msg.sender, _to, _amount, _data, _custom_fallback);
511     }
512 
513     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
514     ///  its behalf. This is a modified version of the ERC20 approve function
515     ///  to be a little bit safer
516     /// @param _spender The address of the account able to transfer the tokens
517     /// @param _amount The amount of tokens to be approved for transfer
518     /// @return True if the approval was successful
519     function approve(address _spender, uint256 _amount) returns (bool success) {
520         // Alerts the token controller of the approve function call
521         if (isContract(controller)) {
522             if (!TokenController(controller).onApprove(msg.sender, _spender, _amount))
523                 throw;
524         }
525         
526         return super.approve(_spender, _amount);
527     }
528 
529     function mint(address _guy, uint _wad) auth stoppable {
530         super.mint(_guy, _wad);
531 
532         Transfer(0, _guy, _wad);
533     }
534     function burn(address _guy, uint _wad) auth stoppable {
535         super.burn(_guy, _wad);
536 
537         Transfer(_guy, 0, _wad);
538     }
539 
540     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
541     ///  its behalf, and then a function is triggered in the contract that is
542     ///  being approved, `_spender`. This allows users to use their tokens to
543     ///  interact with contracts in one function call instead of two
544     /// @param _spender The address of the contract able to transfer the tokens
545     /// @param _amount The amount of tokens to be approved for transfer
546     /// @return True if the function call was successful
547     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
548     ) returns (bool success) {
549         if (!approve(_spender, _amount)) throw;
550 
551         ApproveAndCallFallBack(_spender).receiveApproval(
552             msg.sender,
553             _amount,
554             this,
555             _extraData
556         );
557 
558         return true;
559     }
560 
561     /// @dev Internal function to determine if an address is a contract
562     /// @param _addr The address being queried
563     /// @return True if `_addr` is a contract
564     function isContract(address _addr) constant internal returns(bool) {
565         uint size;
566         if (_addr == 0) return false;
567         assembly {
568             size := extcodesize(_addr)
569         }
570         return size>0;
571     }
572 
573     /// @notice The fallback function: If the contract's controller has not been
574     ///  set to 0, then the `proxyPayment` method is called which relays the
575     ///  ether and creates tokens as described in the token controller contract
576     function ()  payable {
577         if (isContract(controller)) {
578             if (! TokenController(controller).proxyPayment.value(msg.value)(msg.sender))
579                 throw;
580         } else {
581             throw;
582         }
583     }
584 
585 //////////
586 // Safety Methods
587 //////////
588 
589     /// @notice This method can be used by the controller to extract mistakenly
590     ///  sent tokens to this contract.
591     /// @param _token The address of the token contract that you want to recover
592     ///  set to 0 in case you want to extract ether.
593     function claimTokens(address _token) onlyController {
594         if (_token == 0x0) {
595             controller.transfer(this.balance);
596             return;
597         }
598 
599         ERC20 token = ERC20(_token);
600         uint balance = token.balanceOf(this);
601         token.transfer(controller, balance);
602         ClaimedTokens(_token, controller, balance);
603     }
604 
605 ////////////////
606 // Events
607 ////////////////
608 
609     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
610 }