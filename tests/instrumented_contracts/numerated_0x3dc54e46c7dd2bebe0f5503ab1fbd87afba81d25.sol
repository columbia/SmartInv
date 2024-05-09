1 pragma solidity ^0.4.10;
2 
3 interface ERC20 {
4   function balanceOf(address who) public view returns (uint256);
5   function transfer(address to, uint256 value) public returns (bool);
6   function allowance(address owner, address spender) public view returns (uint256);
7   function transferFrom(address from, address to, uint256 value) public returns (bool);
8   function approve(address spender, uint256 value) public returns (bool);
9   event Transfer(address indexed from, address indexed to, uint256 value);
10   event Approval(address indexed owner, address indexed spender, uint256 value);
11 }
12 
13 pragma solidity ^0.4.10;
14 
15 library SafeMath {
16   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17     if (a == 0) {
18       return 0;
19     }
20     uint256 c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   function add(uint256 a, uint256 b) internal pure returns (uint256) {
38     uint256 c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 }
43 
44 pragma solidity ^0.4.10;
45 
46 
47 contract LiftUpVets is ERC20 {
48   using SafeMath for uint;
49      
50     string internal _name;
51     string internal _symbol;
52     uint8 internal _decimals;
53     uint256 internal _totalSupply;
54 
55     mapping (address => uint256) internal balances;
56     mapping (address => mapping (address => uint256)) internal allowed;
57 
58     function LiftUpVets(string name, string symbol, uint8 decimals, uint256 totalSupply) public {
59         _symbol = symbol;
60         _name = name;
61         _decimals = decimals;
62         _totalSupply = totalSupply;
63         balances[msg.sender] = totalSupply;
64     }
65 
66     function name()
67         public
68         view
69         returns (string) {
70         return _name;
71     }
72 
73     function symbol()
74         public
75         view
76         returns (string) {
77         return _symbol;
78     }
79 
80     function decimals()
81         public
82         view
83         returns (uint8) {
84         return _decimals;
85     }
86 
87     function totalSupply()
88         public
89         view
90         returns (uint256) {
91         return _totalSupply;
92     }
93 
94    function transfer(address _to, uint256 _value) public returns (bool) {
95      require(_to != address(0));
96      require(_value <= balances[msg.sender]);
97      balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
98      balances[_to] = SafeMath.add(balances[_to], _value);
99      Transfer(msg.sender, _to, _value);
100      return true;
101    }
102 
103   function balanceOf(address _owner) public view returns (uint256 balance) {
104     return balances[_owner];
105    }
106 
107   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
108     require(_to != address(0));
109      require(_value <= balances[_from]);
110      require(_value <= allowed[_from][msg.sender]);
111 
112     balances[_from] = SafeMath.sub(balances[_from], _value);
113      balances[_to] = SafeMath.add(balances[_to], _value);
114      allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
115     Transfer(_from, _to, _value);
116      return true;
117    }
118 
119    function approve(address _spender, uint256 _value) public returns (bool) {
120      allowed[msg.sender][_spender] = _value;
121      Approval(msg.sender, _spender, _value);
122      return true;
123    }
124 
125   function allowance(address _owner, address _spender) public view returns (uint256) {
126      return allowed[_owner][_spender];
127    }
128 
129    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
130      allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
131      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
132      return true;
133    }
134 
135   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
136      uint oldValue = allowed[msg.sender][_spender];
137      if (_subtractedValue > oldValue) {
138        allowed[msg.sender][_spender] = 0;
139      } else {
140        allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
141     }
142      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
143      return true;
144    }
145 
146 }