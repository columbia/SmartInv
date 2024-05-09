1 pragma solidity 0.4.18;
2 
3 contract Ownable {
4   address public owner;
5   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6 
7   /**
8    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
9    * account.
10    */
11   function Ownable() public {
12     owner = msg.sender;
13   }
14 
15   /**
16    * @dev Throws if called by any account other than the owner.
17    */
18   modifier onlyOwner() {
19     require(msg.sender == owner);
20     _;
21   }
22 
23   /**
24    * @dev Allows the current owner to transfer control of the contract to a newOwner.
25    * @param newOwner The address to transfer ownership to.
26    */
27   function transferOwnership(address newOwner) public onlyOwner {
28     require(newOwner != address(0) && newOwner != owner);
29     OwnershipTransferred(owner, newOwner);
30     owner = newOwner;
31   }
32 }
33 
34 /**
35  * @title SafeMath
36  * @dev Math operations with safety checks that throw on error
37  */
38 library SafeMath {
39   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a * b;
41     assert(a == 0 || c / a == b);
42     return c;
43   }
44 
45   function div(uint256 a, uint256 b) internal pure returns (uint256) {
46     assert(b > 0); // Solidity automatically throws when dividing by 0
47     uint256 c = a / b;
48     return c;
49   }
50 
51   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52     assert(b <= a);
53     return a - b;
54   }
55 
56   function add(uint256 a, uint256 b) internal pure returns (uint256) {
57     uint256 c = a + b;
58     assert(c >= a);
59     return c;
60   }
61 }
62 
63 contract Pausable is Ownable {
64   event Pause();
65   event Unpause();
66 
67   bool public paused = false;
68 
69   /**
70    *  modifier to allow actions only when the contract IS paused
71    */
72   modifier whenNotPaused() {
73     require(!paused);
74     _;
75   }
76 
77   /**
78    *  modifier to allow actions only when the contract IS NOT paused
79    */
80   modifier whenPaused() {
81     require(paused);
82     _;
83   }
84 
85   /**
86    *  called by the owner to pause, triggers stopped state
87    */
88   function pause() public onlyOwner whenNotPaused {
89     paused = true;
90     Pause();
91   }
92 
93   /**
94    *  called by the owner to unpause, returns to normal state
95    */
96   function unpause() public onlyOwner whenPaused {
97     paused = false;
98     Unpause();
99   }
100 }
101 
102 /**
103  * @title Destructible
104  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
105  */
106 contract Destructible is Ownable {
107 
108   function Destructible() public payable { }
109 
110   /**
111    * @dev Transfers the current balance to the owner and terminates the contract.
112    */
113   function destroy() onlyOwner public {
114     selfdestruct(owner);
115   }
116 
117   function destroyAndSend(address _recipient) onlyOwner public {
118     selfdestruct(_recipient);
119   }
120 }
121 
122 contract UserTokensControl is Ownable, Pausable{
123   address companyReserve;
124   address founderReserve;
125   address deedSaftReserve;
126   bool public isSwapDone = false;
127 
128   modifier isUserAbleToTransferCheck() {
129     if(msg.sender == owner){
130       _;
131     }else{
132       if(msg.sender == deedSaftReserve){
133         isSwapDone = true;
134       }
135 
136       if(isSwapDone){
137         _;
138       }else{
139         if(paused){    // else{ revert(); } } } <--- THIS USED TO BE ALIS CODE
140           revert();
141         }else{
142           _;
143         }
144       }
145     }
146   }
147 }
148 
149 /**
150  * @title ERC20Basic
151  * @dev Simpler version of ERC20 interface
152  */
153 contract ERC20Basic {
154   uint256 public totalSupply;
155   function balanceOf(address who) public constant returns (uint256);
156   function transfer(address to, uint256 value) public returns (bool);
157   event Transfer(address indexed from, address indexed to, uint256 value);
158 }
159 
160 /**
161  * @title Basic token
162  * @dev Basic version of StandardToken, with no allowances.
163  */
164 contract BasicToken is ERC20Basic, UserTokensControl {
165   using SafeMath for uint256;
166   bool isDistributeToFounders=false;
167 
168   mapping(address => uint256) balances;
169 
170   /**
171   * @dev transfer token for a specified address
172   * @param _to The address to transfer to.
173   * @param _value The amount to be transferred.
174   */
175   function transfer(address _to, uint256 _value) public isUserAbleToTransferCheck whenNotPaused returns (bool) {
176     require(_to != address(0));
177     require(_value <= balances[msg.sender]);
178     require(_value >= 0);
179 
180     // SafeMath.sub will throw if there is not enough balance.
181     balances[msg.sender] = balances[msg.sender].sub(_value);
182     balances[_to] = balances[_to].add(_value);
183     Transfer(msg.sender, _to, _value);
184     return true;
185   }
186 
187   //Only owner will initiate transfer during sale
188   function transferByOwnerContract(address _to, uint256 _value) public onlyOwner returns (bool) {
189     require(_to != address(0));
190     require(_value <= balances[msg.sender]);
191     require(_value >= 0);
192 
193     // SafeMath.sub will throw if there is not enough balance.
194     balances[msg.sender] = balances[msg.sender].sub(_value);
195     balances[_to] = balances[_to].add(_value);
196     Transfer(msg.sender, _to, _value);
197     return true;
198   }
199 
200   /**
201   * @dev Gets the balance of the specified address.
202   * @param _owner The address to query the the balance of.
203   * @return An uint256 representing the amount owned by the passed address.
204   */
205   function balanceOf(address _owner) public constant returns (uint256 balance) {
206     return balances[_owner];
207   }
208 }
209 
210 /**
211  * @title ERC20 interface
212  * @dev see https://github.com/ethereum/EIPs/issues/20
213  */
214 contract ERC20 is ERC20Basic {
215   function allowance(address owner, address spender) public constant returns (uint256);
216   function transferFrom(address from, address to, uint256 value) public returns (bool);
217   function approve(address spender, uint256 value) public returns (bool);
218   event Approval(address indexed owner, address indexed spender, uint256 value);
219 }
220 
221 contract StandardToken is ERC20, BasicToken {
222 
223   mapping (address => mapping (address => uint256)) internal allowed;
224 
225   /**
226    * @dev Transfer tokens from one address to another
227    * @param _from address The address which you want to send tokens from
228    * @param _to address The address which you want to transfer to
229    * @param _value uint256 the amount of tokens to be transferred
230    */
231   function transferFrom(address _from, address _to, uint256 _value) public isUserAbleToTransferCheck whenNotPaused returns (bool) {
232     require(_to != address(0));
233     require(_value <= balances[_from]);
234     require(_value >= 0);
235     require(_value <= allowed[_from][msg.sender]);
236 
237     balances[_from] = balances[_from].sub(_value);
238     balances[_to] = balances[_to].add(_value);
239     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
240     Transfer(_from, _to, _value);
241     return true;
242   }
243 
244   /**
245    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
246    *
247    * Beware that changing an allowance with this method brings the risk that someone may use both the old
248    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
249    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
250    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
251    * @param _spender The address which will spend the funds.
252    * @param _value The amount of tokens to be spent.
253    */
254   function approve(address _spender, uint256 _value) public returns (bool) {
255     require(_spender != address(0));
256     allowed[msg.sender][_spender] = _value;
257     Approval(msg.sender, _spender, _value);
258     return true;
259   }
260 
261   /**
262    * @dev Function to check the amount of tokens that an owner allowed to a spender.
263    * @param _owner address The address which owns the funds.
264    * @param _spender address The address which will spend the funds.
265    * @return A uint256 specifying the amount of tokens still available for the spender.
266    */
267   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
268     require(_owner != address(0));
269     require(_spender != address(0));
270     return allowed[_owner][_spender];
271   }
272 
273   /**
274    * approve should be called when allowed[_spender] == 0. To increment
275    * allowed value is better to use this function to avoid 2 calls (and wait until
276    * the first transaction is mined)
277    * From MonolithDAO Token.sol
278    */
279   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
280     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
281     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
282     return true;
283   }
284 
285   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
286     uint oldValue = allowed[msg.sender][_spender];
287     if (_subtractedValue > oldValue) {
288       allowed[msg.sender][_spender] = 0;
289     } else {
290       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
291     }
292     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
293     return true;
294   }
295 }
296 
297 contract DeedCoin is StandardToken,Destructible {
298   string public constant name = "Deedcoin";
299   uint public constant decimals = 18;
300   string public constant symbol = "DEED";
301 
302   function DeedCoin()  public {
303     totalSupply=132857135 *(10**decimals);  // 
304     owner = msg.sender;
305     companyReserve = 0xbBE0805F7660aE0C4C7484dBee097398329eD5f2;
306     founderReserve = 0x63547A5423652ABaF323c5B4fae848C7686B28Bf; 
307     deedSaftReserve = 0x3EA6F9f6D21CEEf6ce84dA606754887b3e6AAFf6; 
308     balances[msg.sender] = 36999996 * (10**decimals);
309     balances[companyReserve] = 19928570 * (10**decimals); 
310     balances[founderReserve] = 19928570 * (10**decimals);
311     balances[deedSaftReserve] = 55999999 * (10 ** decimals);
312   }
313 
314   function() public {
315      revert();
316   }
317 }