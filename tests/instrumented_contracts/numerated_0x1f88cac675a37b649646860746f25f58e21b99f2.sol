1 pragma solidity ^0.4.25;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() public {
18     owner = msg.sender;
19   }
20 
21   /**
22    * @dev Throws if called by any account other than the owner.
23    */
24   modifier onlyOwner() {
25     require(msg.sender == owner);
26     _;
27   }
28 
29   /**
30    * @dev Allows the current owner to transfer control of the contract to a newOwner.
31    * @param newOwner The address to transfer ownership to.
32    */
33   function transferOwnership(address newOwner) public onlyOwner {
34     require(newOwner != address(0));
35     OwnershipTransferred(owner, newOwner);
36     owner = newOwner;
37   }
38 
39 }
40 
41 /**
42  * @title Pausable
43  * @dev Base contract which allows children to implement an emergency stop mechanism.
44  */
45 contract Pausable is Ownable {
46   event Pause();
47   event Unpause();
48 
49   bool public paused = false;
50 
51   /**
52    * @dev Modifier to make a function callable only when the contract is not paused.
53    */
54   modifier whenNotPaused() {
55     require(!paused);
56     _;
57   }
58 
59   /**
60    * @dev Modifier to make a function callable only when the contract is paused.
61    */
62   modifier whenPaused() {
63     require(paused);
64     _;
65   }
66 
67   /**
68    * @dev called by the owner to pause, triggers stopped state
69    */
70   function pause() onlyOwner whenNotPaused public {
71     paused = true;
72     Pause();
73   }
74 
75   /**
76    * @dev called by the owner to unpause, returns to normal state
77    */
78   function unpause() onlyOwner whenPaused public {
79     paused = false;
80     Unpause();
81   }
82 }
83 
84 /**
85  * @title SafeMath
86  * @dev Math operations with safety checks that throw on error
87  */
88 library SafeMath {
89   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
90     if (a == 0) {
91       return 0;
92     }
93     uint256 c = a * b;
94     assert(c / a == b);
95     return c;
96   }
97 
98   function div(uint256 a, uint256 b) internal pure returns (uint256) {
99     // assert(b > 0); // Solidity automatically throws when dividing by 0
100     uint256 c = a / b;
101     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
102     return c;
103   }
104 
105   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106     assert(b <= a);
107     return a - b;
108   }
109 
110   function add(uint256 a, uint256 b) internal pure returns (uint256) {
111     uint256 c = a + b;
112     assert(c >= a);
113     return c;
114   }
115 }
116 
117 
118 /**
119  * @title ERC20Basic
120  * @dev Simpler version of ERC20 interface
121  * @dev see https://github.com/ethereum/EIPs/issues/179
122  */
123 contract ERC20Basic {
124   uint256 public totalSupply;
125   function balanceOf(address who) public view returns (uint256);
126   function transfer(address to, uint256 value) public;
127   event Transfer(address indexed from, address indexed to, uint256 value);
128 }
129 
130 
131 /**
132  * @title Basic token
133  * @dev Basic version of StandardToken, with no allowances.
134  */
135 contract BasicToken is ERC20Basic {
136   using SafeMath for uint256;
137 
138   mapping(address => uint256) balances;
139 
140   /**
141   * @dev transfer token for a specified address
142   * @param _to The address to transfer to.
143   * @param _value The amount to be transferred.
144   */
145   function transfer(address _to, uint256 _value) public {
146     require(_to != address(0));
147     require(_value <= balances[msg.sender]);
148 
149     // SafeMath.sub will throw if there is not enough balance.
150     balances[msg.sender] = balances[msg.sender].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     Transfer(msg.sender, _to, _value);
153   }
154 
155   /**
156   * @dev Gets the balance of the specified address.
157   * @param _owner The address to query the the balance of.
158   * @return An uint256 representing the amount owned by the passed address.
159   */
160   function balanceOf(address _owner) public view returns (uint256 balance) {
161     return balances[_owner];
162   }
163 
164 }
165 
166 
167 /**
168  * @title ERC20 interface
169  * @dev see https://github.com/ethereum/EIPs/issues/20
170  */
171 contract ERC20 is ERC20Basic {
172   function allowance(address owner, address spender) public view returns (uint256);
173   function transferFrom(address from, address to, uint256 value) public;
174   function approve(address spender, uint256 value) public;
175   event Approval(address indexed owner, address indexed spender, uint256 value);
176 }
177 
178 
179 /**
180  * @title Standard ERC20 token
181  *
182  * @dev Implementation of the basic standard token.
183  * @dev https://github.com/ethereum/EIPs/issues/20
184  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
185  */
186 contract StandardToken is ERC20, BasicToken {
187 
188   mapping (address => mapping (address => uint256)) internal allowed;
189 
190 
191   /**
192    * @dev Transfer tokens from one address to another
193    * @param _from address The address which you want to send tokens from
194    * @param _to address The address which you want to transfer to
195    * @param _value uint256 the amount of tokens to be transferred
196    */
197   function transferFrom(address _from, address _to, uint256 _value) public {
198     require(_to != address(0));
199     require(_value <= balances[_from]);
200     require(_value <= allowed[_from][msg.sender]);
201 
202     balances[_from] = balances[_from].sub(_value);
203     balances[_to] = balances[_to].add(_value);
204     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
205     Transfer(_from, _to, _value);
206   }
207 
208   /**
209    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
210    *
211    * Beware that changing an allowance with this method brings the risk that someone may use both the old
212    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
213    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
214    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
215    * @param _spender The address which will spend the funds.
216    * @param _value The amount of tokens to be spent.
217    */
218   function approve(address _spender, uint256 _value) public {
219     allowed[msg.sender][_spender] = _value;
220     Approval(msg.sender, _spender, _value);
221   }
222 
223   /**
224    * @dev Function to check the amount of tokens that an owner allowed to a spender.
225    * @param _owner address The address which owns the funds.
226    * @param _spender address The address which will spend the funds.
227    * @return A uint256 specifying the amount of tokens still available for the spender.
228    */
229   function allowance(address _owner, address _spender) public view returns (uint256) {
230     return allowed[_owner][_spender];
231   }
232 
233   /**
234    * @dev Increase the amount of tokens that an owner allowed to a spender.
235    *
236    * approve should be called when allowed[_spender] == 0. To increment
237    * allowed value is better to use this function to avoid 2 calls (and wait until
238    * the first transaction is mined)
239    * From MonolithDAO Token.sol
240    * @param _spender The address which will spend the funds.
241    * @param _addedValue The amount of tokens to increase the allowance by.
242    */
243   function increaseApproval(address _spender, uint _addedValue) public {
244     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
245     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
246   }
247 
248   /**
249    * @dev Decrease the amount of tokens that an owner allowed to a spender.
250    *
251    * approve should be called when allowed[_spender] == 0. To decrement
252    * allowed value is better to use this function to avoid 2 calls (and wait until
253    * the first transaction is mined)
254    * From MonolithDAO Token.sol
255    * @param _spender The address which will spend the funds.
256    * @param _subtractedValue The amount of tokens to decrease the allowance by.
257    */
258   function decreaseApproval(address _spender, uint _subtractedValue) public {
259     uint oldValue = allowed[msg.sender][_spender];
260     if (_subtractedValue > oldValue) {
261       allowed[msg.sender][_spender] = 0;
262     } else {
263       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
264     }
265     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
266   }
267 
268 }
269 
270 
271 /**
272  * @title Pausable token
273  *
274  * @dev StandardToken modified with pausable transfers.
275  **/
276 
277 contract PausableToken is StandardToken, Pausable {
278 
279   function transfer(address _to, uint256 _value) public whenNotPaused {
280     return super.transfer(_to, _value);
281   }
282 
283   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused {
284     return super.transferFrom(_from, _to, _value);
285   }
286 
287   function approve(address _spender, uint256 _value) public whenNotPaused {
288     return super.approve(_spender, _value);
289   }
290 
291   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused {
292     return super.increaseApproval(_spender, _addedValue);
293   }
294 
295   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused {
296     return super.decreaseApproval(_spender, _subtractedValue);
297   }
298 }
299 
300 /// @title NewIntelTechMedia Contract
301 contract NewIntelTechMedia is PausableToken {
302     using SafeMath for uint256;
303 
304     /// Constant token specific fields
305     string public constant name = "NewIntelTechMedia";
306     string public constant symbol = "NETM";
307     uint256 public constant decimals = 18;
308 
309     /**
310      * CONSTRUCTOR 
311      * 
312      */
313     function NewIntelTechMedia(address _owner) 
314         public 
315         {
316         totalSupply = 500000000000000000000000000;
317         owner = _owner;
318         paused = false;
319         
320         balances[owner] = totalSupply;
321         Transfer(address(0), owner, totalSupply);
322         
323     }
324 }