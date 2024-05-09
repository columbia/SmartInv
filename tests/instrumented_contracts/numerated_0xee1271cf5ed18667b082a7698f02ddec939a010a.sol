1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * openzeppelin-solidity@1.9.0/contracts/math/SafeMath.sol
6  */
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 
14   /**
15   * @dev Multiplies two numbers, throws on overflow.
16   */
17   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
18     if (a == 0) {
19       return 0;
20     }
21     c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return a / b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48     c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 
55 /**
56  * openzeppelin-solidity@1.9.0/contracts/ownership/Ownable.sol
57  */
58 
59 /**
60  * @title Ownable
61  * @dev The Ownable contract has an owner address, and provides basic authorization control
62  * functions, this simplifies the implementation of "user permissions".
63  */
64 contract Ownable {
65   address public owner;
66 
67 
68   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70 
71   /**
72    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
73    * account.
74    */
75   function Ownable() public {
76     owner = msg.sender;
77   }
78 
79   /**
80    * @dev Throws if called by any account other than the owner.
81    */
82   modifier onlyOwner() {
83     require(msg.sender == owner);
84     _;
85   }
86 
87   /**
88    * @dev Allows the current owner to transfer control of the contract to a newOwner.
89    * @param newOwner The address to transfer ownership to.
90    */
91   function transferOwnership(address newOwner) public onlyOwner {
92     require(newOwner != address(0));
93     emit OwnershipTransferred(owner, newOwner);
94     owner = newOwner;
95   }
96 
97 }
98 
99 
100 /**
101  * openzeppelin-solidity@1.9.0/contracts/token/ERC20/ERC20Basic.sol
102  */
103 
104 /**
105  * @title ERC20Basic
106  * @dev Simpler version of ERC20 interface
107  * @dev see https://github.com/ethereum/EIPs/issues/179
108  */
109 contract ERC20Basic {
110   function totalSupply() public view returns (uint256);
111   function balanceOf(address who) public view returns (uint256);
112   function transfer(address to, uint256 value) public returns (bool);
113   event Transfer(address indexed from, address indexed to, uint256 value);
114 }
115 
116 
117 /**
118  * openzeppelin-solidity@1.9.0/contracts/token/ERC20/ERC20.sol
119  */
120 
121 /**
122  * @title ERC20 interface
123  * @dev see https://github.com/ethereum/EIPs/issues/20
124  */
125 contract ERC20 is ERC20Basic {
126   function allowance(address owner, address spender) public view returns (uint256);
127   function transferFrom(address from, address to, uint256 value) public returns (bool);
128   function approve(address spender, uint256 value) public returns (bool);
129   event Approval(address indexed owner, address indexed spender, uint256 value);
130 }
131 
132 
133 /**
134  * openzeppelin-solidity@1.9.0/contracts/token/ERC20/BasicToken.sol
135  */
136 
137 /**
138  * @title Basic token
139  * @dev Basic version of StandardToken, with no allowances.
140  */
141 contract BasicToken is ERC20Basic {
142   using SafeMath for uint256;
143 
144   mapping(address => uint256) balances;
145 
146   uint256 totalSupply_;
147 
148   /**
149   * @dev total number of tokens in existence
150   */
151   function totalSupply() public view returns (uint256) {
152     return totalSupply_;
153   }
154 
155   /**
156   * @dev transfer token for a specified address
157   * @param _to The address to transfer to.
158   * @param _value The amount to be transferred.
159   */
160   function transfer(address _to, uint256 _value) public returns (bool) {
161     require(_to != address(0));
162     require(_value <= balances[msg.sender]);
163 
164     balances[msg.sender] = balances[msg.sender].sub(_value);
165     balances[_to] = balances[_to].add(_value);
166     emit Transfer(msg.sender, _to, _value);
167     return true;
168   }
169 
170   /**
171   * @dev Gets the balance of the specified address.
172   * @param _owner The address to query the the balance of.
173   * @return An uint256 representing the amount owned by the passed address.
174   */
175   function balanceOf(address _owner) public view returns (uint256) {
176     return balances[_owner];
177   }
178 
179 }
180 
181 
182 /**
183  * openzeppelin-solidity@1.9.0/contracts/token/ERC20/StandardToken.sol
184  */
185 
186 /**
187  * @title Standard ERC20 token
188  *
189  * @dev Implementation of the basic standard token.
190  * @dev https://github.com/ethereum/EIPs/issues/20
191  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
192  */
193 contract StandardToken is ERC20, BasicToken {
194 
195   mapping (address => mapping (address => uint256)) internal allowed;
196 
197 
198   /**
199    * @dev Transfer tokens from one address to another
200    * @param _from address The address which you want to send tokens from
201    * @param _to address The address which you want to transfer to
202    * @param _value uint256 the amount of tokens to be transferred
203    */
204   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
205     require(_to != address(0));
206     require(_value <= balances[_from]);
207     require(_value <= allowed[_from][msg.sender]);
208 
209     balances[_from] = balances[_from].sub(_value);
210     balances[_to] = balances[_to].add(_value);
211     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
212     emit Transfer(_from, _to, _value);
213     return true;
214   }
215 
216   /**
217    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
218    *
219    * Beware that changing an allowance with this method brings the risk that someone may use both the old
220    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
221    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
222    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
223    * @param _spender The address which will spend the funds.
224    * @param _value The amount of tokens to be spent.
225    */
226   function approve(address _spender, uint256 _value) public returns (bool) {
227     allowed[msg.sender][_spender] = _value;
228     emit Approval(msg.sender, _spender, _value);
229     return true;
230   }
231 
232   /**
233    * @dev Function to check the amount of tokens that an owner allowed to a spender.
234    * @param _owner address The address which owns the funds.
235    * @param _spender address The address which will spend the funds.
236    * @return A uint256 specifying the amount of tokens still available for the spender.
237    */
238   function allowance(address _owner, address _spender) public view returns (uint256) {
239     return allowed[_owner][_spender];
240   }
241 
242   /**
243    * @dev Increase the amount of tokens that an owner allowed to a spender.
244    *
245    * approve should be called when allowed[_spender] == 0. To increment
246    * allowed value is better to use this function to avoid 2 calls (and wait until
247    * the first transaction is mined)
248    * From MonolithDAO Token.sol
249    * @param _spender The address which will spend the funds.
250    * @param _addedValue The amount of tokens to increase the allowance by.
251    */
252   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
253     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
254     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255     return true;
256   }
257 
258   /**
259    * @dev Decrease the amount of tokens that an owner allowed to a spender.
260    *
261    * approve should be called when allowed[_spender] == 0. To decrement
262    * allowed value is better to use this function to avoid 2 calls (and wait until
263    * the first transaction is mined)
264    * From MonolithDAO Token.sol
265    * @param _spender The address which will spend the funds.
266    * @param _subtractedValue The amount of tokens to decrease the allowance by.
267    */
268   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
269     uint oldValue = allowed[msg.sender][_spender];
270     if (_subtractedValue > oldValue) {
271       allowed[msg.sender][_spender] = 0;
272     } else {
273       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
274     }
275     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
276     return true;
277   }
278 
279 }
280 
281 
282 /**
283  * openzeppelin-solidity@1.9.0/contracts/token/ERC20/BurnableToken.sol
284  */
285 
286 /**
287  * @title Burnable Token
288  * @dev Token that can be irreversibly burned (destroyed).
289  */
290 contract BurnableToken is BasicToken {
291 
292   event Burn(address indexed burner, uint256 value);
293 
294   /**
295    * @dev Burns a specific amount of tokens.
296    * @param _value The amount of token to be burned.
297    */
298   function burn(uint256 _value) public {
299     _burn(msg.sender, _value);
300   }
301 
302   function _burn(address _who, uint256 _value) internal {
303     require(_value <= balances[_who]);
304     // no need to require value <= totalSupply, since that would imply the
305     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
306 
307     balances[_who] = balances[_who].sub(_value);
308     totalSupply_ = totalSupply_.sub(_value);
309     emit Burn(_who, _value);
310     emit Transfer(_who, address(0), _value);
311   }
312 }
313 
314 
315 /**
316  * openzeppelin-solidity@1.9.0/contracts/token/ERC20/MintableToken.sol
317  */
318 
319 /**
320  * @title Mintable token
321  * @dev Simple ERC20 Token example, with mintable token creation
322  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
323  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
324  */
325 contract MintableToken is StandardToken, Ownable {
326   event Mint(address indexed to, uint256 amount);
327   event MintFinished();
328 
329   bool public mintingFinished = false;
330 
331 
332   modifier canMint() {
333     require(!mintingFinished);
334     _;
335   }
336 
337   /**
338    * @dev Function to mint tokens
339    * @param _to The address that will receive the minted tokens.
340    * @param _amount The amount of tokens to mint.
341    * @return A boolean that indicates if the operation was successful.
342    */
343   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
344     totalSupply_ = totalSupply_.add(_amount);
345     balances[_to] = balances[_to].add(_amount);
346     emit Mint(_to, _amount);
347     emit Transfer(address(0), _to, _amount);
348     return true;
349   }
350 
351   /**
352    * @dev Function to stop minting new tokens.
353    * @return True if the operation was successful.
354    */
355   function finishMinting() onlyOwner canMint public returns (bool) {
356     mintingFinished = true;
357     emit MintFinished();
358     return true;
359   }
360 }
361 
362 
363 /**
364  * openzeppelin-solidity@1.9.0/contracts/token/ERC20/CappedToken.sol
365  */
366 
367 /**
368  * @title Capped token
369  * @dev Mintable token with a token cap.
370  */
371 contract CappedToken is MintableToken {
372 
373   uint256 public cap;
374 
375   function CappedToken(uint256 _cap) public {
376     require(_cap > 0);
377     cap = _cap;
378   }
379 
380   /**
381    * @dev Function to mint tokens
382    * @param _to The address that will receive the minted tokens.
383    * @param _amount The amount of tokens to mint.
384    * @return A boolean that indicates if the operation was successful.
385    */
386   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
387     require(totalSupply_.add(_amount) <= cap);
388 
389     return super.mint(_to, _amount);
390   }
391 
392 }
393 
394 
395 /**
396  * DNC Token, totalSupply 90000000000000000000000000
397  */
398 contract DataStorageTraceability is BurnableToken, CappedToken(90000000000000000000000000) {
399     string public name = "Data Storage Traceability";
400     string public symbol = "DAY";
401     uint8 public decimals = 8;
402     uint256 public totalSupply = 100000000000000000;
403 
404     function burn(uint256 _value) onlyOwner public {
405         super.burn(_value);
406     }
407 }