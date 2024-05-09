1 pragma solidity ^0.4.21;
2 
3 // File: contracts/math/SafeMath.sol
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
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     if (a == 0) {
16       return 0;
17     }
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: contracts/token/ERC20Basic.sol
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   uint256 public totalSupply;
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 // File: contracts/token/BasicToken.sol
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
76   /**
77   * @dev transfer token for a specified address
78   * @param _to The address to transfer to.
79   * @param _value The amount to be transferred.
80   */
81   function transfer(address _to, uint256 _value) public returns (bool) {
82     require(_to != address(0));
83     require(_value <= balances[msg.sender]);
84 
85     // SafeMath.sub will throw if there is not enough balance.
86     balances[msg.sender] = balances[msg.sender].sub(_value);
87     balances[_to] = balances[_to].add(_value);
88     emit Transfer(msg.sender, _to, _value);
89     return true;
90   }
91 
92   /**
93   * @dev Gets the balance of the specified address.
94   * @param _owner The address to query the the balance of.
95   * @return An uint256 representing the amount owned by the passed address.
96   */
97   function balanceOf(address _owner) public view returns (uint256 balance) {
98     return balances[_owner];
99   }
100 
101 }
102 
103 // File: contracts/token/BurnableToken.sol
104 
105 /**
106  * @title Burnable Token
107  * @dev Token that can be irreversibly burned (destroyed).
108  */
109 contract BurnableToken is BasicToken {
110 
111     event Burn(address indexed burner, uint256 value);
112 
113     /**
114      * @dev Burns a specific amount of tokens.
115      * @param _value The amount of token to be burned.
116      */
117     function burn(uint256 _value) public {
118         require(_value <= balances[msg.sender]);
119         // no need to require value <= totalSupply, since that would imply the
120         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
121 
122         address burner = msg.sender;
123         balances[burner] = balances[burner].sub(_value);
124         totalSupply = totalSupply.sub(_value);
125         emit Burn(burner, _value);
126     }
127 }
128 
129 // File: contracts/ownership/Ownable.sol
130 
131 /**
132  * @title Ownable
133  * @dev The Ownable contract has an owner address, and provides basic authorization control
134  * functions, this simplifies the implementation of "user permissions".
135  */
136 contract Ownable {
137   address public owner;
138 
139 
140   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
141 
142 
143   /**
144    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
145    * account.
146    */
147   function Ownable() public {
148     owner = msg.sender;
149   }
150 
151 
152   /**
153    * @dev Throws if called by any account other than the owner.
154    */
155   modifier onlyOwner() {
156     require(msg.sender == owner);
157     _;
158   }
159 
160 
161   /**
162    * @dev Allows the current owner to transfer control of the contract to a newOwner.
163    * @param newOwner The address to transfer ownership to.
164    */
165   function transferOwnership(address newOwner) public onlyOwner {
166     require(newOwner != address(0));
167     emit OwnershipTransferred(owner, newOwner);
168     owner = newOwner;
169   }
170 
171 }
172 
173 // File: contracts/token/ERC20.sol
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
186 // File: contracts/token/StandardToken.sol
187 
188 /**
189  * @title Standard ERC20 token
190  *
191  * @dev Implementation of the basic standard token.
192  * @dev https://github.com/ethereum/EIPs/issues/20
193  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
194  */
195 contract StandardToken is ERC20, BasicToken {
196 
197   mapping (address => mapping (address => uint256)) internal allowed;
198 
199 
200   /**
201    * @dev Transfer tokens from one address to another
202    * @param _from address The address which you want to send tokens from
203    * @param _to address The address which you want to transfer to
204    * @param _value uint256 the amount of tokens to be transferred
205    */
206   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
207     require(_to != address(0));
208     require(_value <= balances[_from]);
209     require(_value <= allowed[_from][msg.sender]);
210 
211     balances[_from] = balances[_from].sub(_value);
212     balances[_to] = balances[_to].add(_value);
213     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
214     emit Transfer(_from, _to, _value);
215     return true;
216   }
217 
218   /**
219    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
220    *
221    * Beware that changing an allowance with this method brings the risk that someone may use both the old
222    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
223    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
224    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
225    * @param _spender The address which will spend the funds.
226    * @param _value The amount of tokens to be spent.
227    */
228   function approve(address _spender, uint256 _value) public returns (bool) {
229     allowed[msg.sender][_spender] = _value;
230     emit Approval(msg.sender, _spender, _value);
231     return true;
232   }
233 
234   /**
235    * @dev Function to check the amount of tokens that an owner allowed to a spender.
236    * @param _owner address The address which owns the funds.
237    * @param _spender address The address which will spend the funds.
238    * @return A uint256 specifying the amount of tokens still available for the spender.
239    */
240   function allowance(address _owner, address _spender) public view returns (uint256) {
241     return allowed[_owner][_spender];
242   }
243 
244   /**
245    * @dev Increase the amount of tokens that an owner allowed to a spender.
246    *
247    * approve should be called when allowed[_spender] == 0. To increment
248    * allowed value is better to use this function to avoid 2 calls (and wait until
249    * the first transaction is mined)
250    * From MonolithDAO Token.sol
251    * @param _spender The address which will spend the funds.
252    * @param _addedValue The amount of tokens to increase the allowance by.
253    */
254   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
255     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
256     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
257     return true;
258   }
259 
260   /**
261    * @dev Decrease the amount of tokens that an owner allowed to a spender.
262    *
263    * approve should be called when allowed[_spender] == 0. To decrement
264    * allowed value is better to use this function to avoid 2 calls (and wait until
265    * the first transaction is mined)
266    * From MonolithDAO Token.sol
267    * @param _spender The address which will spend the funds.
268    * @param _subtractedValue The amount of tokens to decrease the allowance by.
269    */
270   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
271     uint oldValue = allowed[msg.sender][_spender];
272     if (_subtractedValue > oldValue) {
273       allowed[msg.sender][_spender] = 0;
274     } else {
275       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
276     }
277     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
278     return true;
279   }
280 
281 }
282 
283 // File: contracts/token/MintableToken.sol
284 
285 /**
286  * @title Mintable token
287  * @dev Simple ERC20 Token example, with mintable token creation
288  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
289  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
290  */
291 
292 contract MintableToken is StandardToken, Ownable {
293   event Mint(address indexed to, uint256 amount);
294   event MintFinished();
295 
296   bool public mintingFinished = false;
297 
298 
299   modifier canMint() {
300     require(!mintingFinished);
301     _;
302   }
303 
304   /**
305    * @dev Function to mint tokens
306    * @param _to The address that will receive the minted tokens.
307    * @param _amount The amount of tokens to mint.
308    * @return A boolean that indicates if the operation was successful.
309    *
310    */
311   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
312     totalSupply = totalSupply.add(_amount);
313     balances[_to] = balances[_to].add(_amount);
314     emit Mint(_to, _amount);
315     emit Transfer(address(0), _to, _amount);
316     return true;
317   }
318 
319   /**
320    * @dev Function to stop minting new tokens.
321    * @return True if the operation was successful.
322    */
323   function finishMinting() onlyOwner canMint public returns (bool) {
324     mintingFinished = true;
325     emit MintFinished();
326     return true;
327   }
328 }
329 
330 // File: contracts/token/SafeERC20.sol
331 
332 /**
333  * @title SafeERC20
334  * @dev Wrappers around ERC20 operations that throw on failure.
335  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
336  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
337  */
338 library SafeERC20 {
339   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
340     assert(token.transfer(to, value));
341   }
342 
343   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
344     assert(token.transferFrom(from, to, value));
345   }
346 
347   function safeApprove(ERC20 token, address spender, uint256 value) internal {
348     assert(token.approve(spender, value));
349   }
350 }
351 
352 // File: contracts/BitexToken.sol
353 
354 contract BitexToken is MintableToken, BurnableToken {
355     using SafeERC20 for ERC20;
356 
357     string public constant name = "Bitex Coin";
358 
359     string public constant symbol = "XBX";
360 
361     uint8 public decimals = 18;
362 
363     bool public tradingStarted = false;
364 
365     // allow exceptional transfer fro sender address - this mapping  can be modified only before the starting rounds
366     mapping (address => bool) public transferable;
367 
368     /**
369      * @dev modifier that throws if spender address is not allowed to transfer
370      * and the trading is not enabled
371      */
372     modifier allowTransfer(address _spender) {
373 
374         require(tradingStarted || transferable[_spender]);
375         _;
376     }
377     /**
378     *
379     * Only the owner of the token smart contract can add allow token to be transfer before the trading has started
380     *
381     */
382 
383     function modifyTransferableHash(address _spender, bool value) onlyOwner public {
384         transferable[_spender] = value;
385     }
386 
387     /**
388      * @dev Allows the owner to enable the trading.
389      */
390     function startTrading() onlyOwner public {
391         tradingStarted = true;
392     }
393 
394     /**
395      * @dev Allows anyone to transfer the tokens once trading has started
396      * @param _to the recipient address of the tokens.
397      * @param _value number of tokens to be transfered.
398      */
399     function transfer(address _to, uint _value) allowTransfer(msg.sender) public returns (bool){
400         return super.transfer(_to, _value);
401     }
402 
403     /**
404      * @dev Allows anyone to transfer the  tokens once trading has started or if the spender is part of the mapping
405 
406      * @param _from address The address which you want to send tokens from
407      * @param _to address The address which you want to transfer to
408      * @param _value uint the amout of tokens to be transfered
409      */
410     function transferFrom(address _from, address _to, uint _value) allowTransfer(_from) public returns (bool){
411         return super.transferFrom(_from, _to, _value);
412     }
413 
414     /**
415    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender when not paused.
416    * @param _spender The address which will spend the funds.
417    * @param _value The amount of tokens to be spent.
418    */
419     function approve(address _spender, uint256 _value) public allowTransfer(_spender) returns (bool) {
420         return super.approve(_spender, _value);
421     }
422 
423     /**
424      * Adding whenNotPaused
425      */
426     function increaseApproval(address _spender, uint _addedValue) public allowTransfer(_spender) returns (bool success) {
427         return super.increaseApproval(_spender, _addedValue);
428     }
429 
430     /**
431      * Adding whenNotPaused
432      */
433     function decreaseApproval(address _spender, uint _subtractedValue) public allowTransfer(_spender) returns (bool success) {
434         return super.decreaseApproval(_spender, _subtractedValue);
435     }
436 
437 }