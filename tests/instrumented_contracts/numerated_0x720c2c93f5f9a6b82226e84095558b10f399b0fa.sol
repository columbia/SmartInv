1 /**
2  *Submitted for verification at Etherscan.io on 2019-10-10
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2019-08-29
7 */
8 
9 pragma solidity ^0.5.11;
10 
11 contract ERC20 {
12   function balanceOf(address who) public view returns (uint256);
13   function allowance(address owner, address spender) public view returns (uint256);
14   function transferFrom(address from, address to, uint256 value) public returns (bool);
15   function approve(address spender, uint256 value) public returns (bool);
16   function transfer(address to, uint value) public returns(bool);
17   event Transfer(address indexed from, address indexed to, uint value);
18   event Approval(address indexed owner, address indexed spender, uint256 value);
19   
20 }
21 
22 library SafeMath{
23       function mul(uint256 a, uint256 b) internal pure returns (uint256) 
24     {
25         if (a == 0) {
26         return 0;}
27         uint256 c = a * b;
28         assert(c / a == b);
29         return c;
30     }
31 
32     function div(uint256 a, uint256 b) internal pure returns (uint256) 
33     {
34         uint256 c = a / b;
35         return c;
36     }
37 
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
39     {
40         assert(b <= a);
41         return a - b;
42     }
43 
44     function add(uint256 a, uint256 b) internal pure returns (uint256) 
45     {
46         uint256 c = a + b;
47         assert(c >= a);
48         return c;
49     }
50 
51 }
52 contract GRIC_COIN is ERC20 {
53     
54         using SafeMath for uint256;
55 
56     string internal _name;
57     string internal _symbol;
58     uint8 internal _decimals;
59     uint256 internal _totalSupply;
60     
61     address internal  _admin;
62     uint256 public exchangeRate; //percentage
63     address public tokenaddress;
64 
65     mapping (address => uint256) internal balances;
66     mapping (address => mapping (address => uint256)) internal allowed;
67     event oldtokenhistory(address tokenaddress,address _from, address _to,uint256 _amount);
68    
69 
70     constructor(uint256 _rate,address _tokenaddress) public {
71         _admin = msg.sender;
72         _symbol = "GC";  
73         _name = "Gric Coin"; 
74         _decimals = 18; 
75         _totalSupply = 20000000* 10**uint(_decimals);
76         balances[msg.sender]=_totalSupply;
77         exchangeRate = _rate;
78         tokenaddress = _tokenaddress;
79     }
80     
81     modifier ownership()  {
82     require(msg.sender == _admin);
83         _;
84     }
85     
86   
87     function name() public view returns (string memory) 
88     {
89         return _name;
90     }
91 
92     function symbol() public view returns (string memory) 
93     {
94         return _symbol;
95     }
96 
97     function decimals() public view returns (uint8) 
98     {
99         return _decimals;
100     }
101 
102     function totalSupply() public view returns (uint256) 
103     {
104         return _totalSupply;
105     }
106 
107    function transfer(address _to, uint256 _value) public returns (bool) {
108      require(_to != address(0));
109      require(_value <= balances[msg.sender]);
110      balances[msg.sender] = balances[msg.sender].sub(_value);
111      balances[_to] = (balances[_to]).add( _value);
112      emit ERC20.Transfer(msg.sender, _to, _value);
113      return true;
114    }
115 
116   function balanceOf(address _owner) public view returns (uint256 balance) {
117     return balances[_owner];
118    }
119 
120   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
121      require(_to != address(0));
122      require(_value <= balances[_from]);
123      require(_value <= allowed[_from][msg.sender]);
124 
125     balances[_from] = (balances[_from]).sub( _value);
126     balances[_to] = (balances[_to]).add(_value);
127     allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_value);
128     emit ERC20.Transfer(_from, _to, _value);
129      return true;
130    }
131 
132    function approve(address _spender, uint256 _value) public returns (bool) {
133      allowed[msg.sender][_spender] = _value;
134     emit ERC20.Approval(msg.sender, _spender, _value);
135      return true;
136    }
137 
138   function allowance(address _owner, address _spender) public view returns (uint256) {
139      return allowed[_owner][_spender];
140    }
141 
142   function mint(uint256 _amount) public ownership returns (bool) {
143     _totalSupply = (_totalSupply).add(_amount);
144     balances[_admin] +=_amount;
145     return true;
146   }
147     
148   function exchange(uint256 _amount) public{   //amountA = value //_rate= ratio value
149      uint256 total = (_amount.div(1000)).mul(exchangeRate) ;
150      require(balances[_admin]>=total);
151      ERC20(tokenaddress).transferFrom(msg.sender,address(this), _amount); //after allowance
152      balances[_admin]= (balances[_admin]).sub(total);
153      balances[msg.sender] = (balances[msg.sender]).add(total);
154      emit ERC20.Transfer(_admin,msg.sender,total);
155      emit oldtokenhistory(tokenaddress,msg.sender,address(this),_amount);
156   }
157 
158   // owner can update the ratio rate of old token
159   function updateRate(uint256 _rate) public returns(bool) {
160         require(msg.sender==_admin);
161         exchangeRate = _rate;
162         return true;
163     }
164 
165   //owner can update the old token address    
166   function updatetokenaddress(address _tokenaddress) public returns(bool) {
167       require(msg.sender==_admin);
168       tokenaddress = _tokenaddress;
169       return true;
170   }    
171   
172   //only admin can initiate this function
173   //he can transfer the old token to him or any body else
174   function withdrawoldtoken(uint256 amount, address to) public returns (bool){      
175       require(msg.sender==_admin && uint256(ERC20(tokenaddress).balanceOf(address(this)))>=amount);
176       ERC20(tokenaddress).transferFrom(address(this),to,amount);
177       emit oldtokenhistory(tokenaddress,address(this),to,amount);
178       return true;
179   }
180   
181   //Admin can transfer his ownership to new address
182   function transferownership(address _newaddress) public returns(bool){
183       require(msg.sender==_admin);
184       _admin=_newaddress;
185       return true;
186   }
187     
188 }