1 /* ===============================================
2  * Flattened with Solidifier by Coinage
3  * 
4  * https://solidifier.coina.ge
5  * ===============================================
6 */
7 
8 
9 pragma solidity 0.4.24;
10 
11 
12 /**
13  * @title ERC20Basic
14  * @dev Simpler version of ERC20 interface
15  * @dev see https://github.com/ethereum/EIPs/issues/179
16  */
17 contract ERC20Basic {
18   function totalSupply() public view returns (uint256);
19   function balanceOf(address who) public view returns (uint256);
20   function transfer(address to, uint256 value) public returns (bool);
21   event Transfer(address indexed from, address indexed to, uint256 value);
22 }
23 
24 
25 /**
26  * @title SafeMath
27  * @dev Math operations with safety checks that throw on error
28  */
29 library SafeMath {
30 
31   /**
32   * @dev Multiplies two numbers, throws on overflow.
33   */
34   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
35     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
36     // benefit is lost if 'b' is also tested.
37     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
38     if (a == 0) {
39       return 0;
40     }
41 
42     c = a * b;
43     assert(c / a == b);
44     return c;
45   }
46 
47   /**
48   * @dev Integer division of two numbers, truncating the quotient.
49   */
50   function div(uint256 a, uint256 b) internal pure returns (uint256) {
51     // assert(b > 0); // Solidity automatically throws when dividing by 0
52     // uint256 c = a / b;
53     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54     return a / b;
55   }
56 
57   /**
58   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
59   */
60   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61     assert(b <= a);
62     return a - b;
63   }
64 
65   /**
66   * @dev Adds two numbers, throws on overflow.
67   */
68   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
69     c = a + b;
70     assert(c >= a);
71     return c;
72   }
73 }
74 
75 
76 /**
77  * @title Basic token
78  * @dev Basic version of StandardToken, with no allowances.
79  */
80 contract BasicToken is ERC20Basic {
81   using SafeMath for uint256;
82 
83   mapping(address => uint256) balances;
84 
85   uint256 totalSupply_;
86 
87   /**
88   * @dev total number of tokens in existence
89   */
90   function totalSupply() public view returns (uint256) {
91     return totalSupply_;
92   }
93 
94   /**
95   * @dev transfer token for a specified address
96   * @param _to The address to transfer to.
97   * @param _value The amount to be transferred.
98   */
99   function transfer(address _to, uint256 _value) public returns (bool) {
100     require(_to != address(0));
101     require(_value <= balances[msg.sender]);
102 
103     balances[msg.sender] = balances[msg.sender].sub(_value);
104     balances[_to] = balances[_to].add(_value);
105     emit Transfer(msg.sender, _to, _value);
106     return true;
107   }
108 
109   /**
110   * @dev Gets the balance of the specified address.
111   * @param _owner The address to query the the balance of.
112   * @return An uint256 representing the amount owned by the passed address.
113   */
114   function balanceOf(address _owner) public view returns (uint256) {
115     return balances[_owner];
116   }
117 
118 }
119 
120 
121 /**
122  * @title Burnable Token
123  * @dev Token that can be irreversibly burned (destroyed).
124  */
125 contract BurnableToken is BasicToken {
126 
127   event Burn(address indexed burner, uint256 value);
128 
129   /**
130    * @dev Burns a specific amount of tokens.
131    * @param _value The amount of token to be burned.
132    */
133   function burn(uint256 _value) public {
134     _burn(msg.sender, _value);
135   }
136 
137   function _burn(address _who, uint256 _value) internal {
138     require(_value <= balances[_who]);
139     // no need to require value <= totalSupply, since that would imply the
140     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
141 
142     balances[_who] = balances[_who].sub(_value);
143     totalSupply_ = totalSupply_.sub(_value);
144     emit Burn(_who, _value);
145     emit Transfer(_who, address(0), _value);
146   }
147 }
148 
149 
150 /**
151  * @title ERC20 interface
152  * @dev see https://github.com/ethereum/EIPs/issues/20
153  */
154 contract ERC20 is ERC20Basic {
155   function allowance(address owner, address spender)
156     public view returns (uint256);
157 
158   function transferFrom(address from, address to, uint256 value)
159     public returns (bool);
160 
161   function approve(address spender, uint256 value) public returns (bool);
162   event Approval(
163     address indexed owner,
164     address indexed spender,
165     uint256 value
166   );
167 }
168 
169 
170 /**
171  * @title Standard ERC20 token
172  *
173  * @dev Implementation of the basic standard token.
174  * @dev https://github.com/ethereum/EIPs/issues/20
175  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
176  */
177 contract StandardToken is ERC20, BasicToken {
178 
179   mapping (address => mapping (address => uint256)) internal allowed;
180 
181 
182   /**
183    * @dev Transfer tokens from one address to another
184    * @param _from address The address which you want to send tokens from
185    * @param _to address The address which you want to transfer to
186    * @param _value uint256 the amount of tokens to be transferred
187    */
188   function transferFrom(
189     address _from,
190     address _to,
191     uint256 _value
192   )
193     public
194     returns (bool)
195   {
196     require(_to != address(0));
197     require(_value <= balances[_from]);
198     require(_value <= allowed[_from][msg.sender]);
199 
200     balances[_from] = balances[_from].sub(_value);
201     balances[_to] = balances[_to].add(_value);
202     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
203     emit Transfer(_from, _to, _value);
204     return true;
205   }
206 
207   /**
208    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
209    *
210    * Beware that changing an allowance with this method brings the risk that someone may use both the old
211    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
212    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
213    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
214    * @param _spender The address which will spend the funds.
215    * @param _value The amount of tokens to be spent.
216    */
217   function approve(address _spender, uint256 _value) public returns (bool) {
218     allowed[msg.sender][_spender] = _value;
219     emit Approval(msg.sender, _spender, _value);
220     return true;
221   }
222 
223   /**
224    * @dev Function to check the amount of tokens that an owner allowed to a spender.
225    * @param _owner address The address which owns the funds.
226    * @param _spender address The address which will spend the funds.
227    * @return A uint256 specifying the amount of tokens still available for the spender.
228    */
229   function allowance(
230     address _owner,
231     address _spender
232    )
233     public
234     view
235     returns (uint256)
236   {
237     return allowed[_owner][_spender];
238   }
239 
240   /**
241    * @dev Increase the amount of tokens that an owner allowed to a spender.
242    *
243    * approve should be called when allowed[_spender] == 0. To increment
244    * allowed value is better to use this function to avoid 2 calls (and wait until
245    * the first transaction is mined)
246    * From MonolithDAO Token.sol
247    * @param _spender The address which will spend the funds.
248    * @param _addedValue The amount of tokens to increase the allowance by.
249    */
250   function increaseApproval(
251     address _spender,
252     uint _addedValue
253   )
254     public
255     returns (bool)
256   {
257     allowed[msg.sender][_spender] = (
258       allowed[msg.sender][_spender].add(_addedValue));
259     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260     return true;
261   }
262 
263   /**
264    * @dev Decrease the amount of tokens that an owner allowed to a spender.
265    *
266    * approve should be called when allowed[_spender] == 0. To decrement
267    * allowed value is better to use this function to avoid 2 calls (and wait until
268    * the first transaction is mined)
269    * From MonolithDAO Token.sol
270    * @param _spender The address which will spend the funds.
271    * @param _subtractedValue The amount of tokens to decrease the allowance by.
272    */
273   function decreaseApproval(
274     address _spender,
275     uint _subtractedValue
276   )
277     public
278     returns (bool)
279   {
280     uint oldValue = allowed[msg.sender][_spender];
281     if (_subtractedValue > oldValue) {
282       allowed[msg.sender][_spender] = 0;
283     } else {
284       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
285     }
286     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
287     return true;
288   }
289 
290 }
291 
292 
293 /**
294  * @title Standard Burnable Token
295  * @dev Adds burnFrom method to ERC20 implementations
296  */
297 contract StandardBurnableToken is BurnableToken, StandardToken {
298 
299   /**
300    * @dev Burns a specific amount of tokens from the target address and decrements allowance
301    * @param _from address The address which you want to send tokens from
302    * @param _value uint256 The amount of token to be burned
303    */
304   function burnFrom(address _from, uint256 _value) public {
305     require(_value <= allowed[_from][msg.sender]);
306     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
307     // this function needs to emit an event with the updated approval.
308     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
309     _burn(_from, _value);
310   }
311 }
312 
313 
314 contract ExposureToken is StandardBurnableToken {
315     string public constant name = "Exposure";
316     string public constant symbol = "EXPO";
317     uint8 public constant decimals = 18;
318 
319     constructor() public 
320     {
321         // 1 BILLION EXPOSURE
322         totalSupply_ = 1000000000 ether;
323         
324         // Owner starts with all of the Exposure.
325         balances[msg.sender] = totalSupply_;
326         emit Transfer(0, msg.sender, totalSupply_);
327     }
328 }