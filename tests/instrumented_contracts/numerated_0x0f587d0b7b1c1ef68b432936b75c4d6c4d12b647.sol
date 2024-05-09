1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32   function Ownable() {
33     owner = msg.sender;
34   }
35   modifier onlyOwner() {
36     require(msg.sender == owner);
37     _;
38   }
39   function transferOwnership(address newOwner) onlyOwner public {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 contract ERC20Basic {
48   uint256 public totalSupply;
49   function balanceOf(address who) public constant returns (uint256);
50   function transfer(address to, uint256 value) public returns (bool);
51   event Transfer(address indexed from, address indexed to, uint256 value);
52 }
53 
54 contract ERC20 is ERC20Basic {
55   function allowance(address owner, address spender) public constant returns (uint256);
56   function transferFrom(address from, address to, uint256 value) public returns (bool);
57   function approve(address spender, uint256 value) public returns (bool);
58   event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 contract BasicToken is ERC20Basic, Ownable {
62   using SafeMath for uint256;
63 
64   mapping(address => uint256) balances;
65 
66   bool transferAllowed = false;
67 
68   function setTransferAllowed(bool _transferAllowed) public onlyOwner {
69     transferAllowed = _transferAllowed;
70   }
71 
72   /**
73   * @dev transfer token for a specified address
74   * @param _to The address to transfer to.
75   * @param _value The amount to be transferred.
76   */
77   function transfer(address _to, uint256 _value) public returns (bool) {
78     require(_to != address(0));
79     require(_value <= balances[msg.sender]);
80     require(transferAllowed);
81 
82     // SafeMath.sub will throw if there is not enough balance.
83     balances[msg.sender] = balances[msg.sender].sub(_value);
84     balances[_to] = balances[_to].add(_value);
85     Transfer(msg.sender, _to, _value);
86     return true;
87   }
88 
89   /**
90   * @dev Gets the balance of the specified address.
91   * @param _owner The address to query the the balance of.
92   * @return An uint256 representing the amount owned by the passed address.
93   */
94   function balanceOf(address _owner) public constant returns (uint256 balance) {
95     return balances[_owner];
96   }
97 }
98 //StandardToken.sol
99 contract StandardToken is ERC20, BasicToken {
100   using SafeMath for uint256;
101 
102   mapping (address => mapping (address => uint256)) internal allowed;
103 
104 
105   /**
106    * @dev Transfer tokens from one address to another
107    * @param _from address The address which you want to send tokens from
108    * @param _to address The address which you want to transfer to
109    * @param _value uint256 the amount of tokens to be transferred
110    */
111   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
112     require(_to != address(0));
113     require(_value <= balances[_from]);
114     require(_value <= allowed[_from][msg.sender]);
115     require(transferAllowed);
116 
117     balances[_from] = balances[_from].sub(_value);
118     balances[_to] = balances[_to].add(_value);
119     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
120     Transfer(_from, _to, _value);
121     return true;
122   }
123 
124   /**
125    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
126    *
127    * Beware that changing an allowance with this method brings the risk that someone may use both the old
128    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
129    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
130    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131    * @param _spender The address which will spend the funds.
132    * @param _value The amount of tokens to be spent.
133    */
134   function approve(address _spender, uint256 _value) public returns (bool) {
135     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
136     allowed[msg.sender][_spender] = _value;
137     Approval(msg.sender, _spender, _value);
138     return true;
139   }
140 
141   /**
142    * @dev Function to check the amount of tokens that an owner allowed to a spender.
143    * @param _owner address The address which owns the funds.
144    * @param _spender address The address which will spend the funds.
145    * @return A uint256 specifying the amount of tokens still available for the spender.
146    */
147   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
148     return allowed[_owner][_spender];
149   }
150 }
151 
152 contract MatToken is Ownable, StandardToken {
153   string public constant name = "MiniApps Token";
154   string public constant symbol = "MAT";
155   uint   public constant decimals = 18;
156   
157   // token units
158   uint256 public constant MAT_UNIT = 10**uint256(decimals);
159   uint256 constant MILLION_MAT = 10**6 * MAT_UNIT;
160   uint256 constant THOUSAND_MAT = 10**3 * MAT_UNIT;
161 
162   // Token distribution: crowdsale - 50%, partners - 35%, team - 15%, total 20M  
163   uint256 public constant MAT_CROWDSALE_SUPPLY_LIMIT = 10 * MILLION_MAT;
164   uint256 public constant MAT_TEAM_SUPPLY_LIMIT = 7 * MILLION_MAT;
165   uint256 public constant MAT_PARTNERS_SUPPLY_LIMIT = 3 * MILLION_MAT;
166   uint256 public constant MAT_TOTAL_SUPPLY_LIMIT = MAT_CROWDSALE_SUPPLY_LIMIT + MAT_TEAM_SUPPLY_LIMIT + MAT_PARTNERS_SUPPLY_LIMIT;
167 }
168 
169 contract MatBonus is MatToken {
170   uint256 public constant TOTAL_SUPPLY_UPPER_BOUND = 14000 * THOUSAND_MAT;
171   uint256 public constant TOTAL_SUPPLY_BOTTOM_BOUND = 11600 * THOUSAND_MAT;
172 
173   function calcBonus(uint256 tokens) internal returns (uint256){
174     if (totalSupply <= TOTAL_SUPPLY_BOTTOM_BOUND)
175       return tokens.mul(8).div(100);
176     else if (totalSupply > TOTAL_SUPPLY_BOTTOM_BOUND && totalSupply <= TOTAL_SUPPLY_UPPER_BOUND)
177       return tokens.mul(5).div(100);
178     else
179       return 0;
180   }
181 }
182 
183 contract MatBase is Ownable, MatToken, MatBonus {
184  using SafeMath for uint256;
185   
186   uint256 public constant _START_DATE = 1508284800; //  Wednesday, 18-Oct-17 00:00:00 UTC in RFC 2822
187   uint256 public constant _END_DATE = 1513641600; // Tuesday, 19-Dec-17 00:00:00 UTC in RFC 2822
188   uint256 public constant CROWDSALE_PRICE = 100; // 100 MAT per ETH
189   address public constant ICO_ADDRESS = 0x6075a5A0620861cfeF593a51A01aF0fF179168C7;
190   address public constant PARTNERS_WALLET =  0x39467d5B39F1d24BC8479212CEd151ad469B0D7E;
191   address public constant TEAM_WALLET = 0xe1d32147b08b2a7808026D4A94707E321ccc7150;
192 
193   // start and end timestamps where investments are allowed (both inclusive)
194   uint256 public startTime;
195   uint256 public endTime;
196   function setStartTime(uint256 _startTime) onlyOwner
197   {
198     startTime = _startTime;
199   }
200   function setEndTime(uint256 _endTime) onlyOwner
201   {
202     endTime = _endTime;
203   }
204 
205   // address  where funds are collected
206   address public wallet;
207   address public p_wallet;
208   address public t_wallet;
209 
210   // total amount of raised money in wei
211   uint256 public totalCollected;
212   // how many token units a buyer gets per wei
213   uint256 public rate;
214   // @return true if crowdsale event has ended
215   function hasEnded() public constant returns (bool) {
216     return now > endTime;
217   }
218   event Mint(address indexed purchaser, uint256 amount);
219   event Bonus(address indexed purchaser,uint256 amount);
220   function mint(address _to, uint256 _tokens) internal returns (bool) {
221     totalSupply = totalSupply.add(_tokens);
222     require(totalSupply <= whiteListLimit);
223     require(totalSupply <= MAT_TOTAL_SUPPLY_LIMIT);
224 
225     balances[_to] = balances[_to].add(_tokens);
226     Mint(_to, _tokens);
227     Transfer(0x0, _to, _tokens);
228     return true;
229   }
230   // send ether to the fund collection wallet
231   // override to create custom fund forwarding mechanisms
232   function forwardFunds() internal {
233     wallet.transfer(msg.value);
234   }
235 
236   // @return true if the transaction can buy tokens
237   function validPurchase() internal constant returns (bool) {
238     bool withinPeriod = now >= startTime && now <= endTime;
239     bool nonZeroPurchase = msg.value != 0;
240     return withinPeriod && nonZeroPurchase;
241   }
242   /**
243    * event for token purchase logging
244    * @param purchaser who paid for the tokens
245    * @param beneficiary who got the tokens
246    * @param value weis paid for purchase
247    * @param amountTokens amount of tokens purchased
248    */
249   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amountTokens,
250     string referral);
251 
252   // fallback function can be used to buy tokens
253   function () payable {
254     buyTokens(msg.sender);
255   }
256 
257   // low level token purchase function
258   function buyTokens(address beneficiary) public payable {
259     buyTokensReferral(beneficiary, "");
260   }
261 
262   // low level token purchase function
263   function buyTokensReferral(address beneficiary, string referral) public payable {
264     require(msg.value > 0);
265     require(beneficiary != 0x0);
266     require(validPurchase());
267 
268     uint256 weiAmount = msg.value;
269 
270     // calculate token amount to be created
271     uint256 tokens = weiAmount.mul(rate);
272     uint256 bonus = calcBonus(tokens);
273 
274     // update state
275     totalCollected = totalCollected.add(weiAmount);
276 
277     if (!buyTokenWL(tokens)) mint(beneficiary, bonus);
278     mint(beneficiary, tokens);
279     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens, referral);
280     forwardFunds();
281   }
282 
283 //whitelist
284   bool isWhitelistOn;
285   uint256 public whiteListLimit;
286 
287   enum WLS {notlisted,listed,fulfilled}
288   struct FundReservation {
289     WLS status;
290     uint256  reserved;
291   }
292   mapping ( address => FundReservation ) whitelist;
293 
294   function stopWhitelistReservetion() onlyOwner public { 
295     whiteListLimit = MAT_TOTAL_SUPPLY_LIMIT; 
296   }
297 
298   function setWhiteListStatus(bool _isWhitelistOn) onlyOwner public {
299     isWhitelistOn = _isWhitelistOn;
300   }
301 
302   function buyTokenWL(uint256 tokens) internal returns (bool)
303   { 
304     require(isWhitelistOn);
305     require(now >= startTime);
306     if (whitelist[msg.sender].status == WLS.listed) {
307       uint256 reservation = whitelist[msg.sender].reserved;
308       uint256 low = reservation.mul(9).div(10);
309       uint256 upper = reservation.mul(11).div(10);
310       
311       if( low <= msg.value && msg.value <= upper) {
312         whitelist[msg.sender].status == WLS.fulfilled;
313         uint256 bonus = tokens / 10;
314         mint(msg.sender, bonus);
315         Bonus(msg.sender,bonus);
316         return true;
317       }
318     }
319     return false;
320   }
321   event White(address indexed to, uint256 reservation);
322   function regWL(address wlmember, uint256 reservation) onlyOwner public returns (bool status)
323   {
324     require(now < endTime);
325     require(whitelist[wlmember].status == WLS.notlisted);
326     
327     whitelist[wlmember].status = WLS.listed;
328     whitelist[wlmember].reserved = reservation;
329     
330     whiteListLimit = whiteListLimit.sub(reservation.mul(CROWDSALE_PRICE).mul(11).div(10));
331     White(wlmember,reservation);
332     return true;
333   }
334   address public constant PRESALE_CONTRACT = 0x503FE694CE047eCB51952b79eCAB2A907Afe8ACd;
335     /**
336    * @dev presale token conversion 
337    *
338    * @param _to holder of presale tokens
339    * @param _pretokens The amount of presale tokens to be spent.
340    * @param _tokens The amount of presale tokens to be minted on crowdsale, the rest transfer from partners pool
341    */
342   function convert(address _to, uint256 _pretokens, uint256 _tokens) onlyOwner public returns (bool){
343     require(now <= endTime);
344     require(_to != address(0));
345     require(_pretokens >=  _tokens);
346     
347     mint(_to, _tokens); //implicit transfer event
348     
349     uint256 theRest = _pretokens.sub(_tokens);
350     require(balances[PARTNERS_WALLET] >= theRest);
351     
352     if (theRest > 0) {
353       balances[PARTNERS_WALLET] = balances[PARTNERS_WALLET].sub(theRest);
354       balances[_to] = balances[_to].add(theRest);
355       Transfer(PARTNERS_WALLET, _to, theRest); //explicit transfer event
356     }
357     uint256 amount = _pretokens.div(rate);
358     totalCollected = totalCollected.add(amount);
359     return true;
360   }
361   function MatBase() {
362     startTime = _START_DATE;
363     endTime = _END_DATE;
364     wallet = ICO_ADDRESS;
365     rate = CROWDSALE_PRICE;
366     p_wallet = PARTNERS_WALLET;
367     t_wallet = TEAM_WALLET;
368     balances[p_wallet] =  MAT_PARTNERS_SUPPLY_LIMIT;
369     balances[t_wallet] = MAT_TEAM_SUPPLY_LIMIT;
370     totalSupply = MAT_PARTNERS_SUPPLY_LIMIT + MAT_TEAM_SUPPLY_LIMIT;
371     whiteListLimit = MAT_TOTAL_SUPPLY_LIMIT;
372   }
373 }