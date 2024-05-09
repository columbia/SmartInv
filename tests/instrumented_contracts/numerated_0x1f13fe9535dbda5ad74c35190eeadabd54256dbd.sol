1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
25     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
26     // benefit is lost if 'b' is also tested.
27     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
28     if (a == 0) {
29       return 0;
30     }
31 
32     c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     // uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return a / b;
45   }
46 
47   /**
48   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
59     c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 /**
66  * @title Basic token
67  * @dev Basic version of StandardToken, with no allowances.
68  */
69 contract BasicToken is ERC20Basic {
70   using SafeMath for uint256;
71 
72   mapping(address => uint256) balances;
73 
74   uint256 totalSupply_;
75 
76   /**
77   * @dev total number of tokens in existence
78   */
79   function totalSupply() public view returns (uint256) {
80     return totalSupply_;
81   }
82 
83   /**
84   * @dev transfer token for a specified address
85   * @param _to The address to transfer to.
86   * @param _value The amount to be transferred.
87   */
88   function transfer(address _to, uint256 _value) public returns (bool) {
89     require(_to != address(0));
90     require(_value <= balances[msg.sender]);
91 
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     emit Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of.
101   * @return An uint256 representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) public view returns (uint256) {
104     return balances[_owner];
105   }
106 
107 }
108 
109 /**
110  * @title Burnable Token
111  * @dev Token that can be irreversibly burned (destroyed).
112  */
113 contract BurnableToken is BasicToken {
114 
115   event Burn(address indexed burner, uint256 value);
116 
117   /**
118    * @dev Burns a specific amount of tokens.
119    * @param _value The amount of token to be burned.
120    */
121   function burn(uint256 _value) public {
122     _burn(msg.sender, _value);
123   }
124 
125   function _burn(address _who, uint256 _value) internal {
126     require(_value <= balances[_who]);
127     // no need to require value <= totalSupply, since that would imply the
128     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
129 
130     balances[_who] = balances[_who].sub(_value);
131     totalSupply_ = totalSupply_.sub(_value);
132     emit Burn(_who, _value);
133     emit Transfer(_who, address(0), _value);
134   }
135 }
136 
137 /**
138  * @title ERC20 interface
139  * @dev see https://github.com/ethereum/EIPs/issues/20
140  */
141 contract ERC20 is ERC20Basic {
142   function allowance(address owner, address spender)
143     public view returns (uint256);
144 
145   function transferFrom(address from, address to, uint256 value)
146     public returns (bool);
147 
148   function approve(address spender, uint256 value) public returns (bool);
149   event Approval(
150     address indexed owner,
151     address indexed spender,
152     uint256 value
153   );
154 }
155 
156 /**
157  * @title Standard ERC20 token
158  *
159  * @dev Implementation of the basic standard token.
160  * @dev https://github.com/ethereum/EIPs/issues/20
161  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
162  */
163 contract StandardToken is ERC20, BasicToken {
164 
165   mapping (address => mapping (address => uint256)) internal allowed;
166 
167 
168   /**
169    * @dev Transfer tokens from one address to another
170    * @param _from address The address which you want to send tokens from
171    * @param _to address The address which you want to transfer to
172    * @param _value uint256 the amount of tokens to be transferred
173    */
174   function transferFrom(
175     address _from,
176     address _to,
177     uint256 _value
178   )
179     public
180     returns (bool)
181   {
182     require(_to != address(0));
183     require(_value <= balances[_from]);
184     require(_value <= allowed[_from][msg.sender]);
185 
186     balances[_from] = balances[_from].sub(_value);
187     balances[_to] = balances[_to].add(_value);
188     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
189     emit Transfer(_from, _to, _value);
190     return true;
191   }
192 
193   /**
194    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
195    *
196    * Beware that changing an allowance with this method brings the risk that someone may use both the old
197    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
198    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
199    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
200    * @param _spender The address which will spend the funds.
201    * @param _value The amount of tokens to be spent.
202    */
203   function approve(address _spender, uint256 _value) public returns (bool) {
204     allowed[msg.sender][_spender] = _value;
205     emit Approval(msg.sender, _spender, _value);
206     return true;
207   }
208 
209   /**
210    * @dev Function to check the amount of tokens that an owner allowed to a spender.
211    * @param _owner address The address which owns the funds.
212    * @param _spender address The address which will spend the funds.
213    * @return A uint256 specifying the amount of tokens still available for the spender.
214    */
215   function allowance(
216     address _owner,
217     address _spender
218    )
219     public
220     view
221     returns (uint256)
222   {
223     return allowed[_owner][_spender];
224   }
225 
226   /**
227    * @dev Increase the amount of tokens that an owner allowed to a spender.
228    *
229    * approve should be called when allowed[_spender] == 0. To increment
230    * allowed value is better to use this function to avoid 2 calls (and wait until
231    * the first transaction is mined)
232    * From MonolithDAO Token.sol
233    * @param _spender The address which will spend the funds.
234    * @param _addedValue The amount of tokens to increase the allowance by.
235    */
236   function increaseApproval(
237     address _spender,
238     uint _addedValue
239   )
240     public
241     returns (bool)
242   {
243     allowed[msg.sender][_spender] = (
244       allowed[msg.sender][_spender].add(_addedValue));
245     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
246     return true;
247   }
248 
249   /**
250    * @dev Decrease the amount of tokens that an owner allowed to a spender.
251    *
252    * approve should be called when allowed[_spender] == 0. To decrement
253    * allowed value is better to use this function to avoid 2 calls (and wait until
254    * the first transaction is mined)
255    * From MonolithDAO Token.sol
256    * @param _spender The address which will spend the funds.
257    * @param _subtractedValue The amount of tokens to decrease the allowance by.
258    */
259   function decreaseApproval(
260     address _spender,
261     uint _subtractedValue
262   )
263     public
264     returns (bool)
265   {
266     uint oldValue = allowed[msg.sender][_spender];
267     if (_subtractedValue > oldValue) {
268       allowed[msg.sender][_spender] = 0;
269     } else {
270       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
271     }
272     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
273     return true;
274   }
275 
276 }
277 
278 
279 /**
280  * @title Standard Burnable Token
281  * @dev Adds burnFrom method to ERC20 implementations
282  */
283 contract StandardBurnableToken is BurnableToken, StandardToken {
284   
285   /**
286    * @dev Burns a specific amount of tokens from the target address and decrements allowance
287    * @param _from address The address which you want to send tokens from
288    * @param _value uint256 The amount of token to be burned
289    */
290   function burnFrom(address _from, uint256 _value) public {
291     require(_value <= allowed[_from][msg.sender]);
292     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
293     // this function needs to emit an event with the updated approval.
294     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
295     _burn(_from, _value);
296   }
297 }
298 
299 /**
300  * @title DavidLearningToken
301  * @dev Learning about ETH and ERC20 Token
302  */
303 
304 contract DavidLearningToken is StandardBurnableToken {
305 using SafeERC20 for ERC20; 
306 
307 string public name = 'DavidLearningToken';
308 string public symbol = 'DLT';
309 uint8 public decimals = 4;
310 uint256 public INITIAL_SUPPLY = 1080000000000000;
311 
312 constructor() public {
313   totalSupply_ = INITIAL_SUPPLY;
314   balances[msg.sender] = INITIAL_SUPPLY;
315 }
316 
317 }
318 
319 
320 /**
321  * @title SafeERC20
322  * @dev Wrappers around ERC20 operations that throw on failure.
323  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
324  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
325  */
326 library SafeERC20 {
327   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
328     require(token.transfer(to, value));
329   }
330 
331   function safeTransferFrom(
332     ERC20 token,
333     address from,
334     address to,
335     uint256 value
336   )
337     internal
338   {
339     require(token.transferFrom(from, to, value));
340   }
341 
342   function safeApprove(ERC20 token, address spender, uint256 value) internal {
343     require(token.approve(spender, value));
344   }
345 }