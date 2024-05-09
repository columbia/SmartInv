1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42   address public owner;
43 
44 
45   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47 
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   function Ownable() public {
53     owner = msg.sender;
54   }
55 
56 
57   /**
58    * @dev Throws if called by any account other than the owner.
59    */
60   modifier onlyOwner() {
61     require(msg.sender == owner);
62     _;
63   }
64 
65 
66   /**
67    * @dev Allows the current owner to transfer control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function transferOwnership(address newOwner) public onlyOwner {
71     require(newOwner != address(0));
72     OwnershipTransferred(owner, newOwner);
73     owner = newOwner;
74   }
75 
76 }
77 
78 /**
79  * @title ERC20Basic
80  * @dev Simpler version of ERC20 interface
81  * @dev see https://github.com/ethereum/EIPs/issues/179
82  */
83 contract ERC20Basic {
84   uint256 public totalSupply;
85   function balanceOf(address who) public view returns (uint256);
86   function transfer(address to, uint256 value) public returns (bool);
87   event Transfer(address indexed from, address indexed to, uint256 value);
88 }
89 
90 contract ALT1Token is Ownable, ERC20Basic {
91   using SafeMath for uint256;
92 
93   string public constant name     = "Altair VR presale token";
94   string public constant symbol   = "ALT1";
95   uint8  public constant decimals = 18;
96 
97   bool public mintingFinished = false;
98 
99   mapping(address => uint256) public balances;
100   address[] public holders;
101 
102   event Mint(address indexed to, uint256 amount);
103   event MintFinished();
104 
105   /**
106   * @dev Function to mint tokens
107   * @param _to The address that will receive the minted tokens.
108   * @param _amount The amount of tokens to mint.
109   * @return A boolean that indicates if the operation was successful.
110   */
111   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
112     totalSupply = totalSupply.add(_amount);
113     if (balances[_to] == 0) { 
114       holders.push(_to);
115     }
116     balances[_to] = balances[_to].add(_amount);
117 
118     Mint(_to, _amount);
119     Transfer(address(0), _to, _amount);
120     return true;
121   }
122 
123   /**
124   * @dev Function to stop minting new tokens.
125   * @return True if the operation was successful.
126   */
127   function finishMinting() onlyOwner canMint public returns (bool) {
128     mintingFinished = true;
129     MintFinished();
130     return true;
131   }
132 
133   /**
134   * @dev Current token is not transferred.
135   * After start official token sale ALT, you can exchange your ALT1 to ALT
136   */
137   function transfer(address, uint256) public returns (bool) {
138     revert();
139     return false;
140   }
141 
142   /**
143   * @dev Gets the balance of the specified address.
144   * @param _owner The address to query the the balance of.
145   * @return An uint256 representing the amount owned by the passed address.
146   */
147   function balanceOf(address _owner) public view returns (uint256 balance) {
148     return balances[_owner];
149   }
150 
151   modifier canMint() {
152     require(!mintingFinished);
153     _;
154   }
155 }
156 
157 /**
158  * @title Crowdsale ALT1 presale token
159  */
160 
161 contract Crowdsale is Ownable {
162   using SafeMath for uint256;
163 
164   uint256   public constant rate = 10000;                  // How many token units a buyer gets per wei
165   uint256   public constant cap = 80000000 ether;          // Maximum amount of funds
166 
167   bool      public isFinalized = false;
168 
169   uint256   public endTime = 1522540800;                  // End timestamps where investments are allowed
170                                                           // 01-Apr-18 00:00:00 UTC
171   uint256 public bonusDecreaseDay = 1517529600;           // First day with lower bonus 02-Feb-18 00:00:00 UTC
172 
173   ALT1Token     public token;                                 // ALT1 token itself
174   ALT1Token     public oldToken;                              // Old ALT1 token for balance converting
175   address       public wallet;                                // Wallet of funds
176   uint256       public weiRaised;                             // Amount of raised money in wei
177 
178   mapping(address => uint) public oldHolders;
179 
180   uint256 public constant bonusByAmount = 70;
181   uint256 public constant amountForBonus = 50 ether;
182 
183   mapping(uint => uint) public bonusesByDates;
184   uint[] public bonusesDates;
185 
186   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
187   event Finalized();
188 
189   function Crowdsale (ALT1Token _ALT1, ALT1Token _OldALT1, address _wallet) public {
190     assert(address(_ALT1) != address(0));
191     assert(address(_OldALT1) != address(0));
192     assert(_wallet != address(0));
193     assert(endTime > now);
194     assert(rate > 0);
195     assert(cap > 0);
196 
197     token = _ALT1;
198     oldToken = _OldALT1;
199 
200     bonusesDates = [
201       bonusDecreaseDay,   // 02-Feb-18 00:00:00 UTC
202       1517788800,         // 05-Feb-18 00:00:00 UTC
203       1518048000,         // 08-Feb-18 00:00:00 UTC
204       1518307200,         // 11-Feb-18 00:00:00 UTC
205       1518566400,         // 14-Feb-18 00:00:00 UTC
206       1518825600,         // 17-Feb-18 00:00:00 UTC
207       1519084800,         // 20-Feb-18 00:00:00 UTC
208       1519344000,         // 23-Feb-18 00:00:00 UTC
209       1519603200          // 26-Feb-18 00:00:00 UTC
210     ];
211 
212     bonusesByDates[bonusesDates[0]] = 70;
213     bonusesByDates[bonusesDates[1]] = 65;
214     bonusesByDates[bonusesDates[2]] = 60;
215     bonusesByDates[bonusesDates[3]] = 55;
216     bonusesByDates[bonusesDates[4]] = 50;
217     bonusesByDates[bonusesDates[5]] = 45;
218     bonusesByDates[bonusesDates[6]] = 40;
219     bonusesByDates[bonusesDates[7]] = 35;
220     bonusesByDates[bonusesDates[8]] = 30;
221 
222   
223     wallet = _wallet;
224   }
225 
226   function () public payable {
227     buyTokens(msg.sender);
228   }
229 
230   function buyTokens(address beneficiary) public payable {
231     require(beneficiary != address(0));
232     require(validPurchase());
233 
234     uint256 weiAmount = msg.value;
235     uint256 tokens = tokensForWei(weiAmount);
236     
237     weiRaised = weiRaised.add(weiAmount);
238 
239     token.mint(beneficiary, tokens);
240     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
241 
242     forwardFunds();
243   }
244 
245   function getBonus(uint256 _tokens) public view returns (uint256) {
246     if (_tokens.div(rate) >= amountForBonus && now <= bonusesDates[8]) return _tokens.mul(70).div(100);
247     if (now < bonusesDates[0]) return getBonusByDate(0, _tokens);
248     if (now < bonusesDates[1]) return getBonusByDate(1, _tokens);
249     if (now < bonusesDates[2]) return getBonusByDate(2, _tokens);
250     if (now < bonusesDates[3]) return getBonusByDate(3, _tokens);
251     if (now < bonusesDates[4]) return getBonusByDate(4, _tokens);
252     if (now < bonusesDates[5]) return getBonusByDate(5, _tokens);
253     if (now < bonusesDates[6]) return getBonusByDate(6, _tokens);
254     if (now < bonusesDates[7]) return getBonusByDate(7, _tokens);
255     if (now < bonusesDates[8]) return getBonusByDate(8, _tokens);
256     return _tokens.mul(25).div(100);
257   }
258 
259    function getBonusByDate(uint256 _number, uint256 _tokens) public view returns (uint256 bonus) {
260     bonus = _tokens.mul(bonusesByDates[bonusesDates[_number]]).div(100);
261    }
262 
263   function convertOldToken(address beneficiary) public oldTokenHolders(beneficiary) oldTokenFinalized {
264     uint amount = oldToken.balanceOf(beneficiary);
265     oldHolders[beneficiary] = amount;
266     weiRaised = weiRaised.add(amount.div(17000));
267     token.mint(beneficiary, amount);
268   }
269 
270   function convertAllOldTokens(uint256 length, uint256 start) public oldTokenFinalized {
271     for (uint i = start; i < length; i++) {
272       if (oldHolders[oldToken.holders(i)] == 0) {
273         convertOldToken(oldToken.holders(i));
274       }
275     }
276   }
277 
278   /**
279    * @dev Calls the contract's finalization function.
280    */
281   function finalize() onlyOwner public {
282     require(!isFinalized);
283 
284     finalization();
285     Finalized();
286 
287     isFinalized = true;
288   }
289 
290   // send ether to the fund collection wallet
291   // override to create custom fund forwarding mechanisms
292   function forwardFunds() internal {
293     wallet.transfer(msg.value);
294   }
295 
296   // @return true if the transaction can buy tokens
297   function validPurchase() internal view returns (bool) {
298     bool tokenMintingFinished = token.mintingFinished();
299     bool withinCap = token.totalSupply().add(tokensForWei(msg.value)) <= cap;
300     bool withinPeriod = now <= endTime;
301     bool nonZeroPurchase = msg.value != 0;
302     bool moreThanMinimumPayment = msg.value >= 0.05 ether;
303 
304     return !tokenMintingFinished && withinCap && withinPeriod && nonZeroPurchase && moreThanMinimumPayment;
305   }
306 
307   function tokensForWei(uint weiAmount) public view returns (uint tokens) {
308     tokens = weiAmount.mul(rate);
309     tokens = tokens.add(getBonus(tokens));
310   }
311 
312   function finalization() internal {
313     token.finishMinting();
314     endTime = now;
315   }
316 
317   // @return true if crowdsale event has ended
318   function hasEnded() public view returns (bool) {
319     return now > endTime;
320   }
321 
322 
323   /**
324    * Throws if called by not an ALT0 holder or second time call for same ALT0 holder
325    */
326   modifier oldTokenHolders(address beneficiary) {
327     require(oldToken.balanceOf(beneficiary) > 0);
328     require(oldHolders[beneficiary] == 0);
329     _;
330   }
331 
332   modifier oldTokenFinalized() {
333     require(oldToken.mintingFinished());
334     _;
335   }
336 
337 }