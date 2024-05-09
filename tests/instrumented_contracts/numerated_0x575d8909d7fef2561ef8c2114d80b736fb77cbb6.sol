1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25     if (a == 0) {
26       return 0;
27     }
28     uint256 c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   /**
34   * @dev Integer division of two numbers, truncating the quotient.
35   */
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return c;
41   }
42 
43   /**
44   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45   */
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   /**
52   * @dev Adds two numbers, throws on overflow.
53   */
54   function add(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 /**
62  * @title Basic token
63  * @dev Basic version of StandardToken, with no allowances.
64  */
65 contract BasicToken is ERC20Basic {
66   using SafeMath for uint256;
67 
68   mapping(address => uint256) balances;
69 
70   /**
71   * @dev transfer token for a specified address
72   * @param _to The address to transfer to.
73   * @param _value The amount to be transferred.
74   */
75   function transfer(address _to, uint256 _value) public returns (bool) {
76     require(_to != address(0));
77     require(_value <= balances[msg.sender]);
78 
79     // SafeMath.sub will throw if there is not enough balance.
80     balances[msg.sender] = balances[msg.sender].sub(_value);
81     balances[_to] = balances[_to].add(_value);
82     Transfer(msg.sender, _to, _value);
83     return true;
84   }
85 
86   /**
87   * @dev Gets the balance of the specified address.
88   * @param _owner The address to query the the balance of.
89   * @return An uint256 representing the amount owned by the passed address.
90   */
91   function balanceOf(address _owner) public view returns (uint256 balance) {
92     return balances[_owner];
93   }
94 
95 }
96 
97 /**
98  * @title ERC20 interface
99  * @dev see https://github.com/ethereum/EIPs/issues/20
100  */
101 contract ERC20 is ERC20Basic {
102   function allowance(address owner, address spender) public view returns (uint256);
103   function transferFrom(address from, address to, uint256 value) public returns (bool);
104   function approve(address spender, uint256 value) public returns (bool);
105   event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 /**
109  * @title Standard ERC20 token
110  *
111  * @dev Implementation of the basic standard token.
112  * @dev https://github.com/ethereum/EIPs/issues/20
113  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
114  */
115 contract StandardToken is ERC20, BasicToken {
116 
117   mapping (address => mapping (address => uint256)) internal allowed;
118 
119 
120   /**
121    * @dev Transfer tokens from one address to another
122    * @param _from address The address which you want to send tokens from
123    * @param _to address The address which you want to transfer to
124    * @param _value uint256 the amount of tokens to be transferred
125    */
126   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
127     require(_to != address(0));
128     require(_value <= balances[_from]);
129     require(_value <= allowed[_from][msg.sender]);
130 
131     balances[_from] = balances[_from].sub(_value);
132     balances[_to] = balances[_to].add(_value);
133     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
134     Transfer(_from, _to, _value);
135     return true;
136   }
137 
138   /**
139    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
140    *
141    * Beware that changing an allowance with this method brings the risk that someone may use both the old
142    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
143    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
144    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145    * @param _spender The address which will spend the funds.
146    * @param _value The amount of tokens to be spent.
147    */
148   function approve(address _spender, uint256 _value) public returns (bool) {
149     allowed[msg.sender][_spender] = _value;
150     Approval(msg.sender, _spender, _value);
151     return true;
152   }
153 
154   /**
155    * @dev Function to check the amount of tokens that an owner allowed to a spender.
156    * @param _owner address The address which owns the funds.
157    * @param _spender address The address which will spend the funds.
158    * @return A uint256 specifying the amount of tokens still available for the spender.
159    */
160   function allowance(address _owner, address _spender) public view returns (uint256) {
161     return allowed[_owner][_spender];
162   }
163 
164   /**
165    * @dev Increase the amount of tokens that an owner allowed to a spender.
166    *
167    * approve should be called when allowed[_spender] == 0. To increment
168    * allowed value is better to use this function to avoid 2 calls (and wait until
169    * the first transaction is mined)
170    * From MonolithDAO Token.sol
171    * @param _spender The address which will spend the funds.
172    * @param _addedValue The amount of tokens to increase the allowance by.
173    */
174   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
175     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
176     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
177     return true;
178   }
179 
180   /**
181    * @dev Decrease the amount of tokens that an owner allowed to a spender.
182    *
183    * approve should be called when allowed[_spender] == 0. To decrement
184    * allowed value is better to use this function to avoid 2 calls (and wait until
185    * the first transaction is mined)
186    * From MonolithDAO Token.sol
187    * @param _spender The address which will spend the funds.
188    * @param _subtractedValue The amount of tokens to decrease the allowance by.
189    */
190   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
191     uint oldValue = allowed[msg.sender][_spender];
192     if (_subtractedValue > oldValue) {
193       allowed[msg.sender][_spender] = 0;
194     } else {
195       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
196     }
197     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
198     return true;
199   }
200 
201 }
202 
203 contract MigrationAgent {
204     function migrateFrom(address _from, uint256 _value);
205 }
206 
207 contract ABChainRTBtoken is StandardToken {
208   using SafeMath for uint256;
209 
210   string public name = "AB-CHAIN RTB token";
211   string public symbol = "RTB";
212   uint256 public decimals = 18;
213   uint256 public INITIAL_SUPPLY = 100000000 * 1 ether;
214   uint256 public burnedCount = 0;
215   uint256 public burnedAfterSaleCount = 0;
216   address public contractOwner = 0;
217   address public migrationAgent = 0;
218 
219   event Burn(address indexed burner, uint256 value);
220   event Migrate(address indexed migrator, uint256 value);
221   
222   function ABChainRTBtoken() {
223       burnedCount = 0;
224       burnedAfterSaleCount = 0;
225       totalSupply = INITIAL_SUPPLY;
226       balances[msg.sender] = INITIAL_SUPPLY;
227       contractOwner = msg.sender;
228   }
229   
230   function migrate() {
231         require(migrationAgent != 0);
232         uint256 _value = balances[msg.sender];
233         require(_value > 0);
234         burn(_value);
235         MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);
236         Migrate(msg.sender, _value);
237     }
238 
239     function setMigrationAgent(address _agent) {
240         require(msg.sender == contractOwner);
241         migrationAgent = _agent;
242     }
243 
244   /**
245    * @dev Burns a specific amount of tokens.
246    * @param _value The amount of token to be burned.
247    */
248   function burn(uint256 _value) public {
249     require(_value <= balances[msg.sender]);
250     // no need to require value <= totalSupply, since that would imply the
251     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
252 
253     address burner = msg.sender;
254     balances[burner] = balances[burner].sub(_value);
255     totalSupply = totalSupply.sub(_value);
256     burnedCount = burnedCount.add(_value);
257     Burn(burner, _value);
258     }
259   // only for burn after sale
260   function burnaftersale(uint256 _value) public {
261     require(_value <= balances[msg.sender]);
262     // no need to require value <= totalSupply, since that would imply the
263     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
264     address burner = msg.sender;
265     balances[burner] = balances[burner].sub(_value);
266     totalSupply = totalSupply.sub(_value);
267     burnedAfterSaleCount = burnedAfterSaleCount.add(_value);
268     Burn(burner, _value);
269     }
270     
271     // only for lazy migration
272     function () payable {
273         require(migrationAgent != 0 && msg.value == 0);
274         migrate();
275     }
276 }
277 
278 /* AB-CHAIN Network RTB payments processing smart-contract  */
279 contract ABChainNetContract_v5 {
280     using SafeMath for uint256;
281     
282     address public contractOwner = 0;
283     address public tokenAddress = 0xEC491c1088Eae992B7A214efB0a266AD0927A72A;
284     address public ABChainRevenueAddress = 0x651Ccecc133dEa9635c84FC2C17707Ee18729f62;
285     address public ABChainPBudgetsAddress = 0x5B16ce4534c1a746cffE95ae18083969e9e1F5e9;
286     uint256 public tokenBurningPercentage = 500; // 1 = 0.01%; 500 = 5% 
287     uint256 public revenuePercentage = 500; // 1 = 0.01%; 500 = 5%
288     uint256 public processedRTBs = 0;
289     uint256 public burnedRTBs = 0;
290     uint256 public netRevenueRTBs = 0;
291     uint256 public publrsBudgRTBs = 0;
292     uint256 public processingCallsCount = 0;
293     
294     // RTBProcessing event
295     event RTBProcessing(
296         address indexed sender,
297         uint256 balanceBefore,
298         uint256 burned,
299         uint256 sendedToPBudgets,
300         uint256 sendedToRevenue,
301         address indexed curABChainRevenueAddress,
302         address indexed curABChainPBudgetsAddress,
303         uint256 curRevPerc,
304         uint256 curTokenBurningPerc,
305         address curContractOwner
306     );
307     
308     constructor () public {
309         contractOwner = msg.sender;
310     }
311     
312     function unprocessedRTBBalance() public view returns (uint256) {
313         return ABChainRTBtoken(tokenAddress).balanceOf(address(this));
314     }
315     
316     // change contract owner
317     function changeOwner(address _owner) public {
318         require(msg.sender == contractOwner);
319         contractOwner = _owner;
320     }
321     
322     // change the address of the token contract
323     function changeTokenAddress(address _tokenAddress) public {
324         require(msg.sender == contractOwner);
325         tokenAddress = _tokenAddress;
326     }
327     
328     // change ABChain Revenue Address
329     function changeABChainRevenueAddress(address _ABChainRevenueAddress) public {
330         require(msg.sender == contractOwner);
331         ABChainRevenueAddress = _ABChainRevenueAddress;
332     }
333     
334     // change ABChainPBudgetsAddress
335     function changeABChainPBudgetsAddress(address _ABChainPBudgetsAddress) public {
336         require(msg.sender == contractOwner);
337         ABChainPBudgetsAddress = _ABChainPBudgetsAddress;
338     }
339     
340     // change tokenBurningPercentage
341     function changeTokenBurningPercentage(uint256 _tokenBurningPercentage) public {
342         require(msg.sender == contractOwner);
343         tokenBurningPercentage = _tokenBurningPercentage;
344     }
345     
346     // change revenuePercentage
347     function changeRevenuePercentage(uint256 _revenuePercentage) public {
348         require(msg.sender == contractOwner);
349         revenuePercentage = _revenuePercentage;
350     }
351     
352     // RTB-payments processing
353     function rtbPaymentsProcessing() public {
354         uint256 _balance = ABChainRTBtoken(tokenAddress).balanceOf(address(this));
355         require(_balance > 0);
356         
357         processingCallsCount = processingCallsCount.add(1);
358         
359         uint256 _forBurning = uint256(_balance.div(10000)).mul(tokenBurningPercentage);
360         
361         uint256 _forRevenue = uint256(_balance.div(10000)).mul(revenuePercentage);
362         
363         uint256 _forPBudgets = uint256(_balance.sub(_forBurning)).sub(_forRevenue);
364         
365         ABChainRTBtoken(tokenAddress).transfer(ABChainPBudgetsAddress, _forPBudgets);
366         
367         ABChainRTBtoken(tokenAddress).transfer(ABChainRevenueAddress, _forRevenue);
368         
369         ABChainRTBtoken(tokenAddress).burn(_forBurning);
370         
371         processedRTBs = processedRTBs.add(_balance);
372         burnedRTBs = burnedRTBs.add(_forBurning);
373         publrsBudgRTBs = publrsBudgRTBs.add(_forPBudgets);
374         netRevenueRTBs = netRevenueRTBs.add(_forRevenue);
375 
376         emit RTBProcessing(
377             msg.sender,
378             _balance,
379             _forBurning,
380             _forPBudgets,
381             _forRevenue,
382             ABChainRevenueAddress,
383             ABChainPBudgetsAddress,
384             revenuePercentage,
385             tokenBurningPercentage,
386             contractOwner
387         );
388     }
389 
390     // current contract version does not accept ethereum. RTB processing only :)
391     function () payable public {
392         require(msg.value == 0);
393     }
394 }