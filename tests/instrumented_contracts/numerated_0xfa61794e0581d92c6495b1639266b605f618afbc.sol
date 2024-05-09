1 pragma solidity ^0.4.19;
2 
3 /* Interface for ERC20 Tokens */
4 contract Token {
5     bytes32 public standard;
6     bytes32 public name;
7     bytes32 public symbol;
8     uint256 public totalSupply;
9     uint8 public decimals;
10     bool public allowTransactions;
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13     function transfer(address _to, uint256 _value) returns (bool success);
14     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success);
15     function approve(address _spender, uint256 _value) returns (bool success);
16     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
17 }
18 
19 /* Interface for pTokens contract */
20 contract pToken {
21     function redeem(uint256 _value, string memory _btcAddress) public returns (bool _success);
22 }
23 
24 interface IAMB {
25     function messageSender() external view returns (address);
26     function maxGasPerTx() external view returns (uint256);
27     function transactionHash() external view returns (bytes32);
28     function messageId() external view returns (bytes32);
29     function messageSourceChainId() external view returns (bytes32);
30     function messageCallStatus(bytes32 _messageId) external view returns (bool);
31     function failedMessageDataHash(bytes32 _messageId) external view returns (bytes32);
32     function failedMessageReceiver(bytes32 _messageId) external view returns (address);
33     function failedMessageSender(bytes32 _messageId) external view returns (address);
34     function requireToPassMessage(address _contract, bytes _data, uint256 _gas) external returns (bytes32);
35     function requireToConfirmMessage(address _contract, bytes _data, uint256 _gas) external returns (bytes32);
36     function sourceChainId() external view returns (uint256);
37     function destinationChainId() external view returns (uint256);
38 }
39 
40 interface DMEXXDAI {
41     function depositTokenForUser(address token, uint128 amount, address user);
42 }
43 
44 // The DMEX base Contract
45 contract DMEX_Base {
46     address public owner; // holds the address of the contract owner
47     mapping (address => bool) public admins; // mapping of admin addresses
48     address public AMBBridgeContract;
49     address public DMEX_XDAI_CONTRACT;
50 
51     uint256 public inactivityReleasePeriod; // period in blocks before a user can use the withdraw() function
52 
53     bool public destroyed = false; // contract is destoryed
54     uint256 public destroyDelay = 1000000; // number of blocks after destroy, the contract is still active (aprox 6 monthds)
55     uint256 public destroyBlock;
56 
57     uint256 public ambInstructionGas = 2000000;
58 
59     mapping (bytes32 => bool) public processedMessages; // records processed bridge messages, so the same message is not executed twice
60 
61     
62     /**
63      *
64      *  BALNCE FUNCTIONS
65      *
66      **/
67 
68     // Deposit ETH to contract
69     function deposit() payable {
70         if (destroyed) revert();
71         
72         sendDepositInstructionToAMBBridge(msg.sender, address(0), msg.value);
73     }
74 
75     // Deposit token to contract
76     function depositToken(address token, uint128 amount) {
77         if (destroyed) revert();
78         if (!Token(token).transferFrom(msg.sender, this, amount)) throw; // attempts to transfer the token to this contract, if fails throws an error
79         sendDepositInstructionToAMBBridge(msg.sender, token, amount);
80     }
81 
82     // Deposit token to contract for a user
83     function depositTokenForUser(address token, uint128 amount, address user) {    
84         if (destroyed) revert();    
85 
86         if (!Token(token).transferFrom(msg.sender, this, amount)) throw; // attempts to transfer the token to this contract, if fails throws an error
87         sendDepositInstructionToAMBBridge(user, token, amount);
88     }
89 
90 
91     function pTokenRedeem(address token, uint256 amount, string destinationAddress) onlyAMBBridge returns (bool success) {
92         if (!pToken(token).redeem(amount, destinationAddress)) revert();
93         bytes32 msgId = IAMB(AMBBridgeContract).messageId();
94         processedMessages[msgId] = true;
95         emit pTokenRedeemEvent(token, msg.sender, amount, destinationAddress);
96     }
97 
98 
99     function sendDepositInstructionToAMBBridge(address user, address token, uint256 amount) internal
100     {
101         bytes4 methodSelector = DMEXXDAI(0).depositTokenForUser.selector;
102         bytes memory data = abi.encodeWithSelector(methodSelector, token, amount, user);
103 
104         uint256 gas = ambInstructionGas;
105 
106         // send AMB bridge instruction
107         bytes32 msgId = IAMB(AMBBridgeContract).requireToPassMessage(DMEX_XDAI_CONTRACT, data, gas);
108 
109         emit Deposit(token, user, amount, msgId); // fires the deposit event
110     }    
111  
112 
113 
114     // Withdrawal function used by the server to execute withdrawals
115     function withdrawForUser(
116         address token, // the address of the token to be withdrawn
117         uint256 amount, // the amount to be withdrawn
118         address user // address of the user
119     ) onlyAMBBridge returns (bool success) {
120         if (token == address(0)) { // checks if the withdrawal is in ETH or Tokens
121             if (!user.send(amount)) throw; // sends ETH
122         } else {
123             if (!Token(token).transfer(user, amount)) throw; // sends tokens
124         }
125 
126         bytes32 msgId = IAMB(AMBBridgeContract).messageId();
127         processedMessages[msgId] = true;
128         emit Withdraw(token, user, amount, msgId); // fires the withdraw event
129     }
130 
131 
132 
133     /**
134      *
135      *  HELPER FUNCTIONS
136      *
137      **/
138 
139     // Event fired when the owner of the contract is changed
140     event SetOwner(address indexed previousOwner, address indexed newOwner);
141 
142     // Allows only the owner of the contract to execute the function
143     modifier onlyOwner {
144         assert(msg.sender == owner);
145         _;
146     }
147 
148     // Changes the owner of the contract
149     function setOwner(address newOwner) onlyOwner {
150         SetOwner(owner, newOwner);
151         owner = newOwner;
152     }
153 
154     // Owner getter function
155     function getOwner() returns (address out) {
156         return owner;
157     }
158 
159     // Adds or disables an admin account
160     function setAdmin(address admin, bool isAdmin) onlyOwner {
161         admins[admin] = isAdmin;
162     }
163 
164 
165     // Allows for admins only to call the function
166     modifier onlyAdmin {
167         if (msg.sender != owner && !admins[msg.sender]) throw;
168         _;
169     }
170 
171 
172     // Allows for AMB Bridge only to call the function
173     modifier onlyAMBBridge {
174         if (msg.sender != AMBBridgeContract) throw;
175 
176         bytes32 msgId = IAMB(AMBBridgeContract).messageId();
177         require(!processedMessages[msgId], "Error: message already processed");
178         _;
179     }
180 
181     function() external {
182         throw;
183     }
184 
185     function assert(bool assertion) {
186         if (!assertion) throw;
187     }
188 
189     // Safe Multiply Function - prevents integer overflow 
190     function safeMul(uint a, uint b) returns (uint) {
191         uint c = a * b;
192         assert(a == 0 || c / a == b);
193         return c;
194     }
195 
196     // Safe Subtraction Function - prevents integer overflow 
197     function safeSub(uint a, uint b) returns (uint) {
198         assert(b <= a);
199         return a - b;
200     }
201 
202     // Safe Addition Function - prevents integer overflow 
203     function safeAdd(uint a, uint b) returns (uint) {
204         uint c = a + b;
205         assert(c>=a && c>=b);
206         return c;
207     }
208 
209 
210 
211     /**
212      *
213      *  ADMIN FUNCTIONS
214      *
215      **/
216     // Deposit event fired when a deposit takes place
217     event Deposit(address indexed token, address indexed user, uint256 amount, bytes32 msgId);
218 
219     // Withdraw event fired when a withdrawal id executed
220     event Withdraw(address indexed token, address indexed user, uint256 amount, bytes32 msgId);
221     
222     // pTokenRedeemEvent event fired when a pToken withdrawal is executed
223     event pTokenRedeemEvent(address indexed token, address indexed user, uint256 amount, string destinationAddress);
224 
225     // Change inactivity release period event
226     event InactivityReleasePeriodChange(uint256 value);
227 
228     // Fee account changed event
229     event FeeAccountChanged(address indexed newFeeAccount);
230 
231 
232 
233     // Constructor function, initializes the contract and sets the core variables
234     function DMEX_Base(uint256 inactivityReleasePeriod_, address AMBBridgeContract_, address DMEX_XDAI_CONTRACT_) {
235         owner = msg.sender;
236         inactivityReleasePeriod = inactivityReleasePeriod_;
237         AMBBridgeContract = AMBBridgeContract_;
238         DMEX_XDAI_CONTRACT = DMEX_XDAI_CONTRACT_;
239     }
240 
241     // Sets the inactivity period before a user can withdraw funds manually
242     function destroyContract() onlyOwner returns (bool success) {
243         if (destroyed) throw;
244         destroyBlock = block.number;
245 
246         return true;
247     }
248 
249     // Sets the inactivity period before a user can withdraw funds manually
250     function setInactivityReleasePeriod(uint256 expiry) onlyOwner returns (bool success) {
251         if (expiry > 1000000) throw;
252         inactivityReleasePeriod = expiry;
253 
254         emit InactivityReleasePeriodChange(expiry);
255         return true;
256     }
257 
258     // Returns the inactivity release perios
259     function getInactivityReleasePeriod() view returns (uint256)
260     {
261         return inactivityReleasePeriod;
262     }
263 
264 
265     function releaseFundsAfterDestroy(address token, uint256 amount) onlyOwner returns (bool success) {
266         if (!destroyed) throw;
267         if (safeAdd(destroyBlock, destroyDelay) > block.number) throw; // destroy delay not yet passed
268 
269         if (token == address(0)) { // checks if withdrawal is a token or ETH, ETH has address 0x00000... 
270             if (!msg.sender.send(amount)) throw; // send ETH
271         } else {
272             if (!Token(token).transfer(msg.sender, amount)) throw; // Send token
273         }
274     }
275 
276     function setAmbInstructionGas(uint256 newGas) onlyOwner {
277         ambInstructionGas = newGas;
278     }
279 }