1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a / b;
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 /**
32  * @title Ownable
33  * The Ownable contract has an owner address, and provides basic authorization control
34  */
35 contract Ownable {
36   address public owner;
37 
38 
39   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41 
42   /**
43    * The Ownable constructor sets the original `owner` of the contract to the sender
44    * account.
45    */
46   function Ownable() {
47     owner = msg.sender;
48   }
49 
50   /**
51    * Throws if called by any account other than the owner.
52    */
53   modifier onlyOwner() {
54     require(msg.sender == owner);
55     _;
56   }
57 
58 
59   /**
60    * Allows the current owner to transfer control of the contract to a newOwner.
61    */
62   function transferOwnership(address newOwner) onlyOwner {
63     require(newOwner != address(0));      
64     OwnershipTransferred(owner, newOwner);
65     owner = newOwner;
66   }
67 
68 }
69 
70 /**
71  * @title Pausable
72  * Base contract which allows children to implement an emergency stop mechanism.
73  */
74 contract Pausable is Ownable {
75   event Pause();
76   event Unpause();
77 
78   bool public paused = false;
79 
80 
81   /**
82    * Modifier to make a function callable only when the contract is not paused.
83    */
84   modifier whenNotPaused() {
85     require(!paused);
86     _;
87   }
88 
89   /**
90    * Modifier to make a function callable only when the contract is paused.
91    */
92   modifier whenPaused() {
93     require(paused);
94     _;
95   }
96 
97   /**
98    * called by the owner to pause, triggers stopped state
99    */
100   function pause() onlyOwner whenNotPaused {
101     paused = true;
102     Pause();
103   }
104 
105   /**
106    * called by the owner to unpause, returns to normal state
107    */
108   function unpause() onlyOwner whenPaused {
109     paused = false;
110     Unpause();
111   }
112 }
113 
114  
115 /**
116  * @title ERC20 interface
117  */
118 contract ERC20 is Ownable {
119   uint256 public totalSupply;
120   function balanceOf(address who) public view returns (uint256);
121   function transfer(address to, uint256 value) public returns (bool);
122   function allowance(address owner, address spender) public view returns (uint256);
123   function transferFrom(address from, address to, uint256 value) public returns (bool);
124   function approve(address spender, uint256 value) public returns (bool);
125   event Transfer(address indexed from, address indexed to, uint256 value);
126   event Approval(address indexed owner, address indexed spender, uint256 value);
127 }
128 
129 /**
130  * @title Standard ERC20 token
131  *
132  * @dev Implementation of the basic standard token.
133  * @dev https://github.com/ethereum/EIPs/issues/20
134  */
135 contract StandardToken is ERC20, Pausable {
136   using SafeMath for uint256;
137 
138   mapping(address => uint256) balances;
139   mapping (address => mapping (address => uint256)) allowed;
140 
141  mapping(address => bool) frozen;
142 
143   /**
144    * check if given address is frozen. Freeze works only if moderator role is active
145    */
146   function isFrozen(address _addr) constant returns (bool){
147       return frozen[_addr];
148   }
149 
150   /**
151    * Freezes address (no transfer can be made from or to this address).
152    */
153   function freeze(address _addr) onlyOwner {
154       frozen[_addr] = true;
155   }
156 
157   /**
158    * Unfreezes frozen address.
159    */
160   function unfreeze(address _addr) onlyOwner {
161       frozen[_addr] = false;
162   }
163 
164   /**
165    * @dev Gets the balance of the specified address.
166    * @param _owner The address to query the the balance of.
167    * @return An uint256 representing the amount owned by the passed address.
168    */
169   function balanceOf(address _owner) public view returns (uint256 balance) {
170     return balances[_owner];
171   }
172 
173   /**
174    * @dev transfer token for a specified address
175    * @param _to The address to transfer to.
176    * @param _value The amount to be transferred.
177    */
178   function transfer(address _to, uint256 _value) public returns (bool) {
179     require(_to != address(0));
180 
181     // SafeMath.sub will throw if there is not enough balance.
182     balances[msg.sender] = balances[msg.sender].sub(_value);
183     balances[_to] = balances[_to].add(_value);
184     Transfer(msg.sender, _to, _value);
185     return true;
186   }
187 
188   /**
189    * @dev Transfer tokens from one address to another
190    * @param _from address The address which you want to send tokens from
191    * @param _to address The address which you want to transfer to
192    * @param _value uint256 the amount of tokens to be transferred
193    */
194   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
195     var _allowance = allowed[_from][msg.sender];
196     require(_to != address(0));
197     require (_value <= _allowance);
198     balances[_from] = balances[_from].sub(_value);
199     balances[_to] = balances[_to].add(_value);
200     allowed[_from][msg.sender] = _allowance.sub(_value);
201     Transfer(_from, _to, _value);
202     return true;
203   }
204 
205   /**
206    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
207    * @param _spender The address which will spend the funds.
208    * @param _value The amount of tokens to be spent.
209    */
210   function approve(address _spender, uint256 _value) public returns (bool) {
211     // To change the approve amount you first have to reduce the addresses`
212     //  allowance to zero by calling `approve(_spender, 0)` if it is not
213     //  already 0 to mitigate the race condition described here:
214     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
215     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
216     allowed[msg.sender][_spender] = _value;
217     Approval(msg.sender, _spender, _value);
218     return true;
219   }
220 
221   /**
222    * @dev Function to check the amount of tokens that an owner allowed to a spender.
223    * @param _owner address The address which owns the funds.
224    * @param _spender address The address which will spend the funds.
225    * @return A uint256 specifying the amount of tokens still available for the spender.
226    */
227   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
228     return allowed[_owner][_spender];
229   }
230 }
231 
232 /**
233  * Pausable token with moderator role and freeze address implementation
234  **/
235 contract ModToken is StandardToken {
236 
237   mapping(address => bool) frozen;
238 
239   /**
240    * check if given address is frozen. Freeze works only if moderator role is active
241    */
242   function isFrozen(address _addr) constant returns (bool){
243       return frozen[_addr];
244   }
245 
246   /**
247    * Freezes address (no transfer can be made from or to this address).
248    */
249   function freeze(address _addr) onlyOwner {
250       frozen[_addr] = true;
251   }
252 
253   /**
254    * Unfreezes frozen address.
255    */
256   function unfreeze(address _addr) onlyOwner {
257       frozen[_addr] = false;
258   }
259 
260   /**
261    * Declines transfers from/to frozen addresses.
262    */
263   function transfer(address _to, uint256 _value) whenNotPaused returns (bool) {
264     require(!isFrozen(msg.sender));
265     require(!isFrozen(_to));
266     return super.transfer(_to, _value);
267   }
268 
269   /**
270    * Declines transfers from/to/by frozen addresses.
271    */
272   function transferFrom(address _from, address _to, uint256 _value) whenNotPaused returns (bool) {
273     require(!isFrozen(msg.sender));
274     require(!isFrozen(_from));
275     require(!isFrozen(_to));
276     return super.transferFrom(_from, _to, _value);
277   }
278 }
279 
280 
281 contract SIEChain is ModToken {
282    uint256 _initialAmount = 1000000000;
283     uint8 constant public decimals = 8;
284     uint public totalSupply = _initialAmount * 10 ** uint256(decimals);
285     string constant public name = "SIE Chain";
286     string constant public symbol = "SIE";
287     
288   function SIEChain() public {
289         balances[msg.sender] = totalSupply;
290         Transfer(address(0), msg.sender, totalSupply);
291   }
292 }