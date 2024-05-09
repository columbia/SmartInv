1 pragma solidity 0.4.19;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: zeppelin-solidity/contracts/math/SafeMath.sol
46 
47 /**
48  * @title SafeMath
49  * @dev Math operations with safety checks that throw on error
50  */
51 library SafeMath {
52 
53   /**
54   * @dev Multiplies two numbers, throws on overflow.
55   */
56   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57     if (a == 0) {
58       return 0;
59     }
60     uint256 c = a * b;
61     assert(c / a == b);
62     return c;
63   }
64 
65   /**
66   * @dev Integer division of two numbers, truncating the quotient.
67   */
68   function div(uint256 a, uint256 b) internal pure returns (uint256) {
69     // assert(b > 0); // Solidity automatically throws when dividing by 0
70     uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72     return c;
73   }
74 
75   /**
76   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
77   */
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   /**
84   * @dev Adds two numbers, throws on overflow.
85   */
86   function add(uint256 a, uint256 b) internal pure returns (uint256) {
87     uint256 c = a + b;
88     assert(c >= a);
89     return c;
90   }
91 }
92 
93 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101   function totalSupply() public view returns (uint256);
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
108 
109 /**
110  * @title Basic token
111  * @dev Basic version of StandardToken, with no allowances.
112  */
113 contract BasicToken is ERC20Basic {
114   using SafeMath for uint256;
115 
116   mapping(address => uint256) balances;
117 
118   uint256 totalSupply_;
119 
120   /**
121   * @dev total number of tokens in existence
122   */
123   function totalSupply() public view returns (uint256) {
124     return totalSupply_;
125   }
126 
127   /**
128   * @dev transfer token for a specified address
129   * @param _to The address to transfer to.
130   * @param _value The amount to be transferred.
131   */
132   function transfer(address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[msg.sender]);
135 
136     // SafeMath.sub will throw if there is not enough balance.
137     balances[msg.sender] = balances[msg.sender].sub(_value);
138     balances[_to] = balances[_to].add(_value);
139     Transfer(msg.sender, _to, _value);
140     return true;
141   }
142 
143   /**
144   * @dev Gets the balance of the specified address.
145   * @param _owner The address to query the the balance of.
146   * @return An uint256 representing the amount owned by the passed address.
147   */
148   function balanceOf(address _owner) public view returns (uint256 balance) {
149     return balances[_owner];
150   }
151 
152 }
153 
154 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
155 
156 /**
157  * @title ERC20 interface
158  * @dev see https://github.com/ethereum/EIPs/issues/20
159  */
160 contract ERC20 is ERC20Basic {
161   function allowance(address owner, address spender) public view returns (uint256);
162   function transferFrom(address from, address to, uint256 value) public returns (bool);
163   function approve(address spender, uint256 value) public returns (bool);
164   event Approval(address indexed owner, address indexed spender, uint256 value);
165 }
166 
167 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
168 
169 /**
170  * @title Standard ERC20 token
171  *
172  * @dev Implementation of the basic standard token.
173  * @dev https://github.com/ethereum/EIPs/issues/20
174  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
175  */
176 contract StandardToken is ERC20, BasicToken {
177 
178   mapping (address => mapping (address => uint256)) internal allowed;
179 
180 
181   /**
182    * @dev Transfer tokens from one address to another
183    * @param _from address The address which you want to send tokens from
184    * @param _to address The address which you want to transfer to
185    * @param _value uint256 the amount of tokens to be transferred
186    */
187   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
188     require(_to != address(0));
189     require(_value <= balances[_from]);
190     require(_value <= allowed[_from][msg.sender]);
191 
192     balances[_from] = balances[_from].sub(_value);
193     balances[_to] = balances[_to].add(_value);
194     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
195     Transfer(_from, _to, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
201    *
202    * Beware that changing an allowance with this method brings the risk that someone may use both the old
203    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
204    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
205    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206    * @param _spender The address which will spend the funds.
207    * @param _value The amount of tokens to be spent.
208    */
209   function approve(address _spender, uint256 _value) public returns (bool) {
210     allowed[msg.sender][_spender] = _value;
211     Approval(msg.sender, _spender, _value);
212     return true;
213   }
214 
215   /**
216    * @dev Function to check the amount of tokens that an owner allowed to a spender.
217    * @param _owner address The address which owns the funds.
218    * @param _spender address The address which will spend the funds.
219    * @return A uint256 specifying the amount of tokens still available for the spender.
220    */
221   function allowance(address _owner, address _spender) public view returns (uint256) {
222     return allowed[_owner][_spender];
223   }
224 
225   /**
226    * @dev Increase the amount of tokens that an owner allowed to a spender.
227    *
228    * approve should be called when allowed[_spender] == 0. To increment
229    * allowed value is better to use this function to avoid 2 calls (and wait until
230    * the first transaction is mined)
231    * From MonolithDAO Token.sol
232    * @param _spender The address which will spend the funds.
233    * @param _addedValue The amount of tokens to increase the allowance by.
234    */
235   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
236     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
237     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238     return true;
239   }
240 
241   /**
242    * @dev Decrease the amount of tokens that an owner allowed to a spender.
243    *
244    * approve should be called when allowed[_spender] == 0. To decrement
245    * allowed value is better to use this function to avoid 2 calls (and wait until
246    * the first transaction is mined)
247    * From MonolithDAO Token.sol
248    * @param _spender The address which will spend the funds.
249    * @param _subtractedValue The amount of tokens to decrease the allowance by.
250    */
251   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
252     uint oldValue = allowed[msg.sender][_spender];
253     if (_subtractedValue > oldValue) {
254       allowed[msg.sender][_spender] = 0;
255     } else {
256       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
257     }
258     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
259     return true;
260   }
261 
262 }
263 
264 // File: contracts/BurnableToken.sol
265 
266 /**
267 * @title Customized Burnable Token
268 * @dev Token that can be irreversibly burned (destroyed).
269 */
270 contract BurnableToken is StandardToken, Ownable {
271 
272     event Burn(address indexed burner, uint256 amount);
273 
274     /**
275     * @dev Anybody can burn a specific amount of their tokens.
276     * @param _amount The amount of token to be burned.
277     */
278     function burn(uint256 _amount) public {
279         burnInternal(msg.sender, _amount);
280     }
281 
282     /**
283     * @dev Owner can burn a specific amount of tokens of other token holders.
284     * @param _from The address of token holder whose tokens to be burned.
285     * @param _amount The amount of token to be burned.
286     */
287     function burnFrom(address _from, uint256 _amount) public onlyOwner {
288         burnInternal(_from, _amount);
289     }
290 
291     /**
292     * @dev Burns a specific amount of tokens of a token holder.
293     * @param _from The address of token holder whose tokens are to be burned.
294     * @param _amount The amount of token to be burned.
295     */
296     function burnInternal(address _from, uint256 _amount) internal {
297         require(_from != address(0));
298         require(_amount > 0);
299         require(_amount <= balances[_from]);
300         // no need to require _amount <= totalSupply, since that would imply the
301         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
302 
303         balances[_from] = balances[_from].sub(_amount);
304         totalSupply_ = totalSupply_.sub(_amount);
305         Transfer(_from, address(0), _amount);
306         Burn(_from, _amount);
307     }
308 
309 }
310 
311 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
312 
313 /**
314  * @title Pausable
315  * @dev Base contract which allows children to implement an emergency stop mechanism.
316  */
317 contract Pausable is Ownable {
318   event Pause();
319   event Unpause();
320 
321   bool public paused = false;
322 
323 
324   /**
325    * @dev Modifier to make a function callable only when the contract is not paused.
326    */
327   modifier whenNotPaused() {
328     require(!paused);
329     _;
330   }
331 
332   /**
333    * @dev Modifier to make a function callable only when the contract is paused.
334    */
335   modifier whenPaused() {
336     require(paused);
337     _;
338   }
339 
340   /**
341    * @dev called by the owner to pause, triggers stopped state
342    */
343   function pause() onlyOwner whenNotPaused public {
344     paused = true;
345     Pause();
346   }
347 
348   /**
349    * @dev called by the owner to unpause, returns to normal state
350    */
351   function unpause() onlyOwner whenPaused public {
352     paused = false;
353     Unpause();
354   }
355 }
356 
357 // File: contracts/GiftToken.sol
358 
359 contract GiftToken is BurnableToken, Pausable {
360 
361     string public name = "Giftcoin";
362     string public symbol = "GIFT";
363     uint8 public decimals = 18;
364   
365     uint256 public initialTotalSupply = uint256(1e8) * (uint256(10) ** decimals);
366 
367     address private addressIco;
368 
369     modifier onlyIco() {
370         require(msg.sender == addressIco);
371         _;
372     }
373 
374     /**
375     * @dev Create GiftToken contract and set pause
376     * @param _ico The address of ICO contract.
377     */
378     function GiftToken(address _ico) public {
379         pause();
380         setIcoAddress(_ico);
381 
382         totalSupply_ = initialTotalSupply;
383         balances[_ico] = balances[_ico].add(initialTotalSupply);
384         Transfer(address(0), _ico, initialTotalSupply);
385     }
386 
387     function setIcoAddress(address _ico) public onlyOwner {
388         require(_ico != address(0));
389         // to change the ICO address firstly transfer the tokens to the new ICO
390         require(balanceOf(addressIco) == 0);
391 
392         addressIco = _ico;
393   
394         // the ownership of the token needs to be transferred to the crowdsale contract
395         // but it can be reclaimed using transferTokenOwnership() function
396         // or along withdrawal of the funds
397         transferOwnership(_ico);
398     }
399 
400     /**
401     * @dev Transfer token for a specified address with pause feature for owner.
402     * @dev Only applies when the transfer is allowed by the owner.
403     * @param _to The address to transfer to.
404     * @param _value The amount to be transferred.
405     */
406     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
407         return super.transfer(_to, _value);
408     }
409 
410     /**
411     * @dev Transfer tokens from one address to another with pause feature for owner.
412     * @dev Only applies when the transfer is allowed by the owner.
413     * @param _from address The address which you want to send tokens from
414     * @param _to address The address which you want to transfer to
415     * @param _value uint256 the amount of tokens to be transferred
416     */
417     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
418         return super.transferFrom(_from, _to, _value);
419     }
420 
421     /**
422     * @dev Transfer tokens from ICO address to another address.
423     * @param _to The address to transfer to.
424     * @param _value The amount to be transferred.
425     */
426     function transferFromIco(address _to, uint256 _value) public onlyIco returns (bool) {
427         return super.transfer(_to, _value);
428     }
429 }