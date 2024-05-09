1 pragma solidity ^0.4.24;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 /**
62  * @title ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/20
64  */
65 contract ERC20 is ERC20Basic {
66   function allowance(address owner, address spender) public view returns (uint256);
67   function transferFrom(address from, address to, uint256 value) public returns (bool);
68   function approve(address spender, uint256 value) public returns (bool);
69   event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 /**
73  * @title Ownable
74  * @dev The Ownable contract has an owner address, and provides basic authorization control
75  * functions, this simplifies the implementation of "user permissions".
76  */
77 contract Ownable {
78   address public owner;
79 
80 
81   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83 
84   /**
85    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
86    * account.
87    */
88   function Ownable() public {
89     owner = msg.sender;
90   }
91 
92   /**
93    * @dev Throws if called by any account other than the owner.
94    */
95   modifier onlyOwner() {
96     require(msg.sender == owner);
97     _;
98   }
99 
100   /**
101    * @dev Allows the current owner to transfer control of the contract to a newOwner.
102    * @param newOwner The address to transfer ownership to.
103    */
104   function transferOwnership(address newOwner) public onlyOwner {
105     require(newOwner != address(0));
106     emit OwnershipTransferred(owner, newOwner);
107     owner = newOwner;
108   }
109 
110 }
111 
112 /**
113  * @title Pausable
114  * @dev Base contract which allows children to implement an emergency stop mechanism.
115  */
116 contract Pausable is Ownable {
117   event Pause();
118   event Unpause();
119 
120   bool public paused = false;
121 
122 
123   /**
124    * @dev Modifier to make a function callable only when the contract is not paused.
125    */
126   modifier whenNotPaused() {
127     require(!paused);
128     _;
129   }
130 
131   /**
132    * @dev Modifier to make a function callable only when the contract is paused.
133    */
134   modifier whenPaused() {
135     require(paused);
136     _;
137   }
138 
139   /**
140    * @dev called by the owner to pause, triggers stopped state
141    */
142   function pause() onlyOwner whenNotPaused public {
143     paused = true;
144     emit Pause();
145   }
146 
147   /**
148    * @dev called by the owner to unpause, returns to normal state
149    */
150   function unpause() onlyOwner whenPaused public {
151     paused = false;
152     emit Unpause();
153   }
154 }
155 
156 /**
157  * @title Basic token
158  * @dev Basic version of StandardToken, with no allowances.
159  */
160 contract BasicToken is ERC20Basic {
161   using SafeMath for uint256;
162 
163   mapping(address => uint256) balances;
164 
165   uint256 totalSupply_;
166 
167   /**
168   * @dev total number of tokens in existence
169   */
170   function totalSupply() public view returns (uint256) {
171     return totalSupply_;
172   }
173 
174   /**
175   * @dev transfer token for a specified address
176   * @param _to The address to transfer to.
177   * @param _value The amount to be transferred.
178   */
179   function transfer(address _to, uint256 _value) public returns (bool) {
180     require(_to != address(0));
181     require(_value <= balances[msg.sender]);
182 
183     balances[msg.sender] = balances[msg.sender].sub(_value);
184     balances[_to] = balances[_to].add(_value);
185     emit Transfer(msg.sender, _to, _value);
186     return true;
187   }
188 
189   /**
190   * @dev Gets the balance of the specified address.
191   * @param _owner The address to query the the balance of.
192   * @return An uint256 representing the amount owned by the passed address.
193   */
194   function balanceOf(address _owner) public view returns (uint256) {
195     return balances[_owner];
196   }
197 
198 }
199 /**
200  * @title Standard ERC20 token
201  *
202  * @dev Implementation of the basic standard token.
203  * @dev https://github.com/ethereum/EIPs/issues/20
204  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
205  */
206 contract StandardToken is ERC20, BasicToken {
207 
208   mapping (address => mapping (address => uint256)) internal allowed;
209 
210 
211   /**
212    * @dev Transfer tokens from one address to another
213    * @param _from address The address which you want to send tokens from
214    * @param _to address The address which you want to transfer to
215    * @param _value uint256 the amount of tokens to be transferred
216    */
217   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
218     require(_to != address(0));
219     require(_value <= balances[_from]);
220     require(_value <= allowed[_from][msg.sender]);
221 
222     balances[_from] = balances[_from].sub(_value);
223     balances[_to] = balances[_to].add(_value);
224     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
225     emit Transfer(_from, _to, _value);
226     return true;
227   }
228 
229   /**
230    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
231    *
232    * Beware that changing an allowance with this method brings the risk that someone may use both the old
233    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
234    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
235    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
236    * @param _spender The address which will spend the funds.
237    * @param _value The amount of tokens to be spent.
238    */
239   function approve(address _spender, uint256 _value) public returns (bool) {
240     allowed[msg.sender][_spender] = _value;
241     emit Approval(msg.sender, _spender, _value);
242     return true;
243   }
244 
245   /**
246    * @dev Function to check the amount of tokens that an owner allowed to a spender.
247    * @param _owner address The address which owns the funds.
248    * @param _spender address The address which will spend the funds.
249    * @return A uint256 specifying the amount of tokens still available for the spender.
250    */
251   function allowance(address _owner, address _spender) public view returns (uint256) {
252     return allowed[_owner][_spender];
253   }
254 
255   /**
256    * @dev Increase the amount of tokens that an owner allowed to a spender.
257    *
258    * approve should be called when allowed[_spender] == 0. To increment
259    * allowed value is better to use this function to avoid 2 calls (and wait until
260    * the first transaction is mined)
261    * From MonolithDAO Token.sol
262    * @param _spender The address which will spend the funds.
263    * @param _addedValue The amount of tokens to increase the allowance by.
264    */
265   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
266     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
267     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
268     return true;
269   }
270 
271   /**
272    * @dev Decrease the amount of tokens that an owner allowed to a spender.
273    *
274    * approve should be called when allowed[_spender] == 0. To decrement
275    * allowed value is better to use this function to avoid 2 calls (and wait until
276    * the first transaction is mined)
277    * From MonolithDAO Token.sol
278    * @param _spender The address which will spend the funds.
279    * @param _subtractedValue The amount of tokens to decrease the allowance by.
280    */
281   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
282     uint oldValue = allowed[msg.sender][_spender];
283     if (_subtractedValue > oldValue) {
284       allowed[msg.sender][_spender] = 0;
285     } else {
286       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
287     }
288     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
289     return true;
290   }
291 
292 }
293 
294 /**
295  * @title Mintable token
296  * @dev Simple ERC20 Token example, with mintable token creation
297  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
298  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
299  */
300 contract MintableToken is StandardToken, Ownable {
301   event Mint(address indexed to, uint256 amount);
302   event MintFinished();
303 
304   bool public mintingFinished = false;
305 
306 
307   modifier canMint() {
308     require(!mintingFinished);
309     _;
310   }
311 
312   /**
313    * @dev Function to mint tokens
314    * @param _to The address that will receive the minted tokens.
315    * @param _amount The amount of tokens to mint.
316    * @return A boolean that indicates if the operation was successful.
317    */
318   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
319     totalSupply_ = totalSupply_.add(_amount);
320     balances[_to] = balances[_to].add(_amount);
321     emit Mint(_to, _amount);
322     emit Transfer(address(0), _to, _amount);
323     return true;
324   }
325 
326   /**
327    * @dev Function to stop minting new tokens.
328    * @return True if the operation was successful.
329    */
330   function finishMinting() onlyOwner canMint public returns (bool) {
331     mintingFinished = true;
332     emit MintFinished();
333     return true;
334   }
335 }
336 
337 
338 contract PausableToken is StandardToken, Pausable {
339 
340   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
341     return super.transfer(_to, _value);
342   }
343 
344   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
345     return super.transferFrom(_from, _to, _value);
346   }
347 
348   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
349     return super.approve(_spender, _value);
350   }
351 
352   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
353     return super.increaseApproval(_spender, _addedValue);
354   }
355 
356   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
357     return super.decreaseApproval(_spender, _subtractedValue);
358   }
359 }
360 
361 contract MedXToken is PausableToken, MintableToken {
362   string public name = "MEDX TOKEN";
363   string public symbol = "MEDX";
364   uint256 public decimals = 8;
365 }