1 pragma solidity ^0.4.13;
2 
3 contract AbstractToken {
4 
5     function mint(address _to, uint256 _amount) public returns (bool);
6     function transferOwnership(address newOwner) public;
7     function finishMinting() public returns (bool);
8 
9 }
10 
11 library SafeMath {
12   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
13     uint256 c = a * b;
14     require(a == 0 || c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal constant returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
26     require(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal constant returns (uint256) {
31     uint256 c = a + b;
32     require(c >= a);
33     return c;
34   }
35 
36   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
37     return a >= b ? a : b;
38   }
39 
40   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
41     return a < b ? a : b;
42   }
43 
44   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a >= b ? a : b;
46   }
47 
48   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
49     return a < b ? a : b;
50   }
51 
52 }
53 
54 contract Ownable {
55   address public owner;
56 
57 
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   function Ownable() {
65     owner = msg.sender;
66   }
67 
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address newOwner) onlyOwner public {
83     require(newOwner != address(0));
84     OwnershipTransferred(owner, newOwner);
85     owner = newOwner;
86   }
87 
88 }
89 
90 contract Destructible is Ownable {
91 
92   function Destructible() payable { } 
93 
94   /**
95    * @dev Transfers the current balance to the owner and terminates the contract. 
96    */
97   function destroy() public onlyOwner {
98     selfdestruct(owner);
99   }
100 
101   function destroyAndSend(address _recipient) public onlyOwner {
102     selfdestruct(_recipient);
103   }
104 }
105 
106 contract MinimumValueTransfer is Ownable {
107 
108   uint256 internal minimumWeiRequired;
109 
110   /**
111    * @dev modifier to allow actions only when the minimum wei is received
112    */
113   modifier minimumWeiMet() {
114     require(msg.value >= minimumWeiRequired);
115     _;
116   }
117 
118   /**
119    * @dev Allows the owner to update the Minimum required Wei
120    */
121   function updateMinimumWeiRequired(uint256 minimunTransferInWei) public onlyOwner {
122     minimumWeiRequired = minimunTransferInWei;
123   }
124 
125 
126   /**
127    * @dev Shows the minimum required Wei in the Smart contract
128    */
129   function minimumTransferInWei() public constant returns(uint256) {
130     return minimumWeiRequired;
131   }
132 
133 }
134 
135 contract Crowdsale is MinimumValueTransfer {
136   using SafeMath for uint256;
137 
138   // The token being sold
139   AbstractToken public token;
140 
141   // start and end time where investments are allowed (both inclusive)
142   uint256 public startTime;
143   uint256 public endTime;
144 
145   // address where funds are collected
146   address public wallet;
147 
148   // how many token units a buyer gets per wei
149   uint256 public rate;
150 
151   // amount of raised money in wei
152   uint256 public weiRaised;
153 
154   /**
155    * event for token purchase logging
156    * @param purchaser who paid for the tokens
157    * @param beneficiary who got the tokens
158    * @param value weis paid for purchase
159    * @param amount amount of tokens purchased
160    */
161   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
162 
163 
164   function Crowdsale(address _tokenAddress, uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
165     require(_endTime >= _startTime);
166     require(_rate > 0);
167     require(_wallet != 0x0);
168     require(_tokenAddress != 0x0);
169 
170     // Create and instance pointer to the already deployed Token
171     token = createTokenContract(_tokenAddress);
172 
173     // Set the timelines, exchange rate & wallet to store the received ETH
174     startTime = _startTime;
175     endTime = _endTime;
176     rate = _rate;
177     wallet = _wallet;
178   }
179 
180   // creates the token to be sold. 
181   // override this method to have crowdsale of a specific mintable token.
182   function createTokenContract(address _tokenAddress) internal returns (AbstractToken) {
183     return AbstractToken(_tokenAddress);
184   }
185 
186   // fallback function can be used to buy tokens
187   function () payable {
188     buyTokens(msg.sender);
189   }
190 
191   // low level token purchase function
192   function buyTokens(address beneficiary) payable {
193     require(beneficiary != 0x0);
194     require(validPurchase());
195 
196     uint256 weiAmount = msg.value;
197 
198     // calculate token amount to be created
199     uint256 tokens = weiAmount.mul(rate);
200 
201     // update state
202     weiRaised = weiRaised.add(weiAmount);
203 
204     token.mint(beneficiary, tokens);
205     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
206 
207     forwardFunds();
208   }
209 
210   // send ether to the fund collection wallet
211   // override to create custom fund forwarding mechanisms
212   function forwardFunds() internal {
213     wallet.transfer(msg.value);
214   }
215 
216   // @return true if the transaction can buy tokens
217   function validPurchase() minimumWeiMet internal constant returns (bool) {
218     uint256 current = now;
219     bool withinPeriod = current >= startTime && current <= endTime;
220     bool nonZeroPurchase = msg.value != 0;
221     return withinPeriod && nonZeroPurchase && !hasEnded();
222   }
223 
224   // @return true if crowdsale event has ended
225   function hasEnded() public constant returns (bool) {
226     return now > endTime;
227   }
228 
229   // Allows the Owner to run any emergency updates on the time line
230   function updateCrowdsaleTimeline(uint256 newStartTime, uint256 newEndTime) onlyOwner external {
231     require (newStartTime > 0 && newEndTime > newStartTime);
232     startTime = newStartTime;
233     endTime = newEndTime;
234   }
235 
236   // Gets the Human readable progress for the current crowsale timeline in %
237   function crowdsaleProgress() external constant returns(uint256){
238     return now > endTime ? 100: now.sub(startTime).mul(100).div(endTime.sub(startTime));
239   }
240 
241   // Transfers the Token ownership
242   function transferTokenOwnership(address newOwner) public onlyOwner {
243     token.transferOwnership(newOwner);
244   }
245 
246 
247 }
248 
249 contract CappedCrowdsale is Crowdsale {
250   using SafeMath for uint256;
251 
252   uint256 public cap;
253 
254   function CappedCrowdsale(uint256 _cap) {
255     require(_cap > 0);
256     cap = _cap;
257   }
258 
259   // overriding Crowdsale#validPurchase to add extra cap logic
260   // @return true if investors can buy at the moment
261   function validPurchase() internal constant returns (bool) {
262     bool withinCap = weiRaised.add(msg.value) <= cap;
263     return super.validPurchase() && withinCap;
264   }
265 
266   // overriding Crowdsale#hasEnded to add cap logic
267   // @return true if crowdsale event has ended
268   function hasEnded() public constant returns (bool) {
269     bool capReached = weiRaised >= cap;
270     return super.hasEnded() || capReached;
271   }
272 
273 }
274 
275 contract Pausable is Ownable {
276   event Pause();
277   event Unpause();
278 
279   bool public paused = false;
280 
281 
282   /**
283    * @dev modifier to allow actions only when the contract IS paused
284    */
285   modifier whenNotPaused() {
286     require(!paused);
287     _;
288   }
289 
290   /**
291    * @dev modifier to allow actions only when the contract IS NOT paused
292    */
293   modifier whenPaused {
294     require(paused);
295     _;
296   }
297 
298   /**
299    * @dev called by the owner to pause, triggers stopped state
300    */
301   function pause() public onlyOwner whenNotPaused returns (bool) {
302     paused = true;
303     Pause();
304     return true;
305   }
306 
307   /**
308    * @dev called by the owner to unpause, returns to normal state
309    */
310   function unpause() public onlyOwner whenPaused returns (bool) {
311     paused = false;
312     Unpause();
313     return true;
314   }
315 }
316 
317 contract AlloyPresale is Ownable, Destructible, Pausable, CappedCrowdsale {
318 
319     using SafeMath for uint256;
320 
321     function AlloyPresale(address _tokenAddress, uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet, uint256 _cap) CappedCrowdsale(_cap) Crowdsale(_tokenAddress, _startTime, _endTime, _rate, _wallet) {
322     }
323 
324     /**
325      * Overrides the base function
326      */
327     function hasEnded() public constant returns (bool) {
328         return paused || super.hasEnded();
329     }
330 
331 }