1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7         if (a == 0) {
8             return 0;
9         }
10         uint256 c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization
39  *      control functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42     address public owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev The Ownable constructor sets the original `owner` of the contract to the
48      *      sender account.
49      */
50     function Ownable() public {
51         owner = msg.sender;
52     }
53 
54     /**
55      * @dev Throws if called by any account other than the owner.
56      */
57     modifier onlyOwner() {
58         require(msg.sender == owner);
59         _;
60     }
61 
62     /**
63      * @dev Allows the current owner to transfer control of the contract to a newOwner.
64      * @param newOwner The address to transfer ownership to.
65      */
66     function transferOwnership(address newOwner) onlyOwner public {
67         require(newOwner != address(0));
68         OwnershipTransferred(owner, newOwner);
69         owner = newOwner;
70     }
71 }
72 
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
106 
107 /**
108  * @title ContractReceiver
109  * @dev Contract that is working with ERC223 tokens
110  */
111  contract ContractReceiver {
112 
113     struct TKN {
114         address sender;
115         uint value;
116         bytes data;
117         bytes4 sig;
118     }
119 
120     function tokenFallback(address _from, uint _value, bytes _data) public pure {
121         TKN memory tkn;
122         tkn.sender = _from;
123         tkn.value = _value;
124         tkn.data = _data;
125         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
126         tkn.sig = bytes4(u);
127 
128         /*
129          * tkn variable is analogue of msg variable of Ether transaction
130          * tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
131          * tkn.value the number of tokens that were sent   (analogue of msg.value)
132          * tkn.data is data of token transaction   (analogue of msg.data)
133          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
134          */
135     }
136 }
137 
138 
139 
140 /**
141  * @title AMAL
142  * @author AMAL people
143  * @dev AMAL is an ERC223 Token with ERC20 functions and events
144  *      Fully backward compatible with ERC20
145  */
146 contract AMAL is ERC223, Ownable {
147     using SafeMath for uint256;
148 
149     string public name = "AMAL";
150     string public symbol = "AMAL";
151     string public constant AAcontributors = "AMALcont";
152     uint8 public decimals = 8;
153     uint256 public totalSupply = 21e7 * 1e8;
154     uint256 public distributeAmount = 0;
155     bool public mintingFinished = false;
156 
157     address public founder = 0xBF89166D97dDBe3444e26a84606ee18B4fF34164;
158     //address public founder = 0xBF89166D97dDBe3444e26a84606ee18B4fF34164;
159     //address public preSeasonGame = ;
160     //address public founder = 0xBF89166D97dDBe3444e26a84606ee18B4fF34164;
161     //address public lockedFundsForthefuture = ;
162 
163     mapping(address => uint256) public balanceOf;
164     mapping(address => mapping (address => uint256)) public allowance;
165     mapping (address => bool) public frozenAccount;
166     mapping (address => uint256) public unlockUnixTime;
167 
168     event FrozenFunds(address indexed target, bool frozen);
169     event LockedFunds(address indexed target, uint256 locked);
170     event Burn(address indexed from, uint256 amount);
171     event Mint(address indexed to, uint256 amount);
172     event MintFinished();
173 
174 
175     /**
176      * @dev Constructor is called only once and can not be called again
177      */
178     function AMAL() public {
179         //owner = founder;
180         owner = founder;
181 
182         balanceOf[founder] = totalSupply.mul(100).div(100);
183         //balanceOf[founder] = totalSupply.mul(25).div(100);
184         //balanceOf[preSeasonGame] = totalSupply.mul(55).div(100);
185         //balanceOf[founder] = totalSupply.mul(10).div(100);
186         //balanceOf[lockedFundsForthefuture] = totalSupply.mul(10).div(100);
187     }
188 
189 
190     function name() public view returns (string _name) {
191         return name;
192     }
193 
194     function symbol() public view returns (string _symbol) {
195         return symbol;
196     }
197 
198     function decimals() public view returns (uint8 _decimals) {
199         return decimals;
200     }
201 
202     function totalSupply() public view returns (uint256 _totalSupply) {
203         return totalSupply;
204     }
205 
206     function balanceOf(address _owner) public view returns (uint256 balance) {
207         return balanceOf[_owner];
208     }
209 
210 
211     /**
212      * @dev Prevent targets from sending or receiving tokens
213      * @param targets Addresses to be frozen
214      * @param isFrozen either to freeze it or not
215      */
216     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
217         require(targets.length > 0);
218 
219         for (uint j = 0; j < targets.length; j++) {
220             require(targets[j] != 0x0);
221             frozenAccount[targets[j]] = isFrozen;
222             FrozenFunds(targets[j], isFrozen);
223         }
224     }
225 
226     /**
227      * @dev Prevent targets from sending or receiving tokens by setting Unix times
228      * @param targets Addresses to be locked funds
229      * @param unixTimes Unix times when locking up will be finished
230      */
231     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
232         require(targets.length > 0
233                 && targets.length == unixTimes.length);
234 
235         for(uint j = 0; j < targets.length; j++){
236             require(unlockUnixTime[targets[j]] < unixTimes[j]);
237             unlockUnixTime[targets[j]] = unixTimes[j];
238             LockedFunds(targets[j], unixTimes[j]);
239         }
240     }
241 
242 
243     /**
244      * @dev Function that is called when a user or another contract wants to transfer funds
245      */
246     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
247         require(_value > 0
248                 && frozenAccount[msg.sender] == false
249                 && frozenAccount[_to] == false
250                 && now > unlockUnixTime[msg.sender]
251                 && now > unlockUnixTime[_to]);
252 
253         if (isContract(_to)) {
254             require(balanceOf[msg.sender] >= _value);
255             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
256             balanceOf[_to] = balanceOf[_to].add(_value);
257             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
258             Transfer(msg.sender, _to, _value, _data);
259             Transfer(msg.sender, _to, _value);
260             return true;
261         } else {
262             return transferToAddress(_to, _value, _data);
263         }
264     }
265 
266     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
267         require(_value > 0
268                 && frozenAccount[msg.sender] == false
269                 && frozenAccount[_to] == false
270                 && now > unlockUnixTime[msg.sender]
271                 && now > unlockUnixTime[_to]);
272 
273         if (isContract(_to)) {
274             return transferToContract(_to, _value, _data);
275         } else {
276             return transferToAddress(_to, _value, _data);
277         }
278     }
279 
280     /**
281      * @dev Standard function transfer similar to ERC20 transfer with no _data
282      *      Added due to backwards compatibility reasons
283      */
284     function transfer(address _to, uint _value) public returns (bool success) {
285         require(_value > 0
286                 && frozenAccount[msg.sender] == false
287                 && frozenAccount[_to] == false
288                 && now > unlockUnixTime[msg.sender]
289                 && now > unlockUnixTime[_to]);
290 
291         bytes memory empty;
292         if (isContract(_to)) {
293             return transferToContract(_to, _value, empty);
294         } else {
295             return transferToAddress(_to, _value, empty);
296         }
297     }
298 
299     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
300     function isContract(address _addr) private view returns (bool is_contract) {
301         uint length;
302         assembly {
303             //retrieve the size of the code on target address, this needs assembly
304             length := extcodesize(_addr)
305         }
306         return (length > 0);
307     }
308 
309     // function that is called when transaction target is an address
310     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
311         require(balanceOf[msg.sender] >= _value);
312         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
313         balanceOf[_to] = balanceOf[_to].add(_value);
314         Transfer(msg.sender, _to, _value, _data);
315         Transfer(msg.sender, _to, _value);
316         return true;
317     }
318 
319     // function that is called when transaction target is a contract
320     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
321         require(balanceOf[msg.sender] >= _value);
322         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
323         balanceOf[_to] = balanceOf[_to].add(_value);
324         ContractReceiver receiver = ContractReceiver(_to);
325         receiver.tokenFallback(msg.sender, _value, _data);
326         Transfer(msg.sender, _to, _value, _data);
327         Transfer(msg.sender, _to, _value);
328         return true;
329     }
330 
331 
332 
333     /**
334      * @dev Transfer tokens from one address to another
335      *      Added due to backwards compatibility with ERC20
336      * @param _from address The address which you want to send tokens from
337      * @param _to address The address which you want to transfer to
338      * @param _value uint256 the amount of tokens to be transferred
339      */
340     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
341         require(_to != address(0)
342                 && _value > 0
343                 && balanceOf[_from] >= _value
344                 && allowance[_from][msg.sender] >= _value
345                 && frozenAccount[_from] == false
346                 && frozenAccount[_to] == false
347                 && now > unlockUnixTime[_from]
348                 && now > unlockUnixTime[_to]);
349 
350         balanceOf[_from] = balanceOf[_from].sub(_value);
351         balanceOf[_to] = balanceOf[_to].add(_value);
352         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
353         Transfer(_from, _to, _value);
354         return true;
355     }
356 
357     /**
358      * @dev Allows _spender to spend no more than _value tokens in your behalf
359      *      Added due to backwards compatibility with ERC20
360      * @param _spender The address authorized to spend
361      * @param _value the max amount they can spend
362      */
363     function approve(address _spender, uint256 _value) public returns (bool success) {
364         allowance[msg.sender][_spender] = _value;
365         Approval(msg.sender, _spender, _value);
366         return true;
367     }
368 
369     /**
370      * @dev Function to check the amount of tokens that an owner allowed to a spender
371      *      Added due to backwards compatibility with ERC20
372      * @param _owner address The address which owns the funds
373      * @param _spender address The address which will spend the funds
374      */
375     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
376         return allowance[_owner][_spender];
377     }
378 
379 
380 
381     /**
382      * @dev Burns a specific amount of tokens.
383      * @param _from The address that will burn the tokens.
384      * @param _unitAmount The amount of token to be burned.
385      */
386     function burn(address _from, uint256 _unitAmount) onlyOwner public {
387         require(_unitAmount > 0
388                 && balanceOf[_from] >= _unitAmount);
389 
390         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
391         totalSupply = totalSupply.sub(_unitAmount);
392         Burn(_from, _unitAmount);
393     }
394 
395 
396     modifier canMint() {
397         require(!mintingFinished);
398         _;
399     }
400 
401     /**
402      * @dev Function to mint tokens
403      * @param _to The address that will receive the minted tokens.
404      * @param _unitAmount The amount of tokens to mint.
405      */
406     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
407         require(_unitAmount > 0);
408 
409         totalSupply = totalSupply.add(_unitAmount);
410         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
411         Mint(_to, _unitAmount);
412         Transfer(address(0), _to, _unitAmount);
413         return true;
414     }
415 
416     /**
417      * @dev Function to stop minting new tokens.
418      */
419     function finishMinting() onlyOwner canMint public returns (bool) {
420         mintingFinished = true;
421         MintFinished();
422         return true;
423     }
424 
425 
426 
427     /**
428      * @dev Function to distribute tokens to the list of addresses by the provided amount
429      */
430     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
431         require(amount > 0
432                 && addresses.length > 0
433                 && frozenAccount[msg.sender] == false
434                 && now > unlockUnixTime[msg.sender]);
435 
436         amount = amount.mul(1e8);
437         uint256 totalAmount = amount.mul(addresses.length);
438         require(balanceOf[msg.sender] >= totalAmount);
439 
440         for (uint j = 0; j < addresses.length; j++) {
441             require(addresses[j] != 0x0
442                     && frozenAccount[addresses[j]] == false
443                     && now > unlockUnixTime[addresses[j]]);
444 
445             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
446             Transfer(msg.sender, addresses[j], amount);
447         }
448         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
449         return true;
450     }
451 
452     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
453         require(addresses.length > 0
454                 && addresses.length == amounts.length
455                 && frozenAccount[msg.sender] == false
456                 && now > unlockUnixTime[msg.sender]);
457 
458         uint256 totalAmount = 0;
459 
460         for(uint j = 0; j < addresses.length; j++){
461             require(amounts[j] > 0
462                     && addresses[j] != 0x0
463                     && frozenAccount[addresses[j]] == false
464                     && now > unlockUnixTime[addresses[j]]);
465 
466             amounts[j] = amounts[j].mul(1e8);
467             totalAmount = totalAmount.add(amounts[j]);
468         }
469         require(balanceOf[msg.sender] >= totalAmount);
470 
471         for (j = 0; j < addresses.length; j++) {
472             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
473             Transfer(msg.sender, addresses[j], amounts[j]);
474         }
475         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
476         return true;
477     }
478 
479     /**
480      * @dev Function to collect tokens from the list of addresses
481      */
482     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
483         require(addresses.length > 0
484                 && addresses.length == amounts.length);
485 
486         uint256 totalAmount = 0;
487 
488         for (uint j = 0; j < addresses.length; j++) {
489             require(amounts[j] > 0
490                     && addresses[j] != 0x0
491                     && frozenAccount[addresses[j]] == false
492                     && now > unlockUnixTime[addresses[j]]);
493 
494             amounts[j] = amounts[j].mul(1e8);
495             require(balanceOf[addresses[j]] >= amounts[j]);
496             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
497             totalAmount = totalAmount.add(amounts[j]);
498             Transfer(addresses[j], msg.sender, amounts[j]);
499         }
500         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
501         return true;
502     }
503 
504 
505     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
506         distributeAmount = _unitAmount;
507     }
508 
509     /**
510      * @dev Function to distribute tokens to the msg.sender automatically
511      *      If distributeAmount is 0, this function doesn't work
512      */
513     function autoDistribute() payable public {
514         require(distributeAmount > 0
515                 && balanceOf[founder] >= distributeAmount
516                 && frozenAccount[msg.sender] == false
517                 && now > unlockUnixTime[msg.sender]);
518         if(msg.value > 0) founder.transfer(msg.value);
519 
520         balanceOf[founder] = balanceOf[founder].sub(distributeAmount);
521         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
522         Transfer(founder, msg.sender, distributeAmount);
523     }
524 
525     /**
526      * @dev fallback function
527      */
528     function() payable public {
529         autoDistribute();
530      }
531 
532 }