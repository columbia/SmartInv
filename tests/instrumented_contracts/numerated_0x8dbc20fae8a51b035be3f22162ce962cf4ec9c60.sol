1 pragma solidity ^0.4.13;
2 
3 contract DSAuthority {
4     function canCall(
5         address src, address dst, bytes4 sig
6     ) constant returns (bool);
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
18     function DSAuth() {
19         owner = msg.sender;
20         LogSetOwner(msg.sender);
21     }
22 
23     function setOwner(address owner_)
24         auth
25     {
26         owner = owner_;
27         LogSetOwner(owner);
28     }
29 
30     function setAuthority(DSAuthority authority_)
31         auth
32     {
33         authority = authority_;
34         LogSetAuthority(authority);
35     }
36 
37     modifier auth {
38         require(isAuthorized(msg.sender, msg.sig));
39         _;
40     }
41 
42     function isAuthorized(address src, bytes4 sig) internal returns (bool) {
43         if (src == address(this)) {
44             return true;
45         } else if (src == owner) {
46             return true;
47         } else if (authority == DSAuthority(0)) {
48             return false;
49         } else {
50             return authority.canCall(src, this, sig);
51         }
52     }
53 }
54 
55 contract DSNote {
56     event LogNote(
57         bytes4   indexed  sig,
58         address  indexed  guy,
59         bytes32  indexed  foo,
60         bytes32  indexed  bar,
61         uint              wad,
62         bytes             fax
63     ) anonymous;
64 
65     modifier note {
66         bytes32 foo;
67         bytes32 bar;
68 
69         assembly {
70             foo := calldataload(4)
71             bar := calldataload(36)
72         }
73 
74         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
75 
76         _;
77     }
78 }
79 
80 contract DSStop is DSNote, DSAuth {
81 
82     bool public stopped;
83 
84     modifier stoppable {
85         require(!stopped);
86         _;
87     }
88     function stop() auth note {
89         stopped = true;
90     }
91     function start() auth note {
92         stopped = false;
93     }
94 
95 }
96 
97 /// base.sol -- basic ERC20 implementation
98 
99 // Token standard API
100 // https://github.com/ethereum/EIPs/issues/20
101 
102 contract ERC20 {
103     function totalSupply() constant returns (uint supply);
104     function balanceOf( address who ) constant returns (uint value);
105     function allowance( address owner, address spender ) constant returns (uint _allowance);
106 
107     function transfer( address to, uint value) returns (bool ok);
108     function transferFrom( address from, address to, uint value) returns (bool ok);
109     function approve( address spender, uint value ) returns (bool ok);
110 
111     event Transfer( address indexed from, address indexed to, uint value);
112     event Approval( address indexed owner, address indexed spender, uint value);
113 }
114 contract DSMath {
115     function add(uint x, uint y) internal returns (uint z) {
116         require((z = x + y) >= x);
117     }
118     function sub(uint x, uint y) internal returns (uint z) {
119         require((z = x - y) <= x);
120     }
121     function mul(uint x, uint y) internal returns (uint z) {
122         require(y == 0 || (z = x * y) / y == x);
123     }
124 
125     function min(uint x, uint y) internal returns (uint z) {
126         return x <= y ? x : y;
127     }
128     function max(uint x, uint y) internal returns (uint z) {
129         return x >= y ? x : y;
130     }
131     function imin(int x, int y) internal returns (int z) {
132         return x <= y ? x : y;
133     }
134     function imax(int x, int y) internal returns (int z) {
135         return x >= y ? x : y;
136     }
137 
138     uint constant WAD = 10 ** 18;
139     uint constant RAY = 10 ** 27;
140 
141     function wmul(uint x, uint y) internal returns (uint z) {
142         z = add(mul(x, y), WAD / 2) / WAD;
143     }
144     function rmul(uint x, uint y) internal returns (uint z) {
145         z = add(mul(x, y), RAY / 2) / RAY;
146     }
147     function wdiv(uint x, uint y) internal returns (uint z) {
148         z = add(mul(x, WAD), y / 2) / y;
149     }
150     function rdiv(uint x, uint y) internal returns (uint z) {
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
169     function rpow(uint x, uint n) internal returns (uint z) {
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
182 
183 contract DSTokenBase is ERC20, DSMath {
184     uint256                                            _supply;
185     mapping (address => uint256)                       _balances;
186     mapping (address => mapping (address => uint256))  _approvals;
187 
188     function DSTokenBase(uint supply) {
189         _balances[msg.sender] = supply;
190         _supply = supply;
191     }
192 
193     function totalSupply() constant returns (uint) {
194         return _supply;
195     }
196     function balanceOf(address src) constant returns (uint) {
197         return _balances[src];
198     }
199     function allowance(address src, address guy) constant returns (uint) {
200         return _approvals[src][guy];
201     }
202 
203     function transfer(address dst, uint wad) returns (bool) {
204         return transferFrom(msg.sender, dst, wad);
205     }
206 
207     function transferFrom(address src, address dst, uint wad) returns (bool) {
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
220     function approve(address guy, uint wad) returns (bool) {
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
236     function DSToken(bytes32 symbol_) {
237         symbol = symbol_;
238     }
239 
240     event Trust(address indexed src, address indexed guy, bool wat);
241     event Mint(address indexed guy, uint wad);
242     event Burn(address indexed guy, uint wad);
243 
244     function trusted(address src, address guy) constant returns (bool) {
245         return _trusted[src][guy];
246     }
247     function trust(address guy, bool wat) stoppable {
248         _trusted[msg.sender][guy] = wat;
249         Trust(msg.sender, guy, wat);
250     }
251 
252     function approve(address guy, uint wad) stoppable returns (bool) {
253         return super.approve(guy, wad);
254     }
255     function transferFrom(address src, address dst, uint wad)
256         stoppable
257         returns (bool)
258     {
259         if (src != msg.sender && !_trusted[src][msg.sender]) {
260             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
261         }
262 
263         _balances[src] = sub(_balances[src], wad);
264         _balances[dst] = add(_balances[dst], wad);
265 
266         Transfer(src, dst, wad);
267 
268         return true;
269     }
270 
271     function push(address dst, uint wad) {
272         transferFrom(msg.sender, dst, wad);
273     }
274     function pull(address src, uint wad) {
275         transferFrom(src, msg.sender, wad);
276     }
277     function move(address src, address dst, uint wad) {
278         transferFrom(src, dst, wad);
279     }
280 
281     function mint(uint wad) {
282         mint(msg.sender, wad);
283     }
284     function burn(uint wad) {
285         burn(msg.sender, wad);
286     }
287     function mint(address guy, uint wad) auth stoppable {
288         _balances[guy] = add(_balances[guy], wad);
289         _supply = add(_supply, wad);
290         Mint(guy, wad);
291     }
292     function burn(address guy, uint wad) auth stoppable {
293         if (guy != msg.sender && !_trusted[guy][msg.sender]) {
294             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
295         }
296 
297         _balances[guy] = sub(_balances[guy], wad);
298         _supply = sub(_supply, wad);
299         Burn(guy, wad);
300     }
301 
302     // Optional token name
303     bytes32   public  name = "";
304 
305     function setName(bytes32 name_) auth {
306         name = name_;
307     }
308 }
309 
310 /// @title ERC223ReceivingContract - Standard contract implementation for compatibility with ERC223 tokens.
311 contract ERC223ReceivingContract {
312 
313     /// @dev Function that is called when a user or another contract wants to transfer funds.
314     /// @param _from Transaction initiator, analogue of msg.sender
315     /// @param _value Number of tokens to transfer.
316     /// @param _data Data containig a function signature and/or parameters
317     function tokenFallback(address _from, uint256 _value, bytes _data) public;
318 }
319 
320 /// @dev The token controller contract must implement these functions
321 contract TokenController {
322     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
323     /// @param _owner The address that sent the ether to create tokens
324     /// @return True if the ether is accepted, false if it throws
325     function proxyPayment(address _owner) payable returns(bool);
326 
327     /// @notice Notifies the controller about a token transfer allowing the
328     ///  controller to react if desired
329     /// @param _from The origin of the transfer
330     /// @param _to The destination of the transfer
331     /// @param _amount The amount of the transfer
332     /// @return False if the controller does not authorize the transfer
333     function onTransfer(address _from, address _to, uint _amount) returns(bool);
334 
335     /// @notice Notifies the controller about an approval allowing the
336     ///  controller to react if desired
337     /// @param _owner The address that calls `approve()`
338     /// @param _spender The spender in the `approve()` call
339     /// @param _amount The amount in the `approve()` call
340     /// @return False if the controller does not authorize the approval
341     function onApprove(address _owner, address _spender, uint _amount)
342         returns(bool);
343 }
344 
345 contract Controlled {
346     /// @notice The address of the controller is the only address that can call
347     ///  a function with this modifier
348     modifier onlyController { if (msg.sender != controller) throw; _; }
349 
350     address public controller;
351 
352     function Controlled() { controller = msg.sender;}
353 
354     /// @notice Changes the controller of the contract
355     /// @param _newController The new controller of the contract
356     function changeController(address _newController) onlyController {
357         controller = _newController;
358     }
359 }
360 
361 contract ApproveAndCallFallBack {
362     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
363 }
364 
365 contract PLS is DSToken("PLS"), Controlled {
366 
367     function PLS() {
368         setName("DACPLAY Token");
369     }
370 
371     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
372     ///  is approved by `_from`
373     /// @param _from The address holding the tokens being transferred
374     /// @param _to The address of the recipient
375     /// @param _amount The amount of tokens to be transferred
376     /// @return True if the transfer was successful
377     function transferFrom(address _from, address _to, uint256 _amount
378     ) returns (bool success) {
379         // Alerts the token controller of the transfer
380         if (isContract(controller)) {
381             if (!TokenController(controller).onTransfer(_from, _to, _amount))
382                throw;
383         }
384 
385         success = super.transferFrom(_from, _to, _amount);
386 
387         if (success && isContract(_to))
388         {
389             // Refer Contract Interface ApproveAndCallFallBack, using keccak256 since sha3 has been deprecated.
390             if(!_to.call(bytes4(bytes32(keccak256("receiveToken(address,uint256,address)"))), _from, _amount, this)) {
391                 // do nothing when error in call in case that the _to contract is not inherited from ReceiveAndCallFallBack
392                 // revert();
393                 // TODO: Log Some Event here to record the fail.
394                 // Even the fallback failed if there is such one, the transfer will not be revert since "revert()" is not called.
395             }
396         }
397     }
398 
399     /*
400      * ERC 223
401      * Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
402      * https://github.com/ethereum/EIPs/issues/223
403      * function transfer(address _to, uint256 _value, bytes _data) public returns (bool success);
404      */
405 
406     /// @notice Send `_value` tokens to `_to` from `msg.sender` and trigger
407     /// tokenFallback if sender is a contract.
408     /// @dev Function that is called when a user or another contract wants to transfer funds.
409     /// @param _to Address of token receiver.
410     /// @param _value Number of tokens to transfer.
411     /// @param _data Data to be sent to tokenFallback
412     /// @return Returns success of function call.
413     function transfer(
414         address _to,
415         uint256 _value,
416         bytes _data)
417         public
418         returns (bool)
419     {
420         require(transfer(_to, _value));
421 
422         if (isContract(_to)) {
423             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
424             receiver.tokenFallback(msg.sender, _value, _data);
425         }
426 
427         return true;
428     }
429 
430     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
431     ///  its behalf. This is a modified version of the ERC20 approve function
432     ///  to be a little bit safer
433     /// @param _spender The address of the account able to transfer the tokens
434     /// @param _amount The amount of tokens to be approved for transfer
435     /// @return True if the approval was successful
436     function approve(address _spender, uint256 _amount) returns (bool success) {
437         // Alerts the token controller of the approve function call
438         if (isContract(controller)) {
439             if (!TokenController(controller).onApprove(msg.sender, _spender, _amount))
440                 throw;
441         }
442         
443         return super.approve(_spender, _amount);
444     }
445 
446     function mint(address _guy, uint _wad) auth stoppable {
447         super.mint(_guy, _wad);
448 
449         Transfer(0, _guy, _wad);
450     }
451     function burn(address _guy, uint _wad) auth stoppable {
452         super.burn(_guy, _wad);
453 
454         Transfer(_guy, 0, _wad);
455     }
456 
457     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
458     ///  its behalf, and then a function is triggered in the contract that is
459     ///  being approved, `_spender`. This allows users to use their tokens to
460     ///  interact with contracts in one function call instead of two
461     /// @param _spender The address of the contract able to transfer the tokens
462     /// @param _amount The amount of tokens to be approved for transfer
463     /// @return True if the function call was successful
464     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
465     ) returns (bool success) {
466         if (!approve(_spender, _amount)) throw;
467 
468         ApproveAndCallFallBack(_spender).receiveApproval(
469             msg.sender,
470             _amount,
471             this,
472             _extraData
473         );
474 
475         return true;
476     }
477 
478     /// @dev Internal function to determine if an address is a contract
479     /// @param _addr The address being queried
480     /// @return True if `_addr` is a contract
481     function isContract(address _addr) constant internal returns(bool) {
482         uint size;
483         if (_addr == 0) return false;
484         assembly {
485             size := extcodesize(_addr)
486         }
487         return size>0;
488     }
489 
490     /// @notice The fallback function: If the contract's controller has not been
491     ///  set to 0, then the `proxyPayment` method is called which relays the
492     ///  ether and creates tokens as described in the token controller contract
493     function ()  payable {
494         if (isContract(controller)) {
495             if (! TokenController(controller).proxyPayment.value(msg.value)(msg.sender))
496                 throw;
497         } else {
498             throw;
499         }
500     }
501 
502 //////////
503 // Safety Methods
504 //////////
505 
506     /// @notice This method can be used by the controller to extract mistakenly
507     ///  sent tokens to this contract.
508     /// @param _token The address of the token contract that you want to recover
509     ///  set to 0 in case you want to extract ether.
510     function claimTokens(address _token) onlyController {
511         if (_token == 0x0) {
512             controller.transfer(this.balance);
513             return;
514         }
515 
516         ERC20 token = ERC20(_token);
517         uint balance = token.balanceOf(this);
518         token.transfer(controller, balance);
519         ClaimedTokens(_token, controller, balance);
520     }
521 
522 ////////////////
523 // Events
524 ////////////////
525 
526     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
527 
528 }
529 
530 contract MigrateController is DSAuth, TokenController {
531     PLS public  pls;
532 
533     function MigrateController(address _pls) {
534         pls = PLS(_pls);
535     }
536 
537     /// @notice The owner of this contract can change the controller of the PLS token
538     ///  Please, be sure that the owner is a trusted agent or 0x0 address.
539     /// @param _newController The address of the new controller
540     function changeController(address _newController) public auth {
541         require(_newController != 0x0);
542         pls.changeController(_newController);
543         ControllerChanged(_newController);
544     }
545     
546     // In between the offering and the network. Default settings for allowing token transfers.
547     function proxyPayment(address) public payable returns (bool) {
548         return false;
549     }
550     
551     function onTransfer(address, address, uint256) public returns (bool) {
552         return true;
553     }
554 
555     function onApprove(address, address, uint256) public returns (bool) {
556         return true;
557     }
558 
559     function mint(address _th, uint256 _amount, bytes data) auth {
560         pls.mint(_th, _amount);
561 
562         NewIssue(_th, _amount, data);
563     }
564   
565     /// @dev Internal function to determine if an address is a contract
566     /// @param _addr The address being queried
567     /// @return True if `_addr` is a contract
568     function isContract(address _addr) constant internal returns (bool) {
569         if (_addr == 0) return false;
570         uint256 size;
571         assembly {
572             size := extcodesize(_addr)
573         }
574         return (size > 0);
575     }
576 
577     function time() constant returns (uint) {
578         return block.timestamp;
579     }
580 
581     //////////
582     // Testing specific methods
583     //////////
584 
585     /// @notice This function is overridden by the test Mocks.
586     function getBlockNumber() internal constant returns (uint256) {
587         return block.number;
588     }
589 
590     //////////
591     // Safety Methods
592     //////////
593 
594     /// @notice This method can be used by the controller to extract mistakenly
595     ///  sent tokens to this contract.
596     /// @param _token The address of the token contract that you want to recover
597     ///  set to 0 in case you want to extract ether.
598     function claimTokens(address _token) public auth {
599         if (pls.controller() == address(this)) {
600             pls.claimTokens(_token);
601         }
602         if (_token == 0x0) {
603             owner.transfer(this.balance);
604             return;
605         }
606 
607         ERC20 token = ERC20(_token);
608         uint256 balance = token.balanceOf(this);
609         token.transfer(owner, balance);
610         ClaimedTokens(_token, owner, balance);
611     }
612 
613     event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
614     event NewIssue(address indexed _th, uint256 _amount, bytes data);
615     event ControllerChanged(address indexed _newController);
616 }