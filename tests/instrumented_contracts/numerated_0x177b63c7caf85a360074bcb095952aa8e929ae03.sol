1 /**
2  *  MultiSig.sol v1.1.0
3  * 
4  *  Bilal Arif - https://twitter.com/furusiyya_
5  *  Draglet GbmH
6  */
7 
8 pragma solidity 0.4.19;
9 
10 
11 library SafeMath {
12   function mul(uint256 a, uint256 b) pure internal returns (uint256) {
13     uint256 c = a * b;
14     assert(a == 0 || c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) pure internal returns (uint256) {
19     uint256 c = a / b;
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) pure internal returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) pure internal returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 
34   function max64(uint64 a, uint64 b) pure internal returns (uint64) {
35     return a >= b ? a : b;
36   }
37 
38   function min64(uint64 a, uint64 b) pure internal returns (uint64) {
39     return a < b ? a : b;
40   }
41 
42   function max256(uint256 a, uint256 b) pure internal returns (uint256) {
43     return a >= b ? a : b;
44   }
45 
46   function min256(uint256 a, uint256 b) pure internal returns (uint256) {
47     return a < b ? a : b;
48   }
49 
50 }
51 
52 contract ReentrancyGuard {
53 
54   /**
55    * @dev We use a single lock for the whole contract.
56    */
57   bool private rentrancy_lock = false;
58 
59   /**
60    * @dev Prevents a contract from calling itself, directly or indirectly.
61    * @notice If you mark a function `nonReentrant`, you should also
62    * mark it `external`. Calling one nonReentrant function from
63    * another is not supported. Instead, you can implement a
64    * `private` function doing the actual work, and a `external`
65    * wrapper marked as `nonReentrant`.
66    */
67   modifier nonReentrant() {
68     require(!rentrancy_lock);
69     rentrancy_lock = true;
70     _;
71     rentrancy_lock = false;
72   }
73 
74 }
75 
76 /**
77  * MultiSig is designed to hold funds of the ico. Account is controlled by four administratos. To trigger a payout
78  * three out of four administrators will must agree on same amount of ethers to be transferred. During the signing
79  * process if one administrator sends different targetted address or amount of ethers, process will abort and they
80  * need to start again.
81  * Administrator can be replaced but three out of four must agree upon replacement of fourth administrator. Three
82  * admins will send address of fourth administrator along with address of new one administrator. If a single one
83  * sends different address the updating process will abort and they need to start again. 
84  */
85 
86 contract MultiSig is ReentrancyGuard{
87   
88   using SafeMath for uint256;
89   
90   // Maintain state funds transfer signing process
91   struct Transaction{
92     address[3] signer;
93     uint confirmations;
94     uint256 eth;
95   }
96   
97   // count and record signers with ethers they agree to transfer
98   Transaction private  pending;
99     
100   // the number of administrator that must confirm the same operation before it is run.
101   uint256 constant public required = 3;
102 
103   mapping(address => bool) private administrators;
104  
105   // Funds has arrived into the contract (record how much).
106   event Deposit(address _from, uint256 value);
107   
108   // Funds transfer to other contract
109   event Transfer(address indexed fristSigner, address indexed secondSigner, address indexed thirdSigner, address to,uint256 eth,bool success);
110   
111   // Administrator successfully signs a fund transfer
112   event TransferConfirmed(address signer,uint256 amount,uint256 remainingConfirmations);
113   
114   // Administrator successfully signs a key update transaction
115   event UpdateConfirmed(address indexed signer,address indexed newAddress,uint256 remainingConfirmations);
116   
117   
118   // Administrator violated consensus
119   event Violated(string action, address sender); 
120   
121   // Administrator key updated (administrator replaced)
122   event KeyReplaced(address oldKey,address newKey);
123 
124   event EventTransferWasReset();
125   event EventUpdateWasReset();
126   
127   
128   function MultiSig() public {
129 
130     administrators[0x8E0c5A1b55d4E71B7891010EF504b11f19F4c466] = true;
131     administrators[0x5e77156CD35574A1dAC125992B73b3C5a973a4eb] = true;
132     administrators[0x604EdF8FE01db0AdafED4701F5De42b15067d23c] = true;
133     administrators[0xed4C73Ad76D90715d648797Acd29A8529ED511A0] = true;
134 
135   }
136   
137   /**
138    * @dev  To trigger payout three out of four administrators call this
139    * function, funds will be transferred right after verification of
140    * third signer call.
141    * @param recipient The address of recipient
142    * @param amount Amount of wei to be transferred
143    */
144   function transfer(address recipient, uint256 amount) external onlyAdmin nonReentrant {
145     
146     // input validations
147     require( recipient != 0x00 );
148     require( amount > 0 );
149     require( this.balance >= amount);
150 
151     uint remaining;
152     
153     // Start of signing process, first signer will finalize inputs for remaining two
154     if(pending.confirmations == 0){
155         
156         pending.signer[pending.confirmations] = msg.sender;
157         pending.eth = amount;
158         pending.confirmations = pending.confirmations.add(1);
159         remaining = required.sub(pending.confirmations);
160         TransferConfirmed(msg.sender,amount,remaining);
161         return;
162     
163     }
164     
165     // Compare amount of wei with previous confirmtaion
166     if(pending.eth != amount){
167         transferViolated("Incorrect amount of wei passed");
168         return;
169     }
170     
171     // make sure signer is not trying to spam
172     if(msg.sender == pending.signer[0]){
173         transferViolated("Signer is spamming");
174         return;
175     }
176     
177     pending.signer[pending.confirmations] = msg.sender;
178     pending.confirmations = pending.confirmations.add(1);
179     remaining = required.sub(pending.confirmations);
180     
181     // make sure signer is not trying to spam
182     if( remaining == 0){
183         if(msg.sender == pending.signer[1]){
184             transferViolated("One of signers is spamming");
185             return;
186         }
187     }
188     
189     TransferConfirmed(msg.sender,amount,remaining);
190     
191     // If three confirmation are done, trigger payout
192     if (pending.confirmations == 3){
193         if(recipient.send(amount)){
194             Transfer(pending.signer[0],pending.signer[1], pending.signer[2], recipient,amount,true);
195         }else{
196             Transfer(pending.signer[0],pending.signer[1], pending.signer[2], recipient,amount,false);
197         }
198         ResetTransferState();
199     } 
200   }
201   
202   function transferViolated(string error) private {
203     Violated(error, msg.sender);
204     ResetTransferState();
205   }
206   
207   function ResetTransferState() internal
208   {
209       delete pending;
210       EventTransferWasReset();
211   }
212 
213 
214   /**
215    * @dev Reset values of pending (Transaction object)
216    */
217   function abortTransaction() external onlyAdmin{
218        ResetTransferState();
219   }
220   
221   /** 
222    * @dev Fallback function, receives value and emits a deposit event. 
223    */
224   function() payable public {
225     // just being sent some cash?
226     if (msg.value > 0)
227       Deposit(msg.sender, msg.value);
228   }
229 
230   /**
231    * @dev Checks if given address is an administrator.
232    * @param _addr address The address which you want to check.
233    * @return True if the address is an administrator and fase otherwise.
234    */
235   function isAdministrator(address _addr) public constant returns (bool) {
236     return administrators[_addr];
237   }
238   
239   // Maintian state of administrator key update process
240   struct KeyUpdate{
241     address[3] signer;
242     uint confirmations;
243     address oldAddress;
244     address newAddress;
245   }
246   
247   KeyUpdate private updating;
248   
249   /**
250    * @dev Three admnistrator can replace key of fourth administrator. 
251    * @param _oldAddress Address of adminisrator needs to be replaced
252    * @param _newAddress Address of new administrator
253    */
254   function updateAdministratorKey(address _oldAddress, address _newAddress) external onlyAdmin {
255     
256     // input verifications
257     require(isAdministrator(_oldAddress));
258     require( _newAddress != 0x00 );
259     require(!isAdministrator(_newAddress));
260     require( msg.sender != _oldAddress );
261     
262     // count confirmation 
263     uint256 remaining;
264     
265     // start of updating process, first signer will finalize address to be replaced
266     // and new address to be registered, remaining two must confirm
267     if( updating.confirmations == 0){
268         
269         updating.signer[updating.confirmations] = msg.sender;
270         updating.oldAddress = _oldAddress;
271         updating.newAddress = _newAddress;
272         updating.confirmations = updating.confirmations.add(1);
273         remaining = required.sub(updating.confirmations);
274         UpdateConfirmed(msg.sender,_newAddress,remaining);
275         return;
276         
277     }
278     
279     // violated consensus
280     if(updating.oldAddress != _oldAddress){
281         Violated("Old addresses do not match",msg.sender);
282         ResetUpdateState();
283         return;
284     }
285     
286     if(updating.newAddress != _newAddress){
287         Violated("New addresses do not match",msg.sender);
288         ResetUpdateState();
289         return; 
290     }
291     
292     // make sure admin is not trying to spam
293     if(msg.sender == updating.signer[0]){
294         Violated("Signer is spamming",msg.sender);
295         ResetUpdateState();
296         return;
297     }
298         
299     updating.signer[updating.confirmations] = msg.sender;
300     updating.confirmations = updating.confirmations.add(1);
301     remaining = required.sub(updating.confirmations);
302 
303     if( remaining == 0){
304         if(msg.sender == updating.signer[1]){
305             Violated("One of signers is spamming",msg.sender);
306             ResetUpdateState();
307             return;
308         }
309     }
310 
311     UpdateConfirmed(msg.sender,_newAddress,remaining);
312     
313     // if three confirmation are done, register new admin and remove old one
314     if( updating.confirmations == 3 ){
315         KeyReplaced(_oldAddress, _newAddress);
316         ResetUpdateState();
317         delete administrators[_oldAddress];
318         administrators[_newAddress] = true;
319         return;
320     }
321   }
322   
323   function ResetUpdateState() internal
324   {
325       delete updating;
326       EventUpdateWasReset();
327   }
328 
329   /**
330    * @dev Reset values of updating (KeyUpdate object)
331    */
332   function abortUpdate() external onlyAdmin{
333       ResetUpdateState();
334   }
335   
336   /**
337    * @dev modifier allow only if function is called by administrator
338    */
339   modifier onlyAdmin(){
340       if( !administrators[msg.sender] ){
341           revert();
342       }
343       _;
344   }
345 }