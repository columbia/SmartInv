1 pragma solidity ^0.4.24;
2 
3 /**
4  * Libraries
5  */
6 
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * Helper contracts
51  */
52 
53 
54 contract Ownable {
55   address public owner;
56 
57 
58   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   constructor() public {
65     owner = msg.sender;
66   }
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76   /**
77    * @dev Allows the current owner to transfer control of the contract to a newOwner.
78    * @param newOwner The address to transfer ownership to.
79    */
80   function transferOwnership(address newOwner) public onlyOwner {
81     require(newOwner != address(0));
82     emit OwnershipTransferred(owner, newOwner);
83     owner = newOwner;
84   }
85 }
86 
87 contract Pausable is Ownable {
88   event Pause();
89   event Unpause();
90 
91   bool public paused = false;
92 
93 
94   /**
95    * @dev Modifier to make a function callable only when the contract is not paused.
96    */
97   modifier whenNotPaused() {
98     require(!paused);
99     _;
100   }
101 
102   /**
103    * @dev Modifier to make a function callable only when the contract is paused.
104    */
105   modifier whenPaused() {
106     require(paused);
107     _;
108   }
109 
110   /**
111    * @dev called by the owner to pause, triggers stopped state
112    */
113   function pause() onlyOwner whenNotPaused public {
114     paused = true;
115     emit Pause();
116   }
117 
118   /**
119    * @dev called by the owner to unpause, returns to normal state
120    */
121   function unpause() onlyOwner whenPaused public {
122     paused = false;
123     emit Unpause();
124   }
125 }
126 
127 
128 contract ERC20Basic {
129   function totalSupply() public view returns (uint256);
130   function balanceOf(address who) public view returns (uint256);
131   function transfer(address to, uint256 value) public returns (bool);
132   event Transfer(address indexed from, address indexed to, uint256 value);
133 }
134 
135 contract ERC20 is ERC20Basic {
136   function allowance(address owner, address spender) public view returns (uint256);
137   function transferFrom(address from, address to, uint256 value) public returns (bool);
138   function approve(address spender, uint256 value) public returns (bool);
139   event Approval(address indexed owner, address indexed spender, uint256 value);
140 }
141 
142 contract HUBRISTOKEN is ERC20 {
143   string public name;
144   string public symbol;
145   uint8 public decimals;
146 
147  constructor(string _name, string _symbol, uint8 _decimals) public {
148     name = _name;
149     symbol = _symbol;
150     decimals = _decimals;
151   }
152 }
153 
154 contract BasicToken is ERC20Basic {
155   using SafeMath for uint256;
156 
157   mapping(address => uint256) balances;
158 
159   uint256 totalSupply_;
160 
161   /**
162   * @dev total number of tokens in existence
163   */
164   function totalSupply() public view returns (uint256) {
165     return totalSupply_;
166   }
167 
168   /**
169   * @dev transfer token for a specified address
170   * @param _to The address to transfer to.
171   * @param _value The amount to be transferred.
172   */
173   function transfer(address _to, uint256 _value) public returns (bool) {
174     require(_to != address(0));
175     require(_value <= balances[msg.sender]);
176 
177     // SafeMath.sub will throw if there is not enough balance.
178     balances[msg.sender] = balances[msg.sender].sub(_value);
179     balances[_to] = balances[_to].add(_value);
180     emit Transfer(msg.sender, _to, _value);
181     return true;
182   }
183 
184   /**
185   * @dev Gets the balance of the specified address.
186   * @param _owner The address to query the the balance of.
187   * @return An uint256 representing the amount owned by the passed address.
188   */
189   function balanceOf(address _owner) public view returns (uint256 balance) {
190     return balances[_owner];
191   }
192 
193 }
194 
195 contract Standard is ERC20, BasicToken {
196 
197   mapping (address => mapping (address => uint256)) internal allowed;
198 
199 
200   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
201     require(_to != address(0));
202     require(_value <= balances[_from]);
203     require(_value <= allowed[_from][msg.sender]);
204 
205     balances[_from] = balances[_from].sub(_value);
206     balances[_to] = balances[_to].add(_value);
207     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
208     emit Transfer(_from, _to, _value);
209     return true;
210   }
211 
212 
213   function approve(address _spender, uint256 _value) public returns (bool) {
214     allowed[msg.sender][_spender] = _value;
215     emit Approval(msg.sender, _spender, _value);
216     return true;
217   }
218 
219 
220   function allowance(address _owner, address _spender) public view returns (uint256) {
221     return allowed[_owner][_spender];
222   }
223 
224 
225   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
226     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
227     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
228     return true;
229   }
230 
231 
232   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
233     uint oldValue = allowed[msg.sender][_spender];
234     if (_subtractedValue > oldValue) {
235       allowed[msg.sender][_spender] = 0;
236     } else {
237       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
238     }
239     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
240     return true;
241   }
242 
243 }
244 
245 contract BurnableToken is BasicToken {
246 
247   event Burn(address indexed burner, uint256 value);
248 
249   /**
250    * @dev Burns a specific amount of tokens.
251    * @param _value The amount of token to be burned.
252    */
253   function burn(uint256 _value) public {
254     _burn(msg.sender, _value);
255   }
256 
257   function _burn(address _who, uint256 _value) internal {
258     require(_value <= balances[_who]);
259     // no need to require value <= totalSupply, since that would imply the
260     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
261 
262     balances[_who] = balances[_who].sub(_value);
263     totalSupply_ = totalSupply_.sub(_value);
264     emit Burn(_who, _value);
265     emit Transfer(_who, address(0), _value);
266   }
267 }
268 
269 /**
270  * HUBRIS Token
271  */
272 
273 contract HUBRIS is Ownable, Pausable, Standard, BurnableToken, HUBRISTOKEN {
274     using SafeMath for uint256;
275 
276     string name = "HUBRIS";
277     string symbol = "HBRS";
278     uint8 decimals = 18;
279 
280     //token allocation addresses
281     address TOKEN_SALE = 0xdff99ef7ed50f9EB06183d0DfeD9CD5DB051878B;
282     address EQUITY_SHARE = 0xb2aA0f5c0e2e7f94A26022C076240509C85eDab1;
283     address TEAM = 0x922E97d03bEeA115Ab95CC638765d2BebEb04f20;
284     address ADVISORS = 0x6FB54a06f94591EAF330c4BdD644c4Ab753eb105;
285     address CUSTOMERS = 0x382C33946B73A3B8B7F3E70A553b6965d6F28a48;
286     address BOUNTY = 0x1d1390c9d5e08aCEC31991EA7Be7443ad2EEA6e6;
287     address RESERVE = 0x79641ae5D204C45038a9cF07c32E39d2EeC23C5c;
288     address LEGAL = 0xe49941b4B66D61d98d4766c8EEB3004c0961075B;
289     
290     bool tokensAllocated = false;
291 
292     constructor() HUBRISTOKEN(name, symbol, decimals) public {
293         totalSupply_ = 1000000000E18;
294         balances[this] = totalSupply_;
295     }
296 
297     function envokeTokenAllocation() public onlyOwner {
298         require(!tokensAllocated);
299         tokensAllocated = true;
300         this.transfer(TOKEN_SALE, 300000000E18); //30% of totalSupply_
301         this.transfer(EQUITY_SHARE, 300000000E18); //30% of totalSupply_
302         this.transfer(TEAM, 150000000E18); //15% of totalSupply_
303         this.transfer(ADVISORS, 30000000E18); //3% of totalSupply_
304         this.transfer(CUSTOMERS, 100000000E18); //10% of totalSupply_
305         this.transfer(msg.sender, 50000000E18); //5% of totalSupply_
306         this.transfer(BOUNTY, 40000000E18); //4% of totalSupply_
307         this.transfer(RESERVE, 20000000E18); //2% of totalSupply_
308         this.transfer(LEGAL, 10000000E18); //1% of totalSupply_
309     }
310 
311 }