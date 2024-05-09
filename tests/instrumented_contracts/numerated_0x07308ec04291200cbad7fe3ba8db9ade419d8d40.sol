1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return a / b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48     c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 /**
55  * @title Ownable
56  * @dev The Ownable contract has an owner address, and provides basic authorization control
57  * functions, this simplifies the implementation of "user permissions".
58  */
59 contract Ownable {
60   address public owner;
61 
62 
63   event OwnershipRenounced(address indexed previousOwner);
64   event OwnershipTransferred(
65     address indexed previousOwner,
66     address indexed newOwner
67   );
68 
69 
70   /**
71    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
72    * account.
73    */
74   constructor() public {
75     owner = msg.sender;
76   }
77 
78   /**
79    * @dev Throws if called by any account other than the owner.
80    */
81   modifier onlyOwner() {
82     require(msg.sender == owner);
83     _;
84   }
85 
86   /**
87    * @dev Allows the current owner to relinquish control of the contract.
88    * @notice Renouncing to ownership will leave the contract without an owner.
89    * It will not be possible to call the functions with the `onlyOwner`
90    * modifier anymore.
91    */
92   function renounceOwnership() public onlyOwner {
93     emit OwnershipRenounced(owner);
94     owner = address(0);
95   }
96 
97   /**
98    * @dev Allows the current owner to transfer control of the contract to a newOwner.
99    * @param _newOwner The address to transfer ownership to.
100    */
101   function transferOwnership(address _newOwner) public onlyOwner {
102     _transferOwnership(_newOwner);
103   }
104 
105   /**
106    * @dev Transfers control of the contract to a newOwner.
107    * @param _newOwner The address to transfer ownership to.
108    */
109   function _transferOwnership(address _newOwner) internal {
110     require(_newOwner != address(0));
111     emit OwnershipTransferred(owner, _newOwner);
112     owner = _newOwner;
113   }
114 }
115 
116 
117 /**
118  * @title Pausable
119  * @dev Base contract which allows children to implement an emergency stop mechanism.
120  */
121 contract Pausable is Ownable {
122   event Pause();
123   event Unpause();
124 
125   bool public paused = false;
126 
127 
128   /**
129    * @dev Modifier to make a function callable only when the contract is not paused.
130    */
131   modifier whenNotPaused() {
132     require(!paused);
133     _;
134   }
135 
136   /**
137    * @dev Modifier to make a function callable only when the contract is paused.
138    */
139   modifier whenPaused() {
140     require(paused);
141     _;
142   }
143 
144   /**
145    * @dev called by the owner to pause, triggers stopped state
146    */
147   function pause() onlyOwner whenNotPaused public {
148     paused = true;
149     emit Pause();
150   }
151 
152   /**
153    * @dev called by the owner to unpause, returns to normal state
154    */
155   function unpause() onlyOwner whenPaused public {
156     paused = false;
157     emit Unpause();
158   }
159 }
160 
161 
162 
163 contract HBToken is Pausable {
164 
165   string public name = "HappyBirthday";
166   string public symbol = "HappyBirthday";
167   uint8 public decimals = 18;
168 
169   mapping(address => uint256) internal balances;
170 
171   uint256 internal totalSupply_ = (10 ** 10) * (10 ** uint256(decimals));
172 
173   mapping (address => mapping (address => uint256)) internal allowed;
174 
175   event Transfer(address indexed from, address indexed to, uint256 value);
176   event Approval(address indexed owner, address indexed spender, uint256 value);
177 
178   using SafeMath for uint256;
179   
180   constructor() public {
181       balances[msg.sender] = totalSupply_;
182   }
183   
184   /**
185   * @dev Total number of tokens in existence
186   */
187   function totalSupply() public view returns (uint256) {
188     return totalSupply_;
189   }
190 
191   /**
192   * @dev Transfer token for a specified address
193   * @param _to The address to transfer to.
194   * @param _value The amount to be transferred.
195   */
196   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
197     require(_value <= balances[msg.sender]);
198     require(_to != address(0));
199 
200     balances[msg.sender] = balances[msg.sender].sub(_value);
201     balances[_to] = balances[_to].add(_value);
202     emit Transfer(msg.sender, _to, _value);
203     return true;
204   }
205 
206   /**
207   * @dev Gets the balance of the specified address.
208   * @param _owner The address to query the the balance of.
209   * @return An uint256 representing the amount owned by the passed address.
210   */
211   function balanceOf(address _owner) public view returns (uint256) {
212     return balances[_owner];
213   }
214 
215   /**
216    * @dev Transfer tokens from one address to another
217    * @param _from address The address which you want to send tokens from
218    * @param _to address The address which you want to transfer to
219    * @param _value uint256 the amount of tokens to be transferred
220    */
221   function transferFrom(
222     address _from,
223     address _to,
224     uint256 _value
225   )
226     public
227     whenNotPaused
228     returns (bool)
229   {
230     require(_value <= balances[_from]);
231     require(_value <= allowed[_from][msg.sender]);
232     require(_to != address(0));
233 
234     balances[_from] = balances[_from].sub(_value);
235     balances[_to] = balances[_to].add(_value);
236     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
237     emit Transfer(_from, _to, _value);
238     return true;
239   }
240 
241   /**
242    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
243    * Beware that changing an allowance with this method brings the risk that someone may use both the old
244    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
245    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
246    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
247    * @param _spender The address which will spend the funds.
248    * @param _value The amount of tokens to be spent.
249    */
250   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
251     allowed[msg.sender][_spender] = _value;
252     emit Approval(msg.sender, _spender, _value);
253     return true;
254   }
255 
256   /**
257    * @dev Function to check the amount of tokens that an owner allowed to a spender.
258    * @param _owner address The address which owns the funds.
259    * @param _spender address The address which will spend the funds.
260    * @return A uint256 specifying the amount of tokens still available for the spender.
261    */
262   function allowance(
263     address _owner,
264     address _spender
265    )
266     public
267     view
268     returns (uint256)
269   {
270     return allowed[_owner][_spender];
271   }
272 
273   /**
274    * @dev Increase the amount of tokens that an owner allowed to a spender.
275    * approve should be called when allowed[_spender] == 0. To increment
276    * allowed value is better to use this function to avoid 2 calls (and wait until
277    * the first transaction is mined)
278    * From MonolithDAO Token.sol
279    * @param _spender The address which will spend the funds.
280    * @param _addedValue The amount of tokens to increase the allowance by.
281    */
282   function increaseApproval(
283     address _spender,
284     uint256 _addedValue
285   )
286     public
287     whenNotPaused
288     returns (bool)
289   {
290     allowed[msg.sender][_spender] = (
291       allowed[msg.sender][_spender].add(_addedValue));
292     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
293     return true;
294   }
295 
296   /**
297    * @dev Decrease the amount of tokens that an owner allowed to a spender.
298    * approve should be called when allowed[_spender] == 0. To decrement
299    * allowed value is better to use this function to avoid 2 calls (and wait until
300    * the first transaction is mined)
301    * From MonolithDAO Token.sol
302    * @param _spender The address which will spend the funds.
303    * @param _subtractedValue The amount of tokens to decrease the allowance by.
304    */
305   function decreaseApproval(
306     address _spender,
307     uint256 _subtractedValue
308   )
309     public
310     whenNotPaused
311     returns (bool)
312   {
313     uint256 oldValue = allowed[msg.sender][_spender];
314     if (_subtractedValue >= oldValue) {
315       allowed[msg.sender][_spender] = 0;
316     } else {
317       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
318     }
319     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
320     return true;
321   }
322 
323 }