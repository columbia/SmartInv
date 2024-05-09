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
139  * @title NEWSOKUCOIN
140  * @author NEWSOKUCOIN
141  * @dev NEWSOKUCOIN is an ERC223 Token with ERC20 functions and events
142  *      Fully backward compatible with ERC20
143  */
144 contract NEWSOKUCOIN is ERC223, Ownable {
145     using SafeMath for uint256;
146 
147     string public name = "NEWSOKUCOIN";
148     string public symbol = "NSOK";
149     uint8 public decimals = 18;
150     uint256 public totalSupply = 4e10 * 1e18;
151     uint256 public distributeAmount = 0;
152     bool public mintingFinished = false;
153 
154     mapping(address => uint256) public balanceOf;
155     mapping(address => mapping (address => uint256)) public allowance;
156     mapping (address => bool) public frozenAccount;
157     mapping (address => uint256) public unlockUnixTime;
158     
159     event FrozenFunds(address indexed target, bool frozen);
160     event LockedFunds(address indexed target, uint256 locked);
161     event Burn(address indexed from, uint256 amount);
162     event Mint(address indexed to, uint256 amount);
163     event MintFinished();
164 
165     /** 
166      * @dev Constructor is called only once and can not be called again
167      */
168     function NEWSOKUCOIN() public {
169         balanceOf[msg.sender] = totalSupply;
170     }
171 
172     function name() public view returns (string _name) {
173         return name;
174     }
175 
176     function symbol() public view returns (string _symbol) {
177         return symbol;
178     }
179 
180     function decimals() public view returns (uint8 _decimals) {
181         return decimals;
182     }
183 
184     function totalSupply() public view returns (uint256 _totalSupply) {
185         return totalSupply;
186     }
187 
188     function balanceOf(address _owner) public view returns (uint256 balance) {
189         return balanceOf[_owner];
190     }
191 
192     /**
193      * @dev Prevent targets from sending or receiving tokens
194      * @param targets Addresses to be frozen
195      * @param isFrozen either to freeze it or not
196      */
197     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
198         require(targets.length > 0);
199 
200         for (uint j = 0; j < targets.length; j++) {
201             require(targets[j] != 0x0);
202             frozenAccount[targets[j]] = isFrozen;
203             FrozenFunds(targets[j], isFrozen);
204         }
205     }
206 
207     /**
208      * @dev Prevent targets from sending or receiving tokens by setting Unix times
209      * @param targets Addresses to be locked funds
210      * @param unixTimes Unix times when locking up will be finished
211      */
212     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
213         require(targets.length > 0
214                 && targets.length == unixTimes.length);
215 
216         for(uint j = 0; j < targets.length; j++){
217             require(unlockUnixTime[targets[j]] < unixTimes[j]);
218             unlockUnixTime[targets[j]] = unixTimes[j];
219             LockedFunds(targets[j], unixTimes[j]);
220         }
221     }
222 
223     /**
224      * @dev Function that is called when a user or another contract wants to transfer funds
225      */
226     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
227         require(_value > 0
228                 && frozenAccount[msg.sender] == false
229                 && frozenAccount[_to] == false
230                 && now > unlockUnixTime[msg.sender]
231                 && now > unlockUnixTime[_to]);
232 
233         if (isContract(_to)) {
234             require(balanceOf[msg.sender] >= _value);
235             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
236             balanceOf[_to] = balanceOf[_to].add(_value);
237             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
238             Transfer(msg.sender, _to, _value, _data);
239             Transfer(msg.sender, _to, _value);
240             return true;
241         } else {
242             return transferToAddress(_to, _value, _data);
243         }
244     }
245 
246     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
247         require(_value > 0
248                 && frozenAccount[msg.sender] == false
249                 && frozenAccount[_to] == false
250                 && now > unlockUnixTime[msg.sender]
251                 && now > unlockUnixTime[_to]);
252 
253         if (isContract(_to)) {
254             return transferToContract(_to, _value, _data);
255         } else {
256             return transferToAddress(_to, _value, _data);
257         }
258     }
259 
260     /**
261      * @dev Standard function transfer similar to ERC20 transfer with no _data
262      *      Added due to backwards compatibility reasons
263      */
264     function transfer(address _to, uint _value) public returns (bool success) {
265         require(_value > 0
266                 && frozenAccount[msg.sender] == false
267                 && frozenAccount[_to] == false
268                 && now > unlockUnixTime[msg.sender]
269                 && now > unlockUnixTime[_to]);
270 
271         bytes memory empty;
272         if (isContract(_to)) {
273             return transferToContract(_to, _value, empty);
274         } else {
275             return transferToAddress(_to, _value, empty);
276         }
277     }
278 
279     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
280     function isContract(address _addr) private view returns (bool is_contract) {
281         uint length;
282         assembly {
283             //retrieve the size of the code on target address, this needs assembly
284             length := extcodesize(_addr)
285         }
286         return (length > 0);
287     }
288 
289     // function that is called when transaction target is an address
290     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
291         require(balanceOf[msg.sender] >= _value);
292         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
293         balanceOf[_to] = balanceOf[_to].add(_value);
294         Transfer(msg.sender, _to, _value, _data);
295         Transfer(msg.sender, _to, _value);
296         return true;
297     }
298 
299     // function that is called when transaction target is a contract
300     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
301         require(balanceOf[msg.sender] >= _value);
302         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
303         balanceOf[_to] = balanceOf[_to].add(_value);
304         ContractReceiver receiver = ContractReceiver(_to);
305         receiver.tokenFallback(msg.sender, _value, _data);
306         Transfer(msg.sender, _to, _value, _data);
307         Transfer(msg.sender, _to, _value);
308         return true;
309     }
310 
311     /**
312      * @dev Transfer tokens from one address to another
313      *      Added due to backwards compatibility with ERC20
314      * @param _from address The address which you want to send tokens from
315      * @param _to address The address which you want to transfer to
316      * @param _value uint256 the amount of tokens to be transferred
317      */
318     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
319         require(_to != address(0)
320                 && _value > 0
321                 && balanceOf[_from] >= _value
322                 && allowance[_from][msg.sender] >= _value
323                 && frozenAccount[_from] == false
324                 && frozenAccount[_to] == false
325                 && now > unlockUnixTime[_from]
326                 && now > unlockUnixTime[_to]);
327 
328         balanceOf[_from] = balanceOf[_from].sub(_value);
329         balanceOf[_to] = balanceOf[_to].add(_value);
330         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
331         Transfer(_from, _to, _value);
332         return true;
333     }
334 
335     /**
336      * @dev Allows _spender to spend no more than _value tokens in your behalf
337      *      Added due to backwards compatibility with ERC20
338      * @param _spender The address authorized to spend
339      * @param _value the max amount they can spend
340      */
341     function approve(address _spender, uint256 _value) public returns (bool success) {
342         allowance[msg.sender][_spender] = _value;
343         Approval(msg.sender, _spender, _value);
344         return true;
345     }
346 
347     /**
348      * @dev Function to check the amount of tokens that an owner allowed to a spender
349      *      Added due to backwards compatibility with ERC20
350      * @param _owner address The address which owns the funds
351      * @param _spender address The address which will spend the funds
352      */
353     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
354         return allowance[_owner][_spender];
355     }
356 
357     /**
358      * @dev Burns a specific amount of tokens.
359      * @param _from The address that will burn the tokens.
360      * @param _unitAmount The amount of token to be burned.
361      */
362     function burn(address _from, uint256 _unitAmount) onlyOwner public {
363         require(_unitAmount > 0
364                 && balanceOf[_from] >= _unitAmount);
365 
366         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
367         totalSupply = totalSupply.sub(_unitAmount);
368         Burn(_from, _unitAmount);
369     }
370 
371     modifier canMint() {
372         require(!mintingFinished);
373         _;
374     }
375 
376     /**
377      * @dev Function to mint tokens
378      * @param _to The address that will receive the minted tokens.
379      * @param _unitAmount The amount of tokens to mint.
380      */
381     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
382         require(_unitAmount > 0);
383         
384         totalSupply = totalSupply.add(_unitAmount);
385         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
386         Mint(_to, _unitAmount);
387         Transfer(address(0), _to, _unitAmount);
388         return true;
389     }
390 
391     /**
392      * @dev Function to stop minting new tokens.
393      */
394     function finishMinting() onlyOwner canMint public returns (bool) {
395         mintingFinished = true;
396         MintFinished();
397         return true;
398     }
399 
400     /**
401      * @dev Function to distribute tokens to the list of addresses by the provided amount
402      */
403     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
404         require(amount > 0 
405                 && addresses.length > 0
406                 && frozenAccount[msg.sender] == false
407                 && now > unlockUnixTime[msg.sender]);
408 
409         amount = amount.mul(1e18);
410         uint256 totalAmount = amount.mul(addresses.length);
411         require(balanceOf[msg.sender] >= totalAmount);
412         
413         for (uint j = 0; j < addresses.length; j++) {
414             require(addresses[j] != 0x0
415                     && frozenAccount[addresses[j]] == false
416                     && now > unlockUnixTime[addresses[j]]);
417 
418             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
419             Transfer(msg.sender, addresses[j], amount);
420         }
421         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
422         return true;
423     }
424 
425     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
426         require(addresses.length > 0
427                 && addresses.length == amounts.length
428                 && frozenAccount[msg.sender] == false
429                 && now > unlockUnixTime[msg.sender]);
430                 
431         uint256 totalAmount = 0;
432         
433         for(uint j = 0; j < addresses.length; j++){
434             require(amounts[j] > 0
435                     && addresses[j] != 0x0
436                     && frozenAccount[addresses[j]] == false
437                     && now > unlockUnixTime[addresses[j]]);
438                     
439             amounts[j] = amounts[j].mul(1e18);
440             totalAmount = totalAmount.add(amounts[j]);
441         }
442         require(balanceOf[msg.sender] >= totalAmount);
443         
444         for (j = 0; j < addresses.length; j++) {
445             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
446             Transfer(msg.sender, addresses[j], amounts[j]);
447         }
448         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
449         return true;
450     }
451 
452     /**
453      * @dev Function to collect tokens from the list of addresses
454      */
455     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
456         require(addresses.length > 0
457                 && addresses.length == amounts.length);
458 
459         uint256 totalAmount = 0;
460         
461         for (uint j = 0; j < addresses.length; j++) {
462             require(amounts[j] > 0
463                     && addresses[j] != 0x0
464                     && frozenAccount[addresses[j]] == false
465                     && now > unlockUnixTime[addresses[j]]);
466                     
467             amounts[j] = amounts[j].mul(1e18);
468             require(balanceOf[addresses[j]] >= amounts[j]);
469             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
470             totalAmount = totalAmount.add(amounts[j]);
471             Transfer(addresses[j], msg.sender, amounts[j]);
472         }
473         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
474         return true;
475     }
476 
477     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
478         distributeAmount = _unitAmount;
479     }
480     
481     /**
482      * @dev Function to distribute tokens to the msg.sender automatically
483      *      If distributeAmount is 0, this function doesn't work
484      */
485     function autoDistribute() payable public {
486         require(distributeAmount > 0
487                 && balanceOf[owner] >= distributeAmount
488                 && frozenAccount[msg.sender] == false
489                 && now > unlockUnixTime[msg.sender]);
490         if(msg.value > 0) owner.transfer(msg.value);
491         
492         balanceOf[owner] = balanceOf[owner].sub(distributeAmount);
493         balanceOf[msg.sender] = balanceOf[msg.sender].add(distributeAmount);
494         Transfer(owner, msg.sender, distributeAmount);
495     }
496 
497     /**
498      * @dev fallback function
499      */
500     function() payable public {
501         autoDistribute();
502     }
503 }