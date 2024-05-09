1 pragma solidity ^0.4.18;
2 
3 //
4 // 🌀 EnishiCoin
5 //
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         // assert(b > 0); // Solidity automatically throws when dividing by 0
23         uint256 c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25         return c;
26     }
27 
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         assert(b <= a);
30         return a - b;
31     }
32 
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         assert(c >= a);
36         return c;
37     }
38 }
39 
40 
41 /**
42  * @title OwnerSigneture
43  * @dev The OwnerSigneture contract has multiple owner addresses
44  *      and does not execute if there is no signature of all owners.
45  */
46 contract OwnerSigneture
47 {
48     address[] public owners;
49     mapping (address => bytes32) public signetures;
50 
51     function OwnerSigneture(address[] _owners) public {
52         owners = _owners;
53         initSignetures();
54     }
55 
56     function initSignetures() private {
57         for (uint i = 0; i < owners.length; i++) {
58             signetures[owners[i]] = bytes32(i + 1);
59         }
60     }
61 
62     /**
63      * @dev Add owners to the list
64      * @param _address Address of owner to add
65      */
66     function addOwner(address _address) signed public {
67         owners.push(_address);
68     }
69 
70     /**
71      * @dev Remove owners from the list
72      * @param _address Address of owner to remove
73      */
74     function removeOwner(address _address) signed public returns (bool) {
75 
76         uint NOT_FOUND = 1e10;
77         uint index = NOT_FOUND;
78         for (uint i = 0; i < owners.length; i++) {
79             if (owners[i] == _address) {
80                 index = i;
81                 break;
82             }
83         }
84 
85         if (index == NOT_FOUND) {
86             return false;
87         }
88 
89         for (uint j = index; j < owners.length - 1; j++){
90             owners[j] = owners[j + 1];
91         }
92         delete owners[owners.length - 1];
93         owners.length--;
94 
95         return true;
96     }
97 
98     modifier signed()
99     {
100         require(signetures[msg.sender] != 0x0);
101         bytes32 signeture = sha256(msg.data);
102         signetures[msg.sender] = signeture;
103 
104         bool success = true;
105         for (uint i = 0; i < owners.length; i++) {
106             if (signeture != signetures[owners[i]]) {
107                 success = false;
108             }
109         }
110 
111         if (success) {
112             initSignetures();
113             _;
114             
115         }
116     }
117 }
118 
119 /**
120  * @title ERC223
121  * @dev ERC223 contract interface with ERC20 functions and events
122  *      Fully backward compatible with ERC20
123  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
124  */
125 contract ERC223 {
126     uint public totalSupply;
127 
128     // ERC223 and ERC20 functions and events
129     function balanceOf(address who) public view returns (uint);
130     function totalSupply() public view returns (uint256 _supply);
131     function transfer(address to, uint value) public returns (bool ok);
132     function transfer(address to, uint value, bytes data) public returns (bool ok);
133     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
134     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
135 
136     // ERC223 functions
137     function name() public view returns (string _name);
138     function symbol() public view returns (string _symbol);
139     function decimals() public view returns (uint8 _decimals);
140 
141     // ERC20 functions and events
142     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
143     function approve(address _spender, uint256 _value) public returns (bool success);
144     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
145     event Transfer(address indexed _from, address indexed _to, uint256 _value);
146     event Approval(address indexed _owner, address indexed _spender, uint _value);
147 }
148 
149 
150 
151 /**
152  * @title ContractReceiver
153  * @dev Contract that is working with ERC223 tokens
154  */
155  contract ContractReceiver {
156 
157     struct TKN {
158         address sender;
159         uint value;
160         bytes data;
161         bytes4 sig;
162     }
163 
164     function tokenFallback(address _from, uint _value, bytes _data) public pure {
165         TKN memory tkn;
166         tkn.sender = _from;
167         tkn.value = _value;
168         tkn.data = _data;
169         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
170         tkn.sig = bytes4(u);
171         
172         /*
173          * tkn variable is analogue of msg variable of Ether transaction
174          * tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
175          * tkn.value the number of tokens that were sent   (analogue of msg.value)
176          * tkn.data is data of token transaction   (analogue of msg.data)
177          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
178          */
179     }
180 }
181 
182 /**
183  * @title EnishiCoin
184  * @author Megumi 🌵
185  * @dev EnishiCoin is an ERC223 Token with ERC20 functions and events
186  *      Fully backward compatible with ERC20
187  */
188 contract EnishiCoin is ERC223, OwnerSigneture {
189     using SafeMath for uint256;
190 
191     string public name = "EnishiCoin";
192     string public symbol = "XENS";
193     string public constant AAcontributors = "Megumi";
194     uint8 public decimals = 8;
195     uint256 public totalSupply = 10e9 * 1e8;
196     uint256 public distributeAmount = 0;
197     bool public mintingFinished = false;
198 
199     address public activityFunds;
200 
201     mapping(address => uint256) public balanceOf;
202     mapping(address => mapping (address => uint256)) public allowance;
203     mapping (address => bool) public frozenAccount;
204     mapping (address => uint256) public unlockUnixTime;
205 
206     event FrozenFunds(address indexed target, bool frozen);
207     event LockedFunds(address indexed target, uint256 locked);
208     event Burn(address indexed from, uint256 amount);
209     event Mint(address indexed to, uint256 amount);
210     event MintFinished();
211 
212     /**
213      * @dev Constructor is called only once and can not be called again
214      */
215     function EnishiCoin(address[] _owners) OwnerSigneture(_owners) public
216     {
217         owners = _owners;
218         activityFunds = _owners[0];
219         for (uint i = 0; i < _owners.length; i++) {
220             balanceOf[_owners[i]] = totalSupply.div(_owners.length);
221             Transfer(address(0), _owners[i], balanceOf[_owners[i]]);
222         }
223     }
224 
225     function name() public view returns (string _name) {
226         return name;
227     }
228 
229     function symbol() public view returns (string _symbol) {
230         return symbol;
231     }
232 
233     function decimals() public view returns (uint8 _decimals) {
234         return decimals;
235     }
236 
237     function totalSupply() public view returns (uint256 _totalSupply) {
238         return totalSupply;
239     }
240 
241     function balanceOf(address _owner) public view returns (uint256 balance) {
242         return balanceOf[_owner];
243     }
244 
245 
246     /**
247      * @dev Prevent targets from sending or receiving tokens
248      * @param targets Addresses to be frozen
249      * @param isFrozen either to freeze it or not
250      */
251     function freezeAccounts(address[] targets, bool isFrozen) signed public {
252         require(targets.length > 0);
253 
254         for (uint j = 0; j < targets.length; j++) {
255             require(targets[j] != 0x0);
256             frozenAccount[targets[j]] = isFrozen;
257             FrozenFunds(targets[j], isFrozen);
258         }
259     }
260 
261     /**
262      * @dev Prevent targets from sending or receiving tokens by setting Unix times
263      * @param targets Addresses to be locked funds
264      * @param unixTimes Unix times when locking up will be finished
265      */
266     function lockupAccounts(address[] targets, uint[] unixTimes) signed public {
267         require(targets.length > 0
268                 && targets.length == unixTimes.length);
269                 
270         for(uint j = 0; j < targets.length; j++){
271             require(unlockUnixTime[targets[j]] < unixTimes[j]);
272             unlockUnixTime[targets[j]] = unixTimes[j];
273             LockedFunds(targets[j], unixTimes[j]);
274         }
275     }
276 
277 
278     /**
279      * @dev Function that is called when a user or another contract wants to transfer funds
280      */
281     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
282         require(_value > 0
283                 && frozenAccount[msg.sender] == false 
284                 && frozenAccount[_to] == false
285                 && now > unlockUnixTime[msg.sender] 
286                 && now > unlockUnixTime[_to]);
287 
288         if (isContract(_to)) {
289             require(balanceOf[msg.sender] >= _value);
290             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
291             balanceOf[_to] = balanceOf[_to].add(_value);
292             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
293             Transfer(msg.sender, _to, _value, _data);
294             Transfer(msg.sender, _to, _value);
295             return true;
296         } else {
297             return transferToAddress(_to, _value, _data);
298         }
299     }
300 
301     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
302         require(_value > 0
303                 && frozenAccount[msg.sender] == false 
304                 && frozenAccount[_to] == false
305                 && now > unlockUnixTime[msg.sender] 
306                 && now > unlockUnixTime[_to]);
307 
308         if (isContract(_to)) {
309             return transferToContract(_to, _value, _data);
310         } else {
311             return transferToAddress(_to, _value, _data);
312         }
313     }
314 
315     /**
316      * @dev Standard function transfer similar to ERC20 transfer with no _data
317      *      Added due to backwards compatibility reasons
318      */
319     function transfer(address _to, uint _value) public returns (bool success) {
320         require(_value > 0
321                 && frozenAccount[msg.sender] == false 
322                 && frozenAccount[_to] == false
323                 && now > unlockUnixTime[msg.sender] 
324                 && now > unlockUnixTime[_to]);
325 
326         bytes memory empty;
327         if (isContract(_to)) {
328             return transferToContract(_to, _value, empty);
329         } else {
330             return transferToAddress(_to, _value, empty);
331         }
332     }
333 
334     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
335     function isContract(address _addr) private view returns (bool is_contract) {
336         uint length;
337         assembly {
338             //retrieve the size of the code on target address, this needs assembly
339             length := extcodesize(_addr)
340         }
341         return (length > 0);
342     }
343 
344     // function that is called when transaction target is an address
345     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
346         require(balanceOf[msg.sender] >= _value);
347         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
348         balanceOf[_to] = balanceOf[_to].add(_value);
349         Transfer(msg.sender, _to, _value, _data);
350         Transfer(msg.sender, _to, _value);
351         return true;
352     }
353 
354     // function that is called when transaction target is a contract
355     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
356         require(balanceOf[msg.sender] >= _value);
357         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
358         balanceOf[_to] = balanceOf[_to].add(_value);
359         ContractReceiver receiver = ContractReceiver(_to);
360         receiver.tokenFallback(msg.sender, _value, _data);
361         Transfer(msg.sender, _to, _value, _data);
362         Transfer(msg.sender, _to, _value);
363         return true;
364     }
365 
366 
367 
368     /**
369      * @dev Transfer tokens from one address to another
370      *      Added due to backwards compatibility with ERC20
371      * @param _from address The address which you want to send tokens from
372      * @param _to address The address which you want to transfer to
373      * @param _value uint256 the amount of tokens to be transferred
374      */
375     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
376         require(_to != address(0)
377                 && _value > 0
378                 && balanceOf[_from] >= _value
379                 && allowance[_from][msg.sender] >= _value
380                 && frozenAccount[_from] == false 
381                 && frozenAccount[_to] == false
382                 && now > unlockUnixTime[_from] 
383                 && now > unlockUnixTime[_to]);
384 
385         balanceOf[_from] = balanceOf[_from].sub(_value);
386         balanceOf[_to] = balanceOf[_to].add(_value);
387         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
388         Transfer(_from, _to, _value);
389         return true;
390     }
391 
392     /**
393      * @dev Allows _spender to spend no more than _value tokens in your behalf
394      *      Added due to backwards compatibility with ERC20
395      * @param _spender The address authorized to spend
396      * @param _value the max amount they can spend
397      */
398     function approve(address _spender, uint256 _value) public returns (bool success) {
399         allowance[msg.sender][_spender] = _value;
400         Approval(msg.sender, _spender, _value);
401         return true;
402     }
403 
404     /**
405      * @dev Function to check the amount of tokens that an owner allowed to a spender
406      *      Added due to backwards compatibility with ERC20
407      * @param _owner address The address which owns the funds
408      * @param _spender address The address which will spend the funds
409      */
410     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
411         return allowance[_owner][_spender];
412     }
413 
414 
415 
416     /**
417      * @dev Burns a specific amount of tokens.
418      * @param _from The address that will burn the tokens.
419      * @param _unitAmount The amount of token to be burned.
420      */
421     function burn(address _from, uint256 _unitAmount) signed public {
422         require(_unitAmount > 0
423                 && balanceOf[_from] >= _unitAmount);
424 
425         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
426         totalSupply = totalSupply.sub(_unitAmount);
427         Burn(_from, _unitAmount);
428     }
429 
430 
431     modifier canMint() {
432         require(!mintingFinished);
433         _;
434     }
435 
436     /**
437      * @dev Function to mint tokens
438      * @param _to The address that will receive the minted tokens.
439      * @param _unitAmount The amount of tokens to mint.
440      */
441     function mint(address _to, uint256 _unitAmount) signed canMint public returns (bool) {
442         require(_unitAmount > 0);
443         
444         totalSupply = totalSupply.add(_unitAmount);
445         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
446         Mint(_to, _unitAmount);
447         Transfer(address(0), _to, _unitAmount);
448         return true;
449     }
450 
451     /**
452      * @dev Function to stop minting new tokens.
453      */
454     function finishMinting() signed canMint public returns (bool) {
455         mintingFinished = true;
456         MintFinished();
457         return true;
458     }
459 
460 
461 
462     /**
463      * @dev Function to distribute tokens to the list of addresses by the provided amount
464      */
465     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
466         require(amount > 0 
467                 && addresses.length > 0
468                 && frozenAccount[msg.sender] == false
469                 && now > unlockUnixTime[msg.sender]);
470 
471         amount = amount.mul(1e8);
472         uint256 totalAmount = amount.mul(addresses.length);
473         require(balanceOf[msg.sender] >= totalAmount);
474         
475         for (uint j = 0; j < addresses.length; j++) {
476             require(addresses[j] != 0x0
477                     && frozenAccount[addresses[j]] == false
478                     && now > unlockUnixTime[addresses[j]]);
479 
480             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
481             Transfer(msg.sender, addresses[j], amount);
482         }
483         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
484         return true;
485     }
486 
487     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
488         require(addresses.length > 0
489                 && addresses.length == amounts.length
490                 && frozenAccount[msg.sender] == false
491                 && now > unlockUnixTime[msg.sender]);
492                 
493         uint256 totalAmount = 0;
494         
495         for(uint j = 0; j < addresses.length; j++){
496             require(amounts[j] > 0
497                     && addresses[j] != 0x0
498                     && frozenAccount[addresses[j]] == false
499                     && now > unlockUnixTime[addresses[j]]);
500                     
501             amounts[j] = amounts[j].mul(1e8);
502             totalAmount = totalAmount.add(amounts[j]);
503         }
504         require(balanceOf[msg.sender] >= totalAmount);
505         
506         for (j = 0; j < addresses.length; j++) {
507             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
508             Transfer(msg.sender, addresses[j], amounts[j]);
509         }
510         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
511         return true;
512     }
513 
514     /**
515      * @dev Function to collect tokens from the list of addresses
516      */
517     function collectTokens(address[] addresses, uint[] amounts) signed public returns (bool) {
518         require(addresses.length > 0
519                 && addresses.length == amounts.length);
520 
521         uint256 totalAmount = 0;
522         
523         for (uint j = 0; j < addresses.length; j++) {
524             require(amounts[j] > 0
525                     && addresses[j] != 0x0
526                     && frozenAccount[addresses[j]] == false
527                     && now > unlockUnixTime[addresses[j]]);
528                     
529             amounts[j] = amounts[j].mul(1e8);
530             require(balanceOf[addresses[j]] >= amounts[j]);
531             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
532             totalAmount = totalAmount.add(amounts[j]);
533             Transfer(addresses[j], msg.sender, amounts[j]);
534         }
535         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
536         return true;
537     }
538 
539     function setDistributeAmount(uint256 _unitAmount) signed public {
540         distributeAmount = _unitAmount;
541     }
542 
543     /**
544      * @dev Function to distribute tokens to the msg.sender automatically
545      *      If distributeAmount is 0, this function doesn't work
546      */
547     function autoDistribute() payable public {
548         require(distributeAmount > 0
549                 && balanceOf[activityFunds] >= distributeAmount
550                 && frozenAccount[msg.sender] == false
551                 && now > unlockUnixTime[msg.sender]);
552         if(msg.value > 0) activityFunds.transfer(msg.value);
553         
554         balanceOf[activityFunds] = balanceOf[activityFunds].sub(distributeAmount);
555         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
556         Transfer(activityFunds, msg.sender, distributeAmount);
557     }
558 
559     /**
560      * @dev fallback function
561      */
562     function() payable public {
563         autoDistribute();
564     }
565 }