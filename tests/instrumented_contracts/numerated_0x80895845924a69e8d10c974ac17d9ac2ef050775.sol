1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to relinquish control of the contract.
38    */
39   function renounceOwnership() public onlyOwner {
40     emit OwnershipRenounced(owner);
41     owner = address(0);
42   }
43 
44   /**
45    * @dev Allows the current owner to transfer control of the contract to a newOwner.
46    * @param _newOwner The address to transfer ownership to.
47    */
48   function transferOwnership(address _newOwner) public onlyOwner {
49     _transferOwnership(_newOwner);
50   }
51 
52   /**
53    * @dev Transfers control of the contract to a newOwner.
54    * @param _newOwner The address to transfer ownership to.
55    */
56   function _transferOwnership(address _newOwner) internal {
57     require(_newOwner != address(0));
58     emit OwnershipTransferred(owner, _newOwner);
59     owner = _newOwner;
60   }
61 }
62 
63 
64 /**
65  * @title SafeMath
66  * @dev Math operations with safety checks that throw on error
67  */
68 library SafeMath {
69 
70   /**
71   * @dev Multiplies two numbers, throws on overflow.
72   */
73   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
74     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
75     // benefit is lost if 'b' is also tested.
76     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
77     if (a == 0) {
78       return 0;
79     }
80 
81     c = a * b;
82     assert(c / a == b);
83     return c;
84   }
85 
86   /**
87   * @dev Integer division of two numbers, truncating the quotient.
88   */
89   function div(uint256 a, uint256 b) internal pure returns (uint256) {
90     // assert(b > 0); // Solidity automatically throws when dividing by 0
91     // uint256 c = a / b;
92     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
93     return a / b;
94   }
95 
96   /**
97   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
98   */
99   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
100     assert(b <= a);
101     return a - b;
102   }
103 
104   /**
105   * @dev Adds two numbers, throws on overflow.
106   */
107   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
108     c = a + b;
109     assert(c >= a);
110     return c;
111   }
112 }
113 
114 
115 
116 contract BFEXMini is Ownable {
117 
118   using SafeMath for uint256;
119 
120   // Start and end timestamps
121   uint public startTime;
122   /* uint public endTime; */
123 
124   // BFEX Address where funds are collected
125   address public wallet;
126   address public feeWallet;
127 
128   // Whitelist Enable
129   bool public whitelistEnable;
130 
131   // timeLimitEnable Enable
132   bool public timeLimitEnable;
133 
134   mapping (address => bool) public whitelist;
135   mapping (address => uint256) public bfexAmount; // 18 digits
136   mapping (address => uint256) public weiParticipate;
137   mapping (address => uint256) public balances;
138 
139   // Amount of wei raised
140   uint256 public weiRaised = 0;
141 
142   // BFEX price pair with ETH
143   uint256 public rate;
144   uint256 public rateSecondTier;
145 
146   // Minimum ETH to participate
147   uint256 public minimum;
148 
149   // number of contributor
150   uint256 public contributor;
151 
152   // Maximun number of contributor
153   uint256 public maxContributor;
154 
155   event BFEXParticipate(
156     address sender,
157     uint256 amount
158   );
159 
160   event WhitelistState(
161     address beneficiary,
162     bool whitelistState
163   );
164 
165   event LogWithdrawal(
166     address receiver,
167     uint amount
168   );
169 
170   /* solhint-disable */
171   constructor(address _wallet, address _feeWallet, uint256 _rate, uint256 _rateSecondTier, uint256 _minimum) public {
172 
173     require(_wallet != address(0));
174 
175     wallet = _wallet;
176     feeWallet = _feeWallet;
177     rate = _rate;
178     rateSecondTier = _rateSecondTier;
179     minimum = _minimum;
180     whitelistEnable = true;
181     timeLimitEnable = true;
182     contributor = 0;
183     maxContributor = 10001;
184     startTime = 1528625400; // 06/10/2018 @ 10:10am (UTC)
185   }
186   /* solhint-enable */
187 
188   /**
189    * @dev Fallback function that can be used to participate in token generation event.
190    */
191   function() external payable {
192     getBFEX(msg.sender);
193   }
194 
195   /**
196    * @dev set rate of Token per 1 ETH
197    * @param _rate of Token per 1 ETH
198    */
199   function setRate(uint _rate) public onlyOwner {
200     rate = _rate;
201   }
202 
203   /**
204    * @dev setMinimum amount to participate
205    * @param _minimum minimum amount in wei
206    */
207   function setMinimum(uint256 _minimum) public onlyOwner {
208     minimum = _minimum;
209   }
210 
211   /**
212    * @dev setMinimum amount to participate
213    * @param _max Maximum contributor allowed
214    */
215   function setMaxContributor(uint256 _max) public onlyOwner {
216     maxContributor = _max;
217   }
218 
219   /**
220    * @dev Add single address to whitelist.
221    * @param _beneficiary Address to be added to the whitelist
222    */
223   function addToWhitelist(address _beneficiary) external onlyOwner {
224     whitelist[_beneficiary] = true;
225     emit WhitelistState(_beneficiary, true);
226   }
227 
228   /**
229    * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
230    * @param _beneficiaries Addresses to be added to the whitelist
231    */
232   function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
233     for (uint256 i = 0; i < _beneficiaries.length; i++) {
234       whitelist[_beneficiaries[i]] = true;
235     }
236   }
237 
238   /**
239    * @dev Remove single address from whitelist.
240    * @param _beneficiary Address to be removed from the whitelist
241    */
242   function removeFromWhiteList(address _beneficiary) external onlyOwner {
243     whitelist[_beneficiary] = false;
244     emit WhitelistState(_beneficiary, false);
245   }
246 
247   function isWhitelist(address _beneficiary) public view returns (bool whitelisted) {
248     return whitelist[_beneficiary];
249   }
250 
251   function checkBenefit(address _beneficiary) public view returns (uint256 bfex) {
252     return bfexAmount[_beneficiary];
253   }
254 
255   function checkContribution(address _beneficiary) public view returns (uint256 weiContribute) {
256     return weiParticipate[_beneficiary];
257   }
258   /**
259   * @dev getBfex function
260   * @param _participant Address performing the bfex token participate
261   */
262   function getBFEX(address _participant) public payable {
263 
264     uint256 weiAmount = msg.value;
265 
266     _preApprove(_participant);
267     require(_participant != address(0));
268     require(weiAmount >= minimum);
269 
270     // calculate bfex token _participant will recieve
271     uint256 bfexToken = _getTokenAmount(weiAmount);
272 
273     // update state
274     weiRaised = weiRaised.add(weiAmount);
275     // update ETH balance
276     uint256 raise = weiAmount.div(1000).mul(955);
277     uint256 fee = weiAmount.div(1000).mul(45);
278     // update contributor count
279     contributor += 1;
280 
281     balances[wallet] = balances[wallet].add(raise);
282     balances[feeWallet] = balances[feeWallet].add(fee);
283 
284     bfexAmount[_participant] = bfexAmount[_participant].add(bfexToken);
285     weiParticipate[_participant] = weiParticipate[_participant].add(weiAmount);
286 
287     emit BFEXParticipate(_participant, weiAmount);
288   }
289 
290   /**
291   * @dev calculate token amont
292   * @param _weiAmount wei amont user are participate
293   */
294   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
295     uint256 _rate;
296     if (_weiAmount >= 0.1 ether && _weiAmount < 1 ether ) {
297       _rate = rate;
298     } else if (_weiAmount >= 1 ether ) {
299       _rate = rateSecondTier;
300     }
301     uint256 bfex = _weiAmount.mul(_rate);
302     /* bfex = bfex.div(1 ether); */
303     return bfex;
304   }
305 
306   /**
307   * @dev check if address is on the whitelist
308   * @param _participant address
309   */
310   function _preApprove(address _participant) internal view {
311     require (maxContributor >= contributor);
312     if (timeLimitEnable == true) {
313       require (now >= startTime && now <= startTime + 1 days);
314     }
315     if (whitelistEnable == true) {
316       require(isWhitelist(_participant));
317       return;
318     } else {
319       return;
320     }
321   }
322 
323   /**
324   * @dev disable whitelist state
325   *
326   */
327   function disableWhitelist() public onlyOwner returns (bool whitelistState) {
328     whitelistEnable = false;
329     emit WhitelistState(msg.sender, whitelistEnable);
330     return whitelistEnable;
331   }
332 
333   /**
334   * @dev enable whitelist state
335   *
336   */
337   function enableWhitelist() public onlyOwner returns (bool whitelistState) {
338     whitelistEnable = true;
339     emit WhitelistState(msg.sender, whitelistEnable);
340     return whitelistEnable;
341   }
342 
343   function withdraw(uint _value) public returns (bool success) {
344     require(balances[msg.sender] <= _value);
345 
346     balances[msg.sender] = balances[msg.sender].sub(_value);
347     msg.sender.transfer(_value);
348     emit LogWithdrawal(msg.sender, _value);
349 
350     return true;
351   }
352 
353   function checkBalance(address _account) public view returns (uint256 balance)  {
354     return balances[_account];
355   }
356 }