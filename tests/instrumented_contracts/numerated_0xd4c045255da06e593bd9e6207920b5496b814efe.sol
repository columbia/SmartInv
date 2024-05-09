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
140 contract StandardToken is ERC223, Ownable {
141     using SafeMath for uint256;
142 
143     string public name;
144     string public symbol;
145     string public constant AAcontributors = "yeah";
146     uint8 public decimals;
147     uint256 public totalSupply;
148     uint256 public distributeAmount = 0;
149     bool public mintingFinished = false;
150     
151     mapping(address => uint256) public balanceOf;
152     mapping(address => mapping (address => uint256)) public allowance;
153     mapping (address => bool) public frozenAccount;
154     mapping (address => uint256) public unlockUnixTime;
155     
156     event FrozenFunds(address indexed target, bool frozen);
157     event LockedFunds(address indexed target, uint256 locked);
158     event Burn(address indexed from, uint256 amount);
159     event Mint(address indexed to, uint256 amount);
160     event MintFinished();
161 
162 
163     /** 
164      * @dev Constructor is called only once and can not be called again
165      */
166     function StandardToken(
167         string _tokenName,
168 		string _tokenSymbol,
169 		uint8 _decimalUnits,
170         uint256 _initialAmount,
171 		address _owner) public {
172 		name = _tokenName;
173 		symbol = _tokenSymbol;
174 		decimals = _decimalUnits;
175 		totalSupply = _initialAmount;
176 		
177 		owner = _owner;
178     }
179 
180 
181     function name() public view returns (string _name) {
182         return name;
183     }
184 
185     function symbol() public view returns (string _symbol) {
186         return symbol;
187     }
188 
189     function decimals() public view returns (uint8 _decimals) {
190         return decimals;
191     }
192 
193     function totalSupply() public view returns (uint256 _totalSupply) {
194         return totalSupply;
195     }
196 
197     function balanceOf(address _owner) public view returns (uint256 balance) {
198         return balanceOf[_owner];
199     }
200 
201 
202     /**
203      * @dev Prevent targets from sending or receiving tokens
204      * @param targets Addresses to be frozen
205      * @param isFrozen either to freeze it or not
206      */
207     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
208         require(targets.length > 0);
209 
210         for (uint j = 0; j < targets.length; j++) {
211             require(targets[j] != 0x0);
212             frozenAccount[targets[j]] = isFrozen;
213             FrozenFunds(targets[j], isFrozen);
214         }
215     }
216 
217     /**
218      * @dev Prevent targets from sending or receiving tokens by setting Unix times
219      * @param targets Addresses to be locked funds
220      * @param unixTimes Unix times when locking up will be finished
221      */
222     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
223         require(targets.length > 0
224                 && targets.length == unixTimes.length);
225                 
226         for(uint j = 0; j < targets.length; j++){
227             require(unlockUnixTime[targets[j]] < unixTimes[j]);
228             unlockUnixTime[targets[j]] = unixTimes[j];
229             LockedFunds(targets[j], unixTimes[j]);
230         }
231     }
232 
233 
234     /**
235      * @dev Function that is called when a user or another contract wants to transfer funds
236      */
237     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
238         require(_value > 0
239                 && frozenAccount[msg.sender] == false 
240                 && frozenAccount[_to] == false
241                 && now > unlockUnixTime[msg.sender] 
242                 && now > unlockUnixTime[_to]);
243 
244         if (isContract(_to)) {
245             require(balanceOf[msg.sender] >= _value);
246             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
247             balanceOf[_to] = balanceOf[_to].add(_value);
248             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
249             Transfer(msg.sender, _to, _value, _data);
250             Transfer(msg.sender, _to, _value);
251             return true;
252         } else {
253             return transferToAddress(_to, _value, _data);
254         }
255     }
256 
257     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
258         require(_value > 0
259                 && frozenAccount[msg.sender] == false 
260                 && frozenAccount[_to] == false
261                 && now > unlockUnixTime[msg.sender] 
262                 && now > unlockUnixTime[_to]);
263 
264         if (isContract(_to)) {
265             return transferToContract(_to, _value, _data);
266         } else {
267             return transferToAddress(_to, _value, _data);
268         }
269     }
270 
271     /**
272      * @dev Standard function transfer similar to ERC20 transfer with no _data
273      *      Added due to backwards compatibility reasons
274      */
275     function transfer(address _to, uint _value) public returns (bool success) {
276         require(_value > 0
277                 && frozenAccount[msg.sender] == false 
278                 && frozenAccount[_to] == false
279                 && now > unlockUnixTime[msg.sender] 
280                 && now > unlockUnixTime[_to]);
281 
282         bytes memory empty;
283         if (isContract(_to)) {
284             return transferToContract(_to, _value, empty);
285         } else {
286             return transferToAddress(_to, _value, empty);
287         }
288     }
289 
290     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
291     function isContract(address _addr) private view returns (bool is_contract) {
292         uint length;
293         assembly {
294             //retrieve the size of the code on target address, this needs assembly
295             length := extcodesize(_addr)
296         }
297         return (length > 0);
298     }
299 
300     // function that is called when transaction target is an address
301     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
302         require(balanceOf[msg.sender] >= _value);
303         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
304         balanceOf[_to] = balanceOf[_to].add(_value);
305         Transfer(msg.sender, _to, _value, _data);
306         Transfer(msg.sender, _to, _value);
307         return true;
308     }
309 
310     // function that is called when transaction target is a contract
311     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
312         require(balanceOf[msg.sender] >= _value);
313         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
314         balanceOf[_to] = balanceOf[_to].add(_value);
315         ContractReceiver receiver = ContractReceiver(_to);
316         receiver.tokenFallback(msg.sender, _value, _data);
317         Transfer(msg.sender, _to, _value, _data);
318         Transfer(msg.sender, _to, _value);
319         return true;
320     }
321 
322 
323 
324     /**
325      * @dev Transfer tokens from one address to another
326      *      Added due to backwards compatibility with ERC20
327      * @param _from address The address which you want to send tokens from
328      * @param _to address The address which you want to transfer to
329      * @param _value uint256 the amount of tokens to be transferred
330      */
331     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
332         require(_to != address(0)
333                 && _value > 0
334                 && balanceOf[_from] >= _value
335                 && allowance[_from][msg.sender] >= _value
336                 && frozenAccount[_from] == false 
337                 && frozenAccount[_to] == false
338                 && now > unlockUnixTime[_from] 
339                 && now > unlockUnixTime[_to]);
340 
341         balanceOf[_from] = balanceOf[_from].sub(_value);
342         balanceOf[_to] = balanceOf[_to].add(_value);
343         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
344         Transfer(_from, _to, _value);
345         return true;
346     }
347 
348     /**
349      * @dev Allows _spender to spend no more than _value tokens in your behalf
350      *      Added due to backwards compatibility with ERC20
351      * @param _spender The address authorized to spend
352      * @param _value the max amount they can spend
353      */
354     function approve(address _spender, uint256 _value) public returns (bool success) {
355         allowance[msg.sender][_spender] = _value;
356         Approval(msg.sender, _spender, _value);
357         return true;
358     }
359 
360     /**
361      * @dev Function to check the amount of tokens that an owner allowed to a spender
362      *      Added due to backwards compatibility with ERC20
363      * @param _owner address The address which owns the funds
364      * @param _spender address The address which will spend the funds
365      */
366     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
367         return allowance[_owner][_spender];
368     }
369 
370 
371 
372     /**
373      * @dev Burns a specific amount of tokens.
374      * @param _from The address that will burn the tokens.
375      * @param _unitAmount The amount of token to be burned.
376      */
377     function burn(address _from, uint256 _unitAmount) onlyOwner public {
378         require(_unitAmount > 0
379                 && balanceOf[_from] >= _unitAmount);
380 
381         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
382         totalSupply = totalSupply.sub(_unitAmount);
383         Burn(_from, _unitAmount);
384     }
385 
386 
387     modifier canMint() {
388         require(!mintingFinished);
389         _;
390     }
391 
392     /**
393      * @dev Function to mint tokens
394      * @param _to The address that will receive the minted tokens.
395      * @param _unitAmount The amount of tokens to mint.
396      */
397     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
398         require(_unitAmount > 0);
399         
400         totalSupply = totalSupply.add(_unitAmount);
401         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
402         Mint(_to, _unitAmount);
403         Transfer(address(0), _to, _unitAmount);
404         return true;
405     }
406 
407     /**
408      * @dev Function to stop minting new tokens.
409      */
410     function finishMinting() onlyOwner canMint public returns (bool) {
411         mintingFinished = true;
412         MintFinished();
413         return true;
414     }
415 
416 
417 
418     /**
419      * @dev Function to distribute tokens to the list of addresses by the provided amount
420      */
421     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
422         require(amount > 0 
423                 && addresses.length > 0
424                 && frozenAccount[msg.sender] == false
425                 && now > unlockUnixTime[msg.sender]);
426 
427         amount = amount.mul(10 * decimals);
428         uint256 totalAmount = amount.mul(addresses.length);
429         require(balanceOf[msg.sender] >= totalAmount);
430         
431         for (uint j = 0; j < addresses.length; j++) {
432             require(addresses[j] != 0x0
433                     && frozenAccount[addresses[j]] == false
434                     && now > unlockUnixTime[addresses[j]]);
435 
436             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
437             Transfer(msg.sender, addresses[j], amount);
438         }
439         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
440         return true;
441     }
442 
443     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
444         require(addresses.length > 0
445                 && addresses.length == amounts.length
446                 && frozenAccount[msg.sender] == false
447                 && now > unlockUnixTime[msg.sender]);
448                 
449         uint256 totalAmount = 0;
450         
451         for(uint j = 0; j < addresses.length; j++){
452             require(amounts[j] > 0
453                     && addresses[j] != 0x0
454                     && frozenAccount[addresses[j]] == false
455                     && now > unlockUnixTime[addresses[j]]);
456                     
457             amounts[j] = amounts[j].mul(10 * decimals);
458             totalAmount = totalAmount.add(amounts[j]);
459         }
460         require(balanceOf[msg.sender] >= totalAmount);
461         
462         for (j = 0; j < addresses.length; j++) {
463             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
464             Transfer(msg.sender, addresses[j], amounts[j]);
465         }
466         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
467         return true;
468     }
469 
470     /**
471      * @dev Function to collect tokens from the list of addresses
472      */
473     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
474         require(addresses.length > 0
475                 && addresses.length == amounts.length);
476 
477         uint256 totalAmount = 0;
478         
479         for (uint j = 0; j < addresses.length; j++) {
480             require(amounts[j] > 0
481                     && addresses[j] != 0x0
482                     && frozenAccount[addresses[j]] == false
483                     && now > unlockUnixTime[addresses[j]]);
484                     
485             amounts[j] = amounts[j].mul(10 * decimals);
486             require(balanceOf[addresses[j]] >= amounts[j]);
487             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
488             totalAmount = totalAmount.add(amounts[j]);
489             Transfer(addresses[j], msg.sender, amounts[j]);
490         }
491         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
492         return true;
493     }
494 
495 
496     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
497         distributeAmount = _unitAmount;
498     }
499     
500     /**
501      * @dev Function to distribute tokens to the msg.sender automatically
502      *      If distributeAmount is 0, this function doesn't work
503      */
504     function autoDistribute() payable public {
505         require(distributeAmount > 0
506                 && balanceOf[owner] >= distributeAmount
507                 && frozenAccount[msg.sender] == false
508                 && now > unlockUnixTime[msg.sender]);
509         if(msg.value > 0) owner.transfer(msg.value);
510         
511         balanceOf[owner] = balanceOf[owner].sub(distributeAmount);
512         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
513         Transfer(owner, msg.sender, distributeAmount);
514     }
515 
516     /**
517      * @dev fallback function
518      */
519     function() payable public {
520         autoDistribute();
521      }
522 
523 }