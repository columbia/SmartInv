1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     if (a == 0) {
10       return 0;
11     }
12     c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     // uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return a / b;
25   }
26 
27   /**
28   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39     c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60   /**
61    * @dev Throws if called by any account other than the owner.
62    */
63   modifier onlyOwner() {
64     require(msg.sender == owner);
65     _;
66   }
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) public onlyOwner {
73     require(newOwner != address(0));
74     emit OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 contract Pausable is Ownable {
81   event Pause();
82   event Unpause();
83 
84   bool public paused = false;
85 
86 
87   /**
88    * @dev Modifier to make a function callable only when the contract is not paused.
89    */
90   modifier whenNotPaused() {
91     require(!paused);
92     _;
93   }
94 
95   /**
96    * @dev Modifier to make a function callable only when the contract is paused.
97    */
98   modifier whenPaused() {
99     require(paused);
100     _;
101   }
102 
103   /**
104    * @dev called by the owner to pause, triggers stopped state
105    */
106   function pause() onlyOwner whenNotPaused public {
107     paused = true;
108     emit Pause();
109   }
110 
111   /**
112    * @dev called by the owner to unpause, returns to normal state
113    */
114   function unpause() onlyOwner whenPaused public {
115     paused = false;
116     emit Unpause();
117   }
118 }
119 
120 contract ERC20Basic {
121   function totalSupply() public view returns (uint256);
122   function balanceOf(address who) public view returns (uint256);
123   function transfer(address to, uint256 value) public returns (bool);
124   event Transfer(address indexed from, address indexed to, uint256 value);
125 }
126 
127 contract BasicToken is ERC20Basic {
128   using SafeMath for uint256;
129 
130   mapping(address => uint256) balances;
131 
132   uint256 totalSupply_;
133 
134   /**
135   * @dev total number of tokens in existence
136   */
137   function totalSupply() public view returns (uint256) {
138     return totalSupply_;
139   }
140 
141   /**
142   * @dev transfer token for a specified address
143   * @param _to The address to transfer to.
144   * @param _value The amount to be transferred.
145   */
146   function transfer(address _to, uint256 _value) public returns (bool) {
147     require(_to != address(0));
148     require(_value <= balances[msg.sender]);
149 
150     balances[msg.sender] = balances[msg.sender].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     emit Transfer(msg.sender, _to, _value);
153     return true;
154   }
155 
156   /**
157   * @dev Gets the balance of the specified address.
158   * @param _owner The address to query the the balance of.
159   * @return An uint256 representing the amount owned by the passed address.
160   */
161   function balanceOf(address _owner) public view returns (uint256) {
162     return balances[_owner];
163   }
164 
165 }
166 
167 contract ERC20 is ERC20Basic {
168   function allowance(address owner, address spender) public view returns (uint256);
169   function transferFrom(address from, address to, uint256 value) public returns (bool);
170   function approve(address spender, uint256 value) public returns (bool);
171   event Approval(address indexed owner, address indexed spender, uint256 value);
172 }
173 
174 contract StandardToken is ERC20, BasicToken {
175 
176   mapping (address => mapping (address => uint256)) internal allowed;
177 
178 
179   /**
180    * @dev Transfer tokens from one address to another
181    * @param _from address The address which you want to send tokens from
182    * @param _to address The address which you want to transfer to
183    * @param _value uint256 the amount of tokens to be transferred
184    */
185   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
186     require(_to != address(0));
187     require(_value <= balances[_from]);
188     require(_value <= allowed[_from][msg.sender]);
189 
190     balances[_from] = balances[_from].sub(_value);
191     balances[_to] = balances[_to].add(_value);
192     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
193     emit Transfer(_from, _to, _value);
194     return true;
195   }
196 
197   /**
198    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
199    *
200    * Beware that changing an allowance with this method brings the risk that someone may use both the old
201    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
202    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
203    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
204    * @param _spender The address which will spend the funds.
205    * @param _value The amount of tokens to be spent.
206    */
207   function approve(address _spender, uint256 _value) public returns (bool) {
208     allowed[msg.sender][_spender] = _value;
209     emit Approval(msg.sender, _spender, _value);
210     return true;
211   }
212 
213   /**
214    * @dev Function to check the amount of tokens that an owner allowed to a spender.
215    * @param _owner address The address which owns the funds.
216    * @param _spender address The address which will spend the funds.
217    * @return A uint256 specifying the amount of tokens still available for the spender.
218    */
219   function allowance(address _owner, address _spender) public view returns (uint256) {
220     return allowed[_owner][_spender];
221   }
222 
223   /**
224    * @dev Increase the amount of tokens that an owner allowed to a spender.
225    *
226    * approve should be called when allowed[_spender] == 0. To increment
227    * allowed value is better to use this function to avoid 2 calls (and wait until
228    * the first transaction is mined)
229    * From MonolithDAO Token.sol
230    * @param _spender The address which will spend the funds.
231    * @param _addedValue The amount of tokens to increase the allowance by.
232    */
233   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
234     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
235     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
236     return true;
237   }
238 
239   /**
240    * @dev Decrease the amount of tokens that an owner allowed to a spender.
241    *
242    * approve should be called when allowed[_spender] == 0. To decrement
243    * allowed value is better to use this function to avoid 2 calls (and wait until
244    * the first transaction is mined)
245    * From MonolithDAO Token.sol
246    * @param _spender The address which will spend the funds.
247    * @param _subtractedValue The amount of tokens to decrease the allowance by.
248    */
249   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
250     uint oldValue = allowed[msg.sender][_spender];
251     if (_subtractedValue > oldValue) {
252       allowed[msg.sender][_spender] = 0;
253     } else {
254       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
255     }
256     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
257     return true;
258   }
259 
260 }
261 
262 contract MintableToken is StandardToken, Ownable {
263   event Mint(address indexed to, uint256 amount);
264   event MintFinished();
265 
266   bool public mintingFinished = false;
267 
268 
269   modifier canMint() {
270     require(!mintingFinished);
271     _;
272   }
273 
274   /**
275    * @dev Function to mint tokens
276    * @param _to The address that will receive the minted tokens.
277    * @param _amount The amount of tokens to mint.
278    * @return A boolean that indicates if the operation was successful.
279    */
280   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
281     totalSupply_ = totalSupply_.add(_amount);
282     balances[_to] = balances[_to].add(_amount);
283     emit Mint(_to, _amount);
284     emit Transfer(address(0), _to, _amount);
285     return true;
286   }
287 
288   /**
289    * @dev Function to stop minting new tokens.
290    * @return True if the operation was successful.
291    */
292   function finishMinting() onlyOwner canMint public returns (bool) {
293     mintingFinished = true;
294     emit MintFinished();
295     return true;
296   }
297 }
298 
299 contract CappedToken is MintableToken {
300 
301   uint256 public cap;
302 
303   function CappedToken(uint256 _cap) public {
304     require(_cap > 0);
305     cap = _cap;
306   }
307 
308   /**
309    * @dev Function to mint tokens
310    * @param _to The address that will receive the minted tokens.
311    * @param _amount The amount of tokens to mint.
312    * @return A boolean that indicates if the operation was successful.
313    */
314   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
315     require(totalSupply_.add(_amount) <= cap);
316 
317     return super.mint(_to, _amount);
318   }
319 
320 }
321 
322 contract PausableToken is StandardToken, Pausable {
323 
324   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
325     return super.transfer(_to, _value);
326   }
327 
328   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
329     return super.transferFrom(_from, _to, _value);
330   }
331 
332   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
333     return super.approve(_spender, _value);
334   }
335 
336   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
337     return super.increaseApproval(_spender, _addedValue);
338   }
339 
340   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
341     return super.decreaseApproval(_spender, _subtractedValue);
342   }
343 }
344 
345 contract GalaxyToken  is PausableToken, CappedToken {
346     string public constant name = 'GalaxyCoin';
347     string public constant symbol = 'GC';
348     uint256 public constant decimals = 18;
349     uint256 public constant CAP = 500000000 * (10 ** decimals);
350 
351     // angel investors wallet
352     address public angelInvestorsWallet;
353     // public offering wallet
354     address public publicOfferingWallet;
355     // private offering wallet
356     address public privateOfferingWallet;
357     // operations wallet
358     address public operationsWallet;
359     // ecosystem building wallet
360     address public ecosystemBuildingWallet;
361     // mining incentive wallet
362     address public miningIncentiveWallet;
363 
364     // 10%
365     uint256 public angelInvestorsTokens = 50000000 * (10 ** 18);
366     // 20%
367     uint256 public publicOfferingTokens = 100000000 * (10 ** 18);
368     // 10%
369     uint256 public privateOfferingTokens = 50000000 * (10 ** 18);
370     // 30%
371     uint256 public operationsTokens = 150000000 * (10 ** 18);
372     // 18%
373     uint256 public ecosystemBuildingTokens = 90000000 * (10 ** 18);
374     // 12%
375     uint256 public miningIncentiveTokens = 60000000 * (10 ** 18);
376 
377     constructor(
378         address _angelInvestorsWallet,
379         address _publicOfferingWallet,
380         address _privateOfferingWallet,
381         address _operationsWallet,
382         address _ecosystemBuildingWallet,
383         address _miningIncentiveWallet
384     ) CappedToken( CAP ) public {
385         require(_angelInvestorsWallet != address(0));
386         require(_publicOfferingWallet != address(0));
387         require(_privateOfferingWallet != address(0));
388         require(_operationsWallet != address(0));
389         require(_ecosystemBuildingWallet != address(0));
390         require(_miningIncentiveWallet != address(0));
391 
392         angelInvestorsWallet = _angelInvestorsWallet;
393         publicOfferingWallet = _publicOfferingWallet;
394         privateOfferingWallet = _privateOfferingWallet;
395         operationsWallet = _operationsWallet;
396         ecosystemBuildingWallet = _ecosystemBuildingWallet;
397         miningIncentiveWallet = _miningIncentiveWallet;
398 
399 
400         mint(angelInvestorsWallet, angelInvestorsTokens);
401         mint(publicOfferingWallet, publicOfferingTokens);
402         mint(privateOfferingWallet, privateOfferingTokens);
403         mint(operationsWallet, operationsTokens);
404         mint(ecosystemBuildingWallet, ecosystemBuildingTokens);
405         mint(miningIncentiveWallet, miningIncentiveTokens);
406         finishMinting();
407         transferOwnership(owner);
408     }
409 }