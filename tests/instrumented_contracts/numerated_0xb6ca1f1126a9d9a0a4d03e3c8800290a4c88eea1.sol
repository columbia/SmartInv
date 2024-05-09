1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 /**
18  * @title Ownable
19  * @dev The Ownable contract has an owner address, and provides basic authorization control
20  * functions, this simplifies the implementation of "user permissions".
21  */
22 contract Ownable {
23   address public owner;
24 
25   event OwnershipTransferred(
26     address indexed previousOwner,
27     address indexed newOwner
28   );
29 
30 
31   /**
32    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
33    * account.
34    */
35   constructor() public {
36     owner = msg.sender;
37   }
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47   /**
48    * @dev Allows the current owner to transfer control of the contract to a newOwner.
49    * @param _newOwner The address to transfer ownership to.
50    */
51   function transferOwnership(address _newOwner) public onlyOwner {
52     _transferOwnership(_newOwner);
53   }
54 
55   /**
56    * @dev Transfers control of the contract to a newOwner.
57    * @param _newOwner The address to transfer ownership to.
58    */
59   function _transferOwnership(address _newOwner) internal {
60     require(_newOwner != address(0));
61     emit OwnershipTransferred(owner, _newOwner);
62     owner = _newOwner;
63   }
64 }
65 
66 
67 
68 
69 
70 
71 /**
72  * @title ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 contract ERC20 is ERC20Basic {
76   function allowance(address owner, address spender)
77     public view returns (uint256);
78 
79   function transferFrom(address from, address to, uint256 value)
80     public returns (bool);
81 
82   function approve(address spender, uint256 value) public returns (bool);
83   event Approval(
84     address indexed owner,
85     address indexed spender,
86     uint256 value
87   );
88 }
89 
90 
91 
92 
93 
94 
95 
96 
97 
98 
99 /**
100  * @title SafeMath
101  * @dev Math operations with safety checks that throw on error
102  */
103 library SafeMath {
104 
105   /**
106   * @dev Multiplies two numbers, throws on overflow.
107   */
108   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
109     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
110     // benefit is lost if 'b' is also tested.
111     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
112     if (a == 0) {
113       return 0;
114     }
115 
116     c = a * b;
117     assert(c / a == b);
118     return c;
119   }
120 
121   /**
122   * @dev Integer division of two numbers, truncating the quotient.
123   */
124   function div(uint256 a, uint256 b) internal pure returns (uint256) {
125     // assert(b > 0); // Solidity automatically throws when dividing by 0
126     // uint256 c = a / b;
127     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
128     return a / b;
129   }
130 
131   /**
132   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
133   */
134   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
135     assert(b <= a);
136     return a - b;
137   }
138 
139   /**
140   * @dev Adds two numbers, throws on overflow.
141   */
142   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
143     c = a + b;
144     assert(c >= a);
145     return c;
146   }
147 }
148 
149 
150 /**
151  * @title Basic token
152  * @dev Basic version of StandardToken, with no allowances.
153  */
154 contract BasicToken is ERC20Basic {
155   using SafeMath for uint256;
156 
157   mapping(address => uint256) balances;
158 
159   uint256 totalSupply_;
160 
161   /**
162   * @dev Total number of tokens in existence
163   */
164   function totalSupply() public view returns (uint256) {
165     return totalSupply_;
166   }
167 
168   /**
169   * @dev Transfer token for a specified address
170   * @param _to The address to transfer to.
171   * @param _value The amount to be transferred.
172   */
173   function transfer(address _to, uint256 _value) public returns (bool) {
174     require(_to != address(0));
175     require(_value <= balances[msg.sender]);
176 
177     balances[msg.sender] = balances[msg.sender].sub(_value);
178     balances[_to] = balances[_to].add(_value);
179     emit Transfer(msg.sender, _to, _value);
180     return true;
181   }
182 
183   /**
184   * @dev Gets the balance of the specified address.
185   * @param _owner The address to query the the balance of.
186   * @return An uint256 representing the amount owned by the passed address.
187   */
188   function balanceOf(address _owner) public view returns (uint256) {
189     return balances[_owner];
190   }
191 
192 }
193 
194 
195 
196 /**
197  * @title Standard ERC20 token
198  *
199  * @dev Implementation of the basic standard token.
200  * @dev https://github.com/ethereum/EIPs/issues/20
201  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
202  */
203 contract StandardToken is ERC20, BasicToken {
204 
205   mapping (address => mapping (address => uint256)) internal allowed;
206 
207 
208   /**
209    * @dev Transfer tokens from one address to another
210    * @param _from address The address which you want to send tokens from
211    * @param _to address The address which you want to transfer to
212    * @param _value uint256 the amount of tokens to be transferred
213    */
214   function transferFrom(
215     address _from,
216     address _to,
217     uint256 _value
218   )
219     public
220     returns (bool)
221   {
222     require(_to != address(0));
223     require(_value <= balances[_from]);
224     require(_value <= allowed[_from][msg.sender]);
225 
226     balances[_from] = balances[_from].sub(_value);
227     balances[_to] = balances[_to].add(_value);
228     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
229     emit Transfer(_from, _to, _value);
230     return true;
231   }
232 
233   /**
234    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
235    *
236    * Beware that changing an allowance with this method brings the risk that someone may use both the old
237    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
238    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
239    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
240    * @param _spender The address which will spend the funds.
241    * @param _value The amount of tokens to be spent.
242    */
243   function approve(address _spender, uint256 _value) public returns (bool) {
244     allowed[msg.sender][_spender] = _value;
245     emit Approval(msg.sender, _spender, _value);
246     return true;
247   }
248 
249   /**
250    * @dev Function to check the amount of tokens that an owner allowed to a spender.
251    * @param _owner address The address which owns the funds.
252    * @param _spender address The address which will spend the funds.
253    * @return A uint256 specifying the amount of tokens still available for the spender.
254    */
255   function allowance(
256     address _owner,
257     address _spender
258    )
259     public
260     view
261     returns (uint256)
262   {
263     return allowed[_owner][_spender];
264   }
265 
266   /**
267    * @dev Increase the amount of tokens that an owner allowed to a spender.
268    *
269    * approve should be called when allowed[_spender] == 0. To increment
270    * allowed value is better to use this function to avoid 2 calls (and wait until
271    * the first transaction is mined)
272    * From MonolithDAO Token.sol
273    * @param _spender The address which will spend the funds.
274    * @param _addedValue The amount of tokens to increase the allowance by.
275    */
276   function increaseApproval(
277     address _spender,
278     uint256 _addedValue
279   )
280     public
281     returns (bool)
282   {
283     allowed[msg.sender][_spender] = (
284       allowed[msg.sender][_spender].add(_addedValue));
285     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
286     return true;
287   }
288 
289   /**
290    * @dev Decrease the amount of tokens that an owner allowed to a spender.
291    *
292    * approve should be called when allowed[_spender] == 0. To decrement
293    * allowed value is better to use this function to avoid 2 calls (and wait until
294    * the first transaction is mined)
295    * From MonolithDAO Token.sol
296    * @param _spender The address which will spend the funds.
297    * @param _subtractedValue The amount of tokens to decrease the allowance by.
298    */
299   function decreaseApproval(
300     address _spender,
301     uint256 _subtractedValue
302   )
303     public
304     returns (bool)
305   {
306     uint256 oldValue = allowed[msg.sender][_spender];
307     if (_subtractedValue > oldValue) {
308       allowed[msg.sender][_spender] = 0;
309     } else {
310       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
311     }
312     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
313     return true;
314   }
315 
316 }
317 
318 /**
319  * @title RetailcoinToken
320  * @dev The RetailcoinToken, very simple ERC20 Token implementation, where all tokens are pre-assigned to the creator.
321  * Note they can later distribute these tokens as they wish using `transfer` and other
322  * `StandardToken` functions.
323  */
324 contract RetailcoinToken is Ownable, StandardToken {
325 
326   string public constant name = "Retailcoin"; // solium-disable-line uppercase
327   string public constant symbol = "XRTC"; // solium-disable-line uppercase
328   uint8 public constant decimals = 8; // solium-disable-line uppercase
329 
330   uint256 public constant INITIAL_SUPPLY = 7000000000 * (10 ** uint256(decimals));
331 
332   /**
333    * @dev Constructor that gives msg.sender all of existing tokens.
334    */
335   constructor() public {
336     totalSupply_ = INITIAL_SUPPLY;
337     balances[msg.sender] = INITIAL_SUPPLY;
338     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
339   }
340 
341   function() public payable {
342     revert();
343   }
344 
345   function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
346     return ERC20(tokenAddress).transfer(owner, tokens);
347   }
348 
349 }