1 /**
2  *Submitted for verification at Etherscan.io on 2019-08-29
3 */
4 
5 pragma solidity ^0.5.11;
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
17 library SafeMath{
18       function mul(uint256 a, uint256 b) internal pure returns (uint256) 
19     {
20         if (a == 0) {
21         return 0;}
22         uint256 c = a * b;
23         assert(c / a == b);
24         return c;
25     }
26 
27     function div(uint256 a, uint256 b) internal pure returns (uint256) 
28     {
29         uint256 c = a / b;
30         return c;
31     }
32 
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
34     {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     function add(uint256 a, uint256 b) internal pure returns (uint256) 
40     {
41         uint256 c = a + b;
42         assert(c >= a);
43         return c;
44     }
45 
46 }
47 contract Vyvo is ERC20 {
48     
49         using SafeMath for uint256;
50 
51     string internal _name;
52     string internal _symbol;
53     uint8 internal _decimals;
54     uint256 internal _totalSupply;
55     
56     uint256 internal _freezebalance;
57     uint256 internal _unfreezebalance;
58     address internal  _admin;
59 
60     mapping (address => uint256) internal balances;
61     mapping (address => mapping (address => uint256)) internal allowed;
62 
63     constructor() public {
64         
65         _admin = msg.sender;
66         _symbol = "VYVO";  
67         _name = "Vyvo"; 
68         _decimals = 8; 
69         _totalSupply = 2000000000* 10**uint(_decimals);
70         _freezebalance = 100000;
71         _unfreezebalance = _totalSupply - _freezebalance;
72         balances[msg.sender] = _freezebalance;
73     }
74     
75     modifier ownership()  {
76     require(msg.sender == _admin);
77         _;
78     }
79     
80   
81     function name() public view returns (string memory) 
82     {
83         return _name;
84     }
85 
86     function symbol() public view returns (string memory) 
87     {
88         return _symbol;
89     }
90 
91     function decimals() public view returns (uint8) 
92     {
93         return _decimals;
94     }
95 
96     function totalSupply() public view returns (uint256) 
97     {
98         return _totalSupply;
99     }
100 
101    function transfer(address _to, uint256 _value) public returns (bool) {
102      require(_to != address(0));
103      require(_value <= balances[msg.sender]);
104      balances[msg.sender] = balances[msg.sender].sub(_value);
105      balances[_to] = (balances[_to]).add( _value);
106      emit ERC20.Transfer(msg.sender, _to, _value);
107      return true;
108    }
109 
110   function balanceOf(address _owner) public view returns (uint256 balance) {
111     return balances[_owner];
112    }
113 
114   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
115      require(_to != address(0));
116      require(_value <= balances[_from]);
117      require(_value <= allowed[_from][msg.sender]);
118 
119     balances[_from] = (balances[_from]).sub( _value);
120     balances[_to] = (balances[_to]).add(_value);
121     allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_value);
122     emit ERC20.Transfer(_from, _to, _value);
123      return true;
124    }
125 
126    function approve(address _spender, uint256 _value) public returns (bool) {
127      allowed[msg.sender][_spender] = _value;
128     emit ERC20.Approval(msg.sender, _spender, _value);
129      return true;
130    }
131 
132   function allowance(address _owner, address _spender) public view returns (uint256) {
133      return allowed[_owner][_spender];
134    }
135 
136   function mint(uint256 _amount) public ownership returns (bool) {
137     _totalSupply = (_totalSupply).add(_amount);
138     balances[_admin] +=_amount;
139     return true;
140   }
141 
142     function unfreeze(uint256 _amount) public ownership returns (bool) {
143     require(_unfreezebalance >= _amount);
144     balances[_admin] +=  _amount;
145     _unfreezebalance -= _amount;
146         
147     return true;
148     }
149 
150 }