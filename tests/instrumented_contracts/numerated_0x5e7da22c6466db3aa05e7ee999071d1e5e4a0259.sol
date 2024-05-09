1 pragma solidity ^0.4.18;
2 
3 
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         if (a == 0) {
13             return 0;
14         }
15         uint256 c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19 
20     function div(uint256 a, uint256 b) internal pure returns (uint256) {
21         // assert(b > 0); // Solidity automatically throws when dividing by 0
22         uint256 c = a / b;
23         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24         return c;
25     }
26 
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         assert(b <= a);
29         return a - b;
30     }
31 
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         assert(c >= a);
35         return c;
36     }
37 }
38 
39 
40 
41 /**
42  * @title Ownable
43  * @dev The Ownable contract has an owner address, and provides basic authorization
44  *      control functions, this simplifies the implementation of "user permissions".
45  */
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
81  * 彡(^)(^)
82  * @title ERC223
83  * @dev ERC223 contract interface with ERC20 functions and events
84  *      Fully backward compatible with ERC20
85  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
86  */
87 contract ERC223 {
88     uint public totalSupply;
89 
90     // ERC223 and ERC20 functions and events
91     function balanceOf(address who) public view returns (uint);
92     function totalSupply() public view returns (uint256 _supply);
93     function transfer(address to, uint value) public returns (bool ok);
94     function transfer(address to, uint value, bytes data) public returns (bool ok);
95     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
96     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
97 
98     // ERC223 functions
99     function name() public view returns (string _name);
100     function symbol() public view returns (string _symbol);
101     function decimals() public view returns (uint8 _decimals);
102 
103     // ERC20 functions and events
104     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
105     function approve(address _spender, uint256 _value) public returns (bool success);
106     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
107     event Transfer(address indexed _from, address indexed _to, uint256 _value);
108     event Approval(address indexed _owner, address indexed _spender, uint _value);
109 }
110 
111 
112 
113 /**
114  * @title ContractReceiver
115  * @dev Contract that is working with ERC223 tokens
116  */
117  contract ContractReceiver {
118 
119     struct TKN {
120         address sender;
121         uint value;
122         bytes data;
123         bytes4 sig;
124     }
125 
126     function tokenFallback(address _from, uint _value, bytes _data) public pure {
127         TKN memory tkn;
128         tkn.sender = _from;
129         tkn.value = _value;
130         tkn.data = _data;
131         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
132         tkn.sig = bytes4(u);
133         
134         /*
135          * tkn variable is analogue of msg variable of Ether transaction
136          * tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
137          * tkn.value the number of tokens that were sent   (analogue of msg.value)
138          * tkn.data is data of token transaction   (analogue of msg.data)
139          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
140          */
141     }
142 }
143 
144 
145 
146 /**
147  * 彡(ﾟ)(ﾟ)
148  * @title YumeGorilla
149  * @author YumeGorilla
150  * @dev YumeGorilla is an ERC223 Token with ERC20 functions and events
151  *      Fully backward compatible with ERC20
152  */
153 contract YumeGorilla is ERC223, Ownable {
154     using SafeMath for uint256;
155 
156     string public name = "YumeGorilla";
157     string public symbol = "YMG";
158     uint8 public decimals = 8;
159     uint256 public totalSupply = 877e8 * 1e8;
160     uint256 public distributeAmount = 0;
161     bool public mintingFinished = false;
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
178     function YumeGorilla() public {
179         balanceOf[msg.sender] = totalSupply;
180     }
181 
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
203 
204     /**
205      * @dev Prevent targets from sending or receiving tokens
206      * @param targets Addresses to be frozen
207      * @param isFrozen either to freeze it or not
208      */
209     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
210         require(targets.length > 0);
211 
212         for (uint j = 0; j < targets.length; j++) {
213             require(targets[j] != 0x0);
214             frozenAccount[targets[j]] = isFrozen;
215             FrozenFunds(targets[j], isFrozen);
216         }
217     }
218 
219     /**
220      * @dev Prevent targets from sending or receiving tokens by setting Unix times
221      * @param targets Addresses to be locked funds
222      * @param unixTimes Unix times when locking up will be finished
223      */
224     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
225         require(targets.length > 0
226                 && targets.length == unixTimes.length);
227                 
228         for(uint j = 0; j < targets.length; j++){
229             require(unlockUnixTime[targets[j]] < unixTimes[j]);
230             unlockUnixTime[targets[j]] = unixTimes[j];
231             LockedFunds(targets[j], unixTimes[j]);
232         }
233     }
234 
235 
236     /**
237      * @dev Function that is called when a user or another contract wants to transfer funds
238      */
239     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
240         require(_value > 0
241                 && frozenAccount[msg.sender] == false 
242                 && frozenAccount[_to] == false
243                 && now > unlockUnixTime[msg.sender] 
244                 && now > unlockUnixTime[_to]);
245 
246         if (isContract(_to)) {
247             require(balanceOf[msg.sender] >= _value);
248             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
249             balanceOf[_to] = balanceOf[_to].add(_value);
250             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
251             Transfer(msg.sender, _to, _value, _data);
252             Transfer(msg.sender, _to, _value);
253             return true;
254         } else {
255             return transferToAddress(_to, _value, _data);
256         }
257     }
258 
259     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
260         require(_value > 0
261                 && frozenAccount[msg.sender] == false 
262                 && frozenAccount[_to] == false
263                 && now > unlockUnixTime[msg.sender] 
264                 && now > unlockUnixTime[_to]);
265 
266         if (isContract(_to)) {
267             return transferToContract(_to, _value, _data);
268         } else {
269             return transferToAddress(_to, _value, _data);
270         }
271     }
272 
273     /**
274      * @dev Standard function transfer similar to ERC20 transfer with no _data
275      *      Added due to backwards compatibility reasons
276      */
277     function transfer(address _to, uint _value) public returns (bool success) {
278         require(_value > 0
279                 && frozenAccount[msg.sender] == false 
280                 && frozenAccount[_to] == false
281                 && now > unlockUnixTime[msg.sender] 
282                 && now > unlockUnixTime[_to]);
283 
284         bytes memory empty;
285         if (isContract(_to)) {
286             return transferToContract(_to, _value, empty);
287         } else {
288             return transferToAddress(_to, _value, empty);
289         }
290     }
291 
292     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
293     function isContract(address _addr) private view returns (bool is_contract) {
294         uint length;
295         assembly {
296             //retrieve the size of the code on target address, this needs assembly
297             length := extcodesize(_addr)
298         }
299         return (length > 0);
300     }
301 
302     // function that is called when transaction target is an address
303     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
304         require(balanceOf[msg.sender] >= _value);
305         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
306         balanceOf[_to] = balanceOf[_to].add(_value);
307         Transfer(msg.sender, _to, _value, _data);
308         Transfer(msg.sender, _to, _value);
309         return true;
310     }
311 
312     // function that is called when transaction target is a contract
313     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
314         require(balanceOf[msg.sender] >= _value);
315         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
316         balanceOf[_to] = balanceOf[_to].add(_value);
317         ContractReceiver receiver = ContractReceiver(_to);
318         receiver.tokenFallback(msg.sender, _value, _data);
319         Transfer(msg.sender, _to, _value, _data);
320         Transfer(msg.sender, _to, _value);
321         return true;
322     }
323 
324 
325 
326     /**
327      * @dev Transfer tokens from one address to another
328      *      Added due to backwards compatibility with ERC20
329      * @param _from address The address which you want to send tokens from
330      * @param _to address The address which you want to transfer to
331      * @param _value uint256 the amount of tokens to be transferred
332      */
333     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
334         require(_to != address(0)
335                 && _value > 0
336                 && balanceOf[_from] >= _value
337                 && allowance[_from][msg.sender] >= _value
338                 && frozenAccount[_from] == false 
339                 && frozenAccount[_to] == false
340                 && now > unlockUnixTime[_from] 
341                 && now > unlockUnixTime[_to]);
342 
343         balanceOf[_from] = balanceOf[_from].sub(_value);
344         balanceOf[_to] = balanceOf[_to].add(_value);
345         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
346         Transfer(_from, _to, _value);
347         return true;
348     }
349 
350     /**
351      * @dev Allows _spender to spend no more than _value tokens in your behalf
352      *      Added due to backwards compatibility with ERC20
353      * @param _spender The address authorized to spend
354      * @param _value the max amount they can spend
355      */
356     function approve(address _spender, uint256 _value) public returns (bool success) {
357         allowance[msg.sender][_spender] = _value;
358         Approval(msg.sender, _spender, _value);
359         return true;
360     }
361 
362     /**
363      * @dev Function to check the amount of tokens that an owner allowed to a spender
364      *      Added due to backwards compatibility with ERC20
365      * @param _owner address The address which owns the funds
366      * @param _spender address The address which will spend the funds
367      */
368     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
369         return allowance[_owner][_spender];
370     }
371 
372 
373 
374     /**
375      * @dev Burns a specific amount of tokens.
376      * @param _from The address that will burn the tokens.
377      * @param _unitAmount The amount of token to be burned.
378      */
379     function burn(address _from, uint256 _unitAmount) onlyOwner public {
380         require(_unitAmount > 0
381                 && balanceOf[_from] >= _unitAmount);
382 
383         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
384         totalSupply = totalSupply.sub(_unitAmount);
385         Burn(_from, _unitAmount);
386     }
387 
388 
389     modifier canMint() {
390         require(!mintingFinished);
391         _;
392     }
393 
394     /**
395      * @dev Function to mint tokens
396      * @param _to The address that will receive the minted tokens.
397      * @param _unitAmount The amount of tokens to mint.
398      */
399     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
400         require(_unitAmount > 0);
401         
402         totalSupply = totalSupply.add(_unitAmount);
403         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
404         Mint(_to, _unitAmount);
405         Transfer(address(0), _to, _unitAmount);
406         return true;
407     }
408 
409     /**
410      * @dev Function to stop minting new tokens.
411      */
412     function finishMinting() onlyOwner canMint public returns (bool) {
413         mintingFinished = true;
414         MintFinished();
415         return true;
416     }
417 
418 
419 
420     /**
421      * @dev Function to distribute tokens to the list of addresses by the provided amount
422      */
423     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
424         require(amount > 0 
425                 && addresses.length > 0
426                 && frozenAccount[msg.sender] == false
427                 && now > unlockUnixTime[msg.sender]);
428 
429         amount = amount.mul(1e8);
430         uint256 totalAmount = amount.mul(addresses.length);
431         require(balanceOf[msg.sender] >= totalAmount);
432         
433         for (uint j = 0; j < addresses.length; j++) {
434             require(addresses[j] != 0x0
435                     && frozenAccount[addresses[j]] == false
436                     && now > unlockUnixTime[addresses[j]]);
437 
438             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
439             Transfer(msg.sender, addresses[j], amount);
440         }
441         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
442         return true;
443     }
444 
445     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
446         require(addresses.length > 0
447                 && addresses.length == amounts.length
448                 && frozenAccount[msg.sender] == false
449                 && now > unlockUnixTime[msg.sender]);
450                 
451         uint256 totalAmount = 0;
452         
453         for(uint j = 0; j < addresses.length; j++){
454             require(amounts[j] > 0
455                     && addresses[j] != 0x0
456                     && frozenAccount[addresses[j]] == false
457                     && now > unlockUnixTime[addresses[j]]);
458                     
459             amounts[j] = amounts[j].mul(1e8);
460             totalAmount = totalAmount.add(amounts[j]);
461         }
462         require(balanceOf[msg.sender] >= totalAmount);
463         
464         for (j = 0; j < addresses.length; j++) {
465             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
466             Transfer(msg.sender, addresses[j], amounts[j]);
467         }
468         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
469         return true;
470     }
471 
472     /**
473      * @dev Function to collect tokens from the list of addresses
474      */
475     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
476         require(addresses.length > 0
477                 && addresses.length == amounts.length);
478 
479         uint256 totalAmount = 0;
480         
481         for (uint j = 0; j < addresses.length; j++) {
482             require(amounts[j] > 0
483                     && addresses[j] != 0x0
484                     && frozenAccount[addresses[j]] == false
485                     && now > unlockUnixTime[addresses[j]]);
486                     
487             amounts[j] = amounts[j].mul(1e8);
488             require(balanceOf[addresses[j]] >= amounts[j]);
489             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
490             totalAmount = totalAmount.add(amounts[j]);
491             Transfer(addresses[j], msg.sender, amounts[j]);
492         }
493         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
494         return true;
495     }
496 
497 
498     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
499         distributeAmount = _unitAmount;
500     }
501     
502     /**
503      * @dev Function to distribute tokens to the msg.sender automatically
504      *      If distributeAmount is 0, this function doesn't work
505      */
506     function autoDistribute() payable public {
507         require(distributeAmount > 0
508                 && balanceOf[owner] >= distributeAmount
509                 && frozenAccount[msg.sender] == false
510                 && now > unlockUnixTime[msg.sender]);
511         if(msg.value > 0) owner.transfer(msg.value);
512         
513         balanceOf[owner] = balanceOf[owner].sub(distributeAmount);
514         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
515         Transfer(owner, msg.sender, distributeAmount);
516     }
517 
518     /**
519      * @dev fallback function
520      */
521     function() payable public {
522         autoDistribute();
523      }
524 
525 }