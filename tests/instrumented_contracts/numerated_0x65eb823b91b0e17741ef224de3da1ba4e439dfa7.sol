1 pragma solidity ^0.4.19;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   uint256 public totalSupply;
9   function balanceOf(address who) public view returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public view returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title Basic token
28  * @dev Basic version of StandardToken, with no allowances.
29  */
30 contract BasicToken is ERC20Basic {
31   using SafeMath for uint256;
32 
33   mapping(address => uint256) balances;
34 
35   /**
36   * @dev transfer token for a specified address
37   * @param _to The address to transfer to.
38   * @param _value The amount to be transferred.
39   */
40   function transfer(address _to, uint256 _value) public returns (bool) {
41     require(_to != address(0));
42     require(_value <= balances[msg.sender]);
43 
44     // SafeMath.sub will throw if there is not enough balance.
45     balances[msg.sender] = balances[msg.sender].sub(_value);
46     balances[_to] = balances[_to].add(_value);
47     Transfer(msg.sender, _to, _value);
48     return true;
49   }
50 
51   /**
52   * @dev Gets the balance of the specified address.
53   * @param _owner The address to query the the balance of.
54   * @return An uint256 representing the amount owned by the passed address.
55   */
56   function balanceOf(address _owner) public view returns (uint256 balance) {
57     return balances[_owner];
58   }
59 
60 }
61 
62 /**
63  * @title Ownable
64  * @dev The Ownable contract has an owner address, and provides basic authorization control
65  * functions, this simplifies the implementation of "user permissions".
66  */
67 contract Ownable {
68   address public owner;
69 
70 
71   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73 
74   /**
75    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
76    * account.
77    */
78   function Ownable() public {
79     owner = msg.sender;
80   }
81 
82   /**
83    * @dev Throws if called by any account other than the owner.
84    */
85   modifier onlyOwner() {
86     require(msg.sender == owner);
87     _;
88   }
89 
90 
91   /**
92    * @dev Allows the current owner to transfer control of the contract to a newOwner.
93    * @param newOwner The address to transfer ownership to.
94    */
95   function transferOwnership(address newOwner) public onlyOwner {
96     require(newOwner != address(0));
97     OwnershipTransferred(owner, newOwner);
98     owner = newOwner;
99   }
100 
101 }
102 
103 
104 /**
105  * @title Standard ERC20 token
106  *
107  * @dev Implementation of the basic standard token.
108  * @dev https://github.com/ethereum/EIPs/issues/20
109  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
110  */
111 contract StandardToken is ERC20, BasicToken {
112 
113   mapping (address => mapping (address => uint256)) internal allowed;
114 
115 
116   /**
117    * @dev Transfer tokens from one address to another
118    * @param _from address The address which you want to send tokens from
119    * @param _to address The address which you want to transfer to
120    * @param _value uint256 the amount of tokens to be transferred
121    */
122   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
123     require(_to != address(0));
124     require(_value <= balances[_from]);
125     require(_value <= allowed[_from][msg.sender]);
126 
127     balances[_from] = balances[_from].sub(_value);
128     balances[_to] = balances[_to].add(_value);
129     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
130     Transfer(_from, _to, _value);
131     return true;
132   }
133 
134   /**
135    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
136    *
137    * Beware that changing an allowance with this method brings the risk that someone may use both the old
138    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
139    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
140    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141    * @param _spender The address which will spend the funds.
142    * @param _value The amount of tokens to be spent.
143    */
144   function approve(address _spender, uint256 _value) public returns (bool) {
145     allowed[msg.sender][_spender] = _value;
146     Approval(msg.sender, _spender, _value);
147     return true;
148   }
149 
150   /**
151    * @dev Function to check the amount of tokens that an owner allowed to a spender.
152    * @param _owner address The address which owns the funds.
153    * @param _spender address The address which will spend the funds.
154    * @return A uint256 specifying the amount of tokens still available for the spender.
155    */
156   function allowance(address _owner, address _spender) public view returns (uint256) {
157     return allowed[_owner][_spender];
158   }
159 
160   /**
161    * @dev Increase the amount of tokens that an owner allowed to a spender.
162    *
163    * approve should be called when allowed[_spender] == 0. To increment
164    * allowed value is better to use this function to avoid 2 calls (and wait until
165    * the first transaction is mined)
166    * From MonolithDAO Token.sol
167    * @param _spender The address which will spend the funds.
168    * @param _addedValue The amount of tokens to increase the allowance by.
169    */
170   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
171     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
172     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173     return true;
174   }
175 
176   /**
177    * @dev Decrease the amount of tokens that an owner allowed to a spender.
178    *
179    * approve should be called when allowed[_spender] == 0. To decrement
180    * allowed value is better to use this function to avoid 2 calls (and wait until
181    * the first transaction is mined)
182    * From MonolithDAO Token.sol
183    * @param _spender The address which will spend the funds.
184    * @param _subtractedValue The amount of tokens to decrease the allowance by.
185    */
186   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
187     uint oldValue = allowed[msg.sender][_spender];
188     if (_subtractedValue > oldValue) {
189       allowed[msg.sender][_spender] = 0;
190     } else {
191       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
192     }
193     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
194     return true;
195   }
196 
197 }
198 
199 
200 /**
201  * @title SafeMath
202  * @dev Math operations with safety checks that throw on error
203  */
204 library SafeMath {
205   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
206     if (a == 0) {
207       return 0;
208     }
209     uint256 c = a * b;
210     assert(c / a == b);
211     return c;
212   }
213 
214   function div(uint256 a, uint256 b) internal pure returns (uint256) {
215     // assert(b > 0); // Solidity automatically throws when dividing by 0
216     uint256 c = a / b;
217     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
218     return c;
219   }
220 
221   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
222     assert(b <= a);
223     return a - b;
224   }
225 
226   function add(uint256 a, uint256 b) internal pure returns (uint256) {
227     uint256 c = a + b;
228     assert(c >= a);
229     return c;
230   }
231 }
232 
233 
234 /**
235  * @title Destructible
236  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
237  */
238 contract Destructible is Ownable {
239 
240     function Destructible() public payable { }
241 
242     /**
243      * @dev Transfers the current balance to the owner and terminates the contract.
244      */
245     function destroy() onlyOwner public {
246         selfdestruct(owner);
247     }
248 
249     function destroyAndSend(address _recipient) onlyOwner public {
250         selfdestruct(_recipient);
251     }
252 }
253 
254 
255 /**
256  * @title Pausable
257  * @dev Base contract which allows children to implement an emergency stop mechanism.
258  */
259 contract Pausable is Ownable {
260     event Pause();
261     event Unpause();
262 
263     bool public paused = false;
264 
265 
266     /**
267      * @dev Modifier to make a function callable only when the contract is not paused.
268      */
269     modifier whenNotPaused() {
270         require(!paused);
271         _;
272     }
273 
274     /**
275      * @dev Modifier to make a function callable only when the contract is paused.
276      */
277     modifier whenPaused() {
278         require(paused);
279         _;
280     }
281 
282     /**
283      * @dev called by the owner to pause, triggers stopped state
284      */
285     function pause() onlyOwner whenNotPaused public {
286         paused = true;
287         Pause();
288     }
289 
290     /**
291      * @dev called by the owner to unpause, returns to normal state
292      */
293     function unpause() onlyOwner whenPaused public {
294         paused = false;
295         Unpause();
296     }
297 }
298 
299 
300 /// @title ETTToken - Token code for the ETT Project
301 contract ETTToken is StandardToken, Ownable, Pausable, Destructible {
302 
303     using SafeMath for uint;
304     string public constant name = "Exchange Test Token";
305     string public constant symbol = "ETT";
306     uint public constant decimals = 18;
307 
308     uint constant million=1000000e18;
309     //total token supply: 680million
310     uint constant totalToken = 100*million;
311 
312     //@notice  Constructor of TPKToken
313     function ETTToken() public {
314       totalSupply = totalToken;
315       balances[msg.sender] = totalSupply;
316     }
317 
318 }