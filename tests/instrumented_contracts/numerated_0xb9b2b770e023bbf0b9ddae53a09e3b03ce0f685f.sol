1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title SafeMath
20  * @dev Math operations with safety checks that throw on error
21  */
22 library SafeMath {
23 
24   /**
25   * @dev Multiplies two numbers, throws on overflow.
26   */
27   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
28     if (a == 0) {
29       return 0;
30     }
31     c = a * b;
32     assert(c / a == b);
33     return c;
34   }
35 
36   /**
37   * @dev Integer division of two numbers, truncating the quotient.
38   */
39   function div(uint256 a, uint256 b) internal pure returns (uint256) {
40     // assert(b > 0); // Solidity automatically throws when dividing by 0
41     // uint256 c = a / b;
42     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43     return a / b;
44   }
45 
46   /**
47   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
48   */
49   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50     assert(b <= a);
51     return a - b;
52   }
53 
54   /**
55   * @dev Adds two numbers, throws on overflow.
56   */
57   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
58     c = a + b;
59     assert(c >= a);
60     return c;
61   }
62 }
63 
64 
65 
66 /**
67  * @title Basic token
68  * @dev Basic version of StandardToken, with no allowances.
69  */
70 contract BasicToken is ERC20Basic {
71   using SafeMath for uint256;
72 
73   mapping(address => uint256) balances;
74 
75   uint256 totalSupply_;
76 
77   /**
78   * @dev total number of tokens in existence
79   */
80   function totalSupply() public view returns (uint256) {
81     return totalSupply_;
82   }
83 
84   /**
85   * @dev transfer token for a specified address
86   * @param _to The address to transfer to.
87   * @param _value The amount to be transferred.
88   */
89   function transfer(address _to, uint256 _value) public returns (bool) {
90     require(_to != address(0));
91     require(_value <= balances[msg.sender]);
92 
93     balances[msg.sender] = balances[msg.sender].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     emit Transfer(msg.sender, _to, _value);
96     return true;
97   }
98 
99   /**
100   * @dev Gets the balance of the specified address.
101   * @param _owner The address to query the the balance of.
102   * @return An uint256 representing the amount owned by the passed address.
103   */
104   function balanceOf(address _owner) public view returns (uint256) {
105     return balances[_owner];
106   }
107 
108 }
109 // NOTE: BasicToken only has partial ERC20 support
110 contract Ico is BasicToken {
111   address owner;
112   uint256 public teamNum;
113   mapping(address => bool) team;
114 
115   // expose these for ERC20 tools
116   string public constant name = "LUNA";
117   string public constant symbol = "LUNA";
118   uint8 public constant decimals = 18;
119 
120   // Significant digits tokenPrecision
121   uint256 private constant tokenPrecision = 10e17;
122 
123   // Tokens frozen supply
124   uint256 public tokensFrozen = 0;
125 
126   uint256 public tokenValue = 1 * tokenPrecision;
127 
128   // struct representing a dividends snapshot
129   struct DividendSnapshot {
130     uint256 totalSupply;
131     uint256 dividendsIssued;
132     uint256 managementDividends;
133   }
134   // An array of all the DividendSnapshot so far
135   DividendSnapshot[] dividendSnapshots;
136 
137   // Mapping of user to the index of the last dividend that was awarded to zhie
138   mapping(address => uint256) lastDividend;
139 
140   // Management fees share express as 100/%: eg. 20% => 100/20 = 5
141   uint256 public constant managementFees = 10;
142 
143   // Assets under management in USD
144   uint256 public aum = 0;
145 
146   // Amount of tokens in circulation
147   uint256 public totalSupply = 0;
148 
149   // drip percent in 100 / percentage
150   uint256 public dripRate = 50;
151 
152   // current registred change address
153   address public currentSaleAddress;
154 
155   // custom events
156   event Freeze(address indexed from, uint256 value);
157   event Reconcile(address indexed from, uint256 period, uint256 value);
158 
159   /**
160    * Luna constructor
161    * Define Luna details and contribution period
162    */
163   constructor(address[] _team, address[] shareholders, uint256[] shares, uint256 _aum, uint256 _tokensFrozen) public {
164     owner = msg.sender;
165 
166     // reset from old contract
167     aum = _aum;
168     tokensFrozen = _tokensFrozen;
169 
170     uint256 shareholderNum = shareholders.length;
171     for (uint256 i = 0; i < shareholderNum; i++) {
172       balances[shareholders[i]] = shares[i];
173       totalSupply = totalSupply.add(shares[i]);
174       emit Transfer(0x0, shareholders[i], shares[i]);
175     }
176 
177     // initialize the team mapping with true when part of the team
178     teamNum = _team.length;
179     for (i = 0; i < teamNum; i++) {
180       team[_team[i]] = true;
181     }
182 
183     // as a safety measure tempory set the sale address to something else than 0x0
184     currentSaleAddress = owner;
185   }
186 
187   /**
188    * Modifiers
189    */
190   modifier onlyOwner() {
191     require (msg.sender == owner);
192     _;
193   }
194 
195   modifier onlyTeam() {
196     require (team[msg.sender] == true);
197     _;
198   }
199 
200   modifier onlySaleAddress() {
201     require (msg.sender == currentSaleAddress);
202     _;
203   }
204 
205   /**
206    * Internal burn function, only callable by team
207    *
208    * @param _amount is the amount of tokens to burn.
209    */
210   function freeze(uint256 _amount) public onlySaleAddress returns (bool) {
211     reconcileDividend(msg.sender);
212     require(_amount <= balances[msg.sender]);
213 
214     // SafeMath.sub will throw if there is not enough balance.
215     balances[msg.sender] = balances[msg.sender].sub(_amount);
216     totalSupply = totalSupply.sub(_amount);
217     tokensFrozen = tokensFrozen.add(_amount);
218 
219     aum = aum.sub(tokenValue.mul(_amount).div(tokenPrecision));
220 
221     emit Freeze(msg.sender, _amount);
222     emit Transfer(msg.sender, 0x0, _amount);
223     return true;
224   }
225 
226   /**
227    * Calculate the divends for the current period given the AUM profit
228    *
229    * @param totalProfit is the amount of total profit in USD.
230    */
231   function reportProfit(int256 totalProfit, bool shouldDrip, address saleAddress) public onlyTeam returns (bool) {
232     // first we new dividends if this period was profitable
233     if (totalProfit > 0) {
234       // We only care about 50% of this, as the rest is reinvested right away
235       uint256 profit = uint256(totalProfit).mul(tokenPrecision).div(2);
236 
237       // this will throw if there are not enough tokens
238       addNewDividends(profit);
239     }
240 
241     if (shouldDrip) {
242       // then we drip
243       drip(saleAddress);
244     }
245 
246     // adjust AUM
247     if (totalProfit > 0) {
248       aum = aum.add(uint256(totalProfit).mul(tokenPrecision));
249     } else if (totalProfit < 0) {
250       aum = aum.sub(uint256(-totalProfit).mul(tokenPrecision));
251     }
252 
253     // register the sale address
254     currentSaleAddress = saleAddress;
255 
256     return true;
257   }
258 
259 
260   function drip(address saleAddress) internal {
261     uint256 dripTokens = tokensFrozen.div(dripRate);
262 
263     tokensFrozen = tokensFrozen.sub(dripTokens);
264     totalSupply = totalSupply.add(dripTokens);
265     aum = aum.add(tokenValue.mul(dripTokens).div(tokenPrecision));
266 
267     reconcileDividend(saleAddress);
268     balances[saleAddress] = balances[saleAddress].add(dripTokens);
269     emit Transfer(0x0, saleAddress, dripTokens);
270   }
271 
272   /**
273    * Calculate the divends for the current period given the dividend
274    * amounts (USD * tokenPrecision).
275    */
276   function addNewDividends(uint256 profit) internal {
277     uint256 newAum = aum.add(profit); // 18 sig digits
278     tokenValue = newAum.mul(tokenPrecision).div(totalSupply); // 18 sig digits
279     uint256 totalDividends = profit.mul(tokenPrecision).div(tokenValue); // 18 sig digits
280     uint256 managementDividends = totalDividends.div(managementFees); // 17 sig digits
281     uint256 dividendsIssued = totalDividends.sub(managementDividends); // 18 sig digits
282 
283     // make sure we have enough in the frozen fund
284     require(tokensFrozen >= totalDividends);
285 
286     dividendSnapshots.push(DividendSnapshot(totalSupply, dividendsIssued, managementDividends));
287 
288     // add the previous amount of given dividends to the totalSupply
289     totalSupply = totalSupply.add(totalDividends);
290     tokensFrozen = tokensFrozen.sub(totalDividends);
291   }
292 
293   /**
294    * Withdraw all funds and kill fund smart contract
295    */
296   function liquidate() public onlyTeam returns (bool) {
297     selfdestruct(owner);
298   }
299 
300   /**
301    * Manually update AUM, need (for example) when the drip was sold
302    * for anything other than NAV.
303    */
304   function setAUM(uint256 _aum) public onlyTeam returns (bool) {
305     aum = _aum;
306     return true;
307   }
308 
309 
310   // getter to retrieve divident owed
311   function getOwedDividend(address _owner) public view returns (uint256 total, uint256[]) {
312     uint256[] memory noDividends = new uint256[](0);
313     // And the address' current balance
314     uint256 balance = BasicToken.balanceOf(_owner);
315     // retrieve index of last dividend this address received
316     // NOTE: the default return value of a mapping is 0 in this case
317     uint idx = lastDividend[_owner];
318     if (idx == dividendSnapshots.length) return (total, noDividends);
319     if (balance == 0 && team[_owner] != true) return (total, noDividends);
320 
321     uint256[] memory dividends = new uint256[](dividendSnapshots.length - idx - i);
322     uint256 currBalance = balance;
323     for (uint i = idx; i < dividendSnapshots.length; i++) {
324       // We should be able to remove the .mul(tokenPrecision) and .div(tokenPrecision) and apply them once
325       // at the beginning and once at the end, but we need to math it out
326       uint256 dividend = currBalance.mul(tokenPrecision).div(dividendSnapshots[i].totalSupply).mul(dividendSnapshots[i].dividendsIssued).div(tokenPrecision);
327 
328       // Add the management dividends in equal parts if the current address is part of the team
329       if (team[_owner] == true) {
330         dividend = dividend.add(dividendSnapshots[i].managementDividends.div(teamNum));
331       }
332 
333       total = total.add(dividend);
334 
335       dividends[i - idx] = dividend;
336 
337       currBalance = currBalance.add(dividend);
338     }
339 
340     return (total, dividends);
341   }
342 
343   // monkey patches
344   function balanceOf(address _owner) public view returns (uint256) {
345     uint256 owedDividend;
346     (owedDividend,) = getOwedDividend(_owner);
347     return BasicToken.balanceOf(_owner).add(owedDividend);
348   }
349 
350 
351   // Reconcile all outstanding dividends for an address
352   // into its balance.
353   function reconcileDividend(address _owner) internal {
354     uint256 owedDividend;
355     uint256[] memory dividends;
356     (owedDividend, dividends) = getOwedDividend(_owner);
357 
358     for (uint i = 0; i < dividends.length; i++) {
359       if (dividends[i] > 0) {
360         emit Reconcile(_owner, lastDividend[_owner] + i, dividends[i]);
361         emit Transfer(0x0, _owner, dividends[i]);
362       }
363     }
364 
365     if(owedDividend > 0) {
366       balances[_owner] = balances[_owner].add(owedDividend);
367     }
368 
369     // register this user as being owed no further dividends
370     lastDividend[_owner] = dividendSnapshots.length;
371   }
372 
373   function transfer(address _to, uint256 _amount) public returns (bool) {
374     reconcileDividend(msg.sender);
375     reconcileDividend(_to);
376     return BasicToken.transfer(_to, _amount);
377   }
378 
379 }