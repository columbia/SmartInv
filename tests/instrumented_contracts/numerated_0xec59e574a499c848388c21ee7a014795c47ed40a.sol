1 pragma solidity ^0.4.18;
2 
3 
4 /**besed on  OpenZeppelin**/
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
39 
40 /**
41  * @title ERC20Basic
42  * @dev Simpler version of ERC20 interface
43  * @dev see https://github.com/ethereum/EIPs/issues/179
44  */
45 contract ERC20Basic {
46   uint256 public totalSupply;
47   function balanceOf(address who) public view returns (uint256);
48   function transfer(address to, uint256 value) public returns (bool);
49   event Transfer(address indexed from, address indexed to, uint256 value);
50 }
51 
52 // File: zeppelin-solidity/contracts/token/BasicToken.sol
53 
54 /**
55  * @title Basic token
56  * @dev Basic version of StandardToken, with no allowances.
57  */
58 contract BasicToken is ERC20Basic {
59   using SafeMath for uint256;
60 
61   mapping(address => uint256) balances;
62   mapping(address => bool) internal locks;
63   mapping(address => mapping(address => uint256)) internal allowed;
64 
65   /**
66   * @dev transfer token for a specified address
67   * @param _to The address to transfer to.
68   * @param _value The amount to be transferred.
69   */
70   function transfer(address _to, uint256 _value) public returns (bool) {
71     require(_to != address(0));
72     require(_value <= balances[msg.sender]);
73 
74     // SafeMath.sub will throw if there is not enough balance.
75     balances[msg.sender] = balances[msg.sender].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   /**
82   * @dev Gets the balance of the specified address.
83   * @param _owner The address to query the the balance of.
84   * @return An uint256 representing the amount owned by the passed address.
85   */
86   function balanceOf(address _owner) public view returns (uint256 balance) {
87     return balances[_owner];
88   }
89   
90 
91 }
92 
93 // File: zeppelin-solidity/contracts/token/BurnableToken.sol
94 
95 /**
96  * @title Burnable Token
97  * @dev Token that can be irreversibly burned (destroyed).
98  */
99 contract BurnableToken is BasicToken {
100 
101     event Burn(address indexed burner, uint256 value);
102 
103     /**
104      * @dev Burns a specific amount of tokens.
105      * @param _value The amount of token to be burned.
106      */
107     function burn(uint256 _value) public {
108         require(_value <= balances[msg.sender]);
109         // no need to require value <= totalSupply, since that would imply the
110         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
111 
112         address burner = msg.sender;
113         balances[burner] = balances[burner].sub(_value);
114         totalSupply = totalSupply.sub(_value);
115         Burn(burner, _value);
116     }
117 
118     
119 }
120 
121 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
122 
123 /**
124  * @title Ownable
125  * @dev The Ownable contract has an owner address, and provides basic authorization control
126  * functions, this simplifies the implementation of "user permissions".
127  */
128 contract Ownable {
129   address public owner;
130 
131 
132   function Ownable() public {
133     owner = msg.sender;
134   }
135 
136 
137   modifier onlyOwner() {
138     require(msg.sender == owner);
139     _;
140   }
141 }
142 contract Pausable is Ownable {
143   event Pause();
144   event Unpause();
145 
146   bool public paused = false;
147 
148 
149   /**
150    * @dev Modifier to make a function callable only when the contract is not paused.
151    */
152   modifier whenNotPaused() {
153     require(!paused);
154     _;
155   }
156 
157   /**
158    * @dev Modifier to make a function callable only when the contract is paused.
159    */
160   modifier whenPaused() {
161     require(paused);
162     _;
163   }
164 
165   /**
166    * @dev called by the owner to pause, triggers stopped state
167    */
168   function pause() onlyOwner whenNotPaused public {
169     paused = true;
170      Pause();
171   }
172 
173   /**
174    * @dev called by the owner to unpause, returns to normal state
175    */
176   function unpause() onlyOwner whenPaused public {
177     paused = false;
178      Unpause();
179   }
180 
181     
182 }
183 
184 
185 // File: zeppelin-solidity/contracts/token/ERC20.sol
186 
187 /**
188  * @title ERC20 interface
189  * @dev see https://github.com/ethereum/EIPs/issues/20
190  */
191 contract ERC20 is ERC20Basic {
192   function allowance(address owner, address spender) public view returns (uint256);
193   function transferFrom(address from, address to, uint256 value) public returns (bool);
194   function approve(address spender, uint256 value) public returns (bool);
195   event Approval(address indexed owner, address indexed spender, uint256 value);
196 }
197 
198 // File: zeppelin-solidity/contracts/token/StandardToken.sol
199 
200 /**
201  * @title Standard ERC20 token
202  *
203  * @dev Implementation of the basic standard token.
204  * @dev https://github.com/ethereum/EIPs/issues/20
205  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
206  */
207 contract StandardToken is ERC20, BasicToken {
208 
209   mapping (address => mapping (address => uint256)) internal allowed;
210 
211 
212   /**
213    * @dev Transfer tokens from one address to another
214    * @param _from address The address which you want to send tokens from
215    * @param _to address The address which you want to transfer to
216    * @param _value uint256 the amount of tokens to be transferred
217    */
218   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
219     require(_to != address(0));
220     require(_value <= balances[_from]);
221     require(_value <= allowed[_from][msg.sender]);
222 
223     balances[_from] = balances[_from].sub(_value);
224     balances[_to] = balances[_to].add(_value);
225     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
226     Transfer(_from, _to, _value);
227     return true;
228   }
229 
230   /**
231    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
232    *
233    * Beware that changing an allowance with this method brings the risk that someone may use both the old
234    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
235    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
236    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
237    * @param _spender The address which will spend the funds.
238    * @param _value The amount of tokens to be spent.
239    */
240   function approve(address _spender, uint256 _value) public returns (bool) {
241     allowed[msg.sender][_spender] = _value;
242     Approval(msg.sender, _spender, _value);
243     return true;
244   }
245 
246   /**
247    * @dev Function to check the amount of tokens that an owner allowed to a spender.
248    * @param _owner address The address which owns the funds.
249    * @param _spender address The address which will spend the funds.
250    * @return A uint256 specifying the amount of tokens still available for the spender.
251    */
252   function allowance(address _owner, address _spender) public view returns (uint256) {
253     return allowed[_owner][_spender];
254   }
255 
256   /**
257    * @dev Increase the amount of tokens that an owner allowed to a spender.
258    *
259    * approve should be called when allowed[_spender] == 0. To increment
260    * allowed value is better to use this function to avoid 2 calls (and wait until
261    * the first transaction is mined)
262    * From MonolithDAO Token.sol
263    * @param _spender The address which will spend the funds.
264    * @param _addedValue The amount of tokens to increase the allowance by.
265    */
266   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
267     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
268     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
269     return true;
270   }
271 
272   /**
273    * @dev Decrease the amount of tokens that an owner allowed to a spender.
274    *
275    * approve should be called when allowed[_spender] == 0. To decrement
276    * allowed value is better to use this function to avoid 2 calls (and wait until
277    * the first transaction is mined)
278    * From MonolithDAO Token.sol
279    * @param _spender The address which will spend the funds.
280    * @param _subtractedValue The amount of tokens to decrease the allowance by.
281    */
282   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
283     uint oldValue = allowed[msg.sender][_spender];
284     if (_subtractedValue > oldValue) {
285       allowed[msg.sender][_spender] = 0;
286     } else {
287       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
288     }
289     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
290     return true;
291   }
292 
293 }
294 
295 // File: zeppelin-solidity/contracts/token/MintableToken.sol
296 
297 /**
298  * @title Mintable token
299  * @dev Simple ERC20 Token example, with mintable token creation
300  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
301  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
302  */
303 
304 contract MintableToken is StandardToken, Ownable {
305   event Mint(address indexed to, uint256 amount);
306   event MintFinished();
307 
308   bool public mintingFinished = false;
309 
310 
311   modifier canMint() {
312     require(!mintingFinished);
313     _;
314   }
315 
316   /**
317    * @dev Function to mint tokens
318    * @param _to The address that will receive the minted tokens.
319    * @param _amount The amount of tokens to mint.
320    * @return A boolean that indicates if the operation was successful.
321    */
322   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
323     totalSupply = totalSupply.add(_amount);
324     balances[_to] = balances[_to].add(_amount);
325     Mint(_to, _amount);
326     Transfer(address(0), _to, _amount);
327     return true;
328   }
329 
330 }
331 
332 // File: zeppelin-solidity/contracts/token/CappedToken.sol
333 
334 /**
335  * @title Capped token
336  * @dev Mintable token with a token cap.
337  */
338 
339 contract CappedToken is MintableToken {
340 
341   uint256 public cap;
342 
343   function CappedToken(uint256 _cap) public {
344     require(_cap > 0);
345     cap = _cap;
346   }
347 
348   /**
349    * @dev Function to mint tokens
350    * @param _to The address that will receive the minted tokens.
351    * @param _amount The amount of tokens to mint.
352    * @return A boolean that indicates if the operation was successful.
353    */
354   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
355     require(totalSupply.add(_amount) <= cap);
356 
357     return super.mint(_to, _amount);
358   }
359 
360 }
361 
362 // File: zeppelin-solidity/contracts/token/DetailedERC20.sol
363 
364 contract DetailedERC20 is ERC20 {
365   string public name;
366   string public symbol;
367   uint8 public decimals;
368 
369   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
370     name = _name;
371     symbol = _symbol;
372     decimals = _decimals;
373   }
374   
375 }
376 
377 
378 
379 
380 
381 
382 contract WINNER is DetailedERC20, StandardToken, BurnableToken, CappedToken, Pausable {
383   /**
384    * @dev Set the maximum issuance cap and token details.
385    */
386   function WINNER()
387     DetailedERC20('WINNER', 'WINNER', 18)
388     CappedToken((10**9) * (10**18) )
389   public {
390 
391   }
392   
393 }