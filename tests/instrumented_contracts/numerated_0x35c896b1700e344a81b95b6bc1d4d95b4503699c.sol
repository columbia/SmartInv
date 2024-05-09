1 pragma solidity ^0.4.10;
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
31 
32 interface ERC20 {
33   function balanceOf(address who) public view returns (uint256);
34   function transfer(address to, uint256 value) public returns (bool);
35   function allowance(address owner, address spender) public view returns (uint256);
36   function transferFrom(address from, address to, uint256 value) public returns (bool);
37   function approve(address spender, uint256 value) public returns (bool);
38   event Transfer(address indexed from, address indexed to, uint256 value);
39   event Approval(address indexed owner, address indexed spender, uint256 value);
40 }
41 
42 contract PokerSportsToken is ERC20 {
43   using SafeMath for uint;
44      
45     string internal _name;
46     string internal _symbol;
47     uint8 internal _decimals;
48     uint256 internal _totalSupply;
49 
50     mapping (address => uint256) internal balances;
51     mapping (address => mapping (address => uint256)) internal allowed;
52 
53     function PokerSportsToken(string name, string symbol, uint8 decimals, uint256 totalSupply) public {
54         _symbol = "XPST";
55         _name = "PokerSports Token";
56         _decimals = 18;
57         _totalSupply = 500000000000000000000000000;
58         balances[msg.sender] = 500000000000000000000000000;
59     }
60 
61     function name()
62         public
63         view
64         returns (string) {
65         return _name;
66     }
67 
68     function symbol()
69         public
70         view
71         returns (string) {
72         return _symbol;
73     }
74 
75     function decimals()
76         public
77         view
78         returns (uint8) {
79         return _decimals;
80     }
81 
82     function totalSupply()
83         public
84         view
85         returns (uint256) {
86         return _totalSupply;
87     }
88 
89    function transfer(address _to, uint256 _value) public returns (bool) {
90      require(_to != address(0));
91      require(_value <= balances[msg.sender]);
92      balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
93      balances[_to] = SafeMath.add(balances[_to], _value);
94      Transfer(msg.sender, _to, _value);
95      return true;
96    }
97 
98   function balanceOf(address _owner) public view returns (uint256 balance) {
99     return balances[_owner];
100    }
101 
102   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
103     require(_to != address(0));
104      require(_value <= balances[_from]);
105      require(_value <= allowed[_from][msg.sender]);
106 
107     balances[_from] = SafeMath.sub(balances[_from], _value);
108      balances[_to] = SafeMath.add(balances[_to], _value);
109      allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
110     Transfer(_from, _to, _value);
111      return true;
112    }
113 
114    function approve(address _spender, uint256 _value) public returns (bool) {
115      allowed[msg.sender][_spender] = _value;
116      Approval(msg.sender, _spender, _value);
117      return true;
118    }
119 
120   function allowance(address _owner, address _spender) public view returns (uint256) {
121      return allowed[_owner][_spender];
122    }
123 
124    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
125      allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
126      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
127      return true;
128    }
129 
130   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
131      uint oldValue = allowed[msg.sender][_spender];
132      if (_subtractedValue > oldValue) {
133        allowed[msg.sender][_spender] = 0;
134      } else {
135        allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
136     }
137      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
138      return true;
139    }
140 
141 }