1 pragma solidity ^0.4.13;
2 
3 interface ERC20 {
4     // Get the total token supply
5     function totalSupply() constant returns (uint totalSupply);
6     // Get the account balance of another account with address _owner
7     function balanceOf(address _owner) constant returns (uint balance);
8     // Send _value amount of tokens to address _to
9     function transfer(address _to, uint _value) returns (bool success);
10     // Send _value amount of tokens from address _from to address _to
11     function transferFrom(address _from, address _to, uint _value) returns (bool success);
12     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
13     // If this function is called again it overwrites the current allowance with _value.
14     // this function is required for some DEX functionality
15     function approve(address _spender, uint _value) returns (bool success);
16     // Returns the amount which _spender is still allowed to withdraw from _owner
17     function allowance(address _owner, address _spender) constant returns (uint remaining);
18     // Triggered when tokens are transferred.
19     event Transfer(address indexed _from, address indexed _to, uint _value);
20     // Triggered whenever approve(address _spender, uint256 _value) is called.
21     event Approval(address indexed _owner, address indexed _spender, uint _value);
22 }
23 
24 contract NewPiedPiperCoin is ERC20 {
25   using SafeMath for uint;
26      
27     string internal _name;
28     string internal _symbol;
29     uint8 internal _decimals;
30     uint256 internal _totalSupply;
31 
32     mapping (address => uint256) internal balances;
33     mapping (address => mapping (address => uint256)) internal allowed;
34 
35     function NewPiedPiperCoin(string name, string symbol, uint8 decimals, uint256 totalSupply) public {
36         _symbol = symbol;
37         _name = name;
38         _decimals = decimals;
39         _totalSupply = totalSupply;
40         balances[msg.sender] = totalSupply;
41     }
42 
43     function name()
44         public
45         view
46         returns (string) {
47         return _name;
48     }
49 
50     function symbol()
51         public
52         view
53         returns (string) {
54         return _symbol;
55     }
56 
57     function decimals()
58         public
59         view
60         returns (uint8) {
61         return _decimals;
62     }
63 
64     function totalSupply()
65         public
66         view
67         returns (uint256) {
68         return _totalSupply;
69     }
70 
71    function transfer(address _to, uint256 _value) public returns (bool) {
72      require(_to != address(0));
73      require(_value <= balances[msg.sender]);
74      balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
75      balances[_to] = SafeMath.add(balances[_to], _value);
76      Transfer(msg.sender, _to, _value);
77      return true;
78    }
79 
80   function balanceOf(address _owner) public view returns (uint256 balance) {
81     return balances[_owner];
82    }
83 
84   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
85     require(_to != address(0));
86      require(_value <= balances[_from]);
87      require(_value <= allowed[_from][msg.sender]);
88 
89     balances[_from] = SafeMath.sub(balances[_from], _value);
90      balances[_to] = SafeMath.add(balances[_to], _value);
91      allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
92     Transfer(_from, _to, _value);
93      return true;
94    }
95 
96    function approve(address _spender, uint256 _value) public returns (bool) {
97      allowed[msg.sender][_spender] = _value;
98      Approval(msg.sender, _spender, _value);
99      return true;
100    }
101 
102   function allowance(address _owner, address _spender) public view returns (uint256) {
103      return allowed[_owner][_spender];
104    }
105 
106    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
107      allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
108      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
109      return true;
110    }
111 
112   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
113      uint oldValue = allowed[msg.sender][_spender];
114      if (_subtractedValue > oldValue) {
115        allowed[msg.sender][_spender] = 0;
116      } else {
117        allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
118     }
119      Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
120      return true;
121    }
122 
123 }
124 
125 library SafeMath {
126   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
127     uint256 c = a * b;
128     assert(a == 0 || c / a == b);
129     return c;
130   }
131 
132   function div(uint256 a, uint256 b) internal constant returns (uint256) {
133     assert(b > 0); // Solidity automatically throws when dividing by 0
134     uint256 c = a / b;
135     assert(a == b * c + a % b); // There is no case in which this doesn't hold
136     return c;
137   }
138 
139   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
140     assert(b <= a);
141     return a - b;
142   }
143 
144   function add(uint256 a, uint256 b) internal constant returns (uint256) {
145     uint256 c = a + b;
146     assert(c >= a);
147     return c;
148   }
149 }