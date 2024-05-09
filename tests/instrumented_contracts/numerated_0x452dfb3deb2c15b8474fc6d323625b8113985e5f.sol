1 pragma solidity ^0.4.24;
2 /**
3  * Level 1 71 Clara Street Wynnum Queensland / Australia
4  * PNI Financial Services Pty. Ltd.
5  * (c) Banking As A Protocol Ltd.
6  * Deployed to: 0xEA342BC3C72ED16184e61686611319334Fea8475
7  * Symbol: BAAP
8  * Name: Banking As A Protocol
9  * Initial supply: 100 000 000
10  * Decimals: 18
11  * Functions: Minting for future liquidity increase / SafeMath / BasicERC20
12  */
13 
14 /**
15  * @title SafeERC20
16  * @dev Wrappers around ERC20 operations that throw on failure.
17  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
18  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
19  */
20 library SafeMath {
21 
22 	  /**
23 	  * @dev Multiplies two numbers, throws on overflow.
24 	  */
25 
26 	  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
27 	    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
28 	    // benefit is lost if 'b' is also tested.
29 	    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
30 	  if (a == 0) {
31 	      return 0;
32       }
33 	      c = a * b;
34 	      assert(c / a == b);
35 	      return c;
36 	  }
37 
38 	  /**
39 	  * @dev Integer division of two numbers, truncating the quotient.
40 	  */
41 
42 	  function div(uint256 a, uint256 b) internal pure returns (uint256) {
43 	    // assert(b > 0); // Solidity automatically throws when dividing by 0
44 	    // uint256 c = a / b;
45 	    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46 	    return a / b;
47 	  }
48 
49 	    /**
50 	    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
51 	    */
52 
53 	    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54 	        assert(b <= a);
55 	        return a - b;
56 	    }
57 
58 	    /**
59 	    * @dev Adds two numbers, throws on overflow.
60 	    */
61 	    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
62 	        c = a + b;
63 	        assert(c >= a);
64 	        return c;
65   }
66 }
67 
68 /**
69  * @title ERC20 interface
70  * @dev see https://github.com/ethereum/EIPs/issues/20
71  */
72 contract ERC20 {
73   function totalSupply() public view returns (uint256);
74 
75   function balanceOf(address _who) public view returns (uint256);
76 
77   function allowance(address _owner, address _spender)
78     public view returns (uint256);
79 
80   function transfer(address _to, uint256 _value) public returns (bool);
81 
82   function approve(address _spender, uint256 _value)
83     public returns (bool);
84 
85   function transferFrom(address _from, address _to, uint256 _value)
86     public returns (bool);
87 
88   event Transfer(
89     address indexed from,
90     address indexed to,
91     uint256 value
92   );
93 
94   event Approval(
95     address indexed owner,
96     address indexed spender,
97     uint256 value
98   );
99 }
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * https://github.com/ethereum/EIPs/issues/20
106  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
107  */
108 contract StandardToken is ERC20 {
109   using SafeMath for uint256;
110 
111   mapping(address => uint256) balances;
112 
113   mapping (address => mapping (address => uint256)) internal allowed;
114 
115   uint256 totalSupply_;
116 
117   /**
118   * @dev Total number of tokens in existence
119   */
120   function totalSupply() public view returns (uint256) {
121     return totalSupply_;
122   }
123 
124   /**
125   * @dev Gets the balance of the specified address.
126   * @param _owner The address to query the the balance of.
127   * @return An uint256 representing the amount owned by the passed address.
128   */
129   function balanceOf(address _owner) public view returns (uint256) {
130     return balances[_owner];
131   }
132 
133   /**
134    * @dev Function to check the amount of tokens that an owner allowed to a spender.
135    * @param _owner address The address which owns the funds.
136    * @param _spender address The address which will spend the funds.
137    * @return A uint256 specifying the amount of tokens still available for the spender.
138    */
139   function allowance(
140     address _owner,
141     address _spender
142    )
143     public
144     view
145     returns (uint256)
146   {
147     return allowed[_owner][_spender];
148   }
149 
150   /**
151   * @dev Transfer token for a specified address
152   * @param _to The address to transfer to.
153   * @param _value The amount to be transferred.
154   */
155   function transfer(address _to, uint256 _value) public returns (bool) {
156     require(_value <= balances[msg.sender]);
157     require(_to != address(0));
158 
159     balances[msg.sender] = balances[msg.sender].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     emit Transfer(msg.sender, _to, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167    * Beware that changing an allowance with this method brings the risk that someone may use both the old
168    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171    * @param _spender The address which will spend the funds.
172    * @param _value The amount of tokens to be spent.
173    */
174   function approve(address _spender, uint256 _value) public returns (bool) {
175     allowed[msg.sender][_spender] = _value;
176     emit Approval(msg.sender, _spender, _value);
177     return true;
178   }
179 
180   /**
181    * @dev Transfer tokens from one address to another
182    * @param _from address The address which you want to send tokens from
183    * @param _to address The address which you want to transfer to
184    * @param _value uint256 the amount of tokens to be transferred
185    */
186   function transferFrom(
187     address _from,
188     address _to,
189     uint256 _value
190   )
191     public
192     returns (bool)
193   {
194     require(_value <= balances[_from]);
195     require(_value <= allowed[_from][msg.sender]);
196     require(_to != address(0));
197 
198     balances[_from] = balances[_from].sub(_value);
199     balances[_to] = balances[_to].add(_value);
200     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
201     emit Transfer(_from, _to, _value);
202     return true;
203   }
204 
205   /**
206    * @dev Increase the amount of tokens that an owner allowed to a spender.
207    * approve should be called when allowed[_spender] == 0. To increment
208    * allowed value is better to use this function to avoid 2 calls (and wait until
209    * the first transaction is mined)
210    * From MonolithDAO Token.sol
211    * @param _spender The address which will spend the funds.
212    * @param _addedValue The amount of tokens to increase the allowance by.
213    */
214   function increaseApproval(
215     address _spender,
216     uint256 _addedValue
217   )
218     public
219     returns (bool)
220   {
221     allowed[msg.sender][_spender] = (
222       allowed[msg.sender][_spender].add(_addedValue));
223     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
224     return true;
225   }
226 
227   /**
228    * @dev Decrease the amount of tokens that an owner allowed to a spender.
229    * approve should be called when allowed[_spender] == 0. To decrement
230    * allowed value is better to use this function to avoid 2 calls (and wait until
231    * the first transaction is mined)
232    * From MonolithDAO Token.sol
233    * @param _spender The address which will spend the funds.
234    * @param _subtractedValue The amount of tokens to decrease the allowance by.
235    */
236   function decreaseApproval(
237     address _spender,
238     uint256 _subtractedValue
239   )
240     public
241     returns (bool)
242   {
243     uint256 oldValue = allowed[msg.sender][_spender];
244     if (_subtractedValue >= oldValue) {
245       allowed[msg.sender][_spender] = 0;
246     } else {
247       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
248     }
249     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
250     return true;
251   }
252 
253 }
254 
255 /**
256  * @title Ownable
257  * @dev The Ownable contract has an owner address, and provides basic authorization control
258  * functions, this simplifies the implementation of "user permissions".
259  */
260 contract Ownable {
261   address public owner;
262 
263 
264   event OwnershipRenounced(address indexed previousOwner);
265   event OwnershipTransferred(
266     address indexed previousOwner,
267     address indexed newOwner
268   );
269 
270 
271   /**
272    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
273    * account.
274    */
275   constructor() public {
276     owner = msg.sender;
277   }
278 
279   /**
280    * @dev Throws if called by any account other than the owner.
281    */
282   modifier onlyOwner() {
283     require(msg.sender == owner);
284     _;
285   }
286 
287   /**
288    * @dev Allows the current owner to relinquish control of the contract.
289    * @notice Renouncing to ownership will leave the contract without an owner.
290    * It will not be possible to call the functions with the `onlyOwner`
291    * modifier anymore.
292    */
293   function renounceOwnership() public onlyOwner {
294     emit OwnershipRenounced(owner);
295     owner = address(0);
296   }
297 
298   /**
299    * @dev Allows the current owner to transfer control of the contract to a newOwner.
300    * @param _newOwner The address to transfer ownership to.
301    */
302   function transferOwnership(address _newOwner) public onlyOwner {
303     _transferOwnership(_newOwner);
304   }
305 
306   /**
307    * @dev Transfers control of the contract to a newOwner.
308    * @param _newOwner The address to transfer ownership to.
309    */
310   function _transferOwnership(address _newOwner) internal {
311     require(_newOwner != address(0));
312     emit OwnershipTransferred(owner, _newOwner);
313     owner = _newOwner;
314   }
315 }
316 
317 /**
318  * @title Burnable Token
319  * @dev Token that can be irreversibly burned (destroyed).
320  */
321  /**
322  * @title Mintable token
323  * @dev Simple ERC20 Token example, with mintable token creation
324  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
325  */
326 /**
327  * Contract to increase and decrease amount of Tokens anytime
328  */
329 
330 contract MintableBurnToken is StandardToken, Ownable {
331   event Mint(address indexed to, uint256 amount);
332   event MintFinished();
333 
334   string public constant name = "Banking As A Protocol";
335   string public constant symbol = "BAAP";
336   uint32 public constant decimals = 18;
337 
338   bool public mintingFinished = false;
339 
340 
341   modifier canMint() {
342     require(!mintingFinished);
343     _;
344   }
345 
346   modifier hasMintPermission() {
347     require(msg.sender == owner);
348     _;
349   }
350 
351   /**
352    * @dev Function to mint tokens
353    * @param _to The address that will receive the minted tokens.
354    * @param _amount The amount of tokens to mint.
355    * @return A boolean that indicates if the operation was successful.
356    */
357   function mint(
358     address _to,
359     uint256 _amount
360   )
361     public
362     hasMintPermission
363     canMint
364     returns (bool)
365   {
366     totalSupply_ = totalSupply_.add(_amount);
367     balances[_to] = balances[_to].add(_amount);
368     emit Mint(_to, _amount);
369     emit Transfer(address(0), _to, _amount);
370     return true;
371   }
372 
373   /**
374    * @dev Function to stop minting new tokens.
375    * @return True if the operation was successful.
376    */
377   function finishMinting() public onlyOwner canMint returns (bool) {
378     mintingFinished = true;
379     emit MintFinished();
380     return true;
381   }
382 
383   event Burn(address indexed burner, uint256 value);
384 
385   /**
386    * @dev Burns a specific amount of tokens.
387    * @param _value The amount of token to be burned.
388    */
389   function burn(uint256 _value) public {
390     _burn(msg.sender, _value);
391   }
392 
393   /**
394    * @dev Burns a specific amount of tokens from the target address and decrements allowance
395    * @param _from address The address which you want to send tokens from
396    * @param _value uint256 The amount of token to be burned
397    */
398   function burnFrom(address _from, uint256 _value) public {
399     require(_value <= allowed[_from][msg.sender]);
400     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
401     // this function needs to emit an event with the updated approval.
402     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
403     _burn(_from, _value);
404   }
405 
406   function _burn(address _who, uint256 _value) internal {
407     require(_value <= balances[_who]);
408     // no need to require value <= totalSupply, since that would imply the
409     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
410 
411     balances[_who] = balances[_who].sub(_value);
412     totalSupply_ = totalSupply_.sub(_value);
413     emit Burn(_who, _value);
414     emit Transfer(_who, address(0), _value);
415   }
416 }