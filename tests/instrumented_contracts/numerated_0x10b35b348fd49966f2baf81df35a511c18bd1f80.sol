1 pragma solidity 0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12   /**
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
14    */
15   function Ownable() public {
16     owner = msg.sender;
17   }
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27   /**
28    * @dev Allows the current owner to transfer control of the contract to a newOwner.
29    * @param newOwner The address to transfer ownership to.
30    */
31   function transferOwnership(address newOwner) public onlyOwner {
32     if (newOwner != address(0)) {
33       owner = newOwner;
34     }
35   }
36 
37 }
38 
39 
40 /**
41  * @title Pausable
42  * @dev Base contract which allows children to implement an emergency stop mechanism.
43  */
44 contract Pausable is Ownable {
45   event Pause();
46   event Unpause();
47 
48   bool public paused = false;
49 
50   function Pausable() public {}
51 
52   /**
53    * @dev modifier to allow actions only when the contract IS paused
54    */
55   modifier whenNotPaused() {
56     require(!paused);
57     _;
58   }
59 
60   /**
61    * @dev modifier to allow actions only when the contract IS NOT paused
62    */
63   modifier whenPaused {
64     require(paused);
65     _;
66   }
67 
68   /**
69    * @dev called by the owner to pause, triggers stopped state
70    */
71   function pause() public onlyOwner whenNotPaused {
72     paused = true;
73     Pause();
74   }
75 
76   /**
77    * @dev called by the owner to unpause, returns to normal state
78    */
79   function unpause() public onlyOwner whenPaused {
80     paused = false;
81     Unpause();
82   }
83 }
84 
85 
86 /**
87  * @title SafeMath
88  * @dev Math operations with safety checks that throw on error
89  */
90 contract SafeMath {
91   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
92     uint256 c = a * b;
93     assert(a == 0 || c / a == b);
94     return c;
95   }
96 
97   function div(uint256 a, uint256 b) internal pure returns (uint256) {
98     uint256 c = a / b;
99     return c;
100   }
101 
102   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
103     assert(b <= a);
104     return a - b;
105   }
106 
107   function add(uint256 a, uint256 b) internal pure returns (uint256) {
108     uint256 c = a + b;
109     assert(c >= a);
110     return c;
111   }
112 }
113 
114 
115 contract Denaro is Pausable, SafeMath {
116 
117   uint256 public totalSupply;
118 
119   mapping(address => uint) public balances;
120   mapping (address => mapping (address => uint)) public allowed;
121 
122   // ERC20 properties
123   string public constant name = "Denaro";
124   string public constant symbol = "DNO";
125   uint8 public constant decimals = 7;
126   
127   // custom properties
128   bool public mintingFinished = false;
129   uint256 public constant MINTING_LIMIT = 100000000 * (uint256(10) ** decimals);
130 
131   event Transfer(address indexed from, address indexed to, uint256 value);
132   event Approval(address indexed owner, address indexed spender, uint256 value);
133 
134   event Mint(address indexed to, uint256 amount);
135   event MintFinished();
136 
137   function Denaro() public {}
138 
139   function() public payable {
140     revert();
141   }
142 
143   function balanceOf(address _owner) public view returns (uint256) {
144     return balances[_owner];
145   }
146 
147   function transfer(address _to, uint _value) public whenNotPaused returns (bool) {
148 
149     balances[msg.sender] = sub(balances[msg.sender], _value);
150     balances[_to] = add(balances[_to], _value);
151 
152     Transfer(msg.sender, _to, _value);
153     return true;
154   }
155 
156   function transferFrom(address _from, address _to, uint _value) public whenNotPaused returns (bool) {
157     var _allowance = allowed[_from][msg.sender];
158 
159     balances[_to] = add(balances[_to], _value);
160     balances[_from] = sub(balances[_from], _value);
161     allowed[_from][msg.sender] = sub(_allowance, _value);
162 
163     Transfer(_from, _to, _value);
164     return true;
165   }
166 
167   function approve(address _spender, uint _value) public whenNotPaused returns (bool) {
168     //https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
170     
171     allowed[msg.sender][_spender] = _value;
172     Approval(msg.sender, _spender, _value);
173     return true;
174   }
175 
176   function allowance(address _owner, address _spender) public view returns (uint256) {
177     return allowed[_owner][_spender];
178   }
179 
180   modifier canMint() {
181     require(!mintingFinished);
182     _;
183   }
184 
185   function mint(address _to, uint256 _amount) public onlyOwner canMint {
186     totalSupply = add(totalSupply, _amount);
187     require(totalSupply <= MINTING_LIMIT);
188     
189     balances[_to] = add(balances[_to], _amount);
190     Mint(_to, _amount);
191   }
192 
193   function finishMinting() public onlyOwner {
194     require(!mintingFinished);
195     mintingFinished = true;
196     MintFinished();
197   }
198 
199 }