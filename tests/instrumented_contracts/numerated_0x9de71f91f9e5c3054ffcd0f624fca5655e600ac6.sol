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
37 /**
38  * @title Ownable
39  * @dev The Ownable contract has an owner address, and provides basic authorization
40  *      control functions, this simplifies the implementation of "user permissions".
41  */
42 contract Ownable {
43     address public owner;
44 
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47     /**
48      * @dev The Ownable constructor sets the original `owner` of the contract to the
49      *      sender account.
50      */
51     function Ownable() public {
52         owner = msg.sender;
53     }
54 
55     /**
56      * @dev Throws if called by any account other than the owner.
57      */
58     modifier onlyOwner() {
59         require(msg.sender == owner);
60         _;
61     }
62 
63     /**
64      * @dev Allows the current owner to transfer control of the contract to a newOwner.
65      * @param newOwner The address to transfer ownership to.
66      */
67     function transferOwnership(address newOwner) onlyOwner public {
68         require(newOwner != address(0));
69         OwnershipTransferred(owner, newOwner);
70         owner = newOwner;
71     }
72 }
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
106 /**
107  * @title ContractReceiver
108  * @dev Contract that is working with ERC223 tokens
109  */
110  contract ContractReceiver {
111 
112     struct TKN {
113         address sender;
114         uint value;
115         bytes data;
116         bytes4 sig;
117     }
118 
119     function tokenFallback(address _from, uint _value, bytes _data) public pure {
120         TKN memory tkn;
121         tkn.sender = _from;
122         tkn.value = _value;
123         tkn.data = _data;
124         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
125         tkn.sig = bytes4(u);
126 
127         /**
128          * tkn variable is analogue of msg variable of Ether transaction
129          * tkn.sender is person who initiated this token transaction (analogue of msg.sender)
130          * tkn.value the number of tokens that were sent (analogue of msg.value)
131          * tkn.data is data of token transaction (analogue of msg.data)
132          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
133          */
134     }
135 }
136 
137 
138 /**
139  * @title Alpon
140  * @author Alpon
141  * @dev Alpon is an ERC223 Token with ERC20 functions and events
142  *      Fully backward compatible with ERC20
143  */
144 contract Alpon is ERC223, Ownable {
145     using SafeMath for uint256;
146 
147     string public name = "Alpon";
148     string public symbol = "APN";
149     uint8 public decimals = 8;
150     uint256 public initialSupply = 10e9 * 1e8;
151     uint256 public totalSupply;
152     uint256 public distributeAmount = 0;
153     bool public mintingFinished = false;
154 
155     mapping(address => uint256) public balanceOf;
156     mapping(address => mapping (address => uint256)) public allowance;
157     mapping (address => bool) public frozenAccount;
158     mapping (address => uint256) public unlockUnixTime;
159     
160     event FrozenFunds(address indexed target, bool frozen);
161     event LockedFunds(address indexed target, uint256 locked);
162     event Burn(address indexed from, uint256 amount);
163     event Mint(address indexed to, uint256 amount);
164     event MintFinished();
165 
166     /** 
167      * @dev Constructor is called only once and can not be called again
168      */
169     function Alpon() public {
170         totalSupply = initialSupply;
171         balanceOf[msg.sender] = totalSupply;
172     }
173 
174     function name() public view returns (string _name) {
175         return name;
176     }
177 
178     function symbol() public view returns (string _symbol) {
179         return symbol;
180     }
181 
182     function decimals() public view returns (uint8 _decimals) {
183         return decimals;
184     }
185 
186     function totalSupply() public view returns (uint256 _totalSupply) {
187         return totalSupply;
188     }
189 
190     function balanceOf(address _owner) public view returns (uint256 balance) {
191         return balanceOf[_owner];
192     }
193 
194     /**
195      * @dev Prevent targets from sending or receiving tokens
196      * @param targets Addresses to be frozen
197      * @param isFrozen either to freeze it or not
198      */
199     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
200         require(targets.length > 0);
201 
202         for (uint j = 0; j < targets.length; j++) {
203             require(targets[j] != 0x0);
204             frozenAccount[targets[j]] = isFrozen;
205             FrozenFunds(targets[j], isFrozen);
206         }
207     }
208 
209     /**
210      * @dev Prevent targets from sending or receiving tokens by setting Unix times
211      * @param targets Addresses to be locked funds
212      * @param unixTimes Unix times when locking up will be finished
213      */
214     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
215         require(targets.length > 0
216                 && targets.length == unixTimes.length);
217 
218         for(uint j = 0; j < targets.length; j++){
219             require(unlockUnixTime[targets[j]] < unixTimes[j]);
220             unlockUnixTime[targets[j]] = unixTimes[j];
221             LockedFunds(targets[j], unixTimes[j]);
222         }
223     }
224 
225     /**
226      * @dev Function that is called when a user or another contract wants to transfer funds
227      */
228     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
229         require(_value > 0
230                 && frozenAccount[msg.sender] == false
231                 && frozenAccount[_to] == false
232                 && now > unlockUnixTime[msg.sender]
233                 && now > unlockUnixTime[_to]);
234 
235         if (isContract(_to)) {
236             require(balanceOf[msg.sender] >= _value);
237             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
238             balanceOf[_to] = balanceOf[_to].add(_value);
239             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
240             Transfer(msg.sender, _to, _value, _data);
241             Transfer(msg.sender, _to, _value);
242             return true;
243         } else {
244             return transferToAddress(_to, _value, _data);
245         }
246     }
247 
248     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
249         require(_value > 0
250                 && frozenAccount[msg.sender] == false
251                 && frozenAccount[_to] == false
252                 && now > unlockUnixTime[msg.sender]
253                 && now > unlockUnixTime[_to]);
254 
255         if (isContract(_to)) {
256             return transferToContract(_to, _value, _data);
257         } else {
258             return transferToAddress(_to, _value, _data);
259         }
260     }
261 
262     /**
263      * @dev Standard function transfer similar to ERC20 transfer with no _data
264      *      Added due to backwards compatibility reasons
265      */
266     function transfer(address _to, uint _value) public returns (bool success) {
267         require(_value > 0
268                 && frozenAccount[msg.sender] == false
269                 && frozenAccount[_to] == false
270                 && now > unlockUnixTime[msg.sender]
271                 && now > unlockUnixTime[_to]);
272 
273         bytes memory empty;
274         if (isContract(_to)) {
275             return transferToContract(_to, _value, empty);
276         } else {
277             return transferToAddress(_to, _value, empty);
278         }
279     }
280 
281     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
282     function isContract(address _addr) private view returns (bool is_contract) {
283         uint length;
284         assembly {
285             //retrieve the size of the code on target address, this needs assembly
286             length := extcodesize(_addr)
287         }
288         return (length > 0);
289     }
290 
291     // function that is called when transaction target is an address
292     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
293         require(balanceOf[msg.sender] >= _value);
294         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
295         balanceOf[_to] = balanceOf[_to].add(_value);
296         Transfer(msg.sender, _to, _value, _data);
297         Transfer(msg.sender, _to, _value);
298         return true;
299     }
300 
301     // function that is called when transaction target is a contract
302     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
303         require(balanceOf[msg.sender] >= _value);
304         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
305         balanceOf[_to] = balanceOf[_to].add(_value);
306         ContractReceiver receiver = ContractReceiver(_to);
307         receiver.tokenFallback(msg.sender, _value, _data);
308         Transfer(msg.sender, _to, _value, _data);
309         Transfer(msg.sender, _to, _value);
310         return true;
311     }
312 
313     /**
314      * @dev Transfer tokens from one address to another
315      *      Added due to backwards compatibility with ERC20
316      * @param _from address The address which you want to send tokens from
317      * @param _to address The address which you want to transfer to
318      * @param _value uint256 the amount of tokens to be transferred
319      */
320     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
321         require(_to != address(0)
322                 && _value > 0
323                 && balanceOf[_from] >= _value
324                 && allowance[_from][msg.sender] >= _value
325                 && frozenAccount[_from] == false
326                 && frozenAccount[_to] == false
327                 && now > unlockUnixTime[_from]
328                 && now > unlockUnixTime[_to]);
329 
330         balanceOf[_from] = balanceOf[_from].sub(_value);
331         balanceOf[_to] = balanceOf[_to].add(_value);
332         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
333         Transfer(_from, _to, _value);
334         return true;
335     }
336 
337     /**
338      * @dev Allows _spender to spend no more than _value tokens in your behalf
339      *      Added due to backwards compatibility with ERC20
340      * @param _spender The address authorized to spend
341      * @param _value the max amount they can spend
342      */
343     function approve(address _spender, uint256 _value) public returns (bool success) {
344         allowance[msg.sender][_spender] = _value;
345         Approval(msg.sender, _spender, _value);
346         return true;
347     }
348 
349     /**
350      * @dev Function to check the amount of tokens that an owner allowed to a spender
351      *      Added due to backwards compatibility with ERC20
352      * @param _owner address The address which owns the funds
353      * @param _spender address The address which will spend the funds
354      */
355     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
356         return allowance[_owner][_spender];
357     }
358 
359     /**
360      * @dev Burns a specific amount of tokens.
361      * @param _from The address that will burn the tokens.
362      * @param _unitAmount The amount of token to be burned.
363      */
364     function burn(address _from, uint256 _unitAmount) onlyOwner public {
365         require(_unitAmount > 0
366                 && balanceOf[_from] >= _unitAmount);
367 
368         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
369         totalSupply = totalSupply.sub(_unitAmount);
370         Burn(_from, _unitAmount);
371     }
372 
373     modifier canMint() {
374         require(!mintingFinished);
375         _;
376     }
377 
378     /**
379      * @dev Function to mint tokens
380      * @param _to The address that will receive the minted tokens.
381      * @param _unitAmount The amount of tokens to mint.
382      */
383     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
384         require(_unitAmount > 0);
385         
386         totalSupply = totalSupply.add(_unitAmount);
387         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
388         Mint(_to, _unitAmount);
389         Transfer(address(0), _to, _unitAmount);
390         return true;
391     }
392 
393     /**
394      * @dev Function to stop minting new tokens.
395      */
396     function finishMinting() onlyOwner canMint public returns (bool) {
397         mintingFinished = true;
398         MintFinished();
399         return true;
400     }
401 
402     /**
403      * @dev Function to distribute tokens to the list of addresses by the provided amount
404      */
405     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
406         require(amount > 0 
407                 && addresses.length > 0
408                 && frozenAccount[msg.sender] == false
409                 && now > unlockUnixTime[msg.sender]);
410 
411         amount = amount.mul(1e8);
412         uint256 totalAmount = amount.mul(addresses.length);
413         require(balanceOf[msg.sender] >= totalAmount);
414         
415         for (uint j = 0; j < addresses.length; j++) {
416             require(addresses[j] != 0x0
417                     && frozenAccount[addresses[j]] == false
418                     && now > unlockUnixTime[addresses[j]]);
419 
420             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
421             Transfer(msg.sender, addresses[j], amount);
422         }
423         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
424         return true;
425     }
426 
427     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
428         require(addresses.length > 0
429                 && addresses.length == amounts.length
430                 && frozenAccount[msg.sender] == false
431                 && now > unlockUnixTime[msg.sender]);
432                 
433         uint256 totalAmount = 0;
434         
435         for(uint j = 0; j < addresses.length; j++){
436             require(amounts[j] > 0
437                     && addresses[j] != 0x0
438                     && frozenAccount[addresses[j]] == false
439                     && now > unlockUnixTime[addresses[j]]);
440                     
441             amounts[j] = amounts[j].mul(1e8);
442             totalAmount = totalAmount.add(amounts[j]);
443         }
444         require(balanceOf[msg.sender] >= totalAmount);
445         
446         for (j = 0; j < addresses.length; j++) {
447             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
448             Transfer(msg.sender, addresses[j], amounts[j]);
449         }
450         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
451         return true;
452     }
453 
454     /**
455      * @dev Function to collect tokens from the list of addresses
456      */
457     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
458         require(addresses.length > 0
459                 && addresses.length == amounts.length);
460 
461         uint256 totalAmount = 0;
462         
463         for (uint j = 0; j < addresses.length; j++) {
464             require(amounts[j] > 0
465                     && addresses[j] != 0x0
466                     && frozenAccount[addresses[j]] == false
467                     && now > unlockUnixTime[addresses[j]]);
468                     
469             amounts[j] = amounts[j].mul(1e8);
470             require(balanceOf[addresses[j]] >= amounts[j]);
471             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
472             totalAmount = totalAmount.add(amounts[j]);
473             Transfer(addresses[j], msg.sender, amounts[j]);
474         }
475         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
476         return true;
477     }
478 
479     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
480         distributeAmount = _unitAmount;
481     }
482     
483     /**
484      * @dev Function to distribute tokens to the msg.sender automatically
485      *      If distributeAmount is 0, this function doesn't work
486      */
487     function autoDistribute() payable public {
488         require(distributeAmount > 0
489                 && balanceOf[owner] >= distributeAmount
490                 && frozenAccount[msg.sender] == false
491                 && now > unlockUnixTime[msg.sender]);
492         if(msg.value > 0) owner.transfer(msg.value);
493         
494         balanceOf[owner] = balanceOf[owner].sub(distributeAmount);
495         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
496         Transfer(owner, msg.sender, distributeAmount);
497     }
498 
499     /**
500      * @dev fallback function
501      */
502     function() payable public {
503         autoDistribute();
504     }
505 }