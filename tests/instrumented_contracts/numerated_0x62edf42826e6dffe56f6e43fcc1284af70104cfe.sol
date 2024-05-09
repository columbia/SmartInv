1 pragma solidity ^0.4.24;
2 
3 
4 library SafeMath {
5 
6   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
7     if (a == 0) { return 0; }
8     c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     return a / b;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
23     c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 
28 }
29 
30 
31 contract Ownable {
32   address public owner;
33   address public pendingOwner;
34 
35   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37 
38   constructor() public {
39     owner = msg.sender;
40     pendingOwner = address(0);
41   }
42 
43 
44 
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50 
51   function transferOwnership(address newOwner) onlyOwner external {
52     pendingOwner = newOwner;
53   }
54 
55   function claimOwnership() external {
56     require(msg.sender == pendingOwner);
57     emit OwnershipTransferred(owner, pendingOwner);
58     owner = pendingOwner;
59     pendingOwner = address(0);
60   }
61 
62 }
63 
64 
65 contract Pausable is Ownable {
66   event Pause();
67   event Unpause();
68 
69   bool public paused = false;
70 
71 
72   modifier whenNotPaused() {
73     require(!paused || msg.sender == owner);
74     _;
75   }
76 
77   modifier whenPaused() {
78     require(paused);
79     _;
80   }
81 
82   function pause() onlyOwner whenNotPaused external {
83     paused = true;
84     emit Pause();
85   }
86 
87   function unpause() onlyOwner whenPaused external {
88     paused = false;
89     emit Unpause();
90   }
91 
92 }
93 
94 
95 contract ERC20 {
96   function totalSupply() public view returns (uint256);
97   function balanceOf(address who) public view returns (uint256);
98   function transfer(address to, uint256 value) public returns (bool);
99   function allowance(address owner, address spender) public view returns (uint256);
100   function transferFrom(address from, address to, uint256 value) public returns (bool);
101   function approve(address spender, uint256 value) public returns (bool);
102   event Approval(address indexed owner, address indexed spender, uint256 value);
103   event Transfer(address indexed from, address indexed to, uint256 value);
104 }
105 
106 
107 contract TokenBase is ERC20, Pausable {
108   using SafeMath for uint256;
109 
110   mapping (address => uint256) balances;
111   mapping (address => mapping (address => uint256)) internal allowed;
112 
113   uint256 totalSupply_;
114 
115   modifier isValidDestination(address _to) {
116     require(_to != address(0x0));
117     require(_to != address(this));
118     _;
119   }
120 
121 
122   function totalSupply() public view returns (uint256) {
123     return totalSupply_;
124   }
125 
126   function balanceOf(address _owner) public view returns (uint256) {
127     return balances[_owner];
128   }
129 
130   function allowance(address _owner, address _spender) public view returns (uint256) {
131     return allowed[_owner][_spender];
132   }
133 
134 
135 
136   function transfer(address _to, uint256 _value) public whenNotPaused isValidDestination(_to) returns (bool) {
137     require(_to != address(0));
138     require(_value <= balances[msg.sender]);
139 
140     balances[msg.sender] = balances[msg.sender].sub(_value);
141     balances[_to] = balances[_to].add(_value);
142     emit Transfer(msg.sender, _to, _value);
143     return true;
144   }
145 
146   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused isValidDestination(_to) returns (bool) {
147     require(_to != address(0));
148     require(_value <= balances[_from]);
149     require(_value <= allowed[_from][msg.sender]);
150 
151     balances[_from] = balances[_from].sub(_value);
152     balances[_to] = balances[_to].add(_value);
153     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
154     emit Transfer(_from, _to, _value);
155     return true;
156   }
157 
158   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
159     allowed[msg.sender][_spender] = _value;
160     emit Approval(msg.sender, _spender, _value);
161     return true;
162   }
163 
164   function increaseApproval(address _spender, uint256 _addedValue) public whenNotPaused returns (bool) {
165     allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
166     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
167     return true;
168   }
169 
170   function decreaseApproval(address _spender, uint256 _subtractedValue) public whenNotPaused returns (bool) {
171     uint256 oldValue = allowed[msg.sender][_spender];
172     if (_subtractedValue > oldValue) {
173       allowed[msg.sender][_spender] = 0;
174     } else {
175       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
176     }
177     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
178     return true;
179   }
180 
181 }
182 
183 
184 contract MintableToken is TokenBase {
185   event Mint(address indexed to, uint256 amount);
186   event MintFinished();
187 
188   bool public mintingFinished = false;
189 
190 
191   modifier canMint() {
192     require(!mintingFinished);
193     _;
194   }
195 
196 
197   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
198     totalSupply_ = totalSupply_.add(_amount);
199     balances[_to] = balances[_to].add(_amount);
200     emit Mint(_to, _amount);
201     emit Transfer(address(0), _to, _amount);
202     return true;
203   }
204 
205   function finishMinting() onlyOwner canMint external returns (bool) {
206     mintingFinished = true;
207     emit MintFinished();
208     return true;
209   }
210 
211 }
212 
213 
214 contract BurnableToken is MintableToken {
215   event Burn(address indexed burner, uint256 value);
216 
217 
218   function burn(uint256 _value) external {
219     require(_value <= balances[msg.sender]);
220 
221     balances[msg.sender] = balances[msg.sender].sub(_value);
222     totalSupply_ = totalSupply_.sub(_value);
223     emit Burn(msg.sender, _value);
224     emit Transfer(msg.sender, address(0), _value);
225   }
226 
227 }
228 
229 
230 contract SleekPlayToken is BurnableToken {
231   string public constant name = "SleekPlay Token";
232   string public constant symbol = "SKP";
233   uint8 public constant decimals = 18;
234 
235 
236   /**
237   * @dev Allows the owner to take out wrongly sent tokens to this contract by mistake.
238   * @param _token The contract address of the token that is getting pulled out.
239   * @param _amount The amount to pull out.
240   */
241   function pullOut(ERC20 _token, uint256 _amount) external onlyOwner {
242     _token.transfer(owner, _amount);
243   }
244 
245   /**
246   * @dev 'tokenFallback' function in accordance to the ERC223 standard. Rejects all incoming ERC223 token transfers.
247   */
248   function tokenFallback(address from_, uint256 value_, bytes data_) public {
249     from_; value_; data_;
250     revert();
251   }
252 
253   function() external payable {
254       revert("This contract does not accept Ethereum!");
255     }
256 
257 }