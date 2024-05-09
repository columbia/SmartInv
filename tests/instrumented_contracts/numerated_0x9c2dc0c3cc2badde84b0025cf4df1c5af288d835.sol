1 pragma solidity ^0.6.0;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6     if (a == 0) { return 0; }
7     c = a * b;
8     assert(c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     return a / b;
14   }
15 
16   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17     assert(b <= a);
18     return a - b;
19   }
20 
21   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
22     c = a + b;
23     assert(c >= a);
24     return c;
25   }
26 
27 }
28 
29 contract Ownable {
30   address public admin;
31   mapping(address => bool) public owners;
32 
33   constructor() public {
34     admin = msg.sender;
35   }
36 
37   modifier onlyOwner() {
38     require(owners[msg.sender] || admin == msg.sender);
39     _;
40   }
41 
42   function addOwner(address newOwner) onlyOwner public returns(bool success) {
43     if (!owners[newOwner]) {
44       owners[newOwner] = true;
45       success = true; 
46     }
47   }
48   
49   function removeOwner(address oldOwner) onlyOwner public returns(bool success) {
50     if (owners[oldOwner]) {
51       owners[oldOwner] = false;
52       success = true;
53     }
54   }
55 
56 }
57 
58 contract Pausable is Ownable {
59   event Pause();
60   event Unpause();
61 
62   bool public paused = false;
63 
64   modifier whenNotPaused() {
65     require(!paused || msg.sender == admin || owners[msg.sender]);
66     _;
67   }
68 
69   modifier whenPaused() {
70     require(paused);
71     _;
72   }
73 
74   function pause() onlyOwner whenNotPaused external {
75     paused = true;
76     emit Pause();
77   }
78 
79   function unpause() onlyOwner whenPaused external {
80     paused = false;
81     emit Unpause();
82   }
83 
84 }
85 
86 abstract contract ERC20 {
87   function totalSupply() virtual public view returns (uint256);
88   function balanceOf(address who) virtual public view returns (uint256);
89   function transfer(address to, uint256 value) virtual public returns (bool);
90   function allowance(address owner, address spender) virtual public view returns (uint256);
91   function transferFrom(address from, address to, uint256 value) virtual public returns (bool);
92   function approve(address spender, uint256 value) virtual public returns (bool);
93   event Approval(address indexed owner, address indexed spender, uint256 value);
94   event Transfer(address indexed from, address indexed to, uint256 value);
95 }
96 
97 contract TokenBase is ERC20, Pausable {
98   using SafeMath for uint256;
99 
100   mapping (address => uint256) balances;
101   mapping (address => mapping (address => uint256)) internal allowed;
102 
103   uint256 totalSupply_;
104 
105   modifier isValidDestination(address _to) {
106     require(_to != address(0x0));
107     require(_to != address(this));
108     _;
109   }
110 
111   function totalSupply() override public view returns (uint256) {
112     return totalSupply_;
113   }
114 
115   function balanceOf(address _owner) override public view returns (uint256) {
116     return balances[_owner];
117   }
118 
119   function allowance(address _owner, address _spender) override public view returns (uint256) {
120     return allowed[_owner][_spender];
121   }
122 
123   function transfer(address _to, uint256 _value) override public whenNotPaused isValidDestination(_to) returns (bool) {
124     require(_to != address(0));
125     require(_value <= balances[msg.sender]);
126 
127     balances[msg.sender] = balances[msg.sender].sub(_value);
128     balances[_to] = balances[_to].add(_value);
129     emit Transfer(msg.sender, _to, _value);
130     return true;
131   }
132 
133   function transferFrom(address _from, address _to, uint256 _value) override public whenNotPaused isValidDestination(_to) returns (bool) {
134     require(_to != address(0));
135     require(_value <= balances[_from]);
136     require(_value <= allowed[_from][msg.sender]);
137 
138     balances[_from] = balances[_from].sub(_value);
139     balances[_to] = balances[_to].add(_value);
140     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
141     emit Transfer(_from, _to, _value);
142     return true;
143   }
144 
145   function approve(address _spender, uint256 _value) override public whenNotPaused returns (bool) {
146     allowed[msg.sender][_spender] = _value;
147     emit Approval(msg.sender, _spender, _value);
148     return true;
149   }
150 
151   function increaseApproval(address _spender, uint256 _addedValue) public whenNotPaused returns (bool) {
152     allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
153     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
154     return true;
155   }
156 
157   function decreaseApproval(address _spender, uint256 _subtractedValue) public whenNotPaused returns (bool) {
158     uint256 oldValue = allowed[msg.sender][_spender];
159     if (_subtractedValue > oldValue) {
160       allowed[msg.sender][_spender] = 0;
161     } else {
162       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
163     }
164     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
165     return true;
166   }
167 
168 }
169 
170 contract MintableToken is TokenBase {
171   event Mint(address indexed to, uint256 amount);
172   event MintFinished();
173 
174   bool public mintingFinished = false;
175 
176   modifier canMint() {
177     require(!mintingFinished);
178     _;
179   }
180 
181   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
182     totalSupply_ = totalSupply_.add(_amount);
183     balances[_to] = balances[_to].add(_amount);
184     emit Mint(_to, _amount);
185     emit Transfer(address(0), _to, _amount);
186     return true;
187   }
188 
189   function finishMinting() onlyOwner canMint external returns (bool) {
190     mintingFinished = true;
191     emit MintFinished();
192     return true;
193   }
194 
195 }
196 
197 contract BurnableToken is MintableToken {
198   event Burn(address indexed burner, uint256 value);
199 
200   function burn(uint256 _value) external {
201     require(_value <= balances[msg.sender]);
202 
203     balances[msg.sender] = balances[msg.sender].sub(_value);
204     totalSupply_ = totalSupply_.sub(_value);
205     emit Burn(msg.sender, _value);
206     emit Transfer(msg.sender, address(0), _value);
207   }
208 
209 }
210 
211 contract CORToken is BurnableToken {
212   string public constant name = "COR Token";
213   string public constant symbol = "COR";
214   uint8 public constant decimals = 18;
215 
216   function takeOut(ERC20 _token, uint256 _amount) external onlyOwner {
217     _token.transfer(msg.sender, _amount);
218   }
219   
220   function takeOutETH(uint256 _amount) external {
221     (bool success, ) = msg.sender.call.value(_amount)("");
222     require(success, "Transfer failed.");
223   }
224  
225 }