1 pragma solidity ^0.4.23;
2 /**
3  * @title Ownable
4  * @dev The Ownable contract has an owner address, and provides basic authorization control
5  * functions, this simplifies the implementation of "user permissions".
6  */
7 contract Ownable {
8   address public owner;
9   event OwnershipRenounced(address indexed previousOwner);
10   event OwnershipTransferred(
11     address indexed previousOwner,
12     address indexed newOwner
13   );
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   constructor() public {
19     owner = msg.sender;
20   }
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28   /**
29    * @dev Allows the current owner to relinquish control of the contract.
30    */
31   function renounceOwnership() public onlyOwner {
32     emit OwnershipRenounced(owner);
33     owner = address(0);
34   }
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param _newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address _newOwner) public onlyOwner {
40     _transferOwnership(_newOwner);
41   }
42   /**
43    * @dev Transfers control of the contract to a newOwner.
44    * @param _newOwner The address to transfer ownership to.
45    */
46   function _transferOwnership(address _newOwner) internal {
47     require(_newOwner != address(0));
48     emit OwnershipTransferred(owner, _newOwner);
49     owner = _newOwner;
50   }
51 }
52 /**
53  * @title SafeMath
54  * @dev Math operations with safety checks that throw on error
55  */
56 library SafeMath {
57   /**
58   * @dev Multiplies two numbers, throws on overflow.
59   */
60   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
61     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
62     // benefit is lost if 'b' is also tested.
63     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
64     if (a == 0) {
65       return 0;
66     }
67     c = a * b;
68     assert(c / a == b);
69     return c;
70   }
71   /**
72   * @dev Integer division of two numbers, truncating the quotient.
73   */
74   function div(uint256 a, uint256 b) internal pure returns (uint256) {
75     // assert(b > 0); // Solidity automatically throws when dividing by 0
76     // uint256 c = a / b;
77     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
78     return a / b;
79   }
80   /**
81   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
82   */
83   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84     assert(b <= a);
85     return a - b;
86   }
87   /**
88   * @dev Adds two numbers, throws on overflow.
89   */
90   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
91     c = a + b;
92     assert(c >= a);
93     return c;
94   }
95 }
96 /**
97  * @title ERC20Basic
98  * @dev Simpler version of ERC20 interface
99  * @dev see https://github.com/ethereum/EIPs/issues/179
100  */
101 contract ERC20Basic {
102   function totalSupply() public view returns (uint256);
103   function balanceOf(address who) public view returns (uint256);
104   function transfer(address to, uint256 value) public returns (bool);
105   event Transfer(address indexed from, address indexed to, uint256 value);
106 }
107 /**
108  * @title ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/20
110  */
111 contract ERC20 is ERC20Basic {
112   function allowance(address owner, address spender)
113     public view returns (uint256);
114   function transferFrom(address from, address to, uint256 value)
115     public returns (bool);
116   function approve(address spender, uint256 value) public returns (bool);
117   event Approval(
118     address indexed owner,
119     address indexed spender,
120     uint256 value
121   );
122 }
123 contract PreSale is Ownable {
124     using SafeMath for uint256;
125     mapping(address => uint256) public unconfirmedMap;
126     mapping(address => uint256) public confirmedMap;
127     mapping(address => address) public holderReferrer;
128     mapping(address => uint256) public holdersOrder;
129     address[] public holders;
130     uint256 public holdersCount;
131     mapping(address => uint256) public bonusMap;
132     mapping(address => uint256) public topMap;
133     uint256 public confirmedAmount;
134     uint256 public bonusAmount;
135     uint256 lastOf10 = 0;
136     uint256 lastOf15 = 0;
137     mapping(address => bool) _isConfirmed;
138     uint256 public totalSupply;
139     uint256 REF_BONUS_PERCENT = 50;
140     uint256 MIN_AMOUNT = 9 * 10e15;
141     uint256 OPERATIONS_FEE = 10e15;
142     uint256 public startTime;
143     uint256 public endTime;
144     //48 hours
145     uint256 public confirmTime = 48 * 3600;
146     bool internal _isGoalReached = false;
147     ERC20 token;
148     constructor(
149         uint256 _totalSupply,
150         uint256 _startTime,
151         uint256 _endTime,
152         ERC20 _token
153     ) public {
154         require(_startTime >= now);
155         require(_startTime < _endTime);
156         totalSupply = _totalSupply;
157         startTime = _startTime;
158         endTime = _endTime;
159         token = _token;
160     }
161     modifier pending() {
162         require(now >= startTime && now < endTime);
163         _;
164     }
165     modifier isAbleConfirmation() {
166         require(now >= startTime && now < endTime + confirmTime);
167         _;
168     }
169     modifier hasClosed() {
170         require(now >= endTime + confirmTime);
171         _;
172     }
173     modifier isGoalReached() {
174         require(_isGoalReached);
175         _;
176     }
177     modifier onlyConfirmed() {
178         require(_isConfirmed[msg.sender]);
179         _;
180     }
181     function() payable public pending {
182         _buyTokens(msg.sender, msg.value);
183     }
184     function buyTokens(address holder) payable public pending {
185         _buyTokens(holder, msg.value);
186     }
187     function buyTokensByReferrer(address holder, address referrer) payable public pending {
188         if (_canSetReferrer(holder, referrer)) {
189             _setReferrer(holder, referrer);
190         }
191         uint256 amount = msg.value - OPERATIONS_FEE;
192         holder.transfer(OPERATIONS_FEE);
193         _buyTokens(holder, amount);
194     }
195     function _buyTokens(address holder, uint256 amount) private {
196         require(amount >= MIN_AMOUNT);
197         if (_isConfirmed[holder]) {
198             confirmedMap[holder] = confirmedMap[holder].add(amount);
199             confirmedAmount = confirmedAmount.add(amount);
200         } else {
201             unconfirmedMap[holder] = unconfirmedMap[holder].add(amount);
202         }
203         if (holdersOrder[holder] == 0) {
204             holders.push(holder);
205             holdersOrder[holder] = holders.length;
206             holdersCount++;
207         }
208         _addBonus(holder, amount);
209     }
210     function _addBonus(address holder, uint256 amount) internal {
211         _addBonusOfTop(holder, amount);
212         _topBonus();
213         _addBonusOfReferrer(holder, amount);
214     }
215     function _addBonusOfTop(address holder, uint256 amount) internal {
216         uint256 bonusOf = 0;
217         if (holdersOrder[holder] <= holdersCount.div(10)) {
218             bonusOf = amount.div(10);
219         } else if (holdersOrder[holder] <= holdersCount.mul(15).div(100)) {
220             bonusOf = amount.mul(5).div(100);
221         }
222         if (bonusOf == 0) {
223             return;
224         }
225         topMap[holder] = topMap[holder].add(bonusOf);
226         if (_isConfirmed[holder]) {
227             bonusAmount = bonusAmount.add(bonusOf);
228         }
229     }
230     function _topBonus() internal {
231         uint256 bonusFor = 0;
232         address holder;
233         uint256 currentAmount;
234         if (lastOf10 < holdersCount.div(10)) {
235             holder = holders[lastOf10++];
236             currentAmount = _isConfirmed[holder] ? confirmedMap[holder] : unconfirmedMap[holder];
237             bonusFor = currentAmount.div(10);
238         } else if (lastOf15 < holdersCount.mul(15).div(100)) {
239             holder = holders[lastOf15++];
240             currentAmount = _isConfirmed[holder] ? confirmedMap[holder] : unconfirmedMap[holder];
241             bonusFor = currentAmount.div(20);
242         } else {
243             return;
244         }
245         if (bonusFor <= topMap[holder]) {
246             return;
247         }
248         if (_isConfirmed[holder]) {
249             uint256 diff = bonusFor - topMap[holder];
250             bonusAmount = bonusAmount.add(diff);
251         }
252         topMap[holder] = bonusFor;
253     }
254     function _addBonusOfReferrer(address holder, uint256 amount) internal {
255         if (holderReferrer[holder] == 0x0) {
256             return;
257         }
258         address referrer = holderReferrer[holder];
259         uint256 bonus = amount.div(2);
260         bonusMap[holder] = bonusMap[holder].add(bonus);
261         bonusMap[referrer] = bonusMap[referrer].add(bonus);
262         if (_isConfirmed[holder]) {
263             bonusAmount = bonusAmount.add(bonus);
264         }
265         if (_isConfirmed[referrer]) {
266             bonusAmount = bonusAmount.add(bonus);
267         }
268     }
269     function _canSetReferrer(address holder, address referrer) view private returns (bool) {
270         return holderReferrer[holder] == 0x0
271         && holder != referrer
272         && referrer != 0x0
273         && holderReferrer[referrer] != holder;
274     }
275     function _setReferrer(address holder, address referrer) private {
276         holderReferrer[holder] = referrer;
277         if (_isConfirmed[holder]) {
278             _addBonusOfReferrer(holder, confirmedMap[holder]);
279         } else {
280             _addBonusOfReferrer(holder, unconfirmedMap[holder]);
281         }
282     }
283     function setReferrer(address referrer) public pending {
284         require(_canSetReferrer(msg.sender, referrer));
285         _setReferrer(msg.sender, referrer);
286     }
287     function _confirm(address holder) private {
288         confirmedMap[holder] = unconfirmedMap[holder];
289         unconfirmedMap[holder] = 0;
290         confirmedAmount = confirmedAmount.add(confirmedMap[holder]);
291         bonusAmount = bonusAmount.add(bonusMap[holder]).add(topMap[holder]);
292         _isConfirmed[holder] = true;
293     }
294     function isConfirmed(address holder) public view returns (bool) {
295         return _isConfirmed[holder];
296     }
297     function getTokens() public hasClosed isGoalReached onlyConfirmed returns (uint256) {
298         uint256 tokens = calculateTokens(msg.sender);
299         require(tokens > 0);
300         confirmedMap[msg.sender] = 0;
301         bonusMap[msg.sender] = 0;
302         topMap[msg.sender] = 0;
303         require(token.transfer(msg.sender, tokens));
304     }
305     function getRefund() public hasClosed {
306         address holder = msg.sender;
307         uint256 funds = 0;
308         if (_isConfirmed[holder]) {
309             require(_isGoalReached == false);
310             funds = confirmedMap[holder];
311             require(funds > 0);
312             confirmedMap[holder] = 0;
313         } else {
314             funds = unconfirmedMap[holder];
315             require(funds > 0);
316             unconfirmedMap[holder] = 0;
317         }
318         holder.transfer(funds);
319     }
320     function calculateTokens(address holder) public view returns (uint256) {
321         return totalSupply.mul(calculateHolderPiece(holder)).div(calculatePie());
322     }
323     function calculatePie() public view returns (uint256) {
324         return confirmedAmount.add(bonusAmount);
325     }
326     function getCurrentPrice() public view returns (uint256) {
327         return calculatePie().div(totalSupply);
328     }
329     function calculateHolderPiece(address holder) public view returns (uint256){
330         return confirmedMap[holder].add(bonusMap[holder]).add(topMap[holder]);
331     }
332     //***** admin ***
333     function confirm(address holder) public isAbleConfirmation onlyOwner {
334         require(!_isConfirmed[holder]);
335         _confirm(holder);
336     }
337     function confirmBatch(address[] _holders) public isAbleConfirmation onlyOwner {
338         for (uint i = 0; i < _holders.length; i++) {
339             if (!_isConfirmed[_holders[i]]) {
340                 _confirm(_holders[i]);
341             }
342         }
343     }
344     function setReached(bool _isIt) public onlyOwner isAbleConfirmation {
345         _isGoalReached = _isIt;
346         if (!_isIt) {
347             token.transfer(owner, totalSupply);
348         }
349     }
350     function getRaised() public hasClosed isGoalReached onlyOwner {
351         owner.transfer(confirmedAmount);
352     }
353 }