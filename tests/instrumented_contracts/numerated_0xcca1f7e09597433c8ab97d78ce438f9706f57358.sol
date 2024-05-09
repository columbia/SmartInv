1 pragma solidity ^0.4.20;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address, and provides basic authorization
40  *      control functions, this simplifies the implementation of "user permissions".
41  */
42 contract Ownable {
43     address public owner;
44 
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47     /**
48      * @dev The Ownable constructor sets the original `owner` of the contract to the
49      *      sender account.
50      */
51     function Ownable() public {
52         owner = msg.sender;
53     }
54 
55     /**
56      * @dev Throws if called by any account other than the owner.
57      */
58     modifier onlyOwner() {
59         require(msg.sender == owner);
60         _;
61     }
62 
63     /**
64      * @dev Allows the current owner to transfer control of the contract to a newOwner.
65      * @param newOwner The address to transfer ownership to.
66      */
67     function transferOwnership(address newOwner) onlyOwner public {
68         require(newOwner != address(0));
69         OwnershipTransferred(owner, newOwner);
70         owner = newOwner;
71     }
72 }
73 
74 
75 /**
76  * @title ERC223
77  * @dev ERC223 contract interface with ERC20 functions and events
78  *      Fully backward compatible with ERC20
79  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
80  */
81 contract ERC223 {
82     uint public totalSupply;
83 
84     // ERC223 and ERC20 functions and events
85     function balanceOf(address who) public view returns (uint);
86     function totalSupply() public view returns (uint256 _supply);
87     function transfer(address to, uint value) public returns (bool ok);
88     function transfer(address to, uint value, bytes data) public returns (bool ok);
89     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
90     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
91 
92     // ERC223 functions
93     function name() public view returns (string _name);
94     function symbol() public view returns (string _symbol);
95     function decimals() public view returns (uint8 _decimals);
96 
97     // ERC20 functions and events
98     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
99     function approve(address _spender, uint256 _value) public returns (bool success);
100     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
101     event Transfer(address indexed _from, address indexed _to, uint256 _value);
102     event Approval(address indexed _owner, address indexed _spender, uint _value);
103 }
104 
105 
106 /**
107  * @title ContractReceiver
108  * @dev Contract that is working with ERC223 tokens
109  */
110  contract ContractReceiver {
111 
112     struct TKN {
113         address sender;
114         uint value;
115         bytes data;
116         bytes4 sig;
117     }
118 
119     function tokenFallback(address _from, uint _value, bytes _data) public pure {
120         TKN memory tkn;
121         tkn.sender = _from;
122         tkn.value = _value;
123         tkn.data = _data;
124         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
125         tkn.sig = bytes4(u);
126 
127         /**
128          * tkn variable is analogue of msg variable of Ether transaction
129          * tkn.sender is person who initiated this token transaction (analogue of msg.sender)
130          * tkn.value the number of tokens that were sent (analogue of msg.value)
131          * tkn.data is data of token transaction (analogue of msg.data)
132          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
133          */
134     }
135 }
136 
137 
138 /**
139  * @title SharingPlus
140  * @author SharingPlus
141  * @dev SharingPlus is an ERC223 Token with ERC20 functions and events
142  *      Fully backward compatible with ERC20
143  */
144 contract SharingPlus is ERC223, Ownable {
145     using SafeMath for uint256;
146 
147     string public name = "SharingPlus";
148     string public symbol = "SHP";
149     uint8 public decimals = 8;
150     uint256 public totalSupply = 30e9 * 1e8;
151     uint256 public distributeAmount = 0;
152     bool public mintingFinished = false;
153 
154     address public Development = 0x443E77603754BD81FA8541c40BAB0DaF85121eC1;
155     address public Management = 0x69B27283783f8A6971dD9772C57E92Df81f354ab;
156     address public Marketing = 0xdaeded64e1662693ED2B8837e7470DA3Ab8f6745;
157     address public InitialSupply = 0x1cc96C0Ed14B90813c73882EC2E0BCb5Af2AEAAE;
158 
159     mapping(address => uint256) public balanceOf;
160     mapping(address => mapping (address => uint256)) public allowance;
161     mapping (address => bool) public frozenAccount;
162     mapping (address => uint256) public unlockUnixTime;
163     
164     event FrozenFunds(address indexed target, bool frozen);
165     event LockedFunds(address indexed target, uint256 locked);
166     event Burn(address indexed from, uint256 amount);
167     event Mint(address indexed to, uint256 amount);
168     event MintFinished();
169 
170     /** 
171      * @dev Constructor is called only once and can not be called again
172      */
173     function SharingPlus() public {
174         owner = msg.sender;
175 
176         balanceOf[msg.sender] = totalSupply.mul(10).div(100);
177         balanceOf[Development] = totalSupply.mul(15).div(100);
178         balanceOf[Management] = totalSupply.mul(10).div(100);
179         balanceOf[Marketing] = totalSupply.mul(15).div(100);
180         balanceOf[InitialSupply] = totalSupply.mul(50).div(100);
181     }
182 
183     function name() public view returns (string _name) {
184         return name;
185     }
186 
187     function symbol() public view returns (string _symbol) {
188         return symbol;
189     }
190 
191     function decimals() public view returns (uint8 _decimals) {
192         return decimals;
193     }
194 
195     function totalSupply() public view returns (uint256 _totalSupply) {
196         return totalSupply;
197     }
198 
199     function balanceOf(address _owner) public view returns (uint256 balance) {
200         return balanceOf[_owner];
201     }
202 
203     /**
204      * @dev Prevent targets from sending or receiving tokens
205      * @param targets Addresses to be frozen
206      * @param isFrozen either to freeze it or not
207      */
208     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
209         require(targets.length > 0);
210 
211         for (uint j = 0; j < targets.length; j++) {
212             require(targets[j] != 0x0);
213             frozenAccount[targets[j]] = isFrozen;
214             FrozenFunds(targets[j], isFrozen);
215         }
216     }
217 
218     /**
219      * @dev Prevent targets from sending or receiving tokens by setting Unix times
220      * @param targets Addresses to be locked funds
221      * @param unixTimes Unix times when locking up will be finished
222      */
223     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
224         require(targets.length > 0
225                 && targets.length == unixTimes.length);
226 
227         for(uint j = 0; j < targets.length; j++){
228             require(unlockUnixTime[targets[j]] < unixTimes[j]);
229             unlockUnixTime[targets[j]] = unixTimes[j];
230             LockedFunds(targets[j], unixTimes[j]);
231         }
232     }
233 
234     /**
235      * @dev Function that is called when a user or another contract wants to transfer funds
236      */
237     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
238         require(_value > 0
239                 && frozenAccount[msg.sender] == false
240                 && frozenAccount[_to] == false
241                 && now > unlockUnixTime[msg.sender]
242                 && now > unlockUnixTime[_to]);
243 
244         if (isContract(_to)) {
245             require(balanceOf[msg.sender] >= _value);
246             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
247             balanceOf[_to] = balanceOf[_to].add(_value);
248             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
249             Transfer(msg.sender, _to, _value, _data);
250             Transfer(msg.sender, _to, _value);
251             return true;
252         } else {
253             return transferToAddress(_to, _value, _data);
254         }
255     }
256 
257     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
258         require(_value > 0
259                 && frozenAccount[msg.sender] == false
260                 && frozenAccount[_to] == false
261                 && now > unlockUnixTime[msg.sender]
262                 && now > unlockUnixTime[_to]);
263 
264         if (isContract(_to)) {
265             return transferToContract(_to, _value, _data);
266         } else {
267             return transferToAddress(_to, _value, _data);
268         }
269     }
270 
271     /**
272      * @dev Standard function transfer similar to ERC20 transfer with no _data
273      *      Added due to backwards compatibility reasons
274      */
275     function transfer(address _to, uint _value) public returns (bool success) {
276         require(_value > 0
277                 && frozenAccount[msg.sender] == false
278                 && frozenAccount[_to] == false
279                 && now > unlockUnixTime[msg.sender]
280                 && now > unlockUnixTime[_to]);
281 
282         bytes memory empty;
283         if (isContract(_to)) {
284             return transferToContract(_to, _value, empty);
285         } else {
286             return transferToAddress(_to, _value, empty);
287         }
288     }
289 
290     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
291     function isContract(address _addr) private view returns (bool is_contract) {
292         uint length;
293         assembly {
294             //retrieve the size of the code on target address, this needs assembly
295             length := extcodesize(_addr)
296         }
297         return (length > 0);
298     }
299 
300     // function that is called when transaction target is an address
301     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
302         require(balanceOf[msg.sender] >= _value);
303         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
304         balanceOf[_to] = balanceOf[_to].add(_value);
305         Transfer(msg.sender, _to, _value, _data);
306         Transfer(msg.sender, _to, _value);
307         return true;
308     }
309 
310     // function that is called when transaction target is a contract
311     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
312         require(balanceOf[msg.sender] >= _value);
313         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
314         balanceOf[_to] = balanceOf[_to].add(_value);
315         ContractReceiver receiver = ContractReceiver(_to);
316         receiver.tokenFallback(msg.sender, _value, _data);
317         Transfer(msg.sender, _to, _value, _data);
318         Transfer(msg.sender, _to, _value);
319         return true;
320     }
321 
322     /**
323      * @dev Transfer tokens from one address to another
324      *      Added due to backwards compatibility with ERC20
325      * @param _from address The address which you want to send tokens from
326      * @param _to address The address which you want to transfer to
327      * @param _value uint256 the amount of tokens to be transferred
328      */
329     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
330         require(_to != address(0)
331                 && _value > 0
332                 && balanceOf[_from] >= _value
333                 && allowance[_from][msg.sender] >= _value
334                 && frozenAccount[_from] == false
335                 && frozenAccount[_to] == false
336                 && now > unlockUnixTime[_from]
337                 && now > unlockUnixTime[_to]);
338 
339         balanceOf[_from] = balanceOf[_from].sub(_value);
340         balanceOf[_to] = balanceOf[_to].add(_value);
341         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
342         Transfer(_from, _to, _value);
343         return true;
344     }
345 
346     /**
347      * @dev Allows _spender to spend no more than _value tokens in your behalf
348      *      Added due to backwards compatibility with ERC20
349      * @param _spender The address authorized to spend
350      * @param _value the max amount they can spend
351      */
352     function approve(address _spender, uint256 _value) public returns (bool success) {
353         allowance[msg.sender][_spender] = _value;
354         Approval(msg.sender, _spender, _value);
355         return true;
356     }
357 
358     /**
359      * @dev Function to check the amount of tokens that an owner allowed to a spender
360      *      Added due to backwards compatibility with ERC20
361      * @param _owner address The address which owns the funds
362      * @param _spender address The address which will spend the funds
363      */
364     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
365         return allowance[_owner][_spender];
366     }
367 
368     /**
369      * @dev Burns a specific amount of tokens.
370      * @param _from The address that will burn the tokens.
371      * @param _unitAmount The amount of token to be burned.
372      */
373     function burn(address _from, uint256 _unitAmount) onlyOwner public {
374         require(_unitAmount > 0
375                 && balanceOf[_from] >= _unitAmount);
376 
377         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
378         totalSupply = totalSupply.sub(_unitAmount);
379         Burn(_from, _unitAmount);
380     }
381 
382     modifier canMint() {
383         require(!mintingFinished);
384         _;
385     }
386 
387     /**
388      * @dev Function to mint tokens
389      * @param _to The address that will receive the minted tokens.
390      * @param _unitAmount The amount of tokens to mint.
391      */
392     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
393         require(_unitAmount > 0);
394         
395         totalSupply = totalSupply.add(_unitAmount);
396         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
397         Mint(_to, _unitAmount);
398         Transfer(address(0), _to, _unitAmount);
399         return true;
400     }
401 
402     /**
403      * @dev Function to stop minting new tokens.
404      */
405     function finishMinting() onlyOwner canMint public returns (bool) {
406         mintingFinished = true;
407         MintFinished();
408         return true;
409     }
410 
411     /**
412      * @dev Function to distribute tokens to the list of addresses by the provided amount
413      */
414     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
415         require(amount > 0 
416                 && addresses.length > 0
417                 && frozenAccount[msg.sender] == false
418                 && now > unlockUnixTime[msg.sender]);
419 
420         amount = amount.mul(1e8);
421         uint256 totalAmount = amount.mul(addresses.length);
422         require(balanceOf[msg.sender] >= totalAmount);
423         
424         for (uint j = 0; j < addresses.length; j++) {
425             require(addresses[j] != 0x0
426                     && frozenAccount[addresses[j]] == false
427                     && now > unlockUnixTime[addresses[j]]);
428 
429             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
430             Transfer(msg.sender, addresses[j], amount);
431         }
432         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
433         return true;
434     }
435 
436     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
437         require(addresses.length > 0
438                 && addresses.length == amounts.length
439                 && frozenAccount[msg.sender] == false
440                 && now > unlockUnixTime[msg.sender]);
441                 
442         uint256 totalAmount = 0;
443         
444         for(uint j = 0; j < addresses.length; j++){
445             require(amounts[j] > 0
446                     && addresses[j] != 0x0
447                     && frozenAccount[addresses[j]] == false
448                     && now > unlockUnixTime[addresses[j]]);
449                     
450             amounts[j] = amounts[j].mul(1e8);
451             totalAmount = totalAmount.add(amounts[j]);
452         }
453         require(balanceOf[msg.sender] >= totalAmount);
454         
455         for (j = 0; j < addresses.length; j++) {
456             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
457             Transfer(msg.sender, addresses[j], amounts[j]);
458         }
459         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
460         return true;
461     }
462 
463     /**
464      * @dev Function to collect tokens from the list of addresses
465      */
466     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
467         require(addresses.length > 0
468                 && addresses.length == amounts.length);
469 
470         uint256 totalAmount = 0;
471         
472         for (uint j = 0; j < addresses.length; j++) {
473             require(amounts[j] > 0
474                     && addresses[j] != 0x0
475                     && frozenAccount[addresses[j]] == false
476                     && now > unlockUnixTime[addresses[j]]);
477                     
478             amounts[j] = amounts[j].mul(1e8);
479             require(balanceOf[addresses[j]] >= amounts[j]);
480             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
481             totalAmount = totalAmount.add(amounts[j]);
482             Transfer(addresses[j], msg.sender, amounts[j]);
483         }
484         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
485         return true;
486     }
487 
488     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
489         distributeAmount = _unitAmount;
490     }
491     
492     /**
493      * @dev Function to distribute tokens to the msg.sender automatically
494      *      If distributeAmount is 0, this function doesn't work
495      */
496     function autoDistribute() payable public {
497         require(distributeAmount > 0
498                 && balanceOf[owner] >= distributeAmount
499                 && frozenAccount[msg.sender] == false
500                 && now > unlockUnixTime[msg.sender]);
501         if(msg.value > 0) owner.transfer(msg.value);
502         
503         balanceOf[owner] = balanceOf[owner].sub(distributeAmount);
504         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
505         Transfer(owner, msg.sender, distributeAmount);
506     }
507 
508     /**
509      * @dev fallback function
510      */
511     function() payable public {
512         autoDistribute();
513     }
514 }