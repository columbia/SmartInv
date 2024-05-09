1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         uint256 c = a / b;
13         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 
28     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
29         return a >= b ? a : b;
30     }
31 
32     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
33         return a < b ? a : b;
34     }
35 
36     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
37         return a >= b ? a : b;
38     }
39 
40     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
41         return a < b ? a : b;
42     }
43 }
44 
45 
46 /**
47  * @title Ownable
48  * @dev The Ownable contract has an owner address, and provides basic authorization control
49  * functions, this simplifies the implementation of "user permissions".
50  */
51 contract Ownable {
52     address public owner;
53 
54     event OwnerChanged(address indexed previousOwner, address indexed newOwner);
55 
56     /**
57      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
58      * account.
59      */
60     function Ownable() public {
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(msg.sender == owner);
68         _;
69     }
70 
71     /**
72      * @dev Allows the current owner to transfer control of the contract to a newOwner.
73      * @param _newOwner The address to transfer ownership to.
74      */
75     function changeOwner(address _newOwner) onlyOwner public {
76         require(_newOwner != address(0));
77         OwnerChanged(owner, _newOwner);
78         owner = _newOwner;
79     }
80 }
81 
82 
83 contract ContractStakeToken is Ownable {
84     using SafeMath for uint256;
85 
86     enum TypeStake {DAY, WEEK, MONTH}
87     TypeStake typeStake;
88     enum StatusStake {ACTIVE, COMPLETED, CANCEL}
89 
90     struct TransferInStructToken {
91         uint256 indexStake;
92         bool isRipe;
93     }
94 
95     struct StakeStruct {
96         address owner;
97         uint256 amount;
98         TypeStake stakeType;
99         uint256 time;
100         StatusStake status;
101     }
102 
103     StakeStruct[] arrayStakesToken;
104 
105     uint256[] public rates = [101, 109, 136];
106 
107     uint256 public totalDepositTokenAll;
108 
109     uint256 public totalWithdrawTokenAll;
110 
111     mapping (address => uint256) balancesToken;
112     mapping (address => uint256) totalDepositToken;
113     mapping (address => uint256) totalWithdrawToken;
114     mapping (address => TransferInStructToken[]) transferInsToken;
115     mapping (address => bool) public contractUsers;
116 
117     event Withdraw(address indexed receiver, uint256 amount);
118 
119     function ContractStakeToken(address _owner) public {
120         require(_owner != address(0));
121         owner = _owner;
122         //owner = msg.sender; // for test's
123     }
124 
125     modifier onlyOwnerOrUser() {
126         require(msg.sender == owner || contractUsers[msg.sender]);
127         _;
128     }
129 
130     /**
131     * @dev Add an contract admin
132     */
133     function setContractUser(address _user, bool _isUser) public onlyOwner {
134         contractUsers[_user] = _isUser;
135     }
136 
137     // fallback function can be used to buy tokens
138     function() payable public {
139         //deposit(msg.sender, msg.value, TypeStake.DAY, now);
140     }
141 
142     function depositToken(address _investor, TypeStake _stakeType, uint256 _time, uint256 _value) onlyOwnerOrUser external returns (bool){
143         require(_investor != address(0));
144         require(_value > 0);
145         require(transferInsToken[_investor].length < 31);
146 
147         balancesToken[_investor] = balancesToken[_investor].add(_value);
148         totalDepositToken[_investor] = totalDepositToken[_investor].add(_value);
149         totalDepositTokenAll = totalDepositTokenAll.add(_value);
150         uint256 indexStake = arrayStakesToken.length;
151 
152         arrayStakesToken.push(StakeStruct({
153             owner : _investor,
154             amount : _value,
155             stakeType : _stakeType,
156             time : _time,
157             status : StatusStake.ACTIVE
158             }));
159         transferInsToken[_investor].push(TransferInStructToken(indexStake, false));
160 
161         return true;
162     }
163 
164     /**
165      * @dev Function checks how much you can remove the Token
166      * @param _address The address of depositor.
167      * @param _now The current time.
168      * @return the amount of Token that can be withdrawn from contract
169      */
170     function validWithdrawToken(address _address, uint256 _now) public returns (uint256){
171         require(_address != address(0));
172         uint256 amount = 0;
173 
174         if (balancesToken[_address] <= 0 || transferInsToken[_address].length <= 0) {
175             return amount;
176         }
177 
178         for (uint i = 0; i < transferInsToken[_address].length; i++) {
179             uint256 indexCurStake = transferInsToken[_address][i].indexStake;
180             TypeStake stake = arrayStakesToken[indexCurStake].stakeType;
181             uint256 stakeTime = arrayStakesToken[indexCurStake].time;
182             uint256 stakeAmount = arrayStakesToken[indexCurStake].amount;
183             uint8 currentStake = 0;
184             if (arrayStakesToken[transferInsToken[_address][i].indexStake].status == StatusStake.CANCEL) {
185                 amount = amount.add(stakeAmount);
186                 transferInsToken[_address][i].isRipe = true;
187                 continue;
188             }
189             if (stake == TypeStake.DAY) {
190                 currentStake = 0;
191                 if (_now < stakeTime.add(1 days)) continue;
192             }
193             if (stake == TypeStake.WEEK) {
194                 currentStake = 1;
195                 if (_now < stakeTime.add(7 days)) continue;
196             }
197             if (stake == TypeStake.MONTH) {
198                 currentStake = 2;
199                 if (_now < stakeTime.add(730 hours)) continue;
200             }
201             uint256 amountHours = _now.sub(stakeTime).div(1 hours);
202             stakeAmount = calculator(currentStake, stakeAmount, amountHours);
203             amount = amount.add(stakeAmount);
204             transferInsToken[_address][i].isRipe = true;
205             arrayStakesToken[transferInsToken[_address][i].indexStake].status = StatusStake.COMPLETED;
206         }
207         return amount;
208     }
209 
210     function withdrawToken(address _address) onlyOwnerOrUser public returns (uint256){
211         require(_address != address(0));
212         uint256 _currentTime = now;
213         _currentTime = 1525651200; // for test
214         uint256 _amount = validWithdrawToken(_address, _currentTime);
215         require(_amount > 0);
216         totalWithdrawToken[_address] = totalWithdrawToken[_address].add(_amount);
217         totalWithdrawTokenAll = totalWithdrawTokenAll.add(_amount);
218         while (clearTransferInsToken(_address) == false) {
219             clearTransferInsToken(_address);
220         }
221         Withdraw(_address, _amount);
222         return _amount;
223     }
224 
225     function clearTransferInsToken(address _owner) private returns (bool) {
226         for (uint i = 0; i < transferInsToken[_owner].length; i++) {
227             if (transferInsToken[_owner][i].isRipe == true) {
228                 balancesToken[_owner] = balancesToken[_owner].sub(arrayStakesToken[transferInsToken[_owner][i].indexStake].amount);
229                 removeMemberArrayToken(_owner, i);
230                 return false;
231             }
232         }
233         return true;
234     }
235 
236     function removeMemberArrayToken(address _address, uint index) private {
237         if (index >= transferInsToken[_address].length) return;
238         for (uint i = index; i < transferInsToken[_address].length - 1; i++) {
239             transferInsToken[_address][i] = transferInsToken[_address][i + 1];
240         }
241         delete transferInsToken[_address][transferInsToken[_address].length - 1];
242         transferInsToken[_address].length--;
243     }
244 
245     function balanceOfToken(address _owner) public view returns (uint256 balance) {
246         return balancesToken[_owner];
247     }
248 
249     function cancel(uint256 _index, address _address) onlyOwnerOrUser public returns (bool _result) {
250         require(_index >= 0);
251         require(_address != address(0));
252         if(_address != arrayStakesToken[_index].owner){
253             return false;
254         }
255         arrayStakesToken[_index].status = StatusStake.CANCEL;
256         return true;
257     }
258 
259     function withdrawOwner(uint256 _amount) public onlyOwner returns (bool) {
260         require(this.balance >= _amount);
261         owner.transfer(_amount);
262         Withdraw(owner, _amount);
263     }
264 
265     function changeRates(uint8 _numberRate, uint256 _percent) onlyOwnerOrUser public returns (bool) {
266         require(_percent >= 0);
267         require(0 <= _numberRate && _numberRate < 3);
268         rates[_numberRate] = _percent.add(100);
269         return true;
270 
271     }
272 
273     function getTokenStakeByIndex(uint256 _index) onlyOwnerOrUser public view returns (
274         address _owner,
275         uint256 _amount,
276         TypeStake _stakeType,
277         uint256 _time,
278         StatusStake _status
279     ) {
280         require(_index < arrayStakesToken.length);
281         _owner = arrayStakesToken[_index].owner;
282         _amount = arrayStakesToken[_index].amount;
283         _stakeType = arrayStakesToken[_index].stakeType;
284         _time = arrayStakesToken[_index].time;
285         _status = arrayStakesToken[_index].status;
286     }
287 
288     function getTokenTransferInsByAddress(address _address, uint256 _index) onlyOwnerOrUser public view returns (
289         uint256 _indexStake,
290         bool _isRipe
291     ) {
292         require(_index < transferInsToken[_address].length);
293         _indexStake = transferInsToken[_address][_index].indexStake;
294         _isRipe = transferInsToken[_address][_index].isRipe;
295     }
296 
297     function getCountTransferInsToken(address _address) public view returns (uint256 _count) {
298         _count = transferInsToken[_address].length;
299     }
300 
301     function getCountStakesToken() public view returns (uint256 _count) {
302         _count = arrayStakesToken.length;
303     }
304 
305     function getTotalTokenDepositByAddress(address _owner) public view returns (uint256 _amountToken) {
306         return totalDepositToken[_owner];
307     }
308 
309     function getTotalTokenWithdrawByAddress(address _owner) public view returns (uint256 _amountToken) {
310         return totalWithdrawToken[_owner];
311     }
312 
313     function removeContract() public onlyOwner {
314         selfdestruct(owner);
315     }
316 
317     function calculator(uint8 _currentStake, uint256 _amount, uint256 _amountHours) public view returns (uint256 stakeAmount){
318         uint32 i = 0;
319         uint256 number = 0;
320         stakeAmount = _amount;
321         if (_currentStake == 0) {
322             number = _amountHours.div(24);
323         }
324         if (_currentStake == 1) {
325             number = _amountHours.div(168);
326         }
327         if (_currentStake == 2) {
328             number = _amountHours.div(730);
329         }
330         while(i < number){
331             stakeAmount= stakeAmount.mul(rates[_currentStake]).div(100);
332             i++;
333         }
334     }
335 
336 }