1 pragma solidity ^0.4.21;
2 contract ibaMultisig {
3 
4     /*
5     * Types
6     */
7     struct Transaction {
8         uint id;
9         address destination;
10         uint value;
11         bytes data;
12         TxnStatus status;
13         address[] confirmed;
14         address creator;
15     }
16 
17     struct Wallet {
18         bytes32 name;
19         address creator;
20         uint id;
21         uint allowance;
22         address[] owners;
23         Log[] logs;
24         Transaction[] transactions;
25         uint appovalsreq;
26     }
27     
28     struct Log {
29         uint amount;
30         address sender;
31     }
32     
33     enum TxnStatus { Unconfirmed, Pending, Executed }
34     
35     /*
36     * Modifiers
37     */
38     modifier onlyOwner ( address creator, uint walletId ) {
39         bool found;
40         for (uint i = 0;i<wallets[creator][walletId].owners.length;i++){
41             if (wallets[creator][walletId].owners[i] == msg.sender){
42                 found = true;
43             }
44         }
45         if (found){
46             _;
47         }
48     }
49     
50     /*
51     * Events
52     */
53     event WalletCreated(uint id);
54     event TxnSumbitted(uint id);
55     event TxnConfirmed(uint id);
56     event topUpBalance(uint value);
57 
58     /*
59     * Storage
60     */
61     mapping (address => Wallet[]) public wallets;
62     
63     /*
64     * Constructor
65     */
66     function ibaMultisig() public{
67 
68     }
69 
70     /*
71     * Getters
72     */
73     function getWalletId(address creator, bytes32 name) external view returns (uint, bool){
74         for (uint i = 0;i<wallets[creator].length;i++){
75             if (wallets[creator][i].name == name){
76                 return (i, true);
77             }
78         }
79     }
80 
81     function getOwners(address creator, uint id) external view returns (address[]){
82         return wallets[creator][id].owners;
83     }
84     
85     function getTxnNum(address creator, uint id) external view returns (uint){
86         require(wallets[creator][id].owners.length > 0);
87         return wallets[creator][id].transactions.length;
88     }
89     
90     function getTxn(address creator, uint walletId, uint id) external view returns (uint, address, uint, bytes, TxnStatus, address[], address){
91         Transaction storage txn = wallets[creator][walletId].transactions[id];
92         return (txn.id, txn.destination, txn.value, txn.data, txn.status, txn.confirmed, txn.creator);
93     }
94     
95     function getLogsNum(address creator, uint id) external view returns (uint){
96         return wallets[creator][id].logs.length;
97     }
98     
99     function getLog(address creator, uint id, uint logId) external view returns (address, uint){
100         return(wallets[creator][id].logs[logId].sender, wallets[creator][id].logs[logId].amount);
101     }
102     
103     /*
104     * Methods
105     */
106     
107     function createWallet(uint approvals, address[] owners, bytes32 name) external payable{
108 
109         /* check if name was actually given */
110         require(name.length != 0);
111         
112         /*check if approvals num equals or greater than given owners num*/
113         require(approvals <= owners.length);
114         
115         /* check if wallets with given name already exists */
116         bool found;
117         for (uint i = 0; i<wallets[msg.sender].length;i++){
118             if (wallets[msg.sender][i].name == name){
119                 found = true;
120             }
121         }
122         require (found == false);
123         
124         /*instantiate new wallet*/
125         uint currentLen = wallets[msg.sender].length++;
126         wallets[msg.sender][currentLen].name = name;
127         wallets[msg.sender][currentLen].creator = msg.sender;
128         wallets[msg.sender][currentLen].id = currentLen;
129         wallets[msg.sender][currentLen].allowance = msg.value;
130         wallets[msg.sender][currentLen].owners = owners;
131         wallets[msg.sender][currentLen].appovalsreq = approvals;
132         emit WalletCreated(currentLen);
133     }
134 
135     function topBalance(address creator, uint id) external payable {
136         require (msg.value > 0 wei);
137         wallets[creator][id].allowance += msg.value;
138         
139         /* create new log entry */
140         uint loglen = wallets[creator][id].logs.length++;
141         wallets[creator][id].logs[loglen].amount = msg.value;
142         wallets[creator][id].logs[loglen].sender = msg.sender;
143         emit topUpBalance(msg.value);
144     }
145     
146     function submitTransaction(address creator, address destination, uint walletId, uint value, bytes data) onlyOwner (creator,walletId) external returns (bool) {
147         uint newTxId = wallets[creator][walletId].transactions.length++;
148         wallets[creator][walletId].transactions[newTxId].id = newTxId;
149         wallets[creator][walletId].transactions[newTxId].destination = destination;
150         wallets[creator][walletId].transactions[newTxId].value = value;
151         wallets[creator][walletId].transactions[newTxId].data = data;
152         wallets[creator][walletId].transactions[newTxId].creator = msg.sender;
153         emit TxnSumbitted(newTxId);
154         return true;
155     }
156 
157     function confirmTransaction(address creator, uint walletId, uint txId) onlyOwner(creator, walletId) external returns (bool){
158         Wallet storage wallet = wallets[creator][walletId];
159         Transaction storage txn = wallet.transactions[txId];
160 
161         //check whether this owner has already confirmed this txn
162         bool f;
163         for (uint8 i = 0; i<txn.confirmed.length;i++){
164             if (txn.confirmed[i] == msg.sender){
165                 f = true;
166             }
167         }
168         //push sender address into confirmed array if haven't found
169         require(!f);
170         txn.confirmed.push(msg.sender);
171         
172         if (txn.confirmed.length == wallet.appovalsreq){
173             txn.status = TxnStatus.Pending;
174         }
175         
176         //fire event
177         emit TxnConfirmed(txId);
178         
179         return true;
180     }
181     
182     function executeTxn(address creator, uint walletId, uint txId) onlyOwner(creator, walletId) external returns (bool){
183         Wallet storage wallet = wallets[creator][walletId];
184         
185         Transaction storage txn = wallet.transactions[txId];
186         
187         /* check txn status */
188         require(txn.status == TxnStatus.Pending);
189         
190         /* check whether wallet has sufficient balance to send this transaction */
191         require(wallet.allowance >= txn.value);
192         
193         /* send transaction */
194         address dest = txn.destination;
195         uint val = txn.value;
196         bytes memory dat = txn.data;
197         assert(dest.call.value(val)(dat));
198             
199         /* change transaction's status to executed */
200         txn.status = TxnStatus.Executed;
201 
202         /* change wallet's balance */
203         wallet.allowance = wallet.allowance - txn.value;
204 
205         return true;
206         
207     }
208 }