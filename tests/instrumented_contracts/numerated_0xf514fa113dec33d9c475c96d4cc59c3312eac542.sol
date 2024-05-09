1 library SafeMath {
2 
3 
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract ERC20Basic {
34   function totalSupply() public view returns (uint256);
35   function balanceOf(address who) public view returns (uint256);
36   function transfer(address to, uint256 value) public returns (bool);
37   event Transfer(address indexed from, address indexed to, uint256 value);
38 }
39 
40 contract BasicToken is ERC20Basic {
41   using SafeMath for uint256;
42 
43   mapping(address => uint256) balances;
44 
45   uint256 totalSupply_;
46 
47   function totalSupply() public view returns (uint256) {
48     return totalSupply_;
49   }
50 
51 
52   function transfer(address _to, uint256 _value) public returns (bool) {
53     require(_to != address(0));
54     require(_value <= balances[msg.sender]);
55 
56     // SafeMath.sub will throw if there is not enough balance.
57     balances[msg.sender] = balances[msg.sender].sub(_value);
58     balances[_to] = balances[_to].add(_value);
59     Transfer(msg.sender, _to, _value);
60     return true;
61   }
62 
63   function balanceOf(address _owner) public view returns (uint256 balance) {
64     return balances[_owner];
65   }
66 
67 }
68 
69 contract ERC20 is ERC20Basic {
70   function allowance(address owner, address spender) public view returns (uint256);
71   function transferFrom(address from, address to, uint256 value) public returns (bool);
72   function approve(address spender, uint256 value) public returns (bool);
73   event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 contract StandardToken is ERC20, BasicToken {
77 
78   mapping (address => mapping (address => uint256)) internal allowed;
79 
80   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
81     require(_to != address(0));
82     require(_value <= balances[_from]);
83     require(_value <= allowed[_from][msg.sender]);
84 
85     balances[_from] = balances[_from].sub(_value);
86     balances[_to] = balances[_to].add(_value);
87     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
88     Transfer(_from, _to, _value);
89     return true;
90   }
91 
92   function approve(address _spender, uint256 _value) public returns (bool) {
93     allowed[msg.sender][_spender] = _value;
94     Approval(msg.sender, _spender, _value);
95     return true;
96   }
97 
98   function allowance(address _owner, address _spender) public view returns (uint256) {
99     return allowed[_owner][_spender];
100   }
101 
102   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
103     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
104     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
105     return true;
106   }
107 
108   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
109     uint oldValue = allowed[msg.sender][_spender];
110     if (_subtractedValue > oldValue) {
111       allowed[msg.sender][_spender] = 0;
112     } else {
113       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
114     }
115     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
116     return true;
117   }
118 }
119 
120 contract Lemmon is StandardToken {
121   
122     string public name;
123     uint8 public decimals;
124     string public symbol;
125     string public version = '1.0';
126 
127 
128   function Lemmon() public {
129         balances[msg.sender] = 2100000000000000;               // Give the creator all initial tokens
130         totalSupply_ = 2100000000000000;                        // Update total supply
131         name = 'Lemmon';                                   // Set the name for display purposes
132         decimals = 8;                            // Amount of decimals for display purposes
133         symbol = 'LMN';
134   }
135 }