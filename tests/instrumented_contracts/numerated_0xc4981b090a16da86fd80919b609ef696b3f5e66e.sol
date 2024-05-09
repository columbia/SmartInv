1 pragma solidity ^0.4.23;
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
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56   function totalSupply() public view returns (uint256);
57   function balanceOf(address who) public view returns (uint256);
58   function transfer(address to, uint256 value) public returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 /**
63  * @title ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 contract ERC20 is ERC20Basic {
67   function allowance(address owner, address spender)
68     public view returns (uint256);
69 
70   function transferFrom(address from, address to, uint256 value)
71     public returns (bool);
72 
73   function approve(address spender, uint256 value) public returns (bool);
74   event Approval(
75     address indexed owner,
76     address indexed spender,
77     uint256 value
78   );
79 }
80 
81 /**
82  * @title Basic token
83  * @dev Basic version of StandardToken, with no allowances.
84  */
85 contract BasicToken is ERC20Basic {
86   using SafeMath for uint256;
87 
88   mapping(address => uint256) balances;
89 
90   uint256 totalSupply_;
91 
92   /**
93   * @dev total number of tokens in existence
94   */
95   function totalSupply() public view returns (uint256) {
96     return totalSupply_;
97   }
98 
99   /**
100   * @dev transfer token for a specified address
101   * @param _to The address to transfer to.
102   * @param _value The amount to be transferred.
103   */
104   function transfer(address _to, uint256 _value) public returns (bool) {
105     require(_to != address(0));
106     require(_value <= balances[msg.sender]);
107 
108     balances[msg.sender] = balances[msg.sender].sub(_value);
109     balances[_to] = balances[_to].add(_value);
110     emit Transfer(msg.sender, _to, _value);
111     return true;
112   }
113 
114   /**
115   * @dev Gets the balance of the specified address.
116   * @param _owner The address to query the the balance of.
117   * @return An uint256 representing the amount owned by the passed address.
118   */
119   function balanceOf(address _owner) public view returns (uint256) {
120     return balances[_owner];
121   }
122 
123 }
124 
125 /**
126  * @title Standard ERC20 token
127  *
128  * @dev Implementation of the basic standard token.
129  * @dev https://github.com/ethereum/EIPs/issues/20
130  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
131  */
132 contract StandardToken is ERC20, BasicToken {
133 
134   mapping (address => mapping (address => uint256)) internal allowed;
135 
136 
137   /**
138    * @dev Transfer tokens from one address to another
139    * @param _from address The address which you want to send tokens from
140    * @param _to address The address which you want to transfer to
141    * @param _value uint256 the amount of tokens to be transferred
142    */
143   function transferFrom(
144     address _from,
145     address _to,
146     uint256 _value
147   )
148     public
149     returns (bool)
150   {
151     require(_to != address(0));
152     require(_value <= balances[_from]);
153     require(_value <= allowed[_from][msg.sender]);
154 
155     balances[_from] = balances[_from].sub(_value);
156     balances[_to] = balances[_to].add(_value);
157     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
158     emit Transfer(_from, _to, _value);
159     return true;
160   }
161 
162   /**
163    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
164    *
165    * Beware that changing an allowance with this method brings the risk that someone may use both the old
166    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
167    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
168    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169    * @param _spender The address which will spend the funds.
170    * @param _value The amount of tokens to be spent.
171    */
172   function approve(address _spender, uint256 _value) public returns (bool) {
173     allowed[msg.sender][_spender] = _value;
174     emit Approval(msg.sender, _spender, _value);
175     return true;
176   }
177 
178   /**
179    * @dev Function to check the amount of tokens that an owner allowed to a spender.
180    * @param _owner address The address which owns the funds.
181    * @param _spender address The address which will spend the funds.
182    * @return A uint256 specifying the amount of tokens still available for the spender.
183    */
184   function allowance(
185     address _owner,
186     address _spender
187    )
188     public
189     view
190     returns (uint256)
191   {
192     return allowed[_owner][_spender];
193   }
194 
195   /**
196    * @dev Increase the amount of tokens that an owner allowed to a spender.
197    *
198    * approve should be called when allowed[_spender] == 0. To increment
199    * allowed value is better to use this function to avoid 2 calls (and wait until
200    * the first transaction is mined)
201    * From MonolithDAO Token.sol
202    * @param _spender The address which will spend the funds.
203    * @param _addedValue The amount of tokens to increase the allowance by.
204    */
205   function increaseApproval(
206     address _spender,
207     uint _addedValue
208   )
209     public
210     returns (bool)
211   {
212     allowed[msg.sender][_spender] = (
213       allowed[msg.sender][_spender].add(_addedValue));
214     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215     return true;
216   }
217 
218   /**
219    * @dev Decrease the amount of tokens that an owner allowed to a spender.
220    *
221    * approve should be called when allowed[_spender] == 0. To decrement
222    * allowed value is better to use this function to avoid 2 calls (and wait until
223    * the first transaction is mined)
224    * From MonolithDAO Token.sol
225    * @param _spender The address which will spend the funds.
226    * @param _subtractedValue The amount of tokens to decrease the allowance by.
227    */
228   function decreaseApproval(
229     address _spender,
230     uint _subtractedValue
231   )
232     public
233     returns (bool)
234   {
235     uint oldValue = allowed[msg.sender][_spender];
236     if (_subtractedValue > oldValue) {
237       allowed[msg.sender][_spender] = 0;
238     } else {
239       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
240     }
241     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242     return true;
243   }
244 
245 }
246 
247 /**
248  * @title Burnable Token
249  * @dev Token that can be irreversibly burned (destroyed).
250  */
251 contract BurnableToken is BasicToken {
252 
253   event Burn(address indexed burner, uint256 value);
254 
255   /**
256    * @dev Burns a specific amount of tokens.
257    * @param _value The amount of token to be burned.
258    */
259   function burn(uint256 _value) public {
260     _burn(msg.sender, _value);
261   }
262 
263   function _burn(address _who, uint256 _value) internal {
264     require(_value <= balances[_who]);
265     // no need to require value <= totalSupply, since that would imply the
266     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
267 
268     balances[_who] = balances[_who].sub(_value);
269     totalSupply_ = totalSupply_.sub(_value);
270     emit Burn(_who, _value);
271     emit Transfer(_who, address(0), _value);
272   }
273 }
274 
275 /**
276  * @title Standard Burnable Token
277  * @dev Adds burnFrom method to ERC20 implementations
278  */
279 contract StandardBurnableToken is BurnableToken, StandardToken {
280 
281   /**
282    * @dev Burns a specific amount of tokens from the target address and decrements allowance
283    * @param _from address The address which you want to send tokens from
284    * @param _value uint256 The amount of token to be burned
285    */
286   function burnFrom(address _from, uint256 _value) public {
287     require(_value <= allowed[_from][msg.sender]);
288     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
289     // this function needs to emit an event with the updated approval.
290     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
291     _burn(_from, _value);
292   }
293 }
294 
295 contract DetailedERC20 is ERC20 {
296   string public name;
297   string public symbol;
298   uint8 public decimals;
299 
300   constructor(string _name, string _symbol, uint8 _decimals) public {
301     name = _name;
302     symbol = _symbol;
303     decimals = _decimals;
304   }
305 }
306 
307 contract LovrToken is StandardBurnableToken, DetailedERC20 {
308     
309 
310     constructor(uint256 totalSupply, string _name, string _symbol, uint8 _decimals) public
311     DetailedERC20(_name, _symbol, _decimals)
312     {
313         totalSupply_ = totalSupply * 10 ** uint(_decimals);
314         balances[msg.sender] = totalSupply * 10 ** uint(_decimals);
315         emit Transfer(0x0, msg.sender, totalSupply * 10 ** uint(_decimals));
316     }
317 }