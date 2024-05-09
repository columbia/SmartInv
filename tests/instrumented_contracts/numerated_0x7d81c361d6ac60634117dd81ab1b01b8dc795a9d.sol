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
78  * 彡(^)(^)
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
109 
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
141 
142 /**
143  * 彡(ﾟ)(ﾟ)
144  * @title LILITHCOIN
145  * @author Team LILITH
146  * @dev LILITHCOIN is an ERC223 Token with ERC20 functions and events
147  *      Fully backward compatible with ERC20
148  */
149 contract LILITHCOIN is ERC223, Ownable {
150     using SafeMath for uint256;
151 
152     string public name = "LILITHCOIN";
153     string public symbol = "LILI";
154     uint8 public decimals = 8;
155     uint256 public totalSupply = 50e9 * 1e8;
156     uint256 public distributeAmount = 0;
157     bool public mintingFinished = false;
158     
159 
160     mapping(address => uint256) public balanceOf;
161     mapping(address => mapping (address => uint256)) public allowance;
162     mapping (address => bool) public frozenAccount;
163     mapping (address => uint256) public unlockUnixTime;
164     
165     event FrozenFunds(address indexed target, bool frozen);
166     event LockedFunds(address indexed target, uint256 locked);
167     event Burn(address indexed from, uint256 amount);
168     event Mint(address indexed to, uint256 amount);
169     event MintFinished();
170 
171 
172     /** 
173      * @dev Constructor is called only once and can not be called again
174      */
175     function LILITHCOIN() public {
176              balanceOf[msg.sender] = totalSupply;
177     }
178 
179 
180     function name() public view returns (string _name) {
181         return name;
182     }
183 
184     function symbol() public view returns (string _symbol) {
185         return symbol;
186     }
187 
188     function decimals() public view returns (uint8 _decimals) {
189         return decimals;
190     }
191 
192     function totalSupply() public view returns (uint256 _totalSupply) {
193         return totalSupply;
194     }
195 
196     function balanceOf(address _owner) public view returns (uint256 balance) {
197         return balanceOf[_owner];
198     }
199 
200 
201     /**
202      * @dev Prevent targets from sending or receiving tokens
203      * @param targets Addresses to be frozen
204      * @param isFrozen either to freeze it or not
205      */
206     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
207         require(targets.length > 0);
208 
209         for (uint j = 0; j < targets.length; j++) {
210             require(targets[j] != 0x0);
211             frozenAccount[targets[j]] = isFrozen;
212             FrozenFunds(targets[j], isFrozen);
213         }
214     }
215 
216     /**
217      * @dev Prevent targets from sending or receiving tokens by setting Unix times
218      * @param targets Addresses to be locked funds
219      * @param unixTimes Unix times when locking up will be finished
220      */
221     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
222         require(targets.length > 0
223                 && targets.length == unixTimes.length);
224                 
225         for(uint j = 0; j < targets.length; j++){
226             require(unlockUnixTime[targets[j]] < unixTimes[j]);
227             unlockUnixTime[targets[j]] = unixTimes[j];
228             LockedFunds(targets[j], unixTimes[j]);
229         }
230     }
231 
232 
233     /**
234      * @dev Function that is called when a user or another contract wants to transfer funds
235      */
236     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
237         require(_value > 0
238                 && frozenAccount[msg.sender] == false 
239                 && frozenAccount[_to] == false
240                 && now > unlockUnixTime[msg.sender] 
241                 && now > unlockUnixTime[_to]);
242 
243         if (isContract(_to)) {
244             require(balanceOf[msg.sender] >= _value);
245             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
246             balanceOf[_to] = balanceOf[_to].add(_value);
247             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
248             Transfer(msg.sender, _to, _value, _data);
249             Transfer(msg.sender, _to, _value);
250             return true;
251         } else {
252             return transferToAddress(_to, _value, _data);
253         }
254     }
255 
256     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
257         require(_value > 0
258                 && frozenAccount[msg.sender] == false 
259                 && frozenAccount[_to] == false
260                 && now > unlockUnixTime[msg.sender] 
261                 && now > unlockUnixTime[_to]);
262 
263         if (isContract(_to)) {
264             return transferToContract(_to, _value, _data);
265         } else {
266             return transferToAddress(_to, _value, _data);
267         }
268     }
269 
270     /**
271      * @dev Standard function transfer similar to ERC20 transfer with no _data
272      *      Added due to backwards compatibility reasons
273      */
274     function transfer(address _to, uint _value) public returns (bool success) {
275         require(_value > 0
276                 && frozenAccount[msg.sender] == false 
277                 && frozenAccount[_to] == false
278                 && now > unlockUnixTime[msg.sender] 
279                 && now > unlockUnixTime[_to]);
280 
281         bytes memory empty;
282         if (isContract(_to)) {
283             return transferToContract(_to, _value, empty);
284         } else {
285             return transferToAddress(_to, _value, empty);
286         }
287     }
288 
289     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
290     function isContract(address _addr) private view returns (bool is_contract) {
291         uint length;
292         assembly {
293             //retrieve the size of the code on target address, this needs assembly
294             length := extcodesize(_addr)
295         }
296         return (length > 0);
297     }
298 
299     // function that is called when transaction target is an address
300     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
301         require(balanceOf[msg.sender] >= _value);
302         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
303         balanceOf[_to] = balanceOf[_to].add(_value);
304         Transfer(msg.sender, _to, _value, _data);
305         Transfer(msg.sender, _to, _value);
306         return true;
307     }
308 
309     // function that is called when transaction target is a contract
310     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
311         require(balanceOf[msg.sender] >= _value);
312         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
313         balanceOf[_to] = balanceOf[_to].add(_value);
314         ContractReceiver receiver = ContractReceiver(_to);
315         receiver.tokenFallback(msg.sender, _value, _data);
316         Transfer(msg.sender, _to, _value, _data);
317         Transfer(msg.sender, _to, _value);
318         return true;
319     }
320 
321 
322 
323     /**
324      * @dev Transfer tokens from one address to another
325      *      Added due to backwards compatibility with ERC20
326      * @param _from address The address which you want to send tokens from
327      * @param _to address The address which you want to transfer to
328      * @param _value uint256 the amount of tokens to be transferred
329      */
330     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
331         require(_to != address(0)
332                 && _value > 0
333                 && balanceOf[_from] >= _value
334                 && allowance[_from][msg.sender] >= _value
335                 && frozenAccount[_from] == false 
336                 && frozenAccount[_to] == false
337                 && now > unlockUnixTime[_from] 
338                 && now > unlockUnixTime[_to]);
339 
340         balanceOf[_from] = balanceOf[_from].sub(_value);
341         balanceOf[_to] = balanceOf[_to].add(_value);
342         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
343         Transfer(_from, _to, _value);
344         return true;
345     }
346 
347     /**
348      * @dev Allows _spender to spend no more than _value tokens in your behalf
349      *      Added due to backwards compatibility with ERC20
350      * @param _spender The address authorized to spend
351      * @param _value the max amount they can spend
352      */
353     function approve(address _spender, uint256 _value) public returns (bool success) {
354         allowance[msg.sender][_spender] = _value;
355         Approval(msg.sender, _spender, _value);
356         return true;
357     }
358 
359     /**
360      * @dev Function to check the amount of tokens that an owner allowed to a spender
361      *      Added due to backwards compatibility with ERC20
362      * @param _owner address The address which owns the funds
363      * @param _spender address The address which will spend the funds
364      */
365     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
366         return allowance[_owner][_spender];
367     }
368 
369 
370 
371     /**
372      * @dev Burns a specific amount of tokens.
373      * @param _from The address that will burn the tokens.
374      * @param _unitAmount The amount of token to be burned.
375      */
376     function burn(address _from, uint256 _unitAmount) onlyOwner public {
377         require(_unitAmount > 0
378                 && balanceOf[_from] >= _unitAmount);
379 
380         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
381         totalSupply = totalSupply.sub(_unitAmount);
382         Burn(_from, _unitAmount);
383     }
384 
385 
386     modifier canMint() {
387         require(!mintingFinished);
388         _;
389     }
390 
391     /**
392      * @dev Function to mint tokens
393      * @param _to The address that will receive the minted tokens.
394      * @param _unitAmount The amount of tokens to mint.
395      */
396     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
397         require(_unitAmount > 0);
398         
399         totalSupply = totalSupply.add(_unitAmount);
400         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
401         Mint(_to, _unitAmount);
402         Transfer(address(0), _to, _unitAmount);
403         return true;
404     }
405 
406     /**
407      * @dev Function to stop minting new tokens.
408      */
409     function finishMinting() onlyOwner canMint public returns (bool) {
410         mintingFinished = true;
411         MintFinished();
412         return true;
413     }
414 
415 
416 
417     /**
418      * @dev Function to distribute tokens to the list of addresses by the provided amount
419      */
420     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
421         require(amount > 0 
422                 && addresses.length > 0
423                 && frozenAccount[msg.sender] == false
424                 && now > unlockUnixTime[msg.sender]);
425 
426         amount = amount.mul(1e8);
427         uint256 totalAmount = amount.mul(addresses.length);
428         require(balanceOf[msg.sender] >= totalAmount);
429         
430         for (uint j = 0; j < addresses.length; j++) {
431             require(addresses[j] != 0x0
432                     && frozenAccount[addresses[j]] == false
433                     && now > unlockUnixTime[addresses[j]]);
434 
435             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
436             Transfer(msg.sender, addresses[j], amount);
437         }
438         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
439         return true;
440     }
441 
442     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
443         require(addresses.length > 0
444                 && addresses.length == amounts.length
445                 && frozenAccount[msg.sender] == false
446                 && now > unlockUnixTime[msg.sender]);
447                 
448         uint256 totalAmount = 0;
449         
450         for(uint j = 0; j < addresses.length; j++){
451             require(amounts[j] > 0
452                     && addresses[j] != 0x0
453                     && frozenAccount[addresses[j]] == false
454                     && now > unlockUnixTime[addresses[j]]);
455                     
456             amounts[j] = amounts[j].mul(1e8);
457             totalAmount = totalAmount.add(amounts[j]);
458         }
459         require(balanceOf[msg.sender] >= totalAmount);
460         
461         for (j = 0; j < addresses.length; j++) {
462             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
463             Transfer(msg.sender, addresses[j], amounts[j]);
464         }
465         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
466         return true;
467     }
468 
469     /**
470      * @dev Function to collect tokens from the list of addresses
471      */
472     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
473         require(addresses.length > 0
474                 && addresses.length == amounts.length);
475 
476         uint256 totalAmount = 0;
477         
478         for (uint j = 0; j < addresses.length; j++) {
479             require(amounts[j] > 0
480                     && addresses[j] != 0x0
481                     && frozenAccount[addresses[j]] == false
482                     && now > unlockUnixTime[addresses[j]]);
483                     
484             amounts[j] = amounts[j].mul(1e8);
485             require(balanceOf[addresses[j]] >= amounts[j]);
486             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
487             totalAmount = totalAmount.add(amounts[j]);
488             Transfer(addresses[j], msg.sender, amounts[j]);
489         }
490         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
491         return true;
492     }
493 
494 
495     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
496         distributeAmount = _unitAmount;
497     }
498     
499     /**
500      * @dev Function to distribute tokens to the msg.sender automatically
501      *      If distributeAmount is 0, this function doesn't work
502      */
503     function autoDistribute() payable public {
504         require(distributeAmount > 0
505                 && balanceOf[owner] >= distributeAmount
506                 && frozenAccount[msg.sender] == false
507                 && now > unlockUnixTime[msg.sender]);
508         if(msg.value > 0) owner.transfer(msg.value);
509         
510         balanceOf[owner] = balanceOf[owner].sub(distributeAmount);
511         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
512         Transfer(owner, msg.sender, distributeAmount);
513     }
514 
515     /**
516      * @dev fallback function
517      */
518     function() payable public {
519         autoDistribute();
520      }
521 
522 }
523 /**
524  *Copyright (c)2018 Tsuchinoko
525  *Copyright (c)2018 NANJ-COIN
526  *Released under the MIT license
527  *https://opensource.org/licenses/mit-license.php