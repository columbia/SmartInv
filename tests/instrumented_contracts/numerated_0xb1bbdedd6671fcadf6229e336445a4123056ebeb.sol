1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipRenounced(address indexed previousOwner);
14   event OwnershipTransferred(
15     address indexed previousOwner,
16     address indexed newOwner
17   );
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to relinquish control of the contract.
38    * @notice Renouncing to ownership will leave the contract without an owner.
39    * It will not be possible to call the functions with the `onlyOwner`
40    * modifier anymore.
41    */
42   function renounceOwnership() public onlyOwner {
43     emit OwnershipRenounced(owner);
44     owner = address(0);
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
66 /**
67  * @title SafeMath
68  * @dev Math operations with safety checks that throw on error
69  */
70 library SafeMath {
71 
72   /**
73   * @dev Multiplies two numbers, throws on overflow.
74   */
75   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
76     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
77     // benefit is lost if 'b' is also tested.
78     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
79     if (_a == 0) {
80       return 0;
81     }
82 
83     c = _a * _b;
84     assert(c / _a == _b);
85     return c;
86   }
87 
88   /**
89   * @dev Integer division of two numbers, truncating the quotient.
90   */
91   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
92     // assert(_b > 0); // Solidity automatically throws when dividing by 0
93     // uint256 c = _a / _b;
94     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
95     return _a / _b;
96   }
97 
98   /**
99   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
100   */
101   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
102     assert(_b <= _a);
103     return _a - _b;
104   }
105 
106   /**
107   * @dev Adds two numbers, throws on overflow.
108   */
109   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
110     c = _a + _b;
111     assert(c >= _a);
112     return c;
113   }
114 }
115 
116 /**
117  * @title ERC20Basic
118  * @dev Simpler version of ERC20 interface
119  * See https://github.com/ethereum/EIPs/issues/179
120  */
121 contract ERC20Basic {
122   function totalSupply() public view returns (uint256);
123   function balanceOf(address _who) public view returns (uint256);
124   function transfer(address _to, uint256 _value) public returns (bool);
125   event Transfer(address indexed from, address indexed to, uint256 value);
126 }
127 
128 /**
129  * @title ERC20 interface
130  * @dev see https://github.com/ethereum/EIPs/issues/20
131  */
132 contract ERC20 is ERC20Basic {
133   function allowance(address _owner, address _spender)
134     public view returns (uint256);
135 
136   function transferFrom(address _from, address _to, uint256 _value)
137     public returns (bool);
138 
139   function approve(address _spender, uint256 _value) public returns (bool);
140   event Approval(
141     address indexed owner,
142     address indexed spender,
143     uint256 value
144   );
145 }
146 
147 
148 /**
149  * @title Basic token
150  * @dev Basic version of StandardToken, with no allowances.
151  */
152 contract BasicToken is ERC20Basic {
153   using SafeMath for uint256;
154 
155   mapping(address => uint256) internal balances;
156 
157   uint256 internal totalSupply_;
158 
159   /**
160   * @dev Total number of tokens in existence
161   */
162   function totalSupply() public view returns (uint256) {
163     return totalSupply_;
164   }
165 
166   /**
167   * @dev Transfer token for a specified address
168   * @param _to The address to transfer to.
169   * @param _value The amount to be transferred.
170   */
171   function transfer(address _to, uint256 _value) public returns (bool) {
172     require(_value <= balances[msg.sender]);
173     require(_to != address(0));
174 
175     balances[msg.sender] = balances[msg.sender].sub(_value);
176     balances[_to] = balances[_to].add(_value);
177     emit Transfer(msg.sender, _to, _value);
178     return true;
179   }
180 
181   /**
182   * @dev Gets the balance of the specified address.
183   * @param _owner The address to query the the balance of.
184   * @return An uint256 representing the amount owned by the passed address.
185   */
186   function balanceOf(address _owner) public view returns (uint256) {
187     return balances[_owner];
188   }
189 
190 }
191 
192 /**
193  * @title Standard ERC20 token
194  *
195  * @dev Implementation of the basic standard token.
196  * https://github.com/ethereum/EIPs/issues/20
197  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
198  */
199 contract StandardToken is ERC20, BasicToken {
200 
201   mapping (address => mapping (address => uint256)) internal allowed;
202 
203 
204   /**
205    * @dev Transfer tokens from one address to another
206    * @param _from address The address which you want to send tokens from
207    * @param _to address The address which you want to transfer to
208    * @param _value uint256 the amount of tokens to be transferred
209    */
210   function transferFrom(
211     address _from,
212     address _to,
213     uint256 _value
214   )
215     public
216     returns (bool)
217   {
218     require(_value <= balances[_from]);
219     require(_value <= allowed[_from][msg.sender]);
220     require(_to != address(0));
221 
222     balances[_from] = balances[_from].sub(_value);
223     balances[_to] = balances[_to].add(_value);
224     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
225     emit Transfer(_from, _to, _value);
226     return true;
227   }
228 
229   /**
230    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
231    * Beware that changing an allowance with this method brings the risk that someone may use both the old
232    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
233    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
234    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
235    * @param _spender The address which will spend the funds.
236    * @param _value The amount of tokens to be spent.
237    */
238   function approve(address _spender, uint256 _value) public returns (bool) {
239     allowed[msg.sender][_spender] = _value;
240     emit Approval(msg.sender, _spender, _value);
241     return true;
242   }
243 
244   /**
245    * @dev Function to check the amount of tokens that an owner allowed to a spender.
246    * @param _owner address The address which owns the funds.
247    * @param _spender address The address which will spend the funds.
248    * @return A uint256 specifying the amount of tokens still available for the spender.
249    */
250   function allowance(
251     address _owner,
252     address _spender
253    )
254     public
255     view
256     returns (uint256)
257   {
258     return allowed[_owner][_spender];
259   }
260 
261   /**
262    * @dev Increase the amount of tokens that an owner allowed to a spender.
263    * approve should be called when allowed[_spender] == 0. To increment
264    * allowed value is better to use this function to avoid 2 calls (and wait until
265    * the first transaction is mined)
266    * From MonolithDAO Token.sol
267    * @param _spender The address which will spend the funds.
268    * @param _addedValue The amount of tokens to increase the allowance by.
269    */
270   function increaseApproval(
271     address _spender,
272     uint256 _addedValue
273   )
274     public
275     returns (bool)
276   {
277     allowed[msg.sender][_spender] = (
278       allowed[msg.sender][_spender].add(_addedValue));
279     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
280     return true;
281   }
282 
283   /**
284    * @dev Decrease the amount of tokens that an owner allowed to a spender.
285    * approve should be called when allowed[_spender] == 0. To decrement
286    * allowed value is better to use this function to avoid 2 calls (and wait until
287    * the first transaction is mined)
288    * From MonolithDAO Token.sol
289    * @param _spender The address which will spend the funds.
290    * @param _subtractedValue The amount of tokens to decrease the allowance by.
291    */
292   function decreaseApproval(
293     address _spender,
294     uint256 _subtractedValue
295   )
296     public
297     returns (bool)
298   {
299     uint256 oldValue = allowed[msg.sender][_spender];
300     if (_subtractedValue >= oldValue) {
301       allowed[msg.sender][_spender] = 0;
302     } else {
303       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
304     }
305     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
306     return true;
307   }
308 
309 }
310 
311 contract TokenERC20 is StandardToken, Ownable {
312     using SafeMath for uint;
313 
314     string public name;
315     string public symbol;
316     uint8 public decimals;
317 
318     event Burn(address indexed holder, uint256 tokens);
319 
320     constructor (address _supplyReceiver) public {
321         name = 'TOPP';
322         symbol = 'TOPP';
323         decimals = 18;
324         totalSupply_ = 5000000000e18;
325 
326         balances[_supplyReceiver] = totalSupply_;
327 
328         emit Transfer(0, _supplyReceiver, totalSupply_);
329     }
330 
331     function burn(uint256 _amount) public returns (bool) {
332         require(balances[msg.sender] >= _amount);
333 
334         balances[msg.sender] = balances[msg.sender].sub(_amount);
335         totalSupply_ = totalSupply_.sub(_amount);
336 
337         emit Burn(msg.sender, _amount);
338         emit Transfer(msg.sender, address(0), _amount);
339     }
340 }