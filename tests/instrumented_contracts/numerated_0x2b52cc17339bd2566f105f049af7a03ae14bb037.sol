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
127 contract ERC20Basic {
128   function totalSupply() public view returns (uint256);
129   function balanceOf(address who) public view returns (uint256);
130   function transfer(address to, uint256 value) public returns (bool);
131   event Transfer(address indexed from, address indexed to, uint256 value);
132 }
133 
134 contract ERC20 is ERC20Basic {
135   function allowance(address owner, address spender) public view returns (uint256);
136   function transferFrom(address from, address to, uint256 value) public returns (bool);
137   function approve(address spender, uint256 value) public returns (bool);
138   event Approval(address indexed owner, address indexed spender, uint256 value);
139 }
140 
141 contract HUBRISTOKEN is ERC20 {
142   string public name;
143   string public symbol;
144   uint8 public decimals;
145 
146  constructor(string _name, string _symbol, uint8 _decimals) public {
147     name = _name;
148     symbol = _symbol;
149     decimals = _decimals;
150   }
151 }
152 
153 contract BasicToken is ERC20Basic, Ownable {
154   using SafeMath for uint256;
155 
156   mapping(address => uint256) balances;
157 
158   uint256 totalSupply_;
159 
160   bool isLocked = true;
161   mapping(address => uint256) internal allowedWhenLocked;
162 
163   /**
164   * @dev total number of tokens in existence
165   */
166   function totalSupply() public view returns (uint256) {
167     return totalSupply_;
168   }
169 
170   function unlock() onlyOwner public {
171     require(isLocked == true);
172     isLocked = false;
173   }
174 
175   function allowWhenLocked(address addr) onlyOwner public {
176     require(isLocked == true);
177     allowedWhenLocked[addr] = 1;
178   }
179 
180   /**
181   * @dev transfer token for a specified address
182   * @param _to The address to transfer to.
183   * @param _value The amount to be transferred.
184   */
185   function transfer(address _to, uint256 _value) public returns (bool) {
186     require(_to != address(0));
187     require(_value <= balances[msg.sender]);
188 
189     if (isLocked) {
190         require(allowedWhenLocked[msg.sender] == 1);
191     }
192 
193     // SafeMath.sub will throw if there is not enough balance.
194     balances[msg.sender] = balances[msg.sender].sub(_value);
195     balances[_to] = balances[_to].add(_value);
196     emit Transfer(msg.sender, _to, _value);
197     return true;
198   }
199 
200   /**
201   * @dev Gets the balance of the specified address.
202   * @param _owner The address to query the the balance of.
203   * @return An uint256 representing the amount owned by the passed address.
204   */
205   function balanceOf(address _owner) public view returns (uint256 balance) {
206     return balances[_owner];
207   }
208 
209 }
210 
211 contract Standard is ERC20, BasicToken {
212 
213   mapping (address => mapping (address => uint256)) internal allowed;
214 
215 
216   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
217     require(!isLocked);
218     require(_to != address(0));
219     require(_value <= balances[_from]);
220     require(_value <= allowed[_from][msg.sender]);
221 
222     balances[_from] = balances[_from].sub(_value);
223     balances[_to] = balances[_to].add(_value);
224     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
225     emit Transfer(_from, _to, _value);
226     return true;
227   }
228 
229 
230   function approve(address _spender, uint256 _value) public returns (bool) {
231     allowed[msg.sender][_spender] = _value;
232     emit Approval(msg.sender, _spender, _value);
233     return true;
234   }
235 
236 
237   function allowance(address _owner, address _spender) public view returns (uint256) {
238     return allowed[_owner][_spender];
239   }
240 
241 
242   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
243     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
244     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
245     return true;
246   }
247 
248 
249   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
250     uint oldValue = allowed[msg.sender][_spender];
251     if (_subtractedValue > oldValue) {
252       allowed[msg.sender][_spender] = 0;
253     } else {
254       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
255     }
256     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
257     return true;
258   }
259 
260 }
261 
262 contract BurnableToken is BasicToken {
263 
264   event Burn(address indexed burner, uint256 value);
265 
266   /**
267    * @dev Burns a specific amount of tokens.
268    * @param _value The amount of token to be burned.
269    */
270   function burn(uint256 _value) public {
271     _burn(msg.sender, _value);
272   }
273 
274   function _burn(address _who, uint256 _value) internal {
275     require(_value <= balances[_who]);
276     // no need to require value <= totalSupply, since that would imply the
277     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
278 
279     balances[_who] = balances[_who].sub(_value);
280     totalSupply_ = totalSupply_.sub(_value);
281     emit Burn(_who, _value);
282     emit Transfer(_who, address(0), _value);
283   }
284 }
285 
286 /**
287  * HB1 Token
288  */
289 
290 contract HB1 is Ownable, Pausable, Standard, BurnableToken, HUBRISTOKEN {
291     using SafeMath for uint256;
292 
293     string name = "HubrisOne";
294     string symbol = "HB1";
295     uint8 decimals = 18;
296 
297     address INITIAL_TOKEN_HOLDER = 0xD466980226E440C7Da442D3fF1b6F6397229c11F;
298     
299     bool tokensAllocated = false;
300     
301     constructor() HUBRISTOKEN(name, symbol, decimals) public {
302         totalSupply_ = 89000000E18;
303         balances[this] = totalSupply_;
304         allowedWhenLocked[this] = 1;
305     }
306 
307     function envokeTokenAllocation() public onlyOwner {
308         require(!tokensAllocated);
309         tokensAllocated = true;
310         allowedWhenLocked[INITIAL_TOKEN_HOLDER] = 1;
311         this.transfer(INITIAL_TOKEN_HOLDER, totalSupply_);
312     }
313 
314 }