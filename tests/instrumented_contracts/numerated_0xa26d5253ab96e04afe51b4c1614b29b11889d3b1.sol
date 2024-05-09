1 pragma solidity ^0.4.17;
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
37  * @title ERC20Basic
38  * @dev Simpler version of ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/179
40  */
41 contract ERC20Basic {
42   uint256 public totalSupply;
43   function balanceOf(address who) public view returns (uint256);
44   function transfer(address to, uint256 value) public returns (bool);
45   event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 
49 /**
50  * @title Basic token
51  * @dev Basic version of StandardToken, with no allowances.
52  */
53 contract BasicToken is ERC20Basic {
54   using SafeMath for uint256;
55 
56   mapping(address => uint256) balances;
57 
58   /**
59   * @dev transfer token for a specified address
60   * @param _to The address to transfer to.
61   * @param _value The amount to be transferred.
62   */
63   function transfer(address _to, uint256 _value) public returns (bool) {
64     require(_to != address(0));
65     require(_value <= balances[msg.sender]);
66 
67     // SafeMath.sub will throw if there is not enough balance.
68     balances[msg.sender] = balances[msg.sender].sub(_value);
69     balances[_to] = balances[_to].add(_value);
70     Transfer(msg.sender, _to, _value);
71     return true;
72   }
73 
74   /**
75   * @dev Gets the balance of the specified address.
76   * @param _owner The address to query the the balance of.
77   * @return An uint256 representing the amount owned by the passed address.
78   */
79   function balanceOf(address _owner) public view returns (uint256 balance) {
80     return balances[_owner];
81   }
82 
83 }
84 
85 
86 
87 
88 // NOTE: BasicToken only has partial ERC20 support
89 contract Ico is BasicToken {
90   address owner;
91   uint256 public teamNum;
92   mapping(address => bool) team;
93 
94   // expose these for ERC20 tools
95   string public constant name = "LUNA";
96   string public constant symbol = "LUNA";
97   uint8 public constant decimals = 18;
98 
99   // Significant digits tokenPrecision
100   uint256 private constant tokenPrecision = 10e17;
101 
102   // TODO: set this final, this equates to an amount
103   // in dollars.
104   uint256 public constant hardCap = 32000 * tokenPrecision;
105 
106   // Tokens frozen supply
107   uint256 public tokensFrozen = 0;
108 
109   uint256 public tokenValue = 1 * tokenPrecision;
110 
111   // struct representing a dividends snapshot
112   struct DividendSnapshot {
113     uint256 totalSupply;
114     uint256 dividendsIssued;
115     uint256 managementDividends;
116   }
117   // An array of all the DividendSnapshot so far
118   DividendSnapshot[] dividendSnapshots;
119 
120   // Mapping of user to the index of the last dividend that was awarded to zhie
121   mapping(address => uint256) lastDividend;
122 
123   // Management fees share express as 100/%: eg. 20% => 100/20 = 5
124   uint256 public constant managementFees = 10;
125 
126   // Assets under management in USD
127   uint256 public aum = 0;
128 
129   // number of tokens investors will receive per eth invested
130   uint256 public tokensPerEth;
131 
132   // Ico start/end timestamps, between which (inclusively) investments are accepted
133   uint public icoStart;
134   uint public icoEnd;
135 
136   // drip percent in 100 / percentage
137   uint256 public dripRate = 50;
138 
139   // current registred change address
140   address public currentSaleAddress;
141 
142   // custom events
143   event Freeze(address indexed from, uint256 value);
144   event Participate(address indexed from, uint256 value);
145   event Reconcile(address indexed from, uint256 period, uint256 value);
146 
147   /**
148    * ICO constructor
149    * Define ICO details and contribution period
150    */
151   function Ico(uint256 _icoStart, uint256 _icoEnd, address[] _team, uint256 _tokensPerEth) public {
152     // require (_icoStart >= now);
153     require (_icoEnd >= _icoStart);
154     require (_tokensPerEth > 0);
155 
156     owner = msg.sender;
157 
158     icoStart = _icoStart;
159     icoEnd = _icoEnd;
160     tokensPerEth = _tokensPerEth;
161 
162     // initialize the team mapping with true when part of the team
163     teamNum = _team.length;
164     for (uint256 i = 0; i < teamNum; i++) {
165       team[_team[i]] = true;
166     }
167 
168     // as a safety measure tempory set the sale address to something else than 0x0
169     currentSaleAddress = owner;
170   }
171 
172   /**
173    * Modifiers
174    */
175   modifier onlyOwner() {
176     require (msg.sender == owner);
177     _;
178   }
179 
180   modifier onlyTeam() {
181     require (team[msg.sender] == true);
182     _;
183   }
184 
185   modifier onlySaleAddress() {
186     require (msg.sender == currentSaleAddress);
187     _;
188   }
189 
190   /**
191    *
192    * Function allowing investors to participate in the ICO.
193    * Specifying the beneficiary will change who will receive the tokens.
194    * Fund tokens will be distributed based on amount of ETH sent by investor, and calculated
195    * using tokensPerEth value.
196    */
197   function participate(address beneficiary) public payable {
198     require (beneficiary != address(0));
199     require (now >= icoStart && now <= icoEnd);
200     require (msg.value > 0);
201 
202     uint256 ethAmount = msg.value;
203     uint256 numTokens = ethAmount.mul(tokensPerEth);
204 
205     require(totalSupply.add(numTokens) <= hardCap);
206 
207     balances[beneficiary] = balances[beneficiary].add(numTokens);
208     totalSupply = totalSupply.add(numTokens);
209     tokensFrozen = totalSupply * 2;
210     aum = totalSupply;
211 
212     owner.transfer(ethAmount);
213     // Our own custom event to monitor ICO participation
214     Participate(beneficiary, numTokens);
215     // Let ERC20 tools know of token hodlers
216     Transfer(0x0, beneficiary, numTokens);
217   }
218 
219   /**
220    *
221    * We fallback to the partcipate function
222    */
223   function () external payable {
224      participate(msg.sender);
225   }
226 
227   /**
228    * Internal burn function, only callable by team
229    *
230    * @param _amount is the amount of tokens to burn.
231    */
232   function freeze(uint256 _amount) public onlySaleAddress returns (bool) {
233     reconcileDividend(msg.sender);
234     require(_amount <= balances[msg.sender]);
235 
236     // SafeMath.sub will throw if there is not enough balance.
237     balances[msg.sender] = balances[msg.sender].sub(_amount);
238     totalSupply = totalSupply.sub(_amount);
239     tokensFrozen = tokensFrozen.add(_amount);
240 
241     aum = aum.sub(tokenValue.mul(_amount).div(tokenPrecision));
242 
243     Freeze(msg.sender, _amount);
244     Transfer(msg.sender, 0x0, _amount);
245     return true;
246   }
247 
248   /**
249    * Calculate the divends for the current period given the AUM profit
250    *
251    * @param totalProfit is the amount of total profit in USD.
252    */
253   function reportProfit(int256 totalProfit, address saleAddress) public onlyTeam returns (bool) {
254     // first we new dividends if this period was profitable
255     if (totalProfit > 0) {
256       // We only care about 50% of this, as the rest is reinvested right away
257       uint256 profit = uint256(totalProfit).mul(tokenPrecision).div(2);
258 
259       // this will throw if there are not enough tokens
260       addNewDividends(profit);
261     }
262 
263     // then we drip
264     drip(saleAddress);
265 
266     // adjust AUM
267     aum = aum.add(uint256(totalProfit).mul(tokenPrecision));
268 
269     // register the sale address
270     currentSaleAddress = saleAddress;
271 
272     return true;
273   }
274 
275 
276   function drip(address saleAddress) internal {
277     uint256 dripTokens = tokensFrozen.div(dripRate);
278 
279     tokensFrozen = tokensFrozen.sub(dripTokens);
280     totalSupply = totalSupply.add(dripTokens);
281     aum = aum.add(tokenValue.mul(dripTokens).div(tokenPrecision));
282 
283     reconcileDividend(saleAddress);
284     balances[saleAddress] = balances[saleAddress].add(dripTokens);
285     Transfer(0x0, saleAddress, dripTokens);
286   }
287 
288   /**
289    * Calculate the divends for the current period given the dividend
290    * amounts (USD * tokenPrecision).
291    */
292   function addNewDividends(uint256 profit) internal {
293     uint256 newAum = aum.add(profit); // 18 sig digits
294     tokenValue = newAum.mul(tokenPrecision).div(totalSupply); // 18 sig digits
295     uint256 totalDividends = profit.mul(tokenPrecision).div(tokenValue); // 18 sig digits
296     uint256 managementDividends = totalDividends.div(managementFees); // 17 sig digits
297     uint256 dividendsIssued = totalDividends.sub(managementDividends); // 18 sig digits
298 
299     // make sure we have enough in the frozen fund
300     require(tokensFrozen >= totalDividends);
301 
302     dividendSnapshots.push(DividendSnapshot(totalSupply, dividendsIssued, managementDividends));
303 
304     // add the previous amount of given dividends to the totalSupply
305     totalSupply = totalSupply.add(totalDividends);
306     tokensFrozen = tokensFrozen.sub(totalDividends);
307   }
308 
309   /**
310    * Withdraw all funds and kill fund smart contract
311    */
312   function liquidate() public onlyTeam returns (bool) {
313     selfdestruct(owner);
314   }
315 
316 
317   // getter to retrieve divident owed
318   function getOwedDividend(address _owner) public view returns (uint256 total, uint256[]) {
319     uint256[] memory noDividends = new uint256[](0);
320     // And the address' current balance
321     uint256 balance = BasicToken.balanceOf(_owner);
322     // retrieve index of last dividend this address received
323     // NOTE: the default return value of a mapping is 0 in this case
324     uint idx = lastDividend[_owner];
325     if (idx == dividendSnapshots.length) return (total, noDividends);
326     if (balance == 0 && team[_owner] != true) return (total, noDividends);
327 
328     uint256[] memory dividends = new uint256[](dividendSnapshots.length - idx - i);
329     uint256 currBalance = balance;
330     for (uint i = idx; i < dividendSnapshots.length; i++) {
331       // We should be able to remove the .mul(tokenPrecision) and .div(tokenPrecision) and apply them once
332       // at the beginning and once at the end, but we need to math it out
333       uint256 dividend = currBalance.mul(tokenPrecision).div(dividendSnapshots[i].totalSupply).mul(dividendSnapshots[i].dividendsIssued).div(tokenPrecision);
334 
335       // Add the management dividends in equal parts if the current address is part of the team
336       if (team[_owner] == true) {
337         dividend = dividend.add(dividendSnapshots[i].managementDividends.div(teamNum));
338       }
339 
340       total = total.add(dividend);
341 
342       dividends[i - idx] = dividend;
343 
344       currBalance = currBalance.add(dividend);
345     }
346 
347     return (total, dividends);
348   }
349 
350   // monkey patches
351   function balanceOf(address _owner) public view returns (uint256) {
352     var (owedDividend, /* dividends */) = getOwedDividend(_owner);
353     return BasicToken.balanceOf(_owner).add(owedDividend);
354   }
355 
356 
357   // Reconcile all outstanding dividends for an address
358   // into its balance.
359   function reconcileDividend(address _owner) internal {
360     var (owedDividend, dividends) = getOwedDividend(_owner);
361 
362     for (uint i = 0; i < dividends.length; i++) {
363       if (dividends[i] > 0) {
364         Reconcile(_owner, lastDividend[_owner] + i, dividends[i]);
365         Transfer(0x0, _owner, dividends[i]);
366       }
367     }
368 
369     if(owedDividend > 0) {
370       balances[_owner] = balances[_owner].add(owedDividend);
371     }
372 
373     // register this user as being owed no further dividends
374     lastDividend[_owner] = dividendSnapshots.length;
375   }
376 
377   function transfer(address _to, uint256 _amount) public returns (bool) {
378     reconcileDividend(msg.sender);
379     reconcileDividend(_to);
380     return BasicToken.transfer(_to, _amount);
381   }
382 
383 }