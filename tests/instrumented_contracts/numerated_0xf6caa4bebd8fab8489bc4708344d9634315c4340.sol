1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title BDACoin
5  * @author BDACoin
6  * @dev BDACoin is an ERC223 Token with ERC20 functions and events
7  *      Fully backward compatible with ERC20
8  */
9 
10 
11 /**
12  * @title SafeMath
13  * @dev Math operations with safety checks that throw on error
14  */
15 library SafeMath {
16     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17         if (a == 0) {
18             return 0;
19         }
20         uint256 c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         assert(b <= a);
34         return a - b;
35     }
36 
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         assert(c >= a);
40         return c;
41     }
42 }
43 
44 
45 
46 /**
47  * @title Ownable
48  * @dev The Ownable contract has an owner address, and provides basic authorization
49  *      control functions, this simplifies the implementation of "user permissions".
50  */
51 contract Ownable {
52     address public owner;
53 
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56     /**
57      * @dev The Ownable constructor sets the original `owner` of the contract to the
58      *      sender account.
59      */
60     function Ownable() public {
61         owner = msg.sender;
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(msg.sender == owner);
69         _;
70     }
71 
72     /**
73      * @dev Allows the current owner to transfer control of the contract to a newOwner.
74      * @param newOwner The address to transfer ownership to.
75      */
76     function transferOwnership(address newOwner) onlyOwner public {
77         require(newOwner != address(0));
78         OwnershipTransferred(owner, newOwner);
79         owner = newOwner;
80     }
81 }
82 
83 
84 
85 /**
86  * å½¡(^)(^)
87  * @title ERC223
88  * @dev ERC223 contract interface with ERC20 functions and events
89  *      Fully backward compatible with ERC20
90  *      Recommended implementation used at https://github.com/Dexaran/ERC223-token-standard/tree/Recommended
91  */
92 contract ERC223 {
93     uint public totalSupply;
94 
95     // ERC223 and ERC20 functions and events
96     function balanceOf(address who) public view returns (uint);
97     function totalSupply() public view returns (uint256 _supply);
98     function transfer(address to, uint value) public returns (bool ok);
99     function transfer(address to, uint value, bytes data) public returns (bool ok);
100     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
101     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
102 
103     // ERC223 functions
104     function name() public view returns (string _name);
105     function symbol() public view returns (string _symbol);
106     function decimals() public view returns (uint8 _decimals);
107 
108     // ERC20 functions and events
109     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
110     function approve(address _spender, uint256 _value) public returns (bool success);
111     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
112     event Transfer(address indexed _from, address indexed _to, uint256 _value);
113     event Approval(address indexed _owner, address indexed _spender, uint _value);
114 }
115 
116 
117 
118 /**
119  * @title ContractReceiver
120  * @dev Contract that is working with ERC223 tokens
121  */
122  contract ContractReceiver {
123 
124     struct TKN {
125         address sender;
126         uint value;
127         bytes data;
128         bytes4 sig;
129     }
130 
131     function tokenFallback(address _from, uint _value, bytes _data) public pure {
132         TKN memory tkn;
133         tkn.sender = _from;
134         tkn.value = _value;
135         tkn.data = _data;
136         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
137         tkn.sig = bytes4(u);
138         
139         /*
140          * tkn variable is analogue of msg variable of Ether transaction
141          * tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
142          * tkn.value the number of tokens that were sent   (analogue of msg.value)
143          * tkn.data is data of token transaction   (analogue of msg.data)
144          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
145          */
146     }
147 }
148 
149 
150 /**
151  * @title BDACoin
152  * @author BLACK DIA COIN TEAM
153  * @dev BDACoin is an ERC223 Token with ERC20 functions and events
154  *      Fully backward compatible with ERC20
155  */
156 contract BDACoin is ERC223, Ownable {
157     using SafeMath for uint256;
158 
159     string public name = "BLACK DIA COIN";
160     string public symbol = "BDA";
161     string public constant AAcontributors = "BLACK DIA COIN TEAM";
162     uint8 public decimals = 8;
163     uint256 public totalSupply = 1e10 * 4e8;
164     uint256 public distributeAmount = 0;
165     bool public mintingFinished = false;
166     
167     mapping(address => uint256) public balanceOf;
168     mapping(address => mapping (address => uint256)) public allowance;
169     mapping (address => bool) public frozenAccount;
170     mapping (address => uint256) public unlockUnixTime;
171     
172     event FrozenFunds(address indexed target, bool frozen);
173     event LockedFunds(address indexed target, uint256 locked);
174     event Burn(address indexed from, uint256 amount);
175     event Mint(address indexed to, uint256 amount);
176     event MintFinished();
177 
178 
179     /** 
180      * @dev Constructor is called only once and can not be called again
181      */
182     function BDACoin() public {
183         balanceOf[msg.sender] = totalSupply;
184     }
185 
186 
187     function name() public view returns (string _name) {
188         return name;
189     }
190 
191     function symbol() public view returns (string _symbol) {
192         return symbol;
193     }
194 
195     function decimals() public view returns (uint8 _decimals) {
196         return decimals;
197     }
198 
199     function totalSupply() public view returns (uint256 _totalSupply) {
200         return totalSupply;
201     }
202 
203     function balanceOf(address _owner) public view returns (uint256 balance) {
204         return balanceOf[_owner];
205     }
206 
207 
208     /**
209      * @dev Prevent targets from sending or receiving tokens
210      * @param targets Addresses to be frozen
211      * @param isFrozen either to freeze it or not
212      */
213     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
214         require(targets.length > 0);
215 
216         for (uint j = 0; j < targets.length; j++) {
217             require(targets[j] != 0x0);
218             frozenAccount[targets[j]] = isFrozen;
219             FrozenFunds(targets[j], isFrozen);
220         }
221     }
222 
223     /**
224      * @dev Prevent targets from sending or receiving tokens by setting Unix times
225      * @param targets Addresses to be locked funds
226      * @param unixTimes Unix times when locking up will be finished
227      */
228     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
229         require(targets.length > 0
230                 && targets.length == unixTimes.length);
231                 
232         for(uint j = 0; j < targets.length; j++){
233             require(unlockUnixTime[targets[j]] < unixTimes[j]);
234             unlockUnixTime[targets[j]] = unixTimes[j];
235             LockedFunds(targets[j], unixTimes[j]);
236         }
237     }
238 
239 
240     /**
241      * @dev Function that is called when a user or another contract wants to transfer funds
242      */
243     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
244         require(_value > 0
245                 && frozenAccount[msg.sender] == false 
246                 && frozenAccount[_to] == false
247                 && now > unlockUnixTime[msg.sender] 
248                 && now > unlockUnixTime[_to]);
249 
250         if (isContract(_to)) {
251             require(balanceOf[msg.sender] >= _value);
252             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
253             balanceOf[_to] = balanceOf[_to].add(_value);
254             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
255             Transfer(msg.sender, _to, _value, _data);
256             Transfer(msg.sender, _to, _value);
257             return true;
258         } else {
259             return transferToAddress(_to, _value, _data);
260         }
261     }
262 
263     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
264         require(_value > 0
265                 && frozenAccount[msg.sender] == false 
266                 && frozenAccount[_to] == false
267                 && now > unlockUnixTime[msg.sender] 
268                 && now > unlockUnixTime[_to]);
269 
270         if (isContract(_to)) {
271             return transferToContract(_to, _value, _data);
272         } else {
273             return transferToAddress(_to, _value, _data);
274         }
275     }
276 
277     /**
278      * @dev Standard function transfer similar to ERC20 transfer with no _data
279      *      Added due to backwards compatibility reasons
280      */
281     function transfer(address _to, uint _value) public returns (bool success) {
282         require(_value > 0
283                 && frozenAccount[msg.sender] == false 
284                 && frozenAccount[_to] == false
285                 && now > unlockUnixTime[msg.sender] 
286                 && now > unlockUnixTime[_to]);
287 
288         bytes memory empty;
289         if (isContract(_to)) {
290             return transferToContract(_to, _value, empty);
291         } else {
292             return transferToAddress(_to, _value, empty);
293         }
294     }
295 
296     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
297     function isContract(address _addr) private view returns (bool is_contract) {
298         uint length;
299         assembly {
300             //retrieve the size of the code on target address, this needs assembly
301             length := extcodesize(_addr)
302         }
303         return (length > 0);
304     }
305 
306     // function that is called when transaction target is an address
307     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
308         require(balanceOf[msg.sender] >= _value);
309         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
310         balanceOf[_to] = balanceOf[_to].add(_value);
311         Transfer(msg.sender, _to, _value, _data);
312         Transfer(msg.sender, _to, _value);
313         return true;
314     }
315 
316     // function that is called when transaction target is a contract
317     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
318         require(balanceOf[msg.sender] >= _value);
319         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
320         balanceOf[_to] = balanceOf[_to].add(_value);
321         ContractReceiver receiver = ContractReceiver(_to);
322         receiver.tokenFallback(msg.sender, _value, _data);
323         Transfer(msg.sender, _to, _value, _data);
324         Transfer(msg.sender, _to, _value);
325         return true;
326     }
327 
328 
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
376 
377 
378     /**
379      * @dev Burns a specific amount of tokens.
380      * @param _from The address that will burn the tokens.
381      * @param _unitAmount The amount of token to be burned.
382      */
383     function burn(address _from, uint256 _unitAmount) onlyOwner public {
384         require(_unitAmount > 0
385                 && balanceOf[_from] >= _unitAmount);
386 
387         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
388         totalSupply = totalSupply.sub(_unitAmount);
389         Burn(_from, _unitAmount);
390     }
391 
392 
393     modifier canMint() {
394         require(!mintingFinished);
395         _;
396     }
397 
398     /**
399      * @dev Function to mint tokens
400      * @param _to The address that will receive the minted tokens.
401      * @param _unitAmount The amount of tokens to mint.
402      */
403     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
404         require(_unitAmount > 0);
405         
406         totalSupply = totalSupply.add(_unitAmount);
407         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
408         Mint(_to, _unitAmount);
409         Transfer(address(0), _to, _unitAmount);
410         return true;
411     }
412 
413     /**
414      * @dev Function to stop minting new tokens.
415      */
416     function finishMinting() onlyOwner canMint public returns (bool) {
417         mintingFinished = true;
418         MintFinished();
419         return true;
420     }
421 
422 
423 
424     /**
425      * @dev Function to distribute tokens to the list of addresses by the provided amount
426      */
427     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
428         require(amount > 0 
429                 && addresses.length > 0
430                 && frozenAccount[msg.sender] == false
431                 && now > unlockUnixTime[msg.sender]);
432 
433         amount = amount.mul(1e8);
434         uint256 totalAmount = amount.mul(addresses.length);
435         require(balanceOf[msg.sender] >= totalAmount);
436         
437         for (uint j = 0; j < addresses.length; j++) {
438             require(addresses[j] != 0x0
439                     && frozenAccount[addresses[j]] == false
440                     && now > unlockUnixTime[addresses[j]]);
441 
442             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
443             Transfer(msg.sender, addresses[j], amount);
444         }
445         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
446         return true;
447     }
448 
449     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
450         require(addresses.length > 0
451                 && addresses.length == amounts.length
452                 && frozenAccount[msg.sender] == false
453                 && now > unlockUnixTime[msg.sender]);
454                 
455         uint256 totalAmount = 0;
456         
457         for(uint j = 0; j < addresses.length; j++){
458             require(amounts[j] > 0
459                     && addresses[j] != 0x0
460                     && frozenAccount[addresses[j]] == false
461                     && now > unlockUnixTime[addresses[j]]);
462                     
463             amounts[j] = amounts[j].mul(1e8);
464             totalAmount = totalAmount.add(amounts[j]);
465         }
466         require(balanceOf[msg.sender] >= totalAmount);
467         
468         for (j = 0; j < addresses.length; j++) {
469             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
470             Transfer(msg.sender, addresses[j], amounts[j]);
471         }
472         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
473         return true;
474     }
475 
476     /**
477      * @dev Function to collect tokens from the list of addresses
478      */
479     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
480         require(addresses.length > 0
481                 && addresses.length == amounts.length);
482 
483         uint256 totalAmount = 0;
484         
485         for (uint j = 0; j < addresses.length; j++) {
486             require(amounts[j] > 0
487                     && addresses[j] != 0x0
488                     && frozenAccount[addresses[j]] == false
489                     && now > unlockUnixTime[addresses[j]]);
490                     
491             amounts[j] = amounts[j].mul(1e8);
492             require(balanceOf[addresses[j]] >= amounts[j]);
493             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
494             totalAmount = totalAmount.add(amounts[j]);
495             Transfer(addresses[j], msg.sender, amounts[j]);
496         }
497         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
498         return true;
499     }
500 
501 
502     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
503         distributeAmount = _unitAmount;
504     }
505     
506     /**
507      * @dev Function to distribute tokens to the msg.sender automatically
508      *      If distributeAmount is 0, this function doesn't work
509      */
510     function autoDistribute() payable public {
511         require(distributeAmount > 0
512                 && balanceOf[owner] >= distributeAmount
513                 && frozenAccount[msg.sender] == false
514                 && now > unlockUnixTime[msg.sender]);
515         if(msg.value > 0) owner.transfer(msg.value);
516         
517         balanceOf[owner] = balanceOf[owner].sub(distributeAmount);
518         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
519         Transfer(owner, msg.sender, distributeAmount);
520     }
521     
522     /**
523      * @dev fallback function
524      */
525     function() payable public {
526         autoDistribute();
527      }
528 
529 }