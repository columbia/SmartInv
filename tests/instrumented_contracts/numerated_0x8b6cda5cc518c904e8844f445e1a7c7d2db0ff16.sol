1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 interface ERC20 {
37   function balanceOf(address who) public view returns (uint256);
38   function transfer(address to, uint256 value) public returns (bool);
39   function allowance(address owner, address spender) public view returns (uint256);
40   function transferFrom(address from, address to, uint256 value) public returns (bool);
41   function approve(address spender, uint256 value) public returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43   event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 contract SFCapitalToken is ERC20 {
47   using SafeMath for uint;
48      
49     string internal _name;
50     string internal _symbol;
51     uint8 internal _decimals;
52     uint256 internal _totalSupply;
53 
54     mapping (address => uint256) internal balances;
55     mapping (address => mapping (address => uint256)) internal allowed;
56 
57     function SFCapitalToken(string name, string symbol, uint8 decimals, uint256 totalSupply) public {
58         _symbol = symbol;
59         _name = name;
60         _decimals = decimals;
61         _totalSupply = totalSupply;
62         balances[msg.sender] = totalSupply;
63     }
64 
65     function name()
66         public
67         view
68         returns (string) {
69         return _name;
70     }
71 
72     function symbol()
73         public
74         view
75         returns (string) {
76         return _symbol;
77     }
78 
79     function decimals()
80         public
81         view
82         returns (uint8) {
83         return _decimals;
84     }
85 
86     function totalSupply()
87         public
88         view
89         returns (uint256) {
90         return _totalSupply;
91     }
92 
93    function transfer(address _to, uint256 _value) public returns (bool) {
94      require(_to != address(0));
95      require(_value <= balances[msg.sender]);
96      balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
97      balances[_to] = SafeMath.add(balances[_to], _value);
98      Transfer(msg.sender, _to, _value);
99      return true;
100    }
101 
102   function balanceOf(address _owner) public view returns (uint256 balance) {
103     return balances[_owner];
104    }
105 
106   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
107     require(_to != address(0));
108      require(_value <= balances[_from]);
109      require(_value <= allowed[_from][msg.sender]);
110 
111     balances[_from] = SafeMath.sub(balances[_from], _value);
112      balances[_to] = SafeMath.add(balances[_to], _value);
113      allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
114     Transfer(_from, _to, _value);
115      return true;
116    }
117 
118    function approve(address _spender, uint256 _value) public returns (bool) {
119      allowed[msg.sender][_spender] = _value;
120      Approval(msg.sender, _spender, _value);
121      return true;
122    }
123 
124   function allowance(address _owner, address _spender) public view returns (uint256) {
125      return allowed[_owner][_spender];
126    }
127 
128    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
129      allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
130      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
131      return true;
132    }
133 
134   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
135      uint oldValue = allowed[msg.sender][_spender];
136      if (_subtractedValue > oldValue) {
137        allowed[msg.sender][_spender] = 0;
138      } else {
139        allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
140     }
141      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
142      return true;
143    }
144 }