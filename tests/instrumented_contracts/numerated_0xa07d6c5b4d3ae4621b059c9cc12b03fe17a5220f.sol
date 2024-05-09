1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21   function allowance(address owner, address spender) public view returns (uint256);
22   function transferFrom(address from, address to, uint256 value) public returns (bool);
23   function approve(address spender, uint256 value) public returns (bool);
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 /**
28  * @title Basic token
29  * @dev Basic version of StandardToken, with no allowances.
30  */
31 contract BasicToken is ERC20Basic {
32   using SafeMath for uint256;
33 
34   mapping(address => uint256) balances;
35 
36   /**
37   * @dev transfer token for a specified address
38   * @param _to The address to transfer to.
39   * @param _value The amount to be transferred.
40   */
41   function transfer(address _to, uint256 _value) public returns (bool) {
42     require(_to != address(0));
43     require(_value <= balances[msg.sender]);
44 
45     // SafeMath.sub will throw if there is not enough balance.
46     balances[msg.sender] = balances[msg.sender].sub(_value);
47     balances[_to] = balances[_to].add(_value);
48     Transfer(msg.sender, _to, _value);
49     return true;
50   }
51 
52   /**
53   * @dev Gets the balance of the specified address.
54   * @param _owner The address to query the the balance of.
55   * @return An uint256 representing the amount owned by the passed address.
56   */
57   function balanceOf(address _owner) public view returns (uint256 balance) {
58     return balances[_owner];
59   }
60 
61 }
62 pragma solidity ^0.4.19;
63 
64 /**
65  * @title Ownable
66  * @dev The Ownable contract has an owner address, and provides basic authorization control
67  * functions, this simplifies the implementation of "user permissions".
68  */
69 contract Ownable {
70   address public owner;
71 
72 
73   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
74 
75 
76   /**
77    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
78    * account.
79    */
80   function Ownable() public {
81     owner = msg.sender;
82   }
83 
84   /**
85    * @dev Throws if called by any account other than the owner.
86    */
87   modifier onlyOwner() {
88     require(msg.sender == owner);
89     _;
90   }
91 
92   /**
93    * @dev Allows the current owner to transfer control of the contract to a newOwner.
94    * @param newOwner The address to transfer ownership to.
95    */
96   function transferOwnership(address newOwner) public onlyOwner {
97     require(newOwner != address(0));
98     OwnershipTransferred(owner, newOwner);
99     owner = newOwner;
100   }
101 
102 }
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
115   /**
116    * @dev Transfer tokens from one address to another
117    * @param _from address The address which you want to send tokens from
118    * @param _to address The address which you want to transfer to
119    * @param _value uint256 the amount of tokens to be transferred
120    */
121   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
122     require(_to != address(0));
123     require(_value <= balances[_from]);
124     require(_value <= allowed[_from][msg.sender]);
125 
126     balances[_from] = balances[_from].sub(_value);
127     balances[_to] = balances[_to].add(_value);
128     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
129     Transfer(_from, _to, _value);
130     return true;
131   }
132 
133   /**
134    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
135    *
136    * Beware that changing an allowance with this method brings the risk that someone may use both the old
137    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
138    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
139    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
140    * @param _spender The address which will spend the funds.
141    * @param _value The amount of tokens to be spent.
142    */
143   function approve(address _spender, uint256 _value) public returns (bool) {
144     allowed[msg.sender][_spender] = _value;
145     Approval(msg.sender, _spender, _value);
146     return true;
147   }
148 
149   /**
150    * @dev Function to check the amount of tokens that an owner allowed to a spender.
151    * @param _owner address The address which owns the funds.
152    * @param _spender address The address which will spend the funds.
153    * @return A uint256 specifying the amount of tokens still available for the spender.
154    */
155   function allowance(address _owner, address _spender) public view returns (uint256) {
156     return allowed[_owner][_spender];
157   }
158 
159   /**
160    * @dev Increase the amount of tokens that an owner allowed to a spender.
161    *
162    * approve should be called when allowed[_spender] == 0. To increment
163    * allowed value is better to use this function to avoid 2 calls (and wait until
164    * the first transaction is mined)
165    * From MonolithDAO Token.sol
166    * @param _spender The address which will spend the funds.
167    * @param _addedValue The amount of tokens to increase the allowance by.
168    */
169   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
170     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
171     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
172     return true;
173   }
174 
175   /**
176    * @dev Decrease the amount of tokens that an owner allowed to a spender.
177    *
178    * approve should be called when allowed[_spender] == 0. To decrement
179    * allowed value is better to use this function to avoid 2 calls (and wait until
180    * the first transaction is mined)
181    * From MonolithDAO Token.sol
182    * @param _spender The address which will spend the funds.
183    * @param _subtractedValue The amount of tokens to decrease the allowance by.
184    */
185   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
186     uint oldValue = allowed[msg.sender][_spender];
187     if (_subtractedValue > oldValue) {
188       allowed[msg.sender][_spender] = 0;
189     } else {
190       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
191     }
192     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
193     return true;
194   }
195 
196 }
197 
198 pragma solidity ^0.4.19;
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
299 //RBCToken
300 contract RBCToken is StandardToken, Ownable, Pausable, Destructible 
301 {
302     using SafeMath for uint;
303     string public constant name = "RainbowCoin";
304     string public constant symbol = "RBC";
305     uint public constant decimals = 18;
306 
307     uint constant million=1000000e18;
308     uint constant totalToken = 90*million;
309     address public fundStorageVaultAddr = 0xb5184ec8Aa46DA6cAbAb83aB18f8c9D709d6B45e;
310     
311     function RBCToken() public
312     {
313       totalSupply = totalToken;
314       balances[fundStorageVaultAddr] = totalSupply;
315       balances[msg.sender] = 0;
316     }
317 
318 }