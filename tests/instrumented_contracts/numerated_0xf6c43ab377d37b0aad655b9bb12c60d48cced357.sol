1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * See https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender)
21     public view returns (uint256);
22 
23   function transferFrom(address from, address to, uint256 value)
24     public returns (bool);
25 
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(
28     address indexed owner,
29     address indexed spender,
30     uint256 value
31   );
32 }
33 
34 /**
35  * @title Basic token
36  * @dev Basic version of StandardToken, with no allowances.
37  */
38 contract BasicToken is ERC20Basic {
39   using SafeMath for uint256;
40 
41   mapping(address => uint256) balances;
42 
43   uint256 totalSupply_;
44 
45   /**
46   * @dev Total number of tokens in existence
47   */
48   function totalSupply() public view returns (uint256) {
49     return totalSupply_;
50   }
51 
52   /**
53   * @dev Transfer token for a specified address
54   * @param _to The address to transfer to.
55   * @param _value The amount to be transferred.
56   */
57   function transfer(address _to, uint256 _value) public returns (bool) {
58     require(_to != address(0));
59     require(_value <= balances[msg.sender]);
60 
61     balances[msg.sender] = balances[msg.sender].sub(_value);
62     balances[_to] = balances[_to].add(_value);
63     emit Transfer(msg.sender, _to, _value);
64     return true;
65   }
66 
67   /**
68   * @dev Gets the balance of the specified address.
69   * @param _owner The address to query the the balance of.
70   * @return An uint256 representing the amount owned by the passed address.
71   */
72   function balanceOf(address _owner) public view returns (uint256) {
73     return balances[_owner];
74   }
75 
76 }
77 
78 /**
79  * @title Standard ERC20 token
80  *
81  * @dev Implementation of the basic standard token.
82  * https://github.com/ethereum/EIPs/issues/20
83  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
84  */
85 contract StandardToken is ERC20, BasicToken {
86 
87   mapping (address => mapping (address => uint256)) internal allowed;
88 
89 
90   /**
91    * @dev Transfer tokens from one address to another
92    * @param _from address The address which you want to send tokens from
93    * @param _to address The address which you want to transfer to
94    * @param _value uint256 the amount of tokens to be transferred
95    */
96   function transferFrom(
97     address _from,
98     address _to,
99     uint256 _value
100   )
101     public
102     returns (bool)
103   {
104     require(_to != address(0));
105     require(_value <= balances[_from]);
106     require(_value <= allowed[_from][msg.sender]);
107 
108     balances[_from] = balances[_from].sub(_value);
109     balances[_to] = balances[_to].add(_value);
110     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
111     emit Transfer(_from, _to, _value);
112     return true;
113   }
114 
115   /**
116    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
117    * Beware that changing an allowance with this method brings the risk that someone may use both the old
118    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
119    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
120    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
121    * @param _spender The address which will spend the funds.
122    * @param _value The amount of tokens to be spent.
123    */
124   function approve(address _spender, uint256 _value) public returns (bool) {
125     allowed[msg.sender][_spender] = _value;
126     emit Approval(msg.sender, _spender, _value);
127     return true;
128   }
129 
130   /**
131    * @dev Function to check the amount of tokens that an owner allowed to a spender.
132    * @param _owner address The address which owns the funds.
133    * @param _spender address The address which will spend the funds.
134    * @return A uint256 specifying the amount of tokens still available for the spender.
135    */
136   function allowance(
137     address _owner,
138     address _spender
139    )
140     public
141     view
142     returns (uint256)
143   {
144     return allowed[_owner][_spender];
145   }
146 
147   /**
148    * @dev Increase the amount of tokens that an owner allowed to a spender.
149    * approve should be called when allowed[_spender] == 0. To increment
150    * allowed value is better to use this function to avoid 2 calls (and wait until
151    * the first transaction is mined)
152    * From MonolithDAO Token.sol
153    * @param _spender The address which will spend the funds.
154    * @param _addedValue The amount of tokens to increase the allowance by.
155    */
156   function increaseApproval(
157     address _spender,
158     uint256 _addedValue
159   )
160     public
161     returns (bool)
162   {
163     allowed[msg.sender][_spender] = (
164       allowed[msg.sender][_spender].add(_addedValue));
165     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
166     return true;
167   }
168 
169   /**
170    * @dev Decrease the amount of tokens that an owner allowed to a spender.
171    * approve should be called when allowed[_spender] == 0. To decrement
172    * allowed value is better to use this function to avoid 2 calls (and wait until
173    * the first transaction is mined)
174    * From MonolithDAO Token.sol
175    * @param _spender The address which will spend the funds.
176    * @param _subtractedValue The amount of tokens to decrease the allowance by.
177    */
178   function decreaseApproval(
179     address _spender,
180     uint256 _subtractedValue
181   )
182     public
183     returns (bool)
184   {
185     uint256 oldValue = allowed[msg.sender][_spender];
186     if (_subtractedValue > oldValue) {
187       allowed[msg.sender][_spender] = 0;
188     } else {
189       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
190     }
191     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
192     return true;
193   }
194 
195 }
196 
197 /**
198  * @title SafeMath
199  * @dev Math operations with safety checks that throw on error
200  */
201 library SafeMath {
202 
203   /**
204   * @dev Multiplies two numbers, throws on overflow.
205   */
206   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
207     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
208     // benefit is lost if 'b' is also tested.
209     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
210     if (a == 0) {
211       return 0;
212     }
213 
214     c = a * b;
215     assert(c / a == b);
216     return c;
217   }
218 
219   /**
220   * @dev Integer division of two numbers, truncating the quotient.
221   */
222   function div(uint256 a, uint256 b) internal pure returns (uint256) {
223     // assert(b > 0); // Solidity automatically throws when dividing by 0
224     // uint256 c = a / b;
225     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
226     return a / b;
227   }
228 
229   /**
230   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
231   */
232   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
233     assert(b <= a);
234     return a - b;
235   }
236 
237   /**
238   * @dev Adds two numbers, throws on overflow.
239   */
240   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
241     c = a + b;
242     assert(c >= a);
243     return c;
244   }
245 }
246 
247 /**
248  * @title Ownable
249  * @dev The Ownable contract has an owner address, and provides basic authorization control
250  * functions, this simplifies the implementation of "user permissions".
251  */
252 contract Ownable {
253   address public owner;
254 
255 
256   event OwnershipRenounced(address indexed previousOwner);
257   event OwnershipTransferred(
258     address indexed previousOwner,
259     address indexed newOwner
260   );
261 
262 
263   /**
264    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
265    * account.
266    */
267   constructor() public {
268     owner = msg.sender;
269   }
270 
271   /**
272    * @dev Throws if called by any account other than the owner.
273    */
274   modifier onlyOwner() {
275     require(msg.sender == owner);
276     _;
277   }
278 
279   /**
280    * @dev Allows the current owner to relinquish control of the contract.
281    * @notice Renouncing to ownership will leave the contract without an owner.
282    * It will not be possible to call the functions with the `onlyOwner`
283    * modifier anymore.
284    */
285   function renounceOwnership() public onlyOwner {
286     emit OwnershipRenounced(owner);
287     owner = address(0);
288   }
289 
290   /**
291    * @dev Allows the current owner to transfer control of the contract to a newOwner.
292    * @param _newOwner The address to transfer ownership to.
293    */
294   function transferOwnership(address _newOwner) public onlyOwner {
295     _transferOwnership(_newOwner);
296   }
297 
298   /**
299    * @dev Transfers control of the contract to a newOwner.
300    * @param _newOwner The address to transfer ownership to.
301    */
302   function _transferOwnership(address _newOwner) internal {
303     require(_newOwner != address(0));
304     emit OwnershipTransferred(owner, _newOwner);
305     owner = _newOwner;
306   }
307 }
308 /**
309  * @title Mintable token
310  * @dev Simple ERC20 Token example, with mintable token creation
311  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
312  */
313 contract MintableToken is StandardToken, Ownable {
314   event Mint(address indexed to, uint256 amount);
315   event MintFinished();
316 
317   bool public mintingFinished = false;
318 
319 
320   modifier canMint() {
321     require(!mintingFinished);
322     _;
323   }
324 
325   modifier hasMintPermission() {
326     require(msg.sender == owner);
327     _;
328   }
329 
330   /**
331    * @dev Function to mint tokens
332    * @param _to The address that will receive the minted tokens.
333    * @param _amount The amount of tokens to mint.
334    * @return A boolean that indicates if the operation was successful.
335    */
336   function mint(
337     address _to,
338     uint256 _amount
339   )
340     hasMintPermission
341     canMint
342     public
343     returns (bool)
344   {
345     totalSupply_ = totalSupply_.add(_amount);
346     balances[_to] = balances[_to].add(_amount);
347     emit Mint(_to, _amount);
348     emit Transfer(address(0), _to, _amount);
349     return true;
350   }
351 
352   /**
353    * @dev Function to stop minting new tokens.
354    * @return True if the operation was successful.
355    */
356   function finishMinting() onlyOwner canMint public returns (bool) {
357     mintingFinished = true;
358     emit MintFinished();
359     return true;
360   }
361 }
362 
363 contract sarestoken is MintableToken{
364   string public name = "sarestoken";
365   string public symbol = "SARE";
366   uint public decimals = 0;
367 
368   constructor (uint initialSupply) public{
369     totalSupply_ = initialSupply;
370     balances[msg.sender] = initialSupply;
371   }
372 }