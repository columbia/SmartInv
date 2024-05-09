1 pragma solidity ^0.4.11;
2 
3 // copyright contact@ethercheque.com
4 
5 contract EtherCheque {
6     enum Status { NONE, CREATED, LOCKED, EXPIRED, USED}
7     enum ResultCode { 
8         SUCCESS,
9         ERROR_MAX,
10         ERROR_MIN,
11         ERROR_EXIST,
12         ERROR_NOT_EXIST,
13         ERROR_INVALID_STATUS,
14         ERROR_LOCKED,
15         ERROR_EXPIRED,
16         ERROR_INVALID_AMOUNT,
17         ERROR_USED
18     }
19     struct Cheque {
20         bytes32 pinHash; // we only save sha3 of cheque signature
21         address creator;
22         Status status;
23         uint value;
24         uint createTime;
25         uint expiringPeriod; // in seconds - optional, 0 mean no expire
26         uint8 attempt; // current attempt account to cash the cheque
27     }
28     address public owner;
29     address[] public moderators;
30     uint public totalCheque = 0;
31     uint public totalChequeValue = 0;
32     uint public totalRedeemedCheque = 0;
33     uint public totalRedeemedValue = 0;
34     uint public commissionRate = 10; // div 1000
35     uint public minFee = 0.005 ether;
36     uint public minChequeValue = 0.01 ether;
37     uint public maxChequeValue = 0; // optional, 0 mean no limit
38     uint8 public maxAttempt = 3;
39     bool public isMaintaining = false;
40     
41     // hash cheque no -> Cheque info
42     mapping(bytes32 => Cheque) items;
43 
44     // modifier
45     modifier onlyOwner() {
46         require(msg.sender == owner);
47         _;
48     }
49     
50     modifier isActive {
51         if(isMaintaining == true) throw;
52         _;
53     }
54     
55     modifier onlyModerators() {
56         if (msg.sender != owner) {
57             bool found = false;
58             for (uint index = 0; index < moderators.length; index++) {
59                 if (moderators[index] == msg.sender) {
60                     found = true;
61                     break;
62                 }
63             }
64             if (!found) throw;
65         }
66         _;
67     }
68     
69     function EtherCheque() {
70         owner = msg.sender;
71     }
72 
73     // event
74     event LogCreate(bytes32 indexed chequeIdHash, uint result, uint amount);
75     event LogRedeem(bytes32 indexed chequeIdHash, ResultCode result, uint amount, address receiver);
76     event LogWithdrawEther(address indexed sendTo, ResultCode result, uint amount);
77     event LogRefundCheque(bytes32 indexed chequeIdHash, ResultCode result);
78     
79     // owner function
80     function ChangeOwner(address _newOwner) onlyOwner {
81         owner = _newOwner;
82     }
83     
84     function Kill() onlyOwner {
85         suicide(owner);
86     }
87     
88     function AddModerator(address _newModerator) onlyOwner {
89         for (uint index = 0; index < moderators.length; index++) {
90             if (moderators[index] == _newModerator) {
91                 return;
92             }
93         }
94         moderators.push(_newModerator);
95     }
96     
97     function RemoveModerator(address _oldModerator) onlyOwner {
98         uint foundIndex = 0;
99         for (; foundIndex < moderators.length; foundIndex++) {
100             if (moderators[foundIndex] == _oldModerator) {
101                 break;
102             }
103         }
104         if (foundIndex < moderators.length)
105         {
106             moderators[foundIndex] = moderators[moderators.length-1];
107             delete moderators[moderators.length-1];
108             moderators.length--;
109         }
110     }
111     
112     // moderator function
113     function SetCommissionRate(uint _commissionRate) onlyModerators {
114         commissionRate = _commissionRate;
115     }
116     
117     function SetMinFee(uint _minFee) onlyModerators {
118         minFee = _minFee;
119     }
120     
121     function SetMinChequeValue(uint _minChequeValue) onlyModerators {
122         minChequeValue = _minChequeValue;
123     }
124     
125     function SetMaxChequeValue(uint _maxChequeValue) onlyModerators {
126         maxChequeValue = _maxChequeValue;
127     }
128     
129     function SetMaxAttempt(uint8 _maxAttempt) onlyModerators {
130         maxAttempt = _maxAttempt;
131     }
132     
133     function UpdateMaintenance(bool _isMaintaining) onlyModerators {
134         isMaintaining = _isMaintaining;
135     }
136     
137     function WithdrawEther(address _sendTo, uint _amount) onlyModerators returns(ResultCode) {
138         // can only can withdraw profit - unable to withdraw cheque value
139         uint currentProfit = this.balance - (totalChequeValue - totalRedeemedValue);
140         if (_amount > currentProfit) {
141             LogWithdrawEther(_sendTo, ResultCode.ERROR_INVALID_AMOUNT, 0);
142             return ResultCode.ERROR_INVALID_AMOUNT;
143         }
144         
145         _sendTo.transfer(_amount);
146         LogWithdrawEther(_sendTo, ResultCode.SUCCESS, _amount);
147         return ResultCode.SUCCESS;
148     }
149     
150     // only when creator wants to get the money back
151     // only can refund back to creator
152     function RefundChequeById(string _chequeId) onlyModerators returns(ResultCode) {
153         bytes32 chequeIdHash = sha3(_chequeId);
154         Cheque cheque = items[chequeIdHash];
155         if (cheque.status == Status.NONE) {
156             LogRefundCheque(chequeIdHash, ResultCode.ERROR_NOT_EXIST);
157             return ResultCode.ERROR_NOT_EXIST;
158         }
159         if (cheque.status == Status.USED) {
160             LogRefundCheque(chequeIdHash, ResultCode.ERROR_USED);
161             return ResultCode.ERROR_USED;
162         }
163         
164         totalRedeemedCheque += 1;
165         totalRedeemedValue += cheque.value;
166         uint sendAmount = cheque.value;
167         
168         cheque.status = Status.USED;
169         cheque.value = 0;
170         
171         cheque.creator.transfer(sendAmount);
172         LogRefundCheque(chequeIdHash, ResultCode.SUCCESS);
173         return ResultCode.SUCCESS;
174     }
175 
176     function RefundChequeByHash(uint256 _chequeIdHash) onlyModerators returns(ResultCode) {
177         bytes32 chequeIdHash = bytes32(_chequeIdHash);
178         Cheque cheque = items[chequeIdHash];
179         if (cheque.status == Status.NONE) {
180             LogRefundCheque(chequeIdHash, ResultCode.ERROR_NOT_EXIST);
181             return ResultCode.ERROR_NOT_EXIST;
182         }
183         if (cheque.status == Status.USED) {
184             LogRefundCheque(chequeIdHash, ResultCode.ERROR_USED);
185             return ResultCode.ERROR_USED;
186         }
187         
188         totalRedeemedCheque += 1;
189         totalRedeemedValue += cheque.value;
190         uint sendAmount = cheque.value;
191         
192         cheque.status = Status.USED;
193         cheque.value = 0;
194         
195         cheque.creator.transfer(sendAmount);
196         LogRefundCheque(chequeIdHash, ResultCode.SUCCESS);
197         return ResultCode.SUCCESS;
198     }
199 
200     function GetChequeInfoByHash(uint256 _chequeIdHash) onlyModerators constant returns(Status, uint, uint, uint) {
201         bytes32 chequeIdHash = bytes32(_chequeIdHash);
202         Cheque cheque = items[chequeIdHash];
203         if (cheque.status == Status.NONE) 
204             return (Status.NONE, 0, 0, 0);
205 
206         if (cheque.expiringPeriod > 0) {
207             uint timeGap = now;
208             if (timeGap > cheque.createTime)
209                 timeGap = timeGap - cheque.createTime;
210             else
211                 timeGap = 0;
212 
213             if (cheque.expiringPeriod > timeGap)
214                 return (cheque.status, cheque.value, cheque.attempt, cheque.expiringPeriod - timeGap);
215             else
216                 return (Status.EXPIRED, cheque.value, cheque.attempt, 0);
217         }
218         return (cheque.status, cheque.value, cheque.attempt, 0);
219     }
220 
221     function VerifyCheque(string _chequeId, string _pin) onlyModerators constant returns(ResultCode, Status, uint, uint, uint) {
222         bytes32 chequeIdHash = sha3(_chequeId);
223         Cheque cheque = items[chequeIdHash];
224         if (cheque.status == Status.NONE) {
225             return (ResultCode.ERROR_NOT_EXIST, Status.NONE, 0, 0, 0);
226         }
227         if (cheque.status == Status.USED) {
228             return (ResultCode.ERROR_USED, Status.USED, 0, 0, 0);
229         }
230         if (cheque.pinHash != sha3(_chequeId, _pin)) {
231             return (ResultCode.ERROR_INVALID_STATUS, Status.NONE, 0, 0, 0);
232         }
233         
234         return (ResultCode.SUCCESS, cheque.status, cheque.value, cheque.attempt, 0);
235     }
236     
237     // constant function
238     function GetChequeInfo(string _chequeId) constant returns(Status, uint, uint, uint) {
239         bytes32 hashChequeId = sha3(_chequeId);
240         Cheque cheque = items[hashChequeId];
241         if (cheque.status == Status.NONE) 
242             return (Status.NONE, 0, 0, 0);
243 
244         if (cheque.expiringPeriod > 0) {
245             uint timeGap = now;
246             if (timeGap > cheque.createTime)
247                 timeGap = timeGap - cheque.createTime;
248             else
249                 timeGap = 0;
250 
251             if (cheque.expiringPeriod > timeGap)
252                 return (cheque.status, cheque.value, cheque.attempt, cheque.expiringPeriod - timeGap);
253             else
254                 return (Status.EXPIRED, cheque.value, cheque.attempt, 0);
255         }
256         return (cheque.status, cheque.value, cheque.attempt, 0);
257     }
258     
259     // transaction
260     function Create(uint256 _chequeIdHash, uint256 _pinHash, uint32 _expiringPeriod) payable isActive returns(ResultCode) {
261         // condition: 
262         // 1. check min value
263         // 2. check _chequeId exist or not
264         bytes32 chequeIdHash = bytes32(_chequeIdHash);
265         bytes32 pinHash = bytes32(_pinHash);
266         uint chequeValue = 0;
267         
268         // deduct commission
269         uint commissionFee = (msg.value / 1000) * commissionRate;
270         if (commissionFee < minFee) {
271             commissionFee = minFee;
272         }
273         if (msg.value < commissionFee) {
274             msg.sender.transfer(msg.value);
275             LogCreate(chequeIdHash, uint(ResultCode.ERROR_INVALID_AMOUNT), chequeValue);
276             return ResultCode.ERROR_INVALID_AMOUNT;
277         }
278         chequeValue = msg.value - commissionFee;
279         
280         if (chequeValue < minChequeValue) {
281             msg.sender.transfer(msg.value);
282             LogCreate(chequeIdHash, uint(ResultCode.ERROR_MIN), chequeValue);
283             return ResultCode.ERROR_MIN;
284         }
285         if (maxChequeValue > 0 && chequeValue > maxChequeValue) {
286             msg.sender.transfer(msg.value);
287             LogCreate(chequeIdHash, uint(ResultCode.ERROR_MAX), chequeValue);
288             return ResultCode.ERROR_MAX;
289         }
290         if (items[chequeIdHash].status != Status.NONE && items[chequeIdHash].status != Status.USED) {
291             msg.sender.transfer(msg.value);
292             LogCreate(chequeIdHash, uint(ResultCode.ERROR_EXIST), chequeValue);
293             return ResultCode.ERROR_EXIST;
294         }
295 
296         totalCheque += 1;
297         totalChequeValue += chequeValue;
298         items[chequeIdHash] = Cheque({
299             pinHash: pinHash,
300             creator: msg.sender,
301             status: Status.CREATED,
302             value: chequeValue,
303             createTime: now,
304             expiringPeriod: _expiringPeriod,
305             attempt: 0
306         });
307         
308         LogCreate(chequeIdHash, uint(ResultCode.SUCCESS), chequeValue);
309         return ResultCode.SUCCESS;
310     }
311     
312     function Redeem(string _chequeId, string _pin, address _sendTo) payable returns (ResultCode){
313         // condition
314         // 1. cheque status must exist
315         // 2. cheque status must be CREATED status for non-creator
316         // 3. verify attempt and expiry time for non-creator
317         bytes32 chequeIdHash = sha3(_chequeId);
318         Cheque cheque = items[chequeIdHash];
319         if (cheque.status == Status.NONE) {
320             LogRedeem(chequeIdHash, ResultCode.ERROR_NOT_EXIST, 0, _sendTo);
321             return ResultCode.ERROR_NOT_EXIST;
322         }
323         if (cheque.status == Status.USED) {
324             LogRedeem(chequeIdHash, ResultCode.ERROR_USED, 0, _sendTo);
325             return ResultCode.ERROR_USED;
326         }
327         if (msg.sender != cheque.creator) {
328             if (cheque.status != Status.CREATED) {
329                 LogRedeem(chequeIdHash, ResultCode.ERROR_INVALID_STATUS, 0, _sendTo);
330                 return ResultCode.ERROR_INVALID_STATUS;
331             }
332             if (cheque.attempt > maxAttempt) {
333                 LogRedeem(chequeIdHash, ResultCode.ERROR_LOCKED, 0, _sendTo);
334                 return ResultCode.ERROR_LOCKED;
335             }
336             if (cheque.expiringPeriod > 0 && now > (cheque.createTime + cheque.expiringPeriod)) {
337                 LogRedeem(chequeIdHash, ResultCode.ERROR_EXPIRED, 0, _sendTo);
338                 return ResultCode.ERROR_EXPIRED;
339             }
340         }
341         
342         // check pin
343         if (cheque.pinHash != sha3(_chequeId, _pin)) {
344             cheque.attempt += 1;
345             LogRedeem(chequeIdHash, ResultCode.ERROR_INVALID_STATUS, 0, _sendTo);
346             return ResultCode.ERROR_INVALID_STATUS;
347         }
348         
349         totalRedeemedCheque += 1;
350         totalRedeemedValue += cheque.value;
351         uint sendMount = cheque.value;
352         
353         cheque.status = Status.USED;
354         cheque.value = 0;
355         
356         _sendTo.transfer(sendMount);
357         LogRedeem(chequeIdHash, ResultCode.SUCCESS, sendMount, _sendTo);
358         return ResultCode.SUCCESS;
359     }
360 
361 }