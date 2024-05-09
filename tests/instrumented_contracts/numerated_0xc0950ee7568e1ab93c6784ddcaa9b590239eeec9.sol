1 pragma solidity 0.4.19;
2 
3 // File: src/zeppelin/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: src/zeppelin/token/ERC20Basic.sol
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 // File: src/zeppelin/token/BasicToken.sol
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   uint256 totalSupply_;
77 
78   /**
79   * @dev total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     // SafeMath.sub will throw if there is not enough balance.
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   /**
102   * @dev Gets the balance of the specified address.
103   * @param _owner The address to query the the balance of.
104   * @return An uint256 representing the amount owned by the passed address.
105   */
106   function balanceOf(address _owner) public view returns (uint256 balance) {
107     return balances[_owner];
108   }
109 
110 }
111 
112 // File: src/zeppelin/token/ERC20.sol
113 
114 /**
115  * @title ERC20 interface
116  * @dev see https://github.com/ethereum/EIPs/issues/20
117  */
118 contract ERC20 is ERC20Basic {
119   function allowance(address owner, address spender) public view returns (uint256);
120   function transferFrom(address from, address to, uint256 value) public returns (bool);
121   function approve(address spender, uint256 value) public returns (bool);
122   event Approval(address indexed owner, address indexed spender, uint256 value);
123 }
124 
125 // File: src/zeppelin/token/StandardToken.sol
126 
127 /**
128  * @title Standard ERC20 token
129  *
130  * @dev Implementation of the basic standard token.
131  * @dev https://github.com/ethereum/EIPs/issues/20
132  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
133  */
134 contract StandardToken is ERC20, BasicToken {
135 
136   mapping (address => mapping (address => uint256)) internal allowed;
137 
138 
139   /**
140    * @dev Transfer tokens from one address to another
141    * @param _from address The address which you want to send tokens from
142    * @param _to address The address which you want to transfer to
143    * @param _value uint256 the amount of tokens to be transferred
144    */
145   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
146     require(_to != address(0));
147     require(_value <= balances[_from]);
148     require(_value <= allowed[_from][msg.sender]);
149 
150     balances[_from] = balances[_from].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
153     Transfer(_from, _to, _value);
154     return true;
155   }
156 
157   /**
158    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
159    *
160    * Beware that changing an allowance with this method brings the risk that someone may use both the old
161    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164    * @param _spender The address which will spend the funds.
165    * @param _value The amount of tokens to be spent.
166    */
167   function approve(address _spender, uint256 _value) public returns (bool) {
168     allowed[msg.sender][_spender] = _value;
169     Approval(msg.sender, _spender, _value);
170     return true;
171   }
172 
173   /**
174    * @dev Function to check the amount of tokens that an owner allowed to a spender.
175    * @param _owner address The address which owns the funds.
176    * @param _spender address The address which will spend the funds.
177    * @return A uint256 specifying the amount of tokens still available for the spender.
178    */
179   function allowance(address _owner, address _spender) public view returns (uint256) {
180     return allowed[_owner][_spender];
181   }
182 
183   /**
184    * @dev Increase the amount of tokens that an owner allowed to a spender.
185    *
186    * approve should be called when allowed[_spender] == 0. To increment
187    * allowed value is better to use this function to avoid 2 calls (and wait until
188    * the first transaction is mined)
189    * From MonolithDAO Token.sol
190    * @param _spender The address which will spend the funds.
191    * @param _addedValue The amount of tokens to increase the allowance by.
192    */
193   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
194     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
195     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196     return true;
197   }
198 
199   /**
200    * @dev Decrease the amount of tokens that an owner allowed to a spender.
201    *
202    * approve should be called when allowed[_spender] == 0. To decrement
203    * allowed value is better to use this function to avoid 2 calls (and wait until
204    * the first transaction is mined)
205    * From MonolithDAO Token.sol
206    * @param _spender The address which will spend the funds.
207    * @param _subtractedValue The amount of tokens to decrease the allowance by.
208    */
209   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
210     uint oldValue = allowed[msg.sender][_spender];
211     if (_subtractedValue > oldValue) {
212       allowed[msg.sender][_spender] = 0;
213     } else {
214       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
215     }
216     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217     return true;
218   }
219 
220 }
221 
222 // File: src/PrimeToken.sol
223 
224 // ----------------------------------------------------------------------------
225 // PRIME token contract
226 //
227 // Symbol      : PRIME
228 // Name        : PRIME PRETGE
229 // Total supply: 250000000
230 // Decimals    : 18
231 //
232 //
233 // By using this smart-contract you confirm to have read and
234 // agree to the terms and conditions set herein: http://primeshipping.io/legal
235 // ----------------------------------------------------------------------------
236 
237 
238 
239 
240 contract PrimeToken is StandardToken {
241   string public constant name = 'PRIME PRETGE';
242   string public constant symbol = 'PRIME';
243   uint256 public constant decimals = 18;
244 
245   uint256 public constant tokenCreationCap = 250000000 * 10 ** decimals;
246   string public constant LEGAL = 'By using this smart-contract you confirm to have read and agree to the terms and conditions set herein: http://primeshipping.io/legal';
247 
248   address public wallet;
249   address public owner;
250 
251   bool public active = true;
252 
253   uint256 public oneTokenInWei = 50000000000000000;
254   uint256 public minimumAllowedWei = 5000000000000000000;
255 
256   modifier onlyOwner {
257     if (owner != msg.sender) {
258       revert();
259     }
260     _;
261   }
262 
263   modifier onlyActive {
264     if (!active) {
265       revert();
266     }
267     _;
268   }
269 
270   event Mint(address indexed to, uint256 amount);
271   event MintFinished();
272 
273   /**
274    * event for token purchase logging
275    * @param purchaser who paid for the tokens
276    * @param beneficiary who got the tokens
277    * @param value weis paid for purchase
278    * @param amount amount of tokens purchased
279    */
280   event TokenPurchase(
281     address indexed purchaser,
282     address indexed beneficiary,
283     uint256 value,
284     uint256 amount
285   );
286 
287   function PrimeToken(address _wallet) public {
288     wallet = _wallet;
289     owner = msg.sender;
290   }
291 
292   function() payable public {
293     createTokens();
294   }
295 
296   /**
297    * @param  _to Target address.
298    * @param  _amount Amount of PRIME tokens, _NOT_ multiplied to decimals.
299    */
300   function mintTokens(address _to, uint256 _amount) external onlyOwner {
301     uint256 tokens = _amount.mul(10 ** decimals);
302     uint256 checkedSupply = totalSupply_.add(tokens);
303     require(tokenCreationCap > checkedSupply);
304 
305     balances[_to] += tokens;
306     totalSupply_ = checkedSupply;
307 
308     Mint(_to, tokens);
309     Transfer(address(0), _to, tokens);
310   }
311 
312   function withdraw() external onlyOwner {
313     wallet.transfer(this.balance);
314   }
315 
316   function finalize() external onlyOwner {
317     active = false;
318 
319     MintFinished();
320   }
321 
322   /**
323    * Sets price in wei per 1 PRIME token.
324    */
325   function setTokenPriceInWei(uint256 _oneTokenInWei) external onlyOwner {
326     oneTokenInWei = _oneTokenInWei;
327   }
328 
329   function createTokens() internal onlyActive {
330     require(msg.value >= minimumAllowedWei);
331 
332     uint256 multiplier = 10 ** decimals;
333     uint256 tokens = msg.value.mul(multiplier).div(oneTokenInWei);
334     uint256 checkedSupply = totalSupply_.add(tokens);
335 
336     require(tokenCreationCap > checkedSupply);
337 
338     balances[msg.sender] += tokens;
339     totalSupply_ = checkedSupply;
340 
341     Mint(msg.sender, tokens);
342     Transfer(address(0), msg.sender, tokens);
343     TokenPurchase(
344       msg.sender,
345       msg.sender,
346       msg.value,
347       tokens
348     );
349   }
350 
351   function setMinimumAllowedWei(uint256 _wei) external onlyOwner {
352     minimumAllowedWei = _wei;
353   }
354 }