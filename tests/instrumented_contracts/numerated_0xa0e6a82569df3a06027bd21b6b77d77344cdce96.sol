1 pragma solidity ^0.4.24;
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
68  * with fix for the ERC20 short address addtack
69  */
70 contract BasicToken is ERC20Basic {
71   using SafeMath for uint256;
72 
73   mapping(address => uint256) balances;
74 
75   uint256 totalSupply_;
76 
77   /**
78    *
79    * Fix for the ERC20 short address attack
80    *
81    * http://vessenes.com/the-erc20-short-address-attack-explained/
82    */
83    modifier onlyPayloadSize(uint size) {
84      assert(msg.data.length == size + 4);
85      _;
86    } 
87   
88   /**
89   * @dev total number of tokens in existence
90   */
91   function totalSupply() public view returns (uint256) {
92     return totalSupply_;
93   }
94 
95   /**
96   * @dev transfer token for a specified address
97   * @param _to The address to transfer to.
98   * @param _value The amount to be transferred.
99   * with fix for the ERC20 short address addtack
100   */
101   function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool) {
102     require(_to != address(0));
103     require(_value <= balances[msg.sender]);
104 
105     balances[msg.sender] = balances[msg.sender].sub(_value);
106     balances[_to] = balances[_to].add(_value);
107     emit Transfer(msg.sender, _to, _value);
108     return true;
109   }
110 
111   /**
112   * @dev Gets the balance of the specified address.
113   * @param _owner The address to query the the balance of.
114   * @return An uint256 representing the amount owned by the passed address.
115   */
116   function balanceOf(address _owner) public view returns (uint256) {
117     return balances[_owner];
118   }
119 
120 }
121 
122 /**
123  * @title ERC20 interface
124  * @dev see https://github.com/ethereum/EIPs/issues/20
125  */
126 contract ERC20 is ERC20Basic {
127   function allowance(address owner, address spender)
128     public view returns (uint256);
129 
130   function transferFrom(address from, address to, uint256 value)
131     public returns (bool);
132 
133   function approve(address spender, uint256 value) public returns (bool);
134   event Approval(
135     address indexed owner,
136     address indexed spender,
137     uint256 value
138   );
139 }
140 
141 /**
142  * @title Standard ERC20 token
143  *
144  * @dev Implementation of the basic standard token.
145  * @dev https://github.com/ethereum/EIPs/issues/20
146  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
147  */
148 contract StandardToken is ERC20, BasicToken {
149 
150   mapping (address => mapping (address => uint256)) internal allowed;
151 
152   /**
153    * @dev Transfer tokens from one address to another
154    * @param _from address The address which you want to send tokens from
155    * @param _to address The address which you want to transfer to
156    * @param _value uint256 the amount of tokens to be transferred
157    */
158   function transferFrom(
159     address _from,
160     address _to,
161     uint256 _value
162   )
163     public
164     returns (bool)
165   {
166     require(_to != address(0));
167     require(_value <= balances[_from]);
168     require(_value <= allowed[_from][msg.sender]);
169 
170     balances[_from] = balances[_from].sub(_value);
171     balances[_to] = balances[_to].add(_value);
172     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
173     emit Transfer(_from, _to, _value);
174     return true;
175   }
176 
177   /**
178    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
179    *
180    * Beware that changing an allowance with this method brings the risk that someone may use both the old
181    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
182    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
183    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
184    * @param _spender The address which will spend the funds.
185    * @param _value The amount of tokens to be spent.
186    */
187   function approve(address _spender, uint256 _value) public returns (bool) {
188     allowed[msg.sender][_spender] = _value;
189     emit Approval(msg.sender, _spender, _value);
190     return true;
191   }
192 
193   /**
194    * @dev Function to check the amount of tokens that an owner allowed to a spender.
195    * @param _owner address The address which owns the funds.
196    * @param _spender address The address which will spend the funds.
197    * @return A uint256 specifying the amount of tokens still available for the spender.
198    */
199   function allowance(
200     address _owner,
201     address _spender
202    )
203     public
204     view
205     returns (uint256)
206   {
207     return allowed[_owner][_spender];
208   }
209 
210   /**
211    * @dev Increase the amount of tokens that an owner allowed to a spender.
212    *
213    * approve should be called when allowed[_spender] == 0. To increment
214    * allowed value is better to use this function to avoid 2 calls (and wait until
215    * the first transaction is mined)
216    * From MonolithDAO Token.sol
217    * @param _spender The address which will spend the funds.
218    * @param _addedValue The amount of tokens to increase the allowance by.
219    */
220   function increaseApproval(
221     address _spender,
222     uint _addedValue
223   )
224     public
225     returns (bool)
226   {
227     allowed[msg.sender][_spender] = (
228       allowed[msg.sender][_spender].add(_addedValue));
229     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230     return true;
231   }
232 
233   /**
234    * @dev Decrease the amount of tokens that an owner allowed to a spender.
235    *
236    * approve should be called when allowed[_spender] == 0. To decrement
237    * allowed value is better to use this function to avoid 2 calls (and wait until
238    * the first transaction is mined)
239    * From MonolithDAO Token.sol
240    * @param _spender The address which will spend the funds.
241    * @param _subtractedValue The amount of tokens to decrease the allowance by.
242    */
243   function decreaseApproval(
244     address _spender,
245     uint _subtractedValue
246   )
247     public
248     returns (bool)
249   {
250     uint oldValue = allowed[msg.sender][_spender];
251     if (_subtractedValue > oldValue) {
252       allowed[msg.sender][_spender] = 0;
253     } else {
254       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
255     }
256     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
257     return true;
258   }
259 
260 }
261 
262 
263 /**
264  * @title Burnable Token
265  * @dev Token that can be irreversibly burned (destroyed).
266  */
267 contract BurnableToken is BasicToken {
268 
269   event Burn(address indexed burner, uint256 value);
270 
271   /**
272    * @dev Burns a specific amount of tokens.
273    * @param _value The amount of token to be burned.
274    */
275   function burn(uint256 _value) public {
276     _burn(msg.sender, _value);
277   }
278 
279   function _burn(address _who, uint256 _value) internal {
280     require(_value <= balances[_who]);
281     // no need to require value <= totalSupply, since that would imply the
282     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
283 
284     balances[_who] = balances[_who].sub(_value);
285     totalSupply_ = totalSupply_.sub(_value);
286     emit Burn(_who, _value);
287     emit Transfer(_who, address(0), _value);
288   }
289 }
290 
291 
292 /**
293  * @title Standard Burnable Token
294  * @dev Adds burnFrom method to ERC20 implementations
295  */
296 contract StandardBurnableToken is BurnableToken, StandardToken {
297   
298   /**
299    * @dev Burns a specific amount of tokens from the target address and decrements allowance
300    * @param _from address The address which you want to send tokens from
301    * @param _value uint256 The amount of token to be burned
302    */
303   function burnFrom(address _from, uint256 _value) public {
304     require(_value <= allowed[_from][msg.sender]);
305     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
306     // this function needs to emit an event with the updated approval.
307     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
308     _burn(_from, _value);
309   }
310 }
311 
312 /**
313  * @title SafeERC20
314  * @dev Wrappers around ERC20 operations that throw on failure.
315  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
316  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
317  */
318 library SafeERC20 {
319   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
320     require(token.transfer(to, value));
321   }
322 
323   function safeTransferFrom(
324     ERC20 token,
325     address from,
326     address to,
327     uint256 value
328   )
329     internal
330   {
331     require(token.transferFrom(from, to, value));
332   }
333 
334   function safeApprove(ERC20 token, address spender, uint256 value) internal {
335     require(token.approve(spender, value));
336   }
337 }
338 
339 
340 /**
341  * @title Asteroid Token
342  * @dev Asteroid token based on ERC20 burnableToken
343  */
344 
345 contract AsteroidToken is StandardBurnableToken {
346     using SafeERC20 for ERC20; 
347     
348     string public name = 'Asteroid Token';
349     string public symbol = 'AT';
350     uint8 public decimals = 6;
351     uint256 public INITIAL_SUPPLY = 1080000000000000;
352     
353     constructor() public {
354       totalSupply_ = INITIAL_SUPPLY;
355       balances[msg.sender] = INITIAL_SUPPLY;
356     }
357 
358 }