1 pragma solidity 0.4.24;
2 
3 
4 
5 
6 
7 
8 
9 /**
10  * @title ERC20Basic
11  * @dev Simpler version of ERC20 interface
12  * See https://github.com/ethereum/EIPs/issues/179
13  */
14 contract ERC20Basic {
15   function totalSupply() public view returns (uint256);
16   function balanceOf(address _who) public view returns (uint256);
17   function transfer(address _to, uint256 _value) public returns (bool);
18   event Transfer(address indexed from, address indexed to, uint256 value);
19 }
20 
21 
22 /**
23  * @title SafeMath
24  * @dev Math operations with safety checks that throw on error
25  */
26 library SafeMath {
27 
28   /**
29   * @dev Multiplies two numbers, throws on overflow.
30   */
31   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
32     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
33     // benefit is lost if 'b' is also tested.
34     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
35     if (_a == 0) {
36       return 0;
37     }
38 
39     c = _a * _b;
40     assert(c / _a == _b);
41     return c;
42   }
43 
44   /**
45   * @dev Integer division of two numbers, truncating the quotient.
46   */
47   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
48     // assert(_b > 0); // Solidity automatically throws when dividing by 0
49     // uint256 c = _a / _b;
50     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
51     return _a / _b;
52   }
53 
54   /**
55   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
56   */
57   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
58     assert(_b <= _a);
59     return _a - _b;
60   }
61 
62   /**
63   * @dev Adds two numbers, throws on overflow.
64   */
65   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
66     c = _a + _b;
67     assert(c >= _a);
68     return c;
69   }
70 }
71 
72 
73 /**
74  * @title Basic token
75  * @dev Basic version of StandardToken, with no allowances.
76  */
77 contract BasicToken is ERC20Basic {
78   using SafeMath for uint256;
79 
80   mapping(address => uint256) internal balances;
81 
82   uint256 internal totalSupply_;
83 
84   /**
85   * @dev Total number of tokens in existence
86   */
87   function totalSupply() public view returns (uint256) {
88     return totalSupply_;
89   }
90 
91   /**
92   * @dev Transfer token for a specified address
93   * @param _to The address to transfer to.
94   * @param _value The amount to be transferred.
95   */
96   function transfer(address _to, uint256 _value) public returns (bool) {
97     require(_value <= balances[msg.sender]);
98     require(_to != address(0));
99 
100     balances[msg.sender] = balances[msg.sender].sub(_value);
101     balances[_to] = balances[_to].add(_value);
102     emit Transfer(msg.sender, _to, _value);
103     return true;
104   }
105 
106   /**
107   * @dev Gets the balance of the specified address.
108   * @param _owner The address to query the the balance of.
109   * @return An uint256 representing the amount owned by the passed address.
110   */
111   function balanceOf(address _owner) public view returns (uint256) {
112     return balances[_owner];
113   }
114 
115 }
116 
117 
118 
119 /**
120  * @title ERC20 interface
121  * @dev see https://github.com/ethereum/EIPs/issues/20
122  */
123 contract ERC20 is ERC20Basic {
124   function allowance(address _owner, address _spender)
125     public view returns (uint256);
126 
127   function transferFrom(address _from, address _to, uint256 _value)
128     public returns (bool);
129 
130   function approve(address _spender, uint256 _value) public returns (bool);
131   event Approval(
132     address indexed owner,
133     address indexed spender,
134     uint256 value
135   );
136 }
137 
138 
139 /**
140  * @title Standard ERC20 token
141  *
142  * @dev Implementation of the basic standard token.
143  * https://github.com/ethereum/EIPs/issues/20
144  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
145  */
146 contract StandardToken is ERC20, BasicToken {
147 
148   mapping (address => mapping (address => uint256)) internal allowed;
149 
150 
151   /**
152    * @dev Transfer tokens from one address to another
153    * @param _from address The address which you want to send tokens from
154    * @param _to address The address which you want to transfer to
155    * @param _value uint256 the amount of tokens to be transferred
156    */
157   function transferFrom(
158     address _from,
159     address _to,
160     uint256 _value
161   )
162     public
163     returns (bool)
164   {
165     require(_value <= balances[_from]);
166     require(_value <= allowed[_from][msg.sender]);
167     require(_to != address(0));
168 
169     balances[_from] = balances[_from].sub(_value);
170     balances[_to] = balances[_to].add(_value);
171     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
172     emit Transfer(_from, _to, _value);
173     return true;
174   }
175 
176   /**
177    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
178    * Beware that changing an allowance with this method brings the risk that someone may use both the old
179    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
180    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
181    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
182    * @param _spender The address which will spend the funds.
183    * @param _value The amount of tokens to be spent.
184    */
185   function approve(address _spender, uint256 _value) public returns (bool) {
186     allowed[msg.sender][_spender] = _value;
187     emit Approval(msg.sender, _spender, _value);
188     return true;
189   }
190 
191   /**
192    * @dev Function to check the amount of tokens that an owner allowed to a spender.
193    * @param _owner address The address which owns the funds.
194    * @param _spender address The address which will spend the funds.
195    * @return A uint256 specifying the amount of tokens still available for the spender.
196    */
197   function allowance(
198     address _owner,
199     address _spender
200    )
201     public
202     view
203     returns (uint256)
204   {
205     return allowed[_owner][_spender];
206   }
207 
208   /**
209    * @dev Increase the amount of tokens that an owner allowed to a spender.
210    * approve should be called when allowed[_spender] == 0. To increment
211    * allowed value is better to use this function to avoid 2 calls (and wait until
212    * the first transaction is mined)
213    * From MonolithDAO Token.sol
214    * @param _spender The address which will spend the funds.
215    * @param _addedValue The amount of tokens to increase the allowance by.
216    */
217   function increaseApproval(
218     address _spender,
219     uint256 _addedValue
220   )
221     public
222     returns (bool)
223   {
224     allowed[msg.sender][_spender] = (
225       allowed[msg.sender][_spender].add(_addedValue));
226     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
227     return true;
228   }
229 
230   /**
231    * @dev Decrease the amount of tokens that an owner allowed to a spender.
232    * approve should be called when allowed[_spender] == 0. To decrement
233    * allowed value is better to use this function to avoid 2 calls (and wait until
234    * the first transaction is mined)
235    * From MonolithDAO Token.sol
236    * @param _spender The address which will spend the funds.
237    * @param _subtractedValue The amount of tokens to decrease the allowance by.
238    */
239   function decreaseApproval(
240     address _spender,
241     uint256 _subtractedValue
242   )
243     public
244     returns (bool)
245   {
246     uint256 oldValue = allowed[msg.sender][_spender];
247     if (_subtractedValue >= oldValue) {
248       allowed[msg.sender][_spender] = 0;
249     } else {
250       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
251     }
252     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
253     return true;
254   }
255 
256 }
257 
258 
259 /**
260  * @title Ownable
261  * @dev The Ownable contract has an owner address, and provides basic authorization control
262  * functions, this simplifies the implementation of "user permissions".
263  */
264 contract Ownable {
265   address public owner;
266 
267 
268   event OwnershipRenounced(address indexed previousOwner);
269   event OwnershipTransferred(
270     address indexed previousOwner,
271     address indexed newOwner
272   );
273 
274 
275   /**
276    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
277    * account.
278    */
279   constructor() public {
280     owner = msg.sender;
281   }
282 
283   /**
284    * @dev Throws if called by any account other than the owner.
285    */
286   modifier onlyOwner() {
287     require(msg.sender == owner);
288     _;
289   }
290 
291   /**
292    * @dev Allows the current owner to relinquish control of the contract.
293    * @notice Renouncing to ownership will leave the contract without an owner.
294    * It will not be possible to call the functions with the `onlyOwner`
295    * modifier anymore.
296    */
297   function renounceOwnership() public onlyOwner {
298     emit OwnershipRenounced(owner);
299     owner = address(0);
300   }
301 
302   /**
303    * @dev Allows the current owner to transfer control of the contract to a newOwner.
304    * @param _newOwner The address to transfer ownership to.
305    */
306   function transferOwnership(address _newOwner) public onlyOwner {
307     _transferOwnership(_newOwner);
308   }
309 
310   /**
311    * @dev Transfers control of the contract to a newOwner.
312    * @param _newOwner The address to transfer ownership to.
313    */
314   function _transferOwnership(address _newOwner) internal {
315     require(_newOwner != address(0));
316     emit OwnershipTransferred(owner, _newOwner);
317     owner = _newOwner;
318   }
319 }
320 
321 
322 /**
323  * @title Mintable token
324  * @dev Simple ERC20 Token example, with mintable token creation
325  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
326  */
327 contract MintableToken is StandardToken, Ownable {
328   event Mint(address indexed to, uint256 amount);
329   event MintFinished();
330 
331   bool public mintingFinished = false;
332 
333 
334   modifier canMint() {
335     require(!mintingFinished);
336     _;
337   }
338 
339   modifier hasMintPermission() {
340     require(msg.sender == owner);
341     _;
342   }
343 
344   /**
345    * @dev Function to mint tokens
346    * @param _to The address that will receive the minted tokens.
347    * @param _amount The amount of tokens to mint.
348    * @return A boolean that indicates if the operation was successful.
349    */
350   function mint(
351     address _to,
352     uint256 _amount
353   )
354     public
355     hasMintPermission
356     canMint
357     returns (bool)
358   {
359     totalSupply_ = totalSupply_.add(_amount);
360     balances[_to] = balances[_to].add(_amount);
361     emit Mint(_to, _amount);
362     emit Transfer(address(0), _to, _amount);
363     return true;
364   }
365 
366   /**
367    * @dev Function to stop minting new tokens.
368    * @return True if the operation was successful.
369    */
370   function finishMinting() public onlyOwner canMint returns (bool) {
371     mintingFinished = true;
372     emit MintFinished();
373     return true;
374   }
375 }
376 
377 
378 /**
379  * @title Base contract for INNBC token
380  */
381 contract INNBCL is MintableToken {
382   string public name = "InnovativeBioresearchClassic";
383   string public symbol = "INNBCL";
384   uint public decimals = 10;
385 
386   constructor() public {
387     totalSupply_ = 150000000 * (10 ** decimals);
388     balances[msg.sender] = totalSupply_;
389   }
390 }