1 pragma solidity ^0.4.25;
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
32 /**
33  * @title Ownable
34  * @dev The Ownable contract has an owner address, and provides basic authorization
35  *      control functions, this simplifies the implementation of "user permissions".
36  */
37 contract Ownable {
38     address public owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     /**
43      * @dev The Ownable constructor sets the original `owner` of the contract to the
44      *      sender account.
45      */
46     function Ownable() public {
47         owner = msg.sender;
48     }
49 
50     /**
51      * @dev Throws if called by any account other than the owner.
52      */
53     modifier onlyOwner() {
54         require(msg.sender == owner);
55         _;
56     }
57 
58     /**
59      * @dev Allows the current owner to transfer control of the contract to a newOwner.
60      * @param newOwner The address to transfer ownership to.
61      */
62     function transferOwnership(address newOwner) onlyOwner public {
63         require(newOwner != address(0));
64         OwnershipTransferred(owner, newOwner);
65         owner = newOwner;
66     }
67 }
68 
69 contract ERC223 {
70     uint public totalSupply;
71 
72     // ERC223 and ERC20 functions and events
73     function balanceOf(address who) public view returns (uint);
74     function totalSupply() public view returns (uint256 _supply);
75     function transfer(address to, uint value) public returns (bool ok);
76     function transfer(address to, uint value, bytes data) public returns (bool ok);
77     function transfer(address to, uint value, bytes data, string customFallback) public returns (bool ok);
78     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
79 
80     // ERC223 functions
81     function name() public view returns (string _name);
82     function symbol() public view returns (string _symbol);
83     function decimals() public view returns (uint8 _decimals);
84 
85     // ERC20 functions and events
86     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
87     function approve(address _spender, uint256 _value) public returns (bool success);
88     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
89     event Transfer(address indexed _from, address indexed _to, uint256 _value);
90     event Approval(address indexed _owner, address indexed _spender, uint _value);
91 }
92 
93 
94 
95 /**
96  * @title ContractReceiver
97  * @dev Contract that is working with ERC223 tokens
98  */
99  contract ContractReceiver {
100 
101     struct TKN {
102         address sender;
103         uint value;
104         bytes data;
105         bytes4 sig;
106     }
107 
108     function tokenFallback(address _from, uint _value, bytes _data) public pure {
109         TKN memory tkn;
110         tkn.sender = _from;
111         tkn.value = _value;
112         tkn.data = _data;
113         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
114         tkn.sig = bytes4(u);
115 
116         /*
117          * tkn variable is analogue of msg variable of Ether transaction
118          * tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
119          * tkn.value the number of tokens that were sent   (analogue of msg.value)
120          * tkn.data is data of token transaction   (analogue of msg.data)
121          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
122          */
123     }
124 }
125 
126 
127 contract ENERGY is ERC223, Ownable {
128     using SafeMath for uint256;
129 
130     string public name = "ENERGY";
131     string public symbol = "ERG";
132     uint8 public decimals = 18;
133     uint256 public totalSupply = 3e8 * 1e18;
134     bool public mintingFinished = false;
135 
136     address public founder = 0xd31d6589a4a31680a080fD8C2D337fA082d2147d;
137     address public AirDrop = 0xE7dfE192abd0997b3C194ac918d1c960d591E3ed;
138     address public LongTerm = 0xD067a36f0e05eb6C4AADabd36F4bC6B4a7AF2e39;
139 
140     mapping(address => uint256) public balanceOf;
141     mapping(address => mapping (address => uint256)) public allowance;
142     mapping (address => bool) public frozenAccount;
143     mapping (address => uint256) public unlockUnixTime;
144 
145     event FrozenFunds(address indexed target, bool frozen);
146     event LockedFunds(address indexed target, uint256 locked);
147     event Burn(address indexed from, uint256 amount);
148     event Mint(address indexed to, uint256 amount);
149     event MintFinished();
150 
151 
152     /**
153      * @dev Constructor is called only once and can not be called again
154      */
155     function ENERGY() public {
156         owner = founder;
157         balanceOf[founder] = totalSupply.mul(70).div(100);
158         balanceOf[AirDrop] = totalSupply.mul(20).div(100);
159         balanceOf[LongTerm] = totalSupply.mul(10).div(100);
160     }
161 
162     function name() public view returns (string _name) {
163         return name;
164     }
165 
166     function symbol() public view returns (string _symbol) {
167         return symbol;
168     }
169 
170     function decimals() public view returns (uint8 _decimals) {
171         return decimals;
172     }
173 
174     function totalSupply() public view returns (uint256 _totalSupply) {
175         return totalSupply;
176     }
177 
178     function balanceOf(address _owner) public view returns (uint256 balance) {
179         return balanceOf[_owner];
180     }
181 
182     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
183         require(targets.length > 0);
184 
185         for (uint j = 0; j < targets.length; j++) {
186             require(targets[j] != 0x0);
187             frozenAccount[targets[j]] = isFrozen;
188             FrozenFunds(targets[j], isFrozen);
189         }
190     }
191 
192     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
193         require(targets.length > 0
194                 && targets.length == unixTimes.length);
195 
196         for(uint j = 0; j < targets.length; j++){
197             require(unlockUnixTime[targets[j]] < unixTimes[j]);
198             unlockUnixTime[targets[j]] = unixTimes[j];
199             LockedFunds(targets[j], unixTimes[j]);
200         }
201     }
202 
203 
204     /**
205      * @dev Function that is called when a user or another contract wants to transfer funds
206      */
207     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
208         require(_value > 0
209                 && frozenAccount[msg.sender] == false
210                 && frozenAccount[_to] == false
211                 && now > unlockUnixTime[msg.sender]
212                 && now > unlockUnixTime[_to]);
213 
214         if (isContract(_to)) {
215             require(balanceOf[msg.sender] >= _value);
216             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
217             balanceOf[_to] = balanceOf[_to].add(_value);
218             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
219             Transfer(msg.sender, _to, _value, _data);
220             Transfer(msg.sender, _to, _value);
221             return true;
222         } else {
223             return transferToAddress(_to, _value, _data);
224         }
225     }
226 
227     function transfer(address _to, uint _value, bytes _data) public  returns (bool success) {
228         require(_value > 0
229                 && frozenAccount[msg.sender] == false
230                 && frozenAccount[_to] == false
231                 && now > unlockUnixTime[msg.sender]
232                 && now > unlockUnixTime[_to]);
233 
234         if (isContract(_to)) {
235             return transferToContract(_to, _value, _data);
236         } else {
237             return transferToAddress(_to, _value, _data);
238         }
239     }
240 
241     /**
242      * @dev Standard function transfer similar to ERC20 transfer with no _data
243      *      Added due to backwards compatibility reasons
244      */
245     function transfer(address _to, uint _value) public returns (bool success) {
246         require(_value > 0
247                 && frozenAccount[msg.sender] == false
248                 && frozenAccount[_to] == false
249                 && now > unlockUnixTime[msg.sender]
250                 && now > unlockUnixTime[_to]);
251 
252         bytes memory empty;
253         if (isContract(_to)) {
254             return transferToContract(_to, _value, empty);
255         } else {
256             return transferToAddress(_to, _value, empty);
257         }
258     }
259 
260     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
261     function isContract(address _addr) private view returns (bool is_contract) {
262         uint length;
263         assembly {
264             //retrieve the size of the code on target address, this needs assembly
265             length := extcodesize(_addr)
266         }
267         return (length > 0);
268     }
269 
270     // function that is called when transaction target is an address
271     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
272         require(balanceOf[msg.sender] >= _value);
273         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
274         balanceOf[_to] = balanceOf[_to].add(_value);
275         Transfer(msg.sender, _to, _value, _data);
276         Transfer(msg.sender, _to, _value);
277         return true;
278     }
279 
280     // function that is called when transaction target is a contract
281     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
282         require(balanceOf[msg.sender] >= _value);
283         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
284         balanceOf[_to] = balanceOf[_to].add(_value);
285         ContractReceiver receiver = ContractReceiver(_to);
286         receiver.tokenFallback(msg.sender, _value, _data);
287         Transfer(msg.sender, _to, _value, _data);
288         Transfer(msg.sender, _to, _value);
289         return true;
290     }
291 
292 
293 
294     /**
295      * @dev Transfer tokens from one address to another
296      *      Added due to backwards compatibility with ERC20
297      * @param _from address The address which you want to send tokens from
298      * @param _to address The address which you want to transfer to
299      * @param _value uint256 the amount of tokens to be transferred
300      */
301     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
302         require(_to != address(0)
303                 && _value > 0
304                 && balanceOf[_from] >= _value
305                 && allowance[_from][msg.sender] >= _value
306                 && frozenAccount[_from] == false
307                 && frozenAccount[_to] == false
308                 && now > unlockUnixTime[_from]
309                 && now > unlockUnixTime[_to]);
310 
311         balanceOf[_from] = balanceOf[_from].sub(_value);
312         balanceOf[_to] = balanceOf[_to].add(_value);
313         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
314         Transfer(_from, _to, _value);
315         return true;
316     }
317 
318     /**
319      * @dev Allows _spender to spend no more than _value tokens in your behalf
320      *      Added due to backwards compatibility with ERC20
321      * @param _spender The address authorized to spend
322      * @param _value the max amount they can spend
323      */
324     function approve(address _spender, uint256 _value) public returns (bool success) {
325         allowance[msg.sender][_spender] = _value;
326         Approval(msg.sender, _spender, _value);
327         return true;
328     }
329 
330     /**
331      * @dev Function to check the amount of tokens that an owner allowed to a spender
332      *      Added due to backwards compatibility with ERC20
333      * @param _owner address The address which owns the funds
334      * @param _spender address The address which will spend the funds
335      */
336     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
337         return allowance[_owner][_spender];
338     }
339 
340 
341 
342     /**
343      * @dev Burns a specific amount of tokens.
344      * @param _from The address that will burn the tokens.
345      * @param _unitAmount The amount of token to be burned.
346      */
347     function burn(address _from, uint256 _unitAmount) onlyOwner public {
348         require(_unitAmount > 0
349                 && balanceOf[_from] >= _unitAmount);
350 
351         balanceOf[_from] = balanceOf[_from].sub(_unitAmount);
352         totalSupply = totalSupply.sub(_unitAmount);
353         Burn(_from, _unitAmount);
354     }
355 
356 
357     modifier canMint() {
358         require(!mintingFinished);
359         _;
360     }
361 
362     /**
363      * @dev Function to mint tokens
364      * @param _to The address that will receive the minted tokens.
365      * @param _unitAmount The amount of tokens to mint.
366      */
367     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
368         require(_unitAmount > 0);
369 
370         totalSupply = totalSupply.add(_unitAmount);
371         balanceOf[_to] = balanceOf[_to].add(_unitAmount);
372         Mint(_to, _unitAmount);
373         Transfer(address(0), _to, _unitAmount);
374         return true;
375     }
376 
377     /**
378      * @dev Function to stop minting new tokens.
379      */
380     function finishMinting() onlyOwner canMint public returns (bool) {
381         mintingFinished = true;
382         MintFinished();
383         return true;
384     }
385 
386 
387 
388     /**
389      * @dev Function to distribute tokens to the list of addresses by the provided amount
390      */
391     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
392         require(amount > 0
393                 && addresses.length > 0
394                 && frozenAccount[msg.sender] == false
395                 && now > unlockUnixTime[msg.sender]);
396 
397         amount = amount.mul(1e8);
398         uint256 totalAmount = amount.mul(addresses.length);
399         require(balanceOf[msg.sender] >= totalAmount);
400 
401         for (uint j = 0; j < addresses.length; j++) {
402             require(addresses[j] != 0x0
403                     && frozenAccount[addresses[j]] == false
404                     && now > unlockUnixTime[addresses[j]]);
405 
406             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amount);
407             Transfer(msg.sender, addresses[j], amount);
408         }
409         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
410         return true;
411     }
412 
413     function distributeAirdrop(address[] addresses, uint[] amounts) public returns (bool) {
414         require(addresses.length > 0
415                 && addresses.length == amounts.length
416                 && frozenAccount[msg.sender] == false
417                 && now > unlockUnixTime[msg.sender]);
418 
419         uint256 totalAmount = 0;
420 
421         for(uint j = 0; j < addresses.length; j++){
422             require(amounts[j] > 0
423                     && addresses[j] != 0x0
424                     && frozenAccount[addresses[j]] == false
425                     && now > unlockUnixTime[addresses[j]]);
426 
427             amounts[j] = amounts[j].mul(1e8);
428             totalAmount = totalAmount.add(amounts[j]);
429         }
430         require(balanceOf[msg.sender] >= totalAmount);
431 
432         for (j = 0; j < addresses.length; j++) {
433             balanceOf[addresses[j]] = balanceOf[addresses[j]].add(amounts[j]);
434             Transfer(msg.sender, addresses[j], amounts[j]);
435         }
436         balanceOf[msg.sender] = balanceOf[msg.sender].sub(totalAmount);
437         return true;
438     }
439 
440     /**
441      * @dev Function to collect tokens from the list of addresses
442      */
443     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
444         require(addresses.length > 0
445                 && addresses.length == amounts.length);
446 
447         uint256 totalAmount = 0;
448 
449         for (uint j = 0; j < addresses.length; j++) {
450             require(amounts[j] > 0
451                     && addresses[j] != 0x0
452                     && frozenAccount[addresses[j]] == false
453                     && now > unlockUnixTime[addresses[j]]);
454 
455             amounts[j] = amounts[j].mul(1e8);
456             require(balanceOf[addresses[j]] >= amounts[j]);
457             balanceOf[addresses[j]] = balanceOf[addresses[j]].sub(amounts[j]);
458             totalAmount = totalAmount.add(amounts[j]);
459             Transfer(addresses[j], msg.sender, amounts[j]);
460         }
461         balanceOf[msg.sender] = balanceOf[msg.sender].add(totalAmount);
462         return true;
463     }
464 }