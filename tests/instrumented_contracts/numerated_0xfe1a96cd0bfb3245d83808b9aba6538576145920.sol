1 contract Ambi {
2     function getNodeAddress(bytes32 _name) constant returns (address);
3     function addNode(bytes32 _name, address _addr) external returns (bool);
4     function hasRelation(bytes32 _from, bytes32 _role, address _to) constant returns (bool);
5 }
6 
7 contract PotRewards {
8     function transfer(address _from, address _to, uint _amount);
9 }
10 
11 contract PosRewards {
12     function transfer(address _from, address _to);
13 }
14 
15 contract ElcoinInterface {
16     function rewardTo(address _to, uint _amount) returns (bool);
17 }
18 
19 contract EtherTreasuryInterface {
20     function withdraw(address _to, uint _value) returns(bool);
21 }
22 
23 contract MetaCoinInterface {
24 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
25 	event Approved(address indexed _owner, address indexed _spender, uint256 _value);
26 	event Unapproved(address indexed _owner, address indexed _spender);
27 
28 	function totalSupply() constant returns (uint256 supply){}
29 	function balanceOf(address _owner) constant returns (uint256 balance){}
30 	function transfer(address _to, uint256 _value) returns (bool success){}
31 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success){}
32 	function approve(address _spender, uint256 _value) returns (bool success){}
33 	function unapprove(address _spender) returns (bool success){}
34 	function allowance(address _owner, address _spender) constant returns (uint256 remaining){}
35 }
36 
37 contract ElcoinDb {
38     function getBalance(address addr) constant returns(uint balance);
39     function deposit(address addr, uint amount, bytes32 hash, uint time) returns (bool res);
40     function withdraw(address addr, uint amount, bytes32 hash, uint time) returns (bool res);
41 }
42 
43 contract AmbiEnabled {
44     Ambi ambiC;
45     bytes32 public name;
46 
47     modifier checkAccess(bytes32 _role) {
48         if(address(ambiC) != 0x0 && ambiC.hasRelation(name, _role, msg.sender)){
49             _
50         }
51     }
52     
53     function getAddress(bytes32 _name) constant returns (address) {
54         return ambiC.getNodeAddress(_name);
55     }
56 
57     function setAmbiAddress(address _ambi, bytes32 _name) returns (bool){
58         if(address(ambiC) != 0x0){
59             return false;
60         }
61         Ambi ambiContract = Ambi(_ambi);
62         if(ambiContract.getNodeAddress(_name)!=address(this)) {
63             bool isNode = ambiContract.addNode(_name, address(this));
64             if (!isNode){
65                 return false;
66             }   
67         }
68         name = _name;
69         ambiC = ambiContract;
70         return true;
71     }
72 
73     function remove() checkAccess("owner") {
74         suicide(msg.sender);
75     }
76 }
77 
78 contract Elcoin is AmbiEnabled, MetaCoinInterface {
79 
80     event Error(uint8 indexed code, address indexed origin, address indexed sender);
81 
82     mapping (address => uint) public recoveredIndex;
83     address[] public recovered;
84 
85     uint public totalSupply;
86     uint public absMinFee; // set up in 1/1000000 of Elcoin
87     uint public feePercent; // set up in 1/100 of percent, 10 is 0.1%
88     uint public absMaxFee; // set up in 1/1000000 of Elcoin
89     address public feeAddr;
90 
91     function Elcoin() {
92         recovered.length++;
93         feeAddr = tx.origin;
94         _setFeeStructure(0, 0, 1);
95     }
96 
97     function _db() internal constant returns (ElcoinDb) {
98         return ElcoinDb(getAddress("elcoinDb"));
99     }
100 
101     function _setFeeStructure(uint _absMinFee, uint _feePercent, uint _absMaxFee) internal returns (bool) {
102         if(_absMinFee < 0 || _feePercent < 0 || _feePercent > 10000 || _absMaxFee < 0 || _absMaxFee < _absMinFee) {
103             Error(1, tx.origin, msg.sender);
104             return false;
105         }
106         absMinFee = _absMinFee;
107         feePercent = _feePercent;
108         absMaxFee = _absMaxFee;
109         return true;
110     }
111 
112     function _rawTransfer(ElcoinDb _db, address _from, address _to, uint _value) internal {
113         _db.withdraw(_from, _value, 0, 0);
114         uint fee = calculateFee(_value);
115         uint net = _value - fee;
116         _db.deposit(_to, net, 0, 0);
117 
118         Transfer(_from, _to, _value);
119         if (fee > 0) {
120             _db.deposit(feeAddr, fee, 0, 0);
121         }
122     }
123 
124     function _transfer(ElcoinDb _db, address _from, address _to, uint _value) internal returns (bool) {
125         if (_value < absMinFee) {
126             return false;
127         }
128         if (_from == _to) {
129             return false;
130         }
131         uint balance = _db.getBalance(_from);
132 
133         if (balance < _value) {
134             return false;
135         }
136         _rawTransfer(_db, _from, _to, _value);
137 
138         return true;
139     }
140 
141     function _transferWithReward(ElcoinDb _db, address _from, address _to, uint _value) internal returns (bool) {
142         if (!_transfer(_db, _from, _to, _value)) {
143             Error(2, tx.origin, msg.sender);
144             return false;
145         }
146 
147         address pos = getAddress("elcoinPoS");
148         address pot = getAddress("elcoinPoT");
149         if (pos != 0x0) {
150             PosRewards(pos).transfer(_from, _to);
151         }
152         if (pot != 0x0) {
153             PotRewards(pot).transfer(_from, _to, _value);
154         }
155         return true;
156     }
157 
158     function _recoverAccount(ElcoinDb _db, address _old, address _new) internal returns (bool) {
159         uint pos =  recovered.length++;
160         recovered[pos] = _old;
161         recoveredIndex[_old] = pos;
162         uint balance = _db.getBalance(_old);
163         var rv = _db.withdraw(_old, balance, 0, 0);
164         if (!rv) {
165             Error(5, tx.origin, msg.sender);
166             return false;
167         }
168         _db.deposit(_new, balance, 0, 0);
169 
170         return true;
171     }
172 
173     modifier notRecoveredAccount(address _account) {
174         if(recoveredIndex[_account] == 0x0) {
175             _
176         }
177         else {
178             return;
179         }
180     }
181 
182     function balanceOf(address _account) constant returns (uint) {
183         return _db().getBalance(_account);
184     }
185 
186     function calculateFee(uint _amount) constant returns (uint) {
187         uint fee = (_amount * feePercent) / 10000;
188 
189         if (fee < absMinFee) {
190             return absMinFee;
191         }
192 
193         if (fee > absMaxFee) {
194             return absMaxFee;
195         }
196 
197         return fee;
198     }
199 
200     function issueCoin(address _to, uint _value, uint _totalSupply) checkAccess("currencyOwner") returns (bool) {
201         if (totalSupply > 0) {
202             Error(6, tx.origin, msg.sender);
203             return false;
204         }
205 
206         bool dep = _db().deposit(_to, _value, 0, 0);
207         totalSupply = _totalSupply;
208         return dep;
209     }
210 
211     function batchTransfer(address[] _to, uint[] _value) checkAccess("currencyOwner") returns (bool) {
212         if (_to.length != _value.length) {
213             Error(7, tx.origin, msg.sender);
214             return false;
215         }
216 
217         uint totalToSend = 0;
218         for (uint8 i = 0; i < _value.length; i++) {
219             totalToSend += _value[i];
220         }
221 
222         ElcoinDb db = _db();
223         if (db.getBalance(msg.sender) < totalToSend) {
224             Error(8, tx.origin, msg.sender);
225             return false;
226         }
227 
228         db.withdraw(msg.sender, totalToSend, 0, 0);
229         for (uint8 j = 0; j < _to.length; j++) {
230             db.deposit(_to[j], _value[j], 0, 0);
231             Transfer(msg.sender, _to[j], _value[j]);
232         }
233 
234         return true;
235     }
236 
237     function transfer(address _to, uint _value) returns (bool) {
238         uint startGas = msg.gas + transferCallGas;
239         if (!_transferWithReward(_db(), msg.sender, _to, _value)) {
240             return false;
241         }
242         uint refund = (startGas - msg.gas + refundGas) * tx.gasprice;
243         return _refund(refund);
244     }
245 
246     function transferPool(address _from, address _to, uint _value) checkAccess("pool") returns (bool) {
247         return _transferWithReward(_db(), _from, _to, _value);
248     }
249 
250     function rewardTo(address _to, uint _amount) checkAccess("reward") returns (bool) {
251         bool result = _db().deposit(_to, _amount, 0, 0);
252         if (result) {
253             totalSupply += _amount;
254         }
255 
256         return result;
257     }
258 
259     function recoverAccount(address _old, address _new) checkAccess("recovery") notRecoveredAccount(_old) returns (bool) {
260         return _recoverAccount(_db(), _old, _new);
261     }
262 
263     function setFeeAddr(address _feeAddr) checkAccess("currencyOwner") {
264         feeAddr = _feeAddr;
265     }
266 
267     function setFee(uint _absMinFee, uint _feePercent, uint _absMaxFee) checkAccess("cron") returns (bool) {
268         return _setFeeStructure(_absMinFee, _feePercent, _absMaxFee);
269     }
270 
271     uint public txGasPriceLimit = 21000000000;
272     uint public transferCallGas = 21000;
273     uint public refundGas = 15000;
274     EtherTreasuryInterface treasury;
275 
276     function setupTreasury(address _treasury, uint _txGasPriceLimit) checkAccess("currencyOwner") returns (bool) {
277         if (_txGasPriceLimit == 0) {
278             return false;
279         }
280         treasury = EtherTreasuryInterface(_treasury);
281         txGasPriceLimit = _txGasPriceLimit;
282         if (msg.value > 0 && !address(treasury).send(msg.value)) {
283             throw;
284         }
285         return true;
286     }
287 
288     function updateRefundGas() checkAccess("currencyOwner") returns (uint) {
289         uint startGas = msg.gas;
290         uint refund = (startGas - msg.gas + refundGas) * tx.gasprice; // just to simulate calculations, dunno if optimizer will remove this.
291         if (!_refund(1)) {
292             return 0;
293         }
294         refundGas = startGas - msg.gas;
295         return refundGas;
296     }
297 
298     function setOperationsCallGas(uint _transfer) checkAccess("currencyOwner") returns (bool) {
299         transferCallGas = _transfer;
300         return true;
301     }
302 
303     function _refund(uint _value) internal returns (bool) {
304         if (tx.gasprice > txGasPriceLimit) {
305             return false;
306         }
307         return treasury.withdraw(tx.origin, _value);
308     }
309 }