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
151   
152   /**
153   * @dev transfer token for a specified address
154   * @param _to The address to transfer to.
155   * @param _value The amount to be transferred.
156   */
157   function transfer(address _to, uint256 _value) public returns (bool) {
158     require(_to != address(0), "BasicToken: require to address");
159     // SafeMath.sub will throw if there is not enough balance.
160     balances[msg.sender] = balances[msg.sender].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     emit Transfer(msg.sender, _to, _value);
163     return true;
164   }
165   /**
166   * @dev Gets the balance of the specified address.
167   * @param _owner The address to query the the balance of.
168   * @return An uint256 representing the amount owned by the passed address.
169   */
170   function balanceOf(address _owner) public view returns (uint256 balance) {
171     return balances[_owner];
172   }
173 }
174 /**
175  * @title ERC20 interface
176  * @dev see https://github.com/ethereum/EIPs/issues/20
177  */
178 contract ERC20 is ERC20Basic {
179   function allowance(address owner, address spender) public view returns (uint256);
180   function transferFrom(address from, address to, uint256 value) public returns (bool);
181   function approve(address spender, uint256 value) public returns (bool);
182   event Approval(address indexed owner, address indexed spender, uint256 value);
183 }
184 /**
185  * @title Standard ERC20 token
186  *
187  * @dev Implementation of the basic standard token.
188  * @dev https://github.com/ethereum/EIPs/issues/20
189  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
190  */
191 contract StandardToken is ERC20, BasicToken {
192   mapping (address => mapping (address => uint256)) allowed;
193   /**
194    * @dev Transfer tokens from one address to another
195    * @param _from address The address which you want to send tokens from
196    * @param _to address The address which you want to transfer to
197    * @param _value uint256 the amount of tokens to be transferred
198    */
199   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
200     require(_to != address(0), "StandardToken: receiver address empty");
201     uint256 _allowance = allowed[_from][msg.sender];
202     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
203     // require (_value <= _allowance);
204     balances[_from] = balances[_from].sub(_value);
205     balances[_to] = balances[_to].add(_value);
206     allowed[_from][msg.sender] = _allowance.sub(_value);
207     emit Transfer(_from, _to, _value);
208     return true;
209   }
210   /**
211    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
212    *
213    * Beware that changing an allowance with this method brings the risk that someone may use both the old
214    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
215    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
216    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
217    * @param _spender The address which will spend the funds.
218    * @param _value The amount of tokens to be spent.
219    */
220   function approve(address _spender, uint256 _value) public returns (bool) {
221     require(_spender != address(0), "StandardToken: spender address empty");
222     allowed[msg.sender][_spender] = _value;
223     emit Approval(msg.sender, _spender, _value);
224     return true;
225   }
226   /**
227    * @dev Function to check the amount of tokens that an owner allowed to a spender.
228    * @param _owner address The address which owns the funds.
229    * @param _spender address The address which will spend the funds.
230    * @return A uint256 specifying the amount of tokens still available for the spender.
231    */
232   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
233     return allowed[_owner][_spender];
234   }
235   /**
236    * approve should be called when allowed[_spender] == 0. To increment
237    * allowed value is better to use this function to avoid 2 calls (and wait until
238    * the first transaction is mined)
239    * From MonolithDAO Token.sol
240    */
241   function increaseApproval (address _spender, uint256 _addedValue) public
242     returns (bool success) {
243     require(_spender != address(0), "StandardToken: spender address empty");
244     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
245     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
246     return true;
247   }
248   function decreaseApproval (address _spender, uint256 _subtractedValue) public
249     returns (bool success) {
250     require(_spender != address(0), "StandardToken: spender address empty");
251     uint256 oldValue = allowed[msg.sender][_spender];
252     if (_subtractedValue > oldValue) {
253       allowed[msg.sender][_spender] = 0;
254     } else {
255       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
256     }
257     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258     return true;
259   }
260 }
261 
262 
263 contract BurnableToken is StandardToken {
264 
265     /**
266      * @dev Burns a specified amount of tokens.
267      * @param _value The amount of tokens to burn. 
268      */
269     function burn(uint256 _value) public {
270         require(_value > 0, "BurnableToken: value must be greterthan 0");
271 
272         address burner = msg.sender;
273         balances[burner] = balances[burner].sub(_value);
274         totalSupply = totalSupply.sub(_value);
275         emit Transfer(msg.sender, address(0), _value);
276     }
277 
278 }
279 
280 contract PausableToken is StandardToken, Pausable {
281     mapping (address => bool) frozenAccount;
282     event FrozenFunds(address target, bool frozen);
283 
284     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
285     /// @param target Address to be frozen
286     /// @param freeze either to freeze it or not
287     function freezeAccount(address target, bool freeze) onlyOwner public returns(bool){
288         frozenAccount[target] = freeze;
289         emit FrozenFunds(target, freeze);
290         return true;
291     }
292      
293   function transfer(address _to, uint256 _value)public whenNotPaused returns (bool) {
294      require(!frozenAccount[msg.sender], "Sending Tokens from frozen account restricted!");
295     return super.transfer(_to, _value);
296   }
297 
298   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
299    require(!frozenAccount[_from], "Sending Tokens from frozen account restricted!");
300     return super.transferFrom(_from, _to, _value);
301   }
302   
303   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
304     return super.approve(_spender, _value);
305   }
306 
307   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
308     return super.increaseApproval(_spender, _addedValue);
309   }
310 
311   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
312     return super.decreaseApproval(_spender, _subtractedValue);
313   }
314 }
315 
316 contract ParadiseToken is  PausableToken, BurnableToken {
317     string public name = "PARADISE TOKEN";
318     string public symbol = "PDT";
319     uint8 public decimals = 18; 
320     uint256 public  initialSupply = 10000000000 * (10 ** uint256(decimals));
321     // Constructor
322     constructor() public {
323         totalSupply = initialSupply;
324         balances[msg.sender] = initialSupply; // Send all tokens to owner
325         emit Transfer(address(0), msg.sender, initialSupply);
326     }
327     //send ethers
328     function transferEther(address payable _receiver, uint256 _value) public onlyOwner payable{
329         address(_receiver).transfer(_value);
330     }
331     
332     //Receive ether 
333     function () external payable {
334     }
335     
336 }