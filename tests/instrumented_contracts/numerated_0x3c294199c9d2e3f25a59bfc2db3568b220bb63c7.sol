1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8  
9 library SafeMath {
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11         if (a == 0) {
12             return 0;
13         }
14         uint256 c = a * b;
15         assert(c / a == b);
16         return c;
17     }
18 
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         // assert(b > 0); // Solidity automatically throws when dividing by 0
21         uint256 c = a / b;
22         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23         return c;
24     }
25 
26     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27         assert(b <= a);
28         return a - b;
29     }
30 
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         assert(c >= a);
34         return c;
35     }
36 }
37 
38 
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization
43  *      control functions, this simplifies the implementation of "user permissions".
44  */
45  
46 contract Ownable {
47     address public owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev The Ownable constructor sets the original `owner` of the contract to the
53      *      sender account.
54      */
55     function Ownable() public {
56         owner = msg.sender;
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(msg.sender == owner);
64         _;
65     }
66 
67     /**
68      * @dev Allows the current owner to transfer control of the contract to a newOwner.
69      * @param newOwner The address to transfer ownership to.
70      */
71     function transferOwnership(address newOwner) onlyOwner public {
72         require(newOwner != address(0));
73         OwnershipTransferred(owner, newOwner);
74         owner = newOwner;
75     }
76 }
77 
78 
79 
80 /**
81  * 
82  * @title ERC223
83  * @dev ERC223 contract interface with ERC20 functions and events
84  *      Fully backward compatible with ERC20
85  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
86  */
87  
88 contract ERC223 {
89     uint public totalSupply;
90 
91     // ERC223 and ERC20 functions and events
92     function balanceOf(address who) public view returns (uint);
93     function totalSupply() public view returns (uint256 _supply);
94     function transfer(address to, uint value) public returns (bool ok);
95     function transfer(address to, uint value, bytes data) public returns (bool ok);
96     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
97     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
98 
99     // ERC223 functions
100     function name() public view returns (string _name);
101     function symbol() public view returns (string _symbol);
102     function decimals() public view returns (uint8 _decimals);
103 
104     // ERC20 functions and events
105     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
106     function approve(address _spender, uint256 _value) public returns (bool success);
107     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
108     event Transfer(address indexed _from, address indexed _to, uint256 _value);
109     event Approval(address indexed _owner, address indexed _spender, uint _value);
110 }
111 
112 
113 
114 /**
115  * @title ContractReceiver
116  * @dev Contract that is working with ERC223 tokens
117  */
118  contract ContractReceiver {
119 
120     struct TKN {
121         address sender;
122         uint value;
123         bytes data;
124         bytes4 sig;
125     }
126 
127     function tokenFallback(address _from, uint _value, bytes _data) public pure {
128         TKN memory tkn;
129         tkn.sender = _from;
130         tkn.value = _value;
131         tkn.data = _data;
132         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
133         tkn.sig = bytes4(u);
134         
135         /*
136          * tkn variable is analogue of msg variable of Ether transaction
137          * tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
138          * tkn.value the number of tokens that were sent   (analogue of msg.value)
139          * tkn.data is data of token transaction   (analogue of msg.data)
140          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
141          */
142     }
143 }
144 
145 
146 
147  
148 contract Zeinun is ERC223, Ownable {
149     using SafeMath for uint256;
150 
151     string public name = "Zeinun";
152     string public symbol = "ZNN";
153     string public constant AAcontributors = "Zeinun Token";
154     uint8 public decimals = 8;
155     uint256 public totalSupply = 97e5 * 1e7;
156     uint256 public distributeAmount = 0;
157     bool public mintingFinished = false;
158     
159     address public founder = 0x97F0AbcC844C21f39582768c345D8d139415d11f;
160     address public preSeasonGame = 0x97F0AbcC844C21f39582768c345D8d139415d11f;
161     address public activityFunds = 0x97F0AbcC844C21f39582768c345D8d139415d11f;
162     address public lockedFundsForthefuture = 0x97F0AbcC844C21f39582768c345D8d139415d11f;
163 
164     mapping(address => uint256) public balanceOf;
165     mapping(address => mapping (address => uint256)) public allowance;
166     mapping (address => bool) public frozenAccount;
167     mapping (address => uint256) public unlockUnixTime;
168     
169     event FrozenFunds(address indexed target, bool frozen);
170     event LockedFunds(address indexed target, uint256 locked);
171     event Burn(address indexed from, uint256 amount);
172     event Mint(address indexed to, uint256 amount);
173     event MintFinished();
174 
175 
176     /** 
177      * @dev Constructor is called only once and can not be called again
178      */
179     function Zeinun() public {
180         owner = activityFunds;
181         
182         balanceOf[founder] = totalSupply.mul(25).div(100);
183         balanceOf[preSeasonGame] = totalSupply.mul(55).div(100);
184         balanceOf[activityFunds] = totalSupply.mul(10).div(100);
185         balanceOf[lockedFundsForthefuture] = totalSupply.mul(10).div(100);
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
210     /**
211      * @dev Prevent targets from sending or receiving tokens
212      * @param targets Addresses to be frozen
213      * @param isFrozen either to freeze it or not
214      */
215     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
216         require(targets.length > 0);
217 
218         for (uint j = 0; j < targets.length; j++) {
219             require(targets[j] != 0x0);
220             frozenAccount[targets[j]] = isFrozen;
221             FrozenFunds(targets[j], isFrozen);
222         }
223     }
224 
225     /**
226      * @dev Prevent targets from sending or receiving tokens by setting Unix times
227      * @param targets Addresses to be locked funds
228      * @param unixTimes Unix times when locking up will be finished
229      */
230     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
231         require(targets.length > 0
232                 && targets.length == unixTimes.length);
233                 
234         for(uint j = 0; j < targets.length; j++){
235             require(unlockUnixTime[targets[j]] < unixTimes[j]);
236             unlockUnixTime[targets[j]] = unixTimes[j];
237             LockedFunds(targets[j], unixTimes[j]);
238         }
239     }
240 
241 
242     /**
243      * @dev Function that is called when a user or another contract wants to transfer funds
244      */
245     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
246         require(_value > 0
247                 && frozenAccount[msg.sender] == false 
248                 && frozenAccount[_to] == false
249                 && now > unlockUnixTime[msg.sender] 
250                 && now > unlockUnixTime[_to]);
251 
252         if (isContract(_to)) {
253             require(balanceOf[msg.sender] >= _value);
254             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
255             balanceOf[_to] = balanceOf[_to].add(_value);
256             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
257             Transfer(msg.sender, _to, _value, _data);
258             Transfer(msg.sender, _to, _value);
259             return true;
260         } else {
261             return transferToAddress(_to, _value, _data);
262         }
263     }
264 
265     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
266         require(_value > 0
267                 && frozenAccount[msg.sender] == false 
268                 && frozenAccount[_to] == false
269                 && now > unlockUnixTime[msg.sender] 
270                 && now > unlockUnixTime[_to]);
271 
272         if (isContract(_to)) {
273             return transferToContract(_to, _value, _data);
274         } else {
275             return transferToAddress(_to, _value, _data);
276         }
277     }
278 
279     /**
280      * @dev Standard function transfer similar to ERC20 transfer with no _data
281      *      Added due to backwards compatibility reasons
282      */
283     function transfer(address _to, uint _value) public returns (bool success) {
284         require(_value > 0
285                 && frozenAccount[msg.sender] == false 
286                 && frozenAccount[_to] == false
287                 && now > unlockUnixTime[msg.sender] 
288                 && now > unlockUnixTime[_to]);
289 
290         bytes memory empty;
291         if (isContract(_to)) {
292             return transferToContract(_to, _value, empty);
293         } else {
294             return transferToAddress(_to, _value, empty);
295         }
296     }
297 
298     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
299     function isContract(address _addr) private view returns (bool is_contract) {
300         uint length;
301         assembly {
302             //retrieve the size of the code on target address, this needs assembly
303             length := extcodesize(_addr)
304         }
305         return (length > 0);
306     }
307 
308     // function that is called when transaction target is an address
309     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
310         require(balanceOf[msg.sender] >= _value);
311         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
312         balanceOf[_to] = balanceOf[_to].add(_value);
313         Transfer(msg.sender, _to, _value, _data);
314         Transfer(msg.sender, _to, _value);
315         return true;
316     }
317 
318     // function that is called when transaction target is a contract
319     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
320         require(balanceOf[msg.sender] >= _value);
321         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
322         balanceOf[_to] = balanceOf[_to].add(_value);
323         ContractReceiver receiver = ContractReceiver(_to);
324         receiver.tokenFallback(msg.sender, _value, _data);
325         Transfer(msg.sender, _to, _value, _data);
326         Transfer(msg.sender, _to, _value);
327         return true;
328     }
329 
330 
331 
332     /**
333      * @dev Transfer tokens from one address to another
334      *      Added due to backwards compatibility with ERC20
335      * @param _from address The address which you want to send tokens from
336      * @param _to address The address which you want to transfer to
337      * @param _value uint256 the amount of tokens to be transferred
338      */
339     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
340         require(_to != address(0)
341                 && _value > 0
342                 && balanceOf[_from] >= _value
343                 && allowance[_from][msg.sender] >= _value
344                 && frozenAccount[_from] == false 
345                 && frozenAccount[_to] == false
346                 && now > unlockUnixTime[_from] 
347                 && now > unlockUnixTime[_to]);
348 
349         balanceOf[_from] = balanceOf[_from].sub(_value);
350         balanceOf[_to] = balanceOf[_to].add(_value);
351         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
352         Transfer(_from, _to, _value);
353         return true;
354     }
355 
356     /**
357      * @dev Allows _spender to spend no more than _value tokens in your behalf
358      *      Added due to backwards compatibility with ERC20
359      * @param _spender The address authorized to spend
360      * @param _value the max amount they can spend
361      */
362     function approve(address _spender, uint256 _value) public returns (bool success) {
363         allowance[msg.sender][_spender] = _value;
364         Approval(msg.sender, _spender, _value);
365         return true;
366     }
367 
368     /**
369      * @dev Function to check the amount of tokens that an owner allowed to a spender
370      *      Added due to backwards compatibility with ERC20
371      * @param _owner address The address which owns the funds
372      * @param _spender address The address which will spend the funds
373      */
374     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
375         return allowance[_owner][_spender];
376     }
377 
378 
379 
380     /**
381      * @dev Burns a specific amount of tokens.
382      * @param _from The address that will burn the tokens.
383      * @param _unitAmount The amount of token to be burned.
384      */
385     function burn(address _from, uint256 _unitAmount) onlyOwner public {
386         require(_unitAmount > 0
387                 && balanceOf[_from] >= _unitAmount);
388 
389         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
390         totalSupply = totalSupply.sub(_unitAmount);
391         Burn(_from, _unitAmount);
392     }
393 
394 
395     modifier canMint() {
396         require(!mintingFinished);
397         _;
398     }
399 
400     /**
401      * @dev Function to mint tokens
402      * @param _to The address that will receive the minted tokens.
403      * @param _unitAmount The amount of tokens to mint.
404      */
405     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
406         require(_unitAmount > 0);
407         
408         totalSupply = totalSupply.add(_unitAmount);
409         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
410         Mint(_to, _unitAmount);
411         Transfer(address(0), _to, _unitAmount);
412         return true;
413     }
414 
415     /**
416      * @dev Function to stop minting new tokens.
417      */
418     function finishMinting() onlyOwner canMint public returns (bool) {
419         mintingFinished = true;
420         MintFinished();
421         return true;
422     }
423 
424 
425 
426     /**
427      * @dev Function to distribute tokens to the list of addresses by the provided amount
428      */
429     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
430         require(amount > 0 
431                 && addresses.length > 0
432                 && frozenAccount[msg.sender] == false
433                 && now > unlockUnixTime[msg.sender]);
434 
435         amount = amount.mul(1e8);
436         uint256 totalAmount = amount.mul(addresses.length);
437         require(balanceOf[msg.sender] >= totalAmount);
438         
439         for (uint j = 0; j < addresses.length; j++) {
440             require(addresses[j] != 0x0
441                     && frozenAccount[addresses[j]] == false
442                     && now > unlockUnixTime[addresses[j]]);
443 
444             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
445             Transfer(msg.sender, addresses[j], amount);
446         }
447         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
448         return true;
449     }
450 
451     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
452         require(addresses.length > 0
453                 && addresses.length == amounts.length
454                 && frozenAccount[msg.sender] == false
455                 && now > unlockUnixTime[msg.sender]);
456                 
457         uint256 totalAmount = 0;
458         
459         for(uint j = 0; j < addresses.length; j++){
460             require(amounts[j] > 0
461                     && addresses[j] != 0x0
462                     && frozenAccount[addresses[j]] == false
463                     && now > unlockUnixTime[addresses[j]]);
464                     
465             amounts[j] = amounts[j].mul(1e8);
466             totalAmount = totalAmount.add(amounts[j]);
467         }
468         require(balanceOf[msg.sender] >= totalAmount);
469         
470         for (j = 0; j < addresses.length; j++) {
471             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
472             Transfer(msg.sender, addresses[j], amounts[j]);
473         }
474         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
475         return true;
476     }
477 
478     /**
479      * @dev Function to collect tokens from the list of addresses
480      */
481     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
482         require(addresses.length > 0
483                 && addresses.length == amounts.length);
484 
485         uint256 totalAmount = 0;
486         
487         for (uint j = 0; j < addresses.length; j++) {
488             require(amounts[j] > 0
489                     && addresses[j] != 0x0
490                     && frozenAccount[addresses[j]] == false
491                     && now > unlockUnixTime[addresses[j]]);
492                     
493             amounts[j] = amounts[j].mul(1e8);
494             require(balanceOf[addresses[j]] >= amounts[j]);
495             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
496             totalAmount = totalAmount.add(amounts[j]);
497             Transfer(addresses[j], msg.sender, amounts[j]);
498         }
499         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
500         return true;
501     }
502 
503 
504     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
505         distributeAmount = _unitAmount;
506     }
507     
508     /**
509      * @dev Function to distribute tokens to the msg.sender automatically
510      *      If distributeAmount is 0, this function doesn't work
511      */
512     function autoDistribute() payable public {
513         require(distributeAmount > 0
514                 && balanceOf[activityFunds] >= distributeAmount
515                 && frozenAccount[msg.sender] == false
516                 && now > unlockUnixTime[msg.sender]);
517         if(msg.value > 0) activityFunds.transfer(msg.value);
518         
519         balanceOf[activityFunds] = balanceOf[activityFunds].sub(distributeAmount);
520         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
521         Transfer(activityFunds, msg.sender, distributeAmount);
522     }
523 
524     /**
525      * @dev fallback function
526      */
527     function() payable public {
528         autoDistribute();
529      }
530 
531 }