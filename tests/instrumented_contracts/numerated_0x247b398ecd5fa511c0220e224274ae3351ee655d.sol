1 pragma solidity 0.4.25;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://eips.ethereum.org/EIPS/eip-20
6  */
7 contract IERC20 {
8     function transfer(address to, uint256 value) public returns (bool);
9 
10     function approve(address spender, uint256 value) public returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) public returns (bool);
13 
14     function balanceOf(address who) public view returns (uint256);
15 
16     function allowance(address owner, address spender) public view returns (uint256);
17 
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 contract Auth {
24   address internal backupAdmin;
25   address internal mainAdmin;
26   address internal contractAdmin;
27   address internal dabAdmin;
28   address internal gemAdmin;
29   address internal LAdmin;
30 
31   constructor(
32     address _backupAdmin,
33     address _mainAdmin,
34     address _contractAdmin,
35     address _dabAdmin,
36     address _gemAdmin,
37     address _LAdmin
38   )
39   internal
40   {
41     backupAdmin = _backupAdmin;
42     mainAdmin = _mainAdmin;
43     contractAdmin = _contractAdmin;
44     dabAdmin = _dabAdmin;
45     gemAdmin = _gemAdmin;
46     LAdmin = _LAdmin;
47   }
48 
49   modifier onlyBackupAdmin() {
50     require(isBackupAdmin(), "onlyBackupAdmin");
51     _;
52   }
53 
54   modifier onlyMainAdmin() {
55     require(isMainAdmin(), "onlyMainAdmin");
56     _;
57   }
58 
59   modifier onlyBackupOrMainAdmin() {
60     require(isMainAdmin() || isBackupAdmin(), "onlyBackupOrMainAdmin");
61     _;
62   }
63 
64   modifier onlyContractAdmin() {
65     require(isContractAdmin() || isMainAdmin(), "onlyContractAdmin");
66     _;
67   }
68 
69   modifier onlyLAdmin() {
70     require(isLAdmin() || isMainAdmin(), "onlyLAdmin");
71     _;
72   }
73 
74   modifier onlyDABAdmin() {
75     require(isDABAdmin() || isMainAdmin(), "onlyDABAdmin");
76     _;
77   }
78 
79   modifier onlyGEMAdmin() {
80     require(isGEMAdmin() || isMainAdmin(), "onlyGEMAdmin");
81     _;
82   }
83 
84   function isBackupAdmin() public view returns (bool) {
85     return msg.sender == backupAdmin;
86   }
87 
88   function isMainAdmin() public view returns (bool) {
89     return msg.sender == mainAdmin;
90   }
91 
92   function isContractAdmin() public view returns (bool) {
93     return msg.sender == contractAdmin;
94   }
95 
96   function isLAdmin() public view returns (bool) {
97     return msg.sender == LAdmin;
98   }
99 
100   function isDABAdmin() public view returns (bool) {
101     return msg.sender == dabAdmin;
102   }
103 
104   function isGEMAdmin() public view returns (bool) {
105     return msg.sender == gemAdmin;
106   }
107 }
108 
109 interface IContractNo2 {
110   function adminCommission(uint _amount) external;
111 
112   function deposit(
113     address _user,
114     uint8 _type,
115     uint packageAmount,
116     uint _dabAmount,
117     uint _gemAmount
118   ) external;
119 
120   function getProfit(address _user, uint _stakingBalance) external returns (uint, uint);
121 
122   function getWithdraw(address _user, uint _stakingBalance, uint8 _type) external returns (uint, uint);
123 
124   function validateJoinPackage(
125     address _user,
126     address _to,
127     uint8 _type,
128     uint _dabAmount,
129     uint _gemAmount
130   ) external returns (bool);
131 }
132 
133 interface IContractNo3 {
134 
135   function isCitizen(address _user) view external returns (bool);
136 
137   function register(address _user, string _userName, address _inviter) external returns (uint);
138 
139   function addF1M9DepositedToInviter(address _invitee, uint _amount) external;
140 
141   function checkInvestorsInTheSameReferralTree(address _inviter, address _invitee) external view returns (bool);
142 
143   function increaseInviterF1HaveJoinedPackage(address _invitee) external;
144 
145   function increaseInviterF1HaveJoinedM9Package(address _invitee) external;
146 
147   function addNetworkDepositedToInviter(address _inviter, uint _dabAmount, uint _gemAmount) external;
148 
149   function getF1M9Deposited(address _investor) external view returns (uint);
150 
151   function getDirectlyInviteeHaveJoinedM9Package(address _investor) external view returns (address[]);
152 
153   function getRank(address _investor) external view returns (uint8);
154 
155   function getInviter(address _investor) external view returns (address);
156 
157   function showInvestorInfo(address _investorAddress) external view returns (uint, string memory, address, address[],  address[],  address[], uint, uint, uint, uint, uint);
158 }
159 
160 /**
161  * @title SafeMath
162  * @dev Unsigned math operations with safety checks that revert on error.
163  */
164 library SafeMath {
165   /**
166    * @dev Multiplies two unsigned integers, reverts on overflow.
167    */
168   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
169     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
170     // benefit is lost if 'b' is also tested.
171     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
172     if (a == 0) {
173       return 0;
174     }
175 
176     uint256 c = a * b;
177     require(c / a == b, 'SafeMath mul error');
178 
179     return c;
180   }
181 
182   /**
183    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
184    */
185   function div(uint256 a, uint256 b) internal pure returns (uint256) {
186     // Solidity only automatically asserts when dividing by 0
187     require(b > 0, 'SafeMath div error');
188     uint256 c = a / b;
189     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
190 
191     return c;
192   }
193 
194   /**
195    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
196    */
197   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
198     require(b <= a, 'SafeMath sub error');
199     uint256 c = a - b;
200 
201     return c;
202   }
203 
204   /**
205    * @dev Adds two unsigned integers, reverts on overflow.
206    */
207   function add(uint256 a, uint256 b) internal pure returns (uint256) {
208     uint256 c = a + b;
209     require(c >= a, 'SafeMath add error');
210 
211     return c;
212   }
213 
214   /**
215    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
216    * reverts when dividing by zero.
217    */
218   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
219     require(b != 0, 'SafeMath mod error');
220     return a % b;
221   }
222 }
223 
224 contract ContractNo1 is Auth {
225   using SafeMath for uint;
226 
227   enum PackageType {
228     M0,
229     M3,
230     M6,
231     M9,
232     M12,
233     M15,
234     M18
235   }
236 
237   enum WithdrawType {
238     Half,
239     Full
240   }
241 
242   mapping(address => bool) public lAS;
243   IERC20 public dabToken = IERC20(0x5E7Ebea68ab05198F771d77a875480314f1d0aae);
244   IContractNo2 public contractNo2;
245   IContractNo3 public contractNo3;
246 
247   uint public minJP = 5e18;
248   uint8 public gemJPPercent = 30;
249 
250   event Registered(uint id, string userName, address userAddress, address inviter);
251   event PackageJoined(address indexed from, address indexed to, PackageType packageType, uint dabAmount, uint gemAmount);
252   event Profited(address indexed user, uint dabAmount, uint gemAmount);
253   event Withdrew(address indexed user, uint dabAmount, uint gemAmount);
254 
255   constructor(
256     address _backupAdmin,
257     address _mainAdmin,
258     address _dabAdmin,
259     address _LAdmin
260   )
261   public
262   Auth(
263     _backupAdmin,
264     _mainAdmin,
265     msg.sender,
266     _dabAdmin,
267     address(0x0),
268     _LAdmin
269   ) {
270   }
271 
272   // ADMINS FUNCTIONS
273 
274   function setC(address _c) onlyContractAdmin public {
275     contractNo3 = IContractNo3(_c);
276   }
277 
278   function setW(address _w) onlyContractAdmin public {
279     contractNo2 = IContractNo2(_w);
280   }
281 
282   function updateBackupAdmin(address _newBackupAdmin) onlyBackupAdmin public {
283     require(_newBackupAdmin != address(0x0), 'Invalid address');
284     backupAdmin = _newBackupAdmin;
285   }
286 
287   function updateMainAdmin(address _newMainAdmin) onlyBackupOrMainAdmin public {
288     require(_newMainAdmin != address(0x0), 'Invalid address');
289     mainAdmin = _newMainAdmin;
290   }
291 
292   function updateContractAdmin(address _newContractAdmin) onlyMainAdmin public {
293     require(_newContractAdmin != address(0x0), 'Invalid address');
294     contractAdmin = _newContractAdmin;
295   }
296 
297   function updateDABAdmin(address _newDABAdmin) onlyMainAdmin public {
298     require(_newDABAdmin != address(0x0), 'Invalid address');
299     dabAdmin = _newDABAdmin;
300   }
301 
302   function updateLockerAdmin(address _newLockerAdmin) onlyMainAdmin public {
303     require(_newLockerAdmin != address(0x0), 'Invalid address');
304     LAdmin = _newLockerAdmin;
305   }
306 
307   function LA(address[] _values, bool _locked) onlyLAdmin public {
308     require(_values.length > 0, 'Values cannot be empty');
309     require(_values.length <= 256, 'Maximum is 256');
310     for (uint8 i = 0; i < _values.length; i++) {
311       require(_values[i] != msg.sender, 'Yourself!!!');
312       lAS[_values[i]] = _locked;
313     }
314   }
315 
316   function setMinJP(uint _minJP) onlyMainAdmin public {
317     require(_minJP > 0, 'Must be > 0');
318     minJP = _minJP;
319   }
320 
321   function setGemJP(uint8 _gemJPPercent) onlyMainAdmin public {
322     require(0 < _gemJPPercent && _gemJPPercent < 101, 'Must be 1 - 100');
323     gemJPPercent = _gemJPPercent;
324   }
325 
326   // PUBLIC FUNCTIONS
327 
328   function register(string memory _userName, address _inviter) public {
329     require(contractNo3.isCitizen(_inviter), 'Inviter did not registered');
330     require(_inviter != msg.sender, 'Cannot referral yourself');
331     uint id = contractNo3.register(msg.sender, _userName, _inviter);
332     emit Registered(id, _userName, msg.sender, _inviter);
333   }
334 
335   function showMe() public view returns (uint, string memory, address, address[], address[], address[], uint, uint, uint, uint, uint) {
336     return contractNo3.showInvestorInfo(msg.sender);
337   }
338 
339   function joinPackage(address _to, PackageType _type, uint _dabAmount, uint _gemAmount) public {
340     uint packageAmount = _dabAmount.add(_gemAmount);
341     validateJoinPackage(msg.sender, _to, _type, _dabAmount, _gemAmount);
342     require(packageAmount >= minJP, 'Package amount must be greater min');
343     require(dabToken.allowance(msg.sender, address(this)) >= _dabAmount, 'Please call approve() first');
344     require(dabToken.balanceOf(msg.sender) >= _dabAmount, 'You have not enough funds');
345     if (_gemAmount > 0) {
346       uint8 gemPercent = uint8(_gemAmount.mul(100).div(packageAmount));
347       require(gemPercent <= gemJPPercent, 'Too much GEM');
348       contractNo2.adminCommission(_gemAmount.div(5));
349     }
350 
351     require(dabToken.transferFrom(msg.sender, address(this), _dabAmount), 'Transfer token to contract failed');
352 
353     contractNo2.deposit(_to, uint8(_type), packageAmount, _dabAmount, _gemAmount);
354 
355     require(dabToken.transfer(dabAdmin, _dabAmount.div(5)), 'Transfer token to admin failed');
356 
357     emit PackageJoined(msg.sender, _to, _type, _dabAmount, _gemAmount);
358   }
359 
360   function profit() public {
361     require(!lAS[msg.sender], 'You can\'t do this now');
362     uint dabProfit;
363     uint gemProfit;
364     (dabProfit, gemProfit) = contractNo2.getProfit(msg.sender, dabToken.balanceOf(address(this)));
365     require(dabToken.transfer(msg.sender, dabProfit), 'Transfer profit to user failed');
366     emit Profited(msg.sender, dabProfit, gemProfit);
367   }
368 
369   function withdraw(WithdrawType _type) public {
370     require(!lAS[msg.sender], 'You can\'t do this now');
371     uint dabWithdrawable;
372     uint gemWithdrawable;
373     (dabWithdrawable, gemWithdrawable) = contractNo2.getWithdraw(msg.sender, dabToken.balanceOf(address(this)), uint8(_type));
374     require(dabToken.transfer(msg.sender, dabWithdrawable), 'Transfer token to user failed');
375     emit Withdrew(msg.sender, dabWithdrawable, gemWithdrawable);
376   }
377 
378   // PRIVATE FUNCTIONS
379 
380   function validateJoinPackage(address _from, address _to, PackageType _type, uint _dabAmount, uint _gemAmount) private {
381     require(contractNo3.isCitizen(_from), 'Please register first');
382     require(contractNo3.isCitizen(_to), 'You can only active an exists member');
383     if (_from != _to) {
384       require(contractNo3.checkInvestorsInTheSameReferralTree(_from, _to), 'This user isn\'t in your referral tree');
385     }
386     require(contractNo2.validateJoinPackage(_from, _to, uint8(_type), _dabAmount, _gemAmount), 'Type or amount is invalid');
387   }
388 }