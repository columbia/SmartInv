1 pragma solidity ^0.4.24;
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
38 
39 /**
40  * @title Ownable
41  * @dev The Ownable contract has an owner address, and provides basic authorization
42  *      control functions, this simplifies the implementation of "user permissions".
43  */
44 contract Ownable {
45     address public owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev The Ownable constructor sets the original `owner` of the contract to the
51      *      sender account.
52      */
53     function Ownable() public {
54         owner = msg.sender;
55     }
56 
57     /**
58      * @dev Throws if called by any account other than the owner.
59      */
60     modifier onlyOwner() {
61         require(msg.sender == owner);
62         _;
63     }
64 
65     /**
66      * @dev Allows the current owner to transfer control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function transferOwnership(address newOwner) onlyOwner public {
70         require(newOwner != address(0));
71         OwnershipTransferred(owner, newOwner);
72         owner = newOwner;
73     }
74 }
75 
76 
77 
78 /**
79  * 彡(^)(^)
80  * @title ERC223
81  * @dev ERC223 contract interface with ERC20 functions and events
82  *      Fully backward compatible with ERC20
83  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
84  */
85 contract ERC223 {
86     uint public totalSupply;
87 
88     // ERC223 and ERC20 functions and events
89     function balanceOf(address who) public view returns (uint);
90     function totalSupply() public view returns (uint256 _supply);
91     function transfer(address to, uint value) public returns (bool ok);
92     function transfer(address to, uint value, bytes data) public returns (bool ok);
93     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
94     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
95 
96     // ERC223 functions
97     function name() public view returns (string _name);
98     function symbol() public view returns (string _symbol);
99     function decimals() public view returns (uint8 _decimals);
100 
101     // ERC20 functions and events
102     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
103     function approve(address _spender, uint256 _value) public returns (bool success);
104     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
105     event Transfer(address indexed _from, address indexed _to, uint256 _value);
106     event Approval(address indexed _owner, address indexed _spender, uint _value);
107 }
108 
109 
110 
111 /**
112  * @title ContractReceiver
113  * @dev Contract that is working with ERC223 tokens
114  */
115  contract ContractReceiver {
116 
117     struct TKN {
118         address sender;
119         uint value;
120         bytes data;
121         bytes4 sig;
122     }
123 
124     function tokenFallback(address _from, uint _value, bytes _data) public pure {
125         TKN memory tkn;
126         tkn.sender = _from;
127         tkn.value = _value;
128         tkn.data = _data;
129         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
130         tkn.sig = bytes4(u);
131         
132         /*
133          * tkn variable is analogue of msg variable of Ether transaction
134          * tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
135          * tkn.value the number of tokens that were sent   (analogue of msg.value)
136          * tkn.data is data of token transaction   (analogue of msg.data)
137          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
138          */
139     }
140 }
141 
142 
143 /**
144  * @title Petcoin
145  */
146 contract Petcoin is ERC223, Ownable {
147     using SafeMath for uint256;
148 
149     string public name = "Petcoin";
150     string public symbol = "PET";
151     uint8 public decimals = 8;
152     uint256 public totalSupply = 30e9 * 1e8;
153     uint256 public distributeAmount = 0;
154     bool public mintingFinished = false;
155     
156 
157     mapping(address => uint256) public balanceOf;
158     mapping(address => mapping (address => uint256)) public allowance;
159     mapping (address => bool) public frozenAccount;
160     mapping (address => uint256) public unlockUnixTime;
161     
162     event FrozenFunds(address indexed target, bool frozen);
163     event LockedFunds(address indexed target, uint256 locked);
164     event Burn(address indexed from, uint256 amount);
165     event Mint(address indexed to, uint256 amount);
166     event MintFinished();
167 
168 
169     /** 
170      * @dev Constructor is called only once and can not be called again
171      */
172     function Petcoin() public {
173         balanceOf[msg.sender] = totalSupply;
174     }
175 
176 
177     function name() public view returns (string _name) {
178         return name;
179     }
180 
181     function symbol() public view returns (string _symbol) {
182         return symbol;
183     }
184 
185     function decimals() public view returns (uint8 _decimals) {
186         return decimals;
187     }
188 
189     function totalSupply() public view returns (uint256 _totalSupply) {
190         return totalSupply;
191     }
192 
193     function balanceOf(address _owner) public view returns (uint256 balance) {
194         return balanceOf[_owner];
195     }
196 
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
229 
230     /**
231      * @dev Function that is called when a user or another contract wants to transfer funds
232      */
233     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
234         require(_value > 0
235                 && frozenAccount[msg.sender] == false 
236                 && frozenAccount[_to] == false
237                 && now > unlockUnixTime[msg.sender] 
238                 && now > unlockUnixTime[_to]);
239 
240         if (isContract(_to)) {
241             require(balanceOf[msg.sender] >= _value);
242             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
243             balanceOf[_to] = balanceOf[_to].add(_value);
244             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
245             Transfer(msg.sender, _to, _value, _data);
246             Transfer(msg.sender, _to, _value);
247             return true;
248         } else {
249             return transferToAddress(_to, _value, _data);
250         }
251     }
252 
253     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
254         require(_value > 0
255                 && frozenAccount[msg.sender] == false 
256                 && frozenAccount[_to] == false
257                 && now > unlockUnixTime[msg.sender] 
258                 && now > unlockUnixTime[_to]);
259 
260         if (isContract(_to)) {
261             return transferToContract(_to, _value, _data);
262         } else {
263             return transferToAddress(_to, _value, _data);
264         }
265     }
266 
267     /**
268      * @dev Standard function transfer similar to ERC20 transfer with no _data
269      *      Added due to backwards compatibility reasons
270      */
271     function transfer(address _to, uint _value) public returns (bool success) {
272         require(_value > 0
273                 && frozenAccount[msg.sender] == false 
274                 && frozenAccount[_to] == false
275                 && now > unlockUnixTime[msg.sender] 
276                 && now > unlockUnixTime[_to]);
277 
278         bytes memory empty;
279         if (isContract(_to)) {
280             return transferToContract(_to, _value, empty);
281         } else {
282             return transferToAddress(_to, _value, empty);
283         }
284     }
285 
286     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
287     function isContract(address _addr) private view returns (bool is_contract) {
288         uint length;
289         assembly {
290             //retrieve the size of the code on target address, this needs assembly
291             length := extcodesize(_addr)
292         }
293         return (length > 0);
294     }
295 
296     // function that is called when transaction target is an address
297     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
298         require(balanceOf[msg.sender] >= _value);
299         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
300         balanceOf[_to] = balanceOf[_to].add(_value);
301         Transfer(msg.sender, _to, _value, _data);
302         Transfer(msg.sender, _to, _value);
303         return true;
304     }
305 
306     // function that is called when transaction target is a contract
307     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
308         require(balanceOf[msg.sender] >= _value);
309         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
310         balanceOf[_to] = balanceOf[_to].add(_value);
311         ContractReceiver receiver = ContractReceiver(_to);
312         receiver.tokenFallback(msg.sender, _value, _data);
313         Transfer(msg.sender, _to, _value, _data);
314         Transfer(msg.sender, _to, _value);
315         return true;
316     }
317 
318 
319 
320     /**
321      * @dev Transfer tokens from one address to another
322      *      Added due to backwards compatibility with ERC20
323      * @param _from address The address which you want to send tokens from
324      * @param _to address The address which you want to transfer to
325      * @param _value uint256 the amount of tokens to be transferred
326      */
327     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
328         require(_to != address(0)
329                 && _value > 0
330                 && balanceOf[_from] >= _value
331                 && allowance[_from][msg.sender] >= _value
332                 && frozenAccount[_from] == false 
333                 && frozenAccount[_to] == false
334                 && now > unlockUnixTime[_from] 
335                 && now > unlockUnixTime[_to]);
336 
337         balanceOf[_from] = balanceOf[_from].sub(_value);
338         balanceOf[_to] = balanceOf[_to].add(_value);
339         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
340         Transfer(_from, _to, _value);
341         return true;
342     }
343 
344     /**
345      * @dev Allows _spender to spend no more than _value tokens in your behalf
346      *      Added due to backwards compatibility with ERC20
347      * @param _spender The address authorized to spend
348      * @param _value the max amount they can spend
349      */
350     function approve(address _spender, uint256 _value) public returns (bool success) {
351         allowance[msg.sender][_spender] = _value;
352         Approval(msg.sender, _spender, _value);
353         return true;
354     }
355 
356     /**
357      * @dev Function to check the amount of tokens that an owner allowed to a spender
358      *      Added due to backwards compatibility with ERC20
359      * @param _owner address The address which owns the funds
360      * @param _spender address The address which will spend the funds
361      */
362     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
363         return allowance[_owner][_spender];
364     }
365 
366 
367 
368     /**
369      * @dev Burns a specific amount of tokens.
370      * @param _from The address that will burn the tokens.
371      * @param _unitAmount The amount of token to be burned.
372      */
373     function burn(address _from, uint256 _unitAmount) onlyOwner public {
374         require(_unitAmount > 0
375                 && balanceOf[_from] >= _unitAmount);
376 
377         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
378         totalSupply = totalSupply.sub(_unitAmount);
379         Burn(_from, _unitAmount);
380     }
381 
382 
383     modifier canMint() {
384         require(!mintingFinished);
385         _;
386     }
387 
388     /**
389      * @dev Function to mint tokens
390      * @param _to The address that will receive the minted tokens.
391      * @param _unitAmount The amount of tokens to mint.
392      */
393     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
394         require(_unitAmount > 0);
395         
396         totalSupply = totalSupply.add(_unitAmount);
397         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
398         Mint(_to, _unitAmount);
399         Transfer(address(0), _to, _unitAmount);
400         return true;
401     }
402 
403     /**
404      * @dev Function to stop minting new tokens.
405      */
406     function finishMinting() onlyOwner canMint public returns (bool) {
407         mintingFinished = true;
408         MintFinished();
409         return true;
410     }
411 
412 
413 
414     /**
415      * @dev Function to distribute tokens to the list of addresses by the provided amount
416      */
417     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
418         require(amount > 0 
419                 && addresses.length > 0
420                 && frozenAccount[msg.sender] == false
421                 && now > unlockUnixTime[msg.sender]);
422 
423         amount = amount.mul(1e8);
424         uint256 totalAmount = amount.mul(addresses.length);
425         require(balanceOf[msg.sender] >= totalAmount);
426         
427         for (uint j = 0; j < addresses.length; j++) {
428             require(addresses[j] != 0x0
429                     && frozenAccount[addresses[j]] == false
430                     && now > unlockUnixTime[addresses[j]]);
431 
432             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
433             Transfer(msg.sender, addresses[j], amount);
434         }
435         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
436         return true;
437     }
438 
439     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
440         require(addresses.length > 0
441                 && addresses.length == amounts.length
442                 && frozenAccount[msg.sender] == false
443                 && now > unlockUnixTime[msg.sender]);
444                 
445         uint256 totalAmount = 0;
446         
447         for(uint j = 0; j < addresses.length; j++){
448             require(amounts[j] > 0
449                     && addresses[j] != 0x0
450                     && frozenAccount[addresses[j]] == false
451                     && now > unlockUnixTime[addresses[j]]);
452                     
453             amounts[j] = amounts[j].mul(1e8);
454             totalAmount = totalAmount.add(amounts[j]);
455         }
456         require(balanceOf[msg.sender] >= totalAmount);
457         
458         for (j = 0; j < addresses.length; j++) {
459             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
460             Transfer(msg.sender, addresses[j], amounts[j]);
461         }
462         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
463         return true;
464     }
465 
466     /**
467      * @dev Function to collect tokens from the list of addresses
468      */
469     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
470         require(addresses.length > 0
471                 && addresses.length == amounts.length);
472 
473         uint256 totalAmount = 0;
474         
475         for (uint j = 0; j < addresses.length; j++) {
476             require(amounts[j] > 0
477                     && addresses[j] != 0x0
478                     && frozenAccount[addresses[j]] == false
479                     && now > unlockUnixTime[addresses[j]]);
480                     
481             amounts[j] = amounts[j].mul(1e8);
482             require(balanceOf[addresses[j]] >= amounts[j]);
483             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
484             totalAmount = totalAmount.add(amounts[j]);
485             Transfer(addresses[j], msg.sender, amounts[j]);
486         }
487         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
488         return true;
489     }
490 
491 
492     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
493         distributeAmount = _unitAmount;
494     }
495     
496 
497 
498     /**
499      * @dev fallback function
500      */
501     function() payable public {
502 
503      }
504 
505 }