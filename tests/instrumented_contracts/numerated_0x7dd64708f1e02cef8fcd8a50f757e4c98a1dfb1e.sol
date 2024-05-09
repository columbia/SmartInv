1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56   function totalSupply() public view returns (uint256);
57   function balanceOf(address who) public view returns (uint256);
58   function transfer(address to, uint256 value) public returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 
63 /**
64  * @title Basic token
65  * @dev Basic version of StandardToken, with no allowances.
66  */
67 contract BasicToken is ERC20Basic {
68   using SafeMath for uint256;
69 
70   mapping(address => uint256) balances;
71 
72   uint256 totalSupply_;
73 
74   /**
75   * @dev total number of tokens in existence
76   */
77   function totalSupply() public view returns (uint256) {
78     return totalSupply_;
79   }
80 
81   /**
82   * @dev transfer token for a specified address
83   * @param _to The address to transfer to.
84   * @param _value The amount to be transferred.
85   */
86   function transfer(address _to, uint256 _value) public returns (bool) {
87     require(_to != address(0));
88     require(_value <= balances[msg.sender]);
89 
90     // SafeMath.sub will throw if there is not enough balance.
91     balances[msg.sender] = balances[msg.sender].sub(_value);
92     balances[_to] = balances[_to].add(_value);
93     Transfer(msg.sender, _to, _value);
94     return true;
95   }
96 
97   /**
98   * @dev Gets the balance of the specified address.
99   * @param _owner The address to query the the balance of.
100   * @return An uint256 representing the amount owned by the passed address.
101   */
102   function balanceOf(address _owner) public view returns (uint256 balance) {
103     return balances[_owner];
104   }
105 
106 }
107 
108 
109 /**
110  * @title Burnable Token
111  * @dev Token that can be irreversibly burned (destroyed).
112  */
113 contract BurnableToken is BasicToken {
114 
115   event Burn(address indexed burner, uint256 value);
116 
117   /**
118    * @dev Burns a specific amount of tokens.
119    * @param _value The amount of token to be burned.
120    */
121   function burn(uint256 _value) public {
122     require(_value <= balances[msg.sender]);
123     // no need to require value <= totalSupply, since that would imply the
124     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
125 
126     address burner = msg.sender;
127     balances[burner] = balances[burner].sub(_value);
128     totalSupply_ = totalSupply_.sub(_value);
129     Burn(burner, _value);
130   }
131 }
132 
133 
134 /**
135  * @title Ownable
136  * @dev The Ownable contract has an owner address, and provides basic authorization control
137  * functions, this simplifies the implementation of "user permissions".
138  */
139 contract Ownable {
140   address public owner;
141 
142 
143   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
144 
145 
146   /**
147    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
148    * account.
149    */
150   function Ownable() public {
151     owner = msg.sender;
152   }
153 
154   /**
155    * @dev Throws if called by any account other than the owner.
156    */
157   modifier onlyOwner() {
158     require(msg.sender == owner);
159     _;
160   }
161 
162   /**
163    * @dev Allows the current owner to transfer control of the contract to a newOwner.
164    * @param newOwner The address to transfer ownership to.
165    */
166   function transferOwnership(address newOwner) public onlyOwner {
167     require(newOwner != address(0));
168     OwnershipTransferred(owner, newOwner);
169     owner = newOwner;
170   }
171 
172 }
173 
174 
175 /**
176  * @title ERC20 interface
177  * @dev see https://github.com/ethereum/EIPs/issues/20
178  */
179 contract ERC20 is ERC20Basic {
180   function allowance(address owner, address spender) public view returns (uint256);
181   function transferFrom(address from, address to, uint256 value) public returns (bool);
182   function approve(address spender, uint256 value) public returns (bool);
183   event Approval(address indexed owner, address indexed spender, uint256 value);
184 }
185 
186 
187 /**
188  * @title Standard ERC20 token
189  *
190  * @dev Implementation of the basic standard token.
191  * @dev https://github.com/ethereum/EIPs/issues/20
192  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
193  */
194 contract StandardToken is ERC20, BasicToken {
195 
196   mapping (address => mapping (address => uint256)) internal allowed;
197 
198 
199   /**
200    * @dev Transfer tokens from one address to another
201    * @param _from address The address which you want to send tokens from
202    * @param _to address The address which you want to transfer to
203    * @param _value uint256 the amount of tokens to be transferred
204    */
205   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
206     require(_to != address(0));
207     require(_value <= balances[_from]);
208     require(_value <= allowed[_from][msg.sender]);
209 
210     balances[_from] = balances[_from].sub(_value);
211     balances[_to] = balances[_to].add(_value);
212     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
213     Transfer(_from, _to, _value);
214     return true;
215   }
216 
217   /**
218    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
219    *
220    * Beware that changing an allowance with this method brings the risk that someone may use both the old
221    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
222    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
223    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
224    * @param _spender The address which will spend the funds.
225    * @param _value The amount of tokens to be spent.
226    */
227   function approve(address _spender, uint256 _value) public returns (bool) {
228     allowed[msg.sender][_spender] = _value;
229     Approval(msg.sender, _spender, _value);
230     return true;
231   }
232 
233   /**
234    * @dev Function to check the amount of tokens that an owner allowed to a spender.
235    * @param _owner address The address which owns the funds.
236    * @param _spender address The address which will spend the funds.
237    * @return A uint256 specifying the amount of tokens still available for the spender.
238    */
239   function allowance(address _owner, address _spender) public view returns (uint256) {
240     return allowed[_owner][_spender];
241   }
242 
243   /**
244    * @dev Increase the amount of tokens that an owner allowed to a spender.
245    *
246    * approve should be called when allowed[_spender] == 0. To increment
247    * allowed value is better to use this function to avoid 2 calls (and wait until
248    * the first transaction is mined)
249    * From MonolithDAO Token.sol
250    * @param _spender The address which will spend the funds.
251    * @param _addedValue The amount of tokens to increase the allowance by.
252    */
253   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
254     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
255     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
256     return true;
257   }
258 
259   /**
260    * @dev Decrease the amount of tokens that an owner allowed to a spender.
261    *
262    * approve should be called when allowed[_spender] == 0. To decrement
263    * allowed value is better to use this function to avoid 2 calls (and wait until
264    * the first transaction is mined)
265    * From MonolithDAO Token.sol
266    * @param _spender The address which will spend the funds.
267    * @param _subtractedValue The amount of tokens to decrease the allowance by.
268    */
269   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
270     uint oldValue = allowed[msg.sender][_spender];
271     if (_subtractedValue > oldValue) {
272       allowed[msg.sender][_spender] = 0;
273     } else {
274       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
275     }
276     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
277     return true;
278   }
279 
280 }
281 
282 
283 /**
284  * @title Mintable token
285  * @dev Simple ERC20 Token example, with mintable token creation
286  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
287  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
288  */
289 contract MintableToken is StandardToken, Ownable {
290   event Mint(address indexed to, uint256 amount);
291   event MintFinished();
292 
293   bool public mintingFinished = false;
294 
295 
296   modifier canMint() {
297     require(!mintingFinished);
298     _;
299   }
300 
301   /**
302    * @dev Function to mint tokens
303    * @param _to The address that will receive the minted tokens.
304    * @param _amount The amount of tokens to mint.
305    * @return A boolean that indicates if the operation was successful.
306    */
307   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
308     totalSupply_ = totalSupply_.add(_amount);
309     balances[_to] = balances[_to].add(_amount);
310     Mint(_to, _amount);
311     Transfer(address(0), _to, _amount);
312     return true;
313   }
314 
315   /**
316    * @dev Function to stop minting new tokens.
317    * @return True if the operation was successful.
318    */
319   function finishMinting() onlyOwner canMint public returns (bool) {
320     mintingFinished = true;
321     MintFinished();
322     return true;
323   }
324 }
325 
326 
327 
328 /**
329  * @title Capped token
330  * @dev Mintable token with a token cap.
331  */
332 contract CappedToken is MintableToken {
333 
334   uint256 public cap;
335 
336   function CappedToken(uint256 _cap) public {
337     require(_cap > 0);
338     cap = _cap;
339   }
340 
341   /**
342    * @dev Function to mint tokens
343    * @param _to The address that will receive the minted tokens.
344    * @param _amount The amount of tokens to mint.
345    * @return A boolean that indicates if the operation was successful.
346    */
347   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
348     require(totalSupply_.add(_amount) <= cap);
349 
350     return super.mint(_to, _amount);
351   }
352 
353 }
354 
355 
356 contract DetailedERC20 is ERC20 {
357   string public name;
358   string public symbol;
359   uint8 public decimals;
360 
361   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
362     name = _name;
363     symbol = _symbol;
364     decimals = _decimals;
365   }
366 }
367 
368 
369 contract CarToken is DetailedERC20, StandardToken, BurnableToken, CappedToken {
370   /**
371    * @dev Set the maximum issuance cap and token details.
372    */
373   function CarToken()
374     DetailedERC20('CarBlock', 'CAR', 18)
375     CappedToken(1.8 * (10**9) * (10**18))
376   public {
377 
378   }
379 }