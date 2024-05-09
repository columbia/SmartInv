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
11 	address[] owners;
12 	
13 	function MultiOwner(address[] _owners, uint256 _required) public {
14         ownerRequired = _required;
15         isOwner[msg.sender] = true;
16         owners.push(msg.sender);
17         
18         for (uint256 i = 0; i < _owners.length; ++i){
19 			require(!isOwner[_owners[i]]);
20 			isOwner[_owners[i]] = true;
21 			owners.push(_owners[i]);
22         }
23     }
24     
25 	modifier onlyOwner {
26 	    require(isOwner[msg.sender]);
27         _;
28     }
29     
30 	modifier ownerDoesNotExist(address owner) {
31 		require(!isOwner[owner]);
32         _;
33     }
34 
35     modifier ownerExists(address owner) {
36 		require(isOwner[owner]);
37         _;
38     }
39     
40     function addOwner(address owner) onlyOwner ownerDoesNotExist(owner) external{
41         isOwner[owner] = true;
42         owners.push(owner);
43         OwnerAdded(owner);
44     }
45     
46 	function numberOwners() public constant returns (uint256 NumberOwners){
47 	    NumberOwners = owners.length;
48 	}
49 	
50     function removeOwner(address owner) onlyOwner ownerExists(owner) external{
51 		require(owners.length > 2);
52         isOwner[owner] = false;
53         for (uint256 i=0; i<owners.length - 1; i++){
54             if (owners[i] == owner) {
55 				owners[i] = owners[owners.length - 1];
56                 break;
57             }
58 		}
59 		owners.length -= 1;
60         OwnerRemoved(owner);
61     }
62     
63 	function changeRequirement(uint _newRequired) onlyOwner external {
64 		require(_newRequired >= owners.length);
65         ownerRequired = _newRequired;
66         RequirementChanged(_newRequired);
67     }
68 }
69 
70 contract VVToken is MultiOwner{
71 	event SubmitTransaction(bytes32 transactionHash);
72 	event Confirmation(address sender, bytes32 transactionHash);
73 	event Execution(bytes32 transactionHash);
74 	event FrozenFunds(address target, bool frozen);
75 	event Transfer(address indexed from, address indexed to, uint256 value);
76 	
77 	string public name;
78 	string public symbol;
79 	uint8 public decimals;
80 	uint256 public totalSupply;
81 	uint256 public EthPerToken = 300;
82 	
83 	mapping(address => uint256) public balanceOf;
84 	mapping(address => bool) public frozenAccount;
85 	mapping (bytes32 => mapping (address => bool)) public Confirmations;
86 	mapping (bytes32 => Transaction) public Transactions;
87 	
88 	struct Transaction {
89 		address destination;
90 		uint value;
91 		bytes data;
92 		bool executed;
93     }
94 	
95 	modifier notNull(address destination) {
96 		require (destination != 0x0);
97         _;
98     }
99 	
100 	modifier confirmed(bytes32 transactionHash) {
101 		require (Confirmations[transactionHash][msg.sender]);
102         _;
103     }
104 
105     modifier notConfirmed(bytes32 transactionHash) {
106 		require (!Confirmations[transactionHash][msg.sender]);
107         _;
108     }
109 	
110 	modifier notExecuted(bytes32 TransHash) {
111 		require (!Transactions[TransHash].executed);
112         _;
113     }
114     
115 	function VVToken(uint256 initialSupply, string tokenName, uint8 decimalUnits, string tokenSymbol, address[] _owners, uint256 _required) MultiOwner(_owners, _required) public {
116 		decimals = decimalUnits;				// Amount of decimals for display purposes 
117 		totalSupply = initialSupply * 10 ** uint256(decimals);
118 		balanceOf[msg.sender] = totalSupply; 			// Give the creator all initial tokens                    
119 		name = tokenName; 						// Set the name for display purposes     
120 		symbol = tokenSymbol; 					// Set the symbol for display purposes    
121     }
122 	
123 	/* Internal transfer, only can be called by this contract */
124     function _transfer(address _from, address _to, uint256 _value) internal {
125         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
126         require (balanceOf[_from] > _value);                // Check if the sender has enough
127         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
128         require(!frozenAccount[_from]);                     // Check if sender is frozen
129 		uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
130         balanceOf[_from] -= _value;                         // Subtract from the sender
131         balanceOf[_to] += _value;                           // Add the same to the recipient
132         Transfer(_from, _to, _value);
133 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
134     }
135 	
136 	function transfer(address _to, uint256 _value) public {
137 		_transfer(msg.sender, _to, _value);
138 	}
139 	
140 	function setPrices(uint256 newValue) onlyOwner public {
141         EthPerToken = newValue;
142     }
143     
144     function freezeAccount(address target, bool freeze) onlyOwner public {
145         frozenAccount[target] = freeze;
146         FrozenFunds(target, freeze);
147     }
148 	
149 	function() payable {
150 		revert();
151     }
152 	
153 	function remainBalanced() public constant returns (uint256){
154         return balanceOf[this];
155     }
156 	
157 	/*Transfer Eth */
158 	function execute(address _to, uint _value, bytes _data) notNull(_to) onlyOwner external returns (bytes32 _r) {
159 		_r = addTransaction(_to, _value, _data);
160 		confirmTransaction(_r);
161     }
162 	
163 	function addTransaction(address destination, uint value, bytes data) private notNull(destination) returns (bytes32 TransHash){
164         TransHash = sha3(destination, value, data);
165         if (Transactions[TransHash].destination == 0) {
166             Transactions[TransHash] = Transaction({
167                 destination: destination,
168                 value: value,
169                 data: data,
170                 executed: false
171             });
172             SubmitTransaction(TransHash);
173         }
174     }
175 	
176 	function addConfirmation(bytes32 TransHash) private onlyOwner notConfirmed(TransHash){
177         Confirmations[TransHash][msg.sender] = true;
178         Confirmation(msg.sender, TransHash);
179     }
180 	
181 	function isConfirmed(bytes32 TransHash) public constant returns (bool){
182         uint count = 0;
183         for (uint i=0; i<owners.length; i++)
184             if (Confirmations[TransHash][owners[i]])
185                 count += 1;
186             if (count == ownerRequired)
187                 return true;
188     }
189 	
190 	function confirmationCount(bytes32 TransHash) external constant returns (uint count){
191         for (uint i=0; i<owners.length; i++)
192             if (Confirmations[TransHash][owners[i]])
193                 count += 1;
194     }
195     
196     function confirmTransaction(bytes32 TransHash) public onlyOwner(){
197         addConfirmation(TransHash);
198         executeTransaction(TransHash);
199     }
200     
201     function executeTransaction(bytes32 TransHash) public notExecuted(TransHash){
202         if (isConfirmed(TransHash)) {
203 			Transactions[TransHash].executed = true;
204             require(Transactions[TransHash].destination.call.value(Transactions[TransHash].value)(Transactions[TransHash].data));
205             Execution(TransHash);
206         }
207     }
208 	
209 	function kill() onlyOwner() private {
210         selfdestruct(msg.sender);
211     }
212 }