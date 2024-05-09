1 pragma solidity 0.4.21;
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) pure internal returns (uint256) {
6         uint256 c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function div(uint256 a, uint256 b) pure internal returns (uint256) {
12         uint256 c = a / b;
13         return c;
14     }
15 
16     function sub(uint256 a, uint256 b) pure internal returns (uint256) {
17         assert(b <= a);
18         return a - b;
19     }
20 
21     function add(uint256 a, uint256 b) pure internal returns (uint256) {
22         uint256 c = a + b;
23         assert(c >= a);
24         return c;
25     }
26 
27     function max64(uint64 a, uint64 b) pure internal returns (uint64) {
28         return a >= b ? a : b;
29     }
30 
31     function min64(uint64 a, uint64 b) pure internal returns (uint64) {
32         return a < b ? a : b;
33     }
34 
35     function max256(uint256 a, uint256 b) pure internal returns (uint256) {
36         return a >= b ? a : b;
37     }
38 
39     function min256(uint256 a, uint256 b) pure internal returns (uint256) {
40         return a < b ? a : b;
41     }
42 
43 }
44 
45 contract ReentrancyGuard {
46 
47     /**
48      * @dev We use a single lock for the whole contract.
49      */
50     bool private rentrancy_lock = false;
51 
52     /**
53      * @dev Prevents a contract from calling itself, directly or indirectly.
54      * @notice If you mark a function `nonReentrant`, you should also
55      * mark it `external`. Calling one nonReentrant function from
56      * another is not supported. Instead, you can implement a
57      * `private` function doing the actual work, and a `external`
58      * wrapper marked as `nonReentrant`.
59      */
60     modifier nonReentrant() {
61         require(!rentrancy_lock);
62         rentrancy_lock = true;
63         _;
64         rentrancy_lock = false;
65     }
66 
67 }
68 
69 /**
70  * MultiSig is designed to hold funds of the ico. Account is controlled by six administratos. To trigger a payout
71  * two out of six administrators will must agree on same amount of ethers to be transferred. During the signing
72  * process if one administrator sends different targetted address or amount of ethers, process will abort and they
73  * need to start again.
74  * Administrator can be replaced but two out of six must agree upon replacement of fourth administrator. Two
75  * admins will send address of third administrator along with address of new one administrator. If a single one
76  * sends different address the updating process will abort and they need to start again.
77  */
78 
79 contract MultiSig is ReentrancyGuard{
80 
81     using SafeMath for uint256;
82 
83     // Maintain state funds transfer signing process
84     struct Transaction{
85         address[2] signer;
86         uint confirmations;
87         uint256 eth;
88     }
89 
90     // count and record signers with ethers they agree to transfer
91     Transaction private  pending;
92 
93     // the number of administrator that must confirm the same operation before it is run.
94     uint256 constant public required = 2;
95 
96     mapping(address => bool) private administrators;
97 
98     // Funds has arrived into the contract (record how much).
99     event Deposit(address _from, uint256 value);
100 
101     // Funds transfer to other contract
102     event Transfer(address indexed fristSigner, address indexed secondSigner, address to,uint256 eth,bool success);
103 
104     // Administrator successfully signs a fund transfer
105     event TransferConfirmed(address signer,uint256 amount,uint256 remainingConfirmations);
106 
107     // Administrator successfully signs a key update transaction
108     event UpdateConfirmed(address indexed signer,address indexed newAddress,uint256 remainingConfirmations);
109 
110 
111     // Administrator violated consensus
112     event Violated(string action, address sender);
113 
114     // Administrator key updated (administrator replaced)
115     event KeyReplaced(address oldKey,address newKey);
116 
117     event EventTransferWasReset();
118     event EventUpdateWasReset();
119 
120 
121     function MultiSig() public {
122 
123         administrators[0xA45fb4e5A96D267c2BDc5efDD2E93a92b9516232] = true;
124         administrators[0x877994c4192184F18E24083Be0aA51BAA325FD9c] = true;
125         administrators[0x5Aa9E0727b57cF9aC354626A3Ea137317a30E636] = true;
126         administrators[0x8ee5De18c0b70Ccb7844768BAe07db6e208c7082] = true;
127         administrators[0x81e9b014d9cd8c5b76bb712cf03eae9a2669e765] = true;
128         administrators[0xed4c73ad76d90715d648797acd29a8529ed511a0] = true;
129 
130     }
131 
132     /**
133      * @dev  To trigger payout three out of four administrators call this
134      * function, funds will be transferred right after verification of
135      * third signer call.
136      * @param recipient The address of recipient
137      * @param amount Amount of wei to be transferred
138      */
139     function transfer(address recipient, uint256 amount) external onlyAdmin nonReentrant {
140 
141         // input validations
142         require( recipient != 0x00 );
143         require( amount > 0 );
144         require( address(this).balance >= amount );
145 
146         uint remaining;
147 
148         // Start of signing process, first signer will finalize inputs for remaining two
149         if(pending.confirmations == 0){
150 
151             pending.signer[pending.confirmations] = msg.sender;
152             pending.eth = amount;
153             pending.confirmations = pending.confirmations.add(1);
154             remaining = required.sub(pending.confirmations);
155             emit TransferConfirmed(msg.sender,amount,remaining);
156             return;
157 
158         }
159 
160         // Compare amount of wei with previous confirmtaion
161         if(pending.eth != amount){
162             transferViolated("Incorrect amount of wei passed");
163             return;
164         }
165 
166         // make sure signer is not trying to spam
167         if(msg.sender == pending.signer[0]){
168             transferViolated("Signer is spamming");
169             return;
170         }
171 
172         pending.signer[pending.confirmations] = msg.sender;
173         pending.confirmations = pending.confirmations.add(1);
174         remaining = required.sub(pending.confirmations);
175 
176         // make sure signer is not trying to spam
177         if(remaining == 0){
178             if(msg.sender == pending.signer[0]){
179                 transferViolated("One of signers is spamming");
180                 return;
181             }
182         }
183 
184         emit TransferConfirmed(msg.sender,amount,remaining);
185 
186         // If three confirmation are done, trigger payout
187         if (pending.confirmations == 2){
188             if(recipient.send(amount)){
189 
190                 emit Transfer(pending.signer[0],pending.signer[1], recipient,amount,true);
191 
192             } else {
193 
194                 emit Transfer(pending.signer[0],pending.signer[1], recipient,amount,false);
195 
196             }
197             ResetTransferState();
198         }
199     }
200 
201     function transferViolated(string error) private {
202         emit Violated(error, msg.sender);
203         ResetTransferState();
204     }
205 
206     function ResetTransferState() internal {
207         delete pending;
208         emit EventTransferWasReset();
209     }
210 
211 
212     /**
213      * @dev Reset values of pending (Transaction object)
214      */
215     function abortTransaction() external onlyAdmin{
216         ResetTransferState();
217     }
218 
219     /**
220      * @dev Fallback function, receives value and emits a deposit event.
221      */
222     function() payable public {
223         // just being sent some cash?
224         if (msg.value > 0)
225             emit Deposit(msg.sender, msg.value);
226     }
227 
228     /**
229      * @dev Checks if given address is an administrator.
230      * @param _addr address The address which you want to check.
231      * @return True if the address is an administrator and fase otherwise.
232      */
233     function isAdministrator(address _addr) public constant returns (bool) {
234         return administrators[_addr];
235     }
236 
237     // Maintian state of administrator key update process
238     struct KeyUpdate{
239         address[2] signer;
240         uint confirmations;
241         address oldAddress;
242         address newAddress;
243     }
244 
245     KeyUpdate private updating;
246 
247     /**
248      * @dev Two admnistrator can replace key of third administrator.
249      * @param _oldAddress Address of adminisrator needs to be replaced
250      * @param _newAddress Address of new administrator
251      */
252     function updateAdministratorKey(address _oldAddress, address _newAddress) external onlyAdmin {
253 
254         // input verifications
255         require(isAdministrator(_oldAddress));
256         require( _newAddress != 0x00 );
257         require(!isAdministrator(_newAddress));
258         require( msg.sender != _oldAddress );
259 
260         // count confirmation
261         uint256 remaining;
262 
263         // start of updating process, first signer will finalize address to be replaced
264         // and new address to be registered, remaining one must confirm
265         if( updating.confirmations == 0){
266 
267             updating.signer[updating.confirmations] = msg.sender;
268             updating.oldAddress = _oldAddress;
269             updating.newAddress = _newAddress;
270             updating.confirmations = updating.confirmations.add(1);
271             remaining = required.sub(updating.confirmations);
272             emit UpdateConfirmed(msg.sender,_newAddress,remaining);
273             return;
274 
275         }
276 
277         // violated consensus
278         if(updating.oldAddress != _oldAddress){
279             emit Violated("Old addresses do not match",msg.sender);
280             ResetUpdateState();
281             return;
282         }
283 
284         if(updating.newAddress != _newAddress){
285             emit Violated("New addresses do not match",msg.sender);
286             ResetUpdateState();
287             return;
288         }
289 
290         // make sure admin is not trying to spam
291         if(msg.sender == updating.signer[0]){
292             emit Violated("Signer is spamming",msg.sender);
293             ResetUpdateState();
294             return;
295         }
296 
297         updating.signer[updating.confirmations] = msg.sender;
298         updating.confirmations = updating.confirmations.add(1);
299         remaining = required.sub(updating.confirmations);
300 
301         if( remaining == 0){
302             if(msg.sender == updating.signer[0]){
303                 emit Violated("One of signers is spamming",msg.sender);
304                 ResetUpdateState();
305                 return;
306             }
307         }
308 
309         emit UpdateConfirmed(msg.sender,_newAddress,remaining);
310 
311         // if two confirmation are done, register new admin and remove old one
312         if( updating.confirmations == 2 ){
313             emit KeyReplaced(_oldAddress, _newAddress);
314             ResetUpdateState();
315             delete administrators[_oldAddress];
316             administrators[_newAddress] = true;
317             return;
318         }
319     }
320 
321     function ResetUpdateState() internal
322     {
323         delete updating;
324         emit EventUpdateWasReset();
325     }
326 
327     /**
328      * @dev Reset values of updating (KeyUpdate object)
329      */
330     function abortUpdate() external onlyAdmin{
331         ResetUpdateState();
332     }
333 
334     /**
335      * @dev modifier allow only if function is called by administrator
336      */
337     modifier onlyAdmin(){
338         if( !administrators[msg.sender] ){
339             revert();
340         }
341         _;
342     }
343 }