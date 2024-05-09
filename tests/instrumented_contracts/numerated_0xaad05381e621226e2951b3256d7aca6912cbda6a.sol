1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-19
3 */
4 
5 /**
6  * Source Code first verified at https://etherscan.io on Friday, January 11, 2019
7  (UTC) */
8 
9 pragma solidity ^0.5.0;
10 
11 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
12 
13 /**
14  * @title SafeMath
15  * @dev Math operations with safety checks that throw on error
16  */
17 library SafeMath {
18 
19   /**
20   * @dev Multiplies two numbers, throws on overflow.
21   */
22   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
23     if (a == 0) {
24       return 0;
25     }
26     c = a * b;
27     assert(c / a == b);
28     return c;
29   }
30 
31   /**
32   * @dev Integer division of two numbers, truncating the quotient.
33   */
34   function div(uint256 a, uint256 b) internal pure returns (uint256) {
35     // assert(b > 0); // Solidity automatically throws when dividing by 0
36     // uint256 c = a / b;
37     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38     return a / b;
39   }
40 
41   /**
42   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
43   */
44   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45     assert(b <= a);
46     return a - b;
47   }
48 
49   /**
50   * @dev Adds two numbers, throws on overflow.
51   */
52   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
53     c = a + b;
54     assert(c >= a);
55     return c;
56   }
57   
58   function ceil(uint256 a, uint256 m) internal pure returns (uint256 ) {
59         return ((a + m - 1) / m) * m;
60   }
61 }
62 
63 /*
64  * Ownable
65  *
66  * Base contract with an owner.
67  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
68  */
69 contract Ownable {
70   address public owner;
71 
72   constructor () public {
73     owner = msg.sender;
74   }
75 
76   modifier onlyOwner() {
77     assert(msg.sender == owner);
78     _;
79   }
80 
81   function transferOwnership(address newOwner) onlyOwner public {
82     if (newOwner != address(0)) {
83       owner = newOwner;
84     }
85   }
86 
87 }
88 
89 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
90 
91 /**
92  * @title ERC20Basic
93  * @dev Simpler version of ERC20 interface
94  * @dev see https://github.com/ethereum/EIPs/issues/179
95  */
96 contract ERC20Basic {
97   function totalSupply() public view returns (uint256);
98   function balanceOf(address who) public view returns (uint256);
99   function transfer(address to, uint256 value) public returns (bool);
100   event Transfer(address indexed from, address indexed to, uint256 value);
101 }
102 
103 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
104 
105 /**
106  * @title Basic token
107  * @dev Basic version of StandardToken, with no allowances.
108  */
109 contract BasicToken is ERC20Basic {
110   using SafeMath for uint256;
111 
112   mapping(address => uint256) balances;
113 
114   uint256 totalSupply_;
115 
116   /**
117   * @dev total number of tokens in existence
118   */
119   function totalSupply() public view returns (uint256) {
120     return totalSupply_;
121   }
122 
123   /**
124   * @dev transfer token for a specified address
125   * @param _to The address to transfer to.
126   * @param _value The amount to be transferred.
127   */
128   function transfer(address _to, uint256 _value) public returns (bool) {
129     require(_to != address(0));
130     require(_value <= balances[msg.sender] && balances[_to] + _value >= balances[_to]);
131 
132     balances[msg.sender] = balances[msg.sender].sub(_value);
133     balances[_to] = balances[_to].add(_value);
134     emit Transfer(msg.sender, _to, _value);
135     return true;
136   }
137 
138   /**
139   * @dev Gets the balance of the specified address.
140   * @param _owner The address to query the the balance of.
141   * @return An uint256 representing the amount owned by the passed address.
142   */
143   function balanceOf(address _owner) public view returns (uint256) {
144     return balances[_owner];
145   }
146 
147 }
148 
149 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
150 
151 /**
152  * @title ERC20 interface
153  * @dev see https://github.com/ethereum/EIPs/issues/20
154  */
155 contract ERC20 is ERC20Basic {
156   function allowance(address owner, address spender) public view returns (uint256);
157   function transferFrom(address from, address to, uint256 value) public returns (bool);
158   function approve(address spender, uint256 value) public returns (bool);
159   event Approval(address indexed owner, address indexed spender, uint256 value);
160 }
161 
162 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
163 
164 /**
165  * @title Standard ERC20 token
166  *
167  * @dev Implementation of the basic standard token.
168  * @dev https://github.com/ethereum/EIPs/issues/20
169  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
170  */
171 contract StandardToken is ERC20, BasicToken {
172 
173   mapping (address => mapping (address => uint256)) internal allowed;
174 
175 
176   /**
177    * @dev Transfer tokens from one address to another
178    * @param _from address The address which you want to send tokens from
179    * @param _to address The address which you want to transfer to
180    * @param _value uint256 the amount of tokens to be transferred
181    */
182   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
183     require(_to != address(0));
184     require(_value <= balances[_from] && balances[_to] + _value >= balances[_to]);
185     require(_value <= allowed[_from][msg.sender]);
186 
187     balances[_from] = balances[_from].sub(_value);
188     balances[_to] = balances[_to].add(_value);
189     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
190     emit Transfer(_from, _to, _value);
191     return true;
192   }
193 
194   /**
195    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
196    *
197    * Beware that changing an allowance with this method brings the risk that someone may use both the old
198    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
199    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
200    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201    * @param _spender The address which will spend the funds.
202    * @param _value The amount of tokens to be spent.
203    */
204   function approve(address _spender, uint256 _value) public returns (bool) {
205     allowed[msg.sender][_spender] = _value;
206     emit Approval(msg.sender, _spender, _value);
207     return true;
208   }
209 
210   /**
211    * @dev Function to check the amount of tokens that an owner allowed to a spender.
212    * @param _owner address The address which owns the funds.
213    * @param _spender address The address which will spend the funds.
214    * @return A uint256 specifying the amount of tokens still available for the spender.
215    */
216   function allowance(address _owner, address _spender) public view returns (uint256) {
217     return allowed[_owner][_spender];
218   }
219 
220   /**
221    * @dev Increase the amount of tokens that an owner allowed to a spender.
222    *
223    * approve should be called when allowed[_spender] == 0. To increment
224    * allowed value is better to use this function to avoid 2 calls (and wait until
225    * the first transaction is mined)
226    * From MonolithDAO Token.sol
227    * @param _spender The address which will spend the funds.
228    * @param _addedValue The amount of tokens to increase the allowance by.
229    */
230   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
231     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
232     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
233     return true;
234   }
235 
236   /**
237    * @dev Decrease the amount of tokens that an owner allowed to a spender.
238    *
239    * approve should be called when allowed[_spender] == 0. To decrement
240    * allowed value is better to use this function to avoid 2 calls (and wait until
241    * the first transaction is mined)
242    * From MonolithDAO Token.sol
243    * @param _spender The address which will spend the funds.
244    * @param _subtractedValue The amount of tokens to decrease the allowance by.
245    */
246   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
247     uint oldValue = allowed[msg.sender][_spender];
248     if (_subtractedValue > oldValue) {
249       allowed[msg.sender][_spender] = 0;
250     } else {
251       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
252     }
253     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
254     return true;
255   }
256 
257 }
258 
259 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
260 
261 /**
262  * @title Burnable Token
263  * @dev Token that can be irreversibly burned (destroyed).
264  */
265 contract BurnableToken is BasicToken {
266 
267   event Burn(address indexed burner, uint256 value);
268 
269   /**
270    * @dev Burns a specific amount of tokens.
271    * @param _value The amount of token to be burned.
272    */
273   function burn(uint256 _value) public {
274     _burn(msg.sender, _value);
275   }
276 
277   function _burn(address _who, uint256 _value) internal {
278     require(_value <= balances[_who]);
279     // no need to require value <= totalSupply, since that would imply the
280     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
281 
282     balances[_who] = balances[_who].sub(_value);
283     totalSupply_ = totalSupply_.sub(_value);
284     emit Burn(_who, _value);
285     emit Transfer(_who, address(0), _value);
286   }
287 }
288 
289 // File: openzeppelin-solidity/contracts/token/ERC20/StandardBurnableToken.sol
290 
291 /**
292  * @title Standard Burnable Token
293  * @dev Adds burnFrom method to ERC20 implementations
294  */
295 contract StandardBurnableToken is BurnableToken, StandardToken {
296 
297   /**
298    * @dev Burns a specific amount of tokens from the target address and decrements allowance
299    * @param _from address The address which you want to send tokens from
300    * @param _value uint256 The amount of token to be burned
301    */
302   function burnFrom(address _from, uint256 _value) public {
303     require(_value <= allowed[_from][msg.sender]);
304     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
305     // this function needs to emit an event with the updated approval.
306     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
307     _burn(_from, _value);
308   }
309 }
310 
311 // File: contracts/Blcontr.sol
312 
313 contract DOG is StandardBurnableToken, Ownable {
314 
315   string public constant name = "COINDOGS"; // solium-disable-line uppercase
316   string public constant symbol = "DOG"; // solium-disable-line uppercase
317   address payable public constant tokenOwner = 0xB30E79F1808FC364432fa4c73b7E0a5bA8c8fb02;
318   uint256 public constant INITIAL_SUPPLY = 25000000;
319   uint256 public price;
320   uint256 public collectedTokens;
321   uint256 public collectedEthers;
322 
323   using SafeMath for uint256;
324   uint256 public startTime;
325   uint256 public weiRaised;
326   uint256 public tokensSold;
327     
328   bool public isFinished = false;
329 
330     modifier onlyAfter(uint256 time) {
331         assert(now >= time);
332         _;
333     }
334 
335     modifier onlyBefore(uint256 time) {
336         assert(now <= time);
337         _;
338     }
339     
340     modifier checkAmount(uint256 amount) {
341         uint256 tokens = amount.div(price);
342         assert(totalSupply_.sub(tokensSold.add(tokens)) >= 0);
343         _;
344     }
345     
346     modifier notNull(uint256 amount) {
347         assert(amount >= price);
348         _;
349     }
350     
351         
352     modifier checkFinished() {
353         assert(!isFinished);
354         _;
355     }
356 
357   constructor() public {
358     totalSupply_ = INITIAL_SUPPLY;
359     balances[tokenOwner] = INITIAL_SUPPLY;
360     emit Transfer(0x0000000000000000000000000000000000000000, tokenOwner, INITIAL_SUPPLY);
361     
362     price = 0.0035 ether;    
363     startTime = 1561975200;
364   }
365     
366     function () external payable onlyAfter(startTime) checkFinished() checkAmount(msg.value) notNull(msg.value) {
367         doPurchase(msg.value, msg.sender);
368     }
369     
370     function doPurchase(uint256 amount, address sender) private {
371         
372         uint256 tokens = amount.div(price);
373         
374         balances[tokenOwner] = balances[tokenOwner].sub(tokens);
375         balances[sender] = balances[sender].add(tokens);
376         
377         collectedTokens = collectedTokens.add(tokens);
378         collectedEthers = collectedEthers.add(amount);
379         
380         weiRaised = weiRaised.add(amount);
381         tokensSold = tokensSold.add(tokens);
382         
383         emit Transfer(tokenOwner, sender, tokens);
384     }
385     
386     function withdraw() onlyOwner public returns (bool) {
387         if (!tokenOwner.send(collectedEthers)) {
388             return false;
389         }
390         collectedEthers = 0;
391         return true;
392     }
393     
394     function stop() onlyOwner public returns (bool) {
395         isFinished = true;
396         return true;
397     }
398     
399     function changePrice(uint256 amount) onlyOwner public {
400         price = amount;
401     }
402 }