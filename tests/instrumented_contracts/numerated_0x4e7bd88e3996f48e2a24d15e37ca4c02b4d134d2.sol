1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 /**
46  * @title ERC20Basic
47  * @dev Simpler version of ERC20 interface
48  * @dev see https://github.com/ethereum/EIPs/issues/179
49  */
50 contract ERC20Basic {
51   uint256 public totalSupply;
52   function balanceOf(address who) public view returns (uint256);
53   function transfer(address to, uint256 value) public returns (bool);
54   event Transfer(address indexed from, address indexed to, uint256 value);
55 }
56 
57 /**
58  * @title ERC20 interface
59  * @dev see https://github.com/ethereum/EIPs/issues/20
60  */
61 contract ERC20 is ERC20Basic {
62   function allowance(address owner, address spender) public view returns (uint256);
63   function transferFrom(address from, address to, uint256 value) public returns (bool);
64   function approve(address spender, uint256 value) public returns (bool);
65   event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 /**
69  * @title SafeMath
70  * @dev Math operations with safety checks that throw on error
71  */
72 library SafeMath {
73   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74     if (a == 0) {
75       return 0;
76     }
77     uint256 c = a * b;
78     assert(c / a == b);
79     return c;
80   }
81 
82   function div(uint256 a, uint256 b) internal pure returns (uint256) {
83     // assert(b > 0); // Solidity automatically throws when dividing by 0
84     uint256 c = a / b;
85     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
86     return c;
87   }
88 
89   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
90     assert(b <= a);
91     return a - b;
92   }
93 
94   function add(uint256 a, uint256 b) internal pure returns (uint256) {
95     uint256 c = a + b;
96     assert(c >= a);
97     return c;
98   }
99 }
100 
101 
102 /**
103  * @title Basic token
104  * @dev Basic version of StandardToken, with no allowances.
105  */
106 contract BasicToken is ERC20Basic {
107   using SafeMath for uint256;
108 
109   mapping(address => uint256) balances;
110 
111   /**
112   * @dev transfer token for a specified address
113   * @param _to The address to transfer to.
114   * @param _value The amount to be transferred.
115   */
116   function transfer(address _to, uint256 _value) public returns (bool) {
117     require(_to != address(0));
118     require(_value <= balances[msg.sender]);
119 
120     // SafeMath.sub will throw if there is not enough balance.
121     balances[msg.sender] = balances[msg.sender].sub(_value);
122     balances[_to] = balances[_to].add(_value);
123     emit Transfer(msg.sender, _to, _value);
124     return true;
125   }
126 
127   /**
128   * @dev Gets the balance of the specified address.
129   * @param _owner The address to query the the balance of.
130   * @return An uint256 representing the amount owned by the passed address.
131   */
132   function balanceOf(address _owner) public view returns (uint256 balance) {
133     return balances[_owner];
134   }
135 
136 }
137 
138 
139 
140 /**
141  * @title Standard ERC20 token
142  *
143  * @dev Implementation of the basic standard token.
144  * @dev https://github.com/ethereum/EIPs/issues/20
145  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
146  */
147 contract StandardToken is ERC20, BasicToken {
148 
149   mapping (address => mapping (address => uint256)) internal allowed;
150 
151 
152   /**
153    * @dev Transfer tokens from one address to another
154    * @param _from address The address which you want to send tokens from
155    * @param _to address The address which you want to transfer to
156    * @param _value uint256 the amount of tokens to be transferred
157    */
158   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
159     require(_to != address(0));
160     require(_value <= balances[_from]);
161     require(_value <= allowed[_from][msg.sender]);
162 
163     balances[_from] = balances[_from].sub(_value);
164     balances[_to] = balances[_to].add(_value);
165     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
166     emit Transfer(_from, _to, _value);
167     return true;
168   }
169 
170   /**
171    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
172    *
173    * Beware that changing an allowance with this method brings the risk that someone may use both the old
174    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
175    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
176    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177    * @param _spender The address which will spend the funds.
178    * @param _value The amount of tokens to be spent.
179    */
180   function approve(address _spender, uint256 _value) public returns (bool) {
181     allowed[msg.sender][_spender] = _value;
182     emit Approval(msg.sender, _spender, _value);
183     return true;
184   }
185 
186   /**
187    * @dev Function to check the amount of tokens that an owner allowed to a spender.
188    * @param _owner address The address which owns the funds.
189    * @param _spender address The address which will spend the funds.
190    * @return A uint256 specifying the amount of tokens still available for the spender.
191    */
192   function allowance(address _owner, address _spender) public view returns (uint256) {
193     return allowed[_owner][_spender];
194   }
195 
196   /**
197    * @dev Increase the amount of tokens that an owner allowed to a spender.
198    *
199    * approve should be called when allowed[_spender] == 0. To increment
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    * @param _spender The address which will spend the funds.
204    * @param _addedValue The amount of tokens to increase the allowance by.
205    */
206   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
207     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
208     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209     return true;
210   }
211 
212   /**
213    * @dev Decrease the amount of tokens that an owner allowed to a spender.
214    *
215    * approve should be called when allowed[_spender] == 0. To decrement
216    * allowed value is better to use this function to avoid 2 calls (and wait until
217    * the first transaction is mined)
218    * From MonolithDAO Token.sol
219    * @param _spender The address which will spend the funds.
220    * @param _subtractedValue The amount of tokens to decrease the allowance by.
221    */
222   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
223     uint oldValue = allowed[msg.sender][_spender];
224     if (_subtractedValue > oldValue) {
225       allowed[msg.sender][_spender] = 0;
226     } else {
227       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
228     }
229     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230     return true;
231   }
232 
233 }
234 
235 /**
236  * @title Pausable
237  * @dev Base contract which allows children to implement an emergency stop mechanism.
238  */
239 contract Pausable is Ownable {
240   event Pause();
241   event Unpause();
242 
243   bool public paused = false;
244 
245 
246   /**
247    * @dev Modifier to make a function callable only when the contract is not paused.
248    */
249   modifier whenNotPaused() {
250     require(!paused);
251     _;
252   }
253 
254   /**
255    * @dev Modifier to make a function callable only when the contract is paused.
256    */
257   modifier whenPaused() {
258     require(paused);
259     _;
260   }
261 
262   /**
263    * @dev called by the owner to pause, triggers stopped state
264    */
265   function pause() onlyOwner whenNotPaused public {
266     paused = true;
267     emit Pause();
268   }
269 
270   /**
271    * @dev called by the owner to unpause, returns to normal state
272    */
273   function unpause() onlyOwner whenPaused public {
274     paused = false;
275     emit Unpause();
276   }
277 }
278 
279 /**
280  * @title Mintable token
281  * @dev Simple ERC20 Token example, with mintable token creation
282  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
283  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
284  */
285 
286 contract MintablePausableToken is StandardToken, Ownable, Pausable {
287   event Mint(address indexed to, uint256 amount);
288   event MintFinished();
289 
290   bool public mintingFinished = false;
291 
292   modifier canMint() {
293     require(!mintingFinished);
294     _;
295   }
296 
297   /**
298    * @dev Function to mint tokens
299    * @param _to The address that will receive the minted tokens.
300    * @param _amount The amount of tokens to mint.
301    * @return A boolean that indicates if the operation was successful.
302    */
303   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
304     totalSupply = totalSupply.add(_amount);
305     balances[_to] = balances[_to].add(_amount);
306     emit Mint(_to, _amount);
307     emit Transfer(address(0), _to, _amount);
308     return true;
309   }
310 
311   /**
312    * @dev Function to stop minting new tokens.
313    * @return True if the operation was successful.
314    */
315   function finishMinting() onlyOwner canMint public returns (bool) {
316     mintingFinished = true;
317     emit MintFinished();
318     return true;
319   }
320 
321   function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {
322     require(!paused);
323     return super.transferFrom(_from, _to, _value);
324   }
325 
326   function transfer(address _to, uint256 _value) public returns (bool _success) {
327     require(!paused);
328     return super.transfer(_to, _value);
329   }
330 }
331 
332 contract SuperbloomToken is MintablePausableToken {
333   string public name = "Superbloom Network";
334   string public symbol = "SEED";
335   uint8 public decimals = 18;
336 }