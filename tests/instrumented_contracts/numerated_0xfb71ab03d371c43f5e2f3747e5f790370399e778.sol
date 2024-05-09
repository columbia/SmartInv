1 pragma solidity ^0.4.18;
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
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization
41  *      control functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44     address public owner;
45 
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48     /**
49      * @dev The Ownable constructor sets the original `owner` of the contract to the
50      *      sender account.
51      */
52     function Ownable() public {
53         owner = msg.sender;
54     }
55 
56     /**
57      * @dev Throws if called by any account other than the owner.
58      */
59     modifier onlyOwner() {
60         require(msg.sender == owner);
61         _;
62     }
63 
64     /**
65      * @dev Allows the current owner to transfer control of the contract to a newOwner.
66      * @param newOwner The address to transfer ownership to.
67      */
68     function transferOwnership(address newOwner) onlyOwner public {
69         require(newOwner != address(0));
70         OwnershipTransferred(owner, newOwner);
71         owner = newOwner;
72     }
73 }
74 
75 
76 
77 /**
78  * @title ERC223
79  * @dev ERC223 contract interface with ERC20 functions and events
80  *      Fully backward compatible with ERC20
81  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
82  */
83 contract ERC223 {
84     uint public totalSupply;
85 
86     // ERC223 and ERC20 functions and events
87     function balanceOf(address who) public view returns (uint);
88     function totalSupply() public view returns (uint256 _supply);
89     function transfer(address to, uint value) public returns (bool ok);
90     function transfer(address to, uint value, bytes data) public returns (bool ok);
91     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
92     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
93 
94     // ERC223 functions
95     function name() public view returns (string _name);
96     function symbol() public view returns (string _symbol);
97     function decimals() public view returns (uint8 _decimals);
98 
99     // ERC20 functions and events
100     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
101     function approve(address _spender, uint256 _value) public returns (bool success);
102     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
103     event Transfer(address indexed _from, address indexed _to, uint256 _value);
104     event Approval(address indexed _owner, address indexed _spender, uint _value);
105 }
106 
107 
108 
109 /**
110  * @title ContractReceiver
111  * @dev Contract that is working with ERC223 tokens
112  */
113  contract ContractReceiver {
114 
115     struct TKN {
116         address sender;
117         uint value;
118         bytes data;
119         bytes4 sig;
120     }
121 
122     function tokenFallback(address _from, uint _value, bytes _data) public pure {
123         TKN memory tkn;
124         tkn.sender = _from;
125         tkn.value = _value;
126         tkn.data = _data;
127         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
128         tkn.sig = bytes4(u);
129 
130         /*
131          * tkn variable is analogue of msg variable of Ether transaction
132          * tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
133          * tkn.value the number of tokens that were sent   (analogue of msg.value)
134          * tkn.data is data of token transaction   (analogue of msg.data)
135          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
136          */
137     }
138 }
139 
140 
141 
142 
143 /**
144  * @title OREOCOIN
145  * @author ANWAR
146  * @dev OREOCOIN is an ERC223 Token with ERC20 functions and events
147  *      Fully backward compatible with ERC20
148  */
149 contract OREO is ERC223, Ownable {
150     using SafeMath for uint256;
151 
152     string public name = "OREOCOIN";
153     string public symbol = "OREO";
154     string public constant AAcontributors = "ANWAR";
155     uint8 public decimals = 18;
156     uint256 public totalSupply = 1e9 * 1e18;
157     uint256 public distributeAmount = 0;
158     bool public mintingFinished = false;
159 
160     address public founder = 0x6a240e115f04E8d4868DEB47951d95cA4D0Bd968;
161     address public developingFund = 0xdd1ab7b025961ddb0e9313d04933fa67f962293b;
162     address public activityFunds = 0x5998726b57f28da32414274764fb7bb32cc318cb;
163     address public lockedFundsForthefuture = 0x6a69563f627fd4ae48172f934c430542696b5b92;
164 
165     mapping(address => uint256) public balanceOf;
166     mapping(address => mapping (address => uint256)) public allowance;
167     mapping (address => bool) public frozenAccount;
168     mapping (address => uint256) public unlockUnixTime;
169 
170     event FrozenFunds(address indexed target, bool frozen);
171     event LockedFunds(address indexed target, uint256 locked);
172     event Burn(address indexed from, uint256 amount);
173     event Mint(address indexed to, uint256 amount);
174     event MintFinished();
175 
176 
177     /**
178      * @dev Constructor is called only once and can not be called again
179      */
180     function OREO() public {
181         owner = activityFunds;
182 
183         balanceOf[founder] = totalSupply.mul(25).div(100);
184         balanceOf[developingFund] = totalSupply.mul(55).div(100);
185         balanceOf[activityFunds] = totalSupply.mul(10).div(100);
186         balanceOf[lockedFundsForthefuture] = totalSupply.mul(10).div(100);
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
515                 && balanceOf[activityFunds] >= distributeAmount
516                 && frozenAccount[msg.sender] == false
517                 && now > unlockUnixTime[msg.sender]);
518         if(msg.value > 0) activityFunds.transfer(msg.value);
519 
520         balanceOf[activityFunds] = balanceOf[activityFunds].sub(distributeAmount);
521         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
522         Transfer(activityFunds, msg.sender, distributeAmount);
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