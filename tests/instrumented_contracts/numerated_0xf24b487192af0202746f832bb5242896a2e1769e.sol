1 pragma solidity 0.4.19;
2 
3 contract Admin {
4 
5     address public owner;
6     mapping(address => bool) public AdminList;
7 
8     event AdministratorAdded(address indexed _invoker, address indexed _newAdministrator);
9     event AdministratorRemoved(address indexed _invoker, address indexed _removedAdministrator);
10     event OwnershipChanged(address indexed _invoker, address indexed _newOwner);
11 
12     function Admin() public {
13         owner = msg.sender;
14     }
15 
16     modifier OnlyAdmin() {
17         require(msg.sender == owner || AdminList[msg.sender] == true);
18         _;
19     }
20 
21     modifier OnlyOwner() {
22         require(msg.sender == owner);
23         _;
24     }
25 
26     function MakeAdministrator(address AddressToAdd) public returns (bool success) {
27 
28         require(msg.sender == owner);
29         require(AddressToAdd != address(0));
30         AdminList[AddressToAdd] = true;
31         AdministratorAdded(msg.sender, AddressToAdd);
32 
33         return true;
34 
35     }
36 
37     function RemoveAdministrator(address AddressToRemove) public returns (bool success) {
38 
39         require(msg.sender == owner);
40         require(AddressToRemove != address(0));
41         delete AdminList[AddressToRemove];
42         AdministratorRemoved(msg.sender, AddressToRemove);
43 
44         return true;
45 
46     }
47 
48     function ChangeOwner(address AddressToMake) public returns (bool success) {
49 
50         require(msg.sender == owner);
51         require(AddressToMake != address(0));
52         require(owner != AddressToMake);
53         owner = AddressToMake;
54         OwnershipChanged(msg.sender, AddressToMake);
55 
56         return true;
57 
58     }
59 
60 }
61 
62 contract KoveredPay is Admin {
63 
64     bytes4 public symbol = "KVP";
65     bytes16 public name = "KoveredPay";
66     uint8 public decimals = 18;
67     uint256 constant TotalSupply = 50000000000000000000000000;
68 
69     bool public TransfersEnabled;
70     uint256 public TrustlessTransactions_TransactionHeight = 0;
71     uint256 public MediatedTransactions_TransactionHeight = 0;
72     uint128 public TrustlessTransaction_Protection_Seconds = 259200;
73     uint128 public MediatedTransaction_Protection_Seconds = 2620800;
74     address public InitialOwnerAddress = address(0);
75     address public CoreMediator = address(0);
76     uint256 public MediatorFees = 0;
77     uint256 public LockInExpiry = 0;
78 
79     mapping(address => uint256) public UserBalances;
80     mapping(address => mapping(address => uint256)) public Allowance;
81 
82     struct TrustlessTransaction {
83         address _sender;
84         address _receiver;
85         uint256 _kvp_amount;
86         bool _statusModified;
87         bool _credited;
88         bool _refunded;
89         uint256 _time;
90     }
91 
92     struct MediatedTransaction {
93         address _sender;
94         address _receiver;
95         bool _mediator;
96         uint256 _kvp_amount;
97         uint256 _fee_amount;
98         bool _satisfaction;
99         bool _statusModified;
100         bool _credited;
101         uint256 _time;
102     }
103 
104     mapping(uint256 => TrustlessTransaction) public TrustlessTransactions_Log;
105     mapping(uint256 => MediatedTransaction) public MediatedTransactions_Log;
106 
107     event Transfer(address indexed _from, address indexed _to, uint256 _value);
108     event Trustless_Transfer(uint256 _id, address indexed _from, address indexed _to, uint256 _value);
109     event Mediated_Transfer(uint256 _id, address indexed _from, address indexed _to, uint256 _value);
110     event TrustlessTransferStatusModified(uint256 _transactionId, bool _newStatus);
111     event MediatedTransferStatusModified(uint256 _transactionId, bool _newStatus);
112     event TrustlessTransaction_Refunded(uint256 _transactionId, uint256 _amount);
113     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
114 
115     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
116         uint256 c = a * b;
117         require(a == 0 || c / a == b);
118         return c;
119     }
120 
121     function div(uint256 a, uint256 b) internal pure returns (uint256) {
122         uint256 c = a / b;
123         return c;
124     }
125 
126     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
127         require(b <= a);
128         return a - b;
129     }
130 
131     function add(uint256 a, uint256 b) internal pure returns (uint256) {
132         uint256 c = a + b;
133         require(c >= a);
134         return c;
135     }
136 
137     function KoveredPay() public {
138 
139         UserBalances[msg.sender] = TotalSupply;
140         CoreMediator = msg.sender;
141         InitialOwnerAddress = msg.sender;
142         LockInExpiry = add(block.timestamp, 15778463);
143         TransfersEnabled = true;
144 
145     }
146 
147     function AlterMediatorSettings(address _newAddress, uint128 _fees) public OnlyAdmin returns (bool success) {
148 
149         CoreMediator = _newAddress;
150         MediatorFees = _fees;
151 
152         return true;
153 
154     }
155 
156     function ChangeProtectionTime(uint _type, uint128 _seconds) public OnlyAdmin returns (bool success) {
157 
158         if (_type == 1) {
159             TrustlessTransaction_Protection_Seconds = _seconds;
160         } else {
161             MediatedTransaction_Protection_Seconds = _seconds;
162         }
163 
164         return true;
165 
166     }
167 
168     function TransferStatus(bool _newStatus) public OnlyAdmin returns (bool success) {
169 
170         TransfersEnabled = _newStatus;
171 
172         return true;
173 
174     }
175 
176     function TransferValidation(address sender, address recipient, uint256 amount) private view returns (bool success) {
177 
178         require(TransfersEnabled == true);
179         require(amount > 0);
180         require(recipient != address(0));
181         require(UserBalances[sender] >= amount);
182         require(sub(UserBalances[sender], amount) >= 0);
183         require(add(UserBalances[recipient], amount) > UserBalances[recipient]);
184 
185         if (sender == InitialOwnerAddress && block.timestamp < LockInExpiry) {
186             require(sub(UserBalances[sender], amount) >= 10000000000000000000000000);
187         }
188 
189         return true;
190 
191     }
192 
193     function MultiTransfer(address[] _destinations, uint256[] _values) public OnlyAdmin returns (uint256) {
194 
195         uint256 i = 0;
196 
197         while (i < _destinations.length) {
198             transfer(_destinations[i], _values[i]);
199             i += 1;
200         }
201 
202         return (i);
203 
204     }
205 
206     function transfer(address receiver, uint256 amount) public returns (bool _status) {
207 
208         require(TransferValidation(msg.sender, receiver, amount));
209         UserBalances[msg.sender] = sub(UserBalances[msg.sender], amount);
210         UserBalances[receiver] = add(UserBalances[receiver], amount);
211         Transfer(msg.sender, receiver, amount);
212         return true;
213 
214     }
215 
216     function transferFrom(address _owner, address _receiver, uint256 _amount) public returns (bool _status) {
217 
218         require(TransferValidation(_owner, _receiver, _amount));
219         require(sub(Allowance[_owner][msg.sender], _amount) >= _amount);
220         Allowance[_owner][msg.sender] = sub(Allowance[_owner][msg.sender], _amount);
221         UserBalances[_owner] = sub(UserBalances[_owner], _amount);
222         UserBalances[_receiver] = add(UserBalances[_receiver], _amount);
223         Transfer(_owner, _receiver, _amount);
224         return true;
225 
226     }
227 
228     function Send_TrustlessTransaction(address receiver, uint256 amount) public returns (uint256 transferId) {
229 
230         require(TransferValidation(msg.sender, receiver, amount));
231         UserBalances[msg.sender] = sub(UserBalances[msg.sender], amount);
232         TrustlessTransactions_TransactionHeight = TrustlessTransactions_TransactionHeight + 1;
233         TrustlessTransactions_Log[TrustlessTransactions_TransactionHeight] = TrustlessTransaction(msg.sender, receiver, amount, false, false, false, block.timestamp);
234         Trustless_Transfer(TrustlessTransactions_TransactionHeight, msg.sender, receiver, amount);
235         return TrustlessTransactions_TransactionHeight;
236 
237     }
238 
239     function Send_MediatedTransaction(address receiver, uint256 amount) public returns (uint256 transferId) {
240 
241         require(TransferValidation(msg.sender, receiver, amount));
242         UserBalances[msg.sender] = sub(UserBalances[msg.sender], amount);
243         MediatedTransactions_TransactionHeight = MediatedTransactions_TransactionHeight + 1;
244         MediatedTransactions_Log[MediatedTransactions_TransactionHeight] = MediatedTransaction(msg.sender, receiver, false, amount, 0, false, false, false, block.timestamp);
245         Mediated_Transfer(MediatedTransactions_TransactionHeight, msg.sender, receiver, amount);
246         return MediatedTransactions_TransactionHeight;
247 
248     }
249 
250     function Appoint_Mediator(uint256 _txid) public returns (bool success) {
251 
252         if (MediatedTransactions_Log[_txid]._sender == msg.sender || MediatedTransactions_Log[_txid]._receiver == msg.sender) {
253 
254             uint256 sent_on = MediatedTransactions_Log[_txid]._time;
255             uint256 right_now = block.timestamp;
256             uint256 difference = sub(right_now, sent_on);
257 
258             require(MediatedTransactions_Log[_txid]._mediator == false);
259             require(MediatedTransactions_Log[_txid]._satisfaction == false);
260             require(MediatedTransactions_Log[_txid]._statusModified == false);
261             require(difference <= MediatedTransaction_Protection_Seconds);
262             require(MediatedTransactions_Log[_txid]._credited == false);
263             require(MediatedTransactions_Log[_txid]._kvp_amount >= MediatorFees);
264 
265             MediatedTransactions_Log[_txid]._mediator = true;
266             MediatedTransactions_Log[_txid]._fee_amount = MediatorFees;
267 
268             return true;
269 
270         } else {
271 
272             return false;
273 
274         }
275 
276     }
277 
278     function Alter_TrustlessTransaction(uint256 _transactionId, bool _newStatus) public returns (bool _response) {
279 
280         uint256 sent_on = TrustlessTransactions_Log[_transactionId]._time;
281         uint256 right_now = block.timestamp;
282         uint256 difference = sub(right_now, sent_on);
283 
284         require(TransfersEnabled == true);
285         require(TrustlessTransactions_Log[_transactionId]._statusModified == false);
286         require(difference <= TrustlessTransaction_Protection_Seconds);
287         require(TrustlessTransactions_Log[_transactionId]._sender == msg.sender);
288         require(TrustlessTransactions_Log[_transactionId]._refunded == false);
289         require(TrustlessTransactions_Log[_transactionId]._credited == false);
290 
291         if (_newStatus == true) {
292 
293             UserBalances[TrustlessTransactions_Log[_transactionId]._receiver] = add(UserBalances[TrustlessTransactions_Log[_transactionId]._receiver], TrustlessTransactions_Log[_transactionId]._kvp_amount);
294             TrustlessTransactions_Log[_transactionId]._credited = true;
295 
296         } else {
297 
298             UserBalances[TrustlessTransactions_Log[_transactionId]._sender] = add(UserBalances[TrustlessTransactions_Log[_transactionId]._sender], TrustlessTransactions_Log[_transactionId]._kvp_amount);
299 
300         }
301 
302         TrustlessTransactions_Log[_transactionId]._statusModified = true;
303         TrustlessTransferStatusModified(_transactionId, _newStatus);
304 
305         return true;
306 
307     }
308 
309     function Alter_MediatedTransaction(uint256 _transactionId, bool _newStatus) public returns (bool _response) {
310 
311         require(TransfersEnabled == true);
312         require(MediatedTransactions_Log[_transactionId]._mediator == true);
313         require(MediatedTransactions_Log[_transactionId]._statusModified == false);
314         require(CoreMediator == msg.sender);
315         require(MediatedTransactions_Log[_transactionId]._credited == false);
316 
317         uint256 newAmount = sub(MediatedTransactions_Log[_transactionId]._kvp_amount, MediatedTransactions_Log[_transactionId]._fee_amount);
318 
319         if (newAmount < 0) {
320             newAmount = 0;
321         }
322 
323         if (_newStatus == true) {
324 
325             UserBalances[MediatedTransactions_Log[_transactionId]._receiver] = add(UserBalances[MediatedTransactions_Log[_transactionId]._receiver], newAmount);
326             MediatedTransactions_Log[_transactionId]._credited = true;
327 
328         } else {
329 
330             UserBalances[MediatedTransactions_Log[_transactionId]._sender] = add(UserBalances[MediatedTransactions_Log[_transactionId]._sender], newAmount);
331 
332         }
333 
334         UserBalances[CoreMediator] = add(UserBalances[CoreMediator], MediatedTransactions_Log[_transactionId]._fee_amount);
335 
336         MediatedTransactions_Log[_transactionId]._statusModified = true;
337         MediatedTransferStatusModified(_transactionId, _newStatus);
338 
339         return true;
340 
341     }
342 
343     function Refund_TrustlessTransaction(uint256 _transactionId) public returns (bool _response) {
344 
345         require(TransfersEnabled == true);
346         require(TrustlessTransactions_Log[_transactionId]._refunded == false);
347         require(TrustlessTransactions_Log[_transactionId]._statusModified == true);
348         require(TrustlessTransactions_Log[_transactionId]._credited == true);
349         require(TrustlessTransactions_Log[_transactionId]._receiver == msg.sender);
350         require(TransferValidation(msg.sender, TrustlessTransactions_Log[_transactionId]._sender, TrustlessTransactions_Log[_transactionId]._kvp_amount));
351         require(sub(UserBalances[TrustlessTransactions_Log[_transactionId]._sender], TrustlessTransactions_Log[_transactionId]._kvp_amount) > 0);
352         UserBalances[TrustlessTransactions_Log[_transactionId]._sender] = add(UserBalances[TrustlessTransactions_Log[_transactionId]._sender], TrustlessTransactions_Log[_transactionId]._kvp_amount);
353         TrustlessTransactions_Log[_transactionId]._refunded = true;
354         TrustlessTransaction_Refunded(_transactionId, TrustlessTransactions_Log[_transactionId]._kvp_amount);
355 
356         return true;
357 
358     }
359 
360     function Update_TrustlessTransaction(uint256 _transactionId) public returns (bool _response) {
361 
362         uint256 sent_on = TrustlessTransactions_Log[_transactionId]._time;
363         uint256 right_now = block.timestamp;
364         uint256 difference = sub(right_now, sent_on);
365 
366         require(TransfersEnabled == true);
367         require(TrustlessTransactions_Log[_transactionId]._statusModified == false);
368         require(difference > TrustlessTransaction_Protection_Seconds);
369         require(TrustlessTransactions_Log[_transactionId]._refunded == false);
370         require(TrustlessTransactions_Log[_transactionId]._credited == false);
371 
372         UserBalances[TrustlessTransactions_Log[_transactionId]._receiver] = add(UserBalances[TrustlessTransactions_Log[_transactionId]._receiver], TrustlessTransactions_Log[_transactionId]._kvp_amount);
373         TrustlessTransactions_Log[_transactionId]._credited = true;
374         TrustlessTransactions_Log[_transactionId]._statusModified = true;
375         TrustlessTransferStatusModified(_transactionId, true);
376 
377         return true;
378 
379     }
380 
381     function Express_Satisfaction_MediatedTransaction(uint256 _transactionId) public returns (bool _response) {
382 
383         require(TransfersEnabled == true);
384         require(MediatedTransactions_Log[_transactionId]._sender == msg.sender);
385         require(MediatedTransactions_Log[_transactionId]._mediator == false);
386         require(MediatedTransactions_Log[_transactionId]._statusModified == false);
387         require(MediatedTransactions_Log[_transactionId]._credited == false);
388         require(MediatedTransactions_Log[_transactionId]._satisfaction == false);
389 
390         UserBalances[MediatedTransactions_Log[_transactionId]._receiver] = add(UserBalances[MediatedTransactions_Log[_transactionId]._receiver], MediatedTransactions_Log[_transactionId]._kvp_amount);
391         MediatedTransactions_Log[_transactionId]._credited = true;
392         MediatedTransactions_Log[_transactionId]._statusModified = true;
393         MediatedTransactions_Log[_transactionId]._satisfaction = true;
394         MediatedTransferStatusModified(_transactionId, true);
395 
396         return true;
397 
398     }
399 
400     function Update_MediatedTransaction(uint256 _transactionId) public returns (bool _response) {
401 
402         uint256 sent_on = MediatedTransactions_Log[_transactionId]._time;
403         uint256 right_now = block.timestamp;
404         uint256 difference = sub(right_now, sent_on);
405 
406         require(TransfersEnabled == true);
407         require(difference > MediatedTransaction_Protection_Seconds);
408         require(MediatedTransactions_Log[_transactionId]._mediator == false);
409         require(MediatedTransactions_Log[_transactionId]._statusModified == false);
410         require(MediatedTransactions_Log[_transactionId]._credited == false);
411         require(MediatedTransactions_Log[_transactionId]._satisfaction == false);
412 
413         UserBalances[MediatedTransactions_Log[_transactionId]._sender] = add(UserBalances[MediatedTransactions_Log[_transactionId]._sender], MediatedTransactions_Log[_transactionId]._kvp_amount);
414 
415         MediatedTransactions_Log[_transactionId]._statusModified = true;
416         MediatedTransferStatusModified(_transactionId, false);
417 
418         return true;
419 
420     }
421 
422     function View_TrustlessTransaction_Info(uint256 _transactionId) public view returns (
423         address _sender,
424         address _receiver,
425         uint256 _kvp_amount,
426         uint256 _time
427     ) {
428 
429         return (TrustlessTransactions_Log[_transactionId]._sender, TrustlessTransactions_Log[_transactionId]._receiver, TrustlessTransactions_Log[_transactionId]._kvp_amount, TrustlessTransactions_Log[_transactionId]._time);
430 
431     }
432 
433     function View_MediatedTransaction_Info(uint256 _transactionId) public view returns (
434         address _sender,
435         address _receiver,
436         uint256 _kvp_amount,
437         uint256 _fee_amount,
438         uint256 _time
439     ) {
440 
441         return (MediatedTransactions_Log[_transactionId]._sender, MediatedTransactions_Log[_transactionId]._receiver, MediatedTransactions_Log[_transactionId]._kvp_amount, MediatedTransactions_Log[_transactionId]._fee_amount, MediatedTransactions_Log[_transactionId]._time);
442 
443     }
444 
445     function View_TrustlessTransaction_Status(uint256 _transactionId) public view returns (
446         bool _statusModified,
447         bool _credited,
448         bool _refunded
449     ) {
450 
451         return (TrustlessTransactions_Log[_transactionId]._statusModified, TrustlessTransactions_Log[_transactionId]._credited, TrustlessTransactions_Log[_transactionId]._refunded);
452 
453     }
454 
455     function View_MediatedTransaction_Status(uint256 _transactionId) public view returns (
456         bool _satisfaction,
457         bool _statusModified,
458         bool _credited
459     ) {
460 
461         return (MediatedTransactions_Log[_transactionId]._satisfaction, MediatedTransactions_Log[_transactionId]._statusModified, MediatedTransactions_Log[_transactionId]._credited);
462 
463     }
464 
465     function approve(address spender, uint256 amount) public returns (bool approved) {
466         require(amount > 0);
467         require(UserBalances[spender] > 0);
468         Allowance[msg.sender][spender] = amount;
469         Approval(msg.sender, spender, amount);
470         return true;
471     }
472 
473     function balanceOf(address _address) public view returns (uint256 balance) {
474         return UserBalances[_address];
475     }
476 
477     function allowance(address owner, address spender) public view returns (uint256 smount_allowed) {
478         return Allowance[owner][spender];
479     }
480 
481     function totalSupply() public pure returns (uint256 _supply) {
482         return TotalSupply;
483     }
484 
485 }