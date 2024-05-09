1 pragma solidity ^0.5.2;
2 
3 /*
4  * Admin sets only for revealling address restricton
5  */
6 contract RevealPrivilege {
7     address owner;
8     address public delegateAddr;
9     mapping(address => bool) public isAdmin;
10 
11     modifier onlyAdmins() {
12         require(isAdmin[msg.sender] == true);
13         _;
14     }
15     
16     modifier isContractOwner() {
17         require(owner == msg.sender);
18         _;
19     }
20     
21     function addAdmin(address _addr) isContractOwner public {
22         isAdmin[_addr] = true;
23     }
24     
25     function removeAdmin(address _addr) isContractOwner public {
26         isAdmin[_addr] = false;
27     }
28     
29     function transferOwner(address _addr) isContractOwner public {
30         owner = _addr;
31     }
32     
33     function setdelegateAddr(address _addr) onlyAdmins public {
34         delegateAddr = _addr;
35     }
36 }
37 
38 contract FIH is RevealPrivilege {
39     using SafeMath for uint256;
40     
41     // constant value
42     uint256 constant withdrawalFee = 0.05 ether;
43     uint256 constant stake = 0.01 ether;
44     
45     uint256 public bonusCodeNonce;
46     uint16 public currentPeriod;
47     uint256 bonusPool;
48     uint256 public teamBonus;
49     
50     struct BonusCode {
51         uint8 prefix;
52         uint256 orderId;
53         uint256 code;
54         uint256 nums;
55         uint256 period;
56         address addr;
57     }
58     
59     //user balance
60     mapping(address => uint256) balanceOf;
61     mapping(address => bool) public allowance;
62     // _period => BonusCode
63     mapping(uint16 => BonusCode) public revealResultPerPeriod;
64     mapping(uint16 => uint256) revealBonusPerPeriod;
65     
66     mapping(address => BonusCode[]) revealInfoByAddr;
67 
68     mapping(uint16 => uint256) gameBonusPerPeriod;
69     
70     mapping(uint16 => mapping(address => uint256)) invitedBonus; // period => address => amount
71     mapping(address => address) invitedRelations;
72 
73     mapping(uint16 => mapping(uint8 => uint256)) sideTotalAmount; // period => prefix => amount
74     mapping(uint16 => mapping(uint256 => BonusCode)) public revealBonusCodes; // period => code => BonusCode
75     mapping(uint16 => uint256[]) bcodes; // period => code
76 
77     event Bet(uint16 _currentPeriod, uint256 _orderId, uint256 _code, address _from);
78     event Deposit(address _from, address _to, uint256 _amount);
79     event Reveal(uint16 _currentPeriod, uint256 _orderId, uint256 _prefix, uint256 _code, address _addr, uint256 _winnerBonus);
80     event Withdrawal(address _to, uint256 _amount);
81 
82     constructor () public {
83         owner = msg.sender;
84         isAdmin[owner] = true;
85         currentPeriod = 1;
86         bonusCodeNonce = 0;
87         bonusPool = 0;
88         teamBonus = 0;
89         gameBonusPerPeriod[currentPeriod] = 0;
90     }
91 
92     function deposit(address _to) payable public { 
93         require(msg.value > 0);
94         if (msg.sender != _to) {
95             require(msg.sender == delegateAddr, "deposit can only from self-address or delegated address");
96             allowance[_to] = true;
97         }
98         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], msg.value);
99         emit Deposit(msg.sender, _to, msg.value);
100     }
101     
102     function bet(address _from, address _invitedAddr, uint256 _amount, uint8 _fType) public {
103         // validate
104         require(stake <= _amount  && _amount <= balanceOf[_from], "amount should more than stake and less or equal to balance");
105         if (msg.sender != _from) {
106             require(msg.sender == delegateAddr && allowance[_from] == true, "permission rejected");
107         }
108         if (_invitedAddr != address(0x0)) {
109              require(_from != _invitedAddr, "bet _from is not equals _invitedAddr");
110         }
111         
112         //handler balance and allowance
113         balanceOf[_from] = balanceOf[_from].safeSub(_amount);
114          
115         sideTotalAmount[currentPeriod][_fType] = sideTotalAmount[currentPeriod][_fType].safeAdd(_amount);
116         /* split amount */
117         //1. bonusPool
118         uint256 currentAmount = _amount;
119         uint256 gameBonusPercentVal = _amount.safeMul(20).safeDiv(100);
120         uint256 teamBonusPercentVal = _amount.safeMul(15).safeDiv(100);
121         uint256 bonusPoolPercentVal = _amount.safeMul(50).safeDiv(100);
122         
123         gameBonusPerPeriod[currentPeriod] = gameBonusPerPeriod[currentPeriod].safeAdd(gameBonusPercentVal);
124         currentAmount = currentAmount.safeSub(gameBonusPercentVal);
125         
126         teamBonus = teamBonus.safeAdd(teamBonusPercentVal);
127         currentAmount = currentAmount.safeSub(teamBonusPercentVal);
128         
129         bonusPool = bonusPool.safeAdd(bonusPoolPercentVal);
130         currentAmount = currentAmount.safeSub(bonusPoolPercentVal);
131         
132         //invited bonus 
133         uint256 bonusLevelOne = _amount.safeMul(10).safeDiv(100);
134         uint256 bonusLevelTwo = _amount.safeMul(5).safeDiv(100);
135         
136         if(_invitedAddr != address(0x0)) {
137             invitedRelations[_from] = _invitedAddr;
138         }
139         if (invitedRelations[_from] != address(0x0)) {
140             address fa = invitedRelations[_from];
141             invitedBonus[currentPeriod][fa] = invitedBonus[currentPeriod][fa].safeAdd(bonusLevelOne);
142             balanceOf[fa] = balanceOf[fa].safeAdd(bonusLevelOne);
143             currentAmount = currentAmount.safeSub(bonusLevelOne);
144             address gfa = invitedRelations[fa];
145             if (gfa != address(0x0)) {
146                invitedBonus[currentPeriod][gfa] = invitedBonus[currentPeriod][gfa].safeAdd(bonusLevelTwo);
147                balanceOf[gfa] = balanceOf[gfa].safeAdd(bonusLevelTwo);
148                currentAmount = currentAmount.safeSub(bonusLevelTwo);
149             }
150         }
151         assert(currentAmount >= 0);
152         bonusPool = bonusPool.safeAdd(currentAmount);
153         
154         //generate order and bonusCodes
155         uint256 oId = block.timestamp;
156         
157         BonusCode memory bc = BonusCode({
158             orderId: oId,
159             prefix:  _fType,
160             code:    bonusCodeNonce,
161             nums:    _amount.safeDiv(stake),
162             addr:    _from, 
163             period:  currentPeriod
164         });
165         revealBonusCodes[currentPeriod][bonusCodeNonce] = bc;
166         bcodes[currentPeriod].push(bonusCodeNonce);
167         emit Bet(currentPeriod, oId, bonusCodeNonce, _from);
168         bonusCodeNonce = bonusCodeNonce.safeAdd(_amount.safeDiv(stake));
169     }
170     
171     event Debug(uint256 winnerIndex, uint256 bcodesLen, uint256 pos);
172     function reveal(string memory _seed) public onlyAdmins {
173         // random winner index
174         
175         uint256 winner = uint256(keccak256(abi.encodePacked(_seed, msg.sender, block.timestamp))) % bonusCodeNonce;
176         uint256 lt = 0;
177         uint256 rt = bcodes[currentPeriod].length - 1;
178         require(lt <= rt, "bcodes length is not correct");
179         uint256 pos = lt;
180         while (lt <= rt) {
181             uint256 mid = lt + (rt - lt) / 2;
182             if (bcodes[currentPeriod][mid] <= winner) {
183                 pos = mid;
184                 lt = mid + 1;
185             } else {
186                 rt = mid - 1;
187             }
188         }
189         emit Debug(winner, bcodes[currentPeriod].length, pos);
190         
191         
192         uint256 halfBonusPool = bonusPool.safeMul(50).safeDiv(100);
193         BonusCode memory winnerBcode = revealBonusCodes[currentPeriod][bcodes[currentPeriod][pos]];
194         
195         // iterate;  
196         uint256 bcodesLen = bcodes[currentPeriod].length;
197         for (uint256 i = 0; i < bcodesLen; i++) {
198             if (revealBonusCodes[currentPeriod][bcodes[currentPeriod][i]].prefix != winnerBcode.prefix) {
199                 continue;
200             }
201             BonusCode memory thisBonusCode = revealBonusCodes[currentPeriod][bcodes[currentPeriod][i]];
202             if (thisBonusCode.addr == winnerBcode.addr && thisBonusCode.orderId == winnerBcode.orderId) {
203                 balanceOf[winnerBcode.addr] = balanceOf[winnerBcode.addr].safeAdd(halfBonusPool);
204             } else {
205                 uint256 bonusAmount = halfBonusPool.safeMul(
206                     thisBonusCode.nums.safeMul(stake).safeDiv(sideTotalAmount[currentPeriod][winnerBcode.prefix])
207                     );
208                 balanceOf[thisBonusCode.addr] = balanceOf[thisBonusCode.addr].safeAdd(bonusAmount);
209             }
210         }
211         
212         // update reveal result && reset value
213         revealBonusPerPeriod[currentPeriod] = halfBonusPool;
214         revealResultPerPeriod[currentPeriod] = winnerBcode;
215         revealInfoByAddr[winnerBcode.addr].push(winnerBcode);
216         currentPeriod++;
217         bonusPool = 0;
218         bonusCodeNonce = 0;
219         gameBonusPerPeriod[currentPeriod] = 0;
220         
221         emit Reveal(currentPeriod - 1, winnerBcode.orderId, winnerBcode.prefix, winnerBcode.code, winnerBcode.addr, halfBonusPool);
222     }
223     
224     function withdrawal(address _from, address payable _to, uint256 _amount) public {
225         // permission check
226         if (msg.sender != _from) {
227             require(allowance[_from] == true && msg.sender == delegateAddr, "permission rejected");
228         }
229         // amount check
230         require(withdrawalFee <= _amount && _amount <= balanceOf[_from], "Don't have enough balance");
231         
232         balanceOf[_from] = balanceOf[_from].safeSub(_amount);
233         _amount = _amount.safeSub(withdrawalFee);
234         teamBonus = teamBonus.safeAdd(withdrawalFee);
235         
236 	  	_to.transfer(_amount);
237 	    emit Withdrawal(_to, _amount);
238     }
239     
240     function teamWithdrawal() onlyAdmins public {
241         require(teamBonus > 0, "Don't have enough teamBonus");
242         uint256 tmp = teamBonus;
243         teamBonus = 0;
244         msg.sender.transfer(tmp);
245     }
246     
247     function gameBonusWithdrawal(uint16 _period) onlyAdmins public {
248         require(gameBonusPerPeriod[_period] > 0, "Don't have enough money");
249         uint256 tmp = gameBonusPerPeriod[_period];
250         gameBonusPerPeriod[_period] = 0;
251         msg.sender.transfer(tmp);
252     }
253     
254     function updateContract() isContractOwner public {
255         msg.sender.transfer(address(this).balance);
256     }
257     
258     /*
259      * read only part
260      * for query 
261      */
262     function getBalance(address _addr) public view returns(uint256) {
263         return balanceOf[_addr];
264     }
265     
266     function getBonusPool() public view returns(uint256) {
267         return bonusPool;
268     }
269 
270     function getBonusInvited(address _from) public view returns(uint256) {
271         return invitedBonus[currentPeriod][_from];
272     }
273     
274     function getRevealResultPerPeriod(uint16 _period) public view returns(uint8 _prefix, uint256 _orderId, uint256 _code, uint256 _nums, address _addr, uint256 _revealBonus) {
275         _prefix = revealResultPerPeriod[_period].prefix;
276         _orderId = revealResultPerPeriod[_period].orderId;
277         _code = revealResultPerPeriod[_period].code;
278         _nums = revealResultPerPeriod[_period].nums;
279         _addr = revealResultPerPeriod[_period].addr;
280         _revealBonus = revealBonusPerPeriod[_period];
281     }
282 }
283 
284 /**
285  * @title SafeMath
286  * @dev Unsigned math operations with safety checks that revert on error
287  */
288 library SafeMath {
289     /**
290      * @dev Multiplies two unsigned integers, reverts on overflow.
291      */
292     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
293         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
294         // benefit is lost if 'b' is also tested.
295         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
296         if (a == 0) {
297             return 0;
298         }
299 
300         uint256 c = a * b;
301         require(c / a == b);
302 
303         return c;
304     }
305 
306     /**
307      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
308      */
309     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
310         // Solidity only automatically asserts when dividing by 0
311         require(b > 0);
312         uint256 c = a / b;
313         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
314 
315         return c;
316     }
317 
318     /**
319      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
320      */
321     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
322         require(b <= a);
323         uint256 c = a - b;
324 
325         return c;
326     }
327 
328     /**
329      * @dev Adds two unsigned integers, reverts on overflow.
330      */
331     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
332         uint256 c = a + b;
333         require(c >= a);
334 
335         return c;
336     }
337 
338     /**
339      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
340      * reverts when dividing by zero.
341      */
342     function safeMod(uint256 a, uint256 b) internal pure returns (uint256) {
343         require(b != 0);
344         return a % b;
345     }
346 }