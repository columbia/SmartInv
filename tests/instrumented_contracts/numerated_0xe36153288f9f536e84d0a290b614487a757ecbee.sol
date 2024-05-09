1 pragma solidity ^0.5.2;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two numbers, reverts on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         require(c / a == b, "multiplication constraint voilated");
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // Solidity only automatically asserts when dividing by 0
27         require(b > 0, "division constraint voilated");
28         uint256 c = a / b;
29         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30         return c;
31     }
32 
33     /**
34     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         require(b <= a, "substracts constraint voilated");
38         uint256 c = a - b;
39         return c;
40     }
41 
42     /**
43     * @dev Adds two numbers, reverts on overflow.
44     */
45     function add(uint256 a, uint256 b) internal pure returns (uint256) {
46         uint256 c = a + b;
47         require(c >= a, "addition constraint voilated");
48         return c;
49     }
50 
51     /**
52     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
53     * reverts when dividing by zero.
54     */
55     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
56         require(b != 0, "divides contraint voilated");
57         return a % b;
58     }
59 }
60 
61 /**
62  * @title Ownable
63  * @dev The Ownable contract has an owner address, and provides basic authorization control
64  * functions, this simplifies the implementation of "user permissions".
65  */
66 contract Ownable {
67   address public owner;
68   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71    * account.
72    */
73   constructor() public{
74     owner = msg.sender;
75   }
76   /**
77    * @dev Throws if called by any account other than the owner.
78    */
79   modifier onlyOwner() {
80     require(msg.sender == owner, "Ownable: only owner can execute");
81     _;
82   }
83   /**
84    * @dev Allows the current owner to transfer control of the contract to a newOwner.
85    * @param newOwner The address to transfer ownership to.
86    */
87   function transferOwnership(address newOwner) public onlyOwner {
88     require(newOwner != address(0), "Ownable: new owner should not empty");
89     emit OwnershipTransferred(owner, newOwner);
90     owner = newOwner;
91   }
92 }
93 contract Pausable is Ownable {
94   event Pause();
95   event Unpause();
96 
97   bool public paused = false;
98 
99   /**
100    * @dev modifier to allow actions only when the contract IS paused
101    */
102   modifier whenNotPaused() {
103     require(!paused, "Pausable: contract not paused");
104     _;
105   }
106   /**
107    * @dev modifier to allow actions only when the contract IS NOT paused
108    */
109   modifier whenPaused {
110     require(paused, "Pausable: contract paused");
111     _;
112   }
113   /**
114    * @dev called by the owner to pause, triggers stopped state
115    */
116   function pause() public onlyOwner whenNotPaused returns (bool) {
117     paused = true;
118     emit Pause();
119     return true;
120   }
121 
122   /**
123    * @dev called by the owner to unpause, returns to normal state
124    */
125   function unpause() public onlyOwner whenPaused returns (bool) {
126     paused = false;
127     emit Unpause();
128     return true;
129   }
130 }
131 
132 
133 /**
134  * @title ERC20Basic
135  * @dev Simpler version of ERC20 interface
136  * @dev see https://github.com/ethereum/EIPs/issues/179
137  */
138 contract ERC20Basic {
139   uint256 public totalSupply;
140   function balanceOf(address who) public view returns (uint256);
141   function transfer(address to, uint256 value) public returns (bool);
142   event Transfer(address indexed from, address indexed to, uint256 value);
143 }
144 /**
145  * @title Basic token
146  * @dev Basic version of StandardToken, with no allowances.
147  */
148 contract BasicToken is ERC20Basic {
149   using SafeMath for uint256;
150   mapping(address => uint256) balances;
151   /**
152   * @dev transfer token for a specified address
153   * @param _to The address to transfer to.
154   * @param _value The amount to be transferred.
155   */
156   function transfer(address _to, uint256 _value) public returns (bool) {
157     require(_to != address(0), "BasicToken: require to address");
158     // SafeMath.sub will throw if there is not enough balance.
159     balances[msg.sender] = balances[msg.sender].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     emit Transfer(msg.sender, _to, _value);
162     return true;
163   }
164   /**
165   * @dev Gets the balance of the specified address.
166   * @param _owner The address to query the the balance of.
167   * @return An uint256 representing the amount owned by the passed address.
168   */
169   function balanceOf(address _owner) public view returns (uint256 balance) {
170     return balances[_owner];
171   }
172 }
173 /**
174  * @title ERC20 interface
175  * @dev see https://github.com/ethereum/EIPs/issues/20
176  */
177 contract ERC20 is ERC20Basic {
178   function allowance(address owner, address spender) public view returns (uint256);
179   function transferFrom(address from, address to, uint256 value) public returns (bool);
180   function approve(address spender, uint256 value) public returns (bool);
181   event Approval(address indexed owner, address indexed spender, uint256 value);
182 }
183 /**
184  * @title Standard ERC20 token
185  *
186  * @dev Implementation of the basic standard token.
187  * @dev https://github.com/ethereum/EIPs/issues/20
188  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
189  */
190 contract StandardToken is ERC20, BasicToken {
191   mapping (address => mapping (address => uint256)) allowed;
192   /**
193    * @dev Transfer tokens from one address to another
194    * @param _from address The address which you want to send tokens from
195    * @param _to address The address which you want to transfer to
196    * @param _value uint256 the amount of tokens to be transferred
197    */
198   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
199     require(_to != address(0), "StandardToken: receiver address empty");
200     uint256 _allowance = allowed[_from][msg.sender];
201     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
202     // require (_value <= _allowance);
203     balances[_from] = balances[_from].sub(_value);
204     balances[_to] = balances[_to].add(_value);
205     allowed[_from][msg.sender] = _allowance.sub(_value);
206     emit Transfer(_from, _to, _value);
207     return true;
208   }
209   /**
210    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
211    *
212    * Beware that changing an allowance with this method brings the risk that someone may use both the old
213    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
214    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
215    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
216    * @param _spender The address which will spend the funds.
217    * @param _value The amount of tokens to be spent.
218    */
219   function approve(address _spender, uint256 _value) public returns (bool) {
220     require(_spender != address(0), "StandardToken: spender address empty");
221     allowed[msg.sender][_spender] = _value;
222     emit Approval(msg.sender, _spender, _value);
223     return true;
224   }
225   /**
226    * @dev Function to check the amount of tokens that an owner allowed to a spender.
227    * @param _owner address The address which owns the funds.
228    * @param _spender address The address which will spend the funds.
229    * @return A uint256 specifying the amount of tokens still available for the spender.
230    */
231   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
232     return allowed[_owner][_spender];
233   }
234   /**
235    * approve should be called when allowed[_spender] == 0. To increment
236    * allowed value is better to use this function to avoid 2 calls (and wait until
237    * the first transaction is mined)
238    * From MonolithDAO Token.sol
239    */
240   function increaseApproval (address _spender, uint256 _addedValue) public
241     returns (bool success) {
242     require(_spender != address(0), "StandardToken: spender address empty");
243     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
244     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
245     return true;
246   }
247   function decreaseApproval (address _spender, uint256 _subtractedValue) public
248     returns (bool success) {
249     require(_spender != address(0), "StandardToken: spender address empty");
250     uint256 oldValue = allowed[msg.sender][_spender];
251     if (_subtractedValue > oldValue) {
252       allowed[msg.sender][_spender] = 0;
253     } else {
254       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
255     }
256     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
257     return true;
258   }
259 }
260 
261 contract MintableToken is StandardToken, Ownable {
262   event MintFinished();
263 
264     bool public mintingFinished = false;
265 
266 
267   modifier canMint() {
268     require(!mintingFinished, "MintableToken: require minting active");
269     _;
270   }
271 
272   /**
273    * @dev Function to mint tokens
274    * @param _to The address that will recieve the minted tokens.
275    * @param _value The amount of tokens to mint.
276    * @return A boolean that indicates if the operation was successful.
277    */
278   function mint(address _to, uint256 _value) public onlyOwner canMint returns (bool) {
279     totalSupply = totalSupply.add(_value);
280     balances[_to] = balances[_to].add(_value);
281     emit Transfer(address(0), _to, _value);
282     return true;
283   }
284 
285   /**
286    * @dev Function to stop minting new tokens.
287    * @return True if the operation was successful.
288    */
289   function finishMinting() public onlyOwner returns (bool) {
290     mintingFinished = true;
291     emit MintFinished();
292     return true;
293   }
294 }
295 contract BurnableToken is StandardToken {
296 
297     /**
298      * @dev Burns a specified amount of tokens.
299      * @param _value The amount of tokens to burn. 
300      */
301     function burn(uint256 _value) public {
302         require(_value > 0, "BurnableToken: value must be greterthan 0");
303 
304         address burner = msg.sender;
305         balances[burner] = balances[burner].sub(_value);
306         totalSupply = totalSupply.sub(_value);
307         emit Transfer(msg.sender, address(0), _value);
308     }
309 }
310 
311 
312 contract PausableToken is StandardToken, Pausable {
313 
314   function transfer(address _to, uint256 _value)public whenNotPaused returns (bool) {
315     return super.transfer(_to, _value);
316   }
317 
318   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
319     return super.transferFrom(_from, _to, _value);
320   }
321   
322   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
323     return super.approve(_spender, _value);
324   }
325 
326   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
327     return super.increaseApproval(_spender, _addedValue);
328   }
329 
330   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
331     return super.decreaseApproval(_spender, _subtractedValue);
332   }
333 }
334 
335 contract WWWLToken is MintableToken, PausableToken, BurnableToken {
336     string public name = "3WL";
337     string public symbol = "WWWL";
338     uint8 public decimals = 18; 
339     uint256 public  initialSupply = 100000000 * (10 ** uint256(decimals));
340     // Constructor
341     constructor() public {
342         totalSupply = initialSupply;
343         balances[msg.sender] = initialSupply; // Send all tokens to owner
344         emit Transfer(address(0), msg.sender, initialSupply);
345     }
346 
347     // Don't accept ETH
348     function () external payable {
349     }
350       // Only owner can kill
351     function kill() public whenNotPaused onlyOwner {
352         selfdestruct(msg.sender);
353     }
354 }