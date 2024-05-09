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
53     constructor() public {
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
71         emit OwnershipTransferred(owner, newOwner);
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
142 /**
143  * 彡(ﾟ)(ﾟ)
144  * @title RUCCOIN
145  * @author Takuya Kondo
146  * @dev RUCCOIN is an ERC223 Token with ERC20 functions and events
147  *      Fully backward compatible with ERC20
148  */
149 contract RUCCOIN is ERC223, Ownable {
150     using SafeMath for uint256;
151 
152     string public name = "RUCCOIN";
153     string public symbol = "RUC";
154     uint8 public decimals = 8;
155     uint256 public totalSupply = 20000000000000000000;
156     uint256 public distributeAmount = 0;
157     bool public mintingFinished = false;
158     
159     address public founder = 0x47724565d4d3a44ea413a6a3714240d4743af591;
160 
161     mapping(address => uint256) public balanceOf;
162     mapping(address => mapping (address => uint256)) public allowance;
163     mapping (address => bool) public frozenAccount;
164     mapping (address => uint256) public unlockUnixTime;
165     
166     event FrozenFunds(address indexed target, bool frozen);
167     event LockedFunds(address indexed target, uint256 locked);
168     event Burn(address indexed from, uint256 amount);
169     event Mint(address indexed to, uint256 amount);
170     event MintFinished();
171 
172 
173     /** 
174      * @dev Constructor is called only once and can not be called again
175      */
176     constructor() public {
177         owner = founder;
178         balanceOf[founder] = totalSupply;
179     }
180 
181 
182     function name() public view returns (string _name) {
183         return name;
184     }
185 
186     function symbol() public view returns (string _symbol) {
187         return symbol;
188     }
189 
190     function decimals() public view returns (uint8 _decimals) {
191         return decimals;
192     }
193 
194     function totalSupply() public view returns (uint256 _totalSupply) {
195         return totalSupply;
196     }
197 
198     function balanceOf(address _owner) public view returns (uint256 balance) {
199         return balanceOf[_owner];
200     }
201 
202 
203     /**
204      * @dev Prevent targets from sending or receiving tokens
205      * @param targets Addresses to be frozen
206      * @param isFrozen either to freeze it or not
207      */
208     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
209         require(targets.length > 0);
210 
211         for (uint j = 0; j < targets.length; j++) {
212             require(targets[j] != 0x0);
213             frozenAccount[targets[j]] = isFrozen;
214             emit FrozenFunds(targets[j], isFrozen);
215         }
216     }
217 
218     /**
219      * @dev Prevent targets from sending or receiving tokens by setting Unix times
220      * @param targets Addresses to be locked funds
221      * @param unixTimes Unix times when locking up will be finished
222      */
223     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
224         require(targets.length > 0
225                 && targets.length == unixTimes.length);
226                 
227         for(uint j = 0; j < targets.length; j++){
228             require(unlockUnixTime[targets[j]] < unixTimes[j]);
229             unlockUnixTime[targets[j]] = unixTimes[j];
230             emit LockedFunds(targets[j], unixTimes[j]);
231         }
232     }
233 
234 
235     /**
236      * @dev Function that is called when a user or another contract wants to transfer funds
237      */
238     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
239         require(_value > 0
240                 && frozenAccount[msg.sender] == false 
241                 && frozenAccount[_to] == false
242                 && now > unlockUnixTime[msg.sender] 
243                 && now > unlockUnixTime[_to]);
244 
245         if (isContract(_to)) {
246             require(balanceOf[msg.sender] >= _value);
247             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
248             balanceOf[_to] = balanceOf[_to].add(_value);
249             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
250             emit Transfer(msg.sender, _to, _value, _data);
251             emit Transfer(msg.sender, _to, _value);
252             return true;
253         } else {
254             return transferToAddress(_to, _value, _data);
255         }
256     }
257 
258     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
259         require(_value > 0
260                 && frozenAccount[msg.sender] == false 
261                 && frozenAccount[_to] == false
262                 && now > unlockUnixTime[msg.sender] 
263                 && now > unlockUnixTime[_to]);
264 
265         if (isContract(_to)) {
266             return transferToContract(_to, _value, _data);
267         } else {
268             return transferToAddress(_to, _value, _data);
269         }
270     }
271 
272     /**
273      * @dev Standard function transfer similar to ERC20 transfer with no _data
274      *      Added due to backwards compatibility reasons
275      */
276     function transfer(address _to, uint _value) public returns (bool success) {
277         require(_value > 0
278                 && frozenAccount[msg.sender] == false 
279                 && frozenAccount[_to] == false
280                 && now > unlockUnixTime[msg.sender] 
281                 && now > unlockUnixTime[_to]);
282 
283         bytes memory empty;
284         if (isContract(_to)) {
285             return transferToContract(_to, _value, empty);
286         } else {
287             return transferToAddress(_to, _value, empty);
288         }
289     }
290 
291     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
292     function isContract(address _addr) private view returns (bool is_contract) {
293         uint length;
294         assembly {
295             //retrieve the size of the code on target address, this needs assembly
296             length := extcodesize(_addr)
297         }
298         return (length > 0);
299     }
300 
301     // function that is called when transaction target is an address
302     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
303         require(balanceOf[msg.sender] >= _value);
304         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
305         balanceOf[_to] = balanceOf[_to].add(_value);
306         emit Transfer(msg.sender, _to, _value, _data);
307         emit Transfer(msg.sender, _to, _value);
308         return true;
309     }
310 
311     // function that is called when transaction target is a contract
312     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
313         require(balanceOf[msg.sender] >= _value);
314         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
315         balanceOf[_to] = balanceOf[_to].add(_value);
316         ContractReceiver receiver = ContractReceiver(_to);
317         receiver.tokenFallback(msg.sender, _value, _data);
318         emit Transfer(msg.sender, _to, _value, _data);
319         emit Transfer(msg.sender, _to, _value);
320         return true;
321     }
322 
323 
324 
325     /**
326      * @dev Transfer tokens from one address to another
327      *      Added due to backwards compatibility with ERC20
328      * @param _from address The address which you want to send tokens from
329      * @param _to address The address which you want to transfer to
330      * @param _value uint256 the amount of tokens to be transferred
331      */
332     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
333         require(_to != address(0)
334                 && _value > 0
335                 && balanceOf[_from] >= _value
336                 && allowance[_from][msg.sender] >= _value
337                 && frozenAccount[_from] == false 
338                 && frozenAccount[_to] == false
339                 && now > unlockUnixTime[_from] 
340                 && now > unlockUnixTime[_to]);
341 
342         balanceOf[_from] = balanceOf[_from].sub(_value);
343         balanceOf[_to] = balanceOf[_to].add(_value);
344         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
345         emit Transfer(_from, _to, _value);
346         return true;
347     }
348 
349     /**
350      * @dev Allows _spender to spend no more than _value tokens in your behalf
351      *      Added due to backwards compatibility with ERC20
352      * @param _spender The address authorized to spend
353      * @param _value the max amount they can spend
354      */
355     function approve(address _spender, uint256 _value) public returns (bool success) {
356         allowance[msg.sender][_spender] = _value;
357         emit Approval(msg.sender, _spender, _value);
358         return true;
359     }
360 
361     /**
362      * @dev Function to check the amount of tokens that an owner allowed to a spender
363      *      Added due to backwards compatibility with ERC20
364      * @param _owner address The address which owns the funds
365      * @param _spender address The address which will spend the funds
366      */
367     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
368         return allowance[_owner][_spender];
369     }
370 
371 
372 
373     /**
374      * @dev Burns a specific amount of tokens.
375      * @param _from The address that will burn the tokens.
376      * @param _unitAmount The amount of token to be burned.
377      */
378     function burn(address _from, uint256 _unitAmount) onlyOwner public {
379         require(_unitAmount > 0
380                 && balanceOf[_from] >= _unitAmount);
381 
382         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
383         totalSupply = totalSupply.sub(_unitAmount);
384         emit Burn(_from, _unitAmount);
385     }
386 
387 
388     modifier canMint() {
389         require(!mintingFinished);
390         _;
391     }
392 
393     /**
394      * @dev Function to mint tokens
395      * @param _to The address that will receive the minted tokens.
396      * @param _unitAmount The amount of tokens to mint.
397      */
398     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
399         require(_unitAmount > 0);
400         
401         totalSupply = totalSupply.add(_unitAmount);
402         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
403         emit Mint(_to, _unitAmount);
404         emit Transfer(address(0), _to, _unitAmount);
405         return true;
406     }
407 
408     /**
409      * @dev Function to stop minting new tokens.
410      */
411     function finishMinting() onlyOwner canMint public returns (bool) {
412         mintingFinished = true;
413         emit MintFinished();
414         return true;
415     }
416 
417 
418 
419     /**
420      * @dev Function to distribute tokens to the list of addresses by the provided amount
421      */
422     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
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
438             emit Transfer(msg.sender, addresses[j], amount);
439         }
440         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
441         return true;
442     }
443 
444     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
445         require(addresses.length > 0
446                 && addresses.length == amounts.length
447                 && frozenAccount[msg.sender] == false
448                 && now > unlockUnixTime[msg.sender]);
449                 
450         uint256 totalAmount = 0;
451         
452         for(uint j = 0; j < addresses.length; j++){
453             require(amounts[j] > 0
454                     && addresses[j] != 0x0
455                     && frozenAccount[addresses[j]] == false
456                     && now > unlockUnixTime[addresses[j]]);
457                     
458             amounts[j] = amounts[j].mul(1e8);
459             totalAmount = totalAmount.add(amounts[j]);
460         }
461         require(balanceOf[msg.sender] >= totalAmount);
462         
463         for (j = 0; j < addresses.length; j++) {
464             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
465             emit Transfer(msg.sender, addresses[j], amounts[j]);
466         }
467         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
468         return true;
469     }
470 
471     /**
472      * @dev Function to collect tokens from the list of addresses
473      */
474     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
475         require(addresses.length > 0
476                 && addresses.length == amounts.length);
477 
478         uint256 totalAmount = 0;
479         
480         for (uint j = 0; j < addresses.length; j++) {
481             require(amounts[j] > 0
482                     && addresses[j] != 0x0
483                     && frozenAccount[addresses[j]] == false
484                     && now > unlockUnixTime[addresses[j]]);
485                     
486             amounts[j] = amounts[j].mul(1e8);
487             require(balanceOf[addresses[j]] >= amounts[j]);
488             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
489             totalAmount = totalAmount.add(amounts[j]);
490             emit Transfer(addresses[j], msg.sender, amounts[j]);
491         }
492         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
493         return true;
494     }
495 
496 
497     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
498         distributeAmount = _unitAmount;
499     }
500     
501     /**
502      * @dev Function to distribute tokens to the msg.sender automatically
503      *      If distributeAmount is 0, this function doesn't work
504      */
505     function autoDistribute() payable public {
506         require(distributeAmount > 0
507                 && balanceOf[founder] >= distributeAmount
508                 && frozenAccount[msg.sender] == false
509                 && now > unlockUnixTime[msg.sender]);
510         if(msg.value > 0) founder.transfer(msg.value);
511         
512         balanceOf[founder] = balanceOf[founder].sub(distributeAmount);
513         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
514         emit Transfer(founder, msg.sender, distributeAmount);
515     }
516 
517     /**
518      * @dev fallback function
519      */
520     function() payable public {
521         autoDistribute();
522      }
523 
524 }