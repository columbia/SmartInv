1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-27
3 */
4 
5 pragma solidity ^0.5.2;
6 
7 contract ERC20 {
8   function balanceOf(address who) public view returns (uint256);
9   function allowance(address owner, address spender) public view returns (uint256);
10   function transferFrom(address from, address to, uint256 value) public returns (bool);
11   function approve(address spender, uint256 value) public returns (bool);
12   function transfer(address to, uint value) public returns(bool);
13   event Transfer(address indexed from, address indexed to, uint value);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 
18 contract Bet_Chips is ERC20 {
19     
20     string internal _name;
21     string internal _symbol;
22     uint8 internal _decimals;
23     uint256 internal _totalSupply;
24 
25     mapping (address => uint256) internal balances;
26     mapping (address => mapping (address => uint256)) internal allowed;
27 
28     constructor() public {
29         _symbol = "BetC";  
30         _name = "Bet Chips"; 
31         _decimals = 4; 
32         _totalSupply = 900000000* 10**uint(_decimals);
33         balances[msg.sender] = _totalSupply;
34     }
35     
36     function mul(uint256 a, uint256 b) internal pure returns (uint256) 
37     {
38         if (a == 0) {
39         return 0;}
40         uint256 c = a * b;
41         assert(c / a == b);
42         return c;
43     }
44 
45     function div(uint256 a, uint256 b) internal pure returns (uint256) 
46     {
47         uint256 c = a / b;
48         return c;
49     }
50 
51     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
52     {
53         assert(b <= a);
54         return a - b;
55     }
56 
57     function add(uint256 a, uint256 b) internal pure returns (uint256) 
58     {
59         uint256 c = a + b;
60         assert(c >= a);
61         return c;
62     }
63 
64     function name() public view returns (string memory) 
65     {
66         return _name;
67     }
68 
69     function symbol() public view returns (string memory) 
70     {
71         return _symbol;
72     }
73 
74     function decimals() public view returns (uint8) 
75     {
76         return _decimals;
77     }
78 
79     function totalSupply() public view returns (uint256) 
80     {
81         return _totalSupply;
82     }
83 
84    function transfer(address _to, uint256 _value) public returns (bool) {
85      require(_to != address(0));
86      require(_value <= balances[msg.sender]);
87      balances[msg.sender] = sub(balances[msg.sender], _value);
88      balances[_to] = add(balances[_to], _value);
89      emit ERC20.Transfer(msg.sender, _to, _value);
90      return true;
91    }
92 
93   function balanceOf(address _owner) public view returns (uint256 balance) {
94     return balances[_owner];
95    }
96 
97   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
98      require(_to != address(0));
99      require(_value <= balances[_from]);
100      require(_value <= allowed[_from][msg.sender]);
101 
102     balances[_from] = sub(balances[_from], _value);
103     balances[_to] = add(balances[_to], _value);
104     allowed[_from][msg.sender] = sub(allowed[_from][msg.sender], _value);
105     emit ERC20.Transfer(_from, _to, _value);
106      return true;
107    }
108 
109    function approve(address _spender, uint256 _value) public returns (bool) {
110      allowed[msg.sender][_spender] = _value;
111     emit ERC20.Approval(msg.sender, _spender, _value);
112      return true;
113    }
114 
115   function allowance(address _owner, address _spender) public view returns (uint256) {
116      return allowed[_owner][_spender];
117    }
118 
119    function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
120      allowed[msg.sender][_spender] = add(allowed[msg.sender][_spender], _addedValue);
121     emit ERC20.Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
122      return true;
123    }
124 
125   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
126      uint oldValue = allowed[msg.sender][_spender];
127      if (_subtractedValue > oldValue) {
128        allowed[msg.sender][_spender] = 0;
129      } else {
130        allowed[msg.sender][_spender] = sub(oldValue, _subtractedValue);
131     }
132      emit ERC20.Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
133      return true;
134    }
135 
136 }