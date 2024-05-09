1 pragma solidity ^0.4.18;
2 // ----------------------------------------------------------------------------
3 // 'TPC' 'TP Coin' token contract
4 //
5 // Symbol      : TPC
6 // Name        : TP Coin
7 // Total supply: 300,000,000.0000000000
8 // Decimals    : 8
9 //
10 // Enjoy.
11 //
12 // (c) Yat Hong / Wedoops International 2018. The MIT Licence.
13 // ----------------------------------------------------------------------------
14 /**
15  * Math operations with safety checks
16  */
17 library SafeMath {
18   function mul(uint a, uint b) internal pure returns (uint) {
19     uint c = a * b;
20     assert(a == 0 || c / a == b);
21     return c;
22   }
23 
24   function div(uint a, uint b) internal pure returns (uint) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   function sub(uint a, uint b) internal pure returns (uint) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   function add(uint a, uint b) internal pure returns (uint) {
37     uint c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 
42   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
43     return a >= b ? a : b;
44   }
45 
46   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
47     return a < b ? a : b;
48   }
49 
50   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
51     return a >= b ? a : b;
52   }
53 
54   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
55     return a < b ? a : b;
56   }
57 }
58 
59 contract MultiOwner {
60     /* Constructor */
61     event OwnerAdded(address newOwner);
62     event OwnerRemoved(address oldOwner);
63 	event RequirementChanged(uint256 newRequirement);
64 	
65     uint256 public ownerRequired;
66     mapping (address => bool) public isOwner;
67 	mapping (address => bool) public RequireDispose;
68 	address[] owners;
69 	
70 	function MultiOwner(address[] _owners, uint256 _required) public {
71         ownerRequired = _required;
72         isOwner[msg.sender] = true;
73         owners.push(msg.sender);
74         
75         for (uint256 i = 0; i < _owners.length; ++i){
76 			require(!isOwner[_owners[i]]);
77 			isOwner[_owners[i]] = true;
78 			owners.push(_owners[i]);
79         }
80     }
81     
82 	modifier onlyOwner {
83 	    require(isOwner[msg.sender]);
84         _;
85     }
86     
87 	modifier ownerDoesNotExist(address owner) {
88 		require(!isOwner[owner]);
89         _;
90     }
91 
92     modifier ownerExists(address owner) {
93 		require(isOwner[owner]);
94         _;
95     }
96     
97     function addOwner(address owner) onlyOwner ownerDoesNotExist(owner) external{
98         isOwner[owner] = true;
99         owners.push(owner);
100         OwnerAdded(owner);
101     }
102     
103 	function numberOwners() public constant returns (uint256 NumberOwners){
104 	    NumberOwners = owners.length;
105 	}
106 	
107     function removeOwner(address owner) onlyOwner ownerExists(owner) external{
108 		require(owners.length > 2);
109         isOwner[owner] = false;
110 		RequireDispose[owner] = false;
111         for (uint256 i=0; i<owners.length - 1; i++){
112             if (owners[i] == owner) {
113 				owners[i] = owners[owners.length - 1];
114                 break;
115             }
116 		}
117 		owners.length -= 1;
118         OwnerRemoved(owner);
119     }
120     
121 	function changeRequirement(uint _newRequired) onlyOwner external {
122 		require(_newRequired >= owners.length);
123         ownerRequired = _newRequired;
124         RequirementChanged(_newRequired);
125     }
126 	
127 	function ConfirmDispose() onlyOwner() public view returns (bool){
128 		uint count = 0;
129 		for (uint i=0; i<owners.length - 1; i++)
130             if (RequireDispose[owners[i]])
131                 count += 1;
132             if (count == ownerRequired)
133                 return true;
134 	}
135 	
136 	function kill() onlyOwner() public{
137 		RequireDispose[msg.sender] = true;
138 		if(ConfirmDispose()){
139 			selfdestruct(msg.sender);
140 		}
141     }
142 }
143 
144 interface ERC20{
145     function transfer(address _to, uint _value, bytes _data) public;
146     function transfer(address _to, uint256 _value) public;
147     function transferFrom(address _from, address _to, uint256 _value, bool _feed, uint256 _fees) public returns (bool success);
148     function setPrices(uint256 newValue) public;
149     function freezeAccount(address target, bool freeze) public;
150     function() payable public;
151 	function remainBalanced() public constant returns (uint256);
152 	function execute(address _to, uint _value, bytes _data) external returns (bytes32 _r);
153 	function isConfirmed(bytes32 TransHash) public constant returns (bool);
154 	function confirmationCount(bytes32 TransHash) external constant returns (uint count);
155     function confirmTransaction(bytes32 TransHash) public;
156     function executeTransaction(bytes32 TransHash) public;
157 	function AccountVoid(address _from) public;
158 	function burn(uint amount) public;
159 	function bonus(uint amount) public;
160     
161     event SubmitTransaction(bytes32 transactionHash);
162 	event Confirmation(address sender, bytes32 transactionHash);
163 	event Execution(bytes32 transactionHash);
164 	event FrozenFunds(address target, bool frozen);
165     event Transfer(address indexed from, address indexed to, uint value);
166 	event FeePaid(address indexed from, address indexed to, uint256 value);
167 	event VoidAccount(address indexed from, address indexed to, uint256 value);
168 	event Bonus(uint256 value);
169 	event Burn(uint256 value);
170 }
171 
172 interface ERC223 {
173     function transfer(address to, uint value, bytes data) public;
174     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
175 }
176 
177 contract Token is MultiOwner, ERC20, ERC223{
178 	using SafeMath for uint256;
179 	
180 	string public name = "TP Coin";
181 	string public symbol = "TPC";
182 	uint8 public decimals = 8;
183 	uint256 public totalSupply = 300000000 * 10 ** uint256(decimals);
184 	uint256 public EthPerToken = 300000000;
185 	
186 	mapping(address => uint256) public balanceOf;
187 	mapping(address => bool) public frozenAccount;
188 	mapping (bytes32 => mapping (address => bool)) public Confirmations;
189 	mapping (bytes32 => Transaction) public Transactions;
190 	
191 	struct Transaction {
192 		address destination;
193 		uint value;
194 		bytes data;
195 		bool executed;
196     }
197 	
198 	modifier notNull(address destination) {
199 		require (destination != 0x0);
200         _;
201     }
202 	
203 	modifier confirmed(bytes32 transactionHash) {
204 		require (Confirmations[transactionHash][msg.sender]);
205         _;
206     }
207 
208     modifier notConfirmed(bytes32 transactionHash) {
209 		require (!Confirmations[transactionHash][msg.sender]);
210         _;
211     }
212 	
213 	modifier notExecuted(bytes32 TransHash) {
214 		require (!Transactions[TransHash].executed);
215         _;
216     }
217     
218 	function Token(address[] _owners, uint256 _required) MultiOwner(_owners, _required) public {
219 		balanceOf[msg.sender] = totalSupply;
220     }
221 	
222 	/* Internal transfer, only can be called by this contract */
223     function _transfer(address _from, address _to, uint256 _value) internal {
224         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
225         require (balanceOf[_from] >= _value);                // Check if the sender has enough
226         require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
227         require(!frozenAccount[_from]);                     // Check if sender is frozen
228 		uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
229         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
230         balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient
231         Transfer(_from, _to, _value);
232 		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
233     }
234     
235     function transfer(address _to, uint _value, bytes _data) public {
236         require(_value > 0 );
237         if(isContract(_to)) {
238             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
239             receiver.tokenFallback(msg.sender, _value, _data);
240         }
241         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
242         balanceOf[_to] = balanceOf[_to].add(_value);
243         Transfer(msg.sender, _to, _value, _data);
244     }
245     
246     function isContract(address _addr) private view returns (bool is_contract) {
247         uint length;
248         assembly {
249             //retrieve the size of the code on target address, this needs assembly
250             length := extcodesize(_addr)
251         }
252         return (length>0);
253     }
254 	
255 	/* Internal transfer, only can be called by this contract */
256     function _collect_fee(address _from, address _to, uint256 _value) internal {
257         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
258         require (balanceOf[_from] >= _value);                // Check if the sender has enough
259         require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
260         require(!frozenAccount[_from]);                     // Check if sender is frozen
261 		uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
262         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
263         balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient
264 		FeePaid(_from, _to, _value);
265 		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
266     }
267 	
268 	function transfer(address _to, uint256 _value) public {
269 		_transfer(msg.sender, _to, _value);
270 	}
271 		
272 	function transferFrom(address _from, address _to, uint256 _value, bool _feed, uint256 _fees) onlyOwner public returns (bool success) {
273 		uint256 charge = 0 ;
274 		uint256 t_value = _value;
275 		if(_feed){
276 			charge = _value * _fees / 100;
277 		}else{
278 			charge = _value - (_value / (_fees + 100) * 100);
279 		}
280 		t_value = _value.sub(charge);
281 		require(t_value.add(charge) == _value);
282         _transfer(_from, _to, t_value);
283 		_collect_fee(_from, this, charge);
284         return true;
285     }
286 	
287 	function setPrices(uint256 newValue) onlyOwner public {
288         EthPerToken = newValue;
289     }
290 	
291     function freezeAccount(address target, bool freeze) onlyOwner public {
292         frozenAccount[target] = freeze;
293         FrozenFunds(target, freeze);
294     }
295 	
296 	function() payable public{
297 		require(msg.value > 0);
298 		uint amount = msg.value * 10 ** uint256(decimals) * EthPerToken / 1 ether;
299         _transfer(this, msg.sender, amount);
300     }
301 	
302 	function remainBalanced() public constant returns (uint256){
303         return balanceOf[this];
304     }
305 	
306 	/*Transfer Eth */
307 	function execute(address _to, uint _value, bytes _data) notNull(_to) onlyOwner external returns (bytes32 _r) {
308 		_r = addTransaction(_to, _value, _data);
309 		confirmTransaction(_r);
310     }
311 	
312 	function addTransaction(address destination, uint value, bytes data) private notNull(destination) returns (bytes32 TransHash){
313         TransHash = keccak256(destination, value, data);
314         if (Transactions[TransHash].destination == 0) {
315             Transactions[TransHash] = Transaction({
316                 destination: destination,
317                 value: value,
318                 data: data,
319                 executed: false
320             });
321             SubmitTransaction(TransHash);
322         }
323     }
324 	
325 	function addConfirmation(bytes32 TransHash) private onlyOwner notConfirmed(TransHash){
326         Confirmations[TransHash][msg.sender] = true;
327         Confirmation(msg.sender, TransHash);
328     }
329 	
330 	function isConfirmed(bytes32 TransHash) public constant returns (bool){
331         uint count = 0;
332         for (uint i=0; i<owners.length; i++)
333             if (Confirmations[TransHash][owners[i]])
334                 count += 1;
335             if (count == ownerRequired)
336                 return true;
337     }
338 	
339 	function confirmationCount(bytes32 TransHash) external constant returns (uint count){
340         for (uint i=0; i<owners.length; i++)
341             if (Confirmations[TransHash][owners[i]])
342                 count += 1;
343     }
344     
345     function confirmTransaction(bytes32 TransHash) public onlyOwner(){
346         addConfirmation(TransHash);
347         executeTransaction(TransHash);
348     }
349     
350     function executeTransaction(bytes32 TransHash) public notExecuted(TransHash){
351         if (isConfirmed(TransHash)) {
352 			Transactions[TransHash].executed = true;
353             require(Transactions[TransHash].destination.call.value(Transactions[TransHash].value)(Transactions[TransHash].data));
354             Execution(TransHash);
355         }
356     }
357 	
358 	function AccountVoid(address _from) onlyOwner public{
359 		require (balanceOf[_from] > 0); 
360 		uint256 CurrentBalances = balanceOf[_from];
361 		uint256 previousBalances = balanceOf[_from] + balanceOf[msg.sender];
362         balanceOf[_from] -= CurrentBalances;                         
363         balanceOf[msg.sender] += CurrentBalances;
364 		VoidAccount(_from, msg.sender, CurrentBalances);
365 		assert(balanceOf[_from] + balanceOf[msg.sender] == previousBalances);	
366 	}
367 	
368 	function burn(uint amount) onlyOwner public{
369 		uint BurnValue = amount * 10 ** uint256(decimals);
370 		require(balanceOf[this] >= BurnValue);
371 		balanceOf[this] -= BurnValue;
372 		totalSupply -= BurnValue;
373 		Burn(BurnValue);
374 	}
375 	
376 	function bonus(uint amount) onlyOwner public{
377 		uint BonusValue = amount * 10 ** uint256(decimals);
378 		require(balanceOf[this] + BonusValue > balanceOf[this]);
379 		balanceOf[this] += BonusValue;
380 		totalSupply += BonusValue;
381 		Bonus(BonusValue);
382 	}
383 }
384 
385 contract ERC223ReceivingContract { 
386 /**
387  * @dev Standard ERC223 function that will handle incoming token transfers.
388  *
389  * @param _from  Token sender address.
390  * @param _value Amount of tokens.
391  * @param _data  Transaction metadata.
392  */
393     function tokenFallback(address _from, uint _value, bytes _data) public;
394 }