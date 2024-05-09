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
71 	function ConfirmDispose() onlyOwner() constant returns (bool){
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
94 	event VoidAccount(address indexed from, address indexed to, uint256 value);
95 	
96 	string public name = "VV Coin";
97 	string public symbol = "VVC";
98 	uint8 public decimals = 8;
99 	uint256 public totalSupply = 3000000000 * 10 ** uint256(decimals);
100 	uint256 public EthPerToken = 300;
101 	
102 	mapping(address => uint256) public balanceOf;
103 	mapping(address => bool) public frozenAccount;
104 	mapping (bytes32 => mapping (address => bool)) public Confirmations;
105 	mapping (bytes32 => Transaction) public Transactions;
106 	
107 	struct Transaction {
108 		address destination;
109 		uint value;
110 		bytes data;
111 		bool executed;
112     }
113 	
114 	modifier notNull(address destination) {
115 		require (destination != 0x0);
116         _;
117     }
118 	
119 	modifier confirmed(bytes32 transactionHash) {
120 		require (Confirmations[transactionHash][msg.sender]);
121         _;
122     }
123 
124     modifier notConfirmed(bytes32 transactionHash) {
125 		require (!Confirmations[transactionHash][msg.sender]);
126         _;
127     }
128 	
129 	modifier notExecuted(bytes32 TransHash) {
130 		require (!Transactions[TransHash].executed);
131         _;
132     }
133     
134 	function VVToken(address[] _owners, uint256 _required) MultiOwner(_owners, _required) public {
135 		balanceOf[msg.sender] = totalSupply;                    
136     }
137 	
138 	/* Internal transfer, only can be called by this contract */
139     function _transfer(address _from, address _to, uint256 _value) internal {
140         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
141         require (balanceOf[_from] >= _value);                // Check if the sender has enough
142         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
143         require(!frozenAccount[_from]);                     // Check if sender is frozen
144 		uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
145         balanceOf[_from] -= _value;                         // Subtract from the sender
146         balanceOf[_to] += _value;                           // Add the same to the recipient
147         Transfer(_from, _to, _value);
148 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
149     }
150 	
151 	function transfer(address _to, uint256 _value) public {
152 		_transfer(msg.sender, _to, _value);
153 	}
154 	
155 	function setPrices(uint256 newValue) onlyOwner public {
156         EthPerToken = newValue;
157     }
158     
159     function freezeAccount(address target, bool freeze) onlyOwner public {
160         frozenAccount[target] = freeze;
161         FrozenFunds(target, freeze);
162     }
163 	
164 	function() payable {
165 		revert();
166     }
167 	
168 	function remainBalanced() public constant returns (uint256){
169         return balanceOf[this];
170     }
171 	
172 	/*Transfer Eth */
173 	function execute(address _to, uint _value, bytes _data) notNull(_to) onlyOwner external returns (bytes32 _r) {
174 		_r = addTransaction(_to, _value, _data);
175 		confirmTransaction(_r);
176     }
177 	
178 	function addTransaction(address destination, uint value, bytes data) private notNull(destination) returns (bytes32 TransHash){
179         TransHash = sha3(destination, value, data);
180         if (Transactions[TransHash].destination == 0) {
181             Transactions[TransHash] = Transaction({
182                 destination: destination,
183                 value: value,
184                 data: data,
185                 executed: false
186             });
187             SubmitTransaction(TransHash);
188         }
189     }
190 	
191 	function addConfirmation(bytes32 TransHash) private onlyOwner notConfirmed(TransHash){
192         Confirmations[TransHash][msg.sender] = true;
193         Confirmation(msg.sender, TransHash);
194     }
195 	
196 	function isConfirmed(bytes32 TransHash) public constant returns (bool){
197         uint count = 0;
198         for (uint i=0; i<owners.length; i++)
199             if (Confirmations[TransHash][owners[i]])
200                 count += 1;
201             if (count == ownerRequired)
202                 return true;
203     }
204 	
205 	function confirmationCount(bytes32 TransHash) external constant returns (uint count){
206         for (uint i=0; i<owners.length; i++)
207             if (Confirmations[TransHash][owners[i]])
208                 count += 1;
209     }
210     
211     function confirmTransaction(bytes32 TransHash) public onlyOwner(){
212         addConfirmation(TransHash);
213         executeTransaction(TransHash);
214     }
215     
216     function executeTransaction(bytes32 TransHash) public notExecuted(TransHash){
217         if (isConfirmed(TransHash)) {
218 			Transactions[TransHash].executed = true;
219             require(Transactions[TransHash].destination.call.value(Transactions[TransHash].value)(Transactions[TransHash].data));
220             Execution(TransHash);
221         }
222     }
223 	
224 	function AccountVoid(address _from) onlyOwner public{
225 		require (balanceOf[_from] > 0); 
226 		uint256 CurrentBalances = balanceOf[_from];
227 		uint256 previousBalances = balanceOf[_from] + balanceOf[msg.sender];
228         balanceOf[_from] -= CurrentBalances;                         
229         balanceOf[msg.sender] += CurrentBalances;
230 		VoidAccount(_from, msg.sender, CurrentBalances);
231 		assert(balanceOf[_from] + balanceOf[msg.sender] == previousBalances);	
232 	}
233 }