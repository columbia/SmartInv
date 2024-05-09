1 contract ERC20Basic {
2   uint256 public totalSupply;
3   function balanceOf(address who) constant returns (uint256);
4   function transfer(address to, uint256 value) returns (bool);
5   event Transfer(address indexed from, address indexed to, uint256 value);
6 }
7 
8 contract ERC20 is ERC20Basic {
9   function allowance(address owner, address spender) constant returns (uint256);
10   function transferFrom(address from, address to, uint256 value) returns (bool);
11   function approve(address spender, uint256 value) returns (bool);
12   event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 library SafeMath {
16   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
17     uint256 c = a * b;
18     assert(a == 0 || c / a == b);
19     return c;
20   }
21 
22   function div(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a / b;
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal constant returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 
39 contract BasicToken is ERC20Basic {
40   using SafeMath for uint256;
41 
42   mapping(address => uint256) balances;
43 
44   function transfer(address _to, uint256 _value) returns (bool) {
45     require(_to != address(0));
46 
47     // SafeMath.sub will throw if there is not enough balance.
48     balances[msg.sender] = balances[msg.sender].sub(_value);
49     balances[_to] = balances[_to].add(_value);
50     Transfer(msg.sender, _to, _value);
51     return true;
52   }
53 
54   function balanceOf(address _owner) constant returns (uint256 balance) {
55     return balances[_owner];
56   }
57 }
58 
59 contract Ownable {
60     
61   address public owner;
62 
63   function Ownable() {
64     owner = msg.sender;
65   }
66 
67   modifier onlyOwner() {
68     require(msg.sender == owner);
69     _;
70   }
71 
72   function transferOwnership(address newOwner) onlyOwner {
73     require(newOwner != address(0));      
74     owner = newOwner;
75   }
76 }
77 
78 contract StandardToken is ERC20, BasicToken {
79 
80   mapping (address => mapping (address => uint256)) allowed;
81 
82   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
83     require(_to != address(0));
84 
85     var _allowance = allowed[_from][msg.sender];
86 
87     balances[_from] = balances[_from].sub(_value);
88     balances[_to] = balances[_to].add(_value);
89     allowed[_from][msg.sender] = _allowance.sub(_value);
90     Transfer(_from, _to, _value);
91     return true;
92   }
93 
94   function approve(address _spender, uint256 _value) returns (bool) {
95     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
96 
97     allowed[msg.sender][_spender] = _value;
98     Approval(msg.sender, _spender, _value);
99     return true;
100   }
101 
102   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
103     return allowed[_owner][_spender];
104   }
105   
106   function increaseApproval (address _spender, uint _addedValue) returns (bool success) {
107     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
108     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
109     return true;
110   }
111 
112   function decreaseApproval (address _spender, uint _subtractedValue) returns (bool success) {
113     uint oldValue = allowed[msg.sender][_spender];
114     if (_subtractedValue > oldValue) {
115       allowed[msg.sender][_spender] = 0;
116     } else {
117       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
118     }
119     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
120     return true;
121   }
122 }
123 
124 contract MoncryptToken is StandardToken, Ownable {
125     
126     string public constant name = "MONCRYPT Token";
127     
128     string public constant symbol = "MON";
129     
130     uint32 public constant decimals = 8;
131     
132     uint256 _totalSupply = 3000000000000000;
133 
134     function MoncryptToken() {
135         balances[owner] = _totalSupply;
136         totalSupply = _totalSupply;
137     }
138 }