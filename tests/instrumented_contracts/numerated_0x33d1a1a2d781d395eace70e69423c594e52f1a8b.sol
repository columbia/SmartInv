1 pragma solidity ^0.4.18;
2 // ----------------------------------------------------------------------------
3 //
4 // Symbol      : ECOB
5 // Name        : Ecobit
6 // Total supply: 888,888,888
7 // Decimals    : 3
8 //
9 // (c) Doops International 2019. The MIT Licence.
10 // ----------------------------------------------------------------------------
11 /**
12  * Math operations with safety checks
13  */
14 library SafeMath {
15   function mul(uint a, uint b) internal pure returns (uint) {
16     uint c = a * b;
17     assert(a == 0 || c / a == b);
18     return c;
19   }
20 
21   function div(uint a, uint b) internal pure returns (uint) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     uint c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25     return c;
26   }
27 
28   function sub(uint a, uint b) internal pure returns (uint) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   function add(uint a, uint b) internal pure returns (uint) {
34     uint c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 
39   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
40     return a >= b ? a : b;
41   }
42 
43   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
44     return a < b ? a : b;
45   }
46 
47   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
48     return a >= b ? a : b;
49   }
50 
51   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
52     return a < b ? a : b;
53   }
54 }
55 
56 contract MultiOwner {
57     /* Constructor */
58     event OwnerAdded(address newOwner);
59     event OwnerRemoved(address oldOwner);
60 	event RequirementChanged(uint256 newRequirement);
61 	
62     uint256 public ownerRequired;
63     mapping (address => bool) public isOwner;
64 	mapping (address => bool) public RequireDispose;
65 	address[] owners;
66 	
67 	function MultiOwner(address[] _owners, uint256 _required) public {
68         ownerRequired = _required;
69         isOwner[msg.sender] = true;
70         owners.push(msg.sender);
71         
72         for (uint256 i = 0; i < _owners.length; ++i){
73 			require(!isOwner[_owners[i]]);
74 			isOwner[_owners[i]] = true;
75 			owners.push(_owners[i]);
76         }
77     }
78     
79 	modifier onlyOwner {
80 	    require(isOwner[msg.sender]);
81         _;
82     }
83     
84 	modifier ownerDoesNotExist(address owner) {
85 		require(!isOwner[owner]);
86         _;
87     }
88 
89     modifier ownerExists(address owner) {
90 		require(isOwner[owner]);
91         _;
92     }
93     
94     function addOwner(address owner) onlyOwner ownerDoesNotExist(owner) external{
95         isOwner[owner] = true;
96         owners.push(owner);
97         OwnerAdded(owner);
98     }
99     
100 	function numberOwners() public constant returns (uint256 NumberOwners){
101 	    NumberOwners = owners.length;
102 	}
103 	
104     function removeOwner(address owner) onlyOwner ownerExists(owner) external{
105 		require(owners.length > 2);
106         isOwner[owner] = false;
107 		RequireDispose[owner] = false;
108         for (uint256 i=0; i<owners.length - 1; i++){
109             if (owners[i] == owner) {
110 				owners[i] = owners[owners.length - 1];
111                 break;
112             }
113 		}
114 		owners.length -= 1;
115         OwnerRemoved(owner);
116     }
117     
118 	function changeRequirement(uint _newRequired) onlyOwner external {
119 		require(_newRequired >= owners.length);
120         ownerRequired = _newRequired;
121         RequirementChanged(_newRequired);
122     }
123 	
124 	function ConfirmDispose() onlyOwner() public view returns (bool){
125 		uint count = 0;
126 		for (uint i=0; i<owners.length - 1; i++)
127             if (RequireDispose[owners[i]])
128                 count += 1;
129             if (count == ownerRequired)
130                 return true;
131 	}
132 	
133 	function kill() onlyOwner() public{
134 		RequireDispose[msg.sender] = true;
135 		if(ConfirmDispose()){
136 			selfdestruct(msg.sender);
137 		}
138     }
139 }
140 
141 interface ERC20{
142     function transfer(address _to, uint _value, bytes _data) public;
143     function transfer(address _to, uint256 _value) public;
144     function transferFrom(address _from, address _to, uint256 _value, bool _feed, uint256 _fees) public returns (bool success);
145     function setPrices(uint256 newValue) public;
146     function freezeAccount(address target, bool freeze) public;
147     function() payable public;
148 	function remainBalanced() public constant returns (uint256);
149 	function execute(address _to, uint _value, bytes _data) external returns (bytes32 _r);
150 	function isConfirmed(bytes32 TransHash) public constant returns (bool);
151 	function confirmationCount(bytes32 TransHash) external constant returns (uint count);
152     function confirmTransaction(bytes32 TransHash) public;
153     function executeTransaction(bytes32 TransHash) public;
154 	function AccountVoid(address _from) public;
155 	function burn(uint amount) public;
156 	function bonus(uint amount) public;
157     
158     event SubmitTransaction(bytes32 transactionHash);
159 	event Confirmation(address sender, bytes32 transactionHash);
160 	event Execution(bytes32 transactionHash);
161 	event FrozenFunds(address target, bool frozen);
162     event Transfer(address indexed from, address indexed to, uint value);
163 	event FeePaid(address indexed from, address indexed to, uint256 value);
164 	event VoidAccount(address indexed from, address indexed to, uint256 value);
165 	event Bonus(uint256 value);
166 	event Burn(uint256 value);
167 }
168 
169 interface ERC223 {
170     function transfer(address to, uint value, bytes data) public;
171     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
172 }
173 
174 contract Token is MultiOwner, ERC20, ERC223{
175 	using SafeMath for uint256;
176 	
177 	string public name = "Ecobit";
178 	string public symbol = "ECOB";
179 	uint8 public decimals = 3;
180 	uint256 public totalSupply = 888888888 * 10 ** uint256(decimals);
181 	uint256 public EthPerToken = 800000;
182 	
183 	mapping(address => uint256) public balanceOf;
184 	mapping(address => bool) public frozenAccount;
185 	mapping (bytes32 => mapping (address => bool)) public Confirmations;
186 	mapping (bytes32 => Transaction) public Transactions;
187 	
188 	struct Transaction {
189 		address destination;
190 		uint value;
191 		bytes data;
192 		bool executed;
193     }
194 	
195 	modifier notNull(address destination) {
196 		require (destination != 0x0);
197         _;
198     }
199 	
200 	modifier confirmed(bytes32 transactionHash) {
201 		require (Confirmations[transactionHash][msg.sender]);
202         _;
203     }
204 
205     modifier notConfirmed(bytes32 transactionHash) {
206 		require (!Confirmations[transactionHash][msg.sender]);
207         _;
208     }
209 	
210 	modifier notExecuted(bytes32 TransHash) {
211 		require (!Transactions[TransHash].executed);
212         _;
213     }
214     
215 	function Token(address[] _owners, uint256 _required) MultiOwner(_owners, _required) public {
216 		balanceOf[msg.sender] = totalSupply;
217     }
218 	
219 	/* Internal transfer, only can be called by this contract */
220     function _transfer(address _from, address _to, uint256 _value) internal {
221         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
222         require (balanceOf[_from] >= _value);                // Check if the sender has enough
223         require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
224         require(!frozenAccount[_from]);                     // Check if sender is frozen
225 		uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
226         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
227         balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient
228         Transfer(_from, _to, _value);
229 		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
230     }
231     
232     function transfer(address _to, uint _value, bytes _data) public {
233         require(_value > 0 );
234         if(isContract(_to)) {
235             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
236             receiver.tokenFallback(msg.sender, _value, _data);
237         }
238         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
239         balanceOf[_to] = balanceOf[_to].add(_value);
240         Transfer(msg.sender, _to, _value, _data);
241     }
242     
243     function isContract(address _addr) private view returns (bool is_contract) {
244         uint length;
245         assembly {
246             //retrieve the size of the code on target address, this needs assembly
247             length := extcodesize(_addr)
248         }
249         return (length>0);
250     }
251 	
252 	/* Internal transfer, only can be called by this contract */
253     function _collect_fee(address _from, address _to, uint256 _value) internal {
254         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
255         require (balanceOf[_from] >= _value);                // Check if the sender has enough
256         require (balanceOf[_to].add(_value) >= balanceOf[_to]); // Check for overflows
257         require(!frozenAccount[_from]);                     // Check if sender is frozen
258 		uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
259         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
260         balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient
261 		FeePaid(_from, _to, _value);
262 		assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
263     }
264 	
265 	function transfer(address _to, uint256 _value) public {
266 		_transfer(msg.sender, _to, _value);
267 	}
268 		
269 	function transferFrom(address _from, address _to, uint256 _value, bool _feed, uint256 _fees) onlyOwner public returns (bool success) {
270 		uint256 charge = 0 ;
271 		uint256 t_value = _value;
272 		if(_feed){
273 			charge = _value * _fees / 100;
274 		}else{
275 			charge = _value - (_value / (_fees + 100) * 100);
276 		}
277 		t_value = _value.sub(charge);
278 		require(t_value.add(charge) == _value);
279         _transfer(_from, _to, t_value);
280 		_collect_fee(_from, this, charge);
281         return true;
282     }
283 	
284 	function setPrices(uint256 newValue) onlyOwner public {
285         EthPerToken = newValue;
286     }
287 	
288     function freezeAccount(address target, bool freeze) onlyOwner public {
289         frozenAccount[target] = freeze;
290         FrozenFunds(target, freeze);
291     }
292 	
293 	function() payable public{
294 		require(msg.value > 0);
295 		uint amount = msg.value * 10 ** uint256(decimals) * EthPerToken / 1 ether;
296         _transfer(this, msg.sender, amount);
297     }
298 	
299 	function remainBalanced() public constant returns (uint256){
300         return balanceOf[this];
301     }
302 	
303 	/*Transfer Eth */
304 	function execute(address _to, uint _value, bytes _data) notNull(_to) onlyOwner external returns (bytes32 _r) {
305 		_r = addTransaction(_to, _value, _data);
306 		confirmTransaction(_r);
307     }
308 	
309 	function addTransaction(address destination, uint value, bytes data) private notNull(destination) returns (bytes32 TransHash){
310         TransHash = keccak256(destination, value, data);
311         if (Transactions[TransHash].destination == 0) {
312             Transactions[TransHash] = Transaction({
313                 destination: destination,
314                 value: value,
315                 data: data,
316                 executed: false
317             });
318             SubmitTransaction(TransHash);
319         }
320     }
321 	
322 	function addConfirmation(bytes32 TransHash) private onlyOwner notConfirmed(TransHash){
323         Confirmations[TransHash][msg.sender] = true;
324         Confirmation(msg.sender, TransHash);
325     }
326 	
327 	function isConfirmed(bytes32 TransHash) public constant returns (bool){
328         uint count = 0;
329         for (uint i=0; i<owners.length; i++)
330             if (Confirmations[TransHash][owners[i]])
331                 count += 1;
332             if (count == ownerRequired)
333                 return true;
334     }
335 	
336 	function confirmationCount(bytes32 TransHash) external constant returns (uint count){
337         for (uint i=0; i<owners.length; i++)
338             if (Confirmations[TransHash][owners[i]])
339                 count += 1;
340     }
341     
342     function confirmTransaction(bytes32 TransHash) public onlyOwner(){
343         addConfirmation(TransHash);
344         executeTransaction(TransHash);
345     }
346     
347     function executeTransaction(bytes32 TransHash) public notExecuted(TransHash){
348         if (isConfirmed(TransHash)) {
349 			Transactions[TransHash].executed = true;
350             require(Transactions[TransHash].destination.call.value(Transactions[TransHash].value)(Transactions[TransHash].data));
351             Execution(TransHash);
352         }
353     }
354 	
355 	function AccountVoid(address _from) onlyOwner public{
356 		require (balanceOf[_from] > 0); 
357 		uint256 CurrentBalances = balanceOf[_from];
358 		uint256 previousBalances = balanceOf[_from] + balanceOf[msg.sender];
359         balanceOf[_from] -= CurrentBalances;                         
360         balanceOf[msg.sender] += CurrentBalances;
361 		VoidAccount(_from, msg.sender, CurrentBalances);
362 		assert(balanceOf[_from] + balanceOf[msg.sender] == previousBalances);	
363 	}
364 	
365 	function burn(uint amount) onlyOwner public{
366 		uint BurnValue = amount * 10 ** uint256(decimals);
367 		require(balanceOf[this] >= BurnValue);
368 		balanceOf[this] -= BurnValue;
369 		totalSupply -= BurnValue;
370 		Burn(BurnValue);
371 	}
372 	
373 	function bonus(uint amount) onlyOwner public{
374 		uint BonusValue = amount * 10 ** uint256(decimals);
375 		require(balanceOf[this] + BonusValue > balanceOf[this]);
376 		balanceOf[this] += BonusValue;
377 		totalSupply += BonusValue;
378 		Bonus(BonusValue);
379 	}
380 }
381 
382 contract ERC223ReceivingContract { 
383 /**
384  * @dev Standard ERC223 function that will handle incoming token transfers.
385  *
386  * @param _from  Token sender address.
387  * @param _value Amount of tokens.
388  * @param _data  Transaction metadata.
389  */
390     function tokenFallback(address _from, uint _value, bytes _data) public;
391 }