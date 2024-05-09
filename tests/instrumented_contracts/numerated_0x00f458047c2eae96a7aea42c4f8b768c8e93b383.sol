1 pragma solidity 0.4.24;
2 
3 library SafeMath 
4 {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     uint256 c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function div(uint256 a, uint256 b) internal pure returns (uint256) {
12     // assert(b > 0); // Solidity automatically throws when dividing by 0
13     uint256 c = a / b;
14     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract ERC20Basic 
31 {
32   uint256 public totalSupply;
33   function balanceOf(address who) public constant returns (uint256);
34   function transfer(address to, uint256 value) public returns (bool);
35   event Transfer(address indexed from, address indexed to, uint256 value);
36 }
37 
38 contract ERC20 is ERC20Basic 
39 {
40   function allowance(address owner, address spender) public constant returns (uint256);
41   function transferFrom(address from, address to, uint256 value) public returns (bool);
42   function approve(address spender, uint256 value) public returns (bool);
43   event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 contract BasicToken is ERC20Basic 
47 {
48   using SafeMath for uint256;
49 
50   mapping(address => uint256) balances;
51 
52   function transfer(address _to, uint256 _value) public returns (bool) {
53     require(_to != address(0));
54     require(_value <= balances[msg.sender]);
55 
56     // SafeMath.sub will throw if there is not enough balance.
57     balances[msg.sender] = balances[msg.sender].sub(_value);
58     balances[_to] = balances[_to].add(_value);
59     emit Transfer(msg.sender, _to, _value);
60     return true;
61   }
62 
63   function balanceOf(address _owner) public constant returns (uint256 balance) {
64     return balances[_owner];
65   }
66 
67 }
68 
69 contract StandardToken is ERC20, BasicToken 
70 {
71 
72   mapping (address => mapping (address => uint256)) internal allowed;
73 
74   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
75     require(_to != address(0));
76     require(_value <= balances[_from]);
77     require(_value <= allowed[_from][msg.sender]);
78 
79     balances[_from] = balances[_from].sub(_value);
80     balances[_to] = balances[_to].add(_value);
81     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
82     emit Transfer(_from, _to, _value);
83     return true;
84   }
85 
86   function approve(address _spender, uint256 _value) public returns (bool) {
87     allowed[msg.sender][_spender] = _value;
88     emit Approval(msg.sender, _spender, _value);
89     return true;
90   }
91 
92   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
93     return allowed[_owner][_spender];
94   }
95 
96   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
97     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
98     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
99     return true;
100   }
101 
102   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
103     uint oldValue = allowed[msg.sender][_spender];
104     if (_subtractedValue > oldValue) {
105       allowed[msg.sender][_spender] = 0;
106     } else {
107       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
108     }
109     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
110     return true;
111   }
112 
113 }
114 
115 contract Ownable 
116 {
117   address public owner;
118 
119   constructor() public {
120     owner = msg.sender;
121   }
122 
123   modifier onlyOwner() {
124     require(msg.sender == owner);
125     _;
126   }
127 
128   function transferOwnership(address newOwner) public onlyOwner {
129     require(newOwner != address(0)); 
130     owner = newOwner;
131   }
132 }
133 
134 contract VIRToken is StandardToken, Ownable
135 {
136     string public symbol = "VIR";
137     string public name = "Virtual Reality Token";
138 
139     uint public decimals = 18;
140 
141     uint private constant initialSupply = 25e9 * 1e18; // 25 billions + 18 decimals
142 
143     constructor() public
144     {
145         owner = msg.sender;
146         totalSupply = initialSupply;
147         balances[owner] = initialSupply;
148     }
149 }