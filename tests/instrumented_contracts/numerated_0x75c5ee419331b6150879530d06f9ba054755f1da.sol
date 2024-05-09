1 pragma solidity ^0.4.18;
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
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   function Ownable() public {
19     owner = msg.sender;
20   }
21 
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 /**
45  * @title SafeMath
46  * @dev Math operations with safety checks that throw on error
47  */
48 library SafeMath {
49   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a * b;
51     assert(a == 0 || c / a == b);
52     return c;
53   }
54 
55   function div(uint256 a, uint256 b) internal pure returns (uint256) {
56     assert(b > 0); // Solidity automatically throws when dividing by 0
57     uint256 c = a / b;
58     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59     return c;
60   }
61 
62   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63     assert(b <= a);
64     return a - b;
65   }
66 
67   function add(uint256 a, uint256 b) internal pure returns (uint256) {
68     uint256 c = a + b;
69     assert(c >= a);
70     return c;
71   }
72 }
73 
74 /**
75  * @title Pausable
76  * @dev Base contract which allows children to implement an emergency stop mechanism.
77  */
78 contract Pausable is Ownable {
79   event Pause();
80   event Unpause();
81 
82   bool public paused = false;
83 
84 
85   /**
86    * @dev Modifier to make a function callable only when the contract is not paused.
87    */
88   modifier whenNotPaused() {
89     require(!paused);
90     _;
91   }
92 
93   /**
94    * @dev Modifier to make a function callable only when the contract is paused.
95    */
96   modifier whenPaused() {
97     require(paused);
98     _;
99   }
100 
101   /**
102    * @dev called by the owner to pause, triggers stopped state
103    */
104   function pause() onlyOwner whenNotPaused public {
105     paused = true;
106     Pause();
107   }
108 
109   /**
110    * @dev called by the owner to unpause, returns to normal state
111    */
112   function unpause() onlyOwner whenPaused public {
113     paused = false;
114     Unpause();
115   }
116 }
117 /**
118  * @title Destructible
119  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
120  */
121 contract Destructible is Ownable {
122 
123   function Destructible() public payable { }
124 
125   /**
126    * @dev Transfers the current balance to the owner and terminates the contract.
127    */
128   function destroy() onlyOwner public {
129     selfdestruct(owner);
130   }
131 
132   function destroyAndSend(address _recipient) onlyOwner public {
133     selfdestruct(_recipient);
134   }
135 }
136 
137 contract UserTokensControl is Ownable{
138     address companyReserve;
139     uint256 isUserAbleToTransferTime = 1546284400000;//control for transfer Thu Jan 1 2019 
140     modifier isUserAbleToTransferCheck() {
141       if(msg.sender == companyReserve){
142          if(now<isUserAbleToTransferTime){
143              revert();
144          }
145          _;
146       }else {
147           _;
148       }
149     }
150    
151 }
152 
153 
154 /**
155  * @title ERC20Basic
156  * @dev Simpler version of ERC20 interface
157  */
158 contract ERC20Basic {
159   uint256 public totalSupply;
160   function balanceOf(address who) public view returns (uint256);
161   function transfer(address to, uint256 value) public returns (bool);
162   event Transfer(address indexed from, address indexed to, uint256 value);
163   event TransferSalPay(address indexed from, address indexed to, uint256 value);
164 }
165 /**
166  * @title Basic token
167  * @dev Basic version of StandardToken, with no allowances.
168  */
169 contract BasicToken is ERC20Basic, Pausable , UserTokensControl{
170   using SafeMath for uint256;
171  
172   mapping(address => uint256) balances;
173 
174   /**
175   * @dev transfer token for a specified address
176   * @param _to The address to transfer to.
177   * @param _value The amount to be transferred.
178   */
179   function transfer(address _to, uint256 _value) public isUserAbleToTransferCheck whenNotPaused returns (bool) {
180     require(_to != address(0));
181     require(_value <= balances[msg.sender]);
182 
183     // SafeMath.sub will throw if there is not enough balance.
184     balances[msg.sender] = balances[msg.sender].sub(_value);
185     balances[_to] = balances[_to].add(_value);
186     Transfer(msg.sender, _to, _value);
187     TransferSalPay(msg.sender, _to, _value);
188     return true;
189   }
190 
191   
192 
193   /**
194   * @dev Gets the balance of the specified address.
195   * @param _owner The address to query the the balance of.
196   * @return An uint256 representing the amount owned by the passed address.
197   */
198   function balanceOf(address _owner) public constant returns (uint256 balance) {
199     return balances[_owner];
200   }
201 
202 }
203 /**
204  * @title ERC20 interface
205  * @dev see https://github.com/ethereum/EIPs/issues/20
206  */
207 contract ERC20 is ERC20Basic {
208   function allowance(address owner, address spender) public view returns (uint256);
209   function transferFrom(address from, address to, uint256 value) public returns (bool);
210   function approve(address spender, uint256 value) public returns (bool);
211   event Approval(address indexed owner, address indexed spender, uint256 value);
212 }
213 
214 contract StandardToken is ERC20, BasicToken {
215 
216   mapping (address => mapping (address => uint256)) internal allowed;
217 
218   
219   /**
220    * @dev Transfer tokens from one address to another
221    * @param _from address The address which you want to send tokens from
222    * @param _to address The address which you want to transfer to
223    * @param _value uint256 the amount of tokens to be transferred
224    */
225   function transferFrom(address _from, address _to, uint256 _value) public isUserAbleToTransferCheck whenNotPaused returns (bool) {
226     require(_to != address(0));
227     require(_value <= balances[_from]);
228     require(_value <= allowed[_from][msg.sender]);
229 
230     balances[_from] = balances[_from].sub(_value);
231     balances[_to] = balances[_to].add(_value);
232     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
233     Transfer(_from, _to, _value);
234     TransferSalPay(msg.sender, _to, _value);
235     return true;
236   }
237 
238   /**
239    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
240    *
241    * Beware that changing an allowance with this method brings the risk that someone may use both the old
242    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
243    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
244    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
245    * @param _spender The address which will spend the funds.
246    * @param _value The amount of tokens to be spent.
247    */
248   function approve(address _spender, uint256 _value) public returns (bool) {
249     allowed[msg.sender][_spender] = _value;
250     Approval(msg.sender, _spender, _value);
251     return true;
252   }
253 
254   /**
255    * @dev Function to check the amount of tokens that an owner allowed to a spender.
256    * @param _owner address The address which owns the funds.
257    * @param _spender address The address which will spend the funds.
258    * @return A uint256 specifying the amount of tokens still available for the spender.
259    */
260   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
261     return allowed[_owner][_spender];
262   }
263 
264   /**
265    * approve should be called when allowed[_spender] == 0. To increment
266    * allowed value is better to use this function to avoid 2 calls (and wait until
267    * the first transaction is mined)
268    * From MonolithDAO Token.sol
269    */
270   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
271     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
272     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
273     return true;
274   }
275 
276   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
277     uint oldValue = allowed[msg.sender][_spender];
278     if (_subtractedValue > oldValue) {
279       allowed[msg.sender][_spender] = 0;
280     } else {
281       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
282     }
283     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
284     return true;
285   }
286 
287 }
288 
289 
290 contract SalPay is StandardToken, Destructible {
291     string public constant name = "SalPay";
292     uint public constant decimals = 18;
293     string public constant symbol = "SAL";
294     
295     function SalPay()  public {
296        totalSupply=100000000 *(10**decimals);  // 
297        owner = msg.sender;
298        companyReserve = 0x41486C3dF736A67c038F3cD01Bb7610a6d944044;
299        balances[msg.sender] = 80000000 * (10**decimals);
300        balances[companyReserve] = 20000000 * (10**decimals); //given by 
301     }
302 
303     function()  public {
304       revert();
305     }
306 
307 
308 
309 }