1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 contract ERC20 {
9   function totalSupply() public view returns (uint256);
10 
11   function balanceOf(address _who) public view returns (uint256);
12 
13   function allowance(address _owner, address _spender)
14     public view returns (uint256);
15 
16   function transfer(address _to, uint256 _value) public returns (bool);
17 
18   function approve(address _spender, uint256 _value)
19     public returns (bool);
20 
21   function transferFrom(address _from, address _to, uint256 _value)
22     public returns (bool);
23 
24   event Transfer(
25     address indexed from,
26     address indexed to,
27     uint256 value
28   );
29 
30   event Approval(
31     address indexed owner,
32     address indexed spender,
33     uint256 value
34   );
35 }
36 
37 
38 
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that revert on error
43  */
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, reverts on overflow.
48   */
49   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
50     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51     // benefit is lost if 'b' is also tested.
52     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53     if (_a == 0) {
54       return 0;
55     }
56 
57     uint256 c = _a * _b;
58     require(c / _a == _b);
59 
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
65   */
66   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
67     require(_b > 0); // Solidity only automatically asserts when dividing by 0
68     uint256 c = _a / _b;
69     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
70 
71     return c;
72   }
73 
74   /**
75   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
76   */
77   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
78     require(_b <= _a);
79     uint256 c = _a - _b;
80 
81     return c;
82   }
83 
84   /**
85   * @dev Adds two numbers, reverts on overflow.
86   */
87   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
88     uint256 c = _a + _b;
89     require(c >= _a);
90 
91     return c;
92   }
93 
94   /**
95   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
96   * reverts when dividing by zero.
97   */
98   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
99     require(b != 0);
100     return a % b;
101   }
102 }
103 
104 
105 /// @title Desing by contract (Hoare logic)
106 /// @author Melonport AG <team@melonport.com>
107 /// @notice Gives deriving contracts design by contract modifiers
108 contract DBC {
109 
110     // MODIFIERS
111 
112     modifier pre_cond(bool condition) {
113         require(condition);
114         _;
115     }
116 
117     modifier post_cond(bool condition) {
118         _;
119         assert(condition);
120     }
121 
122     modifier invariant(bool condition) {
123         require(condition);
124         _;
125         assert(condition);
126     }
127 }
128 
129 
130 contract Owned is DBC {
131 
132     // FIELDS
133 
134     address public owner;
135 
136     // NON-CONSTANT METHODS
137 
138     function Owned() { owner = msg.sender; }
139 
140     function changeOwner(address ofNewOwner) pre_cond(isOwner()) { owner = ofNewOwner; }
141 
142     // PRE, POST, INVARIANT CONDITIONS
143 
144     function isOwner() internal returns (bool) { return msg.sender == owner; }
145 
146 }
147 
148 
149 
150 /**
151  * @title Standard ERC20 token
152  *
153  * @dev Implementation of the basic standard token.
154  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
155  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
156  */
157 contract StandardToken is ERC20, Owned {
158   using SafeMath for uint256;
159 
160   mapping (address => uint256) private balances;
161 
162   mapping (address => mapping (address => uint256)) private allowed;
163 
164   uint256 private totalSupply_;
165 
166   /**
167   * @dev Total number of tokens in existence
168   */
169   function totalSupply() public view returns (uint256) {
170     return totalSupply_;
171   }
172 
173   /**
174   * @dev Gets the balance of the specified address.
175   * @param _owner The address to query the the balance of.
176   * @return An uint256 representing the amount owned by the passed address.
177   */
178   function balanceOf(address _owner) public view returns (uint256) {
179     return balances[_owner];
180   }
181 
182   /**
183    * @dev Function to check the amount of tokens that an owner allowed to a spender.
184    * @param _owner address The address which owns the funds.
185    * @param _spender address The address which will spend the funds.
186    * @return A uint256 specifying the amount of tokens still available for the spender.
187    */
188   function allowance(
189     address _owner,
190     address _spender
191    )
192     public
193     view
194     returns (uint256)
195   {
196     return allowed[_owner][_spender];
197   }
198 
199   /**
200   * @dev Transfer token for a specified address
201   * @param _to The address to transfer to.
202   * @param _value The amount to be transferred.
203   */
204   function transfer(address _to, uint256 _value) public returns (bool) {
205     require(_value <= balances[msg.sender]);
206     require(_to != address(0));
207 
208     balances[msg.sender] = balances[msg.sender].sub(_value);
209     balances[_to] = balances[_to].add(_value);
210     emit Transfer(msg.sender, _to, _value);
211     return true;
212   }
213 
214   /**
215    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
216    * Beware that changing an allowance with this method brings the risk that someone may use both the old
217    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
218    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
219    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
220    * @param _spender The address which will spend the funds.
221    * @param _value The amount of tokens to be spent.
222    */
223   function approve(address _spender, uint256 _value) public returns (bool) {
224     allowed[msg.sender][_spender] = _value;
225     emit Approval(msg.sender, _spender, _value);
226     return true;
227   }
228 
229   /**
230    * @dev Transfer tokens from one address to another
231    * @param _from address The address which you want to send tokens from
232    * @param _to address The address which you want to transfer to
233    * @param _value uint256 the amount of tokens to be transferred
234    */
235   function transferFrom(
236     address _from,
237     address _to,
238     uint256 _value
239   )
240     public
241     returns (bool)
242   {
243     require(_value <= balances[_from]);
244     require(_value <= allowed[_from][msg.sender]);
245     require(_to != address(0));
246 
247     balances[_from] = balances[_from].sub(_value);
248     balances[_to] = balances[_to].add(_value);
249     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
250     emit Transfer(_from, _to, _value);
251     return true;
252   }
253 
254   /**
255    * @dev Increase the amount of tokens that an owner allowed to a spender.
256    * approve should be called when allowed[_spender] == 0. To increment
257    * allowed value is better to use this function to avoid 2 calls (and wait until
258    * the first transaction is mined)
259    * From MonolithDAO Token.sol
260    * @param _spender The address which will spend the funds.
261    * @param _addedValue The amount of tokens to increase the allowance by.
262    */
263   function increaseApproval(
264     address _spender,
265     uint256 _addedValue
266   )
267     public
268     returns (bool)
269   {
270     allowed[msg.sender][_spender] = (
271       allowed[msg.sender][_spender].add(_addedValue));
272     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
273     return true;
274   }
275 
276   /**
277    * @dev Decrease the amount of tokens that an owner allowed to a spender.
278    * approve should be called when allowed[_spender] == 0. To decrement
279    * allowed value is better to use this function to avoid 2 calls (and wait until
280    * the first transaction is mined)
281    * From MonolithDAO Token.sol
282    * @param _spender The address which will spend the funds.
283    * @param _subtractedValue The amount of tokens to decrease the allowance by.
284    */
285   function decreaseApproval(
286     address _spender,
287     uint256 _subtractedValue
288   )
289     public
290     returns (bool)
291   {
292     uint256 oldValue = allowed[msg.sender][_spender];
293     if (_subtractedValue >= oldValue) {
294       allowed[msg.sender][_spender] = 0;
295     } else {
296       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
297     }
298     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
299     return true;
300   }
301 
302   /**
303    * @dev Internal function that mints an amount of the token and assigns it to
304    * an account. This encapsulates the modification of balances such that the
305    * proper events are emitted.
306    * @param _account The account that will receive the created tokens.
307    * @param _amount The amount that will be created.
308    */
309   function _mint(address _account, uint256 _amount) internal {
310     require(_account != 0);
311     totalSupply_ = totalSupply_.add(_amount);
312     balances[_account] = balances[_account].add(_amount);
313     emit Transfer(address(0), _account, _amount);
314   }
315 
316   /**
317    * @dev Internal function that burns an amount of the token of a given
318    * account.
319    * @param _account The account whose tokens will be burnt.
320    * @param _amount The amount that will be burnt.
321    */
322   function _burn(address _account, uint256 _amount) internal {
323     require(_account != 0);
324     require(_amount <= balances[_account]);
325 
326     totalSupply_ = totalSupply_.sub(_amount);
327     balances[_account] = balances[_account].sub(_amount);
328     emit Transfer(_account, address(0), _amount);
329   }
330 
331   /**
332    * @dev Internal function that burns an amount of the token of a given
333    * account, deducting from the sender's allowance for said account. Uses the
334    * internal _burn function.
335    * @param _account The account whose tokens will be burnt.
336    * @param _amount The amount that will be burnt.
337    */
338   function _burnFrom(address _account, uint256 _amount) internal {
339     require(_amount <= allowed[_account][msg.sender]);
340 
341     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
342     // this function needs to emit an event with the updated approval.
343     allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
344     _burn(_account, _amount);
345   }
346 }
347 
348 
349 /**
350  * @title SimpleToken
351  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
352  * Note they can later distribute these tokens as they wish using `transfer` and other
353  * `StandardToken` functions.
354  */
355 contract GammonCoin is StandardToken {
356 
357   string public constant name = "GammonCoin";
358   string public constant symbol = "GC";
359   uint8 public constant decimals = 18;
360 
361   uint256 public constant INITIAL_SUPPLY = 172750000 * (10 ** uint256(decimals));
362 
363   /**
364    * @dev Constructor that gives msg.sender all of existing tokens.
365    */
366   constructor() public {
367     _mint(msg.sender, INITIAL_SUPPLY);
368   }
369 
370 }