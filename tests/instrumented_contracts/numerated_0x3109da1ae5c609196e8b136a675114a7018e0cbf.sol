1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
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
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 interface ERC20 {
32   function balanceOf(address who) public view returns (uint256);
33   function transfer(address to, uint256 value) public returns (bool);
34   function allowance(address owner, address spender) public view returns (uint256);
35   function transferFrom(address from, address to, uint256 value) public returns (bool);
36   function approve(address spender, uint256 value) public returns (bool);
37   event Transfer(address indexed from, address indexed to, uint256 value);
38   event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 contract StandardToken is ERC20 {
42   using SafeMath for uint;
43      
44     string internal _name;
45     string internal _symbol;
46     uint8 internal _decimals;
47     uint256 internal _totalSupply;
48 
49     mapping (address => uint256) internal balances;
50     mapping (address => mapping (address => uint256)) internal allowed;
51 
52     constructor(string name, string symbol, uint8 decimals, uint256 totalSupply) public {
53         _symbol = symbol;
54         _name = name;
55         _decimals = decimals;
56         _totalSupply = totalSupply;
57         balances[msg.sender] = totalSupply;
58     }
59 
60     function name()
61         public
62         view
63         returns (string) {
64         return _name;
65     }
66 
67     function symbol()
68         public
69         view
70         returns (string) {
71         return _symbol;
72     }
73 
74     function decimals()
75         public
76         view
77         returns (uint8) {
78         return _decimals;
79     }
80 
81     function totalSupply()
82         public
83         view
84         returns (uint256) {
85         return _totalSupply;
86     }
87 
88    function transfer(address _to, uint256 _value) public returns (bool) {
89      require(_to != address(0));
90      require(_value <= balances[msg.sender]);
91      balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
92      balances[_to] = SafeMath.add(balances[_to], _value);
93      Transfer(msg.sender, _to, _value);
94      return true;
95    }
96 
97   function balanceOf(address _owner) public view returns (uint256 balance) {
98     return balances[_owner];
99    }
100 
101   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
102     require(_to != address(0));
103      require(_value <= balances[_from]);
104      require(_value <= allowed[_from][msg.sender]);
105 
106     balances[_from] = SafeMath.sub(balances[_from], _value);
107      balances[_to] = SafeMath.add(balances[_to], _value);
108      allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
109     Transfer(_from, _to, _value);
110      return true;
111    }
112 
113    function approve(address _spender, uint256 _value) public returns (bool) {
114      allowed[msg.sender][_spender] = _value;
115      Approval(msg.sender, _spender, _value);
116      return true;
117    }
118 
119   function allowance(address _owner, address _spender) public view returns (uint256) {
120      return allowed[_owner][_spender];
121    }
122 
123    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
124      allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
125      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
126      return true;
127    }
128 
129   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
130      uint oldValue = allowed[msg.sender][_spender];
131      if (_subtractedValue > oldValue) {
132        allowed[msg.sender][_spender] = 0;
133      } else {
134        allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
135     }
136      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
137      return true;
138    }
139 
140 }