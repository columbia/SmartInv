1 pragma solidity >=0.4.22 <0.6.0;
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
140 
141 
142 
143 /**
144  * @title GOOREO
145  * @author BASSEL
146  * @dev GOOREO is an ERC223 Token with ERC20 functions and events
147  *      Fully backward compatible with ERC20
148  */
149 contract GOOREO is ERC223, Ownable {
150     using SafeMath for uint256;
151 
152     string public name = "GOOREO";
153     string public symbol = "GOOREO";
154     string public constant AAcontributors = "BASSEL";
155     uint8 public decimals = 18;
156     uint256 public totalSupply = 1e9 * 1e18;
157     uint256 public distributeAmount = 0;
158     bool public mintingFinished = true;
159 
160     address public founder = 0x6dba8b5a592e7eFD2904440664609f64f9Ee107C;
161     address public developingFund = 0x3A21c8d4f3f9C9FD116Ca9ad9c684bD549E76692;
162     address public activityFunds = 0xFFc6AB72FD5ba166a4E81dDa2e7d20892aC6d0bB;
163     address public lockedFundsForthefuture = 0xE51E486B6493C77c372F477d501b009280e8253a;
164 
165     mapping(address => uint256) public balanceOf;
166     mapping(address => mapping (address => uint256)) public allowance;
167     mapping (address => bool) public frozenAccount;
168     mapping (address => uint256) public unlockUnixTime;
169 
170     event FrozenFunds(address indexed target, bool frozen);
171     event LockedFunds(address indexed target, uint256 locked);
172     event Burn(address indexed from, uint256 amount);
173     event Mint(address indexed to, uint256 amount);
174     event MintFinished();
175 
176 
177     /**
178      * @dev Constructor is called only once and can not be called again
179      */
180     function GOOREO() public {
181         owner = founder;
182         balanceOf[founder] = totalSupply.mul(25).div(100);
183         balanceOf[developingFund] = totalSupply.mul(55).div(100);
184         balanceOf[activityFunds] = totalSupply.mul(10).div(100);
185         balanceOf[lockedFundsForthefuture] = totalSupply.mul(10).div(100);
186     }
187 
188 
189     function name() public view returns (string _name) {
190         return name;
191     }
192 
193     function symbol() public view returns (string _symbol) {
194         return symbol;
195     }
196 
197     function decimals() public view returns (uint8 _decimals) {
198         return decimals;
199     }
200 
201     function totalSupply() public view returns (uint256 _totalSupply) {
202         return totalSupply;
203     }
204 
205     function balanceOf(address _owner) public view returns (uint256 balance) {
206         return balanceOf[_owner];
207     }
208 
209 
210     /**
211      * @dev Prevent targets from sending or receiving tokens
212      * @param targets Addresses to be frozen
213      * @param isFrozen either to freeze it or not
214      */
215     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
216         require(targets.length > 0);
217 
218         for (uint j = 0; j < targets.length; j++) {
219             require(targets[j] != 0x0);
220             frozenAccount[targets[j]] = isFrozen;
221             FrozenFunds(targets[j], isFrozen);
222         }
223     }
224 
225     /**
226      * @dev Prevent targets from sending or receiving tokens by setting Unix times
227      * @param targets Addresses to be locked funds
228      * @param unixTimes Unix times when locking up will be finished
229      */
230     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
231         require(targets.length > 0
232                 && targets.length == unixTimes.length);
233 
234         for(uint j = 0; j < targets.length; j++){
235             require(unlockUnixTime[targets[j]] < unixTimes[j]);
236             unlockUnixTime[targets[j]] = unixTimes[j];
237             LockedFunds(targets[j], unixTimes[j]);
238         }
239     }
240 
241 
242     /**
243      * @dev Function that is called when a user or another contract wants to transfer funds
244      */
245     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
246         require(_value > 0
247                 && frozenAccount[msg.sender] == false
248                 && frozenAccount[_to] == false
249                 && now > unlockUnixTime[msg.sender]
250                 && now > unlockUnixTime[_to]);
251 
252         if (isContract(_to)) {
253             require(balanceOf[msg.sender] >= _value);
254             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
255             balanceOf[_to] = balanceOf[_to].add(_value);
256             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
257             Transfer(msg.sender, _to, _value, _data);
258             Transfer(msg.sender, _to, _value);
259             return true;
260         } else {
261             return transferToAddress(_to, _value, _data);
262         }
263     }
264 
265     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
266         require(_value > 0
267                 && frozenAccount[msg.sender] == false
268                 && frozenAccount[_to] == false
269                 && now > unlockUnixTime[msg.sender]
270                 && now > unlockUnixTime[_to]);
271 
272         if (isContract(_to)) {
273             return transferToContract(_to, _value, _data);
274         } else {
275             return transferToAddress(_to, _value, _data);
276         }
277     }
278 
279     /**
280      * @dev Standard function transfer similar to ERC20 transfer with no _data
281      *      Added due to backwards compatibility reasons
282      */
283     function transfer(address _to, uint _value) public returns (bool success) {
284         require(_value > 0
285                 && frozenAccount[msg.sender] == false
286                 && frozenAccount[_to] == false
287                 && now > unlockUnixTime[msg.sender]
288                 && now > unlockUnixTime[_to]);
289 
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
330 
331 
332     /**
333      * @dev Transfer tokens from one address to another
334      *      Added due to backwards compatibility with ERC20
335      * @param _from address The address which you want to send tokens from
336      * @param _to address The address which you want to transfer to
337      * @param _value uint256 the amount of tokens to be transferred
338      */
339     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
340         require(_to != address(0)
341                 && _value > 0
342                 && balanceOf[_from] >= _value
343                 && allowance[_from][msg.sender] >= _value
344                 && frozenAccount[_from] == false
345                 && frozenAccount[_to] == false
346                 && now > unlockUnixTime[_from]
347                 && now > unlockUnixTime[_to]);
348 
349         balanceOf[_from] = balanceOf[_from].sub(_value);
350         balanceOf[_to] = balanceOf[_to].add(_value);
351         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
352         Transfer(_from, _to, _value);
353         return true;
354     }
355 
356     /**
357      * @dev Allows _spender to spend no more than _value tokens in your behalf
358      *      Added due to backwards compatibility with ERC20
359      * @param _spender The address authorized to spend
360      * @param _value the max amount they can spend
361      */
362     function approve(address _spender, uint256 _value) public returns (bool success) {
363         allowance[msg.sender][_spender] = _value;
364         Approval(msg.sender, _spender, _value);
365         return true;
366     }
367 
368     /**
369      * @dev Function to check the amount of tokens that an owner allowed to a spender
370      *      Added due to backwards compatibility with ERC20
371      * @param _owner address The address which owns the funds
372      * @param _spender address The address which will spend the funds
373      */
374     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
375         return allowance[_owner][_spender];
376     }
377 
378 
379 
380     /**
381      * @dev Burns a specific amount of tokens.
382      * @param _from The address that will burn the tokens.
383      * @param _unitAmount The amount of token to be burned.
384      */
385     function burn(address _from, uint256 _unitAmount) onlyOwner public {
386         require(_unitAmount > 0
387                 && balanceOf[_from] >= _unitAmount);
388 
389         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
390         totalSupply = totalSupply.sub(_unitAmount);
391         Burn(_from, _unitAmount);
392     }
393 
394 
395     modifier canMint() {
396         require(!mintingFinished);
397         _;
398     }
399 
400     /**
401      * @dev Function to mint tokens
402      * @param _to The address that will receive the minted tokens.
403      * @param _unitAmount The amount of tokens to mint.
404      */
405     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
406         require(_unitAmount > 0);
407 
408         totalSupply = totalSupply.add(_unitAmount);
409         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
410         Mint(_to, _unitAmount);
411         Transfer(address(0), _to, _unitAmount);
412         return true;
413     }
414 
415     /**
416      * @dev Function to stop minting new tokens.
417      */
418     function finishMinting() onlyOwner canMint public returns (bool) {
419         mintingFinished = true;
420         MintFinished();
421         return true;
422     }
423 
424 
425 
426     /**
427      * @dev Function to distribute tokens to the list of addresses by the provided amount
428      */
429     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
430         require(amount > 0
431                 && addresses.length > 0
432                 && frozenAccount[msg.sender] == false
433                 && now > unlockUnixTime[msg.sender]);
434 
435         amount = amount.mul(1e8);
436         uint256 totalAmount = amount.mul(addresses.length);
437         require(balanceOf[msg.sender] >= totalAmount);
438 
439         for (uint j = 0; j < addresses.length; j++) {
440             require(addresses[j] != 0x0
441                     && frozenAccount[addresses[j]] == false
442                     && now > unlockUnixTime[addresses[j]]);
443 
444             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
445             Transfer(msg.sender, addresses[j], amount);
446         }
447         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
448         return true;
449     }
450 
451     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
452         require(addresses.length > 0
453                 && addresses.length == amounts.length
454                 && frozenAccount[msg.sender] == false
455                 && now > unlockUnixTime[msg.sender]);
456 
457         uint256 totalAmount = 0;
458 
459         for(uint j = 0; j < addresses.length; j++){
460             require(amounts[j] > 0
461                     && addresses[j] != 0x0
462                     && frozenAccount[addresses[j]] == false
463                     && now > unlockUnixTime[addresses[j]]);
464 
465             amounts[j] = amounts[j].mul(1e8);
466             totalAmount = totalAmount.add(amounts[j]);
467         }
468         require(balanceOf[msg.sender] >= totalAmount);
469 
470         for (j = 0; j < addresses.length; j++) {
471             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
472             Transfer(msg.sender, addresses[j], amounts[j]);
473         }
474         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
475         return true;
476     }
477 
478     /**
479      * @dev Function to collect tokens from the list of addresses
480      */
481     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
482         require(addresses.length > 0
483                 && addresses.length == amounts.length);
484 
485         uint256 totalAmount = 0;
486 
487         for (uint j = 0; j < addresses.length; j++) {
488             require(amounts[j] > 0
489                     && addresses[j] != 0x0
490                     && frozenAccount[addresses[j]] == false
491                     && now > unlockUnixTime[addresses[j]]);
492 
493             amounts[j] = amounts[j].mul(1e8);
494             require(balanceOf[addresses[j]] >= amounts[j]);
495             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
496             totalAmount = totalAmount.add(amounts[j]);
497             Transfer(addresses[j], msg.sender, amounts[j]);
498         }
499         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
500         return true;
501     }
502 
503 
504     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
505         distributeAmount = _unitAmount;
506     }
507 
508     /**
509      * @dev Function to distribute tokens to the msg.sender automatically
510      *      If distributeAmount is 0, this function doesn't work
511      */
512     function autoDistribute() payable public {
513         require(distributeAmount > 0
514                 && balanceOf[owner] >= distributeAmount
515                 && frozenAccount[msg.sender] == false
516                 && now > unlockUnixTime[msg.sender]);
517         if(msg.value > 0) owner.transfer(msg.value);
518 
519         balanceOf[owner] = balanceOf[owner].sub(distributeAmount);
520         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
521         Transfer(owner, msg.sender, distributeAmount);
522     }
523 
524     /**
525      * @dev fallback function
526      */
527     function() payable public {
528         autoDistribute();
529      }
530 
531 }