1 pragma solidity 0.4.24;
2 
3 interface tokenInterface {
4     function transfer(address reciever, uint amount) external;
5     function balanceOf(address owner) external returns (uint256);
6 }
7 
8 contract dapMultisig {
9 
10     /*
11     * Types
12     */
13     struct Transaction {
14         uint id;
15         address destination;
16         uint value;
17         bytes data;
18         TxnStatus status;
19         address[] confirmed;
20         address creator;
21     }
22     
23     struct tokenTransaction {
24         uint id;
25         tokenInterface token;
26         address reciever;
27         uint value;
28         address[] confirmed;
29         TxnStatus status;
30         address creator;
31     }
32     
33     struct Log {
34         uint amount;
35         address sender;
36     }
37     
38     enum TxnStatus { Unconfirmed, Pending, Executed }
39     
40     /*
41     * Modifiers
42     */
43     modifier onlyOwner () {
44         bool found;
45         for (uint i = 0;i<owners.length;i++){
46             if (owners[i] == msg.sender){
47                 found = true;
48             }
49         }
50         if (found){
51             _;
52         }
53     }
54     
55     /*
56     * Events
57     */
58     event WalletCreated(address creator, address[] owners);
59     event TxnSumbitted(uint id);
60     event TxnConfirmed(uint id);
61     event topUpBalance(uint value);
62     event tokenTxnConfirmed(uint id, address owner);
63     event tokenTxnExecuted(address token, uint256 value, address reciever);
64     /*
65     * Storage
66     */
67     bytes32 public name;
68     address public creator;
69     uint public allowance;
70     address[] public owners;
71     Log[] logs;
72     Transaction[] transactions;
73     tokenTransaction[] tokenTransactions;
74     uint public approvalsreq;
75     
76     /*
77     * Constructor
78     */
79     constructor (uint _approvals, address[] _owners, bytes32 _name) public payable{
80         /* check if name was actually given */
81         require(_name.length != 0);
82         
83         /*check if approvals num equals or greater than given owners num*/
84         require(_approvals <= _owners.length);
85         
86         name = _name;
87         creator = msg.sender;
88         allowance = msg.value;
89         owners = _owners;
90         approvalsreq = _approvals;
91         emit WalletCreated(msg.sender, _owners);
92     }
93 
94     //fallback to accept funds without method signature
95     function () external payable {
96         allowance += msg.value;
97     }
98     
99     /*
100     * Getters
101     */
102 
103     function getOwners() external view returns (address[]){
104         return owners;
105     }
106     
107     function getTxnNum() external view returns (uint){
108         return transactions.length;
109     }
110     
111     function getTxn(uint _id) external view returns (uint, address, uint, bytes, TxnStatus, address[], address){
112         Transaction storage txn = transactions[_id];
113         return (txn.id, txn.destination, txn.value, txn.data, txn.status, txn.confirmed, txn.creator);
114     }
115     
116     function getLogsNum() external view returns (uint){
117         return logs.length;
118     }
119     
120     function getLog(uint logId) external view returns (address, uint){
121         return(logs[logId].sender, logs[logId].amount);
122     }
123     
124     function getTokenTxnNum() external view returns (uint){
125         return tokenTransactions.length;
126     }
127     
128     function getTokenTxn(uint _id) external view returns(uint, address, address, uint256, address[], TxnStatus, address){
129         tokenTransaction storage txn = tokenTransactions[_id];
130         return (txn.id, txn.token, txn.reciever, txn.value, txn.confirmed, txn.status, txn.creator);
131     }
132     
133     /*
134     * Methods
135     */
136 
137     function topBalance() external payable {
138         require (msg.value > 0 wei);
139         allowance += msg.value;
140         
141         /* create new log entry */
142         uint loglen = logs.length++;
143         logs[loglen].amount = msg.value;
144         logs[loglen].sender = msg.sender;
145         emit topUpBalance(msg.value);
146     }
147     
148     function submitTransaction(address _destination, uint _value, bytes _data) onlyOwner () external returns (bool) {
149         uint newTxId = transactions.length++;
150         transactions[newTxId].id = newTxId;
151         transactions[newTxId].destination = _destination;
152         transactions[newTxId].value = _value;
153         transactions[newTxId].data = _data;
154         transactions[newTxId].creator = msg.sender;
155         transactions[newTxId].confirmed.push(msg.sender);
156         if (transactions[newTxId].confirmed.length == approvalsreq){
157             transactions[newTxId].status = TxnStatus.Pending;
158         }
159         emit TxnSumbitted(newTxId);
160         return true;
161     }
162 
163     function confirmTransaction(uint txId) onlyOwner() external returns (bool){
164         Transaction storage txn = transactions[txId];
165 
166         //check whether this owner has already confirmed this txn
167         bool f;
168         for (uint8 i = 0; i<txn.confirmed.length;i++){
169             if (txn.confirmed[i] == msg.sender){
170                 f = true;
171             }
172         }
173         //push sender address into confirmed array if haven't found
174         require(!f);
175         txn.confirmed.push(msg.sender);
176         
177         if (txn.confirmed.length == approvalsreq){
178             txn.status = TxnStatus.Pending;
179         }
180         
181         //fire event
182         emit TxnConfirmed(txId);
183         
184         return true;
185     }
186     
187     function executeTxn(uint txId) onlyOwner() external returns (bool){
188         
189         Transaction storage txn = transactions[txId];
190         
191         /* check txn status */
192         require(txn.status == TxnStatus.Pending);
193         
194         /* check whether wallet has sufficient balance to send this transaction */
195         require(allowance >= txn.value);
196         
197         /* send transaction */
198         address dest = txn.destination;
199         uint val = txn.value;
200         bytes memory dat = txn.data;
201         assert(dest.call.value(val)(dat));
202             
203         /* change transaction's status to executed */
204         txn.status = TxnStatus.Executed;
205 
206         /* change wallet's balance */
207         allowance = allowance - txn.value;
208 
209         return true;
210         
211     }
212     
213     function submitTokenTransaction(address _tokenAddress, address _receiever, uint _value) onlyOwner() external returns (bool) {
214         uint newTxId = tokenTransactions.length++;
215         tokenTransactions[newTxId].id = newTxId;
216         tokenTransactions[newTxId].token = tokenInterface(_tokenAddress);
217         tokenTransactions[newTxId].reciever = _receiever;
218         tokenTransactions[newTxId].value = _value;
219         tokenTransactions[newTxId].confirmed.push(msg.sender);
220         if (tokenTransactions[newTxId].confirmed.length == approvalsreq){
221             tokenTransactions[newTxId].status = TxnStatus.Pending;
222         }
223         emit TxnSumbitted(newTxId);
224         return true;
225     }
226     
227     function confirmTokenTransaction(uint txId) onlyOwner() external returns (bool){
228         tokenTransaction storage txn = tokenTransactions[txId];
229 
230         //check whether this owner has already confirmed this txn
231         bool f;
232         for (uint8 i = 0; i<txn.confirmed.length;i++){
233             if (txn.confirmed[i] == msg.sender){
234                 f = true;
235             }
236         }
237         //push sender address into confirmed array if haven't found
238         require(!f);
239         txn.confirmed.push(msg.sender);
240         
241         if (txn.confirmed.length == approvalsreq){
242             txn.status = TxnStatus.Pending;
243         }
244         
245         //fire event
246         emit tokenTxnConfirmed(txId, msg.sender);
247         
248         return true;
249     }
250     
251     function executeTokenTxn(uint txId) onlyOwner() external returns (bool){
252         
253         tokenTransaction storage txn = tokenTransactions[txId];
254         
255         /* check txn status */
256         require(txn.status == TxnStatus.Pending);
257         
258         /* check whether wallet has sufficient balance to send this transaction */
259         uint256 balance = txn.token.balanceOf(address(this));
260         require (txn.value <= balance);
261         
262         /* Send tokens */
263         txn.token.transfer(txn.reciever, txn.value);
264         
265         /* change transaction's status to executed */
266         txn.status = TxnStatus.Executed;
267         
268         /* Fire event */
269         emit tokenTxnExecuted(address(txn.token), txn.value, txn.reciever);
270        
271         return true;
272     }
273 }