1 pragma solidity >=0.4.0 <0.7.0;
2 
3 
4 contract ERC20Basic {
5     uint256 public totalSupply;
6     function balanceOf(address who)  public view returns (uint256);
7     function transfer(address to, uint256 value) public returns (bool);
8     event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 
12 /**
13  * @title Ownable
14  * @dev The Ownable contract has an owner address, and provides basic authorization control
15  * functions, this simplifies the implementation of "user permissions".
16  */
17 contract Ownable {
18     address public owner;
19 
20 
21     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23 
24   /**
25    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
26    * account.
27    */
28     constructor() public {
29     owner = msg.sender;
30     }
31 
32   /**
33    * @dev Throws if called by any account other than the owner.
34    */
35   modifier onlyOwner() {
36     require(msg.sender == owner);
37     _;
38   }
39 
40   /**
41    * @dev Allows the current owner to transfer control of the contract to a newOwner.
42    * @param newOwner The address to transfer ownership to.
43    */
44   function transferOwnership(address newOwner) public onlyOwner {
45     require(newOwner != address(0));
46     emit OwnershipTransferred(owner, newOwner);
47     owner = newOwner;
48   }
49 
50 }
51 /**
52  * @title Pausable
53  * @dev Base contract which allows children to implement an emergency stop mechanism.
54  */
55 contract Pausable is Ownable {
56   event Pause();
57   event Unpause();
58 
59   bool public paused = false;
60 
61 
62   /**
63    * @dev Modifier to make a function callable only when the contract is not paused.
64    */
65   modifier whenNotPaused() {
66     require(!paused);
67     _;
68   }
69 
70   /**
71    * @dev Modifier to make a function callable only when the contract is paused.
72    */
73   modifier whenPaused() {
74     require(paused);
75     _;
76   }
77 
78   /**
79    * @dev called by the owner to pause, triggers stopped state
80    */
81   function pause() public onlyOwner whenNotPaused  {
82     paused = true;
83     emit Pause();
84   }
85 
86   /**
87    * @dev called by the owner to unpause, returns to normal state
88    */
89   function unpause() public onlyOwner whenPaused {
90     paused = false;
91     emit Unpause();
92   }
93 }
94 
95 /**
96  * @title ERC20 interface
97  * @dev see https://github.com/ethereum/EIPs/issues/20
98  */
99 contract ERC20 is ERC20Basic {
100   function allowance(address owner, address spender) public view returns (uint256);
101   function transferFrom(address from, address to, uint256 value) public returns (bool);
102   function approve(address spender, uint256 value) public returns (bool);
103   event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 library SafeMath {
107   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
108     uint256 c = a * b;
109     assert(a == 0 || c / a == b);
110     return c;
111   }
112 
113   function div(uint256 a, uint256 b) internal pure returns (uint256) {
114     // assert(b > 0); // Solidity automatically throws when dividing by 0
115     uint256 c = a / b;
116     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
117     return c;
118   }
119 
120   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121     assert(b <= a);
122     return a - b;
123   }
124 
125   function add(uint256 a, uint256 b) internal pure returns (uint256) {
126     uint256 c = a + b;
127     assert(c >= a);
128     return c;
129   }
130 }
131 
132 /**
133  * @title Basic token
134  * @dev Basic version of StandardToken, with no allowances.
135  */
136 contract BasicToken is ERC20Basic {
137   using SafeMath for uint256;
138 
139   mapping(address => uint256) balances;
140 
141   /**
142   * @dev transfer token for a specified address
143   * @param _to The address to transfer to.
144   * @param _value The amount to be transferred.
145   */
146   function transfer(address _to, uint256 _value) public returns (bool) {
147     require(_to != address(0x0));
148 
149     // SafeMath.sub will throw if there is not enough balance.
150     balances[msg.sender] = balances[msg.sender].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     emit Transfer(msg.sender, _to, _value);
153     return true;
154   }
155 
156   /**
157   * @dev Gets the balance of the specified address.
158   * @param _owner The address to query the the balance of.
159   * @return An uint256 representing the amount owned by the passed address.
160   */
161   function balanceOf(address _owner) public view returns (uint256 balance) {
162     return balances[_owner];
163   }
164 
165 }
166 
167 
168 /**
169  * @title Standard ERC20 token
170  *
171  * @dev Implementation of the basic standard token.
172  * @dev https://github.com/ethereum/EIPs/issues/20
173  */
174 contract StandardToken is ERC20, BasicToken, Pausable {
175 
176   mapping (address => mapping (address => uint256)) allowed;
177 
178 
179   /**
180    * @dev Transfer tokens from one address to another
181    * @param _from address The address which you want to send tokens from
182    * @param _to address The address which you want to transfer to
183    * @param _value uint256 the amount of tokens to be transferred
184    */
185   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
186     require(_to != address(0x0));
187 
188     uint256 _allowance = allowed[_from][msg.sender];
189 
190     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
191     // require (_value <= _allowance);
192 
193     balances[_from] = balances[_from].sub(_value);
194     balances[_to] = balances[_to].add(_value);
195     allowed[_from][msg.sender] = _allowance.sub(_value);
196     emit Transfer(_from, _to, _value);
197     return true;
198   }
199 
200   
201   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
202     allowed[msg.sender][_spender] = _value;
203     emit Approval(msg.sender, _spender, _value);
204     return true;
205   }
206 
207   function allowance(address _owner, address _spender) public view whenNotPaused returns (uint256 remaining) {
208     return allowed[_owner][_spender];
209   }
210 
211   
212   function increaseApproval (address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
213     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
214     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
215     return true;
216   }
217 
218   function decreaseApproval (address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
219     uint oldValue = allowed[msg.sender][_spender];
220     if (_subtractedValue > oldValue) {
221       allowed[msg.sender][_spender] = 0;
222     } else {
223       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
224     }
225     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229 }
230 
231 contract GRC is StandardToken {
232     using SafeMath for uint256;
233 
234     string public name = "Global Currency Restart";
235     string public symbol = "GCR";
236     uint256 public decimals = 18;
237     uint256 public totalSupply =  15600000000  * (10 ** decimals);
238     uint256 public totalAvailable =  0;
239     uint256 public rate = 2222;
240     address payable public walletETH = msg.sender;
241 
242     constructor() public {
243       balances[walletETH] = totalSupply;
244       totalAvailable = totalSupply;
245     }
246 
247     modifier nonZeroBuy() {
248         require(msg.value > 0, "value cannot be zero");
249         _;
250     }
251 
252     function () external nonZeroBuy payable {
253         uint256 amount = msg.value.mul(rate);
254         require(totalAvailable >= amount);
255         
256         assignTokens(msg.sender, amount);
257         forwardFundsToWallet();
258     }
259 
260     function forwardFundsToWallet() internal {
261         walletETH.transfer(msg.value);
262     }
263 
264     function assignTokens(address recipient, uint256 amount) internal {
265         uint256 amountTotal = amount;
266         balances[walletETH] = balances[walletETH].sub(amountTotal);
267         balances[recipient] = balances[recipient].add(amountTotal);
268         totalAvailable = totalAvailable.sub(amount);
269         emit Transfer(walletETH, recipient, amountTotal);
270     }
271 
272     function setRate(uint256 _rate) public onlyOwner {
273         require(_rate > 0,"rate cannot be zero");
274         rate = _rate;
275     }
276 }