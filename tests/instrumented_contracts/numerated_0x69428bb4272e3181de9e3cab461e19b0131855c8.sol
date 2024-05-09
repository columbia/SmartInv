1 pragma solidity ^0.5.11;
2 
3 contract ERC20 {
4   function balanceOf(address who) public view returns (uint256);
5   function allowance(address owner, address spender) public view returns (uint256);
6   function transferFrom(address from, address to, uint256 value) public returns (bool);
7   function approve(address spender, uint256 value) public returns (bool);
8   function transfer(address to, uint value) public returns(bool);
9   event Transfer(address indexed from, address indexed to, uint value);
10   event Approval(address indexed owner, address indexed spender, uint256 value);
11   event Burn(address indexed from, uint256 value);
12 }
13 
14 library SafeMath{
15       function mul(uint256 a, uint256 b) internal pure returns (uint256) 
16     {
17         if (a == 0) {
18         return 0;}
19         uint256 c = a * b;
20         assert(c / a == b);
21         return c;
22     }
23 
24     function div(uint256 a, uint256 b) internal pure returns (uint256) 
25     {
26         uint256 c = a / b;
27         return c;
28     }
29 
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
31     {
32         assert(b <= a);
33         return a - b;
34     }
35 
36     function add(uint256 a, uint256 b) internal pure returns (uint256) 
37     {
38         uint256 c = a + b;
39         assert(c >= a);
40         return c;
41     }
42 
43 }
44 contract SYBC is ERC20 {
45     
46         using SafeMath for uint256;
47 
48     string internal _name;
49     string internal _symbol;
50     uint8 internal _decimals;
51     uint256 internal _totalSupply;
52     
53     address internal  _admin;
54     
55 
56     mapping (address => uint256) internal balances;
57     mapping (address => mapping (address => uint256)) internal allowed;
58   
59 
60     constructor() public {
61         _admin = msg.sender;
62         _symbol = "SYBC";  
63         _name = "SYBC COIN"; 
64         _decimals = 8; 
65         _totalSupply = 500000000* 10**uint(_decimals);
66         balances[msg.sender]=_totalSupply;
67        
68     }
69     
70     modifier ownership()  {
71     require(msg.sender == _admin);
72         _;
73     }
74     
75   
76     function name() public view returns (string memory) 
77     {
78         return _name;
79     }
80 
81     function symbol() public view returns (string memory) 
82     {
83         return _symbol;
84     }
85 
86     function decimals() public view returns (uint8) 
87     {
88         return _decimals;
89     }
90 
91     function totalSupply() public view returns (uint256) 
92     {
93         return _totalSupply;
94     }
95 
96    function transfer(address _to, uint256 _value) public returns (bool) {
97      require(_to != address(0));
98      require(_value <= balances[msg.sender]);
99      balances[msg.sender] = balances[msg.sender].sub(_value);
100      balances[_to] = (balances[_to]).add( _value);
101      emit ERC20.Transfer(msg.sender, _to, _value);
102      return true;
103    }
104 
105   function balanceOf(address _owner) public view returns (uint256 balance) {
106     return balances[_owner];
107    }
108 
109   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
110      require(_to != address(0));
111      require(_value <= balances[_from]);
112      require(_value <= allowed[_from][msg.sender]);
113 
114     balances[_from] = (balances[_from]).sub( _value);
115     balances[_to] = (balances[_to]).add(_value);
116     allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_value);
117     emit ERC20.Transfer(_from, _to, _value);
118      return true;
119    }
120 
121    function approve(address _spender, uint256 _value) public returns (bool) {
122      allowed[msg.sender][_spender] = _value;
123     emit ERC20.Approval(msg.sender, _spender, _value);
124      return true;
125    }
126 
127   function allowance(address _owner, address _spender) public view returns (uint256) {
128      return allowed[_owner][_spender];
129    }
130 
131   function mint(uint256 _amount) public ownership returns (bool) {
132     _totalSupply = (_totalSupply).add(_amount);
133     balances[_admin] +=_amount;
134     return true;
135   }
136     
137  function burn(uint256 _value) public returns (bool success) {
138         require(balances[msg.sender] >= _value);   // Check if the sender has enough
139         balances[msg.sender] -= _value;            // Subtract from the sender
140         _totalSupply -= _value;                      // Updates totalSupply
141         emit Burn(msg.sender, _value);
142         return true;
143     }
144 
145     /**
146      * Destroy tokens from other account
147      */
148     function burnFrom(address _from, uint256 _value) public returns (bool success) {
149         require(balances[_from] >= _value);                // Check if the targeted balance is enough
150         require(_value <= allowed[_from][msg.sender]);    // Check allowance
151         balances[_from] -= _value;                         // Subtract from the targeted balance
152         allowed[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
153         _totalSupply -= _value;                              // Update totalSupply
154         emit Burn(_from, _value);
155         return true;
156     }
157      
158   
159   
160  
161   
162   //Admin can transfer his ownership to new address
163   function transferownership(address _newaddress) public returns(bool){
164       require(msg.sender==_admin);
165       _admin=_newaddress;
166       return true;
167   }
168     
169 }