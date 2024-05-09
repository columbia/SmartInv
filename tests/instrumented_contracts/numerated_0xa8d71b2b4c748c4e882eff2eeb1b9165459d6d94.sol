1 /**
2  *Submitted for verification at Etherscan.io on 2019-05-31
3 */
4 
5 /**
6  * Source Code first verified at https://etherscan.io on Thursday, June 14, 2018
7  (UTC) */
8 
9 pragma solidity ^0.4.24;
10 
11 /**
12  * @title SafeMath
13  * @dev Math operations with safety checks that throw on error
14  */
15 library SafeMath {
16   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17     uint256 c = a * b;
18     assert(a == 0 || c / a == b);
19     return c;
20   }
21 
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a / b;
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 
39 /**
40  * @title Ownable
41  * The Ownable contract has an owner address, and provides basic authorization control
42  */
43 contract Ownable {
44   address public owner;
45 
46 
47   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49 
50   /**
51    * The Ownable constructor sets the original `owner` of the contract to the sender
52    * account.
53    */
54   function Ownable() {
55     owner = msg.sender;
56   }
57 
58   /**
59    * Throws if called by any account other than the owner.
60    */
61   modifier onlyOwner() {
62     require(msg.sender == owner);
63     _;
64   }
65 
66 
67   /**
68    * Allows the current owner to transfer control of the contract to a newOwner.
69    */
70   function transferOwnership(address newOwner) onlyOwner {
71     require(newOwner != address(0));      
72     OwnershipTransferred(owner, newOwner);
73     owner = newOwner;
74   }
75 
76 }
77 
78 /**
79  * @title Pausable
80  * Base contract which allows children to implement an emergency stop mechanism.
81  */
82 contract Pausable is Ownable {
83   event Pause();
84   event Unpause();
85 
86   bool public paused = false;
87 
88 
89   /**
90    * Modifier to make a function callable only when the contract is not paused.
91    */
92   modifier whenNotPaused() {
93     require(!paused);
94     _;
95   }
96 
97   /**
98    * Modifier to make a function callable only when the contract is paused.
99    */
100   modifier whenPaused() {
101     require(paused);
102     _;
103   }
104 
105   /**
106    * called by the owner to pause, triggers stopped state
107    */
108   function pause() onlyOwner whenNotPaused {
109     paused = true;
110     Pause();
111   }
112 
113   /**
114    * called by the owner to unpause, returns to normal state
115    */
116   function unpause() onlyOwner whenPaused {
117     paused = false;
118     Unpause();
119   }
120 }
121 
122  
123 /**
124  * @title ERC20 interface
125  */
126 contract ERC20 is Ownable {
127   uint256 public totalSupply;
128   function balanceOf(address who) public view returns (uint256);
129   function transfer(address to, uint256 value) public returns (bool);
130   function allowance(address owner, address spender) public view returns (uint256);
131   function transferFrom(address from, address to, uint256 value) public returns (bool);
132   function approve(address spender, uint256 value) public returns (bool);
133   function burn(uint256 value) public returns(bool);
134   function burnFrom(address from,uint256 value)public returns(bool);
135   event Transfer(address indexed from, address indexed to, uint256 value);
136   event Approval(address indexed owner, address indexed spender, uint256 value);
137   event Burn(address target,uint amount);
138 }
139 
140 /**
141  * @title Standard ERC20 token
142  *
143  * @dev Implementation of the basic standard token.
144  * @dev https://github.com/ethereum/EIPs/issues/20
145  */
146 contract StandardToken is ERC20, Pausable {
147   using SafeMath for uint256;
148 
149   mapping(address => uint256) balances;
150   mapping (address => mapping (address => uint256)) allowed;
151 
152  mapping(address => bool) frozen;
153 
154   /**
155    * check if given address is frozen. Freeze works only if moderator role is active
156    */
157   function isFrozen(address _addr) constant returns (bool){
158       return frozen[_addr];
159   }
160 
161   /**
162    * Freezes address (no transfer can be made from or to this address).
163    */
164   function freeze(address _addr) onlyOwner {
165       frozen[_addr] = true;
166   }
167 
168   /**
169    * Unfreezes frozen address.
170    */
171   function unfreeze(address _addr) onlyOwner {
172       frozen[_addr] = false;
173   }
174 
175   /**
176    * @dev Gets the balance of the specified address.
177    * @param _owner The address to query the the balance of.
178    * @return An uint256 representing the amount owned by the passed address.
179    */
180   function balanceOf(address _owner) public view returns (uint256 balance) {
181     return balances[_owner];
182   }
183 
184   /**
185    * @dev transfer token for a specified address
186    * @param _to The address to transfer to.
187    * @param _value The amount to be transferred.
188    */
189   function transfer(address _to, uint256 _value) public returns (bool) {
190     require(_to != address(0));
191 
192     // SafeMath.sub will throw if there is not enough balance.
193     balances[msg.sender] = balances[msg.sender].sub(_value);
194     balances[_to] = balances[_to].add(_value);
195     Transfer(msg.sender, _to, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Transfer tokens from one address to another
201    * @param _from address The address which you want to send tokens from
202    * @param _to address The address which you want to transfer to
203    * @param _value uint256 the amount of tokens to be transferred
204    */
205   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
206     var _allowance = allowed[_from][msg.sender];
207     require(_to != address(0));
208     require (_value <= _allowance);
209     balances[_from] = balances[_from].sub(_value);
210     balances[_to] = balances[_to].add(_value);
211     allowed[_from][msg.sender] = _allowance.sub(_value);
212     Transfer(_from, _to, _value);
213     return true;
214   }
215 
216   /**
217    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
218    * @param _spender The address which will spend the funds.
219    * @param _value The amount of tokens to be spent.
220    */
221   function approve(address _spender, uint256 _value) public returns (bool) {
222     // To change the approve amount you first have to reduce the addresses`
223     //  allowance to zero by calling `approve(_spender, 0)` if it is not
224     //  already 0 to mitigate the race condition described here:
225     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
226     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
227     allowed[msg.sender][_spender] = _value;
228     Approval(msg.sender, _spender, _value);
229     return true;
230   }
231 
232   /**
233    * @dev Function to check the amount of tokens that an owner allowed to a spender.
234    * @param _owner address The address which owns the funds.
235    * @param _spender address The address which will spend the funds.
236    * @return A uint256 specifying the amount of tokens still available for the spender.
237    */
238   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
239     return allowed[_owner][_spender];
240   }
241   
242   function burn(uint256 _value) public returns(bool success){
243     require(balances[msg.sender]>=_value);
244     totalSupply-=_value;
245     balances[msg.sender]-=_value;
246     emit Burn(msg.sender,_value);
247     return true;
248     }
249     
250   function burnFrom(address _from,uint256 _value)public returns(bool success){
251     require(balances[_from]>=_value);
252     require(allowed[_from][msg.sender]>=_value);
253     totalSupply-=_value;
254     balances[msg.sender]-=_value;
255     allowed[_from][msg.sender]-=_value;
256     emit Burn(msg.sender,_value);
257     return true;
258     }
259 }
260 
261 /**
262  * Pausable token with moderator role and freeze address implementation
263  **/
264 contract ModToken is StandardToken {
265 
266   mapping(address => bool) frozen;
267 
268   /**
269    * check if given address is frozen. Freeze works only if moderator role is active
270    */
271   function isFrozen(address _addr) constant returns (bool){
272       return frozen[_addr];
273   }
274 
275   /**
276    * Freezes address (no transfer can be made from or to this address).
277    */
278   function freeze(address _addr) onlyOwner {
279       frozen[_addr] = true;
280   }
281 
282   /**
283    * Unfreezes frozen address.
284    */
285   function unfreeze(address _addr) onlyOwner {
286       frozen[_addr] = false;
287   }
288 
289   /**
290    * Declines transfers from/to frozen addresses.
291    */
292   function transfer(address _to, uint256 _value) whenNotPaused returns (bool) {
293     require(!isFrozen(msg.sender));
294     require(!isFrozen(_to));
295     return super.transfer(_to, _value);
296   }
297 
298   /**
299    * Declines transfers from/to/by frozen addresses.
300    */
301   function transferFrom(address _from, address _to, uint256 _value) whenNotPaused returns (bool) {
302     require(!isFrozen(msg.sender));
303     require(!isFrozen(_from));
304     require(!isFrozen(_to));
305     return super.transferFrom(_from, _to, _value);
306   }
307 }
308 
309 
310 contract Shinhwa is ModToken {
311    uint256 _initialAmount = 10000000000;
312     uint8 constant public decimals = 18;
313     uint public totalSupply = _initialAmount * 10 ** uint256(decimals);
314     string constant public name = "Shinhwa";
315     string constant public symbol = "SWT";
316     
317   function Shinhwa() public {
318         balances[msg.sender] = totalSupply;
319         Transfer(address(0), msg.sender, totalSupply);
320   }
321 }