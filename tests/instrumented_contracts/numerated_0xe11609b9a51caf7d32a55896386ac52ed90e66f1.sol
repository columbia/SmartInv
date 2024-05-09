1 pragma solidity ^0.4.24;
2 
3 //----------------------------------
4 //  COMIKETCOIN code
5 //  @author COMIKETCOIN engineers
6 //----------------------------------
7 
8 /**
9  * @title Ownable
10  * @dev The Ownable contract has an owner address, and provides basic authorization control
11  * functions, this simplifies the implementation of "user permissions".
12  */
13 contract Ownable {
14 
15     address public owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     /**
20     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21     * account.
22     */
23     function Ownable() public {
24         owner = msg.sender;
25     }
26 
27     /**
28     * @dev Throws if called by any account other than the owner.
29     */
30     modifier onlyOwner() {
31         require(msg.sender == owner);
32         _;
33     }
34 
35     /**
36     * @dev Allows the current owner to transfer control of the contract to a newOwner.
37     * @param newOwner The address to transfer ownership to.
38     */
39     function transferOwnership(address newOwner) onlyOwner public {
40         require(newOwner != address(0));
41         OwnershipTransferred(owner, newOwner);
42         owner = newOwner;
43     }
44 
45 }
46 
47 
48 /**
49  * @title SafeMath
50  * @dev Math operations with safety checks that throw on error
51  */
52 library SafeMath {
53 
54     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55         if (a == 0) {
56             return 0;
57         }
58         uint256 c = a * b;
59         assert(c / a == b);
60         return c;
61     }
62 
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         // assert(b > 0); // Solidity automatically throws when dividing by 0
65         uint256 c = a / b;
66         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
67         return c;
68     }
69 
70     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71         assert(b <= a);
72         return a - b;
73     }
74 
75     function add(uint256 a, uint256 b) internal pure returns (uint256) {
76         uint256 c = a + b;
77         assert(c >= a);
78         return c;
79     }
80 
81 }
82 
83 
84 /**
85  * @title ERC223
86  *
87  * https://github.com/Dexaran/ERC223-token-standard
88  */
89 contract ERC223 {
90 
91 	uint public totalSupply;
92 
93     // ERC223 and ERC20 functions and events
94     function balanceOf(address who) public view returns (uint);
95     function totalSupply() public view returns (uint256 _supply);
96     function transfer(address to, uint value) public returns (bool ok);
97     function transfer(address to, uint value, bytes data) public returns (bool ok);
98     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
99     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
100 
101     // ERC223 functions
102     function name() public view returns (string _name);
103     function symbol() public view returns (string _symbol);
104     function decimals() public view returns (uint8 _decimals);
105 
106     // ERC20 functions and events
107     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
108     function approve(address _spender, uint256 _value) public returns (bool success);
109     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
110     event Transfer(address indexed _from, address indexed _to, uint256 _value);
111     event Approval(address indexed _owner, address indexed _spender, uint _value);
112 
113 }
114 
115 
116 /*
117  * @title ContractReceiver
118  * Contract that is working with ERC223 tokens
119  */
120 contract ContractReceiver {
121 
122     struct TKN {
123         address sender;
124         uint value;
125         bytes data;
126         bytes4 sig;
127     }
128 
129 
130     function tokenFallback(address _from, uint _value, bytes _data) public pure {
131         TKN memory tkn;
132         tkn.sender = _from;
133         tkn.value = _value;
134         tkn.data = _data;
135         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
136         tkn.sig = bytes4(u);
137 
138         /* tkn variable is analogue of msg variable of Ether transaction
139          * tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
140          * tkn.value the number of tokens that were sent   (analogue of msg.value)
141          * tkn.data is data of token transaction   (analogue of msg.data)
142          * tkn.sig is 4 bytes signature of function
143          * if data of token transaction is a function execution
144          */
145     }
146 
147 }
148 
149 
150 /**
151  * @title COMIKETCOIN
152  *
153  */
154 contract COMIKETCOIN is ERC223, Ownable {
155 
156     using SafeMath for uint256;
157 
158     string public name = "COMIKETCOIN";
159     string public symbol = "CMIT";
160     uint8 public decimals = 8;
161     uint256 public totalSupply = 50e9 * 1e8;
162     uint256 public distributeAmount = 0;
163     bool public mintingFinished = false;
164 
165     address public ownerCMIT  = 0x479865BE7aC1034bA10190Fcb9561649672E2922;
166     address public Drop       = 0xcA5C301245f2781C2C4304426Ab682d9744F7eB6;
167     address public List       = 0xe4f63D6BB66185Ac6C557DF63C12eDDcfc58c8e8;
168     address public Develop    = 0x6b7fD1eE38D01eF65D9555Ea879d12d9eF7fc64F;
169     address public Contents   = 0x31808F7aa2701a0Ba844D1Ab5319F6097Ea973fe;
170     address public Marketing  = 0x7342B2df961B50C8fa60dee208d036579EcB5B90;
171 
172     mapping (address => uint256) public balanceOf;
173     mapping (address => mapping (address => uint256)) public allowance;
174     mapping (address => bool) public frozenAccount;
175     mapping (address => uint256) public unlockUnixTime;
176 
177     event FrozenFunds(address indexed target, bool frozen);
178     event LockedFunds(address indexed target, uint256 locked);
179     event Burn(address indexed from, uint256 amount);
180     event Mint(address indexed to, uint256 amount);
181     event MintFinished();
182 
183     //@dev This function is called only once.
184     function COMIKETCOIN() public {
185 
186         owner = ownerCMIT;
187 
188         balanceOf[ownerCMIT] = totalSupply.mul(10).div(100);
189         balanceOf[Drop] = totalSupply.mul(10).div(100);
190         balanceOf[List] = totalSupply.mul(30).div(100);
191         balanceOf[Develop] = totalSupply.mul(25).div(100);
192         balanceOf[Contents] = totalSupply.mul(10).div(100);
193         balanceOf[Marketing] = totalSupply.mul(15).div(100);
194 
195     }
196 
197     function name() public view returns (string _name) {
198         return name;
199     }
200 
201     function symbol() public view returns (string _symbol) {
202         return symbol;
203     }
204 
205     function decimals() public view returns (uint8 _decimals) {
206         return decimals;
207     }
208 
209     function totalSupply() public view returns (uint256 _totalSupply) {
210         return totalSupply;
211     }
212 
213     function balanceOf(address _owner) public view returns (uint256 balance) {
214         return balanceOf[_owner];
215     }
216 
217     /**
218      * @dev Prevent targets from sending or receiving tokens
219      * @param targets Addresses to be frozen
220      * @param isFrozen either to freeze it or not
221      */
222     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
223         require(targets.length > 0);
224         for (uint j = 0; j < targets.length; j++) {
225             require(targets[j] != 0x0);
226             frozenAccount[targets[j]] = isFrozen;
227             FrozenFunds(targets[j], isFrozen);
228         }
229     }
230 
231     /**
232      * @dev Prevent targets from sending or receiving tokens by setting Unix times
233      * @param targets Addresses to be locked funds
234      * @param unixTimes Unix times when locking up will be finished
235      */
236     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
237         require(targets.length > 0 && targets.length == unixTimes.length);
238         for(uint j = 0; j < targets.length; j++){
239             require(unlockUnixTime[targets[j]] < unixTimes[j]);
240             unlockUnixTime[targets[j]] = unixTimes[j];
241             LockedFunds(targets[j], unixTimes[j]);
242         }
243     }
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
254         if (isContract(_to)) {
255             require(balanceOf[msg.sender] >= _value);
256             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
257             balanceOf[_to] = balanceOf[_to].add(_value);
258             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
259             Transfer(msg.sender, _to, _value, _data);
260             Transfer(msg.sender, _to, _value);
261             return true;
262         } else {
263             return transferToAddress(_to, _value, _data);
264         }
265     }
266 
267     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
268         require(_value > 0
269                 && frozenAccount[msg.sender] == false
270                 && frozenAccount[_to] == false
271                 && now > unlockUnixTime[msg.sender]
272                 && now > unlockUnixTime[_to]);
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
330     /**
331      * @dev Transfer tokens from one address to another
332      *      Added due to backwards compatibility with ERC20
333      * @param _from address The address which you want to send tokens from
334      * @param _to address The address which you want to transfer to
335      * @param _value uint256 the amount of tokens to be transferred
336      */
337     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
338         require(_to != address(0)
339                 && _value > 0
340                 && balanceOf[_from] >= _value
341                 && allowance[_from][msg.sender] >= _value
342                 && frozenAccount[_from] == false
343                 && frozenAccount[_to] == false
344                 && now > unlockUnixTime[_from]
345                 && now > unlockUnixTime[_to]);
346 
347         balanceOf[_from] = balanceOf[_from].sub(_value);
348         balanceOf[_to] = balanceOf[_to].add(_value);
349         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
350         Transfer(_from, _to, _value);
351         return true;
352     }
353 
354     /**
355      * @dev Allows _spender to spend no more than _value tokens in your behalf
356      *      Added due to backwards compatibility with ERC20
357      * @param _spender The address authorized to spend
358      * @param _value the max amount they can spend
359      */
360     function approve(address _spender, uint256 _value) public returns (bool success) {
361         allowance[msg.sender][_spender] = _value;
362         Approval(msg.sender, _spender, _value);
363         return true;
364     }
365 
366     /**
367      * @dev Function to check the amount of tokens that an owner allowed to a spender
368      *      Added due to backwards compatibility with ERC20
369      * @param _owner address The address which owns the funds
370      * @param _spender address The address which will spend the funds
371      */
372     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
373         return allowance[_owner][_spender];
374     }
375 
376     /**
377      * @dev Burns a specific amount of tokens.
378      * @param _from The address that will burn the tokens.
379      * @param _unitAmount The amount of token to be burned.
380      */
381     function burn(address _from, uint256 _unitAmount) onlyOwner public {
382         require(_unitAmount > 0
383                 && balanceOf[_from] >= _unitAmount);
384 
385         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
386         totalSupply = totalSupply.sub(_unitAmount);
387         Burn(_from, _unitAmount);
388     }
389 
390     modifier canMint() {
391         require(!mintingFinished);
392         _;
393     }
394 
395     /**
396      * @dev Function to mint tokens
397      * @param _to The address that will receive the minted tokens.
398      * @param _unitAmount The amount of tokens to mint.
399      */
400     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
401         require(_unitAmount > 0);
402 
403         totalSupply = totalSupply.add(_unitAmount);
404         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
405         Mint(_to, _unitAmount);
406         Transfer(address(0), _to, _unitAmount);
407         return true;
408     }
409 
410     /**
411      * @dev Function to stop minting new tokens.
412      */
413     function finishMinting() onlyOwner canMint public returns (bool) {
414         mintingFinished = true;
415         MintFinished();
416         return true;
417     }
418 
419     /**
420      * @dev Distribute COMIKETCOIN to multiple addresses.
421      */
422     function distributeCOMIKETCOIN(address[] addresses, uint256 amount) public returns (bool) {
423         require(amount > 0
424                 && addresses.length > 0
425                 && frozenAccount[msg.sender] == false
426                 && now > unlockUnixTime[msg.sender]);
427 
428         amount = amount.mul(1e8);
429         uint256 totalAmount = amount.mul(addresses.length);
430         require(balanceOf[msg.sender] >= totalAmount);
431 
432         for (uint j = 0; j < addresses.length; j++) {
433             require(addresses[j] != 0x0
434                     && frozenAccount[addresses[j]] == false
435                     && now > unlockUnixTime[addresses[j]]);
436 
437             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
438             Transfer(msg.sender, addresses[j], amount);
439         }
440         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
441         return true;
442     }
443 
444     /**
445      * @dev Function to collect tokens from the list of addresses
446      */
447     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
448         require(addresses.length > 0
449                 && addresses.length == amounts.length);
450 
451         uint256 totalAmount = 0;
452 
453         for (uint j = 0; j < addresses.length; j++) {
454             require(amounts[j] > 0
455                     && addresses[j] != 0x0
456                     && frozenAccount[addresses[j]] == false
457                     && now > unlockUnixTime[addresses[j]]);
458 
459             amounts[j] = amounts[j].mul(1e8);
460             require(balanceOf[addresses[j]] >= amounts[j]);
461             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
462             totalAmount = totalAmount.add(amounts[j]);
463             Transfer(addresses[j], msg.sender, amounts[j]);
464         }
465         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
466         return true;
467     }
468 
469     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
470         distributeAmount = _unitAmount;
471     }
472 
473     /**
474      * @dev Function to distribute tokens to the msg.sender automatically
475      *      If distributeAmount is 0, this function doesn't work
476      */
477     function autoDistribute() payable public {
478         require(distributeAmount > 0
479                 && balanceOf[ownerCMIT] >= distributeAmount
480                 && frozenAccount[msg.sender] == false
481                 && now > unlockUnixTime[msg.sender]);
482         if(msg.value > 0) ownerCMIT.transfer(msg.value);
483 
484         balanceOf[ownerCMIT] = balanceOf[ownerCMIT].sub(distributeAmount);
485         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
486         Transfer(ownerCMIT, msg.sender, distributeAmount);
487     }
488 
489     /**
490      * @dev token fallback function
491      */
492     function() payable public {
493         autoDistribute();
494     }
495 
496 }
497 /* EOF */