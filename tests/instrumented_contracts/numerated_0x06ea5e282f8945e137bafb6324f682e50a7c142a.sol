1 pragma solidity ^0.4.24;
2 
3 /* 
4  * CodeOfTalent Token Contract
5  * =======================
6  * 
7  * BASED on the OpenZeppelin Contracts Library.
8  * ASSEMBLED & MODIFIED by Codemelt.
9  * FOR Code Of Talent.
10  */
11 
12 library SafeMath {
13 
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     if (a == 0) { return 0; }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   function div(uint256 a, uint256 b) internal pure returns (uint256) {
22     return a / b;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
31     c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 
36 }
37 
38 
39 contract Ownable {
40   address public owner;
41   address public pendingOwner;
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46   constructor() public {
47     owner = msg.sender;
48     pendingOwner = address(0);
49   }
50 
51 
52 
53   modifier onlyOwner() {
54     require(msg.sender == owner);
55     _;
56   }
57 
58 
59   function transferOwnership(address newOwner) onlyOwner external {
60     pendingOwner = newOwner;
61   }
62 
63   function claimOwnership() external {
64     require(msg.sender == pendingOwner);
65     emit OwnershipTransferred(owner, pendingOwner);
66     owner = pendingOwner;
67     pendingOwner = address(0);
68   }
69 
70 }
71 
72 
73 contract Pausable is Ownable {
74   event Pause();
75   event Unpause();
76 
77   bool public paused = false;
78 
79 
80   modifier whenNotPaused() {
81     require(!paused || msg.sender == owner);
82     _;
83   }
84 
85   modifier whenPaused() {
86     require(paused);
87     _;
88   }
89 
90   function pause() onlyOwner whenNotPaused external {
91     paused = true;
92     emit Pause();
93   }
94 
95   function unpause() onlyOwner whenPaused external {
96     paused = false;
97     emit Unpause();
98   }
99 
100 }
101 
102 
103 contract ERC20 {
104   function totalSupply() public view returns (uint256);
105   function balanceOf(address who) public view returns (uint256);
106   function transfer(address to, uint256 value) public returns (bool);
107   function allowance(address owner, address spender) public view returns (uint256);
108   function transferFrom(address from, address to, uint256 value) public returns (bool);
109   function approve(address spender, uint256 value) public returns (bool);
110   event Approval(address indexed owner, address indexed spender, uint256 value);
111   event Transfer(address indexed from, address indexed to, uint256 value);
112 }
113 
114 
115 contract TokenBase is ERC20, Pausable {
116   using SafeMath for uint256;
117 
118   mapping (address => uint256) balances;
119   mapping (address => mapping (address => uint256)) internal allowed;
120 
121   uint256 totalSupply_;
122 
123   modifier isValidDestination(address _to) {
124     require(_to != address(0x0));
125     require(_to != address(this));
126     _;
127   }
128 
129 
130   function totalSupply() public view returns (uint256) {
131     return totalSupply_;
132   }
133 
134   function balanceOf(address _owner) public view returns (uint256) {
135     return balances[_owner];
136   }
137 
138   function allowance(address _owner, address _spender) public view returns (uint256) {
139     return allowed[_owner][_spender];
140   }
141 
142 
143 
144   function transfer(address _to, uint256 _value) public whenNotPaused isValidDestination(_to) returns (bool) {
145     require(_to != address(0));
146     require(_value <= balances[msg.sender]);
147 
148     balances[msg.sender] = balances[msg.sender].sub(_value);
149     balances[_to] = balances[_to].add(_value);
150     emit Transfer(msg.sender, _to, _value);
151     return true;
152   }
153 
154   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused isValidDestination(_to) returns (bool) {
155     require(_to != address(0));
156     require(_value <= balances[_from]);
157     require(_value <= allowed[_from][msg.sender]);
158 
159     balances[_from] = balances[_from].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
162     emit Transfer(_from, _to, _value);
163     return true;
164   }
165 
166   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
167     allowed[msg.sender][_spender] = _value;
168     emit Approval(msg.sender, _spender, _value);
169     return true;
170   }
171 
172   function increaseApproval(address _spender, uint256 _addedValue) public whenNotPaused returns (bool) {
173     allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
174     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
175     return true;
176   }
177 
178   function decreaseApproval(address _spender, uint256 _subtractedValue) public whenNotPaused returns (bool) {
179     uint256 oldValue = allowed[msg.sender][_spender];
180     if (_subtractedValue > oldValue) {
181       allowed[msg.sender][_spender] = 0;
182     } else {
183       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
184     }
185     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
186     return true;
187   }
188 
189 }
190 
191 
192 contract MintableToken is TokenBase {
193   event Mint(address indexed to, uint256 amount);
194   event MintFinished();
195 
196   bool public mintingFinished = false;
197 
198 
199   modifier canMint() {
200     require(!mintingFinished);
201     _;
202   }
203 
204 
205   function mint(address _to, uint256 _amount) onlyOwner canMint isValidDestination(_to) public returns (bool) {
206     totalSupply_ = totalSupply_.add(_amount);
207     balances[_to] = balances[_to].add(_amount);
208     emit Mint(_to, _amount);
209     emit Transfer(address(0), _to, _amount);
210     return true;
211   }
212 
213   function finishMinting() onlyOwner canMint external returns (bool) {
214     mintingFinished = true;
215     emit MintFinished();
216     return true;
217   }
218 
219 }
220 
221 
222 contract BurnableToken is MintableToken {
223   event Burn(address indexed burner, uint256 value);
224 
225 
226   function burn(uint256 _value) external {
227     require(_value <= balances[msg.sender]);
228 
229     balances[msg.sender] = balances[msg.sender].sub(_value);
230     totalSupply_ = totalSupply_.sub(_value);
231     emit Burn(msg.sender, _value);
232     emit Transfer(msg.sender, address(0), _value);
233   }
234 
235 }
236 
237 
238 contract CodeOfTalentToken is BurnableToken {
239   string public constant name = "CodeOfTalent Token";
240   string public constant symbol = "CODE";
241   uint8 public constant decimals = 18;
242 
243 
244 
245 
246   /**
247   * @dev Allows the owner to take out wrongly sent tokens to this contract by mistake.
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
263 
264 
265   function() external payable {
266       revert("This contract does not accept Ethereum!");
267     }
268 
269 }