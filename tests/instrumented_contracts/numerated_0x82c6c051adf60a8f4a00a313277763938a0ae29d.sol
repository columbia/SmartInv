1 pragma solidity ^0.4.11;
2 
3 // copyright contact@ethercheque.com
4 
5 contract EtherCheque {
6     enum Status { NONE, CREATED, LOCKED, EXPIRED }
7     enum ResultCode { 
8         SUCCESS,
9         ERROR_MAX,
10         ERROR_MIN,
11         ERROR_EXIST,
12         ERROR_NOT_EXIST,
13         ERROR_INVALID_STATUS,
14         ERROR_LOCKED,
15         ERROR_EXPIRED,
16         ERROR_INVALID_AMOUNT
17     }
18     struct Cheque {
19         bytes32 pinHash; // we only save sha3 of cheque signature
20         address creator;
21         Status status;
22         uint value;
23         uint createTime;
24         uint expiringPeriod; // in seconds - optional, 0 mean no expire
25         uint8 attempt; // current attempt account to cash the cheque
26     }
27     address public owner;
28     address[] public moderators;
29     uint public totalCheque = 0;
30     uint public totalChequeValue = 0;
31     uint public totalRedeemedCheque = 0;
32     uint public totalRedeemedValue = 0;
33     uint public commissionFee = 10; // div 1000
34     uint public minChequeValue = 0.01 ether;
35     uint public maxChequeValue = 0; // optional, 0 mean no limit
36     uint8 public maxAttempt = 3;
37     bool public isMaintaining = false;
38     
39     // hash cheque no -> Cheque info
40     mapping(bytes32 => Cheque) items;
41 
42     // modifier
43     modifier onlyOwner() {
44         require(msg.sender == owner);
45         _;
46     }
47     
48     modifier isActive {
49         if(isMaintaining == true) throw;
50         _;
51     }
52     
53     modifier onlyModerators() {
54         if (msg.sender != owner) {
55             bool found = false;
56             for (uint index = 0; index < moderators.length; index++) {
57                 if (moderators[index] == msg.sender) {
58                     found = true;
59                     break;
60                 }
61             }
62             if (!found) throw;
63         }
64         _;
65     }
66     
67     function EtherCheque() {
68         owner = msg.sender;
69     }
70 
71     // event
72     event LogCreate(bytes32 indexed chequeIdHash, uint result, uint amount);
73     event LogRedeem(bytes32 indexed chequeIdHash, ResultCode result, uint amount, address receiver);
74     event LogWithdrawEther(address indexed sendTo, ResultCode result, uint amount);
75     event LogRefundCheque(bytes32 indexed chequeIdHash, ResultCode result);
76     
77     // owner function
78     function ChangeOwner(address _newOwner) onlyOwner {
79         owner = _newOwner;
80     }
81     
82     function Kill() onlyOwner {
83         suicide(owner);
84     }
85     
86     function AddModerator(address _newModerator) onlyOwner {
87         for (uint index = 0; index < moderators.length; index++) {
88             if (moderators[index] == _newModerator) {
89                 return;
90             }
91         }
92         moderators.push(_newModerator);
93     }
94     
95     function RemoveModerator(address _oldModerator) onlyOwner {
96         uint foundIndex = 0;
97         for (; foundIndex < moderators.length; foundIndex++) {
98             if (moderators[foundIndex] == _oldModerator) {
99                 break;
100             }
101         }
102         if (foundIndex < moderators.length)
103         {
104             moderators[foundIndex] = moderators[moderators.length-1];
105             delete moderators[moderators.length-1];
106             moderators.length--;
107         }
108     }
109     
110     // moderator function
111     function SetCommissionValue(uint _commissionFee) onlyModerators {
112         commissionFee = _commissionFee;
113     }
114     
115     function SetMinChequeValue(uint _minChequeValue) onlyModerators {
116         minChequeValue = _minChequeValue;
117     }
118     
119     function SetMaxChequeValue(uint _maxChequeValue) onlyModerators {
120         maxChequeValue = _maxChequeValue;
121     }
122     
123     function SetMaxAttempt(uint8 _maxAttempt) onlyModerators {
124         maxAttempt = _maxAttempt;
125     }
126     
127     function UpdateMaintenance(bool _isMaintaining) onlyModerators {
128         isMaintaining = _isMaintaining;
129     }
130     
131     function WithdrawEther(address _sendTo, uint _amount) onlyModerators returns(ResultCode) {
132         // can only can withdraw profit - unable to withdraw cheque value
133         uint currentProfit = this.balance - (totalChequeValue - totalRedeemedValue);
134         if (_amount > currentProfit) {
135             LogWithdrawEther(_sendTo, ResultCode.ERROR_INVALID_AMOUNT, 0);
136             return ResultCode.ERROR_INVALID_AMOUNT;
137         }
138         
139         _sendTo.transfer(_amount);
140         LogWithdrawEther(_sendTo, ResultCode.SUCCESS, _amount);
141         return ResultCode.SUCCESS;
142     }
143     
144     // only when creator wants to get the money back
145     // only can refund back to creator
146     function RefundChequeById(string _chequeId) onlyModerators returns(ResultCode) {
147         bytes32 hashChequeId = sha3(_chequeId);
148         Cheque cheque = items[hashChequeId];
149         if (cheque.status == Status.NONE) {
150             LogRefundCheque(hashChequeId, ResultCode.ERROR_NOT_EXIST);
151             return ResultCode.ERROR_NOT_EXIST;
152         }
153         
154         totalRedeemedCheque += 1;
155         totalRedeemedValue += cheque.value;
156         uint sendAmount = cheque.value;
157         delete items[hashChequeId];
158         cheque.creator.transfer(sendAmount);
159         LogRefundCheque(hashChequeId, ResultCode.SUCCESS);
160         return ResultCode.SUCCESS;
161     }
162 
163     function RefundChequeByHash(uint256 _chequeIdHash) onlyModerators returns(ResultCode) {
164         bytes32 hashChequeId = bytes32(_chequeIdHash);
165         Cheque cheque = items[hashChequeId];
166         if (cheque.status == Status.NONE) {
167             LogRefundCheque(hashChequeId, ResultCode.ERROR_NOT_EXIST);
168             return ResultCode.ERROR_NOT_EXIST;
169         }
170         
171         totalRedeemedCheque += 1;
172         totalRedeemedValue += cheque.value;
173         uint sendAmount = cheque.value;
174         delete items[hashChequeId];
175         cheque.creator.transfer(sendAmount);
176         LogRefundCheque(hashChequeId, ResultCode.SUCCESS);
177         return ResultCode.SUCCESS;
178     }
179 
180     function GetChequeInfoByHash(uint256 _chequeIdHash) onlyModerators constant returns(Status, uint, uint, uint) {
181         bytes32 hashChequeId = bytes32(_chequeIdHash);
182         Cheque cheque = items[hashChequeId];
183         if (cheque.status == Status.NONE) 
184             return (Status.NONE, 0, 0, 0);
185 
186         if (cheque.expiringPeriod > 0) {
187             uint timeGap = now;
188             if (timeGap > cheque.createTime)
189                 timeGap = timeGap - cheque.createTime;
190             else
191                 timeGap = 0;
192 
193             if (cheque.expiringPeriod > timeGap)
194                 return (cheque.status, cheque.value, cheque.attempt, cheque.expiringPeriod - timeGap);
195             else
196                 return (Status.EXPIRED, cheque.value, cheque.attempt, 0);
197         }
198         return (cheque.status, cheque.value, cheque.attempt, 0);
199     }
200 
201     function VerifyCheque(string _chequeId, string _pin) onlyModerators constant returns(ResultCode, Status, uint, uint, uint) {
202         bytes32 chequeIdHash = sha3(_chequeId);
203         Cheque cheque = items[chequeIdHash];
204         if (cheque.status == Status.NONE) {
205             return (ResultCode.ERROR_NOT_EXIST, Status.NONE, 0, 0, 0);
206         }
207         if (cheque.pinHash != sha3(_chequeId, _pin)) {
208             return (ResultCode.ERROR_INVALID_STATUS, Status.NONE, 0, 0, 0);
209         }
210         
211         return (ResultCode.SUCCESS, cheque.status, cheque.value, cheque.attempt, 0);
212     }
213     
214     // constant function
215     function GetChequeInfo(string _chequeId) constant returns(Status, uint, uint, uint) {
216         bytes32 hashChequeId = sha3(_chequeId);
217         Cheque cheque = items[hashChequeId];
218         if (cheque.status == Status.NONE) 
219             return (Status.NONE, 0, 0, 0);
220 
221         if (cheque.expiringPeriod > 0) {
222             uint timeGap = now;
223             if (timeGap > cheque.createTime)
224                 timeGap = timeGap - cheque.createTime;
225             else
226                 timeGap = 0;
227 
228             if (cheque.expiringPeriod > timeGap)
229                 return (cheque.status, cheque.value, cheque.attempt, cheque.expiringPeriod - timeGap);
230             else
231                 return (Status.EXPIRED, cheque.value, cheque.attempt, 0);
232         }
233         return (cheque.status, cheque.value, cheque.attempt, 0);
234     }
235     
236     // transaction
237     function Create(uint256 _chequeIdHash, uint256 _pinHash, uint32 _expiringPeriod) payable isActive returns(ResultCode) {
238         // condition: 
239         // 1. check min value
240         // 2. check _chequeId exist or not
241         bytes32 chequeIdHash = bytes32(_chequeIdHash);
242         bytes32 pinHash = bytes32(_pinHash);
243         uint chequeValue = 0;
244         if (msg.value < minChequeValue) {
245             msg.sender.transfer(msg.value);
246             LogCreate(chequeIdHash, uint(ResultCode.ERROR_MIN), chequeValue);
247             return ResultCode.ERROR_MIN;
248         }
249         if (maxChequeValue > 0 && msg.value > maxChequeValue) {
250             msg.sender.transfer(msg.value);
251             LogCreate(chequeIdHash, uint(ResultCode.ERROR_MAX), chequeValue);
252             return ResultCode.ERROR_MAX;
253         }
254         if (items[chequeIdHash].status != Status.NONE) {
255             msg.sender.transfer(msg.value);
256             LogCreate(chequeIdHash, uint(ResultCode.ERROR_EXIST), chequeValue);
257             return ResultCode.ERROR_EXIST;
258         }
259         
260         // deduct commission
261         chequeValue = (msg.value / 1000) * (1000 - commissionFee);
262         totalCheque += 1;
263         totalChequeValue += chequeValue;
264         items[chequeIdHash] = Cheque({
265             pinHash: pinHash,
266             creator: msg.sender,
267             status: Status.CREATED,
268             value: chequeValue,
269             createTime: now,
270             expiringPeriod: _expiringPeriod,
271             attempt: 0
272         });
273         
274         LogCreate(chequeIdHash, uint(ResultCode.SUCCESS), chequeValue);
275         return ResultCode.SUCCESS;
276     }
277     
278     function Redeem(string _chequeId, string _pin, address _sendTo) payable returns (ResultCode){
279         // condition
280         // 1. cheque status must exist
281         // 2. cheque status must be CREATED status for non-creator
282         // 3. verify attempt and expiry time for non-creator
283         bytes32 chequeIdHash = sha3(_chequeId);
284         Cheque cheque = items[chequeIdHash];
285         if (cheque.status == Status.NONE) {
286             LogRedeem(chequeIdHash, ResultCode.ERROR_NOT_EXIST, 0, _sendTo);
287             return ResultCode.ERROR_NOT_EXIST;
288         }
289         if (msg.sender != cheque.creator) {
290             if (cheque.status != Status.CREATED) {
291                 LogRedeem(chequeIdHash, ResultCode.ERROR_INVALID_STATUS, 0, _sendTo);
292                 return ResultCode.ERROR_INVALID_STATUS;
293             }
294             if (cheque.attempt > maxAttempt) {
295                 LogRedeem(chequeIdHash, ResultCode.ERROR_LOCKED, 0, _sendTo);
296                 return ResultCode.ERROR_LOCKED;
297             }
298             if (cheque.expiringPeriod > 0 && now > (cheque.createTime + cheque.expiringPeriod)) {
299                 LogRedeem(chequeIdHash, ResultCode.ERROR_EXPIRED, 0, _sendTo);
300                 return ResultCode.ERROR_EXPIRED;
301             }
302         }
303         
304         // check pin
305         if (cheque.pinHash != sha3(_chequeId, _pin)) {
306             cheque.attempt += 1;
307             LogRedeem(chequeIdHash, ResultCode.ERROR_INVALID_STATUS, 0, _sendTo);
308             return ResultCode.ERROR_INVALID_STATUS;
309         }
310         
311         totalRedeemedCheque += 1;
312         totalRedeemedValue += cheque.value;
313         uint sendMount = cheque.value;
314         delete items[chequeIdHash];
315         _sendTo.transfer(sendMount);
316         LogRedeem(chequeIdHash, ResultCode.SUCCESS, sendMount, _sendTo);
317         return ResultCode.SUCCESS;
318     }
319 
320 }