1 pragma solidity ^0.4.24; 
2 
3 /* ----------------------------------------------------------------------------
4  Client contract.
5  This contract is generated for each user (user account). All the transactions of a user are executed from this contract.
6  Only Aion smart contract can interact with the user account and only when the user schedules transactions.
7  ----------------------------------------------------------------------------*/
8 
9 contract AionClient {
10     
11     address private AionAddress;
12 
13     constructor(address addraion) public{
14         AionAddress = addraion;
15     }
16 
17     
18     function execfunct(address to, uint256 value, uint256 gaslimit, bytes data) external returns(bool) {
19         require(msg.sender == AionAddress);
20         return to.call.value(value).gas(gaslimit)(data);
21 
22     }
23     
24 
25     function () payable public {}
26 
27 }
28 
29 
30 // ----------------------------------------------------------------------------
31 // SafeMat library
32 // ----------------------------------------------------------------------------
33 library SafeMath {
34   /** @dev Multiplies two numbers, throws on overflow.*/
35     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36         if (a == 0) {return 0;}
37         uint256 c = a * b;
38         require(c / a == b);
39         return c;
40     }
41 
42   /** @dev Integer division of two numbers, truncating the quotient.*/
43     function div(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a / b;
45         return c;
46     }
47 
48   /**@dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).*/
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         require(b <= a);
51         return a - b;
52     }
53 
54   /** @dev Adds two numbers, throws on overflow.*/
55     function add(uint256 a, uint256 b) internal pure returns (uint256) {
56         uint256 c = a + b;
57         require(c >= a);
58         return c;
59     }
60 
61 }
62 
63 
64 
65 /* ----------------------------------------------------------------------------
66  Aion Smart contract (by ETH-Pantheon)
67   ----------------------------------------------------------------------------*/
68 
69 contract Aion {
70     using SafeMath for uint256;
71 
72     address public owner;
73     uint256 public serviceFee;
74     uint256 public AionID;
75     uint256 public feeChangeInterval;
76     mapping(address => address) public clientAccount;
77     mapping(uint256 => bytes32) public scheduledCalls;
78 
79     // Log for executed transactions.
80     event ExecutedCallEvent(address indexed from, uint256 indexed AionID, bool TxStatus, bool TxStatus_cancel, bool reimbStatus);
81     
82     // Log for scheduled transactions.                        
83     event ScheduleCallEvent(uint256 indexed blocknumber, address indexed from, address to, uint256 value, uint256 gaslimit,
84                             uint256 gasprice, uint256 fee, bytes data, uint256 indexed AionID, bool schedType);
85     
86     // Log for cancelation of a scheduled call (no fee is charged, all funds are moved from client's smart contract to client's address)                        
87     event CancellScheduledTxEvent(address indexed from, uint256 Total, bool Status, uint256 indexed AionID);
88     
89 
90     // Log for changes in the service fee
91     event feeChanged(uint256 newfee, uint256 oldfee);
92     
93 
94     
95     
96     constructor () public {
97         owner = msg.sender;
98         serviceFee = 500000000000000;
99     }    
100 
101     // This function allows to change the address of the owner (admin of the contract)
102     function transferOwnership(address newOwner) public {
103         require(msg.sender == owner);
104         withdraw();
105         owner = newOwner;
106     }
107 
108     // This function creates an account (contract) for a client if his address is 
109     // not yet associated to an account
110     function createAccount() internal {
111         if(clientAccount[msg.sender]==address(0x0)){
112             AionClient newContract = new AionClient(address(this));
113             clientAccount[msg.sender] = address(newContract);
114         }
115     }
116     
117     
118     
119     /* This function schedules transactions: client should provide an amount of Ether equal to value + gaslimit*gasprice + serviceFee
120     @param blocknumber block or timestamp at which the transaction should be executed. 
121     @param to recipient of the transaction.
122     @param value Amount of Wei to send with the transaction.
123     @param gaslimit maximum amount of gas to spend in the transaction.
124     @param gasprice value to pay per unit of gas.
125     @param data transaction data.
126     @param schedType determines if the transaction is scheduled on blocks or timestamp (true->timestamp)
127     @return uint256 Identification of the transaction
128     @return address address of the client account created
129     */
130     function ScheduleCall(uint256 blocknumber, address to, uint256 value, uint256 gaslimit, uint256 gasprice, bytes data, bool schedType) public payable returns (uint,address){
131         require(msg.value == value.add(gaslimit.mul(gasprice)).add(serviceFee));
132         AionID = AionID + 1;
133         scheduledCalls[AionID] = keccak256(abi.encodePacked(blocknumber, msg.sender, to, value, gaslimit, gasprice, serviceFee, data, schedType));
134         createAccount();
135         clientAccount[msg.sender].transfer(msg.value);
136         emit ScheduleCallEvent(blocknumber, msg.sender, to, value, gaslimit, gasprice, serviceFee, data, AionID, schedType);
137         return (AionID,clientAccount[msg.sender]);
138     }
139 
140     
141     /* This function executes the transaction at the correct time/block
142     Aion off-chain system should provide the correct information for executing a transaction.
143     The information is checked against the hash of the original data provided by the user saved in scheduledCalls.
144     If the information does not match, the transaction is reverted.
145     */
146     function executeCall(uint256 blocknumber, address from, address to, uint256 value, uint256 gaslimit, uint256 gasprice,
147                          uint256 fee, bytes data, uint256 aionId, bool schedType) external {
148         require(msg.sender==owner);
149         if(schedType) require(blocknumber <= block.timestamp);
150         if(!schedType) require(blocknumber <= block.number);
151         
152         require(scheduledCalls[aionId]==keccak256(abi.encodePacked(blocknumber, from, to, value, gaslimit, gasprice, fee, data, schedType)));
153         AionClient instance = AionClient(clientAccount[from]);
154         
155         require(instance.execfunct(address(this), gasprice*gaslimit+fee, 2100, hex"00"));
156         bool TxStatus = instance.execfunct(to, value, gasleft().sub(50000), data);
157         
158         // If the user tx fails return the ether to user
159         bool TxStatus_cancel;
160         if(!TxStatus && value>0){TxStatus_cancel = instance.execfunct(from, value, 2100, hex"00");}
161         
162         delete scheduledCalls[aionId];
163         bool reimbStatus = from.call.value((gasleft()).mul(gasprice)).gas(2100)();
164         emit ExecutedCallEvent(from, aionId,TxStatus, TxStatus_cancel, reimbStatus);
165         
166     }
167 
168     
169     /* This function allows clients to cancel scheduled transctions. No fee is charged.
170     Parameters are the same as in ScheduleCall.
171     @return bool indicating success or failure.
172     */
173     function cancellScheduledTx(uint256 blocknumber, address from, address to, uint256 value, uint256 gaslimit, uint256 gasprice,
174                          uint256 fee, bytes data, uint256 aionId, bool schedType) external returns(bool) {
175         if(schedType) require(blocknumber >=  block.timestamp+(3 minutes) || blocknumber <= block.timestamp-(5 minutes));
176         if(!schedType) require(blocknumber >  block.number+10 || blocknumber <= block.number-20);
177         require(scheduledCalls[aionId]==keccak256(abi.encodePacked(blocknumber, from, to, value, gaslimit, gasprice, fee, data, schedType)));
178         require(msg.sender==from);
179         AionClient instance = AionClient(clientAccount[msg.sender]);
180         
181         bool Status = instance.execfunct(from, value+gasprice*gaslimit+fee, 3000, hex"00");
182         require(Status);
183         emit CancellScheduledTxEvent(from, value+gasprice*gaslimit+fee, Status, aionId);
184         delete scheduledCalls[aionId];
185         return true;
186     }
187     
188     
189     
190     
191     // This function allows the owner of the contract to retrieve the fees and the gas price
192     function withdraw() public {
193         require(msg.sender==owner);
194         owner.transfer(address(this).balance);
195     }
196     
197     
198     // This function updates the service fee.
199     // To provide security to the clients the fee can only be updated once per day.
200     // This is to maintain the same price despite the Ether variation.
201     // Also, the amount of the update (if increased) can only increase 10% each time.
202     // Furthermore, an event is fired when the fee has been changed to inform the network.
203     function updatefee(uint256 fee) public{
204         require(msg.sender==owner);
205         require(feeChangeInterval<block.timestamp);
206         uint256 oldfee = serviceFee;
207         if(fee>serviceFee){
208             require(((fee.sub(serviceFee)).mul(100)).div(serviceFee)<=10);
209             serviceFee = fee;
210         } else{
211             serviceFee = fee;
212         }
213         feeChangeInterval = block.timestamp + (1 days);
214         emit feeChanged(serviceFee, oldfee);
215     } 
216     
217 
218     
219     // fallback- receive Ether
220     function () public payable {
221     
222     }
223 
224 
225 
226 }