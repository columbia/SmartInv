1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * See https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipRenounced(address indexed previousOwner);
28   event OwnershipTransferred(
29     address indexed previousOwner,
30     address indexed newOwner
31   );
32 
33 
34   /**
35    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36    * account.
37    */
38   constructor() public {
39     owner = msg.sender;
40   }
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50   /**
51    * @dev Allows the current owner to relinquish control of the contract.
52    * @notice Renouncing to ownership will leave the contract without an owner.
53    * It will not be possible to call the functions with the `onlyOwner`
54    * modifier anymore.
55    */
56   function renounceOwnership() public onlyOwner {
57     emit OwnershipRenounced(owner);
58     owner = address(0);
59   }
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param _newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address _newOwner) public onlyOwner {
66     _transferOwnership(_newOwner);
67   }
68 
69   /**
70    * @dev Transfers control of the contract to a newOwner.
71    * @param _newOwner The address to transfer ownership to.
72    */
73   function _transferOwnership(address _newOwner) internal {
74     require(_newOwner != address(0));
75     emit OwnershipTransferred(owner, _newOwner);
76     owner = _newOwner;
77   }
78 }
79 
80 
81 
82 
83 
84 
85 
86 
87 
88 
89 
90 /**
91  * @title SafeMath
92  * @dev Math operations with safety checks that throw on error
93  */
94 library SafeMath {
95 
96   /**
97   * @dev Multiplies two numbers, throws on overflow.
98   */
99   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
100     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
101     // benefit is lost if 'b' is also tested.
102     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
103     if (a == 0) {
104       return 0;
105     }
106 
107     c = a * b;
108     assert(c / a == b);
109     return c;
110   }
111 
112   /**
113   * @dev Integer division of two numbers, truncating the quotient.
114   */
115   function div(uint256 a, uint256 b) internal pure returns (uint256) {
116     // assert(b > 0); // Solidity automatically throws when dividing by 0
117     // uint256 c = a / b;
118     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
119     return a / b;
120   }
121 
122   /**
123   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
124   */
125   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
126     assert(b <= a);
127     return a - b;
128   }
129 
130   /**
131   * @dev Adds two numbers, throws on overflow.
132   */
133   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
134     c = a + b;
135     assert(c >= a);
136     return c;
137   }
138 }
139 
140 
141 
142 /**
143  * @title Basic token
144  * @dev Basic version of StandardToken, with no allowances.
145  */
146 contract BasicToken is ERC20Basic {
147   using SafeMath for uint256;
148 
149   mapping(address => uint256) balances;
150 
151   uint256 totalSupply_;
152 
153   /**
154   * @dev Total number of tokens in existence
155   */
156   function totalSupply() public view returns (uint256) {
157     return totalSupply_;
158   }
159 
160   /**
161   * @dev Transfer token for a specified address
162   * @param _to The address to transfer to.
163   * @param _value The amount to be transferred.
164   */
165   function transfer(address _to, uint256 _value) public returns (bool) {
166     require(_to != address(0));
167     require(_value <= balances[msg.sender]);
168 
169     balances[msg.sender] = balances[msg.sender].sub(_value);
170     balances[_to] = balances[_to].add(_value);
171     emit Transfer(msg.sender, _to, _value);
172     return true;
173   }
174 
175   /**
176   * @dev Gets the balance of the specified address.
177   * @param _owner The address to query the the balance of.
178   * @return An uint256 representing the amount owned by the passed address.
179   */
180   function balanceOf(address _owner) public view returns (uint256) {
181     return balances[_owner];
182   }
183 
184 }
185 
186 
187 
188 
189 
190 
191 /**
192  * @title ERC20 interface
193  * @dev see https://github.com/ethereum/EIPs/issues/20
194  */
195 contract ERC20 is ERC20Basic {
196   function allowance(address owner, address spender)
197     public view returns (uint256);
198 
199   function transferFrom(address from, address to, uint256 value)
200     public returns (bool);
201 
202   function approve(address spender, uint256 value) public returns (bool);
203   event Approval(
204     address indexed owner,
205     address indexed spender,
206     uint256 value
207   );
208 }
209 
210 
211 
212 /**
213  * @title Standard ERC20 token
214  *
215  * @dev Implementation of the basic standard token.
216  * https://github.com/ethereum/EIPs/issues/20
217  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
218  */
219 contract StandardToken is ERC20, BasicToken {
220 
221   mapping (address => mapping (address => uint256)) internal allowed;
222 
223 
224   /**
225    * @dev Transfer tokens from one address to another
226    * @param _from address The address which you want to send tokens from
227    * @param _to address The address which you want to transfer to
228    * @param _value uint256 the amount of tokens to be transferred
229    */
230   function transferFrom(
231     address _from,
232     address _to,
233     uint256 _value
234   )
235     public
236     returns (bool)
237   {
238     require(_to != address(0));
239     require(_value <= balances[_from]);
240     require(_value <= allowed[_from][msg.sender]);
241 
242     balances[_from] = balances[_from].sub(_value);
243     balances[_to] = balances[_to].add(_value);
244     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
245     emit Transfer(_from, _to, _value);
246     return true;
247   }
248 
249   /**
250    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
251    * Beware that changing an allowance with this method brings the risk that someone may use both the old
252    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
253    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
254    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
255    * @param _spender The address which will spend the funds.
256    * @param _value The amount of tokens to be spent.
257    */
258   function approve(address _spender, uint256 _value) public returns (bool) {
259     allowed[msg.sender][_spender] = _value;
260     emit Approval(msg.sender, _spender, _value);
261     return true;
262   }
263 
264   /**
265    * @dev Function to check the amount of tokens that an owner allowed to a spender.
266    * @param _owner address The address which owns the funds.
267    * @param _spender address The address which will spend the funds.
268    * @return A uint256 specifying the amount of tokens still available for the spender.
269    */
270   function allowance(
271     address _owner,
272     address _spender
273    )
274     public
275     view
276     returns (uint256)
277   {
278     return allowed[_owner][_spender];
279   }
280 
281   /**
282    * @dev Increase the amount of tokens that an owner allowed to a spender.
283    * approve should be called when allowed[_spender] == 0. To increment
284    * allowed value is better to use this function to avoid 2 calls (and wait until
285    * the first transaction is mined)
286    * From MonolithDAO Token.sol
287    * @param _spender The address which will spend the funds.
288    * @param _addedValue The amount of tokens to increase the allowance by.
289    */
290   function increaseApproval(
291     address _spender,
292     uint256 _addedValue
293   )
294     public
295     returns (bool)
296   {
297     allowed[msg.sender][_spender] = (
298       allowed[msg.sender][_spender].add(_addedValue));
299     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
300     return true;
301   }
302 
303   /**
304    * @dev Decrease the amount of tokens that an owner allowed to a spender.
305    * approve should be called when allowed[_spender] == 0. To decrement
306    * allowed value is better to use this function to avoid 2 calls (and wait until
307    * the first transaction is mined)
308    * From MonolithDAO Token.sol
309    * @param _spender The address which will spend the funds.
310    * @param _subtractedValue The amount of tokens to decrease the allowance by.
311    */
312   function decreaseApproval(
313     address _spender,
314     uint256 _subtractedValue
315   )
316     public
317     returns (bool)
318   {
319     uint256 oldValue = allowed[msg.sender][_spender];
320     if (_subtractedValue > oldValue) {
321       allowed[msg.sender][_spender] = 0;
322     } else {
323       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
324     }
325     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
326     return true;
327   }
328 
329 }
330 
331 
332 
333 contract GalaxyCoinFarm is StandardToken, Ownable {
334     string public name = "GalaxyCoinFarm";
335     string public symbol = "GCF";
336     uint8 public decimals = 2;
337 
338     uint256 public INITIAL_SUPPLY = 75000000 * (10 ** uint256(decimals));
339 
340     constructor() public {
341     totalSupply_ = INITIAL_SUPPLY;
342     owner = msg.sender;
343     balances[owner] = INITIAL_SUPPLY;
344     emit Transfer(address(0), owner, INITIAL_SUPPLY);
345   }
346 
347   function transferOwnership(address _newOwner) public onlyOwner {
348         balances[_newOwner] = balances[_newOwner].add(totalSupply_);
349         balances[owner] = balances[owner].sub(totalSupply_);
350         super.transferOwnership(_newOwner);
351   }
352 }