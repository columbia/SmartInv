1 pragma solidity ^0.4.21;
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
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() public {
35     owner = msg.sender;
36   }
37 
38   /**
39    * @dev Throws if called by any account other than the owner.
40    */
41   modifier onlyOwner() {
42     require(msg.sender == owner);
43     _;
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address newOwner) public onlyOwner {
51     require(newOwner != address(0));
52     emit OwnershipTransferred(owner, newOwner);
53     owner = newOwner;
54   }
55 
56 }
57 
58 
59 
60 
61 
62 
63 
64 
65 
66 
67 
68 
69 
70 
71 /**
72  * @title ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 contract ERC20 is ERC20Basic {
76   function allowance(address owner, address spender) public view returns (uint256);
77   function transferFrom(address from, address to, uint256 value) public returns (bool);
78   function approve(address spender, uint256 value) public returns (bool);
79   event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 /**
83  * @title Basic token
84  * @dev Basic version of StandardToken, with no allowances.
85  */
86 contract BasicToken is ERC20Basic {
87   using SafeMath for uint256;
88 
89   mapping(address => uint256) balances;
90 
91   uint256 totalSupply_;
92 
93   /**
94   * @dev total number of tokens in existence
95   */
96   function totalSupply() public view returns (uint256) {
97     return totalSupply_;
98   }
99 
100   /**
101   * @dev transfer token for a specified address
102   * @param _to The address to transfer to.
103   * @param _value The amount to be transferred.
104   */
105   function transfer(address _to, uint256 _value) public returns (bool) {
106     require(_to != address(0));
107     require(_value <= balances[msg.sender]);
108 
109     balances[msg.sender] = balances[msg.sender].sub(_value);
110     balances[_to] = balances[_to].add(_value);
111     emit Transfer(msg.sender, _to, _value);
112     return true;
113   }
114 
115   /**
116   * @dev Gets the balance of the specified address.
117   * @param _owner The address to query the the balance of.
118   * @return An uint256 representing the amount owned by the passed address.
119   */
120   function balanceOf(address _owner) public view returns (uint256) {
121     return balances[_owner];
122   }
123 
124 }
125 
126 
127 
128 /**
129  * @title Standard ERC20 token
130  *
131  * @dev Implementation of the basic standard token.
132  * @dev https://github.com/ethereum/EIPs/issues/20
133  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
134  */
135 contract StandardToken is ERC20, BasicToken {
136 
137   mapping (address => mapping (address => uint256)) internal allowed;
138 
139 
140   /**
141    * @dev Transfer tokens from one address to another
142    * @param _from address The address which you want to send tokens from
143    * @param _to address The address which you want to transfer to
144    * @param _value uint256 the amount of tokens to be transferred
145    */
146   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
147     require(_to != address(0));
148     require(_value <= balances[_from]);
149     require(_value <= allowed[_from][msg.sender]);
150 
151     balances[_from] = balances[_from].sub(_value);
152     balances[_to] = balances[_to].add(_value);
153     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
154     emit Transfer(_from, _to, _value);
155     return true;
156   }
157 
158   /**
159    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160    *
161    * Beware that changing an allowance with this method brings the risk that someone may use both the old
162    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
163    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
164    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165    * @param _spender The address which will spend the funds.
166    * @param _value The amount of tokens to be spent.
167    */
168   function approve(address _spender, uint256 _value) public returns (bool) {
169     allowed[msg.sender][_spender] = _value;
170     emit Approval(msg.sender, _spender, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Function to check the amount of tokens that an owner allowed to a spender.
176    * @param _owner address The address which owns the funds.
177    * @param _spender address The address which will spend the funds.
178    * @return A uint256 specifying the amount of tokens still available for the spender.
179    */
180   function allowance(address _owner, address _spender) public view returns (uint256) {
181     return allowed[_owner][_spender];
182   }
183 
184   /**
185    * @dev Increase the amount of tokens that an owner allowed to a spender.
186    *
187    * approve should be called when allowed[_spender] == 0. To increment
188    * allowed value is better to use this function to avoid 2 calls (and wait until
189    * the first transaction is mined)
190    * From MonolithDAO Token.sol
191    * @param _spender The address which will spend the funds.
192    * @param _addedValue The amount of tokens to increase the allowance by.
193    */
194   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
195     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
196     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197     return true;
198   }
199 
200   /**
201    * @dev Decrease the amount of tokens that an owner allowed to a spender.
202    *
203    * approve should be called when allowed[_spender] == 0. To decrement
204    * allowed value is better to use this function to avoid 2 calls (and wait until
205    * the first transaction is mined)
206    * From MonolithDAO Token.sol
207    * @param _spender The address which will spend the funds.
208    * @param _subtractedValue The amount of tokens to decrease the allowance by.
209    */
210   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
211     uint oldValue = allowed[msg.sender][_spender];
212     if (_subtractedValue > oldValue) {
213       allowed[msg.sender][_spender] = 0;
214     } else {
215       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
216     }
217     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221 }
222 
223 
224 
225 
226 /**
227  * @title Mintable token
228  * @dev Simple ERC20 Token example, with mintable token creation
229  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
230  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
231  */
232 contract MintableToken is StandardToken, Ownable {
233   event Mint(address indexed to, uint256 amount);
234   event MintFinished();
235 
236   bool public mintingFinished = false;
237 
238 
239   modifier canMint() {
240     require(!mintingFinished);
241     _;
242   }
243 
244   /**
245    * @dev Function to mint tokens
246    * @param _to The address that will receive the minted tokens.
247    * @param _amount The amount of tokens to mint.
248    * @return A boolean that indicates if the operation was successful.
249    */
250   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
251     totalSupply_ = totalSupply_.add(_amount);
252     balances[_to] = balances[_to].add(_amount);
253     emit Mint(_to, _amount);
254     emit Transfer(address(0), _to, _amount);
255     return true;
256   }
257 
258   /**
259    * @dev Function to stop minting new tokens.
260    * @return True if the operation was successful.
261    */
262   function finishMinting() onlyOwner canMint public returns (bool) {
263     mintingFinished = true;
264     emit MintFinished();
265     return true;
266   }
267 }
268 
269 
270 
271 /**
272  * @title Capped token
273  * @dev Mintable token with a token cap.
274  */
275 contract CappedToken is MintableToken {
276 
277   uint256 public cap;
278 
279   function CappedToken(uint256 _cap) public {
280     require(_cap > 0);
281     cap = _cap;
282   }
283 
284   /**
285    * @dev Function to mint tokens
286    * @param _to The address that will receive the minted tokens.
287    * @param _amount The amount of tokens to mint.
288    * @return A boolean that indicates if the operation was successful.
289    */
290   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
291     require(totalSupply_.add(_amount) <= cap);
292 
293     return super.mint(_to, _amount);
294   }
295 
296 }
297 
298 
299 
300 
301 
302 
303 
304 
305 
306 
307 /**
308  * @title SafeMath
309  * @dev Math operations with safety checks that throw on error
310  */
311 library SafeMath {
312 
313   /**
314   * @dev Multiplies two numbers, throws on overflow.
315   */
316   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
317     if (a == 0) {
318       return 0;
319     }
320     c = a * b;
321     assert(c / a == b);
322     return c;
323   }
324 
325   /**
326   * @dev Integer division of two numbers, truncating the quotient.
327   */
328   function div(uint256 a, uint256 b) internal pure returns (uint256) {
329     // assert(b > 0); // Solidity automatically throws when dividing by 0
330     // uint256 c = a / b;
331     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
332     return a / b;
333   }
334 
335   /**
336   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
337   */
338   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
339     assert(b <= a);
340     return a - b;
341   }
342 
343   /**
344   * @dev Adds two numbers, throws on overflow.
345   */
346   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
347     c = a + b;
348     assert(c >= a);
349     return c;
350   }
351 }
352 
353 
354 /**
355  * @title Burnable Token
356  * @dev Token that can be irreversibly burned (destroyed).
357  */
358 contract BurnableToken is BasicToken {
359 
360   event Burn(address indexed burner, uint256 value);
361 
362   /**
363    * @dev Burns a specific amount of tokens.
364    * @param _value The amount of token to be burned.
365    */
366   function burn(uint256 _value) public {
367     _burn(msg.sender, _value);
368   }
369 
370   function _burn(address _who, uint256 _value) internal {
371     require(_value <= balances[_who]);
372     // no need to require value <= totalSupply, since that would imply the
373     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
374 
375     balances[_who] = balances[_who].sub(_value);
376     totalSupply_ = totalSupply_.sub(_value);
377     emit Burn(_who, _value);
378     emit Transfer(_who, address(0), _value);
379   }
380 }
381 
382 
383 //CCH is a capped token with a max supply of 145249999 tokenSupply
384 //It is a burnable token as well
385 contract CareerChainToken is CappedToken(145249999000000000000000000), BurnableToken  {
386     string public name = "CareerChain Token";
387     string public symbol = "CCH";
388     uint8 public decimals = 18;
389 
390     //only the owner is allowed to burn tokens
391     function burn(uint256 _value) public onlyOwner {
392       _burn(msg.sender, _value);
393 
394     }
395 
396 }