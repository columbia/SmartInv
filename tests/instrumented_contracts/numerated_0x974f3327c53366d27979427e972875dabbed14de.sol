1 pragma solidity 0.4.21;
2 
3 
4 library SafeMath {
5 
6     function sub(uint256 a, uint256 b) pure internal returns (uint256) {
7         assert(b <= a);
8         return a - b;
9     }
10 
11     function add(uint256 a, uint256 b) pure internal returns (uint256) {
12         uint256 c = a + b;
13         assert(c >= a);
14         return c;
15     }
16 
17 }
18 
19 contract ReentrancyGuard {
20 
21     /**
22      * @dev We use a single lock for the whole contract.
23      */
24     bool private rentrancy_lock = false;
25 
26     /**
27      * @dev Prevents a contract from calling itself, directly or indirectly.
28      * @notice If you mark a function `nonReentrant`, you should also
29      * mark it `external`. Calling one nonReentrant function from
30      * another is not supported. Instead, you can implement a
31      * `private` function doing the actual work, and a `external`
32      * wrapper marked as `nonReentrant`.
33      */
34     modifier nonReentrant() {
35         require(!rentrancy_lock);
36         rentrancy_lock = true;
37         _;
38         rentrancy_lock = false;
39     }
40 
41 }
42 
43 /**
44  * MultiSig is designed to hold funds of the ico. Account is controlled by three administrators. To trigger a payout
45  * two out of three administrators will must agree on same amount of ether to be transferred. During the signing
46  * process if one administrator sends different target address or amount of ether, process will abort and they
47  * need to start again.
48  * Administrator can be replaced but two out of three must agree upon replacement of third administrator. Two
49  * admins will send address of third administrator along with address of new one administrator. If a single one
50  * sends different address the updating process will abort and they need to start again.
51  */
52 
53 contract MultiSig is ReentrancyGuard {
54 
55     using SafeMath for uint256;
56 
57     // Maintain state funds transfer signing process
58     struct Transaction{
59         address[2] signer;
60         uint confirmations;
61         uint256 eth;
62     }
63 
64     // count and record signers with ethers they agree to transfer
65     Transaction private pending;
66 
67     // the number of administrator that must confirm the same operation before it is run.
68     uint256 public required = 2;
69 
70     mapping(address => bool) private administrators;
71 
72     // Funds has arrived into the contract (record how much).
73     event Deposit(address _from, uint256 value);
74 
75     // Funds transfer to other contract
76     event Transfer(address indexed fristSigner, address indexed secondSigner, address to,uint256 eth,bool success);
77 
78     // Administrator successfully signs a fund transfer
79     event TransferConfirmed(address signer,uint256 amount,uint256 remainingConfirmations);
80 
81     // Administrator successfully signs a key update transaction
82     event UpdateConfirmed(address indexed signer,address indexed newAddress,uint256 remainingConfirmations);
83 
84     // Administrator violated consensus
85     event Violated(string action, address sender);
86 
87     // Administrator key updated (administrator replaced)
88     event KeyReplaced(address oldKey,address newKey);
89 
90     event EventTransferWasReset();
91     event EventUpdateWasReset();
92 
93 
94     function MultiSig() public {
95 
96         administrators[0xCDea686Bac6136E3B4D7136967dC3597f96fA24f] = true;
97         administrators[0xf964707c8fb25daf61aEeEF162A3816c2e8f25dD] = true;
98         administrators[0xA45fb4e5A96D267c2BDc5efDD2E93a92b9516232] = true;
99 
100     }
101 
102     /**
103      * @dev  To trigger payout two out of three administrators call this
104      * function, funds will be transferred right after verification of
105      * third signer call.
106      * @param recipient The address of recipient
107      * @param amount Amount of wei to be transferred
108      */
109     function transfer(address recipient, uint256 amount) external onlyAdmin nonReentrant {
110 
111         // input validations
112         require( recipient != 0x00 );
113         require( amount > 0 );
114         require( address(this).balance >= amount );
115 
116         uint remaining;
117 
118         // Start of signing process, first signer will finalize inputs for remaining two
119         if (pending.confirmations == 0) {
120 
121             pending.signer[pending.confirmations] = msg.sender;
122             pending.eth = amount;
123             pending.confirmations = pending.confirmations.add(1);
124             remaining = required.sub(pending.confirmations);
125             emit TransferConfirmed(msg.sender,amount,remaining);
126             return;
127 
128         }
129 
130         // Compare amount of wei with previous confirmtaion
131         if (pending.eth != amount) {
132             transferViolated("Incorrect amount of wei passed");
133             return;
134         }
135 
136         // make sure signer is not trying to spam
137         if (msg.sender == pending.signer[0]) {
138             transferViolated("Signer is spamming");
139             return;
140         }
141 
142         pending.signer[pending.confirmations] = msg.sender;
143         pending.confirmations = pending.confirmations.add(1);
144         remaining = required.sub(pending.confirmations);
145 
146         // make sure signer is not trying to spam
147         if (remaining == 0) {
148             
149             if (msg.sender == pending.signer[0]) {
150                 transferViolated("One of signers is spamming");
151                 return;
152             }
153             
154         }
155 
156         emit TransferConfirmed(msg.sender,amount,remaining);
157 
158         // If two confirmation are done, trigger payout
159         if (pending.confirmations == 2) {
160             
161             if(recipient.send(amount)) {
162 
163                 emit Transfer(pending.signer[0], pending.signer[1], recipient, amount, true);
164 
165             } else {
166 
167                 emit Transfer(pending.signer[0], pending.signer[1], recipient, amount, false);
168 
169             }
170             
171             ResetTransferState();
172         }
173     }
174 
175     function transferViolated(string error) private {
176         emit Violated(error, msg.sender);
177         ResetTransferState();
178     }
179 
180     function ResetTransferState() internal {
181         delete pending;
182         emit EventTransferWasReset();
183     }
184 
185 
186     /**
187      * @dev Reset values of pending (Transaction object)
188      */
189     function abortTransaction() external onlyAdmin{
190         ResetTransferState();
191     }
192 
193     /**
194      * @dev Fallback function, receives value and emits a deposit event.
195      */
196     function() payable public {
197         // deposit ether
198         if (msg.value > 0){
199             emit Deposit(msg.sender, msg.value);
200         }
201 
202     }
203 
204     /**
205      * @dev Checks if given address is an administrator.
206      * @param _addr address The address which you want to check.
207      * @return True if the address is an administrator and fase otherwise.
208      */
209     function isAdministrator(address _addr) public constant returns (bool) {
210         return administrators[_addr];
211     }
212 
213     // Maintian state of administrator key update process
214     struct KeyUpdate {
215         address[2] signer;
216         uint confirmations;
217         address oldAddress;
218         address newAddress;
219     }
220 
221     KeyUpdate private updating;
222 
223     /**
224      * @dev Two admnistrator can replace key of third administrator.
225      * @param _oldAddress Address of adminisrator needs to be replaced
226      * @param _newAddress Address of new administrator
227      */
228     function updateAdministratorKey(address _oldAddress, address _newAddress) external onlyAdmin {
229 
230         // input verifications
231         require( isAdministrator(_oldAddress) );
232         require( _newAddress != 0x00 );
233         require( !isAdministrator(_newAddress) );
234         require( msg.sender != _oldAddress );
235 
236         // count confirmation
237         uint256 remaining;
238 
239         // start of updating process, first signer will finalize address to be replaced
240         // and new address to be registered, remaining two must confirm
241         if (updating.confirmations == 0) {
242 
243             updating.signer[updating.confirmations] = msg.sender;
244             updating.oldAddress = _oldAddress;
245             updating.newAddress = _newAddress;
246             updating.confirmations = updating.confirmations.add(1);
247             remaining = required.sub(updating.confirmations);
248             emit UpdateConfirmed(msg.sender,_newAddress,remaining);
249             return;
250 
251         }
252 
253         // violated consensus
254         if (updating.oldAddress != _oldAddress) {
255             emit Violated("Old addresses do not match",msg.sender);
256             ResetUpdateState();
257             return;
258         }
259 
260         if (updating.newAddress != _newAddress) {
261             emit Violated("New addresses do not match", msg.sender);
262             ResetUpdateState();
263             return;
264         }
265 
266         // make sure admin is not trying to spam
267         if (msg.sender == updating.signer[0]) {
268             emit Violated("Signer is spamming", msg.sender);
269             ResetUpdateState();
270             return;
271         }
272 
273         updating.signer[updating.confirmations] = msg.sender;
274         updating.confirmations = updating.confirmations.add(1);
275         remaining = required.sub(updating.confirmations);
276 
277         if (remaining == 0) {
278             
279             if (msg.sender == updating.signer[0]) {
280                 emit Violated("One of signers is spamming",msg.sender);
281                 ResetUpdateState();
282                 return;
283             }
284             
285         }
286 
287         emit UpdateConfirmed(msg.sender,_newAddress,remaining);
288 
289         // if two confirmation are done, register new admin and remove old one
290         if (updating.confirmations == 2) {
291             emit KeyReplaced(_oldAddress, _newAddress);
292             ResetUpdateState();
293             delete administrators[_oldAddress];
294             administrators[_newAddress] = true;
295             return;
296         }
297     }
298 
299     function ResetUpdateState() internal {
300         delete updating;
301         emit EventUpdateWasReset();
302     }
303 
304     /**
305      * @dev Reset values of updating (KeyUpdate object)
306      */
307     function abortUpdate() external onlyAdmin {
308         ResetUpdateState();
309     }
310 
311     /**
312      * @dev modifier allow only if function is called by administrator
313      */
314     modifier onlyAdmin() {
315         if( !administrators[msg.sender] ){
316             revert();
317         }
318         _;
319     }
320 }