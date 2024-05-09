1 pragma solidity 0.4.19;
2 
3 contract Admin {
4 
5     address public owner;
6     mapping(address => bool) public AdminList;
7     uint256 public ClaimAmount = 350000000000000000000;
8     uint256 public ClaimedAmount = 0;
9 
10     event AdministratorAdded(address indexed _invoker, address indexed _newAdministrator);
11     event AdministratorRemoved(address indexed _invoker, address indexed _removedAdministrator);
12     event OwnershipChanged(address indexed _invoker, address indexed _newOwner);
13 
14     function Admin() public {
15         owner = msg.sender;
16     }
17 
18     modifier OnlyAdmin() {
19         require(msg.sender == owner || AdminList[msg.sender] == true);
20         _;
21     }
22 
23     modifier OnlyOwner() {
24         require(msg.sender == owner);
25         _;
26     }
27     
28     modifier AirdropStatus() {
29         require(ClaimAmount != 0);
30         _;
31     }
32 
33     function MakeAdministrator(address AddressToAdd) public returns (bool success) {
34 
35         require(msg.sender == owner);
36         require(AddressToAdd != address(0));
37         AdminList[AddressToAdd] = true;
38         AdministratorAdded(msg.sender, AddressToAdd);
39 
40         return true;
41 
42     }
43 
44     function RemoveAdministrator(address AddressToRemove) public returns (bool success) {
45 
46         require(msg.sender == owner);
47         require(AddressToRemove != address(0));
48         delete AdminList[AddressToRemove];
49         AdministratorRemoved(msg.sender, AddressToRemove);
50 
51         return true;
52 
53     }
54 
55     function ChangeOwner(address AddressToMake) public returns (bool success) {
56 
57         require(msg.sender == owner);
58         require(AddressToMake != address(0));
59         require(owner != AddressToMake);
60         owner = AddressToMake;
61         OwnershipChanged(msg.sender, AddressToMake);
62 
63         return true;
64 
65     }
66 
67     function ChangeClaimAmount(uint256 NewAmount) public OnlyAdmin() returns (bool success) {
68 
69         ClaimAmount = NewAmount;
70         
71         return true;
72 
73     }
74 
75 }
76 
77 contract KoveredPay is Admin {
78 
79     bytes4 public symbol = "KVP";
80     bytes16 public name = "KoveredPay";
81     uint8 public decimals = 18;
82     uint256 constant TotalSupply = 50000000000000000000000000;
83 
84     bool public TransfersEnabled;
85     uint256 public TrustlessTransactions_TransactionHeight = 0;
86     uint256 public MediatedTransactions_TransactionHeight = 0;
87     uint128 public TrustlessTransaction_Protection_Seconds = 259200;
88     uint128 public MediatedTransaction_Protection_Seconds = 2620800;
89     address public InitialOwnerAddress = address(0);
90     address public CoreMediator = address(0);
91     uint256 public MediatorFees = 0;
92     uint256 public LockInExpiry = 0;
93 
94     mapping(address => uint256) public UserBalances;
95     mapping(address => mapping(address => uint256)) public Allowance;
96 
97     struct TrustlessTransaction {
98         address _sender;
99         address _receiver;
100         uint256 _kvp_amount;
101         bool _statusModified;
102         bool _credited;
103         bool _refunded;
104         uint256 _time;
105     }
106 
107     struct MediatedTransaction {
108         address _sender;
109         address _receiver;
110         bool _mediator;
111         uint256 _kvp_amount;
112         uint256 _fee_amount;
113         bool _satisfaction;
114         bool _statusModified;
115         bool _credited;
116         uint256 _time;
117     }
118 
119     mapping(address => bool) public Claims;
120     mapping(uint256 => TrustlessTransaction) public TrustlessTransactions_Log;
121     mapping(uint256 => MediatedTransaction) public MediatedTransactions_Log;
122 
123     event Transfer(address indexed _from, address indexed _to, uint256 _value);
124     event Trustless_Transfer(uint256 _id, address indexed _from, address indexed _to, uint256 _value);
125     event Mediated_Transfer(uint256 _id, address indexed _from, address indexed _to, uint256 _value);
126     event TrustlessTransferStatusModified(uint256 _transactionId, bool _newStatus);
127     event MediatedTransferStatusModified(uint256 _transactionId, bool _newStatus);
128     event TrustlessTransaction_Refunded(uint256 _transactionId, uint256 _amount);
129     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
130 
131     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
132         uint256 c = a * b;
133         require(a == 0 || c / a == b);
134         return c;
135     }
136 
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         uint256 c = a / b;
139         return c;
140     }
141 
142     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
143         require(b <= a);
144         return a - b;
145     }
146 
147     function add(uint256 a, uint256 b) internal pure returns (uint256) {
148         uint256 c = a + b;
149         require(c >= a);
150         return c;
151     }
152 
153     function KoveredPay() public {
154 
155         UserBalances[msg.sender] = TotalSupply;
156         CoreMediator = msg.sender;
157         InitialOwnerAddress = msg.sender;
158         LockInExpiry = add(block.timestamp, 15778463);
159         TransfersEnabled = true;
160 
161     }
162     
163     function AirdropClaim() public AirdropStatus returns (uint256 AmountClaimed) {
164         
165         require(Claims[msg.sender] == false);
166         require(ClaimedAmount < 35000000000000000000000000);   
167         require(TransferValidation(owner, msg.sender, ClaimAmount) == true);
168         ClaimedAmount = ClaimedAmount + ClaimAmount;
169         UserBalances[msg.sender] = add(UserBalances[msg.sender], ClaimAmount);
170         UserBalances[owner] = sub(UserBalances[owner], ClaimAmount);
171         Claims[msg.sender] = true;
172         Transfer(msg.sender, owner, ClaimAmount);
173 
174         return ClaimAmount;
175         
176     }
177 
178     function AlterMediatorSettings(address _newAddress, uint128 _fees) public OnlyAdmin returns (bool success) {
179 
180         CoreMediator = _newAddress;
181         MediatorFees = _fees;
182 
183         return true;
184 
185     }
186 
187     function ChangeProtectionTime(uint _type, uint128 _seconds) public OnlyAdmin returns (bool success) {
188 
189         if (_type == 1) {
190             TrustlessTransaction_Protection_Seconds = _seconds;
191         } else {
192             MediatedTransaction_Protection_Seconds = _seconds;
193         }
194 
195         return true;
196 
197     }
198 
199     function TransferStatus(bool _newStatus) public OnlyAdmin returns (bool success) {
200 
201         TransfersEnabled = _newStatus;
202 
203         return true;
204 
205     }
206 
207     function TransferValidation(address sender, address recipient, uint256 amount) private view returns (bool success) {
208 
209         require(TransfersEnabled == true);
210         require(amount > 0);
211         require(recipient != address(0));
212         require(UserBalances[sender] >= amount);
213         require(sub(UserBalances[sender], amount) >= 0);
214         require(add(UserBalances[recipient], amount) > UserBalances[recipient]);
215 
216         if (sender == InitialOwnerAddress && block.timestamp < LockInExpiry) {
217             require(sub(UserBalances[sender], amount) >= 10000000000000000000000000);
218         }
219 
220         return true;
221 
222     }
223 
224     function MultiTransfer(address[] _destinations, uint256[] _values) public returns (uint256) {
225 
226         uint256 i = 0;
227 
228         while (i < _destinations.length) {
229             transfer(_destinations[i], _values[i]);
230             i += 1;
231         }
232 
233         return (i);
234 
235     }
236 
237     function transfer(address receiver, uint256 amount) public returns (bool _status) {
238 
239         require(TransferValidation(msg.sender, receiver, amount));
240         UserBalances[msg.sender] = sub(UserBalances[msg.sender], amount);
241         UserBalances[receiver] = add(UserBalances[receiver], amount);
242         Transfer(msg.sender, receiver, amount);
243         return true;
244 
245     }
246 
247     function transferFrom(address _owner, address _receiver, uint256 _amount) public returns (bool _status) {
248 
249         require(TransferValidation(_owner, _receiver, _amount));
250         require(sub(Allowance[_owner][msg.sender], _amount) >= 0);
251         Allowance[_owner][msg.sender] = sub(Allowance[_owner][msg.sender], _amount);
252         UserBalances[_owner] = sub(UserBalances[_owner], _amount);
253         UserBalances[_receiver] = add(UserBalances[_receiver], _amount);
254         Transfer(_owner, _receiver, _amount);
255         return true;
256 
257     }
258 
259     function Send_TrustlessTransaction(address receiver, uint256 amount) public returns (uint256 transferId) {
260 
261         require(TransferValidation(msg.sender, receiver, amount));
262         UserBalances[msg.sender] = sub(UserBalances[msg.sender], amount);
263         TrustlessTransactions_TransactionHeight = TrustlessTransactions_TransactionHeight + 1;
264         TrustlessTransactions_Log[TrustlessTransactions_TransactionHeight] = TrustlessTransaction(msg.sender, receiver, amount, false, false, false, block.timestamp);
265         Trustless_Transfer(TrustlessTransactions_TransactionHeight, msg.sender, receiver, amount);
266         return TrustlessTransactions_TransactionHeight;
267 
268     }
269 
270     function Send_MediatedTransaction(address receiver, uint256 amount) public returns (uint256 transferId) {
271 
272         require(TransferValidation(msg.sender, receiver, amount));
273         UserBalances[msg.sender] = sub(UserBalances[msg.sender], amount);
274         MediatedTransactions_TransactionHeight = MediatedTransactions_TransactionHeight + 1;
275         MediatedTransactions_Log[MediatedTransactions_TransactionHeight] = MediatedTransaction(msg.sender, receiver, false, amount, 0, false, false, false, block.timestamp);
276         Mediated_Transfer(MediatedTransactions_TransactionHeight, msg.sender, receiver, amount);
277         return MediatedTransactions_TransactionHeight;
278 
279     }
280 
281     function Appoint_Mediator(uint256 _txid) public returns (bool success) {
282 
283         if (MediatedTransactions_Log[_txid]._sender == msg.sender || MediatedTransactions_Log[_txid]._receiver == msg.sender) {
284 
285             uint256 sent_on = MediatedTransactions_Log[_txid]._time;
286             uint256 right_now = block.timestamp;
287             uint256 difference = sub(right_now, sent_on);
288 
289             require(MediatedTransactions_Log[_txid]._mediator == false);
290             require(MediatedTransactions_Log[_txid]._satisfaction == false);
291             require(MediatedTransactions_Log[_txid]._statusModified == false);
292             require(difference <= MediatedTransaction_Protection_Seconds);
293             require(MediatedTransactions_Log[_txid]._credited == false);
294             require(MediatedTransactions_Log[_txid]._kvp_amount >= MediatorFees);
295 
296             MediatedTransactions_Log[_txid]._mediator = true;
297             MediatedTransactions_Log[_txid]._fee_amount = MediatorFees;
298 
299             return true;
300 
301         } else {
302 
303             return false;
304 
305         }
306 
307     }
308 
309     function Alter_TrustlessTransaction(uint256 _transactionId, bool _newStatus) public returns (bool _response) {
310 
311         uint256 sent_on = TrustlessTransactions_Log[_transactionId]._time;
312         uint256 right_now = block.timestamp;
313         uint256 difference = sub(right_now, sent_on);
314 
315         require(TransfersEnabled == true);
316         require(TrustlessTransactions_Log[_transactionId]._statusModified == false);
317         require(difference <= TrustlessTransaction_Protection_Seconds);
318         require(TrustlessTransactions_Log[_transactionId]._sender == msg.sender);
319         require(TrustlessTransactions_Log[_transactionId]._refunded == false);
320         require(TrustlessTransactions_Log[_transactionId]._credited == false);
321 
322         if (_newStatus == true) {
323 
324             UserBalances[TrustlessTransactions_Log[_transactionId]._receiver] = add(UserBalances[TrustlessTransactions_Log[_transactionId]._receiver], TrustlessTransactions_Log[_transactionId]._kvp_amount);
325             TrustlessTransactions_Log[_transactionId]._credited = true;
326 
327         } else {
328 
329             UserBalances[TrustlessTransactions_Log[_transactionId]._sender] = add(UserBalances[TrustlessTransactions_Log[_transactionId]._sender], TrustlessTransactions_Log[_transactionId]._kvp_amount);
330 
331         }
332 
333         TrustlessTransactions_Log[_transactionId]._statusModified = true;
334         TrustlessTransferStatusModified(_transactionId, _newStatus);
335 
336         return true;
337 
338     }
339 
340     function Alter_MediatedTransaction(uint256 _transactionId, bool _newStatus) public returns (bool _response) {
341 
342         require(TransfersEnabled == true);
343         require(MediatedTransactions_Log[_transactionId]._mediator == true);
344         require(MediatedTransactions_Log[_transactionId]._statusModified == false);
345         require(CoreMediator == msg.sender);
346         require(MediatedTransactions_Log[_transactionId]._credited == false);
347 
348         uint256 newAmount = sub(MediatedTransactions_Log[_transactionId]._kvp_amount, MediatedTransactions_Log[_transactionId]._fee_amount);
349 
350         if (newAmount < 0) {
351             newAmount = 0;
352         }
353 
354         if (_newStatus == true) {
355 
356             UserBalances[MediatedTransactions_Log[_transactionId]._receiver] = add(UserBalances[MediatedTransactions_Log[_transactionId]._receiver], newAmount);
357             MediatedTransactions_Log[_transactionId]._credited = true;
358 
359         } else {
360 
361             UserBalances[MediatedTransactions_Log[_transactionId]._sender] = add(UserBalances[MediatedTransactions_Log[_transactionId]._sender], newAmount);
362 
363         }
364 
365         UserBalances[CoreMediator] = add(UserBalances[CoreMediator], MediatedTransactions_Log[_transactionId]._fee_amount);
366 
367         MediatedTransactions_Log[_transactionId]._statusModified = true;
368         MediatedTransferStatusModified(_transactionId, _newStatus);
369 
370         return true;
371 
372     }
373 
374     function Refund_TrustlessTransaction(uint256 _transactionId) public returns (bool _response) {
375 
376         require(TransfersEnabled == true);
377         require(TrustlessTransactions_Log[_transactionId]._refunded == false);
378         require(TrustlessTransactions_Log[_transactionId]._statusModified == true);
379         require(TrustlessTransactions_Log[_transactionId]._credited == true);
380         require(TrustlessTransactions_Log[_transactionId]._receiver == msg.sender);
381         require(TransferValidation(msg.sender, TrustlessTransactions_Log[_transactionId]._sender, TrustlessTransactions_Log[_transactionId]._kvp_amount));
382         require(sub(UserBalances[TrustlessTransactions_Log[_transactionId]._sender], TrustlessTransactions_Log[_transactionId]._kvp_amount) > 0);
383         UserBalances[TrustlessTransactions_Log[_transactionId]._sender] = add(UserBalances[TrustlessTransactions_Log[_transactionId]._sender], TrustlessTransactions_Log[_transactionId]._kvp_amount);
384         TrustlessTransactions_Log[_transactionId]._refunded = true;
385         TrustlessTransaction_Refunded(_transactionId, TrustlessTransactions_Log[_transactionId]._kvp_amount);
386 
387         return true;
388 
389     }
390 
391     function Update_TrustlessTransaction(uint256 _transactionId) public returns (bool _response) {
392 
393         uint256 sent_on = TrustlessTransactions_Log[_transactionId]._time;
394         uint256 right_now = block.timestamp;
395         uint256 difference = sub(right_now, sent_on);
396 
397         require(TransfersEnabled == true);
398         require(TrustlessTransactions_Log[_transactionId]._statusModified == false);
399         require(difference > TrustlessTransaction_Protection_Seconds);
400         require(TrustlessTransactions_Log[_transactionId]._refunded == false);
401         require(TrustlessTransactions_Log[_transactionId]._credited == false);
402 
403         UserBalances[TrustlessTransactions_Log[_transactionId]._receiver] = add(UserBalances[TrustlessTransactions_Log[_transactionId]._receiver], TrustlessTransactions_Log[_transactionId]._kvp_amount);
404         TrustlessTransactions_Log[_transactionId]._credited = true;
405         TrustlessTransactions_Log[_transactionId]._statusModified = true;
406         TrustlessTransferStatusModified(_transactionId, true);
407 
408         return true;
409 
410     }
411 
412     function Express_Satisfaction_MediatedTransaction(uint256 _transactionId) public returns (bool _response) {
413 
414         require(TransfersEnabled == true);
415         require(MediatedTransactions_Log[_transactionId]._sender == msg.sender);
416         require(MediatedTransactions_Log[_transactionId]._mediator == false);
417         require(MediatedTransactions_Log[_transactionId]._statusModified == false);
418         require(MediatedTransactions_Log[_transactionId]._credited == false);
419         require(MediatedTransactions_Log[_transactionId]._satisfaction == false);
420 
421         UserBalances[MediatedTransactions_Log[_transactionId]._receiver] = add(UserBalances[MediatedTransactions_Log[_transactionId]._receiver], MediatedTransactions_Log[_transactionId]._kvp_amount);
422         MediatedTransactions_Log[_transactionId]._credited = true;
423         MediatedTransactions_Log[_transactionId]._statusModified = true;
424         MediatedTransactions_Log[_transactionId]._satisfaction = true;
425         MediatedTransferStatusModified(_transactionId, true);
426 
427         return true;
428 
429     }
430 
431     function Update_MediatedTransaction(uint256 _transactionId) public returns (bool _response) {
432 
433         uint256 sent_on = MediatedTransactions_Log[_transactionId]._time;
434         uint256 right_now = block.timestamp;
435         uint256 difference = sub(right_now, sent_on);
436 
437         require(TransfersEnabled == true);
438         require(difference > MediatedTransaction_Protection_Seconds);
439         require(MediatedTransactions_Log[_transactionId]._mediator == false);
440         require(MediatedTransactions_Log[_transactionId]._statusModified == false);
441         require(MediatedTransactions_Log[_transactionId]._credited == false);
442         require(MediatedTransactions_Log[_transactionId]._satisfaction == false);
443 
444         UserBalances[MediatedTransactions_Log[_transactionId]._sender] = add(UserBalances[MediatedTransactions_Log[_transactionId]._sender], MediatedTransactions_Log[_transactionId]._kvp_amount);
445 
446         MediatedTransactions_Log[_transactionId]._statusModified = true;
447         MediatedTransferStatusModified(_transactionId, false);
448 
449         return true;
450 
451     }
452 
453     function View_TrustlessTransaction_Info(uint256 _transactionId) public view returns (
454         address _sender,
455         address _receiver,
456         uint256 _kvp_amount,
457         uint256 _time
458     ) {
459 
460         return (TrustlessTransactions_Log[_transactionId]._sender, TrustlessTransactions_Log[_transactionId]._receiver, TrustlessTransactions_Log[_transactionId]._kvp_amount, TrustlessTransactions_Log[_transactionId]._time);
461 
462     }
463 
464     function View_MediatedTransaction_Info(uint256 _transactionId) public view returns (
465         address _sender,
466         address _receiver,
467         uint256 _kvp_amount,
468         uint256 _fee_amount,
469         uint256 _time
470     ) {
471 
472         return (MediatedTransactions_Log[_transactionId]._sender, MediatedTransactions_Log[_transactionId]._receiver, MediatedTransactions_Log[_transactionId]._kvp_amount, MediatedTransactions_Log[_transactionId]._fee_amount, MediatedTransactions_Log[_transactionId]._time);
473 
474     }
475 
476     function View_TrustlessTransaction_Status(uint256 _transactionId) public view returns (
477         bool _statusModified,
478         bool _credited,
479         bool _refunded
480     ) {
481 
482         return (TrustlessTransactions_Log[_transactionId]._statusModified, TrustlessTransactions_Log[_transactionId]._credited, TrustlessTransactions_Log[_transactionId]._refunded);
483 
484     }
485 
486     function View_MediatedTransaction_Status(uint256 _transactionId) public view returns (
487         bool _satisfaction,
488         bool _statusModified,
489         bool _credited
490     ) {
491 
492         return (MediatedTransactions_Log[_transactionId]._satisfaction, MediatedTransactions_Log[_transactionId]._statusModified, MediatedTransactions_Log[_transactionId]._credited);
493 
494     }
495 
496     function approve(address spender, uint256 amount) public returns (bool approved) {
497         Allowance[msg.sender][spender] = amount;
498         Approval(msg.sender, spender, amount);
499         return true;
500     }
501 
502     function balanceOf(address _address) public view returns (uint256 balance) {
503         return UserBalances[_address];
504     }
505 
506     function allowance(address owner, address spender) public view returns (uint256 amount_allowed) {
507         return Allowance[owner][spender];
508     }
509 
510     function totalSupply() public pure returns (uint256 _supply) {
511         return TotalSupply;
512     }
513 
514 }