1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization
37  *      control functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40     address public owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     /**
45      * @dev The Ownable constructor sets the original `owner` of the contract to the
46      *      sender account.
47      */
48     function Ownable() public {
49         owner = msg.sender;
50     }
51 
52     /**
53      * @dev Throws if called by any account other than the owner.
54      */
55     modifier onlyOwner() {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     /**
61      * @dev Allows the current owner to transfer control of the contract to a newOwner.
62      * @param newOwner The address to transfer ownership to.
63      */
64     function transferOwnership(address newOwner) onlyOwner public {
65         require(newOwner != address(0));
66         OwnershipTransferred(owner, newOwner);
67         owner = newOwner;
68     }
69 }
70 
71 contract ERC223 {
72     uint public totalSupply;
73 
74     // ERC223 and ERC20 functions and events
75     function balanceOf(address who) public view returns (uint);
76     function totalSupply() public view returns (uint256 _supply);
77     function transfer(address to, uint value) public returns (bool ok);
78     function transfer(address to, uint value, bytes data) public returns (bool ok);
79     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
80     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
81 
82     // ERC223 functions
83     function name() public view returns (string _name);
84     function symbol() public view returns (string _symbol);
85     function decimals() public view returns (uint8 _decimals);
86 
87     // ERC20 functions and events
88     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
89     function approve(address _spender, uint256 _value) public returns (bool success);
90     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
91     event Transfer(address indexed _from, address indexed _to, uint256 _value);
92     event Approval(address indexed _owner, address indexed _spender, uint _value);
93 }
94 
95 
96 
97 /**
98  * @title ContractReceiver
99  * @dev Contract that is working with ERC223 tokens
100  */
101  contract ContractReceiver {
102 
103     struct TKN {
104         address sender;
105         uint value;
106         bytes data;
107         bytes4 sig;
108     }
109 
110     function tokenFallback(address _from, uint _value, bytes _data) public pure {
111         TKN memory tkn;
112         tkn.sender = _from;
113         tkn.value = _value;
114         tkn.data = _data;
115         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
116         tkn.sig = bytes4(u);
117 
118         /*
119          * tkn variable is analogue of msg variable of Ether transaction
120          * tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
121          * tkn.value the number of tokens that were sent   (analogue of msg.value)
122          * tkn.data is data of token transaction   (analogue of msg.data)
123          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
124          */
125     }
126 }
127 
128 
129 contract NOTNCoin is ERC223, Ownable {
130     using SafeMath for uint256;
131 
132     string public name = "NAOTANCOIN";
133     string public symbol = "NOTN";
134     uint8 public decimals = 8;
135     uint256 public totalSupply = 123e8 * 1e8;
136     uint256 public distributeAmount = 0;
137     bool public mintingFinished = false;
138 
139     address public founder = 0x9Da9874008d157d8e93DF7639a46b667c65DaadB;
140     address public Sleep = 0x32F7b01EAc87fD4cDd1c3F2Cb0dCeB409B0d9638;
141 
142     mapping(address => uint256) public balanceOf;
143     mapping(address => mapping (address => uint256)) public allowance;
144     mapping (address => bool) public frozenAccount;
145     mapping (address => uint256) public unlockUnixTime;
146 
147     event FrozenFunds(address indexed target, bool frozen);
148     event LockedFunds(address indexed target, uint256 locked);
149     event Burn(address indexed from, uint256 amount);
150     event Mint(address indexed to, uint256 amount);
151     event MintFinished();
152 
153 
154     /**
155      * @dev Constructor is called only once and can not be called again
156      */
157     function NOTNCoin() public {
158         balanceOf[founder] = totalSupply.mul(90).div(100);
159         balanceOf[Sleep] = totalSupply.mul(10).div(100);
160     }
161 
162 
163     function name() public view returns (string _name) {
164         return name;
165     }
166 
167     function symbol() public view returns (string _symbol) {
168         return symbol;
169     }
170 
171     function decimals() public view returns (uint8 _decimals) {
172         return decimals;
173     }
174 
175     function totalSupply() public view returns (uint256 _totalSupply) {
176         return totalSupply;
177     }
178 
179     function balanceOf(address _owner) public view returns (uint256 balance) {
180         return balanceOf[_owner];
181     }
182 
183     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
184         require(targets.length > 0);
185 
186         for (uint j = 0; j < targets.length; j++) {
187             require(targets[j] != 0x0);
188             frozenAccount[targets[j]] = isFrozen;
189             FrozenFunds(targets[j], isFrozen);
190         }
191     }
192 
193     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
194         require(targets.length > 0
195                 && targets.length == unixTimes.length);
196 
197         for(uint j = 0; j < targets.length; j++){
198             require(unlockUnixTime[targets[j]] < unixTimes[j]);
199             unlockUnixTime[targets[j]] = unixTimes[j];
200             LockedFunds(targets[j], unixTimes[j]);
201         }
202     }
203 
204 
205     /**
206      * @dev Function that is called when a user or another contract wants to transfer funds
207      */
208     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
209         require(_value > 0
210                 && frozenAccount[msg.sender] == false
211                 && frozenAccount[_to] == false
212                 && now > unlockUnixTime[msg.sender]
213                 && now > unlockUnixTime[_to]);
214 
215         if (isContract(_to)) {
216             require(balanceOf[msg.sender] >= _value);
217             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
218             balanceOf[_to] = balanceOf[_to].add(_value);
219             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
220             Transfer(msg.sender, _to, _value, _data);
221             Transfer(msg.sender, _to, _value);
222             return true;
223         } else {
224             return transferToAddress(_to, _value, _data);
225         }
226     }
227 
228     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
229         require(_value > 0
230                 && frozenAccount[msg.sender] == false
231                 && frozenAccount[_to] == false
232                 && now > unlockUnixTime[msg.sender]
233                 && now > unlockUnixTime[_to]);
234 
235         if (isContract(_to)) {
236             return transferToContract(_to, _value, _data);
237         } else {
238             return transferToAddress(_to, _value, _data);
239         }
240     }
241 
242     /**
243      * @dev Standard function transfer similar to ERC20 transfer with no _data
244      *      Added due to backwards compatibility reasons
245      */
246     function transfer(address _to, uint _value) public returns (bool success) {
247         require(_value > 0
248                 && frozenAccount[msg.sender] == false
249                 && frozenAccount[_to] == false
250                 && now > unlockUnixTime[msg.sender]
251                 && now > unlockUnixTime[_to]);
252 
253         bytes memory empty;
254         if (isContract(_to)) {
255             return transferToContract(_to, _value, empty);
256         } else {
257             return transferToAddress(_to, _value, empty);
258         }
259     }
260 
261     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
262     function isContract(address _addr) private view returns (bool is_contract) {
263         uint length;
264         assembly {
265             //retrieve the size of the code on target address, this needs assembly
266             length := extcodesize(_addr)
267         }
268         return (length > 0);
269     }
270 
271     // function that is called when transaction target is an address
272     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
273         require(balanceOf[msg.sender] >= _value);
274         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
275         balanceOf[_to] = balanceOf[_to].add(_value);
276         Transfer(msg.sender, _to, _value, _data);
277         Transfer(msg.sender, _to, _value);
278         return true;
279     }
280 
281     // function that is called when transaction target is a contract
282     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
283         require(balanceOf[msg.sender] >= _value);
284         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
285         balanceOf[_to] = balanceOf[_to].add(_value);
286         ContractReceiver receiver = ContractReceiver(_to);
287         receiver.tokenFallback(msg.sender, _value, _data);
288         Transfer(msg.sender, _to, _value, _data);
289         Transfer(msg.sender, _to, _value);
290         return true;
291     }
292 
293 
294 
295     /**
296      * @dev Transfer tokens from one address to another
297      *      Added due to backwards compatibility with ERC20
298      * @param _from address The address which you want to send tokens from
299      * @param _to address The address which you want to transfer to
300      * @param _value uint256 the amount of tokens to be transferred
301      */
302     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
303         require(_to != address(0)
304                 && _value > 0
305                 && balanceOf[_from] >= _value
306                 && allowance[_from][msg.sender] >= _value
307                 && frozenAccount[_from] == false
308                 && frozenAccount[_to] == false
309                 && now > unlockUnixTime[_from]
310                 && now > unlockUnixTime[_to]);
311 
312         balanceOf[_from] = balanceOf[_from].sub(_value);
313         balanceOf[_to] = balanceOf[_to].add(_value);
314         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
315         Transfer(_from, _to, _value);
316         return true;
317     }
318 
319     /**
320      * @dev Allows _spender to spend no more than _value tokens in your behalf
321      *      Added due to backwards compatibility with ERC20
322      * @param _spender The address authorized to spend
323      * @param _value the max amount they can spend
324      */
325     function approve(address _spender, uint256 _value) public returns (bool success) {
326         allowance[msg.sender][_spender] = _value;
327         Approval(msg.sender, _spender, _value);
328         return true;
329     }
330 
331     /**
332      * @dev Function to check the amount of tokens that an owner allowed to a spender
333      *      Added due to backwards compatibility with ERC20
334      * @param _owner address The address which owns the funds
335      * @param _spender address The address which will spend the funds
336      */
337     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
338         return allowance[_owner][_spender];
339     }
340 
341 
342 
343     /**
344      * @dev Burns a specific amount of tokens.
345      * @param _from The address that will burn the tokens.
346      * @param _unitAmount The amount of token to be burned.
347      */
348     function burn(address _from, uint256 _unitAmount) onlyOwner public {
349         require(_unitAmount > 0
350                 && balanceOf[_from] >= _unitAmount);
351 
352         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
353         totalSupply = totalSupply.sub(_unitAmount);
354         Burn(_from, _unitAmount);
355     }
356 
357 
358     modifier canMint() {
359         require(!mintingFinished);
360         _;
361     }
362 
363     /**
364      * @dev Function to mint tokens
365      * @param _to The address that will receive the minted tokens.
366      * @param _unitAmount The amount of tokens to mint.
367      */
368     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
369         require(_unitAmount > 0);
370 
371         totalSupply = totalSupply.add(_unitAmount);
372         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
373         Mint(_to, _unitAmount);
374         Transfer(address(0), _to, _unitAmount);
375         return true;
376     }
377 
378     /**
379      * @dev Function to stop minting new tokens.
380      */
381     function finishMinting() onlyOwner canMint public returns (bool) {
382         mintingFinished = true;
383         MintFinished();
384         return true;
385     }
386 
387 
388 
389     /**
390      * @dev Function to distribute tokens to the list of addresses by the provided amount
391      */
392     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
393         require(amount > 0
394                 && addresses.length > 0
395                 && frozenAccount[msg.sender] == false
396                 && now > unlockUnixTime[msg.sender]);
397 
398         amount = amount.mul(1e8);
399         uint256 totalAmount = amount.mul(addresses.length);
400         require(balanceOf[msg.sender] >= totalAmount);
401 
402         for (uint j = 0; j < addresses.length; j++) {
403             require(addresses[j] != 0x0
404                     && frozenAccount[addresses[j]] == false
405                     && now > unlockUnixTime[addresses[j]]);
406 
407             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
408             Transfer(msg.sender, addresses[j], amount);
409         }
410         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
411         return true;
412     }
413 
414     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
415         require(addresses.length > 0
416                 && addresses.length == amounts.length
417                 && frozenAccount[msg.sender] == false
418                 && now > unlockUnixTime[msg.sender]);
419 
420         uint256 totalAmount = 0;
421 
422         for(uint j = 0; j < addresses.length; j++){
423             require(amounts[j] > 0
424                     && addresses[j] != 0x0
425                     && frozenAccount[addresses[j]] == false
426                     && now > unlockUnixTime[addresses[j]]);
427 
428             amounts[j] = amounts[j].mul(1e8);
429             totalAmount = totalAmount.add(amounts[j]);
430         }
431         require(balanceOf[msg.sender] >= totalAmount);
432 
433         for (j = 0; j < addresses.length; j++) {
434             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
435             Transfer(msg.sender, addresses[j], amounts[j]);
436         }
437         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
438         return true;
439     }
440 
441     /**
442      * @dev Function to collect tokens from the list of addresses
443      */
444     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
445         require(addresses.length > 0
446                 && addresses.length == amounts.length);
447 
448         uint256 totalAmount = 0;
449 
450         for (uint j = 0; j < addresses.length; j++) {
451             require(amounts[j] > 0
452                     && addresses[j] != 0x0
453                     && frozenAccount[addresses[j]] == false
454                     && now > unlockUnixTime[addresses[j]]);
455 
456             amounts[j] = amounts[j].mul(1e8);
457             require(balanceOf[addresses[j]] >= amounts[j]);
458             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
459             totalAmount = totalAmount.add(amounts[j]);
460             Transfer(addresses[j], msg.sender, amounts[j]);
461         }
462         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
463         return true;
464     }
465 
466 
467     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
468         distributeAmount = _unitAmount;
469     }
470 
471     /**
472      * @dev Function to distribute tokens to the msg.sender automatically
473      *      If distributeAmount is 0, this function doesn't work
474      */
475 
476 }