1 pragma solidity ^0.4.20;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 /**
45  * @title Pausable
46  * @dev Base contract which allows children to implement an emergency stop mechanism.
47  */
48 contract Pausable is Ownable {
49   event Pause();
50   event Unpause();
51 
52   bool public paused = false;
53 
54 
55   /**
56    * @dev Modifier to make a function callable only when the contract is not paused.
57    */
58   modifier whenNotPaused() {
59     require(!paused);
60     _;
61   }
62 
63   /**
64    * @dev Modifier to make a function callable only when the contract is paused.
65    */
66   modifier whenPaused() {
67     require(paused);
68     _;
69   }
70 
71   /**
72    * @dev called by the owner to pause, triggers stopped state
73    */
74   function pause() onlyOwner whenNotPaused public {
75     paused = true;
76     Pause();
77   }
78 
79   /**
80    * @dev called by the owner to unpause, returns to normal state
81    */
82   function unpause() onlyOwner whenPaused public {
83     paused = false;
84     Unpause();
85   }
86 }
87 
88 library SafeMath {
89   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
90     if (a == 0) {
91       return 0;
92     }
93     uint256 c = a * b;
94     assert(c / a == b);
95     return c;
96   }
97 
98   function div(uint256 a, uint256 b) internal pure returns (uint256) {
99     // assert(b > 0); // Solidity automatically throws when dividing by 0
100     uint256 c = a / b;
101     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
102     return c;
103   }
104 
105   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106     assert(b <= a);
107     return a - b;
108   }
109 
110   function add(uint256 a, uint256 b) internal pure returns (uint256) {
111     uint256 c = a + b;
112     assert(c >= a);
113     return c;
114   }
115 }
116 contract ERC20 {
117   uint256 public totalSupply;
118   function balanceOf(address who) public view returns (uint256);
119   function transfer(address to, uint256 value) public returns (bool);
120   event Transfer(address indexed from, address indexed to, uint256 value);
121   function allowance(address owner, address spender) public view returns (uint256);
122   function transferFrom(address from, address to, uint256 value) public returns (bool);
123   function approve(address spender, uint256 value) public returns (bool);
124   event Approval(address indexed owner, address indexed spender, uint256 value);
125 }
126 
127 contract DetailedERC20 is ERC20 {
128   string public name;
129   string public symbol;
130   uint8 public decimals;
131 
132   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
133     name = _name;
134     symbol = _symbol;
135     decimals = _decimals;
136   }
137 }
138 
139 contract Micro_Network is Pausable, DetailedERC20 {
140   using SafeMath for uint256;
141 
142   mapping(address => uint256) balances;
143   mapping (address => mapping (address => uint256)) internal allowed;
144 
145   function Micro_Network() DetailedERC20("Micro Network", "WWW", 8) public {
146     totalSupply = 1000000000 * 10 ** uint256(decimals);
147     balances[msg.sender] = totalSupply;
148   }
149 
150 
151   function transfer(address _to, uint256 _value)  whenNotPaused public returns (bool) {
152     require(_to != address(0));
153     require(_value <= balances[msg.sender]);
154 
155     balances[msg.sender] = balances[msg.sender].sub(_value);
156     balances[_to] = balances[_to].add(_value);
157     Transfer(msg.sender, _to, _value);
158     return true;
159   }
160 
161 
162   function balanceOf(address _owner) public view returns (uint256 balance) {
163     return balances[_owner];
164   }
165 
166 
167   function transferFrom(address _from, address _to, uint256 _value) public  whenNotPaused returns (bool) {
168     require(_to != address(0));
169     require(_value <= balances[_from]);
170     require(_value <= allowed[_from][msg.sender]);
171 
172     balances[_from] = balances[_from].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
175     Transfer(_from, _to, _value);
176     return true;
177   }
178 
179   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
180     allowed[msg.sender][_spender] = _value;
181     Approval(msg.sender, _spender, _value);
182     return true;
183   }
184 
185   function allowance(address _owner, address _spender) public view returns (uint256) {
186     return allowed[_owner][_spender];
187   }
188 
189   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool) {
190     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
191     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
192     return true;
193   }
194 
195   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool) {
196     uint oldValue = allowed[msg.sender][_spender];
197     if (_subtractedValue > oldValue) {
198       allowed[msg.sender][_spender] = 0;
199     } else {
200       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
201     }
202     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
203     return true;
204   }
205 }