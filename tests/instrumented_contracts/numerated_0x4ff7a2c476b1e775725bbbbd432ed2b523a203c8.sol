1 pragma solidity ^0.4.24;
2 
3 /* 
4  * Stem Cell Innovations Token Contract
5  * =======================
6  *
7  * BASED on the OpenZeppelin Contracts. 
8  * ASSEMBLED, MODIFIED & DELIVERED by Codemelt.
9  * FOR SCIA (https://scia.io).
10  */
11 
12 
13 
14 library SafeMath {
15 
16   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
17     if (a == 0) { return 0; }
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     return a / b;
25   }
26 
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
33     c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 
38 }
39 
40 
41 contract Ownable {
42   address public owner;
43   address public pendingOwner;
44 
45   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47 
48   constructor() public {
49     owner = msg.sender;
50     pendingOwner = address(0);
51   }
52 
53 
54 
55   modifier onlyOwner() {
56     require(msg.sender == owner);
57     _;
58   }
59 
60 
61   function transferOwnership(address newOwner) onlyOwner external {
62     pendingOwner = newOwner;
63   }
64 
65   function claimOwnership() external {
66     require(msg.sender == pendingOwner);
67     emit OwnershipTransferred(owner, pendingOwner);
68     owner = pendingOwner;
69     pendingOwner = address(0);
70   }
71 
72 }
73 
74 
75 contract Pausable is Ownable {
76   event Pause();
77   event Unpause();
78 
79   bool public paused = false;
80 
81 
82   modifier whenNotPaused() {
83     require(!paused || msg.sender == owner);
84     _;
85   }
86 
87   modifier whenPaused() {
88     require(paused);
89     _;
90   }
91 
92   function pause() onlyOwner whenNotPaused external {
93     paused = true;
94     emit Pause();
95   }
96 
97   function unpause() onlyOwner whenPaused external {
98     paused = false;
99     emit Unpause();
100   }
101 
102 }
103 
104 
105 contract ERC20 {
106   function totalSupply() public view returns (uint256);
107   function balanceOf(address who) public view returns (uint256);
108   function transfer(address to, uint256 value) public returns (bool);
109   function allowance(address owner, address spender) public view returns (uint256);
110   function transferFrom(address from, address to, uint256 value) public returns (bool);
111   function approve(address spender, uint256 value) public returns (bool);
112   event Approval(address indexed owner, address indexed spender, uint256 value);
113   event Transfer(address indexed from, address indexed to, uint256 value);
114 }
115 
116 
117 contract TokenBase is ERC20, Pausable {
118   using SafeMath for uint256;
119 
120   mapping (address => uint256) balances;
121   mapping (address => mapping (address => uint256)) internal allowed;
122 
123   uint256 totalSupply_;
124 
125   modifier isValidDestination(address _to) {
126     require(_to != address(0x0));
127     require(_to != address(this));
128     _;
129   }
130 
131 
132   function totalSupply() public view returns (uint256) {
133     return totalSupply_;
134   }
135 
136   function balanceOf(address _owner) public view returns (uint256) {
137     return balances[_owner];
138   }
139 
140   function allowance(address _owner, address _spender) public view returns (uint256) {
141     return allowed[_owner][_spender];
142   }
143 
144 
145 
146   function transfer(address _to, uint256 _value) public whenNotPaused isValidDestination(_to) returns (bool) {
147     require(_to != address(0));
148     require(_value <= balances[msg.sender]);
149 
150     balances[msg.sender] = balances[msg.sender].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     emit Transfer(msg.sender, _to, _value);
153     return true;
154   }
155 
156   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused isValidDestination(_to) returns (bool) {
157     require(_to != address(0));
158     require(_value <= balances[_from]);
159     require(_value <= allowed[_from][msg.sender]);
160 
161     balances[_from] = balances[_from].sub(_value);
162     balances[_to] = balances[_to].add(_value);
163     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
164     emit Transfer(_from, _to, _value);
165     return true;
166   }
167 
168   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
169     allowed[msg.sender][_spender] = _value;
170     emit Approval(msg.sender, _spender, _value);
171     return true;
172   }
173 
174   function increaseApproval(address _spender, uint256 _addedValue) public whenNotPaused returns (bool) {
175     allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
176     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
177     return true;
178   }
179 
180   function decreaseApproval(address _spender, uint256 _subtractedValue) public whenNotPaused returns (bool) {
181     uint256 oldValue = allowed[msg.sender][_spender];
182     if (_subtractedValue > oldValue) {
183       allowed[msg.sender][_spender] = 0;
184     } else {
185       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
186     }
187     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
188     return true;
189   }
190 
191 }
192 
193 
194 contract MintableToken is TokenBase {
195   event Mint(address indexed to, uint256 amount);
196   event MintFinished();
197 
198   bool public mintingFinished = false;
199 
200 
201   modifier canMint() {
202     require(!mintingFinished);
203     _;
204   }
205 
206 
207   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
208     totalSupply_ = totalSupply_.add(_amount);
209     balances[_to] = balances[_to].add(_amount);
210     emit Mint(_to, _amount);
211     emit Transfer(address(0), _to, _amount);
212     return true;
213   }
214 
215   function finishMinting() onlyOwner canMint external returns (bool) {
216     mintingFinished = true;
217     emit MintFinished();
218     return true;
219   }
220 
221 }
222 
223 
224 contract BurnableToken is MintableToken {
225   event Burn(address indexed burner, uint256 value);
226 
227 
228   function burn(uint256 _value) external {
229     require(_value <= balances[msg.sender]);
230 
231     balances[msg.sender] = balances[msg.sender].sub(_value);
232     totalSupply_ = totalSupply_.sub(_value);
233     emit Burn(msg.sender, _value);
234     emit Transfer(msg.sender, address(0), _value);
235   }
236 
237 }
238 
239 
240 contract StemToken is BurnableToken {
241   string public constant name = "Stem Cell Innovations Token";
242   string public constant symbol = "STEM";
243   uint8 public constant decimals = 18;
244 
245 
246   /**
247   * @dev Allows the owner to take tokens to this contract by mistake.
248   * @param _token The contract address of the token that is getting pulled out.
249   * @param _amount The amount to pull out.
250   */
251   function pullOut(ERC20 _token, uint256 _amount) external onlyOwner {
252     _token.transfer(owner, _amount);
253   }
254 
255   /**
256   * @dev 'tokenFallback' function in accordance to the ERC223 standard. Rejects all incoming ERC223 token transfers.
257   */
258   function tokenFallback(address from_, uint256 value_, bytes data_) public {
259     from_; value_; data_;
260     revert();
261   }
262 
263   function() external payable {
264       revert("This contract does not accept Ethereum!");
265     }
266 
267 }