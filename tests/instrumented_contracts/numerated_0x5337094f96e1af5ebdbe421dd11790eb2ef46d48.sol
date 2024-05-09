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
82   uint public totalSupply;
83 
84     // ERC223 functions
85     function name() public view returns (string _name);
86     function symbol() public view returns (string _symbol);
87     function decimals() public view returns (uint8 _decimals);
88     function totalSupply() public view returns (uint256 _supply);
89     function balanceOf(address who) public view returns (uint);
90 
91     // ERC223 functions and events
92     function transfer(address to, uint value) public returns (bool ok);
93     function transfer(address to, uint value, bytes data) public returns (bool ok);
94     function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
95     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
96     event Transfer(address indexed _from, address indexed _to, uint256 _value);
97 }
98 
99 
100 /**
101  * @title ContractReceiver
102  * @dev Contract that is working with ERC223 tokens
103  */
104  contract ContractReceiver {
105 
106     struct TKN {
107         address sender;
108         uint value;
109         bytes data;
110         bytes4 sig;
111     }
112 
113     function tokenFallback(address _from, uint _value, bytes _data) public pure {
114         TKN memory tkn;
115         tkn.sender = _from;
116         tkn.value = _value;
117         tkn.data = _data;
118         uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
119         tkn.sig = bytes4(u);
120 
121         /**
122          * tkn variable is analogue of msg variable of Ether transaction
123          * tkn.sender is person who initiated this token transaction (analogue of msg.sender)
124          * tkn.value the number of tokens that were sent (analogue of msg.value)
125          * tkn.data is data of token transaction (analogue of msg.data)
126          * tkn.sig is 4 bytes signature of function if data of token transaction is a function execution
127          */
128     }
129 }
130 
131 
132 /**
133  * @title NIZIGEN
134  * @author NIZIGEN
135  * @dev NIZIGEN is an ERC223 Token with ERC20 functions and events
136  *      Fully backward compatible with ERC20
137  */
138 contract NIZIGEN is ERC223, Ownable {
139     using SafeMath for uint256;
140 
141     string public name = "NIZIGEN";
142     string public symbol = "2D";
143     uint8 public decimals = 8;
144     uint256 public initialSupply = 50e9 * 1e8;
145     uint256 public totalSupply;
146     uint256 public distributeAmount = 0;
147     bool public mintingFinished = false;
148 
149     mapping (address => uint) balances;
150     mapping (address => bool) public frozenAccount;
151     mapping (address => uint256) public unlockUnixTime;
152 
153     event FrozenFunds(address indexed target, bool frozen);
154     event LockedFunds(address indexed target, uint256 locked);
155     event Burn(address indexed burner, uint256 value);
156     event Mint(address indexed to, uint256 amount);
157     event MintFinished();
158 
159     function NIZIGEN() public {
160         totalSupply = initialSupply;
161         balances[msg.sender] = totalSupply;
162     }
163 
164     function name() public view returns (string _name) {
165         return name;
166     }
167 
168     function symbol() public view returns (string _symbol) {
169         return symbol;
170     }
171 
172     function decimals() public view returns (uint8 _decimals) {
173         return decimals;
174     }
175 
176     function totalSupply() public view returns (uint256 _totalSupply) {
177         return totalSupply;
178     }
179 
180     function balanceOf(address _owner) public view returns (uint balance) {
181       return balances[_owner];
182     }
183 
184     modifier onlyPayloadSize(uint256 size){
185       assert(msg.data.length >= size + 4);
186       _;
187     }
188 
189     /**
190      * @dev Prevent targets from sending or receiving tokens
191      * @param targets Addresses to be frozen
192      * @param isFrozen either to freeze it or not
193      */
194     function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
195       require(targets.length > 0);
196 
197       for (uint i = 0; i < targets.length; i++) {
198         require(targets[i] != 0x0);
199         frozenAccount[targets[i]] = isFrozen;
200         FrozenFunds(targets[i], isFrozen);
201       }
202     }
203 
204     /**
205      * @dev Prevent targets from sending or receiving tokens by setting Unix times
206      * @param targets Addresses to be locked funds
207      * @param unixTimes Unix times when locking up will be finished
208      */
209     function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
210       require(targets.length > 0
211               && targets.length == unixTimes.length);
212 
213       for(uint i = 0; i < targets.length; i++){
214         require(unlockUnixTime[targets[i]] < unixTimes[i]);
215         unlockUnixTime[targets[i]] = unixTimes[i];
216         LockedFunds(targets[i], unixTimes[i]);
217       }
218     }
219 
220     // Function that is called when a user or another contract wants to transfer funds .
221     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
222       require(_value > 0
223               && frozenAccount[msg.sender] == false
224               && frozenAccount[_to] == false
225               && now > unlockUnixTime[msg.sender]
226               && now > unlockUnixTime[_to]);
227 
228       if(isContract(_to)) {
229           if (balanceOf(msg.sender) < _value) revert();
230           balances[msg.sender] = SafeMath.sub(balanceOf(msg.sender), _value);
231           balances[_to] = SafeMath.add(balanceOf(_to), _value);
232           assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
233           Transfer(msg.sender, _to, _value, _data);
234           Transfer(msg.sender, _to, _value);
235           return true;
236       }
237       else {
238           return transferToAddress(_to, _value, _data);
239       }
240     }
241 
242     // Function that is called when a user or another contract wants to transfer funds .
243     function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
244       require(_value > 0
245               && frozenAccount[msg.sender] == false
246               && frozenAccount[_to] == false
247               && now > unlockUnixTime[msg.sender]
248               && now > unlockUnixTime[_to]);
249 
250       if(isContract(_to)) {
251           return transferToContract(_to, _value, _data);
252       }
253       else {
254           return transferToAddress(_to, _value, _data);
255       }
256     }
257 
258     // Standard function transfer similar to ERC20 transfer with no _data .
259     // Added due to backwards compatibility reasons .
260     function transfer(address _to, uint _value) public returns (bool success) {
261       require(_value > 0
262               && frozenAccount[msg.sender] == false
263               && frozenAccount[_to] == false
264               && now > unlockUnixTime[msg.sender]
265               && now > unlockUnixTime[_to]);
266 
267       //standard function transfer similar to ERC20 transfer with no _data
268       //added due to backwards compatibility reasons
269       bytes memory empty;
270       if(isContract(_to)) {
271           return transferToContract(_to, _value, empty);
272       }
273       else {
274           return transferToAddress(_to, _value, empty);
275       }
276     }
277 
278     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
279     function isContract(address _addr) private view returns (bool is_contract) {
280       uint length;
281       assembly {
282         // retrieve the size of the code on target address, this needs assembly
283         length := extcodesize(_addr)
284       }
285       return (length>0);
286     }
287 
288     // function that is called when transaction target is an address
289     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
290       if (balanceOf(msg.sender) < _value) revert();
291       balances[msg.sender] = SafeMath.sub(balanceOf(msg.sender), _value);
292       balances[_to] = SafeMath.add(balanceOf(_to), _value);
293       Transfer(msg.sender, _to, _value, _data);
294       Transfer(msg.sender, _to, _value);
295       return true;
296     }
297 
298     //function that is called when transaction target is a contract
299     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
300       if (balanceOf(msg.sender) < _value) revert();
301       balances[msg.sender] = SafeMath.sub(balanceOf(msg.sender), _value);
302       balances[_to] = SafeMath.add(balanceOf(_to), _value);
303       ContractReceiver receiver = ContractReceiver(_to);
304       receiver.tokenFallback(msg.sender, _value, _data);
305       Transfer(msg.sender, _to, _value, _data);
306       Transfer(msg.sender, _to, _value);
307       return true;
308     }
309 
310     /**
311      * @dev Burns a specific amount of tokens.
312      * @param _from The address that will burn the tokens.
313      * @param _unitAmount The amount of token to be burned.
314      */
315     function burn(address _from, uint256 _unitAmount) onlyOwner public {
316       require(_unitAmount > 0
317               && balanceOf(_from) >= _unitAmount);
318 
319       balances[_from] = SafeMath.sub(balances[_from], _unitAmount);
320       totalSupply = SafeMath.sub(totalSupply, _unitAmount);
321       Burn(_from, _unitAmount);
322     }
323 
324     modifier canMint() {
325       require(!mintingFinished);
326       _;
327     }
328 
329     /**
330      * @dev Function to mint tokens
331      * @param _to The address that will receive the minted tokens.
332      * @param _unitAmount The amount of tokens to mint.
333      */
334     function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
335       require(_unitAmount > 0);
336 
337       totalSupply = SafeMath.add(totalSupply, _unitAmount);
338       balances[_to] = SafeMath.add(balances[_to], _unitAmount);
339       Mint(_to, _unitAmount);
340       Transfer(address(0), _to, _unitAmount);
341       return true;
342     }
343 
344     /**
345      * @dev Function to stop minting new tokens.
346      */
347     function finishMinting() onlyOwner canMint public returns (bool) {
348       mintingFinished = true;
349       MintFinished();
350       return true;
351     }
352 
353     /**
354      * @dev Function to distribute tokens to the list of addresses by the provided amount
355      */
356     function distributeAirdrop(address[] addresses, uint256 amount) public returns (bool) {
357       require(amount > 0
358               && addresses.length > 0
359               && frozenAccount[msg.sender] == false
360               && now > unlockUnixTime[msg.sender]);
361 
362       amount = SafeMath.mul(amount, 1e8);
363       uint256 totalAmount = SafeMath.mul(amount, addresses.length);
364       require(balances[msg.sender] >= totalAmount);
365 
366       for (uint i = 0; i < addresses.length; i++) {
367           require(addresses[i] != 0x0
368                 && frozenAccount[addresses[i]] == false
369                 && now > unlockUnixTime[addresses[i]]);
370 
371           balances[addresses[i]] = SafeMath.add(balances[addresses[i]], amount);
372           Transfer(msg.sender, addresses[i], amount);
373       }
374       balances[msg.sender] = SafeMath.sub(balances[msg.sender], totalAmount);
375       return true;
376     }
377 
378     /**
379      * @dev Function to collect tokens from the list of addresses
380      */
381     function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
382       require(addresses.length > 0
383               && addresses.length == amounts.length);
384 
385       uint256 totalAmount = 0;
386 
387       for (uint i = 0; i < addresses.length; i++) {
388         require(amounts[i] > 0
389                 && addresses[i] != 0x0
390                 && frozenAccount[addresses[i]] == false
391                 && now > unlockUnixTime[addresses[i]]);
392 
393         amounts[i] = SafeMath.mul(amounts[i], 1e8);
394         require(balances[addresses[i]] >= amounts[i]);
395         balances[addresses[i]] = SafeMath.sub(balances[addresses[i]], amounts[i]);
396         totalAmount = SafeMath.add(totalAmount, amounts[i]);
397         Transfer(addresses[i], msg.sender, amounts[i]);
398       }
399         balances[msg.sender] = SafeMath.add(balances[msg.sender], totalAmount);
400         return true;
401       }
402 
403     function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
404       distributeAmount = _unitAmount;
405     }
406 
407     /**
408      * @dev Function to distribute tokens to the msg.sender automatically
409      *      If distributeAmount is 0, this function doesn't work
410      */
411     function autoDistribute() payable public {
412       require(distributeAmount > 0
413               && balanceOf(owner) >= distributeAmount
414               && frozenAccount[msg.sender] == false
415               && now > unlockUnixTime[msg.sender]);
416       if (msg.value > 0) owner.transfer(msg.value);
417 
418       balances[owner] = SafeMath.sub(balances[owner], distributeAmount);
419       balances[msg.sender] = SafeMath.add(balances[msg.sender], distributeAmount);
420       Transfer(owner, msg.sender, distributeAmount);
421     }
422 
423     /**
424      * @dev token fallback function
425      */
426     function() payable public {
427       autoDistribute();
428     }
429 }