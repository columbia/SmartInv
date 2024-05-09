1 pragma solidity ^0.5.2;
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
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (_a == 0) {
17       return 0;
18     }
19 
20     uint256 c = _a * _b;
21     assert(c / _a == _b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     // assert(_b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     assert(_b <= _a);
42     uint256 c = _a - _b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, throws on overflow.
49   */
50   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
51     uint256 c = _a + _b;
52     assert(c >= _a);
53 
54     return c;
55   }
56 }
57 
58 
59 
60 
61 contract Ownable {
62   address public owner;
63 
64 
65   event OwnershipRenounced(address indexed previousOwner);
66   event OwnershipTransferred(
67     address indexed previousOwner,
68     address indexed newOwner
69   );
70 
71 
72   /**
73    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
74    * account.
75    */
76   constructor() public {
77     owner = msg.sender;
78   }
79 
80   /**
81    * @dev Throws if called by any account other than the owner.
82    */
83   modifier onlyOwner() {
84     require(msg.sender == owner);
85     _;
86   }
87 
88   /**
89    * @dev Allows the current owner to relinquish control of the contract.
90    * @notice Renouncing to ownership will leave the contract without an owner.
91    * It will not be possible to call the functions with the `onlyOwner`
92    * modifier anymore.
93    */
94   function renounceOwnership() public onlyOwner {
95     emit OwnershipRenounced(owner);
96     owner = address(0);
97   }
98 
99   /**
100    * @dev Allows the current owner to transfer control of the contract to a newOwner.
101    * @param _newOwner The address to transfer ownership to.
102    */
103   function transferOwnership(address _newOwner) public onlyOwner {
104     _transferOwnership(_newOwner);
105   }
106 
107   /**
108    * @dev Transfers control of the contract to a newOwner.
109    * @param _newOwner The address to transfer ownership to.
110    */
111   function _transferOwnership(address _newOwner) internal {
112     require(_newOwner != address(0));
113     emit OwnershipTransferred(owner, _newOwner);
114     owner = _newOwner;
115   }
116 }
117 
118 /**
119  * @title ERC20 interface
120  * @dev see https://github.com/ethereum/EIPs/issues/20
121  */
122 contract ERC20 {
123   function totalSupply() public view returns (uint256);
124 
125   function balanceOf(address _who) public view returns (uint256);
126 
127   function allowance(address _owner, address _spender)
128     public view returns (uint256);
129 
130   function transfer(address _to, uint256 _value) public returns (bool);
131 
132   function approve(address _spender, uint256 _value)
133     public returns (bool);
134 
135   function transferFrom(address _from, address _to, uint256 _value)
136     public returns (bool);
137 
138   event Transfer(address indexed from, address indexed to, uint256 value);
139 
140   event Approval(address indexed owner, address indexed spender, uint256 value);
141 }
142 
143 /**
144  * @title Standard ERC20 token
145  *
146  * @dev Implementation of the basic standard token.
147  * https://github.com/ethereum/EIPs/issues/20
148  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
149  */
150 contract StandardToken is ERC20, Ownable {
151   using SafeMath for uint256;
152 
153   mapping(address => uint256) balances;
154 
155   mapping (address => mapping (address => uint256)) internal allowed;
156 
157   mapping (address => bool) public frozenAccount;
158 
159   event FrozenFunds(address target, bool frozen);
160 
161   uint256 totalSupply_;
162 
163   /**
164   * @dev Total number of tokens in existence
165   */
166   function totalSupply() public view returns (uint256) {
167     return totalSupply_;
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
179   /**
180    * @dev Function to check the amount of tokens that an owner allowed to a spender.
181    * @param _owner address The address which owns the funds.
182    * @param _spender address The address which will spend the funds.
183    * @return A uint256 specifying the amount of tokens still available for the spender.
184    */
185   function allowance(
186     address _owner,
187     address _spender
188    )
189     public
190     view
191     returns (uint256)
192   {
193     return allowed[_owner][_spender];
194   }
195   
196 
197   function freezeAccount(address target, bool freeze) onlyOwner public {
198     frozenAccount[target] = freeze;
199     emit FrozenFunds(target, freeze);
200     }
201 
202   /**
203   * @dev Transfer token for a specified address
204   * @param _to The address to transfer to.
205   * @param _value The amount to be transferred.
206   */
207   function transfer(address _to, uint256 _value) public returns (bool) {
208     require(_value <= balances[msg.sender]);
209     require(_to != address(0));
210     require(!frozenAccount[msg.sender]);
211 
212     balances[msg.sender] = balances[msg.sender].sub(_value);
213     balances[_to] = balances[_to].add(_value);
214     emit Transfer(msg.sender, _to, _value);
215     return true;
216   }
217 
218   /**
219    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
220    * Beware that changing an allowance with this method brings the risk that someone may use both the old
221    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
222    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
223    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
224    * @param _spender The address which will spend the funds.
225    * @param _value The amount of tokens to be spent.
226    */
227   function approve(address _spender, uint256 _value) public returns (bool) {
228     allowed[msg.sender][_spender] = _value;
229     emit Approval(msg.sender, _spender, _value);
230     return true;
231   }
232 
233   /**
234    * @dev Transfer tokens from one address to another
235    * @param _from address The address which you want to send tokens from
236    * @param _to address The address which you want to transfer to
237    * @param _value uint256 the amount of tokens to be transferred
238    */
239   function transferFrom(
240     address _from,
241     address _to,
242     uint256 _value
243   )
244     public
245     returns (bool)
246   {
247     require(_value <= balances[_from]);
248     require(_value <= allowed[_from][msg.sender]);
249     require(_to != address(0));
250     require(!frozenAccount[msg.sender]);
251 
252     balances[_from] = balances[_from].sub(_value);
253     balances[_to] = balances[_to].add(_value);
254     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
255     emit Transfer(_from, _to, _value);
256     return true;
257   }
258 
259   /**
260    * @dev Increase the amount of tokens that an owner allowed to a spender.
261    * approve should be called when allowed[_spender] == 0. To increment
262    * allowed value is better to use this function to avoid 2 calls (and wait until
263    * the first transaction is mined)
264    * @param _spender The address which will spend the funds.
265    * @param _addedValue The amount of tokens to increase the allowance by.
266    */
267   function increaseApproval(
268     address _spender,
269     uint256 _addedValue
270   )
271     public
272     returns (bool)
273   {
274     allowed[msg.sender][_spender] = (
275       allowed[msg.sender][_spender].add(_addedValue));
276     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
277     return true;
278   }
279 
280   /**
281    * @dev Decrease the amount of tokens that an owner allowed to a spender.
282    * approve should be called when allowed[_spender] == 0. To decrement
283    * allowed value is better to use this function to avoid 2 calls (and wait until
284    * the first transaction is mined)
285    * From MonolithDAO Token.sol
286    * @param _spender The address which will spend the funds.
287    * @param _subtractedValue The amount of tokens to decrease the allowance by.
288    */
289   function decreaseApproval(
290     address _spender,
291     uint256 _subtractedValue
292   )
293     public
294     returns (bool)
295   {
296     uint256 oldValue = allowed[msg.sender][_spender];
297     if (_subtractedValue >= oldValue) {
298       allowed[msg.sender][_spender] = 0;
299     } else {
300       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
301     }
302     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
303     return true;
304 
305 
306   }
307       /**
308     * @dev Internal function that burns an amount of the token of a given
309     * account.
310     * @param account The account whose tokens will be burnt.
311     * @param value The amount that will be burnt.
312     */
313     function _burn(address account, uint256 value) internal {
314       require(account != address(0));
315 
316       totalSupply_ = totalSupply_.sub(value);
317       balances[account] = balances[account].sub(value);
318       emit Transfer(account, address(0), value);
319     }
320   function _burnFrom(address account, uint256 value) internal {
321     _burn(account, value);
322     approve(account, allowed[account][msg.sender].sub(value));
323   }
324 
325 }
326 
327 
328 /**
329  * @title Burnable Token
330  * @dev Token that can be irreversibly burned (destroyed).
331  */
332 contract ERC20Burnable is StandardToken {
333     /**
334      * @dev Burns a specific amount of tokens.
335      * @param value The amount of token to be burned.
336      */
337     function burn(uint256 value) public {
338         _burn(msg.sender, value);
339     }
340 
341     /**
342      * @dev Burns a specific amount of tokens from the target address and decrements allowance
343      * @param from address The account whose tokens will be burned.
344      * @param value uint256 The amount of token to be burned.
345      */
346     function burnFrom(address from, uint256 value) public {
347         _burnFrom(from, value);
348     }
349 }
350 
351 
352 contract AgaveCoin is Ownable, ERC20Burnable {
353   using SafeMath for uint256;
354 
355     string public name = "AgaveCoin";
356     string public symbol = "AGVC";
357     uint public decimals = 18;
358 
359     uint public INITIAL_SUPPLY = 35000 * (10**6) * (10 ** uint256(decimals)) ; // 35 Billion
360     
361 
362     /// The owner of this address:
363     address public ICOAddress = 0xFd167447Fb1A5E10b962F9c89c857f83bfFEB5D4;
364     
365     /// The owner of this address:
366     address public AgaveCoinOperations = 0x88Ea9058d99DEf4182f4b356Ad178AdCF8e5D784;    
367     
368 
369     uint256 ICOAddressTokens = 25550 * (10**6) * (10**uint256(decimals));
370     uint256 AgaveCoinOperationsTokens = 9450 * (10**6) * (10**uint256(decimals));
371 
372 
373     constructor () public {
374       totalSupply_ = INITIAL_SUPPLY;
375       balances[ICOAddress] = ICOAddressTokens; //Partners
376       balances[AgaveCoinOperations] = AgaveCoinOperationsTokens; //Team and Advisers
377       balances[msg.sender] = INITIAL_SUPPLY - ICOAddressTokens - AgaveCoinOperationsTokens;
378 
379     }
380     //////////////// owner only functions below
381 
382     /// @notice To transfer token contract ownership
383     /// @param _newOwner The address of the new owner of this contract
384     function transferOwnership(address _newOwner) public onlyOwner {
385         balances[_newOwner] = balances[owner];
386         balances[owner] = 0;
387         Ownable.transferOwnership(_newOwner);
388     }
389 
390 }