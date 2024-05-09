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
54 
55 /**
56  * @title ERC20Basic
57  * @dev Simpler version of ERC20 interface
58  * @dev see https://github.com/ethereum/EIPs/issues/179
59  */
60 contract ERC20Basic {
61   function totalSupply() public view returns (uint256);
62   function balanceOf(address who) public view returns (uint256);
63   function transfer(address to, uint256 value) public returns (bool);
64   event Transfer(address indexed from, address indexed to, uint256 value);
65 }
66 
67 
68 /**
69  * @title Basic token
70  * @dev Basic version of StandardToken, with no allowances.
71  */
72 contract BasicToken is ERC20Basic {
73   using SafeMath for uint256;
74 
75   mapping(address => uint256) balances;
76 
77   uint256 totalSupply_;
78 
79   /**
80   * @dev total number of tokens in existence
81   */
82   function totalSupply() public view returns (uint256) {
83     return totalSupply_;
84   }
85 
86   /**
87   * @dev transfer token for a specified address
88   * @param _to The address to transfer to.
89   * @param _value The amount to be transferred.
90   */
91   function transfer(address _to, uint256 _value) public returns (bool) {
92     require(_to != address(0));
93     require(_value <= balances[msg.sender]);
94 
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     emit Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   /**
102   * @dev Gets the balance of the specified address.
103   * @param _owner The address to query the the balance of.
104   * @return An uint256 representing the amount owned by the passed address.
105   */
106   function balanceOf(address _owner) public view returns (uint256) {
107     return balances[_owner];
108   }
109 
110 }
111 
112 
113 /**
114  * @title Burnable Token
115  * @dev Token that can be irreversibly burned (destroyed).
116  */
117 contract BurnableToken is BasicToken {
118 
119   event Burn(address indexed burner, uint256 value);
120 
121   /**
122    * @dev Burns a specific amount of tokens.
123    * @param _value The amount of token to be burned.
124    */
125   function burn(uint256 _value) public {
126     _burn(msg.sender, _value);
127   }
128 
129   function _burn(address _who, uint256 _value) internal {
130     require(_value <= balances[_who]);
131     // no need to require value <= totalSupply, since that would imply the
132     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
133 
134     balances[_who] = balances[_who].sub(_value);
135     totalSupply_ = totalSupply_.sub(_value);
136     emit Burn(_who, _value);
137     emit Transfer(_who, address(0), _value);
138   }
139 }
140 
141 
142 /**
143  * @title ERC20 interface
144  * @dev see https://github.com/ethereum/EIPs/issues/20
145  */
146 contract ERC20 is ERC20Basic {
147   function allowance(address owner, address spender)
148     public view returns (uint256);
149 
150   function transferFrom(address from, address to, uint256 value)
151     public returns (bool);
152 
153   function approve(address spender, uint256 value) public returns (bool);
154   event Approval(
155     address indexed owner,
156     address indexed spender,
157     uint256 value
158   );
159 }
160 
161 
162 /**
163  * @title Standard ERC20 token
164  *
165  * @dev Implementation of the basic standard token.
166  * @dev https://github.com/ethereum/EIPs/issues/20
167  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
168  */
169 contract StandardToken is ERC20, BasicToken {
170 
171   mapping (address => mapping (address => uint256)) internal allowed;
172 
173 
174   /**
175    * @dev Transfer tokens from one address to another
176    * @param _from address The address which you want to send tokens from
177    * @param _to address The address which you want to transfer to
178    * @param _value uint256 the amount of tokens to be transferred
179    */
180   function transferFrom(
181     address _from,
182     address _to,
183     uint256 _value
184   )
185     public
186     returns (bool)
187   {
188     require(_to != address(0));
189     require(_value <= balances[_from]);
190     require(_value <= allowed[_from][msg.sender]);
191 
192     balances[_from] = balances[_from].sub(_value);
193     balances[_to] = balances[_to].add(_value);
194     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
195     emit Transfer(_from, _to, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
201    *
202    * Beware that changing an allowance with this method brings the risk that someone may use both the old
203    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
204    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
205    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206    * @param _spender The address which will spend the funds.
207    * @param _value The amount of tokens to be spent.
208    */
209   function approve(address _spender, uint256 _value) public returns (bool) {
210     allowed[msg.sender][_spender] = _value;
211     emit Approval(msg.sender, _spender, _value);
212     return true;
213   }
214 
215   /**
216    * @dev Function to check the amount of tokens that an owner allowed to a spender.
217    * @param _owner address The address which owns the funds.
218    * @param _spender address The address which will spend the funds.
219    * @return A uint256 specifying the amount of tokens still available for the spender.
220    */
221   function allowance(
222     address _owner,
223     address _spender
224    )
225     public
226     view
227     returns (uint256)
228   {
229     return allowed[_owner][_spender];
230   }
231 
232   /**
233    * @dev Increase the amount of tokens that an owner allowed to a spender.
234    *
235    * approve should be called when allowed[_spender] == 0. To increment
236    * allowed value is better to use this function to avoid 2 calls (and wait until
237    * the first transaction is mined)
238    * From MonolithDAO Token.sol
239    * @param _spender The address which will spend the funds.
240    * @param _addedValue The amount of tokens to increase the allowance by.
241    */
242   function increaseApproval(
243     address _spender,
244     uint _addedValue
245   )
246     public
247     returns (bool)
248   {
249     allowed[msg.sender][_spender] = (
250       allowed[msg.sender][_spender].add(_addedValue));
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255   /**
256    * @dev Decrease the amount of tokens that an owner allowed to a spender.
257    *
258    * approve should be called when allowed[_spender] == 0. To decrement
259    * allowed value is better to use this function to avoid 2 calls (and wait until
260    * the first transaction is mined)
261    * From MonolithDAO Token.sol
262    * @param _spender The address which will spend the funds.
263    * @param _subtractedValue The amount of tokens to decrease the allowance by.
264    */
265   function decreaseApproval(
266     address _spender,
267     uint _subtractedValue
268   )
269     public
270     returns (bool)
271   {
272     uint oldValue = allowed[msg.sender][_spender];
273     if (_subtractedValue > oldValue) {
274       allowed[msg.sender][_spender] = 0;
275     } else {
276       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
277     }
278     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
279     return true;
280   }
281 
282 }
283 
284 
285 /**
286  * @title Standard Burnable Token
287  * @dev Adds burnFrom method to ERC20 implementations
288  */
289 contract StandardBurnableToken is BurnableToken, StandardToken {
290 
291   /**
292    * @dev Burns a specific amount of tokens from the target address and decrements allowance
293    * @param _from address The address which you want to send tokens from
294    * @param _value uint256 The amount of token to be burned
295    */
296   function burnFrom(address _from, uint256 _value) public {
297     require(_value <= allowed[_from][msg.sender]);
298     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
299     // this function needs to emit an event with the updated approval.
300     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
301     _burn(_from, _value);
302   }
303 }
304 
305 
306 contract OrganTree is StandardBurnableToken {
307     bytes32 public constant name = "OrganTree";
308     bytes32 public constant symbol = "OGT";
309     uint8 public constant decimals = 18;
310     uint256 public constant INITIAL_SUPPLY  = 2500000000000000000000000000;
311 
312     constructor() public {
313       totalSupply_ = INITIAL_SUPPLY;
314       balances[msg.sender] = INITIAL_SUPPLY;
315       emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
316     }
317 }