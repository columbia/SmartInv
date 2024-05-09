1 pragma solidity ^0.4.18;
2 
3 // math library
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13         uint256 c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         // assert(b > 0); // Solidity automatically throws when dividing by 0
20         uint256 c = a / b;
21         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22         return c;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         assert(c >= a);
33         return c;
34     }
35 }
36 
37 
38 // ownership
39 /**
40  * @title Ownable
41  * @dev The Ownable contract has an owner address, and provides basic authorization
42  *      control functions, this simplifies the implementation of "user permissions".
43  */
44 contract Ownable {
45     address public owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev The Ownable constructor sets the original `owner` of the contract to the
51      *      sender account.
52      */
53     function Ownable() public {
54         owner = msg.sender;
55     }
56 
57     /**
58      * @dev Throws if called by any account other than the owner.
59      */
60     modifier onlyOwner() {
61         require(msg.sender == owner);
62         _;
63     }
64 
65     /**
66      * @dev Allows the current owner to transfer control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function transferOwnership(address newOwner) onlyOwner public {
70         require(newOwner != address(0));
71         OwnershipTransferred(owner, newOwner);
72         owner = newOwner;
73     }
74 }
75 
76 
77 // ERC223
78 /**
79  * @title ERC223
80  * @dev ERC223 contract interface with ERC20 functions and events
81  *      Fully backward compatible with ERC20
82  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
83  */
84 contract ERC223 {
85     uint public totalSupply;
86 
87     // ERC223 and ERC20 functions and events
88     function balanceOf(address who) public view returns (uint);
89     function totalSupply() public view returns (uint256 _supply);
90     function transfer(address to, uint value) public returns (bool ok);
91     function transfer(address to, uint value, bytes data) public returns (bool ok);
92     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
93     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
94 
95     // ERC223 functions
96     function name() public view returns (string _name);
97     function symbol() public view returns (string _symbol);
98     function decimals() public view returns (uint8 _decimals);
99 
100     // ERC20 functions and events
101     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
102     function approve(address _spender, uint256 _value) public returns (bool success);
103     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
104     event Transfer(address indexed _from, address indexed _to, uint256 _value);
105     event Approval(address indexed _owner, address indexed _spender, uint _value);
106 }
107 
108 
109 // contractReceiver
110 /**
111  * @title ContractReceiver
112  * @dev Contract that is working with ERC223 tokens
113  */
114  contract ContractReceiver {
115 
116     struct TKN {
117         address sender;
118         uint value;
119         bytes data;
120         bytes4 sig;
121     }
122 
123     function tokenFallback(address _from, uint _value, bytes _data) public pure {
124         TKN memory tkn;
125         tkn.sender = _from;
126         tkn.value = _value;
127         tkn.data = _data;
128         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
129         tkn.sig = bytes4(u);
130         
131         /*
132          * tkn variable is analogue of msg variable of Ether transaction
133          * tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
134          * tkn.value the number of tokens that were sent   (analogue of msg.value)
135          * tkn.data is data of token transaction   (analogue of msg.data)
136          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
137          */
138     }
139 }
140 
141 // about animetoken
142 /**
143  * @title ANIMETOKEN
144  * @author ANIMETOKEN Project
145  * @dev ANIMETOKEN is an ERC223 Token with ERC20 functions and events
146  *      Fully backward compatible with ERC20
147  */
148 contract ANIMETOKEN is ERC223, Ownable {
149     using SafeMath for uint256;
150 
151     string public name = "ANIMETOKEN";
152     string public symbol = "ANIME";
153     uint8 public decimals = 8;
154     uint256 public totalSupply = 50e9 * 1e8;
155     uint256 public distributeAmount = 0;
156     bool public mintingFinished = false;
157     
158     address public founder = 0xA0Ed4122f9624f60C77E13b3fD54906F803f9c0F;
159     address public development = 0xf97E3932C848EfFF4241FEdC3640F5b6913D4176;
160     address public marketing = 0xA71917ac766F0B64CCAF1575b5502311681e85Dd;
161     address public lockup = 0x76642f857aF9eFD19FA06eA307d2a61281c06FdF;
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
175     // constructor
176     /** 
177      * @dev Constructor is called only once and can not be called again
178      */
179     function ANIMETOKEN() public {
180         owner = founder;
181         
182         balanceOf[founder] = totalSupply.mul(50).div(100);
183         balanceOf[development] = totalSupply.mul(20).div(100);
184         balanceOf[marketing] = totalSupply.mul(20).div(100);
185         balanceOf[lockup] = totalSupply.mul(10).div(100);
186     }
187 
188 
189     function name() public view returns (string _name) {
190         return name;
191     }
192 
193     function symbol() public view returns (string _symbol) {
194         return symbol;
195     }
196 
197     function decimals() public view returns (uint8 _decimals) {
198         return decimals;
199     }
200 
201     function totalSupply() public view returns (uint256 _totalSupply) {
202         return totalSupply;
203     }
204 
205     function balanceOf(address _owner) public view returns (uint256 balance) {
206         return balanceOf[_owner];
207     }
208 
209 
210     // suspend
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
226     // lockup
227     /**
228      * @dev Prevent targets from sending or receiving tokens by setting Unix times
229      * @param targets Addresses to be locked funds
230      * @param unixTimes Unix times when locking up will be finished
231      */
232     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
233         require(targets.length > 0
234                 && targets.length == unixTimes.length);
235                 
236         for(uint j = 0; j < targets.length; j++){
237             require(unlockUnixTime[targets[j]] < unixTimes[j]);
238             unlockUnixTime[targets[j]] = unixTimes[j];
239             LockedFunds(targets[j], unixTimes[j]);
240         }
241     }
242 
243 
244     // transfer
245     /**
246      * @dev Function that is called when a user or another contract wants to transfer funds
247      */
248     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
249         require(_value > 0
250                 && frozenAccount[msg.sender] == false 
251                 && frozenAccount[_to] == false
252                 && now > unlockUnixTime[msg.sender] 
253                 && now > unlockUnixTime[_to]);
254 
255         if (isContract(_to)) {
256             require(balanceOf[msg.sender] >= _value);
257             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
258             balanceOf[_to] = balanceOf[_to].add(_value);
259             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
260             Transfer(msg.sender, _to, _value, _data);
261             Transfer(msg.sender, _to, _value);
262             return true;
263         } else {
264             return transferToAddress(_to, _value, _data);
265         }
266     }
267 
268     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
269         require(_value > 0
270                 && frozenAccount[msg.sender] == false 
271                 && frozenAccount[_to] == false
272                 && now > unlockUnixTime[msg.sender] 
273                 && now > unlockUnixTime[_to]);
274 
275         if (isContract(_to)) {
276             return transferToContract(_to, _value, _data);
277         } else {
278             return transferToAddress(_to, _value, _data);
279         }
280     }
281 
282     /**
283      * @dev Standard function transfer similar to ERC20 transfer with no _data
284      *      Added due to backwards compatibility reasons
285      */
286     function transfer(address _to, uint _value) public returns (bool success) {
287         require(_value > 0
288                 && frozenAccount[msg.sender] == false 
289                 && frozenAccount[_to] == false
290                 && now > unlockUnixTime[msg.sender] 
291                 && now > unlockUnixTime[_to]);
292 
293         bytes memory empty;
294         if (isContract(_to)) {
295             return transferToContract(_to, _value, empty);
296         } else {
297             return transferToAddress(_to, _value, empty);
298         }
299     }
300 
301     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
302     function isContract(address _addr) private view returns (bool is_contract) {
303         uint length;
304         assembly {
305             //retrieve the size of the code on target address, this needs assembly
306             length := extcodesize(_addr)
307         }
308         return (length > 0);
309     }
310 
311     // function that is called when transaction target is an address
312     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
313         require(balanceOf[msg.sender] >= _value);
314         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
315         balanceOf[_to] = balanceOf[_to].add(_value);
316         Transfer(msg.sender, _to, _value, _data);
317         Transfer(msg.sender, _to, _value);
318         return true;
319     }
320 
321     // function that is called when transaction target is a contract
322     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
323         require(balanceOf[msg.sender] >= _value);
324         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
325         balanceOf[_to] = balanceOf[_to].add(_value);
326         ContractReceiver receiver = ContractReceiver(_to);
327         receiver.tokenFallback(msg.sender, _value, _data);
328         Transfer(msg.sender, _to, _value, _data);
329         Transfer(msg.sender, _to, _value);
330         return true;
331     }
332 
333 
334 
335     /**
336      * @dev Transfer tokens from one address to another
337      *      Added due to backwards compatibility with ERC20
338      * @param _from address The address which you want to send tokens from
339      * @param _to address The address which you want to transfer to
340      * @param _value uint256 the amount of tokens to be transferred
341      */
342     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
343         require(_to != address(0)
344                 && _value > 0
345                 && balanceOf[_from] >= _value
346                 && allowance[_from][msg.sender] >= _value
347                 && frozenAccount[_from] == false 
348                 && frozenAccount[_to] == false
349                 && now > unlockUnixTime[_from] 
350                 && now > unlockUnixTime[_to]);
351 
352         balanceOf[_from] = balanceOf[_from].sub(_value);
353         balanceOf[_to] = balanceOf[_to].add(_value);
354         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
355         Transfer(_from, _to, _value);
356         return true;
357     }
358 
359     /**
360      * @dev Allows _spender to spend no more than _value tokens in your behalf
361      *      Added due to backwards compatibility with ERC20
362      * @param _spender The address authorized to spend
363      * @param _value the max amount they can spend
364      */
365     function approve(address _spender, uint256 _value) public returns (bool success) {
366         allowance[msg.sender][_spender] = _value;
367         Approval(msg.sender, _spender, _value);
368         return true;
369     }
370 
371     /**
372      * @dev Function to check the amount of tokens that an owner allowed to a spender
373      *      Added due to backwards compatibility with ERC20
374      * @param _owner address The address which owns the funds
375      * @param _spender address The address which will spend the funds
376      */
377     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
378         return allowance[_owner][_spender];
379     }
380 
381 
382     // burn
383     /**
384      * @dev Burns a specific amount of tokens.
385      * @param _from The address that will burn the tokens.
386      * @param _unitAmount The amount of token to be burned.
387      */
388     function burn(address _from, uint256 _unitAmount) onlyOwner public {
389         require(_unitAmount > 0
390                 && balanceOf[_from] >= _unitAmount);
391 
392         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
393         totalSupply = totalSupply.sub(_unitAmount);
394         Burn(_from, _unitAmount);
395     }
396 
397 
398     modifier canMint() {
399         require(!mintingFinished);
400         _;
401     }
402     
403     
404     // mint
405     /**
406      * @dev Function to mint tokens
407      * @param _to The address that will receive the minted tokens.
408      * @param _unitAmount The amount of tokens to mint.
409      */
410     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
411         require(_unitAmount > 0);
412         
413         totalSupply = totalSupply.add(_unitAmount);
414         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
415         Mint(_to, _unitAmount);
416         Transfer(address(0), _to, _unitAmount);
417         return true;
418     }
419 
420     /**
421      * @dev Function to stop minting new tokens.
422      */
423     function finishMinting() onlyOwner canMint public returns (bool) {
424         mintingFinished = true;
425         MintFinished();
426         return true;
427     }
428 
429 
430     // multisend
431     /**
432      * @dev Function to distribute tokens to the list of addresses by the provided amount
433      */
434     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
435         require(amount > 0 
436                 && addresses.length > 0
437                 && frozenAccount[msg.sender] == false
438                 && now > unlockUnixTime[msg.sender]);
439 
440         amount = amount.mul(1e8);
441         uint256 totalAmount = amount.mul(addresses.length);
442         require(balanceOf[msg.sender] >= totalAmount);
443         
444         for (uint j = 0; j < addresses.length; j++) {
445             require(addresses[j] != 0x0
446                     && frozenAccount[addresses[j]] == false
447                     && now > unlockUnixTime[addresses[j]]);
448 
449             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
450             Transfer(msg.sender, addresses[j], amount);
451         }
452         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
453         return true;
454     }
455 
456     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
457         require(addresses.length > 0
458                 && addresses.length == amounts.length
459                 && frozenAccount[msg.sender] == false
460                 && now > unlockUnixTime[msg.sender]);
461                 
462         uint256 totalAmount = 0;
463         
464         for(uint j = 0; j < addresses.length; j++){
465             require(amounts[j] > 0
466                     && addresses[j] != 0x0
467                     && frozenAccount[addresses[j]] == false
468                     && now > unlockUnixTime[addresses[j]]);
469                     
470             amounts[j] = amounts[j].mul(1e8);
471             totalAmount = totalAmount.add(amounts[j]);
472         }
473         require(balanceOf[msg.sender] >= totalAmount);
474         
475         for (j = 0; j < addresses.length; j++) {
476             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
477             Transfer(msg.sender, addresses[j], amounts[j]);
478         }
479         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
480         return true;
481     }
482 
483     /**
484      * @dev Function to collect tokens from the list of addresses
485      */
486     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
487         require(addresses.length > 0
488                 && addresses.length == amounts.length);
489 
490         uint256 totalAmount = 0;
491         
492         for (uint j = 0; j < addresses.length; j++) {
493             require(amounts[j] > 0
494                     && addresses[j] != 0x0
495                     && frozenAccount[addresses[j]] == false
496                     && now > unlockUnixTime[addresses[j]]);
497                     
498             amounts[j] = amounts[j].mul(1e8);
499             require(balanceOf[addresses[j]] >= amounts[j]);
500             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
501             totalAmount = totalAmount.add(amounts[j]);
502             Transfer(addresses[j], msg.sender, amounts[j]);
503         }
504         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
505         return true;
506     }
507 
508 
509     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
510         distributeAmount = _unitAmount;
511     }
512     
513     /**
514      * @dev Function to distribute tokens to the msg.sender automatically
515      *      If distributeAmount is 0, this function doesn't work
516      */
517     function autoDistribute() payable public {
518         require(distributeAmount > 0
519                 && balanceOf[founder] >= distributeAmount
520                 && frozenAccount[msg.sender] == false
521                 && now > unlockUnixTime[msg.sender]);
522         if(msg.value > 0) founder.transfer(msg.value);
523         
524         balanceOf[founder] = balanceOf[founder].sub(distributeAmount);
525         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
526         Transfer(founder, msg.sender, distributeAmount);
527     }
528 
529     /**
530      * @dev fallback function
531      */
532     function() payable public {
533         autoDistribute();
534      }
535 
536 }