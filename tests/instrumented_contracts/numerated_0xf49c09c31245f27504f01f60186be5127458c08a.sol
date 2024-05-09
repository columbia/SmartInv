1 pragma solidity ^0.4.18;
2 
3 //
4 //
5 //    🌀 EnishiCoin
6 //
7 //
8 
9 /**
10  * @title OwnerSigneture
11  * @dev The OwnerSigneture contract has multiple owner addresses
12  *      and does not execute if there is no signature of all owners.
13  */
14 contract OwnerSigneture
15 {
16   address[] public owners;
17   mapping (address => bytes32) public signetures;
18 
19   function OwnerSigneture(address[] _owners) public
20   {
21     owners = _owners;
22     initSignetures();
23   }
24 
25   function initSignetures() private
26   {
27     for (uint i = 0; i < owners.length; i++) {
28       signetures[owners[i]] = bytes32(i + 1);
29     }
30   }
31 
32   /**
33    * @dev Add owners to the list
34    * @param _address Address of owner to add
35    */
36   function addOwner(address _address) signed public {
37     owners.push(_address);
38   }
39 
40   /**
41    * @dev Remove owners from the list
42    * @param _address Address of owner to remove
43    */
44   function removeOwner(address _address) signed public returns (bool) {
45 
46     uint NOT_FOUND = 1e10;
47     uint index = NOT_FOUND;
48     for (uint i = 0; i < owners.length; i++) {
49       if (owners[i] == _address) {
50         index = i;
51         break;
52       }
53     }
54 
55     if (index == NOT_FOUND) {
56       return false;
57     }
58 
59     for (uint j = index; j < owners.length - 1; j++){
60       owners[j] = owners[j + 1];
61     }
62     delete owners[owners.length - 1];
63     owners.length--;
64 
65     return true;
66   }
67 
68   modifier signed()
69   {
70     require(signetures[msg.sender] != 0x0);
71     bytes32 signeture = sha256(msg.data);
72     signetures[msg.sender] = signeture;
73 
74     bool success = true;
75     for (uint i = 0; i < owners.length; i++) {
76       if (signeture != signetures[owners[i]]) {
77         success = false;
78       }
79     }
80 
81     if (success) {
82       initSignetures();
83       _;
84       
85     }
86   }
87 }
88 
89 /**
90  * @title ERC223
91  * @dev ERC223 contract interface with ERC20 functions and events
92  *    Fully backward compatible with ERC20
93  *    Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
94  */
95 contract ERC223
96 {
97   uint public totalSupply;
98 
99   // ERC223 and ERC20 functions and events
100   function balanceOf(address who) public view returns (uint);
101   function totalSupply() public view returns (uint256 _supply);
102   function transfer(address to, uint value) public returns (bool ok);
103   function transfer(address to, uint value, bytes data) public returns (bool ok);
104   function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
105   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
106 
107   // ERC223 functions
108   function name() public view returns (string _name);
109   function symbol() public view returns (string _symbol);
110   function decimals() public view returns (uint8 _decimals);
111 
112   // ERC20 functions and events
113   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
114   function approve(address _spender, uint256 _value) public returns (bool success);
115   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
116   event Transfer(address indexed _from, address indexed _to, uint256 _value);
117   event Approval(address indexed _owner, address indexed _spender, uint _value);
118 }
119 
120 /**
121  * @title EnishiCoin
122  * @author Megumi 🌵
123  * @dev EnishiCoin is an ERC223 Token with ERC20 functions and events
124  *    Fully backward compatible with ERC20
125  */
126 contract EnishiCoin is ERC223, OwnerSigneture
127 {
128   using SafeMath for uint256;
129 
130   string public name = "EnishiCoin";
131   string public symbol = "XENS";
132   uint8 public decimals = 8;
133   uint256 dec = 1e8;
134 
135   uint256 public initialSupply = 100e8 * dec; // 100億枚
136   uint256 public totalSupply;
137   bool public mintingFinished = false;
138 
139   address public temporaryAddress = 0x092dEBAEAD027b43301FaFF52360B2B0538b0c98;
140 
141   mapping (address => uint) balances;
142   mapping(address => mapping (address => uint256)) public allowance;
143   mapping (address => bool) public frozenAccount;
144   mapping (address => uint256) public unlockUnixTime;
145 
146   mapping (address => uint) public temporaryBalances;
147   mapping (address => uint256) temporaryLimitUnixTime;
148 
149   event FrozenFunds(address indexed target, bool frozen);
150   event LockedFunds(address indexed target, uint256 locked);
151   event Burn(address indexed burner, uint256 value);
152   event Mint(address indexed to, uint256 amount);
153   event MintFinished();
154 
155   function EnishiCoin(address[] _owners) OwnerSigneture(_owners) public
156   {
157     owners = _owners;
158     totalSupply = initialSupply;
159     for (uint i = 0; i < _owners.length; i++) {
160         balances[_owners[i]] = totalSupply.div(_owners.length);
161     }
162   }
163 
164   function name() public view returns (string _name)
165   {
166     return name;
167   }
168 
169   function symbol() public view returns (string _symbol)
170   {
171     return symbol;
172   }
173 
174   function decimals() public view returns (uint8 _decimals)
175   {
176     return decimals;
177   }
178 
179   function totalSupply() public view returns (uint256 _totalSupply)
180   {
181     return totalSupply;
182   }
183 
184   function balanceOf(address _owner) public view returns (uint balance)
185   {
186     return balances[_owner];
187   }
188 
189   modifier onlyPayloadSize(uint256 _size)
190   {
191     assert(msg.data.length >= _size + 4);
192     _;
193   }
194 
195   /**
196    * @dev Prevent targets from sending or receiving tokens
197    * @param _targets Addresses to be frozen
198    * @param _isFrozen either to freeze it or not
199    */
200   function freezeAccounts(address[] _targets, bool _isFrozen) signed public
201   {
202     require(_targets.length > 0);
203 
204     for (uint i = 0; i < _targets.length; i++) {
205       require(_targets[i] != 0x0);
206       frozenAccount[_targets[i]] = _isFrozen;
207       FrozenFunds(_targets[i], _isFrozen);
208     }
209   }
210 
211   /**
212    * @dev Prevent targets from sending or receiving tokens by setting Unix times
213    * @param _targets Addresses to be locked funds
214    * @param _unixTimes Unix times when locking up will be finished
215    */
216   function lockupAccounts(address[] _targets, uint[] _unixTimes) signed public
217   {
218     require(true
219       && _targets.length > 0
220       && _targets.length == _unixTimes.length
221     );
222 
223     for(uint i = 0; i < _targets.length; i++) {
224       require(unlockUnixTime[_targets[i]] < _unixTimes[i]);
225       unlockUnixTime[_targets[i]] = _unixTimes[i];
226       LockedFunds(_targets[i], _unixTimes[i]);
227     }
228   }
229 
230   /**
231    * @dev Function that is called when a user or another contract wants to transfer funds.
232    */
233   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success)
234   {
235     require(true
236       && _value > 0
237       && frozenAccount[msg.sender] == false
238       && frozenAccount[_to] == false
239       && now > unlockUnixTime[msg.sender]
240       && now > unlockUnixTime[_to]
241     );
242 
243     if (isContract(_to)) {
244       if (balanceOf(msg.sender) < _value) {
245         revert();
246       }
247       balances[msg.sender] = SafeMath.sub(balanceOf(msg.sender), _value);
248       balances[_to] = SafeMath.add(balanceOf(_to), _value);
249       assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
250       Transfer(msg.sender, _to, _value, _data);
251       Transfer(msg.sender, _to, _value);
252       return true;
253     } else {
254       return transferToAddress(_to, _value, _data);
255     }
256   }
257 
258   /**
259    * @dev Function that is called when a user or another contract wants to transfer funds.
260    */
261   function transfer(address _to, uint _value, bytes _data) public returns (bool success)
262   {
263     require(true
264       && _value > 0
265       && frozenAccount[msg.sender] == false
266       && frozenAccount[_to] == false
267       && now > unlockUnixTime[msg.sender]
268       && now > unlockUnixTime[_to]
269     );
270 
271     if (isContract(_to)) {
272       return transferToContract(_to, _value, _data);
273     } else {
274       return transferToAddress(_to, _value, _data);
275     }
276   }
277 
278   /**
279    * @dev Standard function transfer similar to ERC20 transfer with no _data. Added due to backwards compatibility reasons.
280    */
281   function transfer(address _to, uint _value) public returns (bool success)
282   {
283     require(true
284       && _value > 0
285       && frozenAccount[msg.sender] == false
286       && frozenAccount[_to] == false
287       && now > unlockUnixTime[msg.sender]
288       && now > unlockUnixTime[_to]
289     );
290 
291     bytes memory empty;
292     if (isContract(_to)) {
293       return transferToContract(_to, _value, empty);
294     } else {
295       return transferToAddress(_to, _value, empty);
296     }
297   }
298 
299   /**
300    * @dev assemble the given address bytecode. If bytecode exists then the _address is a contract.
301    */
302   function isContract(address _address) private view returns (bool is_contract)
303   {
304     uint length;
305     assembly {
306       // retrieve the size of the code on target address, this needs assembly
307       length := extcodesize(_address)
308     }
309     return (length > 0);
310   }
311 
312   /**
313    * @dev Function that is called when transaction target is an address.
314    */
315   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success)
316   {
317     if (balanceOf(msg.sender) < _value) {
318       revert();
319     }
320     balances[msg.sender] = SafeMath.sub(balanceOf(msg.sender), _value);
321     balances[_to] = SafeMath.add(balanceOf(_to), _value);
322     Transfer(msg.sender, _to, _value, _data);
323     Transfer(msg.sender, _to, _value);
324     return true;
325   }
326 
327   /**
328    * @dev Function that is called when transaction target is a contract.
329    */
330   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success)
331   {
332     if (balanceOf(msg.sender) < _value) {
333       revert();
334     }
335     balances[msg.sender] = SafeMath.sub(balanceOf(msg.sender), _value);
336     balances[_to] = SafeMath.add(balanceOf(_to), _value);
337     ContractReceiver receiver = ContractReceiver(_to);
338     receiver.tokenFallback(msg.sender, _value, _data);
339     Transfer(msg.sender, _to, _value, _data);
340     Transfer(msg.sender, _to, _value);
341     return true;
342   }
343 
344   /**
345    * @dev Burns a specific amount of tokens.
346    * @param _from The address that will burn the tokens.
347    * @param _amount The amount of token to be burned.
348    */
349   function burn(address _from, uint256 _amount) signed public
350   {
351     require(true
352       && _amount > 0
353       && balances[_from] >= _amount
354     );
355 
356     _amount = SafeMath.mul(_amount, dec);
357     balances[_from] = SafeMath.sub(balances[_from], _amount);
358     totalSupply = SafeMath.sub(totalSupply, _amount);
359     Burn(_from, _amount);
360   }
361 
362   modifier canMint()
363   {
364     require(!mintingFinished);
365     _;
366   }
367 
368   /**
369    * @dev Function to mint tokens
370    * @param _to The address that will receive the minted tokens.
371    * @param _amount The amount of tokens to mint.
372    */
373   function mint(address _to, uint256 _amount) signed canMint public returns (bool)
374   {
375     require(_amount > 0);
376 
377     _amount = SafeMath.mul(_amount, dec);
378     totalSupply = SafeMath.add(totalSupply, _amount);
379     balances[_to] = SafeMath.add(balances[_to], _amount);
380     Mint(_to, _amount);
381     Transfer(address(0), _to, _amount);
382     return true;
383   }
384 
385   /**
386    * @dev Function to stop minting new tokens.
387    */
388   function finishMinting() signed canMint public returns (bool)
389   {
390     mintingFinished = true;
391     MintFinished();
392     return true;
393   }
394 
395   /**
396    * @dev Function to distribute tokens to the list of addresses by the provided amount
397    */
398   function distributeAirdrop(address[] _addresses, uint256 _amount) public returns (bool)
399   {
400     require(true
401       && _amount > 0
402       && _addresses.length > 0
403       && frozenAccount[msg.sender] == false
404       && now > unlockUnixTime[msg.sender]
405     );
406 
407     _amount = SafeMath.mul(_amount, dec);
408     uint256 totalAmount = SafeMath.mul(_amount, _addresses.length);
409     require(balances[msg.sender] >= totalAmount);
410 
411     for (uint i = 0; i < _addresses.length; i++) {
412       require(true
413         && _addresses[i] != 0x0
414         && frozenAccount[_addresses[i]] == false
415         && now > unlockUnixTime[_addresses[i]]
416       );
417 
418       balances[_addresses[i]] = SafeMath.add(balances[_addresses[i]], _amount);
419       Transfer(msg.sender, _addresses[i], _amount);
420     }
421     balances[msg.sender] = SafeMath.sub(balances[msg.sender], totalAmount);
422     return true;
423   }
424 
425   /**
426    * @dev Function to collect tokens from the list of _addresses
427    */
428   function collectTokens(address[] _addresses, uint256[] _amounts) signed public returns (bool)
429   {
430     require(true
431       && _addresses.length > 0
432       && _addresses.length == _amounts.length
433     );
434 
435     uint256 totalAmount = 0;
436 
437     for (uint i = 0; i < _addresses.length; i++) {
438       require(true
439         && _amounts[i] > 0
440         && _addresses[i] != 0x0
441         && frozenAccount[_addresses[i]] == false
442         && now > unlockUnixTime[_addresses[i]]
443       );
444 
445       _amounts[i] = SafeMath.mul(_amounts[i], dec);
446       require(balances[_addresses[i]] >= _amounts[i]);
447 
448       balances[_addresses[i]] = SafeMath.sub(balances[_addresses[i]], _amounts[i]);
449       totalAmount = SafeMath.add(totalAmount, _amounts[i]);
450       Transfer(_addresses[i], msg.sender, _amounts[i]);
451     }
452     balances[msg.sender] = SafeMath.add(balances[msg.sender], totalAmount);
453     return true;
454   }
455 
456   /**
457    * @dev Push tokens to temporary area.
458    */
459   function pushToken(address[] _addresses, uint256 _amount, uint _limitUnixTime) public returns (bool)
460   {
461     require(true
462       && _amount > 0
463       && _addresses.length > 0
464       && frozenAccount[msg.sender] == false
465       && now > unlockUnixTime[msg.sender]
466     );
467 
468     _amount = SafeMath.mul(_amount, dec);
469     uint256 totalAmount = SafeMath.mul(_amount, _addresses.length);
470     require(balances[msg.sender] >= totalAmount);
471 
472     for (uint i = 0; i < _addresses.length; i++) {
473       require(true
474         && _addresses[i] != 0x0
475         && frozenAccount[_addresses[i]] == false
476         && now > unlockUnixTime[_addresses[i]]
477       );
478       temporaryBalances[_addresses[i]] = SafeMath.add(temporaryBalances[_addresses[i]], _amount);
479       temporaryLimitUnixTime[_addresses[i]] = _limitUnixTime;
480     }
481     balances[msg.sender] = SafeMath.sub(balances[msg.sender], totalAmount);
482     balances[temporaryAddress] = SafeMath.add(balances[temporaryAddress], totalAmount);
483     Transfer(msg.sender, temporaryAddress, totalAmount);
484     return true;
485   }
486 
487   /**
488    * @dev Pop tokens from temporary area. _amount
489    */
490   function popToken(address _to) public returns (bool)
491   {
492     require(true
493       && temporaryBalances[msg.sender] > 0
494       && frozenAccount[msg.sender] == false
495       && now > unlockUnixTime[msg.sender]
496       && frozenAccount[_to] == false
497       && now > unlockUnixTime[_to]
498       && balances[temporaryAddress] >= temporaryBalances[msg.sender]
499       && temporaryLimitUnixTime[msg.sender] > now
500     );
501 
502     uint256 amount = temporaryBalances[msg.sender];
503 
504     temporaryBalances[msg.sender] = 0;
505     balances[temporaryAddress] = SafeMath.sub(balances[temporaryAddress], amount);
506     balances[_to] = SafeMath.add(balances[_to], amount);
507     Transfer(temporaryAddress, _to, amount);
508     return true;
509   }
510 
511 
512   /**
513    * @dev Transfer tokens from one address to another
514    *      Added due to backwards compatibility with ERC20
515    * @param _from address The address which you want to send tokens from
516    * @param _to address The address which you want to transfer to
517    * @param _value uint256 the amount of tokens to be transferred
518    */
519   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
520       require(true
521         && _to != address(0)
522         && _value > 0
523         && balances[_from] >= _value
524         && allowance[_from][msg.sender] >= _value
525         && frozenAccount[_from] == false 
526         && frozenAccount[_to] == false
527         && now > unlockUnixTime[_from] 
528         && now > unlockUnixTime[_to]);
529 
530       balances[_from] = balances[_from].sub(_value);
531       balances[_to] = balances[_to].add(_value);
532       allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
533       Transfer(_from, _to, _value);
534       return true;
535   }
536 
537   /**
538    * @dev Allows _spender to spend no more than _value tokens in your behalf
539    *      Added due to backwards compatibility with ERC20
540    * @param _spender The address authorized to spend
541    * @param _value the max amount they can spend
542    */
543   function approve(address _spender, uint256 _value) public returns (bool success) {
544     allowance[msg.sender][_spender] = _value;
545     Approval(msg.sender, _spender, _value);
546     return true;
547   }
548 
549   /**
550    * @dev Function to check the amount of tokens that an owner allowed to a spender
551    *      Added due to backwards compatibility with ERC20
552    * @param _owner address The address which owns the funds
553    * @param _spender address The address which will spend the funds
554    */
555   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
556     return allowance[_owner][_spender];
557   }
558 }
559 
560 /**
561  * @title SafeMath
562  * @dev Math operations with safety checks that throw on error
563  */
564 library SafeMath
565 {
566   function mul(uint256 a, uint256 b) internal pure returns (uint256)
567   {
568     if (a == 0) {
569       return 0;
570     }
571     uint256 c = a * b;
572     assert(c / a == b);
573     return c;
574   }
575 
576   function div(uint256 a, uint256 b) internal pure returns (uint256)
577   {
578     uint256 c = a / b;
579     return c;
580   }
581 
582   function sub(uint256 a, uint256 b) internal pure returns (uint256)
583   {
584     assert(b <= a);
585     return a - b;
586   }
587 
588   function add(uint256 a, uint256 b) internal pure returns (uint256)
589   {
590     uint256 c = a + b;
591     assert(c >= a);
592     return c;
593   }
594 }
595 
596 /**
597  * @title ContractReceiver
598  * @dev Contract that is working with ERC223 tokens
599  */
600 contract ContractReceiver
601 {
602   struct TKN {
603     address sender;
604     uint value;
605     bytes data;
606     bytes4 sig;
607   }
608 
609   function tokenFallback(address _from, uint _value, bytes _data) public pure
610   {
611     TKN memory tkn;
612     tkn.sender = _from;
613     tkn.value = _value;
614     tkn.data = _data;
615     uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
616     tkn.sig = bytes4(u);
617   }
618 }