1 pragma solidity ^0.4.18;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract BasicToken is ERC20Basic {
11   using SafeMath for uint256;
12 
13   mapping(address => uint256) balances;
14 
15   /**
16   * @dev transfer token for a specified address
17   * @param _to The address to transfer to.
18   * @param _value The amount to be transferred.
19   */
20   function transfer(address _to, uint256 _value) public returns (bool) {
21     require(_to != address(0));
22     require(_value <= balances[msg.sender]);
23 
24     // SafeMath.sub will throw if there is not enough balance.
25     balances[msg.sender] = balances[msg.sender].sub(_value);
26     balances[_to] = balances[_to].add(_value);
27     Transfer(msg.sender, _to, _value);
28     return true;
29   }
30 
31   /**
32   * @dev Gets the balance of the specified address.
33   * @param _owner The address to query the the balance of.
34   * @return An uint256 representing the amount owned by the passed address.
35   */
36   function balanceOf(address _owner) public view returns (uint256 balance) {
37     return balances[_owner];
38   }
39 
40 }
41 
42 contract Ownable {
43   address public owner;
44 
45 
46   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48 
49   /**
50    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
51    * account.
52    */
53   function Ownable() public {
54     owner = msg.sender;
55   }
56 
57 
58   /**
59    * @dev Throws if called by any account other than the owner.
60    */
61   modifier onlyOwner() {
62     require(msg.sender == owner);
63     _;
64   }
65 
66 
67   /**
68    * @dev Allows the current owner to transfer control of the contract to a newOwner.
69    * @param newOwner The address to transfer ownership to.
70    */
71   function transferOwnership(address newOwner) public onlyOwner {
72     require(newOwner != address(0));
73     OwnershipTransferred(owner, newOwner);
74     owner = newOwner;
75   }
76 
77 }
78 
79 contract Pausable is Ownable {
80   event Pause();
81   event Unpause();
82 
83   bool public paused = false;
84 
85 
86   /**
87    * @dev Modifier to make a function callable only when the contract is not paused.
88    */
89   modifier whenNotPaused() {
90     require(!paused);
91     _;
92   }
93 
94   /**
95    * @dev Modifier to make a function callable only when the contract is paused.
96    */
97   modifier whenPaused() {
98     require(paused);
99     _;
100   }
101 
102   /**
103    * @dev called by the owner to pause, triggers stopped state
104    */
105   function pause() onlyOwner whenNotPaused public {
106     paused = true;
107     Pause();
108   }
109 
110   /**
111    * @dev called by the owner to unpause, returns to normal state
112    */
113   function unpause() onlyOwner whenPaused public {
114     paused = false;
115     Unpause();
116   }
117 }
118 
119 library SafeMath {
120   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
121     if (a == 0) {
122       return 0;
123     }
124     uint256 c = a * b;
125     assert(c / a == b);
126     return c;
127   }
128 
129   function div(uint256 a, uint256 b) internal pure returns (uint256) {
130     // assert(b > 0); // Solidity automatically throws when dividing by 0
131     uint256 c = a / b;
132     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
133     return c;
134   }
135 
136   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
137     assert(b <= a);
138     return a - b;
139   }
140 
141   function add(uint256 a, uint256 b) internal pure returns (uint256) {
142     uint256 c = a + b;
143     assert(c >= a);
144     return c;
145   }
146 }
147 
148 contract ERC20 is ERC20Basic {
149   function allowance(address owner, address spender) public view returns (uint256);
150   function transferFrom(address from, address to, uint256 value) public returns (bool);
151   function approve(address spender, uint256 value) public returns (bool);
152   event Approval(address indexed owner, address indexed spender, uint256 value);
153 }
154 
155 contract StandardToken is ERC20, BasicToken {
156 
157   mapping (address => mapping (address => uint256)) internal allowed;
158 
159 
160   /**
161    * @dev Transfer tokens from one address to another
162    * @param _from address The address which you want to send tokens from
163    * @param _to address The address which you want to transfer to
164    * @param _value uint256 the amount of tokens to be transferred
165    */
166   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
167     require(_to != address(0));
168     require(_value <= balances[_from]);
169     require(_value <= allowed[_from][msg.sender]);
170 
171     balances[_from] = balances[_from].sub(_value);
172     balances[_to] = balances[_to].add(_value);
173     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
174     Transfer(_from, _to, _value);
175     return true;
176   }
177 
178   /**
179    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
180    *
181    * Beware that changing an allowance with this method brings the risk that someone may use both the old
182    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
183    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
184    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
185    * @param _spender The address which will spend the funds.
186    * @param _value The amount of tokens to be spent.
187    */
188   function approve(address _spender, uint256 _value) public returns (bool) {
189     allowed[msg.sender][_spender] = _value;
190     Approval(msg.sender, _spender, _value);
191     return true;
192   }
193 
194   /**
195    * @dev Function to check the amount of tokens that an owner allowed to a spender.
196    * @param _owner address The address which owns the funds.
197    * @param _spender address The address which will spend the funds.
198    * @return A uint256 specifying the amount of tokens still available for the spender.
199    */
200   function allowance(address _owner, address _spender) public view returns (uint256) {
201     return allowed[_owner][_spender];
202   }
203 
204   /**
205    * @dev Increase the amount of tokens that an owner allowed to a spender.
206    *
207    * approve should be called when allowed[_spender] == 0. To increment
208    * allowed value is better to use this function to avoid 2 calls (and wait until
209    * the first transaction is mined)
210    * From MonolithDAO Token.sol
211    * @param _spender The address which will spend the funds.
212    * @param _addedValue The amount of tokens to increase the allowance by.
213    */
214   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
215     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
216     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217     return true;
218   }
219 
220   /**
221    * @dev Decrease the amount of tokens that an owner allowed to a spender.
222    *
223    * approve should be called when allowed[_spender] == 0. To decrement
224    * allowed value is better to use this function to avoid 2 calls (and wait until
225    * the first transaction is mined)
226    * From MonolithDAO Token.sol
227    * @param _spender The address which will spend the funds.
228    * @param _subtractedValue The amount of tokens to decrease the allowance by.
229    */
230   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
231     uint oldValue = allowed[msg.sender][_spender];
232     if (_subtractedValue > oldValue) {
233       allowed[msg.sender][_spender] = 0;
234     } else {
235       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
236     }
237     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
238     return true;
239   }
240 
241 }
242 
243 contract MintableToken is StandardToken, Ownable {
244   event Mint(address indexed to, uint256 amount);
245   event MintFinished();
246 
247   bool public mintingFinished = false;
248 
249 
250   modifier canMint() {
251     require(!mintingFinished);
252     _;
253   }
254 
255   /**
256    * @dev Function to mint tokens
257    * @param _to The address that will receive the minted tokens.
258    * @param _amount The amount of tokens to mint.
259    * @return A boolean that indicates if the operation was successful.
260    */
261   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
262     totalSupply = totalSupply.add(_amount);
263     balances[_to] = balances[_to].add(_amount);
264     Mint(_to, _amount);
265     Transfer(address(0), _to, _amount);
266     return true;
267   }
268 
269   /**
270    * @dev Function to stop minting new tokens.
271    * @return True if the operation was successful.
272    */
273   function finishMinting() onlyOwner canMint public returns (bool) {
274     mintingFinished = true;
275     MintFinished();
276     return true;
277   }
278 }
279 
280 contract NucleusVisionToken is MintableToken {
281   string public constant name = "NucleusVision";
282   string public constant symbol = "nCash";
283   uint8 public constant decimals = 18;
284 
285   // Total supply of nCash tokens is 10 Billion
286   uint256 public constant MAX_SUPPLY = 10 * 1000 * 1000 * 1000 * (10 ** uint256(decimals));
287   // Bit that controls whether the token can be transferred / traded
288   bool public unlocked = false;
289 
290   event NucleusVisionTokenUnlocked();
291 
292   /**
293    * @dev totalSupply is set via the minting process
294    */
295   function NucleusVisionToken() public {
296   }
297 
298   function mint(address to, uint256 amount) onlyOwner public returns (bool) {
299     require(totalSupply + amount <= MAX_SUPPLY);
300     return super.mint(to, amount);
301   }
302 
303   function unlockToken() onlyOwner public {
304     require (!unlocked);
305     unlocked = true;
306     NucleusVisionTokenUnlocked();
307   }
308 
309   // Overriding basic ERC-20 specification that lets people transfer/approve tokens.
310   function transfer(address to, uint256 value) public returns (bool) {
311     require(unlocked);
312     return super.transfer(to, value);
313   }
314 
315   function transferFrom(address from, address to, uint256 value) public returns (bool) {
316     require(unlocked);
317     return super.transferFrom(from, to, value);
318   }
319 
320   function approve(address spender, uint256 value) public returns (bool) {
321     require(unlocked);
322     return super.approve(spender, value);
323   }
324 
325   // Overriding StandardToken functions that lets people transfer/approve tokens.
326   function increaseApproval(address spender, uint addedValue) public returns (bool) {
327     require(unlocked);
328     return super.increaseApproval(spender, addedValue);
329   }
330 
331   function decreaseApproval(address spender, uint subtractedValue) public returns (bool) {
332     require(unlocked);
333     return super.decreaseApproval(spender, subtractedValue);
334   }
335 
336 }