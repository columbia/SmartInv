1 /**
2  * Source Code first verified at https://etherscan.io on Monday, February 18, 2019
3  (UTC) */
4 
5 pragma solidity ^0.5.2;
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12 
13   /**
14   * @dev Multiplies two numbers, throws on overflow.
15   */
16   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
17     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
18     // benefit is lost if 'b' is also tested.
19     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
20     if (_a == 0) {
21       return 0;
22     }
23 
24     uint256 c = _a * _b;
25     assert(c / _a == _b);
26 
27     return c;
28   }
29 
30   /**
31   * @dev Integer division of two numbers, truncating the quotient.
32   */
33   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
34     // assert(_b > 0); // Solidity automatically throws when dividing by 0
35     uint256 c = _a / _b;
36     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
37 
38     return c;
39   }
40 
41   /**
42   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
43   */
44   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
45     assert(_b <= _a);
46     uint256 c = _a - _b;
47 
48     return c;
49   }
50 
51   /**
52   * @dev Adds two numbers, throws on overflow.
53   */
54   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
55     uint256 c = _a + _b;
56     assert(c >= _a);
57 
58     return c;
59   }
60 }
61 
62 
63 contract Ownable {
64   address public owner;
65 
66 
67   event OwnershipRenounced(address indexed previousOwner);
68   event OwnershipTransferred(
69     address indexed previousOwner,
70     address indexed newOwner
71   );
72 
73 
74   /**
75    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
76    * account.
77    */
78   constructor() public {
79     owner = msg.sender;
80   }
81 
82   /**
83    * @dev Throws if called by any account other than the owner.
84    */
85   modifier onlyOwner() {
86     require(msg.sender == owner);
87     _;
88   }
89 
90   /**
91    * @dev Allows the current owner to relinquish control of the contract.
92    * @notice Renouncing to ownership will leave the contract without an owner.
93    * It will not be possible to call the functions with the `onlyOwner`
94    * modifier anymore.
95    */
96   function renounceOwnership() public onlyOwner {
97     emit OwnershipRenounced(owner);
98     owner = address(0);
99   }
100 
101   /**
102    * @dev Allows the current owner to transfer control of the contract to a newOwner.
103    * @param _newOwner The address to transfer ownership to.
104    */
105   function transferOwnership(address _newOwner) public onlyOwner {
106     _transferOwnership(_newOwner);
107   }
108 
109   /**
110    * @dev Transfers control of the contract to a newOwner.
111    * @param _newOwner The address to transfer ownership to.
112    */
113   function _transferOwnership(address _newOwner) internal {
114     require(_newOwner != address(0));
115     emit OwnershipTransferred(owner, _newOwner);
116     owner = _newOwner;
117   }
118 }
119 
120 /**
121  * @title ERC20 interface
122  * @dev see https://github.com/ethereum/EIPs/issues/20
123  */
124 contract ERC20 {
125   function totalSupply() public view returns (uint256);
126 
127   function balanceOf(address _who) public view returns (uint256);
128 
129   function allowance(address _owner, address _spender)
130     public view returns (uint256);
131 
132   function transfer(address _to, uint256 _value) public returns (bool);
133 
134   function approve(address _spender, uint256 _value)
135     public returns (bool);
136 
137   function transferFrom(address _from, address _to, uint256 _value)
138     public returns (bool);
139 
140   event Transfer(address indexed from, address indexed to, uint256 value);
141 
142   event Approval(address indexed owner, address indexed spender, uint256 value);
143 }
144 
145 /**
146  * @title Standard ERC20 token
147  *
148  * @dev Implementation of the basic standard token.
149  * https://github.com/ethereum/EIPs/issues/20
150  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
151  */
152 contract StandardToken is ERC20, Ownable {
153   using SafeMath for uint256;
154 
155   mapping(address => uint256) balances;
156 
157   mapping (address => mapping (address => uint256)) internal allowed;
158 
159   mapping (address => bool) public frozenAccount;
160 
161   event FrozenFunds(address target, bool frozen);
162 
163   uint256 totalSupply_;
164 
165   /**
166   * @dev Total number of tokens in existence
167   */
168   function totalSupply() public view returns (uint256) {
169     return totalSupply_;
170   }
171 
172   /**
173   * @dev Gets the balance of the specified address.
174   * @param _owner The address to query the the balance of.
175   * @return An uint256 representing the amount owned by the passed address.
176   */
177   function balanceOf(address _owner) public view returns (uint256) {
178     return balances[_owner];
179   }
180 
181   /**
182    * @dev Function to check the amount of tokens that an owner allowed to a spender.
183    * @param _owner address The address which owns the funds.
184    * @param _spender address The address which will spend the funds.
185    * @return A uint256 specifying the amount of tokens still available for the spender.
186    */
187   function allowance(
188     address _owner,
189     address _spender
190    )
191     public
192     view
193     returns (uint256)
194   {
195     return allowed[_owner][_spender];
196   }
197   
198 
199   function freezeAccount(address target, bool freeze) onlyOwner public {
200     frozenAccount[target] = freeze;
201     emit FrozenFunds(target, freeze);
202     }
203 
204   /**
205   * @dev Transfer token for a specified address
206   * @param _to The address to transfer to.
207   * @param _value The amount to be transferred.
208   */
209   function transfer(address _to, uint256 _value) public returns (bool) {
210     require(_value <= balances[msg.sender]);
211     require(_to != address(0));
212     require(!frozenAccount[msg.sender]);
213 
214     balances[msg.sender] = balances[msg.sender].sub(_value);
215     balances[_to] = balances[_to].add(_value);
216     emit Transfer(msg.sender, _to, _value);
217     return true;
218   }
219 
220   /**
221    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
222    * Beware that changing an allowance with this method brings the risk that someone may use both the old
223    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
224    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
225    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
226    * @param _spender The address which will spend the funds.
227    * @param _value The amount of tokens to be spent.
228    */
229   function approve(address _spender, uint256 _value) public returns (bool) {
230     allowed[msg.sender][_spender] = _value;
231     emit Approval(msg.sender, _spender, _value);
232     return true;
233   }
234 
235   /**
236    * @dev Transfer tokens from one address to another
237    * @param _from address The address which you want to send tokens from
238    * @param _to address The address which you want to transfer to
239    * @param _value uint256 the amount of tokens to be transferred
240    */
241   function transferFrom(
242     address _from,
243     address _to,
244     uint256 _value
245   )
246     public
247     returns (bool)
248   {
249     require(_value <= balances[_from]);
250     require(_value <= allowed[_from][msg.sender]);
251     require(_to != address(0));
252     require(!frozenAccount[msg.sender]);
253 
254     balances[_from] = balances[_from].sub(_value);
255     balances[_to] = balances[_to].add(_value);
256     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
257     emit Transfer(_from, _to, _value);
258     return true;
259   }
260 
261   /**
262    * @dev Increase the amount of tokens that an owner allowed to a spender.
263    * approve should be called when allowed[_spender] == 0. To increment
264    * allowed value is better to use this function to avoid 2 calls (and wait until
265    * the first transaction is mined)
266    * @param _spender The address which will spend the funds.
267    * @param _addedValue The amount of tokens to increase the allowance by.
268    */
269   function increaseApproval(
270     address _spender,
271     uint256 _addedValue
272   )
273     public
274     returns (bool)
275   {
276     allowed[msg.sender][_spender] = (
277       allowed[msg.sender][_spender].add(_addedValue));
278     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
279     return true;
280   }
281 
282   /**
283    * @dev Decrease the amount of tokens that an owner allowed to a spender.
284    * approve should be called when allowed[_spender] == 0. To decrement
285    * allowed value is better to use this function to avoid 2 calls (and wait until
286    * the first transaction is mined)
287    * From MonolithDAO Token.sol
288    * @param _spender The address which will spend the funds.
289    * @param _subtractedValue The amount of tokens to decrease the allowance by.
290    */
291   function decreaseApproval(
292     address _spender,
293     uint256 _subtractedValue
294   )
295     public
296     returns (bool)
297   {
298     uint256 oldValue = allowed[msg.sender][_spender];
299     if (_subtractedValue >= oldValue) {
300       allowed[msg.sender][_spender] = 0;
301     } else {
302       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
303     }
304     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
305     return true;
306 
307 
308   }
309       /**
310     * @dev Internal function that burns an amount of the token of a given
311     * account.
312     * @param account The account whose tokens will be burnt.
313     * @param value The amount that will be burnt.
314     */
315     function _burn(address account, uint256 value) internal {
316       require(account != address(0));
317 
318       totalSupply_ = totalSupply_.sub(value);
319       balances[account] = balances[account].sub(value);
320       emit Transfer(account, address(0), value);
321     }
322   function _burnFrom(address account, uint256 value) internal {
323     _burn(account, value);
324     approve(account, allowed[account][msg.sender].sub(value));
325   }
326 
327 }
328 
329 
330 /**
331  * @title Burnable Token
332  * @dev Token that can be irreversibly burned (destroyed).
333  */
334 contract ERC20Burnable is StandardToken {
335     /**
336      * @dev Burns a specific amount of tokens.
337      * @param value The amount of token to be burned.
338      */
339     function burn(uint256 value) public {
340         _burn(msg.sender, value);
341     }
342 
343     /**
344      * @dev Burns a specific amount of tokens from the target address and decrements allowance
345      * @param from address The account whose tokens will be burned.
346      * @param value uint256 The amount of token to be burned.
347      */
348     function burnFrom(address from, uint256 value) public {
349         _burnFrom(from, value);
350     }
351 }
352 
353 
354 contract Ozinex is Ownable, ERC20Burnable {
355   using SafeMath for uint256;
356 
357     string public name = "Ozinex Token";
358     string public symbol = "OZI";
359     uint public decimals = 8;
360 
361     uint public INITIAL_SUPPLY = 500 * (10**6) * (10 ** uint256(decimals)) ; // 500 Million
362     
363     constructor () public {
364       totalSupply_ = INITIAL_SUPPLY;
365       balances[msg.sender] = INITIAL_SUPPLY ;
366     }
367     //////////////// owner only functions below
368 
369     /// @notice To transfer token contract ownership
370     /// @param _newOwner The address of the new owner of this contract
371     function transferOwnership(address _newOwner) public onlyOwner {
372         balances[_newOwner] = balances[owner];
373         balances[owner] = 0;
374         Ownable.transferOwnership(_newOwner);
375     }
376 
377 }