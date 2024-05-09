1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title DIETCoin
5  * @author DIETCoin
6  * @dev DIETCoin is an ERC223 Token with ERC20 functions and events
7  *      Fully backward compatible with ERC20
8  */
9 
10 /**
11  * @title SafeMath
12  * @dev Math operations with safety checks that throw on error
13  */
14 library SafeMath {
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         if (a == 0) {
17             return 0;
18         }
19         uint256 c = a * b;
20         assert(c / a == b);
21         return c;
22     }
23 
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         assert(b <= a);
33         return a - b;
34     }
35 
36     function add(uint256 a, uint256 b) internal pure returns (uint256) {
37         uint256 c = a + b;
38         assert(c >= a);
39         return c;
40     }
41 }
42 
43 /**
44  * @title Ownable
45  * @dev The Ownable contract has an owner address, and provides basic authorization
46  *      control functions, this simplifies the implementation of "user permissions".
47  */
48 contract Ownable {
49     address public owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev The Ownable constructor sets the original `owner` of the contract to the
55      *      sender account.
56      */
57     function Ownable() public {
58         owner = msg.sender;
59     }
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         require(msg.sender == owner);
66         _;
67     }
68 
69     /**
70      * @dev Allows the current owner to transfer control of the contract to a newOwner.
71      * @param newOwner The address to transfer ownership to.
72      */
73     function transferOwnership(address newOwner) onlyOwner public {
74         require(newOwner != address(0));
75         OwnershipTransferred(owner, newOwner);
76         owner = newOwner;
77     }
78 }
79 
80 /**
81  * @title ERC223
82  * @dev ERC223 contract interface with ERC20 functions and events
83  *      Fully backward compatible with ERC20
84  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
85  */
86 contract ERC223 {
87     uint public totalSupply;
88 
89     // ERC223 and ERC20 functions and events
90     function balanceOf(address who) public view returns (uint);
91     function totalSupply() public view returns (uint256 _supply);
92     function transfer(address to, uint value) public returns (bool ok);
93     function transfer(address to, uint value, bytes data) public returns (bool ok);
94     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
95     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
96 
97     // ERC223 functions
98     function name() public view returns (string _name);
99     function symbol() public view returns (string _symbol);
100     function decimals() public view returns (uint8 _decimals);
101 
102     // ERC20 functions and events
103     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
104     function approve(address _spender, uint256 _value) public returns (bool success);
105     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
106     event Transfer(address indexed _from, address indexed _to, uint256 _value);
107     event Approval(address indexed _owner, address indexed _spender, uint _value);
108 }
109 
110 
111 
112 /**
113  * @title ContractReceiver
114  * @dev Contract that is working with ERC223 tokens
115  */
116  contract ContractReceiver {
117 
118     struct TKN {
119         address sender;
120         uint value;
121         bytes data;
122         bytes4 sig;
123     }
124 
125     function tokenFallback(address _from, uint _value, bytes _data) public pure {
126         TKN memory tkn;
127         tkn.sender = _from;
128         tkn.value = _value;
129         tkn.data = _data;
130         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
131         tkn.sig = bytes4(u);
132         
133         /*
134          * tkn variable is analogue of msg variable of Ether transaction
135          * tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
136          * tkn.value the number of tokens that were sent   (analogue of msg.value)
137          * tkn.data is data of token transaction   (analogue of msg.data)
138          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
139          */
140     }
141 }
142 
143 /**
144  * @title DIETCoin
145  * @author BLACK DIA COIN TEAM
146  * @dev DIETCoin is an ERC223 Token with ERC20 functions and events
147  *      Fully backward compatible with ERC20
148  */
149 contract DIETCoin is ERC223, Ownable {
150     using SafeMath for uint256;
151 
152     string public name = "Diet Coin";
153     string public symbol = "DIET";
154     uint8 public decimals = 8;
155     uint256 public totalSupply = 1e10 * 2e8;
156     uint256 public distributeAmount = 0;
157     bool public mintingFinished = false;
158     
159     mapping(address => uint256) public balanceOf;
160     mapping(address => mapping (address => uint256)) public allowance;
161     mapping (address => bool) public frozenAccount;
162     mapping (address => uint256) public unlockUnixTime;
163     
164     event FrozenFunds(address indexed target, bool frozen);
165     event LockedFunds(address indexed target, uint256 locked);
166     event Burn(address indexed from, uint256 amount);
167     event Mint(address indexed to, uint256 amount);
168     event MintFinished();
169 
170     /** 
171      * @dev Constructor is called only once and can not be called again
172      */
173     function DIETCoin() public {
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
198     /**
199      * @dev Prevent targets from sending or receiving tokens
200      * @param targets Addresses to be frozen
201      * @param isFrozen either to freeze it or not
202      */
203     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
204         require(targets.length > 0);
205 
206         for (uint j = 0; j < targets.length; j++) {
207             require(targets[j] != 0x0);
208             frozenAccount[targets[j]] = isFrozen;
209             FrozenFunds(targets[j], isFrozen);
210         }
211     }
212 
213     /**
214      * @dev Prevent targets from sending or receiving tokens by setting Unix times
215      * @param targets Addresses to be locked funds
216      * @param unixTimes Unix times when locking up will be finished
217      */
218     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
219         require(targets.length > 0
220                 && targets.length == unixTimes.length);
221                 
222         for(uint j = 0; j < targets.length; j++){
223             require(unlockUnixTime[targets[j]] < unixTimes[j]);
224             unlockUnixTime[targets[j]] = unixTimes[j];
225             LockedFunds(targets[j], unixTimes[j]);
226         }
227     }
228 
229     /**
230      * @dev Function that is called when a user or another contract wants to transfer funds
231      */
232     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
233         require(_value > 0
234                 && frozenAccount[msg.sender] == false 
235                 && frozenAccount[_to] == false
236                 && now > unlockUnixTime[msg.sender] 
237                 && now > unlockUnixTime[_to]);
238 
239         if (isContract(_to)) {
240             require(balanceOf[msg.sender] >= _value);
241             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
242             balanceOf[_to] = balanceOf[_to].add(_value);
243             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
244             Transfer(msg.sender, _to, _value, _data);
245             Transfer(msg.sender, _to, _value);
246             return true;
247         } else {
248             return transferToAddress(_to, _value, _data);
249         }
250     }
251 
252     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
253         require(_value > 0
254                 && frozenAccount[msg.sender] == false 
255                 && frozenAccount[_to] == false
256                 && now > unlockUnixTime[msg.sender] 
257                 && now > unlockUnixTime[_to]);
258 
259         if (isContract(_to)) {
260             return transferToContract(_to, _value, _data);
261         } else {
262             return transferToAddress(_to, _value, _data);
263         }
264     }
265 
266     /**
267      * @dev Standard function transfer similar to ERC20 transfer with no _data
268      *      Added due to backwards compatibility reasons
269      */
270     function transfer(address _to, uint _value) public returns (bool success) {
271         require(_value > 0
272                 && frozenAccount[msg.sender] == false 
273                 && frozenAccount[_to] == false
274                 && now > unlockUnixTime[msg.sender] 
275                 && now > unlockUnixTime[_to]);
276 
277         bytes memory empty;
278         if (isContract(_to)) {
279             return transferToContract(_to, _value, empty);
280         } else {
281             return transferToAddress(_to, _value, empty);
282         }
283     }
284 
285     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
286     function isContract(address _addr) private view returns (bool is_contract) {
287         uint length;
288         assembly {
289             //retrieve the size of the code on target address, this needs assembly
290             length := extcodesize(_addr)
291         }
292         return (length > 0);
293     }
294 
295     // function that is called when transaction target is an address
296     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
297         require(balanceOf[msg.sender] >= _value);
298         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
299         balanceOf[_to] = balanceOf[_to].add(_value);
300         Transfer(msg.sender, _to, _value, _data);
301         Transfer(msg.sender, _to, _value);
302         return true;
303     }
304 
305     // function that is called when transaction target is a contract
306     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
307         require(balanceOf[msg.sender] >= _value);
308         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
309         balanceOf[_to] = balanceOf[_to].add(_value);
310         ContractReceiver receiver = ContractReceiver(_to);
311         receiver.tokenFallback(msg.sender, _value, _data);
312         Transfer(msg.sender, _to, _value, _data);
313         Transfer(msg.sender, _to, _value);
314         return true;
315     }
316 
317     /**
318      * @dev Transfer tokens from one address to another
319      *      Added due to backwards compatibility with ERC20
320      * @param _from address The address which you want to send tokens from
321      * @param _to address The address which you want to transfer to
322      * @param _value uint256 the amount of tokens to be transferred
323      */
324     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
325         require(_to != address(0)
326                 && _value > 0
327                 && balanceOf[_from] >= _value
328                 && allowance[_from][msg.sender] >= _value
329                 && frozenAccount[_from] == false 
330                 && frozenAccount[_to] == false
331                 && now > unlockUnixTime[_from] 
332                 && now > unlockUnixTime[_to]);
333 
334         balanceOf[_from] = balanceOf[_from].sub(_value);
335         balanceOf[_to] = balanceOf[_to].add(_value);
336         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
337         Transfer(_from, _to, _value);
338         return true;
339     }
340 
341     /**
342      * @dev Allows _spender to spend no more than _value tokens in your behalf
343      *      Added due to backwards compatibility with ERC20
344      * @param _spender The address authorized to spend
345      * @param _value the max amount they can spend
346      */
347     function approve(address _spender, uint256 _value) public returns (bool success) {
348         allowance[msg.sender][_spender] = _value;
349         Approval(msg.sender, _spender, _value);
350         return true;
351     }
352 
353     /**
354      * @dev Function to check the amount of tokens that an owner allowed to a spender
355      *      Added due to backwards compatibility with ERC20
356      * @param _owner address The address which owns the funds
357      * @param _spender address The address which will spend the funds
358      */
359     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
360         return allowance[_owner][_spender];
361     }
362 
363     /**
364      * @dev Burns a specific amount of tokens.
365      * @param _from The address that will burn the tokens.
366      * @param _unitAmount The amount of token to be burned.
367      */
368     function burn(address _from, uint256 _unitAmount) onlyOwner public {
369         require(_unitAmount > 0
370                 && balanceOf[_from] >= _unitAmount);
371 
372         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
373         totalSupply = totalSupply.sub(_unitAmount);
374         Burn(_from, _unitAmount);
375     }
376 
377     modifier canMint() {
378         require(!mintingFinished);
379         _;
380     }
381 
382     /**
383      * @dev Function to mint tokens
384      * @param _to The address that will receive the minted tokens.
385      * @param _unitAmount The amount of tokens to mint.
386      */
387     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
388         require(_unitAmount > 0);
389         
390         totalSupply = totalSupply.add(_unitAmount);
391         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
392         Mint(_to, _unitAmount);
393         Transfer(address(0), _to, _unitAmount);
394         return true;
395     }
396 
397     /**
398      * @dev Function to stop minting new tokens.
399      */
400     function finishMinting() onlyOwner canMint public returns (bool) {
401         mintingFinished = true;
402         MintFinished();
403         return true;
404     }
405 
406     /**
407      * @dev Function to distribute tokens to the list of addresses by the provided amount
408      */
409     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
410         require(amount > 0 
411                 && addresses.length > 0
412                 && frozenAccount[msg.sender] == false
413                 && now > unlockUnixTime[msg.sender]);
414 
415         amount = amount.mul(1e8);
416         uint256 totalAmount = amount.mul(addresses.length);
417         require(balanceOf[msg.sender] >= totalAmount);
418         
419         for (uint j = 0; j < addresses.length; j++) {
420             require(addresses[j] != 0x0
421                     && frozenAccount[addresses[j]] == false
422                     && now > unlockUnixTime[addresses[j]]);
423 
424             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
425             Transfer(msg.sender, addresses[j], amount);
426         }
427         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
428         return true;
429     }
430 
431     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
432         require(addresses.length > 0
433                 && addresses.length == amounts.length
434                 && frozenAccount[msg.sender] == false
435                 && now > unlockUnixTime[msg.sender]);
436                 
437         uint256 totalAmount = 0;
438         
439         for(uint j = 0; j < addresses.length; j++){
440             require(amounts[j] > 0
441                     && addresses[j] != 0x0
442                     && frozenAccount[addresses[j]] == false
443                     && now > unlockUnixTime[addresses[j]]);
444                     
445             amounts[j] = amounts[j].mul(1e8);
446             totalAmount = totalAmount.add(amounts[j]);
447         }
448         require(balanceOf[msg.sender] >= totalAmount);
449         
450         for (j = 0; j < addresses.length; j++) {
451             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
452             Transfer(msg.sender, addresses[j], amounts[j]);
453         }
454         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
455         return true;
456     }
457 
458     /**
459      * @dev Function to collect tokens from the list of addresses
460      */
461     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
462         require(addresses.length > 0
463                 && addresses.length == amounts.length);
464 
465         uint256 totalAmount = 0;
466         
467         for (uint j = 0; j < addresses.length; j++) {
468             require(amounts[j] > 0
469                     && addresses[j] != 0x0
470                     && frozenAccount[addresses[j]] == false
471                     && now > unlockUnixTime[addresses[j]]);
472                     
473             amounts[j] = amounts[j].mul(1e8);
474             require(balanceOf[addresses[j]] >= amounts[j]);
475             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
476             totalAmount = totalAmount.add(amounts[j]);
477             Transfer(addresses[j], msg.sender, amounts[j]);
478         }
479         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
480         return true;
481     }
482 
483     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
484         distributeAmount = _unitAmount;
485     }
486     
487     /**
488      * @dev Function to distribute tokens to the msg.sender automatically
489      *      If distributeAmount is 0, this function doesn't work
490      */
491     function autoDistribute() payable public {
492         require(distributeAmount > 0
493                 && balanceOf[owner] >= distributeAmount
494                 && frozenAccount[msg.sender] == false
495                 && now > unlockUnixTime[msg.sender]);
496         if(msg.value > 0) owner.transfer(msg.value);
497         
498         balanceOf[owner] = balanceOf[owner].sub(distributeAmount);
499         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
500         Transfer(owner, msg.sender, distributeAmount);
501     }
502     
503     /**
504      * @dev fallback function
505      */
506     function() payable public {
507         autoDistribute();
508     }
509 }