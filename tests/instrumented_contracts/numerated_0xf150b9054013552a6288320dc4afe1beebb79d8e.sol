1 pragma solidity ^0.4.18;
2 
3 //pragma solidity ^0.4.17;
4 
5 
6 library SafeMath {
7 
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
36 contract ERC20Basic {
37   function totalSupply() public view returns (uint256);
38   function balanceOf(address who) public view returns (uint256);
39   function transfer(address to, uint256 value) public returns (bool);
40   event Transfer(address indexed from, address indexed to, uint256 value);
41 }
42 
43 contract ERC20 is ERC20Basic {
44   function allowance(address owner, address spender) public view returns (uint256);
45   function transferFrom(address from, address to, uint256 value) public returns (bool);
46   function approve(address spender, uint256 value) public returns (bool);
47   event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 contract BasicToken is ERC20Basic {
51   using SafeMath for uint256;
52 
53   mapping(address => uint256) balances;
54 
55   uint256 totalSupply_;
56 
57   function totalSupply() public view returns (uint256) {
58     return totalSupply_;
59   }
60 
61   function transfer(address _to, uint256 _value) public returns (bool) {
62     require(_to != address(0));
63     require(_value <= balances[msg.sender]);
64 
65     // SafeMath.sub will throw if there is not enough balance.
66     balances[msg.sender] = balances[msg.sender].sub(_value);
67     balances[_to] = balances[_to].add(_value);
68     Transfer(msg.sender, _to, _value);
69     return true;
70   }
71 
72   function balanceOf(address _owner) public view returns (uint256 balance) {
73     return balances[_owner];
74   }
75 
76 }
77 
78 contract StandardToken is ERC20, BasicToken {
79 
80   mapping (address => mapping (address => uint256)) internal allowed;
81 
82   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
83     require(_to != address(0));
84     require(_value <= balances[_from]);
85     require(_value <= allowed[_from][msg.sender]);
86 
87     balances[_from] = balances[_from].sub(_value);
88     balances[_to] = balances[_to].add(_value);
89     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
90     Transfer(_from, _to, _value);
91     return true;
92   }
93 
94   function approve(address _spender, uint256 _value) public returns (bool) {
95     allowed[msg.sender][_spender] = _value;
96     Approval(msg.sender, _spender, _value);
97     return true;
98   }
99 
100   function allowance(address _owner, address _spender) public view returns (uint256) {
101     return allowed[_owner][_spender];
102   }
103 
104   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
105     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
106     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
107     return true;
108   }
109 
110   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
111     uint oldValue = allowed[msg.sender][_spender];
112     if (_subtractedValue > oldValue) {
113       allowed[msg.sender][_spender] = 0;
114     } else {
115       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
116     }
117     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
118     return true;
119   }
120 
121 }
122 
123  
124  contract AngelToken is StandardToken {
125  
126      string public constant name = 'AngelToken';
127      string public constant symbol = 'ANGEL';
128      uint8 public constant decimals = 18;
129      uint256 public constant INITIAL_SUPPLY = 5 * 10 ** (9 + uint256(decimals));
130  
131  
132      function AngelToken() public {
133        totalSupply_ = INITIAL_SUPPLY;
134        balances[msg.sender] = INITIAL_SUPPLY;
135      }
136  }