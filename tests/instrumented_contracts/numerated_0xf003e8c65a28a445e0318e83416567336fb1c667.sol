1 pragma solidity ^0.4.20;
2 
3 /**
4  * @title ContractReceiver
5  * @dev Receiver for ERC223 tokens
6  */
7 contract ContractReceiver {
8 
9   struct TKN {
10     address sender;
11     uint value;
12     bytes data;
13     bytes4 sig;
14   }
15 
16   function tokenFallback(address _from, uint _value, bytes _data) public pure {
17     TKN memory tkn;
18     tkn.sender = _from;
19     tkn.value = _value;
20     tkn.data = _data;
21     uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
22     tkn.sig = bytes4(u);
23 
24   }
25 }
26 
27 /**
28  * @title Ownable
29  * @dev The Ownable contract has an owner address, and provides basic authorization control
30  * functions, this simplifies the implementation of "user permissions".
31  */
32 contract Ownable {
33   address public owner;
34 
35   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37   /**
38    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39    * account.
40    */
41   function Ownable() public {
42   //constructor() public
43     owner = msg.sender;
44   }
45 
46   /**
47    * @dev Throws if called by any account other than the owner.
48    */
49   modifier onlyOwner() {
50     require(msg.sender == owner);
51     _;
52   }
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) public onlyOwner {
59     require(newOwner != address(0));
60     OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 }
64 
65 
66 /**
67  * @title SafeMath
68  * @dev Math operations with safety checks that throw on error
69  */
70 library SafeMath {
71   /**
72   * @dev Multiplies two numbers, throws on overflow.
73   */
74   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
75     if (a == 0) {
76       return 0;
77     }
78     uint256 c = a * b;
79     assert(c / a == b);
80     return c;
81   }
82 
83   /**
84   * @dev Integer division of two numbers, truncating the quotient.
85   */
86   function div(uint256 a, uint256 b) internal pure returns (uint256) {
87     // assert(b > 0); // Solidity automatically throws when dividing by 0
88     uint256 c = a / b;
89     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90     return c;
91   }
92 
93   /**
94   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
95   */
96   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97     assert(b <= a);
98     return a - b;
99   }
100 
101   /**
102   * @dev Adds two numbers, throws on overflow.
103   */
104   function add(uint256 a, uint256 b) internal pure returns (uint256) {
105     uint256 c = a + b;
106     assert(c >= a);
107     return c;
108   }
109 }
110 
111 contract ERC223 {
112   uint public totalSupply;
113 
114   function name() public view returns (string _name);
115   function symbol() public view returns (string _symbol);
116   function decimals() public view returns (uint8 _decimals);
117   function totalSupply() public view returns (uint256 _supply);
118   function balanceOf(address who) public view returns (uint);
119 
120   function transfer(address to, uint value) public returns (bool ok);
121   function transfer(address to, uint value, bytes data) public returns (bool ok);
122   function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
123   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
124   event Transfer(address indexed _from, address indexed _to, uint256 _value);
125 }
126 
127 contract CarBonCash is ERC223, Ownable {
128   using SafeMath for uint256;
129 
130   string public name = "CarBon Cash";
131   string public symbol = "CBCx";
132   uint8 public decimals = 4;
133   uint256 public initialSupply = 210000000;
134   uint256 public totalSupply;
135   uint256 public distributeAmount = 0;
136   bool public mintingFinished = false;
137   
138   mapping (address => uint) balances;
139   mapping (address => bool) public frozenAccount;
140   mapping (address => uint256) public unlockUnixTime;
141 
142   event FrozenFunds(address indexed target, bool frozen);
143   event LockedFunds(address indexed target, uint256 locked);
144   event Burn(address indexed burner, uint256 value);
145   event Mint(address indexed to, uint256 amount);
146   event MintFinished();
147 
148   function CarBonCash() public {
149     totalSupply = initialSupply;
150     balances[msg.sender] = totalSupply;
151   }
152 
153   function name() public view returns (string _name) {
154       return name;
155   }
156 
157   function symbol() public view returns (string _symbol) {
158       return symbol;
159   }
160 
161   function decimals() public view returns (uint8 _decimals) {
162       return decimals;
163   }
164 
165   function totalSupply() public view returns (uint256 _totalSupply) {
166       return totalSupply;
167   }
168 
169   function balanceOf(address _owner) public view returns (uint balance) {
170     return balances[_owner];
171   }
172 
173   modifier onlyPayloadSize(uint256 size){
174     assert(msg.data.length >= size + 4);
175     _;
176   }
177 
178   // Function that is called when a user or another contract wants to transfer funds .
179   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
180     require(_value > 0
181             && frozenAccount[msg.sender] == false
182             && frozenAccount[_to] == false
183             && now > unlockUnixTime[msg.sender]
184             && now > unlockUnixTime[_to]);
185 
186     if(isContract(_to)) {
187         if (balanceOf(msg.sender) < _value) revert();
188         balances[msg.sender] = SafeMath.sub(balanceOf(msg.sender), _value);
189         balances[_to] = SafeMath.add(balanceOf(_to), _value);
190         assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
191          Transfer(msg.sender, _to, _value, _data);
192          Transfer(msg.sender, _to, _value);
193         return true;
194     }
195     else {
196         return transferToAddress(_to, _value, _data);
197     }
198   }
199 
200 
201   // Function that is called when a user or another contract wants to transfer funds .
202   function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
203     require(_value > 0
204             && frozenAccount[msg.sender] == false
205             && frozenAccount[_to] == false
206             && now > unlockUnixTime[msg.sender]
207             && now > unlockUnixTime[_to]);
208 
209     if(isContract(_to)) {
210         return transferToContract(_to, _value, _data);
211     }
212     else {
213         return transferToAddress(_to, _value, _data);
214     }
215   }
216 
217   // Standard function transfer similar to ERC20 transfer with no _data .
218   // Added due to backwards compatibility reasons .
219   function transfer(address _to, uint _value) public returns (bool success) {
220     require(_value > 0
221             && frozenAccount[msg.sender] == false
222             && frozenAccount[_to] == false
223             && now > unlockUnixTime[msg.sender]
224             && now > unlockUnixTime[_to]);
225 
226     //standard function transfer similar to ERC20 transfer with no _data
227     //added due to backwards compatibility reasons
228     bytes memory empty;
229     if(isContract(_to)) {
230         return transferToContract(_to, _value, empty);
231     }
232     else {
233         return transferToAddress(_to, _value, empty);
234     }
235   }
236 
237   // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
238   function isContract(address _addr) private view returns (bool is_contract) {
239     uint length;
240     assembly {
241       // retrieve the size of the code on target address, this needs assembly
242       length := extcodesize(_addr)
243     }
244     return (length>0);
245   }
246 
247   // function that is called when transaction target is an address
248   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
249     if (balanceOf(msg.sender) < _value) revert();
250     balances[msg.sender] = SafeMath.sub(balanceOf(msg.sender), _value);
251     balances[_to] = SafeMath.add(balanceOf(_to), _value);
252   Transfer(msg.sender, _to, _value, _data);
253   Transfer(msg.sender, _to, _value);
254     return true;
255   }
256 
257   //function that is called when transaction target is a contract
258   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
259     if (balanceOf(msg.sender) < _value) revert();
260     balances[msg.sender] = SafeMath.sub(balanceOf(msg.sender), _value);
261     balances[_to] = SafeMath.add(balanceOf(_to), _value);
262     ContractReceiver receiver = ContractReceiver(_to);
263     receiver.tokenFallback(msg.sender, _value, _data);
264  Transfer(msg.sender, _to, _value, _data);
265  Transfer(msg.sender, _to, _value);
266     return true;
267   }
268 
269   /**
270    * @dev Prevent targets from sending or receiving tokens
271    * @param targets Addresses to be frozen
272    * @param isFrozen either to freeze it or not
273    */
274   function freezeAccounts(address[] targets, bool isFrozen) onlyOwner public {
275     require(targets.length > 0);
276 
277     for (uint i = 0; i < targets.length; i++) {
278       require(targets[i] != 0x0);
279       frozenAccount[targets[i]] = isFrozen;
280       FrozenFunds(targets[i], isFrozen);
281     }
282   }
283 
284   /**
285    * @dev Prevent targets from sending or receiving tokens by setting Unix times
286    * @param targets Addresses to be locked funds
287    * @param unixTimes Unix times when locking up will be finished
288    */
289   function lockupAccounts(address[] targets, uint[] unixTimes) onlyOwner public {
290     require(targets.length > 0
291             && targets.length == unixTimes.length);
292 
293     for(uint i = 0; i < targets.length; i++){
294       require(unlockUnixTime[targets[i]] < unixTimes[i]);
295       unlockUnixTime[targets[i]] = unixTimes[i];
296       LockedFunds(targets[i], unixTimes[i]);
297     }
298   }
299 
300   /**
301    * @dev Burns a specific amount of tokens.
302    * @param _from The address that will burn the tokens.
303    * @param _unitAmount The amount of token to be burned.
304    */
305   function burn(address _from, uint256 _unitAmount) onlyOwner public {
306     require(_unitAmount > 0
307             && balanceOf(_from) >= _unitAmount);
308 
309     balances[_from] = SafeMath.sub(balances[_from], _unitAmount);
310     totalSupply = SafeMath.sub(totalSupply, _unitAmount);
311    Burn(_from, _unitAmount);
312   }
313 
314   modifier canMint() {
315     require(!mintingFinished);
316     _;
317   }
318 
319   /**
320    * @dev Function to mint tokens
321    * @param _to The address that will receive the minted tokens.
322    * @param _unitAmount The amount of tokens to mint.
323    */
324   function mint(address _to, uint256 _unitAmount) onlyOwner canMint public returns (bool) {
325     require(_unitAmount > 0);
326 
327     totalSupply = SafeMath.add(totalSupply, _unitAmount);
328     balances[_to] = SafeMath.add(balances[_to], _unitAmount);
329     Mint(_to, _unitAmount);
330     Transfer(address(0), _to, _unitAmount);
331     return true;
332   }
333 
334   /**
335    * @dev Function to stop minting new tokens.
336    */
337   function finishMinting() onlyOwner canMint public returns (bool) {
338     mintingFinished = true;
339     MintFinished();
340     return true;
341   }
342 
343   /**
344    * @dev Function to distribute tokens to the list of addresses by the provided amount
345    */
346   function distributeTokens(address[] addresses, uint256 amount) public returns (bool) {
347     require(amount > 0
348             && addresses.length > 0
349             && frozenAccount[msg.sender] == false
350             && now > unlockUnixTime[msg.sender]);
351 
352     amount = SafeMath.mul(amount, 1e8);
353     uint256 totalAmount = SafeMath.mul(amount, addresses.length);
354     require(balances[msg.sender] >= totalAmount);
355 
356     for (uint i = 0; i < addresses.length; i++) {
357       require(addresses[i] != 0x0
358               && frozenAccount[addresses[i]] == false
359               && now > unlockUnixTime[addresses[i]]);
360 
361       balances[addresses[i]] = SafeMath.add(balances[addresses[i]], amount);
362       Transfer(msg.sender, addresses[i], amount);
363     }
364     balances[msg.sender] = SafeMath.sub(balances[msg.sender], totalAmount);
365     return true;
366   }
367 
368   /**
369    * @dev Function to collect tokens from the list of addresses
370    */
371   function collectTokens(address[] addresses, uint[] amounts) onlyOwner public returns (bool) {
372     require(addresses.length > 0
373             && addresses.length == amounts.length);
374 
375     uint256 totalAmount = 0;
376 
377     for (uint i = 0; i < addresses.length; i++) {
378       require(amounts[i] > 0
379               && addresses[i] != 0x0
380               && frozenAccount[addresses[i]] == false
381               && now > unlockUnixTime[addresses[i]]);
382 
383       amounts[i] = SafeMath.mul(amounts[i], 1e8);
384       require(balances[addresses[i]] >= amounts[i]);
385       balances[addresses[i]] = SafeMath.sub(balances[addresses[i]], amounts[i]);
386       totalAmount = SafeMath.add(totalAmount, amounts[i]);
387       Transfer(addresses[i], msg.sender, amounts[i]);
388     }
389     balances[msg.sender] = SafeMath.add(balances[msg.sender], totalAmount);
390     return true;
391   }
392 
393   function setDistributeAmount(uint256 _unitAmount) onlyOwner public {
394     distributeAmount = _unitAmount;
395   }
396 
397   /**
398    * @dev Function to distribute tokens to the msg.sender automatically
399    *      If distributeAmount is 0, this function doesn't work
400    */
401   function autoDistribute() payable public {
402     require(distributeAmount > 0
403             && balanceOf(owner) >= distributeAmount
404             && frozenAccount[msg.sender] == false
405             && now > unlockUnixTime[msg.sender]);
406     if (msg.value > 0) owner.transfer(msg.value);
407     
408     balances[owner] = SafeMath.sub(balances[owner], distributeAmount);
409     balances[msg.sender] = SafeMath.add(balances[msg.sender], distributeAmount);
410     Transfer(owner, msg.sender, distributeAmount);
411   }
412 
413   /**
414    * @dev token fallback function
415    */
416   function() payable public {
417     autoDistribute();
418   }
419 }