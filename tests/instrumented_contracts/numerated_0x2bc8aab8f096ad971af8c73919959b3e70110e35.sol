1 pragma solidity ^0.4.18;
2 
3 
4 /**besed on  OpenZeppelin**/
5 /**gutalik team 1.0v**/
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     if (a == 0) {
13       return 0;
14     }
15     uint256 c = a * b;
16     assert(c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 
39 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
40 
41 /**
42  * @title ERC20Basic
43  * @dev Simpler version of ERC20 interface
44  * @dev see https://github.com/ethereum/EIPs/issues/179
45  */
46 contract ERC20Basic {
47   uint256 public totalSupply;
48   function balanceOf(address who) public view returns (uint256);
49   function transfer(address to, uint256 value) public returns (bool);
50   event Transfer(address indexed from, address indexed to, uint256 value);
51 }
52 
53 // File: zeppelin-solidity/contracts/token/BasicToken.sol
54 
55 /**
56  * @title Basic token
57  * @dev Basic version of StandardToken, with no allowances.
58  */
59 contract BasicToken is ERC20Basic {
60   using SafeMath for uint256;
61 
62   mapping(address => uint256) balances;
63   mapping(address => bool) internal locks;
64   mapping(address => mapping(address => uint256)) internal allowed;
65 
66   /**
67   * @dev transfer token for a specified address
68   * @param _to The address to transfer to.
69   * @param _value The amount to be transferred.
70   */
71   function transfer(address _to, uint256 _value) public returns (bool) {
72     require(_to != address(0));
73     require(_value <= balances[msg.sender]);
74 
75     // SafeMath.sub will throw if there is not enough balance.
76     balances[msg.sender] = balances[msg.sender].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     Transfer(msg.sender, _to, _value);
79     return true;
80   }
81 
82   /**
83   * @dev Gets the balance of the specified address.
84   * @param _owner The address to query the the balance of.
85   * @return An uint256 representing the amount owned by the passed address.
86   */
87   function balanceOf(address _owner) public view returns (uint256 balance) {
88     return balances[_owner];
89   }
90   
91 
92 }
93 
94 // File: zeppelin-solidity/contracts/token/BurnableToken.sol
95 
96 /**
97  * @title Burnable Token
98  * @dev Token that can be irreversibly burned (destroyed).
99  */
100 contract BurnableToken is BasicToken {
101 
102     event Burn(address indexed burner, uint256 value);
103 
104     /**
105      * @dev Burns a specific amount of tokens.
106      * @param _value The amount of token to be burned.
107      */
108     function burn(uint256 _value) public {
109         require(_value <= balances[msg.sender]);
110         // no need to require value <= totalSupply, since that would imply the
111         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
112 
113         address burner = msg.sender;
114         balances[burner] = balances[burner].sub(_value);
115         totalSupply = totalSupply.sub(_value);
116         Burn(burner, _value);
117     }
118 
119     
120 }
121 
122 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
123 
124 /**
125  * @title Ownable
126  * @dev The Ownable contract has an owner address, and provides basic authorization control
127  * functions, this simplifies the implementation of "user permissions".
128  */
129 contract Ownable {
130   address public owner;
131 
132 
133   function Ownable() public {
134     owner = msg.sender;
135   }
136 
137 
138   modifier onlyOwner() {
139     require(msg.sender == owner);
140     _;
141   }
142 }
143 contract Pausable is Ownable {
144   event Pause();
145   event Unpause();
146 
147   bool public paused = false;
148 
149 
150   /**
151    * @dev Modifier to make a function callable only when the contract is not paused.
152    */
153   modifier whenNotPaused() {
154     require(!paused);
155     _;
156   }
157 
158   /**
159    * @dev Modifier to make a function callable only when the contract is paused.
160    */
161   modifier whenPaused() {
162     require(paused);
163     _;
164   }
165 
166   /**
167    * @dev called by the owner to pause, triggers stopped state
168    */
169   function pause() onlyOwner whenNotPaused public {
170     paused = true;
171      Pause();
172   }
173 
174   /**
175    * @dev called by the owner to unpause, returns to normal state
176    */
177   function unpause() onlyOwner whenPaused public {
178     paused = false;
179      Unpause();
180   }
181 
182     
183 }
184 
185 
186 // File: zeppelin-solidity/contracts/token/ERC20.sol
187 
188 /**
189  * @title ERC20 interface
190  * @dev see https://github.com/ethereum/EIPs/issues/20
191  */
192 contract ERC20 is ERC20Basic {
193   function allowance(address owner, address spender) public view returns (uint256);
194   function transferFrom(address from, address to, uint256 value) public returns (bool);
195   function approve(address spender, uint256 value) public returns (bool);
196   event Approval(address indexed owner, address indexed spender, uint256 value);
197 }
198 
199 // File: zeppelin-solidity/contracts/token/StandardToken.sol
200 
201 /**
202  * @title Standard ERC20 token
203  *
204  * @dev Implementation of the basic standard token.
205  * @dev https://github.com/ethereum/EIPs/issues/20
206  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
207  */
208 contract StandardToken is ERC20, BasicToken {
209 
210   mapping (address => mapping (address => uint256)) internal allowed;
211 
212 
213   /**
214    * @dev Transfer tokens from one address to another
215    * @param _from address The address which you want to send tokens from
216    * @param _to address The address which you want to transfer to
217    * @param _value uint256 the amount of tokens to be transferred
218    */
219   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
220     require(_to != address(0));
221     require(_value <= balances[_from]);
222     require(_value <= allowed[_from][msg.sender]);
223 
224     balances[_from] = balances[_from].sub(_value);
225     balances[_to] = balances[_to].add(_value);
226     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
227     Transfer(_from, _to, _value);
228     return true;
229   }
230 
231   /**
232    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
233    *
234    * Beware that changing an allowance with this method brings the risk that someone may use both the old
235    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
236    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
237    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238    * @param _spender The address which will spend the funds.
239    * @param _value The amount of tokens to be spent.
240    */
241   function approve(address _spender, uint256 _value) public returns (bool) {
242     allowed[msg.sender][_spender] = _value;
243     Approval(msg.sender, _spender, _value);
244     return true;
245   }
246 
247   /**
248    * @dev Function to check the amount of tokens that an owner allowed to a spender.
249    * @param _owner address The address which owns the funds.
250    * @param _spender address The address which will spend the funds.
251    * @return A uint256 specifying the amount of tokens still available for the spender.
252    */
253   function allowance(address _owner, address _spender) public view returns (uint256) {
254     return allowed[_owner][_spender];
255   }
256 
257   /**
258    * @dev Increase the amount of tokens that an owner allowed to a spender.
259    *
260    * approve should be called when allowed[_spender] == 0. To increment
261    * allowed value is better to use this function to avoid 2 calls (and wait until
262    * the first transaction is mined)
263    * From MonolithDAO Token.sol
264    * @param _spender The address which will spend the funds.
265    * @param _addedValue The amount of tokens to increase the allowance by.
266    */
267   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
268     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
269     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
270     return true;
271   }
272 
273   /**
274    * @dev Decrease the amount of tokens that an owner allowed to a spender.
275    *
276    * approve should be called when allowed[_spender] == 0. To decrement
277    * allowed value is better to use this function to avoid 2 calls (and wait until
278    * the first transaction is mined)
279    * From MonolithDAO Token.sol
280    * @param _spender The address which will spend the funds.
281    * @param _subtractedValue The amount of tokens to decrease the allowance by.
282    */
283   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
284     uint oldValue = allowed[msg.sender][_spender];
285     if (_subtractedValue > oldValue) {
286       allowed[msg.sender][_spender] = 0;
287     } else {
288       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
289     }
290     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291     return true;
292   }
293 
294 }
295 
296 // File: zeppelin-solidity/contracts/token/MintableToken.sol
297 
298 /**
299  * @title Mintable token
300  * @dev Simple ERC20 Token example, with mintable token creation
301  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
302  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
303  */
304 
305 contract MintableToken is StandardToken, Ownable {
306   event Mint(address indexed to, uint256 amount);
307   event MintFinished();
308 
309   bool public mintingFinished = false;
310 
311 
312   modifier canMint() {
313     require(!mintingFinished);
314     _;
315   }
316 
317   /**
318    * @dev Function to mint tokens
319    * @param _to The address that will receive the minted tokens.
320    * @param _amount The amount of tokens to mint.
321    * @return A boolean that indicates if the operation was successful.
322    */
323   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
324     totalSupply = totalSupply.add(_amount);
325     balances[_to] = balances[_to].add(_amount);
326     Mint(_to, _amount);
327     Transfer(address(0), _to, _amount);
328     return true;
329   }
330 
331 }
332 
333 // File: zeppelin-solidity/contracts/token/CappedToken.sol
334 
335 /**
336  * @title Capped token
337  * @dev Mintable token with a token cap.
338  */
339 
340 contract CappedToken is MintableToken {
341 
342   uint256 public cap;
343 
344   function CappedToken(uint256 _cap) public {
345     require(_cap > 0);
346     cap = _cap;
347   }
348 
349   /**
350    * @dev Function to mint tokens
351    * @param _to The address that will receive the minted tokens.
352    * @param _amount The amount of tokens to mint.
353    * @return A boolean that indicates if the operation was successful.
354    */
355   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
356     require(totalSupply.add(_amount) <= cap);
357 
358     return super.mint(_to, _amount);
359   }
360 
361 }
362 
363 // File: zeppelin-solidity/contracts/token/DetailedERC20.sol
364 
365 contract DetailedERC20 is ERC20 {
366   string public name;
367   string public symbol;
368   uint8 public decimals;
369 
370   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
371     name = _name;
372     symbol = _symbol;
373     decimals = _decimals;
374   }
375   
376 }
377 
378 
379 
380 
381 
382 
383 contract cttest is DetailedERC20, StandardToken, BurnableToken, CappedToken, Pausable {
384   /**
385    * @dev Set the maximum issuance cap and token details.
386    */
387   function cttest()
388     DetailedERC20('cttest', 'cttest', 18)
389     CappedToken( 50 * (10**9) * (10**18) )
390   public {
391 
392   }
393   
394 }