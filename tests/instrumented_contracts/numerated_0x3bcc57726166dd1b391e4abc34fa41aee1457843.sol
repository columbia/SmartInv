1 pragma solidity 0.4.18;
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
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() public {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 /**
44  * @title SafeMath
45  * @dev Math operations with safety checks that throw on error
46  */
47 library SafeMath {
48   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49     uint256 c = a * b;
50     assert(a == 0 || c / a == b);
51     return c;
52   }
53 
54   function div(uint256 a, uint256 b) internal pure returns (uint256) {
55     assert(b > 0); // Solidity automatically throws when dividing by 0
56     uint256 c = a / b;
57     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58     return c;
59   }
60 
61   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62     assert(b <= a);
63     return a - b;
64   }
65 
66   function add(uint256 a, uint256 b) internal pure returns (uint256) {
67     uint256 c = a + b;
68     assert(c >= a);
69     return c;
70   }
71 }
72 
73 /**
74  * @title Pausable
75  * @dev Base contract which allows children to implement an emergency stop mechanism.
76  */
77 contract Pausable is Ownable {
78   event Pause();
79   event Unpause();
80 
81   bool public paused = false;
82 
83 
84   /**
85    * @dev Modifier to make a function callable only when the contract is not paused.
86    */
87   modifier whenNotPaused() {
88     require(!paused);
89     _;
90   }
91 
92   /**
93    * @dev Modifier to make a function callable only when the contract is paused.
94    */
95   modifier whenPaused() {
96     require(paused);
97     _;
98   }
99 
100   /**
101    * @dev called by the owner to pause, triggers stopped state
102    */
103   function pause() onlyOwner whenNotPaused public {
104     paused = true;
105     Pause();
106   }
107 
108   /**
109    * @dev called by the owner to unpause, returns to normal state
110    */
111   function unpause() onlyOwner whenPaused public {
112     paused = false;
113     Unpause();
114   }
115 }
116 /**
117  * @title Destructible
118  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
119  */
120 contract Destructible is Ownable {
121 
122   function Destructible() public payable { }
123 
124   /**
125    * @dev Transfers the current balance to the owner and terminates the contract.
126    */
127   function destroy() onlyOwner public {
128     selfdestruct(owner);
129   }
130 
131   function destroyAndSend(address _recipient) onlyOwner public {
132     selfdestruct(_recipient);
133   }
134 }
135 
136 /**
137  * @title ERC20Basic
138  * @dev Simpler version of ERC20 interface
139  */
140 contract ERC20Basic {
141   uint256 public totalSupply;
142   function balanceOf(address who) public view returns (uint256);
143   function transfer(address to, uint256 value) public returns (bool);
144   event Transfer(address indexed from, address indexed to, uint256 value);
145 }
146 /**
147  * @title Basic token
148  * @dev Basic version of StandardToken, with no allowances.
149  */
150 contract BasicToken is ERC20Basic, Pausable {
151   using SafeMath for uint256;
152  
153   mapping(address => uint256) balances;
154     address[] allParticipants;
155     mapping (address => bool) isParticipated;
156   /**
157   * @dev transfer token for a specified address
158   * @param _to The address to transfer to.
159   * @param _value The amount to be transferred.
160   */
161   function transfer(address _to, uint256 _value) public onlyOwner  returns (bool) {
162     require(_to != address(0));
163     require(_value <= balances[msg.sender]);
164 
165     // SafeMath.sub will throw if there is not enough balance.
166     balances[msg.sender] = balances[msg.sender].sub(_value);
167     balances[_to] = balances[_to].add(_value);
168     if(!isParticipated[_to]){
169         allParticipants.push(_to);
170         isParticipated[_to] = true;
171     }
172     Transfer(msg.sender, _to, _value);
173     return true;
174   }
175 
176      /**
177      * to get total particpants count
178      */
179     function getCountPartipants() public constant returns (uint count){
180        return allParticipants.length;
181     }
182     function getParticipantIndexAddress(uint index)public constant returns (address){
183         return allParticipants[index];
184     }
185 
186   /**
187   * @dev Gets the balance of the specified address.
188   * @param _owner The address to query the the balance of.
189   * @return An uint256 representing the amount owned by the passed address.
190   */
191   function balanceOf(address _owner) public constant returns (uint256 balance) {
192     return balances[_owner];
193   }
194 
195 }
196 /**
197  * @title ERC20 interface
198  * @dev see https://github.com/ethereum/EIPs/issues/20
199  */
200 contract ERC20 is ERC20Basic {
201   function allowance(address owner, address spender) public view returns (uint256);
202   function transferFrom(address from, address to, uint256 value) public returns (bool);
203   function approve(address spender, uint256 value) public returns (bool);
204   event Approval(address indexed owner, address indexed spender, uint256 value);
205 }
206 
207 contract StandardToken is ERC20, BasicToken {
208 
209   mapping (address => mapping (address => uint256)) internal allowed;
210 
211   
212   /**
213    * @dev Transfer tokens from one address to another
214    * @param _from address The address which you want to send tokens from
215    * @param _to address The address which you want to transfer to
216    * @param _value uint256 the amount of tokens to be transferred
217    */
218   function transferFrom(address _from, address _to, uint256 _value) public onlyOwner returns (bool) {
219     require(_to != address(0));
220     require(_value <= balances[_from]);
221     require(_value <= allowed[_from][msg.sender]);
222 
223     balances[_from] = balances[_from].sub(_value);
224     balances[_to] = balances[_to].add(_value);
225     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
226     if(!isParticipated[_to]){
227         allParticipants.push(_to);
228         isParticipated[_to] = true;
229     }
230     Transfer(_from, _to, _value);
231     return true;
232   }
233 
234   /**
235    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
236    *
237    * Beware that changing an allowance with this method brings the risk that someone may use both the old
238    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
239    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
240    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
241    * @param _spender The address which will spend the funds.
242    * @param _value The amount of tokens to be spent.
243    */
244   function approve(address _spender, uint256 _value) public returns (bool) {
245     allowed[msg.sender][_spender] = _value;
246     Approval(msg.sender, _spender, _value);
247     return true;
248   }
249 
250   /**
251    * @dev Function to check the amount of tokens that an owner allowed to a spender.
252    * @param _owner address The address which owns the funds.
253    * @param _spender address The address which will spend the funds.
254    * @return A uint256 specifying the amount of tokens still available for the spender.
255    */
256   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
257     return allowed[_owner][_spender];
258   }
259 
260   /**
261    * approve should be called when allowed[_spender] == 0. To increment
262    * allowed value is better to use this function to avoid 2 calls (and wait until
263    * the first transaction is mined)
264    * From MonolithDAO Token.sol
265    */
266   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
267     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
268     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
269     return true;
270   }
271 
272   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
273     uint oldValue = allowed[msg.sender][_spender];
274     if (_subtractedValue > oldValue) {
275       allowed[msg.sender][_spender] = 0;
276     } else {
277       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
278     }
279     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
280     return true;
281   }
282 
283 }
284 
285 
286 contract DeedSaft is StandardToken, Destructible {
287     string public constant name = "DeedcoinSAFT";
288     uint public constant decimals = 18;
289     string public constant symbol = "DDS";
290     address[] allParticipants;
291     mapping (address => bool) isParticipated;
292     function DeedSaft()  public {
293        totalSupply = 55999999 * (10**decimals);  // 
294        owner = msg.sender;
295        balances[msg.sender] = totalSupply;
296     }
297 
298     function()  public {
299      revert();
300     }
301    
302   
303 }