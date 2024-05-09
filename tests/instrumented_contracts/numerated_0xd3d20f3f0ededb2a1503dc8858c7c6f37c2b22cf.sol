1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract Token {
34     uint256 public totalSupply;
35     function balanceOf(address _owner) constant returns (uint256 balance);
36     function transfer(address _to, uint256 _value) returns (bool success);
37     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
38     function approve(address _spender, uint256 _value) returns (bool success);
39     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
40     event Transfer(address indexed _from, address indexed _to, uint256 _value);
41     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
42 }
43 
44 
45 /*  ERC 20 token */
46 contract StandardToken is Token {
47     using SafeMath for uint256;
48     function transfer(address _to, uint256 _value) returns (bool success) {
49       if (balances[msg.sender] >= _value) {
50         balances[msg.sender] = balances[msg.sender].sub(_value);
51         balances[_to] = balances[_to].add(_value);
52         Transfer(msg.sender, _to, _value);
53         return true;
54       } else {
55         return false;
56       }
57     }
58 
59     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
60       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value) {
61         balances[_to] = balances[_to].add(_value);
62         balances[_from] = balances[_from].sub(_value);
63         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
64         Transfer(_from, _to, _value);
65         return true;
66       } else {
67         return false;
68       }
69     }
70 
71     function balanceOf(address _owner) constant returns (uint256 balance) {
72         return balances[_owner];
73     }
74 
75     function approve(address _spender,  uint256 _value) returns (bool success) {
76         allowed[msg.sender][_spender] = _value;
77         Approval(msg.sender, _spender, _value);
78         return true;
79     }
80 
81     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
82       return allowed[_owner][_spender];
83     }
84 
85     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
86       allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
87       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
88       return true;
89     }
90 
91     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
92       uint oldValue = allowed[msg.sender][_spender];
93       if (_subtractedValue > oldValue) {
94         allowed[msg.sender][_spender] = 0;
95       } else {
96         allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
97       }
98       Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
99       return true;
100     }
101 
102     mapping (address => uint256) balances;
103     mapping (address => mapping (address => uint256)) allowed;
104 }
105 
106 contract TestToken is StandardToken {
107     event Mint(address indexed to, uint256 amount);
108 
109     uint256 public constant PRICE = 4000;
110 
111     // metadata
112     string public constant name = "Infinite Test Token";
113     string public constant symbol = "TEST";
114     uint8 public constant decimals = 18;
115     string public version = "1.1";
116 
117     event CreatedToken();
118 
119     function TestToken() {
120         CreatedToken();
121     }
122 
123     function () payable {
124         buyTokens(msg.sender);
125     }
126 
127     function buyTokens(address beneficiary) payable {
128         uint256 tokens = msg.value * PRICE;
129         balances[beneficiary] += tokens;
130         Transfer(0x0, beneficiary, tokens);
131         Mint(beneficiary, tokens);
132         totalSupply += tokens;
133         msg.sender.transfer(msg.value);
134     }
135 }