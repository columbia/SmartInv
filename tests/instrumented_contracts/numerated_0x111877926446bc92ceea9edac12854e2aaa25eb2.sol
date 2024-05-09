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
141 /**
142  * 彡(ﾟ)(ﾟ)
143  * @title AidEvaCoin
144  * @author AidEvaCoin
145  * @dev AidEvaCoin is an ERC223 Token with ERC20 functions and events
146  *      Fully backward compatible with ERC20
147  */
148 contract AidEvaCoin is ERC223, Ownable {
149     using SafeMath for uint256;
150 
151     string public name = "AidEvaCoin";
152     string public symbol = "AIVA";
153     uint8 public decimals = 18;
154     uint256 public totalSupply = 30e9 * 1e18;
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
173     function AidEvaCoin() public {
174         balanceOf[msg.sender] = totalSupply;
175     }
176 
177 
178     function name() public view returns (string _name) {
179         return name;
180     }
181 
182     function symbol() public view returns (string _symbol) {
183         return symbol;
184     }
185 
186     function decimals() public view returns (uint8 _decimals) {
187         return decimals;
188     }
189 
190     function totalSupply() public view returns (uint256 _totalSupply) {
191         return totalSupply;
192     }
193 
194     function balanceOf(address _owner) public view returns (uint256 balance) {
195         return balanceOf[_owner];
196     }
197 
198 
199     /**
200      * @dev Prevent targets from sending or receiving tokens
201      * @param targets Addresses to be frozen
202      * @param isFrozen either to freeze it or not
203      */
204     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
205         require(targets.length > 0);
206 
207         for (uint j = 0; j < targets.length; j++) {
208             require(targets[j] != 0x0);
209             frozenAccount[targets[j]] = isFrozen;
210             FrozenFunds(targets[j], isFrozen);
211         }
212     }
213 
214     /**
215      * @dev Prevent targets from sending or receiving tokens by setting Unix times
216      * @param targets Addresses to be locked funds
217      * @param unixTimes Unix times when locking up will be finished
218      */
219     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
220         require(targets.length > 0
221                 && targets.length == unixTimes.length);
222                 
223         for(uint j = 0; j < targets.length; j++){
224             require(unlockUnixTime[targets[j]] < unixTimes[j]);
225             unlockUnixTime[targets[j]] = unixTimes[j];
226             LockedFunds(targets[j], unixTimes[j]);
227         }
228     }
229 
230 
231     /**
232      * @dev Function that is called when a user or another contract wants to transfer funds
233      */
234     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
235         require(_value > 0
236                 && frozenAccount[msg.sender] == false 
237                 && frozenAccount[_to] == false
238                 && now > unlockUnixTime[msg.sender] 
239                 && now > unlockUnixTime[_to]);
240 
241         if (isContract(_to)) {
242             require(balanceOf[msg.sender] >= _value);
243             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
244             balanceOf[_to] = balanceOf[_to].add(_value);
245             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
246             Transfer(msg.sender, _to, _value, _data);
247             Transfer(msg.sender, _to, _value);
248             return true;
249         } else {
250             return transferToAddress(_to, _value, _data);
251         }
252     }
253 
254     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
255         require(_value > 0
256                 && frozenAccount[msg.sender] == false 
257                 && frozenAccount[_to] == false
258                 && now > unlockUnixTime[msg.sender] 
259                 && now > unlockUnixTime[_to]);
260 
261         if (isContract(_to)) {
262             return transferToContract(_to, _value, _data);
263         } else {
264             return transferToAddress(_to, _value, _data);
265         }
266     }
267 
268     /**
269      * @dev Standard function transfer similar to ERC20 transfer with no _data
270      *      Added due to backwards compatibility reasons
271      */
272     function transfer(address _to, uint _value) public returns (bool success) {
273         require(_value > 0
274                 && frozenAccount[msg.sender] == false 
275                 && frozenAccount[_to] == false
276                 && now > unlockUnixTime[msg.sender] 
277                 && now > unlockUnixTime[_to]);
278 
279         bytes memory empty;
280         if (isContract(_to)) {
281             return transferToContract(_to, _value, empty);
282         } else {
283             return transferToAddress(_to, _value, empty);
284         }
285     }
286 
287     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
288     function isContract(address _addr) private view returns (bool is_contract) {
289         uint length;
290         assembly {
291             //retrieve the size of the code on target address, this needs assembly
292             length := extcodesize(_addr)
293         }
294         return (length > 0);
295     }
296 
297     // function that is called when transaction target is an address
298     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
299         require(balanceOf[msg.sender] >= _value);
300         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
301         balanceOf[_to] = balanceOf[_to].add(_value);
302         Transfer(msg.sender, _to, _value, _data);
303         Transfer(msg.sender, _to, _value);
304         return true;
305     }
306 
307     // function that is called when transaction target is a contract
308     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
309         require(balanceOf[msg.sender] >= _value);
310         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
311         balanceOf[_to] = balanceOf[_to].add(_value);
312         ContractReceiver receiver = ContractReceiver(_to);
313         receiver.tokenFallback(msg.sender, _value, _data);
314         Transfer(msg.sender, _to, _value, _data);
315         Transfer(msg.sender, _to, _value);
316         return true;
317     }
318 
319 
320 
321     /**
322      * @dev Transfer tokens from one address to another
323      *      Added due to backwards compatibility with ERC20
324      * @param _from address The address which you want to send tokens from
325      * @param _to address The address which you want to transfer to
326      * @param _value uint256 the amount of tokens to be transferred
327      */
328     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
329         require(_to != address(0)
330                 && _value > 0
331                 && balanceOf[_from] >= _value
332                 && allowance[_from][msg.sender] >= _value
333                 && frozenAccount[_from] == false 
334                 && frozenAccount[_to] == false
335                 && now > unlockUnixTime[_from] 
336                 && now > unlockUnixTime[_to]);
337 
338         balanceOf[_from] = balanceOf[_from].sub(_value);
339         balanceOf[_to] = balanceOf[_to].add(_value);
340         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
341         Transfer(_from, _to, _value);
342         return true;
343     }
344 
345     /**
346      * @dev Allows _spender to spend no more than _value tokens in your behalf
347      *      Added due to backwards compatibility with ERC20
348      * @param _spender The address authorized to spend
349      * @param _value the max amount they can spend
350      */
351     function approve(address _spender, uint256 _value) public returns (bool success) {
352         allowance[msg.sender][_spender] = _value;
353         Approval(msg.sender, _spender, _value);
354         return true;
355     }
356 
357     /**
358      * @dev Function to check the amount of tokens that an owner allowed to a spender
359      *      Added due to backwards compatibility with ERC20
360      * @param _owner address The address which owns the funds
361      * @param _spender address The address which will spend the funds
362      */
363     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
364         return allowance[_owner][_spender];
365     }
366 
367 
368 
369     /**
370      * @dev Burns a specific amount of tokens.
371      * @param _from The address that will burn the tokens.
372      * @param _unitAmount The amount of token to be burned.
373      */
374     function burn(address _from, uint256 _unitAmount) onlyOwner public {
375         require(_unitAmount > 0
376                 && balanceOf[_from] >= _unitAmount);
377 
378         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
379         totalSupply = totalSupply.sub(_unitAmount);
380         Burn(_from, _unitAmount);
381     }
382 
383 
384     modifier canMint() {
385         require(!mintingFinished);
386         _;
387     }
388 
389     /**
390      * @dev Function to mint tokens
391      * @param _to The address that will receive the minted tokens.
392      * @param _unitAmount The amount of tokens to mint.
393      */
394     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
395         require(_unitAmount > 0);
396         
397         totalSupply = totalSupply.add(_unitAmount);
398         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
399         Mint(_to, _unitAmount);
400         Transfer(address(0), _to, _unitAmount);
401         return true;
402     }
403 
404     /**
405      * @dev Function to stop minting new tokens.
406      */
407     function finishMinting() onlyOwner canMint public returns (bool) {
408         mintingFinished = true;
409         MintFinished();
410         return true;
411     }
412 
413 
414 
415     /**
416      * @dev Function to distribute tokens to the list of addresses by the provided amount
417      */
418     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
419         require(amount > 0 
420                 && addresses.length > 0
421                 && frozenAccount[msg.sender] == false
422                 && now > unlockUnixTime[msg.sender]);
423 
424         amount = amount.mul(1e18);
425         uint256 totalAmount = amount.mul(addresses.length);
426         require(balanceOf[msg.sender] >= totalAmount);
427         
428         for (uint j = 0; j < addresses.length; j++) {
429             require(addresses[j] != 0x0
430                     && frozenAccount[addresses[j]] == false
431                     && now > unlockUnixTime[addresses[j]]);
432 
433             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
434             Transfer(msg.sender, addresses[j], amount);
435         }
436         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
437         return true;
438     }
439 
440     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
441         require(addresses.length > 0
442                 && addresses.length == amounts.length
443                 && frozenAccount[msg.sender] == false
444                 && now > unlockUnixTime[msg.sender]);
445                 
446         uint256 totalAmount = 0;
447         
448         for(uint j = 0; j < addresses.length; j++){
449             require(amounts[j] > 0
450                     && addresses[j] != 0x0
451                     && frozenAccount[addresses[j]] == false
452                     && now > unlockUnixTime[addresses[j]]);
453                     
454             amounts[j] = amounts[j].mul(1e18);
455             totalAmount = totalAmount.add(amounts[j]);
456         }
457         require(balanceOf[msg.sender] >= totalAmount);
458         
459         for (j = 0; j < addresses.length; j++) {
460             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
461             Transfer(msg.sender, addresses[j], amounts[j]);
462         }
463         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
464         return true;
465     }
466 
467     /**
468      * @dev Function to collect tokens from the list of addresses
469      */
470     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
471         require(addresses.length > 0
472                 && addresses.length == amounts.length);
473 
474         uint256 totalAmount = 0;
475         
476         for (uint j = 0; j < addresses.length; j++) {
477             require(amounts[j] > 0
478                     && addresses[j] != 0x0
479                     && frozenAccount[addresses[j]] == false
480                     && now > unlockUnixTime[addresses[j]]);
481                     
482             amounts[j] = amounts[j].mul(1e8);
483             require(balanceOf[addresses[j]] >= amounts[j]);
484             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
485             totalAmount = totalAmount.add(amounts[j]);
486             Transfer(addresses[j], msg.sender, amounts[j]);
487         }
488         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
489         return true;
490     }
491 
492 
493     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
494         distributeAmount = _unitAmount;
495     }
496     
497     /**
498      * @dev Function to distribute tokens to the msg.sender automatically
499      *      If distributeAmount is 0, this function doesn't work
500      */
501     function autoDistribute() payable public {
502         require(distributeAmount > 0
503                 && balanceOf[owner] >= distributeAmount
504                 && frozenAccount[msg.sender] == false
505                 && now > unlockUnixTime[msg.sender]);
506         if(msg.value > 0) owner.transfer(msg.value);
507         
508         balanceOf[owner] = balanceOf[owner].sub(distributeAmount);
509         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
510         Transfer(owner, msg.sender, distributeAmount);
511     }
512 
513     /**
514      * @dev fallback function
515      */
516     function() payable public {
517         autoDistribute();
518      }
519 
520 }