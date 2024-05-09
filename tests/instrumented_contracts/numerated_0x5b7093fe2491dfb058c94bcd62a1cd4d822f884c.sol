1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
11   
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() public {
17     owner = msg.sender;
18   }
19 
20   /**
21    * @dev Throws if called by any account other than the owner.
22    */
23   modifier onlyOwner() {
24     require(msg.sender == owner);
25     _;
26   }
27 
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
42  * @title SafeMath
43  * @dev Math operations with safety checks that throw on error
44  */
45 library SafeMath {
46   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47     uint256 c = a * b;
48     assert(a == 0 || c / a == b);
49     return c;
50   }
51 
52   function div(uint256 a, uint256 b) internal pure returns (uint256) {
53     assert(b > 0); // Solidity automatically throws when dividing by 0
54     uint256 c = a / b;
55     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
56     return c;
57   }
58 
59   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60     assert(b <= a);
61     return a - b;
62   }
63 
64   function add(uint256 a, uint256 b) internal pure returns (uint256) {
65     uint256 c = a + b;
66     assert(c >= a);
67     return c;
68   }
69 }
70 
71 /**
72  * @title Pausable
73  * @dev Base contract which allows children to implement an emergency stop mechanism.
74  */
75 contract Pausable is Ownable {
76   event Pause();
77   event Unpause();
78 
79   bool public paused = false;
80 
81 
82   /**
83    * @dev Modifier to make a function callable only when the contract is not paused.
84    */
85   modifier whenNotPaused() {
86     require(!paused);
87     _;
88   }
89 
90   /**
91    * @dev Modifier to make a function callable only when the contract is paused.
92    */
93   modifier whenPaused() {
94     require(paused);
95     _;
96   }
97 
98   /**
99    * @dev called by the owner to pause, triggers stopped state
100    */
101   function pause() onlyOwner whenNotPaused public {
102     paused = true;
103     Pause();
104   }
105 
106   /**
107    * @dev called by the owner to unpause, returns to normal state
108    */
109   function unpause() onlyOwner whenPaused public {
110     paused = false;
111     Unpause();
112   }
113 }
114 /**
115  * @title Destructible
116  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
117  */
118 contract Destructible is Ownable {
119 
120   function Destructible() public payable { }
121 
122   /**
123    * @dev Transfers the current balance to the owner and terminates the contract.
124    */
125   function destroy() onlyOwner public {
126     selfdestruct(owner);
127   }
128 
129   function destroyAndSend(address _recipient) onlyOwner public {
130     selfdestruct(_recipient);
131   }
132 }
133 
134 /**
135  * @title ERC20Basic
136  * @dev Simpler version of ERC20 interface
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
148 contract BasicToken is ERC20Basic, Pausable {
149   using SafeMath for uint256;
150  
151   mapping(address => uint256) balances;
152   address[] allParticipants;
153   mapping (address => bool) isParticipated;
154   /**
155   * @dev transfer token for a specified address
156   * @param _to The address to transfer to.
157   * @param _value The amount to be transferred.
158   */
159   function transfer(address _to, uint256 _value) public   returns (bool) {
160     require(_to != address(0));
161     require(_value <= balances[msg.sender]);
162 
163     // SafeMath.sub will throw if there is not enough balance.
164     balances[msg.sender] = balances[msg.sender].sub(_value);
165     balances[_to] = balances[_to].add(_value);
166     if(!isParticipated[_to]){
167         allParticipants.push(_to);
168         isParticipated[_to] = true;
169     }
170     Transfer(msg.sender, _to, _value);
171     return true;
172   }
173 
174      /**
175      * to get total particpants count
176      */
177     function getCountPartipants() public constant returns (uint count){
178        return allParticipants.length;
179     }
180     function getParticipantIndexAddress(uint index)public constant returns (address){
181         return allParticipants[index];
182     }
183 
184   /**
185   * @dev Gets the balance of the specified address.
186   * @param _owner The address to query the the balance of.
187   * @return An uint256 representing the amount owned by the passed address.
188   */
189   function balanceOf(address _owner) public constant returns (uint256 balance) {
190     return balances[_owner];
191   }
192 
193 }
194 /**
195  * @title ERC20 interface
196  * @dev see https://github.com/ethereum/EIPs/issues/20
197  */
198 contract ERC20 is ERC20Basic {
199   function allowance(address owner, address spender) public view returns (uint256);
200   function transferFrom(address from, address to, uint256 value) public returns (bool);
201   function approve(address spender, uint256 value) public returns (bool);
202   event Approval(address indexed owner, address indexed spender, uint256 value);
203 }
204 
205 contract StandardToken is ERC20, BasicToken {
206 
207   mapping (address => mapping (address => uint256)) internal allowed;
208 
209   
210   /**
211    * @dev Transfer tokens from one address to another
212    * @param _from address The address which you want to send tokens from
213    * @param _to address The address which you want to transfer to
214    * @param _value uint256 the amount of tokens to be transferred
215    */
216   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
217     require(_to != address(0));
218     require(_value <= balances[_from]);
219     require(_value <= allowed[_from][msg.sender]);
220 
221     balances[_from] = balances[_from].sub(_value);
222     balances[_to] = balances[_to].add(_value);
223     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
224     if(!isParticipated[_to]){
225         allParticipants.push(_to);
226         isParticipated[_to] = true;
227     }
228     Transfer(_from, _to, _value);
229     return true;
230   }
231 
232   /**
233    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
234    *
235    * Beware that changing an allowance with this method brings the risk that someone may use both the old
236    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
237    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
238    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
239    * @param _spender The address which will spend the funds.
240    * @param _value The amount of tokens to be spent.
241    */
242   function approve(address _spender, uint256 _value) public returns (bool) {
243     allowed[msg.sender][_spender] = _value;
244     Approval(msg.sender, _spender, _value);
245     return true;
246   }
247 
248   /**
249    * @dev Function to check the amount of tokens that an owner allowed to a spender.
250    * @param _owner address The address which owns the funds.
251    * @param _spender address The address which will spend the funds.
252    * @return A uint256 specifying the amount of tokens still available for the spender.
253    */
254   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
255     return allowed[_owner][_spender];
256   }
257 
258   /**
259    * approve should be called when allowed[_spender] == 0. To increment
260    * allowed value is better to use this function to avoid 2 calls (and wait until
261    * the first transaction is mined)
262    * From MonolithDAO Token.sol
263    */
264   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
265     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
266     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
267     return true;
268   }
269 
270   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
271     uint oldValue = allowed[msg.sender][_spender];
272     if (_subtractedValue > oldValue) {
273       allowed[msg.sender][_spender] = 0;
274     } else {
275       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
276     }
277     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
278     return true;
279   }
280 
281 }
282 
283 
284 contract Authoreon is StandardToken, Destructible {
285     string public constant name = "Authoreon";
286     uint public constant decimals = 18;
287     string public constant symbol = "AUN";
288     function Authoreon()  public {
289        totalSupply = 90000000 * (10**decimals);  // 90 million
290        owner = msg.sender;
291        balances[msg.sender] = totalSupply;
292        Transfer(msg.sender, msg.sender, totalSupply);
293     }
294 
295     function()  public {
296      revert();
297     }
298    
299   
300 }