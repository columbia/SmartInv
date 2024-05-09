1 /*****
2    Pewdiepie token
3 
4    Stands for sincerity,
5    truthfulness,
6    kindness,
7    fun, freedom of speech and
8    standing up for yourself.
9    And also a gift to pewdiepie.
10    The token is made for all people who respect and love Felix Kjellberg (also known as pewdiepie) and his work.
11    A larger part (>50%)of funds raised in this ICO will go to the people who need it the most.
12    Everyone should be allowed to laugh, learn, play and enjoy life freely as much as they can.
13    Thank you pewdipie for being the beacon for these values.
14 
15    Disclaimer:
16    Felix Arvid Ulf Kjellberg has not endorsed or backed up this project and is not legally responsible for anything that happens.
17    The makers of this token are not against usage of this token in video games or for purchasing video games or other related stuff.
18 
19 *****/
20 
21 
22 pragma solidity ^0.4.18;
23 
24 /**
25  * @title SafeMath
26  * @dev Math operations with safety checks that throw on error
27  */
28 library SafeMath {
29 
30   /**
31   * @dev Multiplies two numbers, throws on overflow.
32   */
33   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34     if (a == 0) {
35       return 0;
36     }
37     uint256 c = a * b;
38     assert(c / a == b);
39     return c;
40   }
41 
42   /**
43   * @dev Integer division of two numbers, truncating the quotient.
44   */
45   function div(uint256 a, uint256 b) internal pure returns (uint256) {
46     // assert(b > 0); // Solidity automatically throws when dividing by 0
47     uint256 c = a / b;
48     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
49     return c;
50   }
51 
52   /**
53   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
54   */
55   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56     assert(b <= a);
57     return a - b;
58   }
59 
60   /**
61   * @dev Adds two numbers, throws on overflow.
62   */
63   function add(uint256 a, uint256 b) internal pure returns (uint256) {
64     uint256 c = a + b;
65     assert(c >= a);
66     return c;
67   }
68 }
69 
70 pragma solidity ^0.4.18;
71 
72 
73 /**
74  * @title ERC20Basic
75  * @dev Simpler version of ERC20 interface
76  * @dev see https://github.com/ethereum/EIPs/issues/179
77  */
78 contract ERC20Basic {
79   function totalSupply() public view returns (uint256);
80   function balanceOf(address who) public view returns (uint256);
81   function transfer(address to, uint256 value) public returns (bool);
82   event Transfer(address indexed from, address indexed to, uint256 value);
83 }
84 
85 pragma solidity ^0.4.18;
86 
87 /**
88  * @title ERC20 interface
89  * @dev see https://github.com/ethereum/EIPs/issues/20
90  */
91 contract ERC20 is ERC20Basic {
92   function allowance(address owner, address spender) public view returns (uint256);
93   function transferFrom(address from, address to, uint256 value) public returns (bool);
94   function approve(address spender, uint256 value) public returns (bool);
95   event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 pragma solidity ^0.4.18;
99 
100 
101 /**
102  * @title Basic token
103  * @dev Basic version of StandardToken, with no allowances.
104  */
105 contract BasicToken is ERC20Basic {
106   using SafeMath for uint256;
107 
108   mapping(address => uint256) balances;
109 
110   uint256 totalSupply_;
111 
112   /**
113   * @dev total number of tokens in existence
114   */
115   function totalSupply() public view returns (uint256) {
116     return totalSupply_;
117   }
118 
119   /**
120   * @dev transfer token for a specified address
121   * @param _to The address to transfer to.
122   * @param _value The amount to be transferred.
123   */
124   function transfer(address _to, uint256 _value) public returns (bool) {
125     require(_to != address(0));
126     require(_to != address(this));
127     require(_value <= balances[msg.sender]);
128 
129     // SafeMath.sub will throw if there is not enough balance.
130     balances[msg.sender] = balances[msg.sender].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     Transfer(msg.sender, _to, _value);
133     return true;
134   }
135 
136   /**
137   * @dev Gets the balance of the specified address.
138   * @param _owner The address to query the the balance of.
139   * @return An uint256 representing the amount owned by the passed address.
140   */
141   function balanceOf(address _owner) public view returns (uint256 balance) {
142     return balances[_owner];
143   }
144 
145 }
146 
147 pragma solidity ^0.4.18;
148 
149 /**
150  * @title Standard ERC20 token
151  *
152  * @dev Implementation of the basic standard token.
153  * @dev https://github.com/ethereum/EIPs/issues/20
154  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
155  */
156 contract StandardToken is ERC20, BasicToken {
157 
158   mapping (address => mapping (address => uint256)) internal allowed;
159 
160 
161   /**
162    * @dev Transfer tokens from one address to another
163    * @param _from address The address which you want to send tokens from
164    * @param _to address The address which you want to transfer to
165    * @param _value uint256 the amount of tokens to be transferred
166    */
167   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
168     require(_to != address(0));
169     require(_value <= balances[_from]);
170     require(_value <= allowed[_from][msg.sender]);
171 
172     balances[_from] = balances[_from].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
175     Transfer(_from, _to, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181    *
182    * Beware that changing an allowance with this method brings the risk that someone may use both the old
183    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
184    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
185    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186    * @param _spender The address which will spend the funds.
187    * @param _value The amount of tokens to be spent.
188    */
189   function approve(address _spender, uint256 _value) public returns (bool) {
190     allowed[msg.sender][_spender] = _value;
191     Approval(msg.sender, _spender, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Function to check the amount of tokens that an owner allowed to a spender.
197    * @param _owner address The address which owns the funds.
198    * @param _spender address The address which will spend the funds.
199    * @return A uint256 specifying the amount of tokens still available for the spender.
200    */
201   function allowance(address _owner, address _spender) public view returns (uint256) {
202     return allowed[_owner][_spender];
203   }
204 
205   /**
206    * @dev Increase the amount of tokens that an owner allowed to a spender.
207    *
208    * approve should be called when allowed[_spender] == 0. To increment
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param _spender The address which will spend the funds.
213    * @param _addedValue The amount of tokens to increase the allowance by.
214    */
215   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
216     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
217     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221   /**
222    * @dev Decrease the amount of tokens that an owner allowed to a spender.
223    *
224    * approve should be called when allowed[_spender] == 0. To decrement
225    * allowed value is better to use this function to avoid 2 calls (and wait until
226    * the first transaction is mined)
227    * From MonolithDAO Token.sol
228    * @param _spender The address which will spend the funds.
229    * @param _subtractedValue The amount of tokens to decrease the allowance by.
230    */
231   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
232     uint oldValue = allowed[msg.sender][_spender];
233     if (_subtractedValue > oldValue) {
234       allowed[msg.sender][_spender] = 0;
235     } else {
236       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
237     }
238     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239     return true;
240   }
241 
242 }
243 
244 pragma solidity ^0.4.18;
245 
246 
247 /**
248  * @title Ownable
249  * @dev The Ownable contract has an owner address, and provides basic authorization control
250  * functions, this simplifies the implementation of "user permissions".
251  */
252 contract Ownable {
253   address public owner;
254 
255 
256   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
257 
258 
259   /**
260    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
261    * account.
262    */
263   function Ownable() public {
264     owner = msg.sender;
265   }
266 
267   /**
268    * @dev Throws if called by any account other than the owner.
269    */
270   modifier onlyOwner() {
271     require(msg.sender == owner);
272     _;
273   }
274 
275   /**
276    * @dev Allows the current owner to transfer control of the contract to a newOwner.
277    * @param newOwner The address to transfer ownership to.
278    */
279   function transferOwnership(address newOwner) public onlyOwner {
280     require(newOwner != address(0));
281     OwnershipTransferred(owner, newOwner);
282     owner = newOwner;
283   }
284 
285 }
286 
287 pragma solidity ^0.4.18;
288 
289 /**
290  * @title Burnable Token
291  * @dev Token that can be irreversibly burned (destroyed).
292  */
293 contract BurnableToken is BasicToken, Ownable {
294 
295   event Burn(address indexed burner, uint256 value);
296 
297   /**
298    * @dev Burns a specific amount of tokens.
299    * @param _value The amount of token to be burned.
300    */
301   function burn(uint256 _value) public onlyOwner {
302     require(_value <= balances[msg.sender]);
303     // no need to require value <= totalSupply, since that would imply the
304     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
305 
306     address burner = msg.sender;
307     balances[burner] = balances[burner].sub(_value);
308     totalSupply_ = totalSupply_.sub(_value);
309     Burn(burner, _value);
310   }
311 }
312 
313 pragma solidity ^0.4.18;
314 
315 contract PewDiePieToken is StandardToken, BurnableToken {
316 
317     string public name;
318     string public symbol;
319     uint256 public constant decimals = 18;
320 
321     uint256 public tokensAvailable;
322     uint256 public tokenPrice;
323     uint256 public ethRate;
324 
325     address public fundsWallet;
326 
327     /**
328      * @dev Contructor that sets token initial and market supply.
329      */
330     function PewDiePieToken(
331         uint256 initialSupply,
332         uint256 marketSupply,
333         string tokenName,
334         string tokenSymbol,
335         uint256 price,
336         uint256 rate
337       ) {
338         totalSupply_ = initialSupply * 10 ** decimals;
339         tokensAvailable = marketSupply * 10 ** decimals;
340         balances[msg.sender] = totalSupply_;
341         name = tokenName;
342         symbol = tokenSymbol;
343 
344         tokenPrice = price;
345         ethRate = rate;
346 
347         fundsWallet = msg.sender;
348     }
349 
350     /**
351     * @dev Fallback function to buy the tokens
352     */
353     function () payable {
354         require(msg.value > 0);
355         buyTokens(msg.sender, msg.value);
356     }
357 
358     function buyTokens(address sender_, uint256 value_)  internal returns (bool){
359         uint256 amount = value_.mul(ethRate).div(tokenPrice);
360         require(balances[fundsWallet].sub(amount) >= tokensAvailable);
361 
362         balances[fundsWallet] = balances[fundsWallet].sub(amount);
363         balances[sender_] = balances[sender_].add(amount);
364 
365         fundsWallet.transfer(value_);
366 
367         Transfer(fundsWallet, sender_, amount);
368         return true;
369     }
370 
371     /**
372     * @dev Setting up token price and ethereum USD rate
373     */
374     function setPriceAndRate (uint256 price, uint256 rate) public onlyOwner {
375         require(price > 0 && rate > 0);
376 
377         tokenPrice = price;
378         ethRate = rate;
379     }
380 
381 }