1 pragma solidity ^0.4.18;
2 
3 
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
141 /**
142  * @title ARTS
143  * @author ARTS
144  * @dev ARTS is an ERC223 Token with ERC20 functions and events
145  *      Fully backward compatible with ERC20
146  */
147 contract ARTS is ERC223, Ownable {
148     using SafeMath for uint256;
149 
150     string public name = "ARTS";
151     string public symbol = "ARTS";
152     uint8 public decimals = 8;
153     uint256 public initialSupply = 30e9 * 1e8;
154     uint256 public totalSupply;
155     uint256 public distributeAmount = 0;
156     bool public mintingFinished = false;
157     
158     mapping(address => uint256) public balanceOf;
159     mapping(address => mapping (address => uint256)) public allowance;
160     mapping (address => bool) public frozenAccount;
161     mapping (address => uint256) public unlockUnixTime;
162     
163     event FrozenFunds(address indexed target, bool frozen);
164     event LockedFunds(address indexed target, uint256 locked);
165     event Burn(address indexed from, uint256 amount);
166     event Mint(address indexed to, uint256 amount);
167     event MintFinished();
168 
169 
170     /** 
171      * @dev Constructor is called only once and can not be called again
172      */
173 
174     function ARTS() public {
175         totalSupply = initialSupply;
176         balanceOf[msg.sender] = totalSupply;
177     }
178 
179     function name() public view returns (string _name) {
180         return name;
181     }
182 
183     function symbol() public view returns (string _symbol) {
184         return symbol;
185     }
186 
187     function decimals() public view returns (uint8 _decimals) {
188         return decimals;
189     }
190 
191     function totalSupply() public view returns (uint256 _totalSupply) {
192         return totalSupply;
193     }
194 
195     function balanceOf(address _owner) public view returns (uint256 balance) {
196         return balanceOf[_owner];
197     }
198 
199 
200     /**
201      * @dev Prevent targets from sending or receiving tokens
202      * @param targets Addresses to be frozen
203      * @param isFrozen either to freeze it or not
204      */
205     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
206         require(targets.length > 0);
207 
208         for (uint j = 0; j < targets.length; j++) {
209             require(targets[j] != 0x0);
210             frozenAccount[targets[j]] = isFrozen;
211             FrozenFunds(targets[j], isFrozen);
212         }
213     }
214 
215     /**
216      * @dev Prevent targets from sending or receiving tokens by setting Unix times
217      * @param targets Addresses to be locked funds
218      * @param unixTimes Unix times when locking up will be finished
219      */
220     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
221         require(targets.length > 0
222                 && targets.length == unixTimes.length);
223                 
224         for(uint j = 0; j < targets.length; j++){
225             require(unlockUnixTime[targets[j]] < unixTimes[j]);
226             unlockUnixTime[targets[j]] = unixTimes[j];
227             LockedFunds(targets[j], unixTimes[j]);
228         }
229     }
230 
231 
232     /**
233      * @dev Function that is called when a user or another contract wants to transfer funds
234      */
235     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
236         require(_value > 0
237                 && frozenAccount[msg.sender] == false 
238                 && frozenAccount[_to] == false
239                 && now > unlockUnixTime[msg.sender] 
240                 && now > unlockUnixTime[_to]);
241 
242         if (isContract(_to)) {
243             require(balanceOf[msg.sender] >= _value);
244             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
245             balanceOf[_to] = balanceOf[_to].add(_value);
246             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
247             Transfer(msg.sender, _to, _value, _data);
248             Transfer(msg.sender, _to, _value);
249             return true;
250         } else {
251             return transferToAddress(_to, _value, _data);
252         }
253     }
254 
255     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
256         require(_value > 0
257                 && frozenAccount[msg.sender] == false 
258                 && frozenAccount[_to] == false
259                 && now > unlockUnixTime[msg.sender] 
260                 && now > unlockUnixTime[_to]);
261 
262         if (isContract(_to)) {
263             return transferToContract(_to, _value, _data);
264         } else {
265             return transferToAddress(_to, _value, _data);
266         }
267     }
268 
269     /**
270      * @dev Standard function transfer similar to ERC20 transfer with no _data
271      *      Added due to backwards compatibility reasons
272      */
273     function transfer(address _to, uint _value) public returns (bool success) {
274         require(_value > 0
275                 && frozenAccount[msg.sender] == false 
276                 && frozenAccount[_to] == false
277                 && now > unlockUnixTime[msg.sender] 
278                 && now > unlockUnixTime[_to]);
279 
280         bytes memory empty;
281         if (isContract(_to)) {
282             return transferToContract(_to, _value, empty);
283         } else {
284             return transferToAddress(_to, _value, empty);
285         }
286     }
287 
288     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
289     function isContract(address _addr) private view returns (bool is_contract) {
290         uint length;
291         assembly {
292             //retrieve the size of the code on target address, this needs assembly
293             length := extcodesize(_addr)
294         }
295         return (length > 0);
296     }
297 
298     // function that is called when transaction target is an address
299     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
300         require(balanceOf[msg.sender] >= _value);
301         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
302         balanceOf[_to] = balanceOf[_to].add(_value);
303         Transfer(msg.sender, _to, _value, _data);
304         Transfer(msg.sender, _to, _value);
305         return true;
306     }
307 
308     // function that is called when transaction target is a contract
309     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
310         require(balanceOf[msg.sender] >= _value);
311         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
312         balanceOf[_to] = balanceOf[_to].add(_value);
313         ContractReceiver receiver = ContractReceiver(_to);
314         receiver.tokenFallback(msg.sender, _value, _data);
315         Transfer(msg.sender, _to, _value, _data);
316         Transfer(msg.sender, _to, _value);
317         return true;
318     }
319 
320 
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
368 
369 
370     /**
371      * @dev Burns a specific amount of tokens.
372      * @param _from The address that will burn the tokens.
373      * @param _unitAmount The amount of token to be burned.
374      */
375     function burn(address _from, uint256 _unitAmount) onlyOwner public {
376         require(_unitAmount > 0
377                 && balanceOf[_from] >= _unitAmount);
378 
379         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
380         totalSupply = totalSupply.sub(_unitAmount);
381         Burn(_from, _unitAmount);
382     }
383 
384 
385     modifier canMint() {
386         require(!mintingFinished);
387         _;
388     }
389 
390     /**
391      * @dev Function to mint tokens
392      * @param _to The address that will receive the minted tokens.
393      * @param _unitAmount The amount of tokens to mint.
394      */
395     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
396         require(_unitAmount > 0);
397         
398         totalSupply = totalSupply.add(_unitAmount);
399         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
400         Mint(_to, _unitAmount);
401         Transfer(address(0), _to, _unitAmount);
402         return true;
403     }
404 
405     /**
406      * @dev Function to stop minting new tokens.
407      */
408     function finishMinting() onlyOwner canMint public returns (bool) {
409         mintingFinished = true;
410         MintFinished();
411         return true;
412     }
413 
414 
415 
416     /**
417      * @dev Function to distribute tokens to the list of addresses by the provided amount
418      */
419     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
420         require(amount > 0 
421                 && addresses.length > 0
422                 && frozenAccount[msg.sender] == false
423                 && now > unlockUnixTime[msg.sender]);
424 
425         amount = amount.mul(1e8);
426         uint256 totalAmount = amount.mul(addresses.length);
427         require(balanceOf[msg.sender] >= totalAmount);
428         
429         for (uint j = 0; j < addresses.length; j++) {
430             require(addresses[j] != 0x0
431                     && frozenAccount[addresses[j]] == false
432                     && now > unlockUnixTime[addresses[j]]);
433 
434             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
435             Transfer(msg.sender, addresses[j], amount);
436         }
437         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
438         return true;
439     }
440 
441     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
442         require(addresses.length > 0
443                 && addresses.length == amounts.length
444                 && frozenAccount[msg.sender] == false
445                 && now > unlockUnixTime[msg.sender]);
446                 
447         uint256 totalAmount = 0;
448         
449         for(uint j = 0; j < addresses.length; j++){
450             require(amounts[j] > 0
451                     && addresses[j] != 0x0
452                     && frozenAccount[addresses[j]] == false
453                     && now > unlockUnixTime[addresses[j]]);
454                     
455             amounts[j] = amounts[j].mul(1e8);
456             totalAmount = totalAmount.add(amounts[j]);
457         }
458         require(balanceOf[msg.sender] >= totalAmount);
459         
460         for (j = 0; j < addresses.length; j++) {
461             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
462             Transfer(msg.sender, addresses[j], amounts[j]);
463         }
464         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
465         return true;
466     }
467 
468     /**
469      * @dev Function to collect tokens from the list of addresses
470      */
471     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
472         require(addresses.length > 0
473                 && addresses.length == amounts.length);
474 
475         uint256 totalAmount = 0;
476         
477         for (uint j = 0; j < addresses.length; j++) {
478             require(amounts[j] > 0
479                     && addresses[j] != 0x0
480                     && frozenAccount[addresses[j]] == false
481                     && now > unlockUnixTime[addresses[j]]);
482                     
483             amounts[j] = amounts[j].mul(1e8);
484             require(balanceOf[addresses[j]] >= amounts[j]);
485             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
486             totalAmount = totalAmount.add(amounts[j]);
487             Transfer(addresses[j], msg.sender, amounts[j]);
488         }
489         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
490         return true;
491     }
492 
493 
494     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
495         distributeAmount = _unitAmount;
496     }
497     
498     /**
499      * @dev Function to distribute tokens to the msg.sender automatically
500      *      If distributeAmount is 0, this function doesn't work
501      */
502     function autoDistribute() payable public {
503         require(distributeAmount > 0
504                 && balanceOf[owner] >= distributeAmount
505                 && frozenAccount[msg.sender] == false
506                 && now > unlockUnixTime[msg.sender]);
507         if(msg.value > 0) owner.transfer(msg.value);
508         
509         balanceOf[owner] = balanceOf[owner].sub(distributeAmount);
510         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
511         Transfer(owner, msg.sender, distributeAmount);
512     }
513 
514 
515     /**
516      * @dev fallback function
517      */
518     function() payable public {
519         autoDistribute();
520      }
521 
522 }