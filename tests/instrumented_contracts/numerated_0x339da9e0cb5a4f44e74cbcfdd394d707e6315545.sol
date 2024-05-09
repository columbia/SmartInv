1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 /**
68  * @title Ownable
69  * @dev The Ownable contract has an owner address, and provides basic authorization
70  *      control functions, this simplifies the implementation of "user permissions".
71  */
72 contract Ownable {
73     address public owner;
74 
75     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77     /**
78      * @dev The Ownable constructor sets the original `owner` of the contract to the
79      *      sender account.
80      */
81     constructor() public {
82         owner = msg.sender;
83     }
84 
85     /**
86      * @dev Throws if called by any account other than the owner.
87      */
88     modifier onlyOwner() {
89         require(msg.sender == owner);
90         _;
91     }
92 
93     /**
94      * @dev Allows the current owner to transfer control of the contract to a newOwner.
95      * @param newOwner The address to transfer ownership to.
96      */
97     function transferOwnership(address newOwner) onlyOwner public {
98         require(newOwner != address(0));
99         emit OwnershipTransferred(owner, newOwner);
100         owner = newOwner;
101     }
102 }
103 
104 /**
105  * @title ERC223
106  * @dev ERC223 contract interface with ERC20 functions and events
107  *      Fully backward compatible with ERC20
108  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
109  */
110 contract ERC223 {
111     using SafeMath for uint256;
112 
113     // ERC223 and ERC20 functions and events
114     function balanceOf(address who) public view returns (uint256);
115     function totalSupply() public view returns (uint256);
116     function transfer(address to, uint value) public returns (bool);
117     function transfer(address to, uint value, bytes memory data) public returns (bool);
118     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
119 
120     // ERC223 functions
121     function name() public view returns (string memory);
122     function symbol() public view returns (string memory);
123     function decimals() public view returns (uint8);
124 
125     // ERC20 functions and events
126     function transferFrom(address from, address to, uint256 value) public returns (bool);
127     function approve(address spender, uint256 value) public returns (bool);
128     function allowance(address owner, address spender) public view returns (uint256);
129     event Transfer(address indexed from, address indexed to, uint256 value);
130     event Approval(address indexed owner, address indexed spender, uint value);
131 }
132 
133 /**
134  * @title ContractReceiver
135  * @dev Contract that is working with ERC223 tokens
136  */
137 contract ContractReceiver {
138     /**
139     * @dev Standard ERC223 function that will handle incoming token transfers.
140     *
141     * @param _from  Token sender address.
142     * @param _value Amount of tokens.
143     * @param _data  Transaction metadata.
144     */
145     function tokenFallback(address _from, uint _value, bytes memory _data) public;
146 }
147 
148 /**
149  * @title ZENI
150  * @author ZENI
151  * @dev ZENI is an ERC223 Token with ERC20 functions and events
152  *      Fully backward compatible with ERC20
153  */
154 contract ZENI is ERC223, Ownable {
155     using SafeMath for uint256;
156 
157     string private _name = "ZENI";
158     string private _symbol = "ZENI";
159     uint8 private _decimals = 8;
160     uint256 private _initialSupply = 60e9 * 1e8;
161 
162     mapping (address => uint256) private _balances;
163     mapping (address => mapping (address => uint256)) private _allowed;
164     uint private _totalSupply;
165 
166     bool public mintingFinished = false;
167     mapping (address => bool) public frozenAccount;
168     mapping (address => uint256) public unlockUnixTime;
169 
170     event FrozenFunds(address indexed target, bool frozen);
171     event LockedFunds(address indexed target, uint256 locked);
172     event Burn(address indexed from, uint256 amount);
173     event Mint(address indexed to, uint256 amount);
174     event MintFinished();
175 
176     /**
177      * @dev Constructor is called only once and can not be called again
178      */
179     constructor() public {
180         _totalSupply = _initialSupply;
181         _balances[msg.sender] = _totalSupply;
182     }
183 
184 
185     function name() public view returns (string memory) {
186         return _name;
187     }
188 
189     function symbol() public view returns (string memory) {
190         return _symbol;
191     }
192 
193     function decimals() public view returns (uint8) {
194         return _decimals;
195     }
196 
197     function totalSupply() public view returns (uint256) {
198         return _totalSupply;
199     }
200 
201     function balanceOf(address _owner) public view returns (uint256) {
202         return _balances[_owner];
203     }
204 
205     /**
206      * @dev Prevent targets from sending or receiving tokens
207      * @param targets Addresses to be frozen
208      * @param isFrozen either to freeze it or not
209      */
210     function freezeAccounts(address[] memory targets, bool isFrozen) public onlyOwner {
211         require(targets.length > 0);
212 
213         for (uint j = 0; j < targets.length; j++) {
214             require(targets[j] != address(0));
215             frozenAccount[targets[j]] = isFrozen;
216             emit FrozenFunds(targets[j], isFrozen);
217         }
218     }
219 
220     /**
221      * @dev Prevent targets from sending or receiving tokens by setting Unix times
222      * @param targets Addresses to be locked funds
223      * @param unixTimes Unix times when locking up will be finished
224      */
225     function lockupAccounts(address[] memory targets, uint[] memory unixTimes) public onlyOwner {
226         require(
227             targets.length > 0 &&
228             targets.length == unixTimes.length
229         );
230 
231         for(uint i = 0; i < targets.length; i++){
232             require(unlockUnixTime[targets[i]] < unixTimes[i]);
233             unlockUnixTime[targets[i]] = unixTimes[i];
234             emit LockedFunds(targets[i], unixTimes[i]);
235         }
236     }
237 
238     // Function that is called when a user or another contract wants to transfer funds .
239     function transfer(address _to, uint _value, bytes memory _data) public returns (bool) {
240         require(
241             _value > 0 &&
242             frozenAccount[msg.sender] == false &&
243             frozenAccount[_to] == false &&
244             now > unlockUnixTime[msg.sender] &&
245             now > unlockUnixTime[_to]
246         );
247 
248         if(isContract(_to)) {
249             return transferToContract(_to, _value, _data);
250         }
251         else {
252             return transferToAddress(_to, _value, _data);
253         }
254     }
255 
256     /**
257      * @dev Standard function transfer similar to ERC20 transfer with no _data
258      *      Added due to backwards compatibility reasons
259      */
260     function transfer(address _to, uint _value) public returns (bool) {
261         require(
262             _value > 0 &&
263             frozenAccount[msg.sender] == false &&
264             frozenAccount[_to] == false &&
265             now > unlockUnixTime[msg.sender] &&
266             now > unlockUnixTime[_to]
267         );
268 
269         bytes memory empty;
270         if (isContract(_to)) {
271             return transferToContract(_to, _value, empty);
272         } else {
273             return transferToAddress(_to, _value, empty);
274         }
275     }
276 
277     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
278     function isContract(address _addr) private view returns (bool) {
279         uint length;
280         assembly {
281             //retrieve the size of the code on target address, this needs assembly
282             length := extcodesize(_addr)
283         }
284         return (length > 0);
285     }
286 
287     // function that is called when transaction target is an address
288     function transferToAddress(address _to, uint _value, bytes memory _data) private returns (bool) {
289         require(balanceOf(msg.sender) >= _value);
290         _balances[msg.sender] = _balances[msg.sender].sub(_value);
291         _balances[_to] = _balances[_to].add(_value);
292         emit Transfer(msg.sender, _to, _value, _data);
293         emit Transfer(msg.sender, _to, _value);
294         return true;
295     }
296 
297     // function that is called when transaction target is a contract
298     function transferToContract(address _to, uint _value, bytes memory _data) private returns (bool) {
299         require(balanceOf(msg.sender) >= _value);
300         ContractReceiver receiver = ContractReceiver(_to);
301         receiver.tokenFallback(msg.sender, _value, _data);
302         emit Transfer(msg.sender, _to, _value, _data);
303         emit Transfer(msg.sender, _to, _value);
304         return true;
305     }
306 
307     /**
308      * @dev Transfer tokens from one address to another
309      *      Added due to backwards compatibility with ERC20
310      * @param _from address The address which you want to send tokens from
311      * @param _to address The address which you want to transfer to
312      * @param _value uint256 the amount of tokens to be transferred
313      */
314     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
315         require(
316             _to != address(0) &&
317             _value > 0 &&
318             _balances[_from] >= _value &&
319             _allowed[_from][msg.sender] >= _value &&
320             frozenAccount[_from] == false &&
321             frozenAccount[_to] == false &&
322             now > unlockUnixTime[_from] &&
323             now > unlockUnixTime[_to]
324         );
325 
326         _balances[_from] = _balances[_from].sub(_value);
327         _balances[_to] = _balances[_to].add(_value);
328         _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);
329         emit Transfer(_from, _to, _value);
330         return true;
331     }
332 
333     /**
334      * @dev Allows _spender to spend no more than _value tokens in your behalf
335      *      Added due to backwards compatibility with ERC20
336      * @param _spender The address authorized to spend
337      * @param _value the max amount they can spend
338      */
339     function approve(address _spender, uint256 _value) public returns (bool) {
340         _allowed[msg.sender][_spender] = _value;
341         emit Approval(msg.sender, _spender, _value);
342         return true;
343     }
344 
345     /**
346      * @dev Function to check the amount of tokens that an owner allowed to a spender
347      *      Added due to backwards compatibility with ERC20
348      * @param _owner address The address which owns the funds
349      * @param _spender address The address which will spend the funds
350      */
351     function allowance(address _owner, address _spender) public view returns (uint256) {
352         return _allowed[_owner][_spender];
353     }
354 
355     /**
356      * @dev Burns a specific amount of tokens.
357      * @param _from The address that will burn the tokens.
358      * @param _unitAmount The amount of token to be burned.
359      */
360     function burn(address _from, uint256 _unitAmount) public onlyOwner {
361         require(
362             _unitAmount > 0 &&
363             balanceOf(_from) >= _unitAmount
364         );
365 
366         _balances[_from] = _balances[_from].sub(_unitAmount);
367         _totalSupply = _totalSupply.sub(_unitAmount);
368         emit Burn(_from, _unitAmount);
369     }
370 
371 
372     modifier canMint() {
373         require(!mintingFinished);
374         _;
375     }
376 
377     /**
378      * @dev Function to mint tokens
379      * @param _to The address that will receive the minted tokens.
380      * @param _unitAmount The amount of tokens to mint.
381      */
382     function mint(address _to, uint256 _unitAmount) public onlyOwner canMint returns (bool) {
383         require(_unitAmount > 0);
384 
385         _totalSupply = _totalSupply.add(_unitAmount);
386         _balances[_to] = _balances[_to].add(_unitAmount);
387         emit Mint(_to, _unitAmount);
388         emit Transfer(address(0), _to, _unitAmount);
389         return true;
390     }
391 
392     /**
393      * @dev Function to stop minting new tokens.
394      */
395     function finishMinting() public onlyOwner canMint returns (bool) {
396         mintingFinished = true;
397         emit MintFinished();
398         return true;
399     }
400 
401     /**
402      * @dev Function to distribute tokens to the list of addresses by the provided amount
403      */
404     function distributeAirdrop(address[] memory addresses, uint256 amount) public returns (bool) {
405         require(
406             amount > 0 &&
407             addresses.length > 0 &&
408             frozenAccount[msg.sender] == false &&
409             now > unlockUnixTime[msg.sender]
410         );
411 
412         uint256 mulAmount = amount.mul(1e8);
413         uint256 totalAmount = mulAmount.mul(addresses.length);
414         require(_balances[msg.sender] >= totalAmount);
415 
416         for (uint i = 0; i < addresses.length; i++) {
417             require(
418                 addresses[i] != address(0) &&
419                 frozenAccount[addresses[i]] == false &&
420                 now > unlockUnixTime[addresses[i]]
421             );
422 
423             _balances[addresses[i]] = _balances[addresses[i]].add(mulAmount);
424             emit Transfer(msg.sender, addresses[i], mulAmount);
425         }
426         _balances[msg.sender] = _balances[msg.sender].sub(totalAmount);
427         return true;
428     }
429 
430     function distributeAirdrop(address[] memory addresses, uint[] memory amounts) public returns (bool) {
431         require(
432             addresses.length > 0 &&
433             addresses.length == amounts.length &&
434             frozenAccount[msg.sender] == false &&
435             now > unlockUnixTime[msg.sender]
436         );
437 
438         uint256 totalAmount = 0;
439 
440         for(uint i = 0; i < addresses.length; i++){
441             require(
442                 amounts[i] > 0 &&
443                 addresses[i] != address(0) &&
444                 frozenAccount[addresses[i]] == false &&
445                 now > unlockUnixTime[addresses[i]]
446             );
447 
448             amounts[i] = amounts[i].mul(1e8);
449             totalAmount = totalAmount.add(amounts[i]);
450         }
451         require(_balances[msg.sender] >= totalAmount);
452 
453         for (uint j = 0; j < addresses.length; j++) {
454             _balances[addresses[j]] = _balances[addresses[j]].add(amounts[j]);
455             emit Transfer(msg.sender, addresses[j], amounts[j]);
456         }
457         _balances[msg.sender] = _balances[msg.sender].sub(totalAmount);
458         return true;
459     }
460 
461     /**
462      * @dev Function to collect tokens from the list of addresses
463      */
464     function collectTokens(address[] memory addresses, uint[] memory amounts) public onlyOwner returns (bool) {
465         require(
466             addresses.length > 0 &&
467             addresses.length == amounts.length
468         );
469 
470         uint256 totalAmount = 0;
471 
472         for (uint i = 0; i < addresses.length; i++) {
473             require(
474                 amounts[i] > 0 &&
475                 addresses[i] != address(0) &&
476                 frozenAccount[addresses[i]] == false &&
477                 now > unlockUnixTime[addresses[i]]
478             );
479 
480             amounts[i] = amounts[i].mul(1e8);
481             require(_balances[addresses[i]] >= amounts[i]);
482             _balances[addresses[i]] = _balances[addresses[i]].sub(amounts[i]);
483             totalAmount = totalAmount.add(amounts[i]);
484             emit Transfer(addresses[i], msg.sender, amounts[i]);
485         }
486         _balances[msg.sender] = _balances[msg.sender].add(totalAmount);
487         return true;
488     }
489 
490     /**
491      * @dev fallback function
492      */
493     function() external {
494         revert();
495     }
496 
497     /**
498      * @dev Reject all ERC223 compatible tokens
499      * @param from_ address The address that is transferring the tokens
500      * @param value_ uint256 the amount of the specified token
501      * @param data_ Bytes The data passed from the caller.
502      */
503     function tokenFallback(address from_, uint256 value_, bytes memory data_) public pure {
504         from_;
505         value_;
506         data_;
507         revert();
508     }
509 }