1 pragma solidity >=0.4.22 <0.6.0;
2 
3 contract SafeMath {
4     function safeMul(uint256 a, uint256 b) public pure  returns (uint256)  {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9     
10     function safeDiv(uint256 a, uint256 b)public pure returns (uint256) {
11         assert(b > 0);
12         uint256 c = a / b;
13         assert(a == b * c + a % b);
14         return c;
15     }
16     
17     function safeSub(uint256 a, uint256 b)public pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21     
22     function safeAdd(uint256 a, uint256 b)public pure returns (uint256) {
23         uint256 c = a + b;
24         assert(c>=a && c>=b);
25         return c;
26     }
27     
28     function _assert(bool assertion)public pure {
29         assert(!assertion);
30     }
31 }
32 
33 contract ERC20Interface {
34     string public name;
35     string public symbol;
36     uint8 public  decimals;
37     uint public totalSupply;
38     
39     function transfer(address _to, uint256 _value)public returns (bool success);
40     function transferFrom(address _from, address _to, uint256 _value)public returns (bool success);
41     function approve(address _spender, uint256 _value)public returns (bool success);
42     function allowance(address _owner, address _spender)public view returns (uint256 remaining);
43     
44     event Transfer(address indexed _from, address indexed _to, uint256 _value);
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46  }
47  
48 contract owned {
49     address public owner;
50 
51     constructor () public {
52         owner = msg.sender;
53     }
54 
55     modifier onlyOwner {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     function transferOwnerShip(address newOwer) public onlyOwner {
61         owner = newOwer;
62     }
63 
64 }
65  
66 contract ERC20 is ERC20Interface,SafeMath,owned {
67 
68     mapping(address => uint256) public balanceOf;
69     mapping(address => mapping(address => uint256)) allowed;
70 
71     event AddSupply(uint amount);
72     
73     constructor(string memory  _name) public {
74         name = _name;  
75         symbol = "AIMT";
76         decimals = 8;
77         totalSupply = 600000000000000;
78         balanceOf[msg.sender] = totalSupply;
79     }
80 
81     function transfer(address _to, uint256 _value)public returns (bool success) {
82         require(_to != address(0));
83         require(balanceOf[msg.sender] >= _value);
84         require(balanceOf[ _to] + _value >= balanceOf[ _to]);  
85         
86         balanceOf[msg.sender] =SafeMath.safeSub(balanceOf[msg.sender],_value) ;
87         balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to] ,_value);
88         
89         emit Transfer(msg.sender, _to, _value);
90         
91         return true;
92     }
93 
94     function transferFrom(address _from, address _to, uint256 _value)public returns (bool success) {
95         require(_to != address(0));
96         require(allowed[_from][msg.sender] >= _value);
97         require(balanceOf[_from] >= _value);
98         require(balanceOf[_to] + _value >= balanceOf[_to]);
99         
100         balanceOf[_from] =SafeMath.safeSub(balanceOf[_from],_value) ;
101         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to],_value);
102         
103         allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender], _value);
104         
105         emit Transfer(msg.sender, _to, _value);
106         return true;
107     }
108 
109     function approve(address _spender, uint256 _value)public returns (bool success) {
110         require((_value==0)||(allowed[msg.sender][_spender]==0));
111         allowed[msg.sender][_spender] = _value;
112         
113         emit Approval(msg.sender, _spender, _value);
114         return true;
115     }
116     
117     function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
118         return allowed[_owner][_spender];
119     }
120     
121     function mine(address target, uint amount) public onlyOwner {
122         totalSupply =SafeMath.safeAdd(totalSupply,amount) ;
123         balanceOf[target] = SafeMath.safeAdd(balanceOf[target],amount);
124 
125         emit AddSupply(amount);
126         emit Transfer(address(0), target, amount);
127     }
128 
129 }