1 pragma solidity ^0.4.15;
2 
3 contract MultiOwner {
4     /* Constructor */
5     event OwnerAdded(address newOwner);
6     event OwnerRemoved(address oldOwner);
7 	event RequirementChanged(uint256 newRequirement);
8 	
9     uint256 public ownerRequired;
10     mapping (address => bool) public isOwner;
11 	mapping (address => bool) public RequireDispose;
12 	address[] owners;
13 	
14 	function MultiOwner(address[] _owners, uint256 _required) public {
15         ownerRequired = _required;
16         isOwner[msg.sender] = true;
17         owners.push(msg.sender);
18         
19         for (uint256 i = 0; i < _owners.length; ++i){
20 			require(!isOwner[_owners[i]]);
21 			isOwner[_owners[i]] = true;
22 			owners.push(_owners[i]);
23         }
24     }
25     
26 	modifier onlyOwner {
27 	    require(isOwner[msg.sender]);
28         _;
29     }
30     
31 	modifier ownerDoesNotExist(address owner) {
32 		require(!isOwner[owner]);
33         _;
34     }
35 
36     modifier ownerExists(address owner) {
37 		require(isOwner[owner]);
38         _;
39     }
40     
41     function addOwner(address owner) onlyOwner ownerDoesNotExist(owner) external{
42         isOwner[owner] = true;
43         owners.push(owner);
44         OwnerAdded(owner);
45     }
46     
47 	function numberOwners() public constant returns (uint256 NumberOwners){
48 	    NumberOwners = owners.length;
49 	}
50 	
51     function removeOwner(address owner) onlyOwner ownerExists(owner) external{
52 		require(owners.length > 2);
53         isOwner[owner] = false;
54 		RequireDispose[owner] = false;
55         for (uint256 i=0; i<owners.length - 1; i++){
56             if (owners[i] == owner) {
57 				owners[i] = owners[owners.length - 1];
58                 break;
59             }
60 		}
61 		owners.length -= 1;
62         OwnerRemoved(owner);
63     }
64     
65 	function changeRequirement(uint _newRequired) onlyOwner external {
66 		require(_newRequired >= owners.length);
67         ownerRequired = _newRequired;
68         RequirementChanged(_newRequired);
69     }
70 	
71 	function ConfirmDispose() onlyOwner() returns (bool){
72 		uint count = 0;
73 		for (uint i=0; i<owners.length - 1; i++)
74             if (RequireDispose[owners[i]])
75                 count += 1;
76             if (count == ownerRequired)
77                 return true;
78 	}
79 	
80 	function kill() onlyOwner(){
81 		RequireDispose[msg.sender] = true;
82 		if(ConfirmDispose()){
83 			selfdestruct(msg.sender);
84 		}
85     }
86 }
87 
88 contract VVToken is MultiOwner{
89 	event SubmitTransaction(bytes32 transactionHash);
90 	event Confirmation(address sender, bytes32 transactionHash);
91 	event Execution(bytes32 transactionHash);
92 	event FrozenFunds(address target, bool frozen);
93 	event Transfer(address indexed from, address indexed to, uint256 value);
94 	event FeePaid(address indexed from, address indexed to, uint256 value);
95 	event VoidAccount(address indexed from, address indexed to, uint256 value);
96 	event Bonus(uint256 value);
97 	event Burn(uint256 value);
98 	
99 	string public name = "VV Coin";
100 	string public symbol = "VVI";
101 	uint8 public decimals = 8;
102 	uint256 public totalSupply = 3000000000 * 10 ** uint256(decimals);
103 	uint256 public EthPerToken = 300000;
104 	uint256 public ChargeFee = 2;
105 	
106 	mapping(address => uint256) public balanceOf;
107 	mapping(address => bool) public frozenAccount;
108 	mapping (bytes32 => mapping (address => bool)) public Confirmations;
109 	mapping (bytes32 => Transaction) public Transactions;
110 	
111 	struct Transaction {
112 		address destination;
113 		uint value;
114 		bytes data;
115 		bool executed;
116     }
117 	
118 	modifier notNull(address destination) {
119 		require (destination != 0x0);
120         _;
121     }
122 	
123 	modifier confirmed(bytes32 transactionHash) {
124 		require (Confirmations[transactionHash][msg.sender]);
125         _;
126     }
127 
128     modifier notConfirmed(bytes32 transactionHash) {
129 		require (!Confirmations[transactionHash][msg.sender]);
130         _;
131     }
132 	
133 	modifier notExecuted(bytes32 TransHash) {
134 		require (!Transactions[TransHash].executed);
135         _;
136     }
137     
138 	function VVToken(address[] _owners, uint256 _required) MultiOwner(_owners, _required) public {
139 		balanceOf[msg.sender] = totalSupply;                    
140     }
141 	
142 	/* Internal transfer, only can be called by this contract */
143     function _transfer(address _from, address _to, uint256 _value) internal {
144         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
145         require (balanceOf[_from] >= _value);                // Check if the sender has enough
146         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
147         require(!frozenAccount[_from]);                     // Check if sender is frozen
148 		uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
149         balanceOf[_from] -= _value;                         // Subtract from the sender
150         balanceOf[_to] += _value;                           // Add the same to the recipient
151         Transfer(_from, _to, _value);
152 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
153     }
154 	
155 	/* Internal transfer, only can be called by this contract */
156     function _collect_fee(address _from, address _to, uint256 _value) internal {
157         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
158         require (balanceOf[_from] >= _value);                // Check if the sender has enough
159         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
160         require(!frozenAccount[_from]);                     // Check if sender is frozen
161 		uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
162         balanceOf[_from] -= _value;                         // Subtract from the sender
163         balanceOf[_to] += _value;                           // Add the same to the recipient
164 		FeePaid(_from, _to, _value);
165 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
166     }
167 	
168 	function transfer(address _to, uint256 _value) public {
169 		_transfer(msg.sender, _to, _value);
170 	}
171 		
172 	function transferFrom(address _from, address _to, uint256 _value, bool _fee) onlyOwner public returns (bool success) {
173 		uint256 charge = 0 ;
174 		uint256 t_value = _value;
175 		if(_fee){
176 			charge = _value * ChargeFee / 100;
177 		}else{
178 			charge = _value - (_value / (ChargeFee + 100) * 100);
179 		}
180 		t_value = _value - charge;
181 		require(t_value + charge == _value);
182         _transfer(_from, _to, t_value);
183 		_collect_fee(_from, this, charge);
184         return true;
185     }
186 	
187 	function setPrices(uint256 newValue) onlyOwner public {
188         EthPerToken = newValue;
189     }
190     
191 	function setFee(uint256 newValue) onlyOwner public {
192         ChargeFee = newValue;
193     }
194 	
195     function freezeAccount(address target, bool freeze) onlyOwner public {
196         frozenAccount[target] = freeze;
197         FrozenFunds(target, freeze);
198     }
199 	
200 	function() payable {
201 		require(msg.value > 0);
202 		uint amount = msg.value * 10 ** uint256(decimals) * EthPerToken / 1 ether;
203         _transfer(this, msg.sender, amount);
204     }
205 	
206 	function remainBalanced() public constant returns (uint256){
207         return balanceOf[this];
208     }
209 	
210 	/*Transfer Eth */
211 	function execute(address _to, uint _value, bytes _data) notNull(_to) onlyOwner external returns (bytes32 _r) {
212 		_r = addTransaction(_to, _value, _data);
213 		confirmTransaction(_r);
214     }
215 	
216 	function addTransaction(address destination, uint value, bytes data) private notNull(destination) returns (bytes32 TransHash){
217         TransHash = sha3(destination, value, data);
218         if (Transactions[TransHash].destination == 0) {
219             Transactions[TransHash] = Transaction({
220                 destination: destination,
221                 value: value,
222                 data: data,
223                 executed: false
224             });
225             SubmitTransaction(TransHash);
226         }
227     }
228 	
229 	function addConfirmation(bytes32 TransHash) private onlyOwner notConfirmed(TransHash){
230         Confirmations[TransHash][msg.sender] = true;
231         Confirmation(msg.sender, TransHash);
232     }
233 	
234 	function isConfirmed(bytes32 TransHash) public constant returns (bool){
235         uint count = 0;
236         for (uint i=0; i<owners.length; i++)
237             if (Confirmations[TransHash][owners[i]])
238                 count += 1;
239             if (count == ownerRequired)
240                 return true;
241     }
242 	
243 	function confirmationCount(bytes32 TransHash) external constant returns (uint count){
244         for (uint i=0; i<owners.length; i++)
245             if (Confirmations[TransHash][owners[i]])
246                 count += 1;
247     }
248     
249     function confirmTransaction(bytes32 TransHash) public onlyOwner(){
250         addConfirmation(TransHash);
251         executeTransaction(TransHash);
252     }
253     
254     function executeTransaction(bytes32 TransHash) public notExecuted(TransHash){
255         if (isConfirmed(TransHash)) {
256 			Transactions[TransHash].executed = true;
257             require(Transactions[TransHash].destination.call.value(Transactions[TransHash].value)(Transactions[TransHash].data));
258             Execution(TransHash);
259         }
260     }
261 	
262 	function AccountVoid(address _from) onlyOwner public{
263 		require (balanceOf[_from] > 0); 
264 		uint256 CurrentBalances = balanceOf[_from];
265 		uint256 previousBalances = balanceOf[_from] + balanceOf[msg.sender];
266         balanceOf[_from] -= CurrentBalances;                         
267         balanceOf[msg.sender] += CurrentBalances;
268 		VoidAccount(_from, msg.sender, CurrentBalances);
269 		assert(balanceOf[_from] + balanceOf[msg.sender] == previousBalances);	
270 	}
271 	
272 	function burn(uint amount) onlyOwner{
273 		uint BurnValue = amount * 10 ** uint256(decimals);
274 		require(balanceOf[this] >= BurnValue);
275 		balanceOf[this] -= BurnValue;
276 		totalSupply -= BurnValue;
277 		Burn(BurnValue);
278 	}
279 	
280 	function bonus(uint amount) onlyOwner{
281 		uint BonusValue = amount * 10 ** uint256(decimals);
282 		require(balanceOf[this] + BonusValue > balanceOf[this]);
283 		balanceOf[this] += BonusValue;
284 		totalSupply += BonusValue;
285 		Bonus(BonusValue);
286 	}
287 }