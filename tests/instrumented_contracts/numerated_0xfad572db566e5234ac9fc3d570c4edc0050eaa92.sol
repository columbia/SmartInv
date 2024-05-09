1 pragma solidity ^0.4.16;
2 
3 // copyright contact@bytether.com
4 
5 contract BasicAccessControl {
6     address public owner;
7     address[] public moderators;
8 
9     function BasicAccessControl() public {
10         owner = msg.sender;
11     }
12 
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     modifier onlyModerators() {
19         if (msg.sender != owner) {
20             bool found = false;
21             for (uint index = 0; index < moderators.length; index++) {
22                 if (moderators[index] == msg.sender) {
23                     found = true;
24                     break;
25                 }
26             }
27             require(found);
28         }
29         _;
30     }
31 
32     function ChangeOwner(address _newOwner) onlyOwner public {
33         if (_newOwner != address(0)) {
34             owner = _newOwner;
35         }
36     }
37 
38     function Kill() onlyOwner public {
39         selfdestruct(owner);
40     }
41 
42     function AddModerator(address _newModerator) onlyOwner public {
43         if (_newModerator != address(0)) {
44             for (uint index = 0; index < moderators.length; index++) {
45                 if (moderators[index] == _newModerator) {
46                     return;
47                 }
48             }
49             moderators.push(_newModerator);
50         }
51     }
52     
53     function RemoveModerator(address _oldModerator) onlyOwner public {
54         uint foundIndex = 0;
55         for (; foundIndex < moderators.length; foundIndex++) {
56             if (moderators[foundIndex] == _oldModerator) {
57                 break;
58             }
59         }
60         if (foundIndex < moderators.length) {
61             moderators[foundIndex] = moderators[moderators.length-1];
62             delete moderators[moderators.length-1];
63             moderators.length--;
64         }
65     }
66 }
67 
68 interface TokenRecipient { 
69     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; 
70 }
71 
72 interface CrossForkDistribution {
73     function getDistributedAmount(uint64 _requestId, string _btcAddress, address _receiver) public;
74 }
75 
76 interface CrossForkCallback {
77     function callbackCrossFork(uint64 _requestId, uint256 _amount, bytes32 _referCodeHash) public;
78 }
79 
80 contract TokenERC20 {
81     uint256 public totalSupply;
82 
83     mapping (address => uint256) public balanceOf;
84     mapping (address => mapping (address => uint256)) public allowance;
85 
86     event Transfer(address indexed from, address indexed to, uint256 value);
87     event Burn(address indexed from, uint256 value);
88 
89     function _transfer(address _from, address _to, uint _value) internal {
90         require(_to != 0x0);
91         require(balanceOf[_from] >= _value);
92         require(balanceOf[_to] + _value > balanceOf[_to]);
93         uint previousBalances = balanceOf[_from] + balanceOf[_to];
94         balanceOf[_from] -= _value;
95         balanceOf[_to] += _value;
96         Transfer(_from, _to, _value);
97         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
98     }
99 
100     function transfer(address _to, uint256 _value) public {
101         _transfer(msg.sender, _to, _value);
102     }
103 
104     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
105         require(_value <= allowance[_from][msg.sender]);
106         allowance[_from][msg.sender] -= _value;
107         _transfer(_from, _to, _value);
108         return true; 
109     }
110 
111     function approve(address _spender, uint256 _value) public returns (bool success) {
112         allowance[msg.sender][_spender] = _value;
113         return true;
114     }
115 
116     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
117         TokenRecipient spender = TokenRecipient(_spender);
118         if (approve(_spender, _value)) {
119             spender.receiveApproval(msg.sender, _value, this, _extraData);
120             return true;
121         }
122     }
123 
124     function burn(uint256 _value) public returns (bool success) {
125         require(balanceOf[msg.sender] >= _value);
126         balanceOf[msg.sender] -= _value;
127         totalSupply -= _value;
128         Burn(msg.sender, _value);
129         return true;
130     }
131 
132     function burnFrom(address _from, uint256 _value) public returns (bool success) {
133         require(balanceOf[_from] >= _value);
134         require(_value <= allowance[_from][msg.sender]);
135         balanceOf[_from] -= _value;
136         allowance[_from][msg.sender] -= _value;
137         totalSupply -= _value;
138         Burn(_from, _value);
139         return true;
140     }
141 }
142 
143 contract BTHToken is BasicAccessControl, TokenERC20, CrossForkCallback {
144     // metadata
145     string public constant name = "Bytether";
146     string public constant symbol = "BTH";
147     uint256 public constant decimals = 18;
148     string public version = "1.0";
149     
150     // cross fork data
151     enum ForkResultCode { 
152         SUCCESS,
153         TRIGGERED,
154         RECEIVED,
155         PENDING,
156         FAILED,
157         ID_MISMATCH,
158         NOT_ENOUGH_BALANCE,
159         NOT_RECEIVED
160     }
161     enum ClaimReferResultCode {
162         SUCCESS,
163         NOT_ENOUGH_BALANCE
164     }
165     struct CrossForkData {
166         string btcAddress;
167         address receiver;
168         uint256 amount;
169         bytes32 referCodeHash;
170         uint createTime;
171     }
172     uint64 public crossForkCount = 0;
173     uint public referBenefitRate = 10; // 10 btc -> 1 bth
174     bool public crossForking = false;
175     mapping (uint64 => CrossForkData) crossForkMapping;
176     mapping (string => uint64) crossForkIds;
177     mapping (bytes32 => uint256) referBenefits; // referCodeHash -> bth amount
178     address public crossForkDistribution = 0x0; // crossfork contract
179     uint256 public constant satoshi_bth_decimals = 10 ** 10;
180     
181     event LogRevertCrossFork(bytes32 indexed btcAddressHash, address indexed receiver, uint64 indexed requestId, uint256 amount, ForkResultCode result);
182     event LogTriggerCrossFork(bytes32 indexed btcAddressHash, uint64 indexed requestId, ForkResultCode result);
183     event LogCrossFork(uint64 indexed requestId, address receiver, uint256 amount, ForkResultCode result);
184     event LogClaimReferBenefit(bytes32 indexed referCodeHash, address receiver, uint256 amount, ClaimReferResultCode result);
185     
186     // deposit address
187     address public crossForkFundDeposit; // deposit address for cross fork
188     address public bthFundDeposit; // deposit address for user growth pool & marketing
189     address public developerFundDeposit; // deposit address for developer fund
190     
191     // fund distribution
192     uint256 public crossForkFund = 17 * (10**6) * 10**decimals; //17m reserved for BitCoin Cross-Fork
193     uint256 public marketingFund = 2  * (10**6) * 10**decimals; //2m reserved for marketing
194     uint256 public userPoolFund  = 1  * (10**6) * 10**decimals; //1m for user growth pool
195     uint256 public developerFund = 1  * (10**6) * 10**decimals; //1m reserved for developers
196     
197     // for future feature
198     uint256 public sellPrice;
199     uint256 public buyPrice;
200     bool public trading = false;
201     mapping (address => bool) public frozenAccount;
202     event FrozenFunds(address target, bool frozen);
203     
204     // modifier
205     modifier isCrossForking {
206         require(crossForking == true || msg.sender == owner);
207         require(crossForkDistribution != 0x0);
208         _;
209     }
210     
211     modifier isTrading {
212         require(trading == true || msg.sender == owner);
213         _;
214     } 
215 
216     // constructor
217     function BTHToken(address _crossForkDistribution, address _crossForkFundDeposit, address _bthFundDeposit, address _developerFundDeposit) public {
218         totalSupply = crossForkFund + marketingFund + userPoolFund + developerFund;
219         crossForkDistribution = _crossForkDistribution;
220         crossForkFundDeposit = _crossForkFundDeposit;
221         bthFundDeposit = _bthFundDeposit;
222         developerFundDeposit = _developerFundDeposit;
223         
224         balanceOf[crossForkFundDeposit] += crossForkFund;
225         balanceOf[bthFundDeposit] += marketingFund + userPoolFund;
226         balanceOf[developerFundDeposit] += developerFund;
227     }
228 
229     function () payable public {}
230     
231     // only admin
232     function setCrossForkDistribution(address _crossForkDistribution) onlyOwner public {
233         crossForkDistribution = _crossForkDistribution;
234     }
235 
236     function setDepositAddress(address _crossForkFund, address _bthFund, address _developerFund) onlyOwner public {
237         crossForkFundDeposit = _crossForkFund;
238         bthFundDeposit = _bthFund;
239         developerFundDeposit = _developerFund;
240     }
241 
242     function setPrices(uint256 _newSellPrice, uint256 _newBuyPrice) onlyOwner public {
243         sellPrice = _newSellPrice;
244         buyPrice = _newBuyPrice;
245     }
246 
247     function setReferBenefitRate(uint _rate) onlyOwner public {
248         referBenefitRate = _rate;
249     }
250     
251     // only moderators
252     function toggleCrossForking() onlyModerators public {
253         crossForking = !crossForking;
254     }
255     
256     function toggleTrading() onlyModerators public {
257         trading = !trading;
258     }
259     
260     function claimReferBenefit(string _referCode, address _receiver) onlyModerators public {
261         bytes32 referCodeHash = keccak256(_referCode);
262         uint256 totalAmount = referBenefits[referCodeHash];
263         if (totalAmount==0) {
264             LogClaimReferBenefit(referCodeHash, _receiver, 0, ClaimReferResultCode.SUCCESS);
265             return;
266         }
267         if (balanceOf[bthFundDeposit] < totalAmount) {
268             LogClaimReferBenefit(referCodeHash, _receiver, 0, ClaimReferResultCode.NOT_ENOUGH_BALANCE);
269             return;
270         }
271         
272         referBenefits[referCodeHash] = 0;
273         balanceOf[bthFundDeposit] -= totalAmount;
274         balanceOf[_receiver] += totalAmount;
275         LogClaimReferBenefit(referCodeHash, _receiver, totalAmount, ClaimReferResultCode.SUCCESS);
276     }
277 
278     // in case there is an error
279     function revertCrossFork(string _btcAddress) onlyModerators public {
280         bytes32 btcAddressHash = keccak256(_btcAddress);
281         uint64 requestId = crossForkIds[_btcAddress];
282         if (requestId == 0) {
283             LogRevertCrossFork(btcAddressHash, 0x0, 0, 0, ForkResultCode.NOT_RECEIVED);
284             return;
285         }
286         CrossForkData storage crossForkData = crossForkMapping[requestId];
287         uint256 amount = crossForkData.amount;        
288         address receiver = crossForkData.receiver;
289         if (balanceOf[receiver] < crossForkData.amount) {
290             LogRevertCrossFork(btcAddressHash, receiver, requestId, amount, ForkResultCode.NOT_ENOUGH_BALANCE);
291             return;
292         }
293         
294         // revert
295         balanceOf[crossForkData.receiver] -= crossForkData.amount;
296         balanceOf[crossForkFundDeposit] += crossForkData.amount;
297         crossForkIds[_btcAddress] = 0;
298         crossForkData.btcAddress = "";
299         crossForkData.receiver = 0x0;
300         crossForkData.amount = 0;
301         crossForkData.createTime = 0;
302         
303         // revert refer claimable amount if possible
304         if (referBenefits[crossForkData.referCodeHash] > 0) {
305             uint256 deductAmount = crossForkData.amount;
306             if (referBenefits[crossForkData.referCodeHash] < deductAmount) {
307                 deductAmount = referBenefits[crossForkData.referCodeHash];
308             }
309             referBenefits[crossForkData.referCodeHash] -= deductAmount;
310         }
311         
312         LogRevertCrossFork(btcAddressHash, receiver, requestId, amount, ForkResultCode.SUCCESS);
313     }
314 
315     // public
316     function getCrossForkId(string _btcAddress) constant public returns(uint64) {
317         return crossForkIds[_btcAddress];
318     }
319     
320     function getCrossForkData(uint64 _id) constant public returns(string, address, uint256, uint) {
321         CrossForkData storage crossForkData = crossForkMapping[_id];
322         return (crossForkData.btcAddress, crossForkData.receiver, crossForkData.amount, crossForkData.createTime);
323     }
324     
325     function getReferBenefit(string _referCode) constant public returns(uint256) {
326         return referBenefits[keccak256(_referCode)];
327     }
328     
329     function callbackCrossFork(uint64 _requestId, uint256 _amount, bytes32 _referCodeHash) public {
330         if (msg.sender != crossForkDistribution || _amount == 0) {
331             LogCrossFork(_requestId, 0x0, 0, ForkResultCode.FAILED);
332             return;
333         }
334         CrossForkData storage crossForkData = crossForkMapping[_requestId];
335         if (crossForkData.receiver == 0x0) {
336             LogCrossFork(_requestId, crossForkData.receiver, 0, ForkResultCode.ID_MISMATCH);
337             return;
338         }
339         if (crossForkIds[crossForkData.btcAddress] != 0) {
340             LogCrossFork(_requestId, crossForkData.receiver, crossForkData.amount, ForkResultCode.RECEIVED);
341             return;
342         }
343         crossForkIds[crossForkData.btcAddress] = _requestId;
344         crossForkData.amount = _amount*satoshi_bth_decimals;
345         
346         // add fund for address
347         if (balanceOf[crossForkFundDeposit] < crossForkData.amount) {
348             LogCrossFork(_requestId, crossForkData.receiver, crossForkData.amount, ForkResultCode.NOT_ENOUGH_BALANCE);
349             return;
350         }
351         balanceOf[crossForkFundDeposit] -= crossForkData.amount;
352         balanceOf[crossForkData.receiver] += crossForkData.amount;
353         if (referBenefitRate > 0) {
354             crossForkData.referCodeHash = _referCodeHash;
355             referBenefits[_referCodeHash] += crossForkData.amount / referBenefitRate;
356         }
357         
358         LogCrossFork(_requestId, crossForkData.receiver, crossForkData.amount, ForkResultCode.SUCCESS);
359     }
360     
361     function triggerCrossFork(string _btcAddress) isCrossForking public returns(ForkResultCode) {
362         bytes32 btcAddressHash = keccak256(_btcAddress);
363         if (crossForkIds[_btcAddress] > 0) {
364             LogTriggerCrossFork(btcAddressHash, crossForkIds[_btcAddress], ForkResultCode.RECEIVED);
365             return ForkResultCode.RECEIVED;
366         }
367 
368         crossForkCount += 1;
369         CrossForkData storage crossForkData = crossForkMapping[crossForkCount];
370         crossForkData.btcAddress = _btcAddress;
371         crossForkData.receiver = msg.sender;
372         crossForkData.amount = 0;
373         crossForkData.createTime = now;
374         CrossForkDistribution crossfork = CrossForkDistribution(crossForkDistribution);
375         crossfork.getDistributedAmount(crossForkCount, _btcAddress, msg.sender);
376         LogTriggerCrossFork(btcAddressHash, crossForkIds[_btcAddress], ForkResultCode.TRIGGERED);
377         return ForkResultCode.TRIGGERED;
378     }
379     
380     function _transfer(address _from, address _to, uint _value) internal {
381         require (_to != 0x0);
382         require (balanceOf[_from] > _value);
383         require (balanceOf[_to] + _value > balanceOf[_to]);
384         require(!frozenAccount[_from]);
385         require(!frozenAccount[_to]);
386         balanceOf[_from] -= _value;
387         balanceOf[_to] += _value;
388         Transfer(_from, _to, _value);
389     }
390     
391     function freezeAccount(address _target, bool _freeze) onlyOwner public {
392         frozenAccount[_target] = _freeze;
393         FrozenFunds(_target, _freeze);
394     }
395     
396     function buy() payable isTrading public {
397         uint amount = msg.value / buyPrice;
398         _transfer(this, msg.sender, amount);
399     }
400 
401     function sell(uint256 amount) isTrading public {
402         require(this.balance >= amount * sellPrice);
403         _transfer(msg.sender, this, amount);
404         msg.sender.transfer(amount * sellPrice);
405     }
406     
407     
408 }