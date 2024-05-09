1 pragma solidity ^0.4.25;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 // input  /Users/mark/site/www.artwook.com/contracts/contracts/AKC.sol
6 // flattened :  Tuesday, 21-May-19 07:12:32 UTC
7 contract DSAuthority {
8     function canCall(
9         address src, address dst, bytes4 sig
10     ) public view returns (bool);
11 }
12 
13 contract DSAuthEvents {
14     event LogSetAuthority (address indexed authority);
15     event LogSetOwner     (address indexed owner);
16 }
17 
18 contract DSAuth is DSAuthEvents {
19     DSAuthority  public  authority;
20     address      public  owner;
21 
22     constructor() public {
23         owner = msg.sender;
24         emit LogSetOwner(msg.sender);
25     }
26 
27     function setOwner(address owner_)
28         public
29         auth
30     {
31         owner = owner_;
32         emit LogSetOwner(owner);
33     }
34 
35     function setAuthority(DSAuthority authority_)
36         public
37         auth
38     {
39         authority = authority_;
40         emit LogSetAuthority(authority);
41     }
42 
43     modifier auth {
44         require(isAuthorized(msg.sender, msg.sig));
45         _;
46     }
47 
48     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
49         if (src == address(this)) {
50             return true;
51         } else if (src == owner) {
52             return true;
53         } else if (authority == DSAuthority(0)) {
54             return false;
55         } else {
56             return authority.canCall(src, this, sig);
57         }
58     }
59 }
60 
61 contract TokenController {
62     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
63     /// @param _owner The address that sent the ether to create tokens
64     /// @return True if the ether is accepted, false if it throws
65     function proxyPayment(address _owner) payable public returns (bool);
66 
67     /// @notice Notifies the controller about a token transfer allowing the
68     ///  controller to react if desired
69     /// @param _from The origin of the transfer
70     /// @param _to The destination of the transfer
71     /// @param _amount The amount of the transfer
72     /// @return False if the controller does not authorize the transfer
73     function onTransfer(address _from, address _to, uint _amount) public returns (bool);
74 
75     /// @notice Notifies the controller about an approval allowing the
76     ///  controller to react if desired
77     /// @param _owner The address that calls `approve()`
78     /// @param _spender The spender in the `approve()` call
79     /// @param _amount The amount in the `approve()` call
80     /// @return False if the controller does not authorize the approval
81     function onApprove(address _owner, address _spender, uint _amount) public returns (bool);
82 }
83 
84 contract ApproveAndCallFallBack {
85     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
86 }
87 contract ERC20Events {
88     event Approval(address indexed src, address indexed guy, uint wad);
89     event Transfer(address indexed src, address indexed dst, uint wad);
90 }
91 
92 contract ERC20 is ERC20Events {
93     function totalSupply() public view returns (uint);
94     function balanceOf(address guy) public view returns (uint);
95     function allowance(address src, address guy) public view returns (uint);
96 
97     function approve(address guy, uint wad) public returns (bool);
98     function transfer(address dst, uint wad) public returns (bool);
99     function transferFrom(
100         address src, address dst, uint wad
101     ) public returns (bool);
102 }
103 
104 contract DSMath {
105     function add(uint x, uint y) internal pure returns (uint z) {
106         require((z = x + y) >= x);
107     }
108     function sub(uint x, uint y) internal pure returns (uint z) {
109         require((z = x - y) <= x);
110     }
111     function mul(uint x, uint y) internal pure returns (uint z) {
112         require(y == 0 || (z = x * y) / y == x);
113     }
114 
115     function min(uint x, uint y) internal pure returns (uint z) {
116         return x <= y ? x : y;
117     }
118     function max(uint x, uint y) internal pure returns (uint z) {
119         return x >= y ? x : y;
120     }
121     function imin(int x, int y) internal pure returns (int z) {
122         return x <= y ? x : y;
123     }
124     function imax(int x, int y) internal pure returns (int z) {
125         return x >= y ? x : y;
126     }
127 
128     uint constant WAD = 10 ** 18;
129     uint constant RAY = 10 ** 27;
130 
131     function wmul(uint x, uint y) internal pure returns (uint z) {
132         z = add(mul(x, y), WAD / 2) / WAD;
133     }
134     function rmul(uint x, uint y) internal pure returns (uint z) {
135         z = add(mul(x, y), RAY / 2) / RAY;
136     }
137     function wdiv(uint x, uint y) internal pure returns (uint z) {
138         z = add(mul(x, WAD), y / 2) / y;
139     }
140     function rdiv(uint x, uint y) internal pure returns (uint z) {
141         z = add(mul(x, RAY), y / 2) / y;
142     }
143 
144     // This famous algorithm is called "exponentiation by squaring"
145     // and calculates x^n with x as fixed-point and n as regular unsigned.
146     //
147     // It's O(log n), instead of O(n) for naive repeated multiplication.
148     //
149     // These facts are why it works:
150     //
151     //  If n is even, then x^n = (x^2)^(n/2).
152     //  If n is odd,  then x^n = x * x^(n-1),
153     //   and applying the equation for even x gives
154     //    x^n = x * (x^2)^((n-1) / 2).
155     //
156     //  Also, EVM division is flooring and
157     //    floor[(n-1) / 2] = floor[n / 2].
158     //
159     function rpow(uint x, uint n) internal pure returns (uint z) {
160         z = n % 2 != 0 ? x : RAY;
161 
162         for (n /= 2; n != 0; n /= 2) {
163             x = rmul(x, x);
164 
165             if (n % 2 != 0) {
166                 z = rmul(z, x);
167             }
168         }
169     }
170 }
171 
172 contract DSNote {
173     event LogNote(
174         bytes4   indexed  sig,
175         address  indexed  guy,
176         bytes32  indexed  foo,
177         bytes32  indexed  bar,
178         uint              wad,
179         bytes             fax
180     ) anonymous;
181 
182     modifier note {
183         bytes32 foo;
184         bytes32 bar;
185 
186         assembly {
187             foo := calldataload(4)
188             bar := calldataload(36)
189         }
190 
191         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
192 
193         _;
194     }
195 }
196 
197 contract ERC223ReceivingContract {
198 
199     /// @dev Function that is called when a user or another contract wants to transfer funds.
200     /// @param _from Transaction initiator, analogue of msg.sender
201     /// @param _value Number of tokens to transfer.
202     /// @param _data Data containig a function signature and/or parameters
203     function tokenFallback(address _from, uint256 _value, bytes _data) public;
204 
205 
206     /// @dev For ERC20 backward compatibility, same with above tokenFallback but without data.
207     /// The function execution could fail, but do not influence the token transfer.
208     /// @param _from Transaction initiator, analogue of msg.sender
209     /// @param _value Number of tokens to transfer.
210     //  function tokenFallback(address _from, uint256 _value) public;
211 }
212 
213 contract Controlled {
214     /// @notice The address of the controller is the only address that can call
215     ///  a function with this modifier
216     modifier onlyController { if (msg.sender != controller) revert(); _; }
217 
218     address public controller;
219 
220     constructor() { controller = msg.sender;}
221 
222     /// @notice Changes the controller of the contract
223     /// @param _newController The new controller of the contract
224     function changeController(address _newController) onlyController {
225         controller = _newController;
226     }
227 }
228 
229 contract ERC223 {
230     function transfer(address to, uint amount, bytes data) public returns (bool ok);
231 
232     function transferFrom(address from, address to, uint256 amount, bytes data) public returns (bool ok);
233 
234     function transfer(address to, uint amount, bytes data, string custom_fallback) public returns (bool ok);
235 
236     function transferFrom(address from, address to, uint256 amount, bytes data, string custom_fallback) public returns (bool ok);
237 
238     event ERC223Transfer(address indexed from, address indexed to, uint amount, bytes data);
239 
240     event ReceivingContractTokenFallbackFailed(address indexed from, address indexed to, uint amount);
241 }
242 
243 contract DSTokenBase is ERC20, DSMath {
244     uint256                                            _supply;
245     mapping (address => uint256)                       _balances;
246     mapping (address => mapping (address => uint256))  _approvals;
247 
248     constructor(uint supply) public {
249         _balances[msg.sender] = supply;
250         _supply = supply;
251     }
252 
253     function totalSupply() public view returns (uint) {
254         return _supply;
255     }
256     function balanceOf(address src) public view returns (uint) {
257         return _balances[src];
258     }
259     function allowance(address src, address guy) public view returns (uint) {
260         return _approvals[src][guy];
261     }
262 
263     function transfer(address dst, uint wad) public returns (bool) {
264         return transferFrom(msg.sender, dst, wad);
265     }
266 
267     function transferFrom(address src, address dst, uint wad)
268         public
269         returns (bool)
270     {
271         if (src != msg.sender) {
272             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
273         }
274 
275         _balances[src] = sub(_balances[src], wad);
276         _balances[dst] = add(_balances[dst], wad);
277 
278         emit Transfer(src, dst, wad);
279 
280         return true;
281     }
282 
283     function approve(address guy, uint wad) public returns (bool) {
284         _approvals[msg.sender][guy] = wad;
285 
286         emit Approval(msg.sender, guy, wad);
287 
288         return true;
289     }
290 }
291 
292 contract DSStop is DSNote, DSAuth {
293 
294     bool public stopped;
295 
296     modifier stoppable {
297         require(!stopped);
298         _;
299     }
300     function stop() public auth note {
301         stopped = true;
302     }
303     function start() public auth note {
304         stopped = false;
305     }
306 
307 }
308 
309 contract DSToken is DSTokenBase(0), DSStop {
310 
311     bytes32  public  symbol;
312     uint256  public  decimals = 18; // standard token precision. override to customize
313 
314     constructor(bytes32 symbol_) public {
315         symbol = symbol_;
316     }
317 
318     event Mint(address indexed guy, uint wad);
319     event Burn(address indexed guy, uint wad);
320 
321     /* 这个方法会将所有余额授权给相应的账号 此处删除比较危险的功能 */
322     /* function approve(address guy) public stoppable returns (bool) {
323         return super.approve(guy, uint(-1));
324     } */
325 
326     function approve(address guy, uint wad) public stoppable returns (bool) {
327         return super.approve(guy, wad);
328     }
329 
330     function transferFrom(address src, address dst, uint wad)
331         public
332         stoppable
333         returns (bool)
334     {
335         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
336             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
337         }
338 
339         _balances[src] = sub(_balances[src], wad);
340         _balances[dst] = add(_balances[dst], wad);
341 
342         emit Transfer(src, dst, wad);
343 
344         return true;
345     }
346 
347     function push(address dst, uint wad) public {
348         transferFrom(msg.sender, dst, wad);
349     }
350     function pull(address src, uint wad) public {
351         transferFrom(src, msg.sender, wad);
352     }
353     function move(address src, address dst, uint wad) public {
354         transferFrom(src, dst, wad);
355     }
356 
357     function mint(uint wad) public {
358         mint(msg.sender, wad);
359     }
360     function burn(uint wad) public {
361         burn(msg.sender, wad);
362     }
363     function mint(address guy, uint wad) public auth stoppable {
364         _balances[guy] = add(_balances[guy], wad);
365         _supply = add(_supply, wad);
366         emit Mint(guy, wad);
367     }
368     function burn(address guy, uint wad) public auth stoppable {
369         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
370             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
371         }
372 
373         _balances[guy] = sub(_balances[guy], wad);
374         _supply = sub(_supply, wad);
375         emit Burn(guy, wad);
376     }
377 
378     // Optional token name
379     bytes32   public  name = "";
380 
381     function setName(bytes32 name_) public auth {
382         name = name_;
383     }
384 }
385 
386 contract AKC is DSToken("AKC"), ERC223, Controlled {
387 
388     uint256 public cap = 2e26;
389 
390     constructor() {
391         setName("ARTWOOK Coin");
392     }
393 
394     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
395     ///  is approved by `_from`
396     /// @param _from The address holding the tokens being transferred
397     /// @param _to The address of the recipient
398     /// @param _amount The amount of tokens to be transferred
399     /// @return True if the transfer was successful
400     function transferFrom(address _from, address _to, uint256 _amount
401     ) public returns (bool success) {
402         // Alerts the token controller of the transfer
403         if (isContract(controller)) {
404             if (!TokenController(controller).onTransfer(_from, _to, _amount))
405                revert();
406         }
407 
408         success = super.transferFrom(_from, _to, _amount);
409 
410         if (success && isContract(_to))
411         {
412             // ERC20 backward compatiability
413             if(!_to.call(bytes4(keccak256("tokenFallback(address,uint256)")), _from, _amount)) {
414                 // do nothing when error in call in case that the _to contract is not inherited from ERC223ReceivingContract
415                 // revert();
416                 // bytes memory empty;
417 
418                 emit ReceivingContractTokenFallbackFailed(_from, _to, _amount);
419 
420                 // Even the fallback failed if there is such one, the transfer will not be revert since "revert()" is not called.
421             }
422         }
423     }
424 
425     /*
426      * ERC 223
427      * Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
428      */
429     function transferFrom(address _from, address _to, uint256 _amount, bytes _data)
430         public
431         returns (bool success)
432     {
433         // Alerts the token controller of the transfer
434         if (isContract(controller)) {
435             if (!TokenController(controller).onTransfer(_from, _to, _amount))
436                revert();
437         }
438 
439         require(super.transferFrom(_from, _to, _amount));
440 
441         if (isContract(_to)) {
442             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
443             receiver.tokenFallback(_from, _amount, _data);
444         }
445 
446         emit ERC223Transfer(_from, _to, _amount, _data);
447 
448         return true;
449     }
450 
451     /*
452      * ERC 223
453      * Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
454      * https://github.com/ethereum/EIPs/issues/223
455      * function transfer(address _to, uint256 _value, bytes _data) public returns (bool success);
456      */
457     /// @notice Send `_value` tokens to `_to` from `msg.sender` and trigger
458     /// tokenFallback if sender is a contract.
459     /// @dev Function that is called when a user or another contract wants to transfer funds.
460     /// @param _to Address of token receiver.
461     /// @param _amount Number of tokens to transfer.
462     /// @param _data Data to be sent to tokenFallback
463     /// @return Returns success of function call.
464     function transfer(
465         address _to,
466         uint256 _amount,
467         bytes _data)
468         public
469         returns (bool success)
470     {
471         return transferFrom(msg.sender, _to, _amount, _data);
472     }
473 
474     /*
475      * ERC 223
476      * Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
477      */
478     function transferFrom(address _from, address _to, uint256 _amount, bytes _data, string _custom_fallback)
479         public
480         returns (bool success)
481     {
482         // Alerts the token controller of the transfer
483         if (isContract(controller)) {
484             if (!TokenController(controller).onTransfer(_from, _to, _amount))
485                revert();
486         }
487 
488         require(super.transferFrom(_from, _to, _amount));
489 
490         if (isContract(_to)) {
491             /* 修复ERC233 与 ds-auth 合用时产生的安全漏洞 */
492             if(_to == address(this)) revert();
493             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
494             receiver.call.value(0)(bytes4(keccak256(_custom_fallback)), _from, _amount, _data);
495         }
496 
497         emit ERC223Transfer(_from, _to, _amount, _data);
498 
499         return true;
500     }
501 
502     /*
503      * ERC 223
504      * Added support for the ERC 223 "tokenFallback" method in a "transfer" function with a payload.
505      */
506     function transfer(
507         address _to,
508         uint _amount,
509         bytes _data,
510         string _custom_fallback)
511         public
512         returns (bool success)
513     {
514         return transferFrom(msg.sender, _to, _amount, _data, _custom_fallback);
515     }
516 
517     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
518     ///  its behalf. This is a modified version of the ERC20 approve function
519     ///  to be a little bit safer
520     /// @param _spender The address of the account able to transfer the tokens
521     /// @param _amount The amount of tokens to be approved for transfer
522     /// @return True if the approval was successful
523     function approve(address _spender, uint256 _amount) returns (bool success) {
524         // Alerts the token controller of the approve function call
525         if (isContract(controller)) {
526             if (!TokenController(controller).onApprove(msg.sender, _spender, _amount))
527                 revert();
528         }
529 
530         return super.approve(_spender, _amount);
531     }
532 
533     function mint(address _guy, uint _wad) auth stoppable {
534         require(add(_supply, _wad) <= cap);
535 
536         super.mint(_guy, _wad);
537 
538         emit Transfer(0, _guy, _wad);
539     }
540     function burn(address _guy, uint _wad) auth stoppable {
541         super.burn(_guy, _wad);
542 
543         emit Transfer(_guy, 0, _wad);
544     }
545 
546     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
547     ///  its behalf, and then a function is triggered in the contract that is
548     ///  being approved, `_spender`. This allows users to use their tokens to
549     ///  interact with contracts in one function call instead of two
550     /// @param _spender The address of the contract able to transfer the tokens
551     /// @param _amount The amount of tokens to be approved for transfer
552     /// @return True if the function call was successful
553     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
554     ) returns (bool success) {
555         if (!approve(_spender, _amount)) revert();
556 
557         ApproveAndCallFallBack(_spender).receiveApproval(
558             msg.sender,
559             _amount,
560             this,
561             _extraData
562         );
563 
564         return true;
565     }
566 
567     /// @dev Internal function to determine if an address is a contract
568     /// @param _addr The address being queried
569     /// @return True if `_addr` is a contract
570     function isContract(address _addr) constant internal returns(bool) {
571         uint size;
572         if (_addr == 0) return false;
573         assembly {
574             size := extcodesize(_addr)
575         }
576         return size>0;
577     }
578 
579     /// @notice The fallback function: If the contract's controller has not been
580     ///  set to 0, then the `proxyPayment` method is called which relays the
581     ///  ether and creates tokens as described in the token controller contract
582     function ()  payable {
583         if (isContract(controller)) {
584             if (! TokenController(controller).proxyPayment.value(msg.value)(msg.sender))
585                 revert();
586         } else {
587             revert();
588         }
589     }
590 
591 //////////
592 // Safety Methods
593 //////////
594 
595     /// @notice This method can be used by the controller to extract mistakenly
596     ///  sent tokens to this contract.
597     /// @param _token The address of the token contract that you want to recover
598     ///  set to 0 in case you want to extract ether.
599     function claimTokens(address _token) onlyController {
600         if (_token == 0x0) {
601             controller.transfer(this.balance);
602             return;
603         }
604 
605         ERC20 token = ERC20(_token);
606         uint balance = token.balanceOf(this);
607         /* 避免外部调用返回 false 代码仍然继续执行  此处加上require判断 */
608         require(token.transfer(controller, balance));
609         emit ClaimedTokens(_token, controller, balance);
610     }
611 
612 ////////////////
613 // Events
614 ////////////////
615 
616     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
617 }