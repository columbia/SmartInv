1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title BLACK DIA COIN
5  * @author BLACK DIA COIN TEAM
6  * @dev BLACK DIA COIN is an ERC223 Token with ERC20 functions and events
7  *      Fully backward compatible with ERC20
8  */
9 
10 /**
11  * @title SafeMath
12  * @dev Math operations with safety checks that throw on error
13  */
14 library SafeMath {
15     function mul(uint a, uint b) internal pure returns (uint) {
16         if (a == 0) {
17             return 0;
18         }
19         uint c = a * b;
20         assert(c / a == b);
21         return c;
22     }
23 
24     function div(uint a, uint b) internal pure returns (uint) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         uint c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     function sub(uint a, uint b) internal pure returns (uint) {
32         assert(b <= a);
33         return a - b;
34     }
35 
36     function add(uint a, uint b) internal pure returns (uint) {
37         uint c = a + b;
38         assert(c >= a);
39         return c;
40     }
41 }
42 
43 
44 
45 /**
46  * @title Ownable
47  * @dev The Ownable contract has an owner address & authority addresses, and provides basic
48  * authorization control functions, this simplifies the implementation of user permissions.
49  */
50 contract Ownable {
51     address public owner;
52     bool public canRenounce = false;
53     mapping (address => bool) public authorities;
54 
55     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56     event AuthorityAdded(address indexed authority);
57     event AuthorityRemoved(address indexed authority);
58 
59     /**
60      * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
61      */
62     constructor() public {
63         owner = msg.sender;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(msg.sender == owner);
71         _;
72     }
73 
74     /**
75      * @dev Throws if called by any account other than the authority or owner.
76      */
77     modifier onlyAuthority() {
78         require(msg.sender == owner || authorities[msg.sender]);
79         _;
80     }
81 
82     /**
83      * @dev Allows the current owner to relinquish control of the contract.
84      */
85     function enableRenounceOwnership() onlyOwner public {
86         canRenounce = true;
87     }
88 
89     /**
90      * @dev Allows the current owner to transfer control of the contract to a newOwner.
91      * @param _newOwner The address to transfer ownership to.
92      */
93     function transferOwnership(address _newOwner) onlyOwner public {
94         if(!canRenounce){
95             require(_newOwner != address(0));
96         }
97         emit OwnershipTransferred(owner, _newOwner);
98         owner = _newOwner;
99     }
100 
101     /**
102      * @dev Adds authority to execute several functions to subOwner.
103      * @param _authority The address to add authority to.
104      */
105     function addAuthority(address _authority) onlyOwner public {
106         authorities[_authority] = true;
107         emit AuthorityAdded(_authority);
108     }
109 
110     /**
111      * @dev Removes authority to execute several functions from subOwner.
112      * @param _authority The address to remove authority from.
113      */
114     function removeAuthority(address _authority) onlyOwner public {
115         authorities[_authority] = false;
116         emit AuthorityRemoved(_authority);
117     }
118 }
119 
120 
121 
122 /**
123  * @title Pausable
124  * @dev Base contract which allows children to implement an emergency stop mechanism.
125  */
126 contract Pausable is Ownable {
127     event Pause();
128     event Unpause();
129 
130     bool public paused = false;
131 
132     /**
133      * @dev Modifier to make a function callable only when the contract is not paused.
134      */
135     modifier whenNotPaused() {
136         require(!paused);
137         _;
138     }
139 
140     /**
141      * @dev Modifier to make a function callable only when the contract is paused.
142      */
143     modifier whenPaused() {
144         require(paused);
145         _;
146     }
147 
148     /**
149      * @dev called by the owner to pause, triggers stopped state
150      */
151     function pause() onlyAuthority whenNotPaused public {
152         paused = true;
153         emit Pause();
154     }
155 
156     /**
157      * @dev called by the owner to unpause, returns to normal state
158      */
159     function unpause() onlyAuthority whenPaused public {
160         paused = false;
161         emit Unpause();
162     }
163 }
164 
165 
166 
167 /**
168  * @title ERC223
169  * @dev ERC223 contract interface with ERC20 functions and events
170  *      Fully backward compatible with ERC20
171  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
172  */
173 contract ERC223 {
174     uint public totalSupply;
175 
176     // ERC223 and ERC20 functions and events
177     function balanceOf(address who) public view returns (uint);
178     function totalSupply() public view returns (uint _supply);
179     function transfer(address to, uint value) public returns (bool ok);
180     function transfer(address to, uint value, bytes data) public returns (bool ok);
181     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
182     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
183 
184     // ERC223 functions
185     function name() public view returns (string _name);
186     function symbol() public view returns (string _symbol);
187     function decimals() public view returns (uint8 _decimals);
188 
189     // ERC20 functions and events
190     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
191     function approve(address _spender, uint _value) public returns (bool success);
192     function allowance(address _owner, address _spender) public view returns (uint remaining);
193     event Transfer(address indexed _from, address indexed _to, uint _value);
194     event Approval(address indexed _owner, address indexed _spender, uint _value);
195 }
196 
197 
198 
199 /**
200  * @title ContractReceiver
201  * @dev Contract that is working with ERC223 tokens
202  */
203  contract ContractReceiver {
204 
205     struct TKN {
206         address sender;
207         uint value;
208         bytes data;
209         bytes4 sig;
210     }
211 
212     function tokenFallback(address _from, uint _value, bytes _data) public pure {
213         TKN memory tkn;
214         tkn.sender = _from;
215         tkn.value = _value;
216         tkn.data = _data;
217         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
218         tkn.sig = bytes4(u);
219 
220         /*
221          * tkn variable is analogue of msg variable of Ether transaction
222          * tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
223          * tkn.value the number of tokens that were sent   (analogue of msg.value)
224          * tkn.data is data of token transaction   (analogue of msg.data)
225          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
226          */
227     }
228 }
229 
230 
231 
232 /**
233  * @title BLACK DIA COIN
234  * @author BLACK DIA COIN TEAM
235  * @dev BLACK DIA COIN is an ERC223 Token with ERC20 functions and events
236  *      Fully backward compatible with ERC20
237  */
238 contract BDACoin is ERC223, Ownable, Pausable {
239     using SafeMath for uint;
240 
241     string public name = "BLACK DIA COIN";
242     string public symbol = "BDA";
243     uint8 public decimals = 8;
244     string version = "2.0";
245     uint public totalSupply = 1e10 * 4e8;
246     uint public distributeAmount = 0;
247     bool public mintingFinished = false;
248 
249     mapping(address => uint) public balanceOf;
250     mapping(address => mapping (address => uint)) public allowance;
251     mapping (address => bool) public frozenAccount;
252     mapping (address => uint) public unlockUnixTime;
253 
254     event FrozenFunds(address indexed target, bool frozen);
255     event LockedFunds(address indexed target, uint locked);
256     event Burn(address indexed from, uint amount);
257     event Mint(address indexed to, uint amount);
258     event MintFinished();
259 
260     /**
261      * @dev Constructor is called only once and can not be called again
262      */
263     constructor() public {
264         owner = msg.sender;
265         balanceOf[msg.sender] = totalSupply;
266     }
267 
268     function name() public view returns (string _name) {
269         return name;
270     }
271 
272     function symbol() public view returns (string _symbol) {
273         return symbol;
274     }
275 
276     function decimals() public view returns (uint8 _decimals) {
277         return decimals;
278     }
279 
280     function totalSupply() public view returns (uint _totalSupply) {
281         return totalSupply;
282     }
283 
284     function balanceOf(address _owner) public view returns (uint balance) {
285         return balanceOf[_owner];
286     }
287 
288     /**
289      * @dev Prevent targets from sending or receiving tokens
290      * @param targets Addresses to be frozen
291      * @param isFrozen either to freeze it or not
292      */
293     function freezeAccounts(address[] targets, bool isFrozen) onlyAuthority public {
294         require(targets.length > 0);
295 
296         for (uint j = 0; j < targets.length; j++) {
297             require(targets[j] != 0x0);
298             frozenAccount[targets[j]] = isFrozen;
299             emit FrozenFunds(targets[j], isFrozen);
300         }
301     }
302 
303     /**
304      * @dev Prevent targets from sending or receiving tokens by setting Unix times
305      * @param targets Addresses to be locked funds
306      * @param unixTimes Unix times when locking up will be finished
307      */
308     function lockupAccounts(address[] targets, uint[] unixTimes) onlyAuthority public {
309         require(targets.length > 0
310                 && targets.length == unixTimes.length);
311 
312         for(uint j = 0; j < targets.length; j++){
313             require(unlockUnixTime[targets[j]] < unixTimes[j]);
314             unlockUnixTime[targets[j]] = unixTimes[j];
315             emit LockedFunds(targets[j], unixTimes[j]);
316         }
317     }
318 
319     /**
320      * @dev Function that is called when a user or another contract wants to transfer funds
321      */
322     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) whenNotPaused public returns (bool success) {
323         require(_value > 0
324                 && frozenAccount[msg.sender] == false
325                 && frozenAccount[_to] == false
326                 && now > unlockUnixTime[msg.sender]
327                 && now > unlockUnixTime[_to]);
328 
329         if (isContract(_to)) {
330             require(balanceOf[msg.sender] >= _value);
331             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
332             balanceOf[_to] = balanceOf[_to].add(_value);
333             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
334             emit Transfer(msg.sender, _to, _value, _data);
335             emit Transfer(msg.sender, _to, _value);
336             return true;
337         } else {
338             return transferToAddress(_to, _value, _data);
339         }
340     }
341 
342     function transfer(address _to, uint _value, bytes _data) whenNotPaused public returns (bool success) {
343         require(_value > 0
344                 && frozenAccount[msg.sender] == false
345                 && frozenAccount[_to] == false
346                 && now > unlockUnixTime[msg.sender]
347                 && now > unlockUnixTime[_to]);
348 
349         if (isContract(_to)) {
350             return transferToContract(_to, _value, _data);
351         } else {
352             return transferToAddress(_to, _value, _data);
353         }
354     }
355 
356     /**
357      * @dev Standard function transfer similar to ERC20 transfer with no _data
358      *      Added due to backwards compatibility reasons
359      */
360     function transfer(address _to, uint _value) whenNotPaused public returns (bool success) {
361         require(_value > 0
362                 && frozenAccount[msg.sender] == false
363                 && frozenAccount[_to] == false
364                 && now > unlockUnixTime[msg.sender]
365                 && now > unlockUnixTime[_to]);
366 
367         bytes memory empty;
368         if (isContract(_to)) {
369             return transferToContract(_to, _value, empty);
370         } else {
371             return transferToAddress(_to, _value, empty);
372         }
373     }
374 
375     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
376     function isContract(address _addr) private view returns (bool is_contract) {
377         uint length;
378         assembly {
379             //retrieve the size of the code on target address, this needs assembly
380             length := extcodesize(_addr)
381         }
382         return (length > 0);
383     }
384 
385     // function that is called when transaction target is an address
386     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
387         require(balanceOf[msg.sender] >= _value);
388         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
389         balanceOf[_to] = balanceOf[_to].add(_value);
390         emit Transfer(msg.sender, _to, _value, _data);
391         emit Transfer(msg.sender, _to, _value);
392         return true;
393     }
394 
395     // function that is called when transaction target is a contract
396     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
397         require(balanceOf[msg.sender] >= _value);
398         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
399         balanceOf[_to] = balanceOf[_to].add(_value);
400         ContractReceiver receiver = ContractReceiver(_to);
401         receiver.tokenFallback(msg.sender, _value, _data);
402         emit Transfer(msg.sender, _to, _value, _data);
403         emit Transfer(msg.sender, _to, _value);
404         return true;
405     }
406 
407     /**
408      * @dev Transfer tokens from one address to another
409      *      Added due to backwards compatibility with ERC20
410      * @param _from address The address which you want to send tokens from
411      * @param _to address The address which you want to transfer to
412      * @param _value uint the amount of tokens to be transferred
413      */
414     function transferFrom(address _from, address _to, uint _value) whenNotPaused public returns (bool success) {
415         require(_to != address(0)
416                 && _value > 0
417                 && balanceOf[_from] >= _value
418                 && allowance[_from][msg.sender] >= _value
419                 && frozenAccount[_from] == false 
420                 && frozenAccount[_to] == false
421                 && now > unlockUnixTime[_from] 
422                 && now > unlockUnixTime[_to]);
423 
424         balanceOf[_from] = balanceOf[_from].sub(_value);
425         balanceOf[_to] = balanceOf[_to].add(_value);
426         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
427         emit Transfer(_from, _to, _value);
428         return true;
429     }
430 
431     /**
432      * @dev Allows _spender to spend no more than _value tokens in your behalf
433      *      Added due to backwards compatibility with ERC20
434      * @param _spender The address authorized to spend
435      * @param _value the max amount they can spend
436      */
437     function approve(address _spender, uint _value) public returns (bool success) {
438         allowance[msg.sender][_spender] = _value;
439         emit Approval(msg.sender, _spender, _value);
440         return true;
441     }
442 
443     /**
444      * @dev Function to check the amount of tokens that an owner allowed to a spender
445      *      Added due to backwards compatibility with ERC20
446      * @param _owner address The address which owns the funds
447      * @param _spender address The address which will spend the funds
448      */
449     function allowance(address _owner, address _spender) public view returns (uint remaining) {
450         return allowance[_owner][_spender];
451     }
452 
453     /**
454      * @dev Burns a specific amount of tokens.
455      * @param _from The address that will burn the tokens.
456      * @param _unitAmount The amount of token to be burned.
457      */
458     function burn(address _from, uint _unitAmount) onlyAuthority public {
459         require(_unitAmount > 0
460                 && balanceOf[_from] >= _unitAmount);
461 
462         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
463         totalSupply = totalSupply.sub(_unitAmount);
464         emit Burn(_from, _unitAmount);
465         emit Transfer(_from, address(0), _unitAmount);
466     }
467 
468     modifier canMint() {
469         require(!mintingFinished);
470         _;
471     }
472 
473     /**
474      * @dev Function to mint tokens
475      * @param _to The address that will receive the minted tokens.
476      * @param _unitAmount The amount of tokens to mint.
477      */
478     function mint(address _to, uint _unitAmount) onlyOwner canMint public returns (bool) {
479         require(_unitAmount > 0);
480 
481         totalSupply = totalSupply.add(_unitAmount);
482         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
483         emit Mint(_to, _unitAmount);
484         emit Transfer(address(0), _to, _unitAmount);
485         return true;
486     }
487 
488     /**
489      * @dev Function to stop minting new tokens.
490      */
491     function finishMinting() onlyOwner canMint public returns (bool) {
492         mintingFinished = true;
493         emit MintFinished();
494         return true;
495     }
496 
497     /**
498      * @dev Function to distribute tokens to the list of addresses by the provided amount
499      */
500     function distributeAirdrop(address[] addresses, uint amount) whenNotPaused public returns (bool) {
501         require(amount > 0 
502                 && addresses.length > 0
503                 && frozenAccount[msg.sender] == false
504                 && now > unlockUnixTime[msg.sender]);
505 
506         amount = amount.mul(1e8);
507         uint totalAmount = amount.mul(addresses.length);
508         require(balanceOf[msg.sender] >= totalAmount);
509 
510         for (uint j = 0; j < addresses.length; j++) {
511             require(addresses[j] != 0x0
512                     && frozenAccount[addresses[j]] == false
513                     && now > unlockUnixTime[addresses[j]]);
514 
515             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
516             emit Transfer(msg.sender, addresses[j], amount);
517         }
518         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
519         return true;
520     }
521 
522     function distributeAirdrop(address[] addresses, uint[] amounts) whenNotPaused public returns (bool) {
523         require(addresses.length > 0
524                 && addresses.length == amounts.length
525                 && frozenAccount[msg.sender] == false
526                 && now > unlockUnixTime[msg.sender]);
527 
528         uint totalAmount = 0;
529 
530         for(uint j = 0; j < addresses.length; j++){
531             require(amounts[j] > 0
532                     && addresses[j] != 0x0
533                     && frozenAccount[addresses[j]] == false
534                     && now > unlockUnixTime[addresses[j]]);
535 
536             amounts[j] = amounts[j].mul(1e8);
537             totalAmount = totalAmount.add(amounts[j]);
538         }
539         require(balanceOf[msg.sender] >= totalAmount);
540 
541         for (j = 0; j < addresses.length; j++) {
542             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
543             emit Transfer(msg.sender, addresses[j], amounts[j]);
544         }
545         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
546         return true;
547     }
548 
549     function setDistributeAmount(uint _unitAmount) onlyOwner public {
550         distributeAmount = _unitAmount;
551     }
552 
553     /**
554      * @dev Function to distribute tokens to the msg.sender automatically
555      *      If distributeAmount is 0, this function doesn't work
556      */
557     function autoDistribute() payable whenNotPaused public {
558         require(distributeAmount > 0
559                 && balanceOf[owner] >= distributeAmount
560                 && frozenAccount[msg.sender] == false
561                 && now > unlockUnixTime[msg.sender]);
562         if(msg.value > 0) owner.transfer(msg.value);
563 
564         balanceOf[owner] = balanceOf[owner].sub(distributeAmount);
565         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
566         emit Transfer(owner, msg.sender, distributeAmount);
567     }
568 
569     /**
570      * @dev fallback function
571      */
572     function() payable public {
573         autoDistribute();
574     }
575 }