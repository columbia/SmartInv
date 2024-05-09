1 pragma solidity ^0.5;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract Owned {
50 	//address payable private Owner;
51 	address payable internal Owner;
52 	constructor() public{
53 	    
54 	    Owner = msg.sender;
55 	}
56     
57 	function IsOwner(address addr) view public returns(bool)
58 	{
59 	    return Owner == addr;
60 	}
61 	
62 	function TransferOwner(address payable newOwner) public onlyOwner
63 	{
64 	    Owner = newOwner;
65 	}
66 	
67 	function Terminate() public onlyOwner
68 	{
69 	    selfdestruct(Owner);
70 	}
71 	
72 	modifier onlyOwner(){
73         require(msg.sender == Owner);
74         _;
75     }
76 }
77 
78 
79 /**
80  * @title DetailedERC20 token
81  * @dev The decimals are only for visualization purposes.
82  * All the operations are done using the smallest and indivisible token unit,
83  * just as on Ethereum all the operations are done in wei.
84  */
85 
86 //modified by dh
87 contract DetailedERC20 {
88   string public name;
89   string public symbol;
90   uint8 public decimals;
91 
92   constructor(string memory _name, string memory _symbol, uint8 _decimals) public {
93     name = _name;
94     symbol = _symbol;
95     decimals = _decimals;
96   }
97 }
98 
99 
100 
101 /**
102  * @title ERC20 interface
103  * @dev see https://github.com/ethereum/EIPs/issues/20
104  */
105 contract ERC20 {
106   function totalSupply() public view returns (uint256);
107 
108   function balanceOf(address _who) public view returns (uint256);
109 
110   function allowance(address _owner, address _spender)
111     public view returns (uint256);
112 
113   function transfer(address _to, uint256 _value) public returns (bool);
114 
115   function approve(address _spender, uint256 _value)
116     public returns (bool);
117 
118   function transferFrom(address _from, address _to, uint256 _value)
119     public returns (bool);
120 
121   event Transfer(
122     address indexed from,
123     address indexed to,
124     uint256 value
125   );
126 
127   event Approval(
128     address indexed owner,
129     address indexed spender,
130     uint256 value
131   );
132 }
133 
134 
135 
136 /**
137  * @title Standard ERC20 token
138  *
139  * @dev Implementation of the basic standard token.
140  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
141  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
142  */
143 contract StandardToken is ERC20 {
144   using SafeMath for uint256;
145 
146   mapping (address => uint256) public balances_;
147 
148   mapping (address => mapping (address => uint256)) public allowed_;
149 
150   uint256 public totalSupply_;
151 
152   /**
153   * @dev Total number of tokens in existence
154   */
155   function totalSupply() public view returns (uint256) {
156     return totalSupply_;
157   }
158 
159   /**
160   * @dev Gets the balance of the specified address.
161   * @param _owner The address to query the the balance of.
162   * @return An uint256 representing the amount owned by the passed address.
163   */
164   function balanceOf(address _owner) public view returns (uint256) {
165     return balances_[_owner];
166   }
167 
168   /**
169    * @dev Function to check the amount of tokens that an owner allowed to a spender.
170    * @param _owner address The address which owns the funds.
171    * @param _spender address The address which will spend the funds.
172    * @return A uint256 specifying the amount of tokens still available for the spender.
173    */
174   function allowance(
175     address _owner,
176     address _spender
177   )
178   public
179   view
180   returns (uint256)
181   {
182     return allowed_[_owner][_spender];
183   }
184 
185   /**
186   * @dev Transfer token for a specified address
187   * @param _to The address to transfer to.
188   * @param _value The amount to be transferred.
189   */
190   function transfer(address _to, uint256 _value) public returns (bool) {
191     require(_value <= balances_[msg.sender]);
192     require(_to != address(0));
193 
194     balances_[msg.sender] = balances_[msg.sender].sub(_value);
195     balances_[_to] = balances_[_to].add(_value);
196     emit Transfer(msg.sender, _to, _value);
197     return true;
198   }
199 
200   /**
201    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
202    * Beware that changing an allowance with this method brings the risk that someone may use both the old
203    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
204    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
205    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206    * @param _spender The address which will spend the funds.
207    * @param _value The amount of tokens to be spent.
208    */
209   function approve(address _spender, uint256 _value) public returns (bool) {
210     allowed_[msg.sender][_spender] = _value;
211     emit Approval(msg.sender, _spender, _value);
212     return true;
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
226   public
227   returns (bool)
228   {
229     require(_value <= balances_[_from]);
230     require(_value <= allowed_[_from][msg.sender]);
231     require(_to != address(0));
232 
233     balances_[_from] = balances_[_from].sub(_value);
234     balances_[_to] = balances_[_to].add(_value);
235     allowed_[_from][msg.sender] = allowed_[_from][msg.sender].sub(_value);
236     emit Transfer(_from, _to, _value);
237     return true;
238   }
239 
240   /**
241    * @dev Increase the amount of tokens that an owner allowed to a spender.
242    * approve should be called when allowed_[_spender] == 0. To increment
243    * allowed value is better to use this function to avoid 2 calls (and wait until
244    * the first transaction is mined)
245    * From MonolithDAO Token.sol
246    * @param _spender The address which will spend the funds.
247    * @param _addedValue The amount of tokens to increase the allowance by.
248    */
249   function increaseApproval(
250     address _spender,
251     uint256 _addedValue
252   )
253   public
254   returns (bool)
255   {
256     allowed_[msg.sender][_spender] = (
257     allowed_[msg.sender][_spender].add(_addedValue));
258     emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
259     return true;
260   }
261 
262   /**
263    * @dev Decrease the amount of tokens that an owner allowed to a spender.
264    * approve should be called when allowed_[_spender] == 0. To decrement
265    * allowed value is better to use this function to avoid 2 calls (and wait until
266    * the first transaction is mined)
267    * From MonolithDAO Token.sol
268    * @param _spender The address which will spend the funds.
269    * @param _subtractedValue The amount of tokens to decrease the allowance by.
270    */
271   function decreaseApproval(
272     address _spender,
273     uint256 _subtractedValue
274   )
275   public
276   returns (bool)
277   {
278     uint256 oldValue = allowed_[msg.sender][_spender];
279     if (_subtractedValue >= oldValue) {
280       allowed_[msg.sender][_spender] = 0;
281     } else {
282       allowed_[msg.sender][_spender] = oldValue.sub(_subtractedValue);
283     }
284     emit Approval(msg.sender, _spender, allowed_[msg.sender][_spender]);
285     return true;
286   }
287 
288   /**
289    * @dev Internal function that mints an amount of the token and assigns it to
290    * an account. This encapsulates the modification of balances such that the
291    * proper events are emitted.
292    * @param _account The account that will receive the created tokens.
293    * @param _amount The amount that will be created.
294    */
295   function _mint(address _account, uint256 _amount) internal {
296     require(_account != address(0));
297     totalSupply_ = totalSupply_.add(_amount);
298     balances_[_account] = balances_[_account].add(_amount);
299     emit Transfer(address(0), _account, _amount);
300   }
301 
302   /**
303    * @dev Internal function that burns an amount of the token of a given
304    * account.
305    * @param _account The account whose tokens will be burnt.
306    * @param _amount The amount that will be burnt.
307    */
308   function _burn(address _account, uint256 _amount) internal {
309     require(_account != address(0));
310     require(_amount <= balances_[_account]);
311 
312     totalSupply_ = totalSupply_.sub(_amount);
313     balances_[_account] = balances_[_account].sub(_amount);
314     emit Transfer(_account, address(0), _amount);
315   }
316 
317   /**
318    * @dev Internal function that burns an amount of the token of a given
319    * account, deducting from the sender's allowance for said account. Uses the
320    * internal _burn function.
321    * @param _account The account whose tokens will be burnt.
322    * @param _amount The amount that will be burnt.
323    */
324   function _burnFrom(address _account, uint256 _amount) internal {
325     require(_amount <= allowed_[_account][msg.sender]);
326 
327     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
328     // this function needs to emit an event with the updated approval.
329     allowed_[_account][msg.sender] = allowed_[_account][msg.sender].sub(
330       _amount);
331     _burn(_account, _amount);
332   }
333 }
334 contract WholeIssuableToken is StandardToken, Owned {
335 
336     event Mint(uint256 indexed _value, bytes32 indexed _note);
337 
338     /*_value is WHOLE tokens*/
339     function mint(uint256 _value, bytes32 _note) public onlyOwner {
340         
341         uint256 totalVal = _value * 10**9;
342         
343         balances_[address(this)] += totalVal;
344         totalSupply_ += totalVal;
345         emit Mint(totalVal, _note);
346         emit Transfer(address(0), address(this), totalVal);
347 
348     }
349 
350     /*_value is WHOLE tokens*/
351     function issue(uint256 _value, address _target) public onlyOwner {
352         
353         uint256 totalVal = _value * 10**9;
354         
355         require(balances_[address(this)] >= totalVal);
356         balances_[address(this)] -= totalVal;
357         balances_[_target] += totalVal;
358         emit Transfer(address(this),_target, totalVal);
359     }
360 }
361 
362 
363 
364 contract USG is StandardToken, DetailedERC20, WholeIssuableToken   {
365     constructor() DetailedERC20("USGold", "USG", 9) public {}
366     
367     event Redeemed(address addr, uint256 amt, bytes32 notes);
368     
369     //mut be whole token
370     function redeem(uint256 amt, bytes32 notes) public {
371         uint256 total = amt * 10**9;
372         _burn(msg.sender, total);
373         emit Redeemed(msg.sender, amt, notes);
374         
375     }
376    
377 }