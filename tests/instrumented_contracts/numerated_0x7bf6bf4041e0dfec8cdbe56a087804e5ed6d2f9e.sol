1 pragma solidity ^0.5.2;
2 contract Ownable {
3   address public owner;
4   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
5   constructor() public {
6     owner = msg.sender;
7   }
8   modifier KingPrerogative() {
9     require(msg.sender == owner);
10     _;
11   }
12   function transferOwnership(address newOwner) public KingPrerogative {
13     require(newOwner != address(0));
14     emit OwnershipTransferred(owner, newOwner);
15     owner = newOwner;
16   }
17 }
18 library SafeMath {
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     if (a == 0) {
21       return 0;
22     }
23     uint256 c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b > 0); 
29     uint256 c = a / b;
30     assert(a == b * c + a % b);
31     return c;
32   }
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37   function add(uint256 a, uint256 b) internal pure returns (uint256) {
38     uint256 c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 }
43 contract ERC20Basic {
44   uint256 public totalSupply;
45   function balanceOf(address who) public view returns (uint256);
46   function transfer(address to, uint256 value) public returns (bool);
47   event Transfer(address indexed from, address indexed to, uint256 value);
48 }
49 contract BasicToken is ERC20Basic {
50   using SafeMath for uint256;
51   mapping(address => uint256) balances;
52   function transfer(address _to, uint256 _value) public returns (bool) {
53     require(_to != address(0));
54     require(_value <= balances[msg.sender]);
55     // SafeMath.sub will throw if there is not enough balance.
56     balances[msg.sender] = balances[msg.sender].sub(_value);
57     balances[_to] = balances[_to].add(_value);
58     emit Transfer(msg.sender, _to, _value);
59     return true;
60   }
61   function balanceOf(address _owner) public view returns (uint256 balance) {
62     return balances[_owner];
63   }
64 
65 }
66 contract ERC20 is ERC20Basic {
67   function allowance(address owner, address spender) public view returns (uint256);
68   function transferFrom(address from, address to, uint256 value) public returns (bool);
69   function approve(address spender, uint256 value) public returns (bool);
70   event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 contract StandardToken is ERC20, BasicToken {
73   mapping (address => mapping (address => uint256)) internal allowed;
74   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
75     require(_to != address(0));
76     require(_value <= balances[_from]);
77     require(_value <= allowed[_from][msg.sender]);
78     balances[_from] = balances[_from].sub(_value);
79     balances[_to] = balances[_to].add(_value);
80     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
81     emit Transfer(_from, _to, _value);
82     return true;
83   }
84   function approve(address _spender, uint256 _value) public returns (bool) {
85     allowed[msg.sender][_spender] = _value;
86     emit Approval(msg.sender, _spender, _value);
87     return true;
88   }
89   function allowance(address _owner, address _spender) public view returns (uint256) {
90     return allowed[_owner][_spender];
91   }
92   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
93     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
94     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
95     return true;
96   }
97   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
98     uint oldValue = allowed[msg.sender][_spender];
99     if (_subtractedValue > oldValue) {
100       allowed[msg.sender][_spender] = 0;
101     } else {
102       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
103     }
104     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
105     return true;
106   }
107 }
108 contract MintableToken is StandardToken, Ownable {
109   event Mint(address indexed to, uint256 amount);
110   event MintFinished();
111   bool public mintingFinished = false;
112   modifier canMint() {
113     require(!mintingFinished);
114     _;
115   }
116   function mint(address _to, uint256 _amount) KingPrerogative canMint public returns (bool) {
117     totalSupply = totalSupply.add(_amount);
118     balances[_to] = balances[_to].add(_amount);
119     emit Mint(_to, _amount);
120     emit Transfer(address(0), _to, _amount);
121     return true;
122   }
123   function finishMinting() KingPrerogative canMint public returns (bool) {
124     mintingFinished = true;
125     emit MintFinished();
126     return true;
127   }
128 }
129 contract Pausable is Ownable {
130   event Pause();
131   event Unpause();
132   bool public paused = false;
133   modifier whenNotPaused() {
134     require(!paused);
135     _;
136   }
137   modifier whenPaused() {
138     require(paused);
139     _;
140   }
141   function pause() KingPrerogative whenNotPaused public {
142     paused = true;
143     emit Pause();
144   }
145   function unpause() KingPrerogative whenPaused public {
146     paused = false;
147     emit Unpause();
148   }
149 }
150 contract PausableToken is StandardToken, Pausable {
151   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
152     return super.transfer(_to, _value);
153   }
154   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
155     return super.transferFrom(_from, _to, _value);
156   }
157   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
158     return super.approve(_spender, _value);
159   }
160   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
161     return super.increaseApproval(_spender, _addedValue);
162   }
163   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
164     return super.decreaseApproval(_spender, _subtractedValue);
165   }
166 }
167 contract JeromesBTC is PausableToken, MintableToken {
168     string public constant name = "BITCOIN FUTURE FROM DESK DELTA ONE";
169     string public constant symbol = "BTC";
170     uint8 public constant decimals = 18;
171 }
172 // JEROME STRIKES BACK MOTHERFUCKERS