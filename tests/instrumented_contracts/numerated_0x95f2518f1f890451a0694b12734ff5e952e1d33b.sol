1 pragma solidity ^0.4.21;
2 
3 contract TimetechToken {
4   using SafeMath for uint;
5   using SafeERC20 for TimetechToken;
6 
7   string public name = "timetech";
8   string public constant symbol = "TTEC";
9   uint8 public constant decimals = 18;
10   uint public constant decimalsFactor = 10 ** uint(decimals);
11   uint public cap = 8290000000 * decimalsFactor;
12 
13   address public owner;
14   bool public paused = false;
15   mapping(address => uint256) balances;
16   uint256 totalSupply_;
17   mapping (address => mapping (address => uint256)) internal allowed;
18   bool public mintingFinished = false;
19 
20   modifier onlyOwner() {
21     require(msg.sender == owner);
22     _;
23   }
24 
25   modifier whenNotPaused() {
26     require(!paused);
27     _;
28   }
29 
30   modifier whenPaused() {
31     require(paused);
32     _;
33   }
34 
35   modifier canMint() {
36     require(!mintingFinished);
37     _;
38   }
39 
40   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41   event Pause();
42   event Unpause();
43   event Transfer(address indexed from, address indexed to, uint256 value);
44   event Approval(address indexed owner, address indexed spender, uint256 value);
45   event Mint(address indexed to, uint256 amount);
46   event MintFinished();
47   event NameChanged();
48   event CapChanged(uint256 oldVal, uint256 newVal);
49 
50 
51   function TimetechToken() public {
52     paused = true;
53     owner = msg.sender;
54   }
55 
56 
57   function setName(string _name) public {
58     require(bytes(_name).length != 0);
59     name = _name;
60     emit NameChanged();
61   }
62 
63   function setCap(uint256 _cap) onlyOwner public {
64     require(cap > 0);
65     require(_cap >= totalSupply_);
66     uint256 old = cap;
67     cap = _cap;
68     emit CapChanged(old, cap);
69   }
70 
71   function totalSupply() public view returns (uint256) {
72     return totalSupply_;
73   }
74 
75   function balanceOf(address _owner) public view returns (uint256) {
76     return balances[_owner];
77   }
78 
79   function allowance(address _owner, address _spender) public view returns (uint256) {
80     return allowed[_owner][_spender];
81   }
82 
83   function transfer(address _to, uint256 _value) whenNotPaused public returns (bool) {
84     require(_to != address(0));
85     require(_value <= balances[msg.sender]);
86 
87     balances[msg.sender] = balances[msg.sender].sub(_value);
88     balances[_to] = balances[_to].add(_value);
89     emit Transfer(msg.sender, _to, _value);
90     return true;
91   }
92 
93   function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool) {
94     require(_to != address(0));
95     require(_value <= balances[_from]);
96     require(_value <= allowed[_from][msg.sender]);
97 
98     balances[_from] = balances[_from].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
101     emit Transfer(_from, _to, _value);
102     return true;
103   }
104 
105   function approve(address _spender, uint256 _value) whenNotPaused public returns (bool) {
106     allowed[msg.sender][_spender] = _value;
107     emit Approval(msg.sender, _spender, _value);
108     return true;
109   }
110 
111   function increaseApproval(address _spender, uint _addedValue) whenNotPaused public returns (bool) {
112     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
113     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
114     return true;
115   }
116 
117   function decreaseApproval(address _spender, uint _subtractedValue) whenNotPaused public returns (bool) {
118     uint oldValue = allowed[msg.sender][_spender];
119     if (_subtractedValue > oldValue) {
120       allowed[msg.sender][_spender] = 0;
121     } else {
122       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
123     }
124     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
125     return true;
126   }
127 
128 
129   function pause() onlyOwner whenNotPaused public {
130     paused = true;
131     emit Pause();
132   }
133 
134   function unpause() onlyOwner whenPaused public {
135     paused = false;
136     emit Unpause();
137   }
138 
139   function transferOwnership(address newOwner) onlyOwner public {
140     require(newOwner != address(0));
141     owner = newOwner;
142     emit OwnershipTransferred(owner, newOwner);
143   }
144 
145   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
146     require(totalSupply_.add(_amount) <= cap);
147     totalSupply_ = totalSupply_.add(_amount);
148     balances[_to] = balances[_to].add(_amount);
149     emit Mint(_to, _amount);
150     emit Transfer(address(0), _to, _amount); // -- 0x0 means mint.
151     return true;
152   }
153 
154   function finishMinting() onlyOwner canMint public returns (bool) {
155     mintingFinished = true;
156     emit MintFinished();
157     return true;
158   }
159 
160   function reclaimToken(TimetechToken token) onlyOwner external {
161     uint256 balance = token.balanceOf(this);
162     token.safeTransfer(owner, balance);
163   }
164 
165 }
166 
167 
168 /**
169  * @title SafeMath
170  * @dev Math operations with safety checks that throw on error
171  */
172 library SafeMath {
173 
174   /**
175    * @dev Multiplies two numbers, throws on overflow.
176    */
177   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
178     if (a == 0) {
179       return 0;
180     }
181     c = a * b;
182     assert(c / a == b);
183     return c;
184   }
185 
186   /**
187    * @dev Integer division of two numbers, truncating the quotient.
188    */
189   function div(uint256 a, uint256 b) internal pure returns (uint256) {
190     // assert(b > 0); // Solidity automatically throws when dividing by 0
191     // uint256 c = a / b;
192     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
193     return a / b;
194   }
195 
196   /**
197    * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
198    */
199   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
200     assert(b <= a);
201     return a - b;
202   }
203 
204   /**
205    * @dev Adds two numbers, throws on overflow.
206    */
207   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
208     c = a + b;
209     assert(c >= a);
210     return c;
211   }
212 
213 }
214 
215 
216 /**
217  * @title SafeERC20
218  * @dev Wrappers around ERC20 operations that throw on failure.
219  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
220  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
221  */
222 library SafeERC20 {
223 
224   function safeTransfer(TimetechToken token, address to, uint256 value) internal {
225     assert(token.transfer(to, value));
226   }
227 
228   function safeTransferFrom(TimetechToken token, address from, address to, uint256 value) internal {
229     assert(token.transferFrom(from, to, value));
230   }
231 
232   function safeApprove(TimetechToken token, address spender, uint256 value) internal {
233     assert(token.approve(spender, value));
234   }
235 
236 }