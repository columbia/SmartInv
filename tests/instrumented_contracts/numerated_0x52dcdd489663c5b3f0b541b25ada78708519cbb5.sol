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
32 
33 interface ERC20 {
34   function balanceOf(address who) public view returns (uint256);
35   function transfer(address to, uint256 value) public returns (bool);
36   function allowance(address owner, address spender) public view returns (uint256);
37   function transferFrom(address from, address to, uint256 value) public returns (bool);
38   function approve(address spender, uint256 value) public returns (bool);
39   event Transfer(address indexed from, address indexed to, uint256 value);
40   event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 
44 
45 contract DetaToken is ERC20 {
46   using SafeMath for uint;
47      
48     string internal _name;
49     string internal _symbol;
50     uint8 internal _decimals;
51     uint256 internal _totalSupply;
52 
53     mapping (address => uint256) internal balances;
54     mapping (address => mapping (address => uint256)) internal allowed;
55 
56     function DetaToken(string name, string symbol, uint8 decimals, uint256 totalSupply) public {
57         _symbol = symbol;
58         _name = name;
59         _decimals = decimals;
60         _totalSupply = totalSupply;
61         balances[msg.sender] = totalSupply;
62     }
63 
64     function name()
65         public
66         view
67         returns (string) {
68         return _name;
69     }
70 
71     function symbol()
72         public
73         view
74         returns (string) {
75         return _symbol;
76     }
77 
78     function decimals()
79         public
80         view
81         returns (uint8) {
82         return _decimals;
83     }
84 
85     function totalSupply()
86         public
87         view
88         returns (uint256) {
89         return _totalSupply;
90     }
91 
92    function transfer(address _to, uint256 _value) public returns (bool) {
93      require(_to != address(0));
94      require(_value <= balances[msg.sender]);
95      balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
96      balances[_to] = SafeMath.add(balances[_to], _value);
97      Transfer(msg.sender, _to, _value);
98      return true;
99    }
100 
101   function balanceOf(address _owner) public view returns (uint256 balance) {
102     return balances[_owner];
103    }
104 
105   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
106     require(_to != address(0));
107      require(_value <= balances[_from]);
108      require(_value <= allowed[_from][msg.sender]);
109 
110     balances[_from] = SafeMath.sub(balances[_from], _value);
111      balances[_to] = SafeMath.add(balances[_to], _value);
112      allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
113     Transfer(_from, _to, _value);
114      return true;
115    }
116 
117    function approve(address _spender, uint256 _value) public returns (bool) {
118      allowed[msg.sender][_spender] = _value;
119      Approval(msg.sender, _spender, _value);
120      return true;
121    }
122 
123   function allowance(address _owner, address _spender) public view returns (uint256) {
124      return allowed[_owner][_spender];
125    }
126 
127    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
128      allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
129      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
130      return true;
131    }
132 
133   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
134      uint oldValue = allowed[msg.sender][_spender];
135      if (_subtractedValue > oldValue) {
136        allowed[msg.sender][_spender] = 0;
137      } else {
138        allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
139     }
140      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
141      return true;
142    }
143 
144 }