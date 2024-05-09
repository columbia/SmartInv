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
142 /**
143  * @title CAP
144  * @author CAP people
145  * @dev CAP is an ERC223 Token with ERC20 functions and events
146  *      Fully backward compatible with ERC20
147  */
148 contract CAP is ERC223, Ownable {
149     using SafeMath for uint256;
150 
151     string public name = "CAP";
152     string public symbol = "CAP";
153     string public constant AAcontributors = "CAPcont";
154     uint8 public decimals = 8;
155     uint256 public totalSupply = 2 * 10e15;
156     uint256 public distributeAmount = 0;
157     bool public mintingFinished = false;
158 
159     address public founder = 0x302531ff8f705891032A9BBCCFFCEF6d3BC0e4ca;
160     //address public founder = 0x302531ff8f705891032A9BBCCFFCEF6d3BC0e4ca;
161     //address public preSeasonGame = ;
162     //address public founder = 0x302531ff8f705891032A9BBCCFFCEF6d3BC0e4ca;
163     //address public lockedFundsForthefuture = ;
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
180     function CAP() public {
181         //owner = founder;
182         owner = founder;
183 
184         balanceOf[founder] = totalSupply.mul(100).div(100);
185         //balanceOf[founder] = totalSupply.mul(25).div(100);
186         //balanceOf[preSeasonGame] = totalSupply.mul(55).div(100);
187         //balanceOf[founder] = totalSupply.mul(10).div(100);
188         //balanceOf[lockedFundsForthefuture] = totalSupply.mul(10).div(100);
189     }
190 
191 
192     function name() public view returns (string _name) {
193         return name;
194     }
195 
196     function symbol() public view returns (string _symbol) {
197         return symbol;
198     }
199 
200     function decimals() public view returns (uint8 _decimals) {
201         return decimals;
202     }
203 
204     function totalSupply() public view returns (uint256 _totalSupply) {
205         return totalSupply;
206     }
207 
208     function balanceOf(address _owner) public view returns (uint256 balance) {
209         return balanceOf[_owner];
210     }
211 
212 
213     /**
214      * @dev Prevent targets from sending or receiving tokens
215      * @param targets Addresses to be frozen
216      * @param isFrozen either to freeze it or not
217      */
218     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
219         require(targets.length > 0);
220 
221         for (uint j = 0; j < targets.length; j++) {
222             require(targets[j] != 0x0);
223             frozenAccount[targets[j]] = isFrozen;
224             FrozenFunds(targets[j], isFrozen);
225         }
226     }
227 
228     /**
229      * @dev Prevent targets from sending or receiving tokens by setting Unix times
230      * @param targets Addresses to be locked funds
231      * @param unixTimes Unix times when locking up will be finished
232      */
233     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
234         require(targets.length > 0
235                 && targets.length == unixTimes.length);
236 
237         for(uint j = 0; j < targets.length; j++){
238             require(unlockUnixTime[targets[j]] < unixTimes[j]);
239             unlockUnixTime[targets[j]] = unixTimes[j];
240             LockedFunds(targets[j], unixTimes[j]);
241         }
242     }
243 
244 
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
382 
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
403     /**
404      * @dev Function to mint tokens
405      * @param _to The address that will receive the minted tokens.
406      * @param _unitAmount The amount of tokens to mint.
407      */
408     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
409         require(_unitAmount > 0);
410 
411         totalSupply = totalSupply.add(_unitAmount);
412         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
413         Mint(_to, _unitAmount);
414         Transfer(address(0), _to, _unitAmount);
415         return true;
416     }
417 
418     /**
419      * @dev Function to stop minting new tokens.
420      */
421     function finishMinting() onlyOwner canMint public returns (bool) {
422         mintingFinished = true;
423         MintFinished();
424         return true;
425     }
426 
427 
428 
429     /**
430      * @dev Function to distribute tokens to the list of addresses by the provided amount
431      */
432     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
433         require(amount > 0
434                 && addresses.length > 0
435                 && frozenAccount[msg.sender] == false
436                 && now > unlockUnixTime[msg.sender]);
437 
438         amount = amount.mul(1e8);
439         uint256 totalAmount = amount.mul(addresses.length);
440         require(balanceOf[msg.sender] >= totalAmount);
441 
442         for (uint j = 0; j < addresses.length; j++) {
443             require(addresses[j] != 0x0
444                     && frozenAccount[addresses[j]] == false
445                     && now > unlockUnixTime[addresses[j]]);
446 
447             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
448             Transfer(msg.sender, addresses[j], amount);
449         }
450         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
451         return true;
452     }
453 
454     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
455         require(addresses.length > 0
456                 && addresses.length == amounts.length
457                 && frozenAccount[msg.sender] == false
458                 && now > unlockUnixTime[msg.sender]);
459 
460         uint256 totalAmount = 0;
461 
462         for(uint j = 0; j < addresses.length; j++){
463             require(amounts[j] > 0
464                     && addresses[j] != 0x0
465                     && frozenAccount[addresses[j]] == false
466                     && now > unlockUnixTime[addresses[j]]);
467 
468             amounts[j] = amounts[j].mul(1e8);
469             totalAmount = totalAmount.add(amounts[j]);
470         }
471         require(balanceOf[msg.sender] >= totalAmount);
472 
473         for (j = 0; j < addresses.length; j++) {
474             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
475             Transfer(msg.sender, addresses[j], amounts[j]);
476         }
477         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
478         return true;
479     }
480 
481     /**
482      * @dev Function to collect tokens from the list of addresses
483      */
484     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
485         require(addresses.length > 0
486                 && addresses.length == amounts.length);
487 
488         uint256 totalAmount = 0;
489 
490         for (uint j = 0; j < addresses.length; j++) {
491             require(amounts[j] > 0
492                     && addresses[j] != 0x0
493                     && frozenAccount[addresses[j]] == false
494                     && now > unlockUnixTime[addresses[j]]);
495 
496             amounts[j] = amounts[j].mul(1e8);
497             require(balanceOf[addresses[j]] >= amounts[j]);
498             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
499             totalAmount = totalAmount.add(amounts[j]);
500             Transfer(addresses[j], msg.sender, amounts[j]);
501         }
502         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
503         return true;
504     }
505 
506 
507     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
508         distributeAmount = _unitAmount;
509     }
510 
511     /**
512      * @dev Function to distribute tokens to the msg.sender automatically
513      *      If distributeAmount is 0, this function doesn't work
514      */
515     function autoDistribute() payable public {
516         require(distributeAmount > 0
517                 && balanceOf[founder] >= distributeAmount
518                 && frozenAccount[msg.sender] == false
519                 && now > unlockUnixTime[msg.sender]);
520         if(msg.value > 0) founder.transfer(msg.value);
521 
522         balanceOf[founder] = balanceOf[founder].sub(distributeAmount);
523         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
524         Transfer(founder, msg.sender, distributeAmount);
525     }
526 
527     /**
528      * @dev fallback function
529      */
530     function() payable public {
531         autoDistribute();
532      }
533 
534 }