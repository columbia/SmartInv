1 pragma solidity ^0.4.24;
2 
3 contract AraniumToken {
4   using SafeMath for uint;
5   using SafeERC20 for AraniumToken;
6 
7   string public name = "Aranium";
8   string public constant symbol = "ARA";
9   uint8 public constant decimals = 18;
10   uint public constant decimalsFactor = 10 ** uint(decimals);
11   uint public cap = 3800000000 * decimalsFactor;
12 
13   address public owner;
14   mapping (address => bool) public companions;
15   address[] public companionsList;
16   bool public paused = false;
17   mapping(address => uint256) balances;
18   uint256 totalSupply_;
19   mapping (address => mapping (address => uint256)) internal allowed;
20   bool public mintingFinished = false;
21 
22   modifier onlyOwner() {
23     require((msg.sender == owner) || (companions[msg.sender]));
24     _;
25   }
26 
27   modifier whenNotPaused() {
28     require(!paused);
29     _;
30   }
31 
32   modifier whenPaused() {
33     require(paused);
34     _;
35   }
36 
37   modifier canMint() {
38     require(!mintingFinished);
39     _;
40   }
41 
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43   event CompanionAdded(address indexed _companion);
44   event CompanionRemoved(address indexed _companion);
45   event Pause();
46   event Unpause();
47   event Transfer(address indexed from, address indexed to, uint256 value);
48   event Approval(address indexed owner, address indexed spender, uint256 value);
49   event Mint(address indexed to, uint256 amount);
50   event MintFinished();
51   event MintFinishedChanged();
52   event NameChanged();
53   event CapChanged(uint256 oldVal, uint256 newVal);
54 
55 
56   constructor() public {
57     owner = msg.sender;
58     totalSupply_ = cap;
59     balances[msg.sender] = totalSupply_;
60     mintingFinished = true;
61   }
62 
63 
64   function setName(string _name) onlyOwner public {
65     require(bytes(_name).length != 0);
66     name = _name;
67     emit NameChanged();
68   }
69 
70   function setCap(uint256 _cap) onlyOwner public {
71     require(cap > 0);
72     require(_cap >= totalSupply_);
73     uint256 old = cap;
74     cap = _cap;
75     emit CapChanged(old, cap);
76   }
77 
78   function totalSupply() public view returns (uint256) {
79     return totalSupply_;
80   }
81 
82   function balanceOf(address _owner) public view returns (uint256) {
83     return balances[_owner];
84   }
85 
86   function allowance(address _owner, address _spender) public view returns (uint256) {
87     return allowed[_owner][_spender];
88   }
89 
90   function transfer(address _to, uint256 _value) whenNotPaused public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     emit Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100   function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool) {
101     require(_to != address(0));
102     require(_value <= balances[_from]);
103     require(_value <= allowed[_from][msg.sender]);
104 
105     balances[_from] = balances[_from].sub(_value);
106     balances[_to] = balances[_to].add(_value);
107     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
108     emit Transfer(_from, _to, _value);
109     return true;
110   }
111 
112   function approve(address _spender, uint256 _value) whenNotPaused public returns (bool) {
113     allowed[msg.sender][_spender] = _value;
114     emit Approval(msg.sender, _spender, _value);
115     return true;
116   }
117 
118   function increaseApproval(address _spender, uint _addedValue) whenNotPaused public returns (bool) {
119     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
120     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
121     return true;
122   }
123 
124   function decreaseApproval(address _spender, uint _subtractedValue) whenNotPaused public returns (bool) {
125     uint oldValue = allowed[msg.sender][_spender];
126     if (_subtractedValue > oldValue) {
127       allowed[msg.sender][_spender] = 0;
128     } else {
129       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
130     }
131     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
132     return true;
133   }
134 
135 
136   function pause() onlyOwner whenNotPaused public {
137     paused = true;
138     emit Pause();
139   }
140 
141   function unpause() onlyOwner whenPaused public {
142     paused = false;
143     emit Unpause();
144   }
145 
146   function transferOwnership(address newOwner) onlyOwner public {
147     require(newOwner != address(0));
148     owner = newOwner;
149     emit OwnershipTransferred(owner, newOwner);
150   }
151 
152   function addCompanion(address _companion) onlyOwner public {
153     require(_companion != address(0));
154     companions[_companion] = true;
155     companionsList.push(_companion);
156     emit CompanionAdded(_companion);
157   }
158 
159   function removeCompanion(address _companion) onlyOwner public {
160     require(_companion != address(0));
161     companions[_companion] = false;
162     // -- companionsList element remains, for record purposes.
163     emit CompanionRemoved(_companion);
164   }
165 
166   // -- onlyOwner: returns 0 in MEW.
167   function companionsListCount() onlyOwner public view returns (uint256) {
168     return companionsList.length;
169   }
170 
171   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
172     require(totalSupply_.add(_amount) <= cap);
173     totalSupply_ = totalSupply_.add(_amount);
174     balances[_to] = balances[_to].add(_amount);
175     emit Mint(_to, _amount);
176     emit Transfer(address(0), _to, _amount); // -- 0x0 means mint.
177     return true;
178   }
179 
180   function finishMinting() onlyOwner canMint public returns (bool) {
181     mintingFinished = true;
182     emit MintFinished();
183     return true;
184   }
185   
186   function setMintingFinish(bool m) onlyOwner public returns (bool) {
187     mintingFinished = m;
188     emit MintFinishedChanged();
189     return true;
190   }
191 
192   function reclaimToken(AraniumToken token) onlyOwner external {
193     uint256 balance = token.balanceOf(this);
194     token.safeTransfer(owner, balance);
195   }
196 
197 }
198 
199 
200 /**
201  * @title SafeMath
202  * @dev Math operations with safety checks that throw on error
203  */
204 library SafeMath {
205 
206   /**
207    * @dev Multiplies two numbers, throws on overflow.
208    */
209   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
210     if (a == 0) {
211       return 0;
212     }
213     c = a * b;
214     assert(c / a == b);
215     return c;
216   }
217 
218   /**
219    * @dev Integer division of two numbers, truncating the quotient.
220    */
221   function div(uint256 a, uint256 b) internal pure returns (uint256) {
222     // assert(b > 0); // Solidity automatically throws when dividing by 0
223     // uint256 c = a / b;
224     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
225     return a / b;
226   }
227 
228   /**
229    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
230    */
231   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
232     assert(b <= a);
233     return a - b;
234   }
235 
236   /**
237    * @dev Adds two numbers, throws on overflow.
238    */
239   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
240     c = a + b;
241     assert(c >= a);
242     return c;
243   }
244 
245 }
246 
247 
248 /**
249  * @title SafeERC20
250  * @dev Wrappers around ERC20 operations that throw on failure.
251  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
252  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
253  */
254 library SafeERC20 {
255 
256   function safeTransfer(AraniumToken token, address to, uint256 value) internal {
257     assert(token.transfer(to, value));
258   }
259 
260   function safeTransferFrom(AraniumToken token, address from, address to, uint256 value) internal {
261     assert(token.transferFrom(from, to, value));
262   }
263 
264   function safeApprove(AraniumToken token, address spender, uint256 value) internal {
265     assert(token.approve(spender, value));
266   }
267 
268 }