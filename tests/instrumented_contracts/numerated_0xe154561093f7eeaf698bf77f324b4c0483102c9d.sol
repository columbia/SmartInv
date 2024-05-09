1 pragma solidity ^0.4.19;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
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
51 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   function Ownable() public {
70     owner = msg.sender;
71   }
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) public onlyOwner {
86     require(newOwner != address(0));
87     OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91 }
92 
93 // File: contracts/SkillChainContributions.sol
94 
95 // File: contracts/ApproveAndCallFallBack.sol
96 
97 contract ApproveAndCallFallBack {
98     function receiveApproval(
99         address from,
100         uint256 tokens,
101         address token,
102         bytes data) public;
103 }
104 
105 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
106 
107 /**
108  * @title ERC20Basic
109  * @dev Simpler version of ERC20 interface
110  * @dev see https://github.com/ethereum/EIPs/issues/179
111  */
112 contract ERC20Basic {
113   function totalSupply() public view returns (uint256);
114   function balanceOf(address who) public view returns (uint256);
115   function transfer(address to, uint256 value) public returns (bool);
116   event Transfer(address indexed from, address indexed to, uint256 value);
117 }
118 
119 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
120 
121 /**
122  * @title Basic token
123  * @dev Basic version of StandardToken, with no allowances.
124  */
125 contract BasicToken is ERC20Basic {
126   using SafeMath for uint256;
127 
128   mapping(address => uint256) balances;
129 
130   uint256 totalSupply_;
131 
132   /**
133   * @dev total number of tokens in existence
134   */
135   function totalSupply() public view returns (uint256) {
136     return totalSupply_;
137   }
138 
139   /**
140   * @dev transfer token for a specified address
141   * @param _to The address to transfer to.
142   * @param _value The amount to be transferred.
143   */
144   function transfer(address _to, uint256 _value) public returns (bool) {
145     require(_to != address(0));
146     require(_value <= balances[msg.sender]);
147 
148     // SafeMath.sub will throw if there is not enough balance.
149     balances[msg.sender] = balances[msg.sender].sub(_value);
150     balances[_to] = balances[_to].add(_value);
151     Transfer(msg.sender, _to, _value);
152     return true;
153   }
154 
155   /**
156   * @dev Gets the balance of the specified address.
157   * @param _owner The address to query the the balance of.
158   * @return An uint256 representing the amount owned by the passed address.
159   */
160   function balanceOf(address _owner) public view returns (uint256 balance) {
161     return balances[_owner];
162   }
163 
164 }
165 
166 // File: zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
167 
168 /**
169  * @title Burnable Token
170  * @dev Token that can be irreversibly burned (destroyed).
171  */
172 contract BurnableToken is BasicToken {
173 
174   event Burn(address indexed burner, uint256 value);
175 
176   /**
177    * @dev Burns a specific amount of tokens.
178    * @param _value The amount of token to be burned.
179    */
180   function burn(uint256 _value) public {
181     require(_value <= balances[msg.sender]);
182     // no need to require value <= totalSupply, since that would imply the
183     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
184 
185     address burner = msg.sender;
186     balances[burner] = balances[burner].sub(_value);
187     totalSupply_ = totalSupply_.sub(_value);
188     Burn(burner, _value);
189   }
190 }
191 
192 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
193 
194 /**
195  * @title ERC20 interface
196  * @dev see https://github.com/ethereum/EIPs/issues/20
197  */
198 contract ERC20 is ERC20Basic {
199   function allowance(address owner, address spender) public view returns (uint256);
200   function transferFrom(address from, address to, uint256 value) public returns (bool);
201   function approve(address spender, uint256 value) public returns (bool);
202   event Approval(address indexed owner, address indexed spender, uint256 value);
203 }
204 
205 // File: zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
206 
207 contract DetailedERC20 is ERC20 {
208   string public name;
209   string public symbol;
210   uint8 public decimals;
211 
212   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
213     name = _name;
214     symbol = _symbol;
215     decimals = _decimals;
216   }
217 }
218 
219 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
220 
221 /**
222  * @title Standard ERC20 token
223  *
224  * @dev Implementation of the basic standard token.
225  * @dev https://github.com/ethereum/EIPs/issues/20
226  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
227  */
228 contract StandardToken is ERC20, BasicToken {
229 
230   mapping (address => mapping (address => uint256)) internal allowed;
231 
232 
233   /**
234    * @dev Transfer tokens from one address to another
235    * @param _from address The address which you want to send tokens from
236    * @param _to address The address which you want to transfer to
237    * @param _value uint256 the amount of tokens to be transferred
238    */
239   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
240     require(_to != address(0));
241     require(_value <= balances[_from]);
242     require(_value <= allowed[_from][msg.sender]);
243 
244     balances[_from] = balances[_from].sub(_value);
245     balances[_to] = balances[_to].add(_value);
246     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
247     Transfer(_from, _to, _value);
248     return true;
249   }
250 
251   /**
252    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
253    *
254    * Beware that changing an allowance with this method brings the risk that someone may use both the old
255    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
256    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
257    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
258    * @param _spender The address which will spend the funds.
259    * @param _value The amount of tokens to be spent.
260    */
261   function approve(address _spender, uint256 _value) public returns (bool) {
262     allowed[msg.sender][_spender] = _value;
263     Approval(msg.sender, _spender, _value);
264     return true;
265   }
266 
267   /**
268    * @dev Function to check the amount of tokens that an owner allowed to a spender.
269    * @param _owner address The address which owns the funds.
270    * @param _spender address The address which will spend the funds.
271    * @return A uint256 specifying the amount of tokens still available for the spender.
272    */
273   function allowance(address _owner, address _spender) public view returns (uint256) {
274     return allowed[_owner][_spender];
275   }
276 
277   /**
278    * @dev Increase the amount of tokens that an owner allowed to a spender.
279    *
280    * approve should be called when allowed[_spender] == 0. To increment
281    * allowed value is better to use this function to avoid 2 calls (and wait until
282    * the first transaction is mined)
283    * From MonolithDAO Token.sol
284    * @param _spender The address which will spend the funds.
285    * @param _addedValue The amount of tokens to increase the allowance by.
286    */
287   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
288     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
289     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
290     return true;
291   }
292 
293   /**
294    * @dev Decrease the amount of tokens that an owner allowed to a spender.
295    *
296    * approve should be called when allowed[_spender] == 0. To decrement
297    * allowed value is better to use this function to avoid 2 calls (and wait until
298    * the first transaction is mined)
299    * From MonolithDAO Token.sol
300    * @param _spender The address which will spend the funds.
301    * @param _subtractedValue The amount of tokens to decrease the allowance by.
302    */
303   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
304     uint oldValue = allowed[msg.sender][_spender];
305     if (_subtractedValue > oldValue) {
306       allowed[msg.sender][_spender] = 0;
307     } else {
308       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
309     }
310     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
311     return true;
312   }
313 
314 }
315 
316 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
317 
318 /**
319  * @title Mintable token
320  * @dev Simple ERC20 Token example, with mintable token creation
321  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
322  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
323  */
324 
325 
326 // File: contracts/SkillChainToken.sol
327 
328 contract CoinStocker is DetailedERC20, StandardToken, BurnableToken, Ownable  {
329 
330     uint public rate = 20000;
331 
332     function CoinStocker() DetailedERC20("CoinStocker", "CSR", 18) Ownable public {
333       balances[this] = 1000000000 * 10 ** 18;
334       totalSupply_ =  1000000000 * 10 ** 18;
335     }
336 
337     function transfer(address _to, uint _value)  public returns (bool) {
338         return super.transfer(_to, _value);
339     }
340 
341     function transferFrom(address _from, address _to, uint _value)  public returns (bool) {
342         return super.transferFrom(_from, _to, _value);
343     }
344 
345     function () external payable {
346       buyTokens(msg.sender);
347     }
348 
349   // low level token purchase function
350     function buyTokens(address beneficiary) public payable {
351       require(beneficiary != address(0));
352 
353       uint256 weiAmount = msg.value;
354 
355     // calculate token amount to be created
356       uint256 tokens = getTokenAmount(weiAmount);
357 
358       require(tokens < balances[this]);
359       balances[this] = balances[this].sub(tokens);
360       balances[beneficiary] = balances[beneficiary].add(tokens);
361     }
362 
363     function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
364       return weiAmount.mul(rate);
365     }
366     
367     function setRate(uint256 r) onlyOwner public {
368         rate = r;
369     }
370 
371     function transferAnyERC20Token(address _tokenAddress, uint256 _tokens) onlyOwner public returns (bool success) {
372         return ERC20Basic(_tokenAddress).transfer(owner, _tokens);
373     }
374     
375     function get_back() onlyOwner public {
376         owner.transfer(this.balance);
377     }
378 }