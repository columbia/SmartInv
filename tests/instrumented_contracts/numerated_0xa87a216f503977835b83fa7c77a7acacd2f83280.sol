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
29       assert(!assertion);
30     }
31 }
32 
33 contract ERC20Interface {
34     string public name;
35     string public symbol;
36     uint8 public  decimals;
37     uint public totalSupply;
38     
39     function transfer(address _to, uint256 _value) public returns (bool success);
40     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
41     function approve(address _spender, uint256 _value) public returns (bool success);
42     function allowance(address _owner, address _spender)public view returns (uint256 remaining);
43     
44     event Transfer(address indexed _from, address indexed _to, uint256 _value);
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46  }
47  
48 contract ERC20 is ERC20Interface,SafeMath {
49     mapping(address => uint256) public balanceOf;
50     mapping(address => mapping(address => uint256)) allowed;
51 
52     constructor(string memory _name) public {
53         name = _name;
54         symbol = "CSCY";
55         decimals = 4;
56         totalSupply = 100000000000;
57         balanceOf[msg.sender] = totalSupply;
58     }
59 
60     function transfer(address _to, uint256 _value) public returns (bool success) {
61         require(_to != address(0));
62         require(balanceOf[msg.sender] >= _value);
63         require(balanceOf[ _to] + _value >= balanceOf[ _to]);  
64 
65         balanceOf[msg.sender] =SafeMath.safeSub(balanceOf[msg.sender],_value) ;
66         balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to] ,_value);
67 
68         emit Transfer(msg.sender, _to, _value);
69  
70         return true;
71     }
72 
73     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
74         require(_to != address(0));
75         require(allowed[_from][msg.sender] >= _value);
76         require(balanceOf[_from] >= _value);
77         require(balanceOf[_to] + _value >= balanceOf[_to]);
78 
79         balanceOf[_from] =SafeMath.safeSub(balanceOf[_from],_value) ;
80         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to],_value);
81 
82         allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender], _value);
83 
84         emit Transfer(msg.sender, _to, _value);
85         return true;
86     }
87 
88     function approve(address _spender, uint256 _value) public returns (bool success) {
89         require((_value==0)||(allowed[msg.sender][_spender]==0));
90         allowed[msg.sender][_spender] = _value;
91  
92         emit Approval(msg.sender, _spender, _value);
93         return true;
94     }
95 
96     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
97       
98         return allowed[_owner][_spender];
99     }
100 
101 }
102 
103 contract owned {
104     address public owner;
105 
106     constructor () public {
107         
108         owner = msg.sender;
109     }
110 
111     modifier onlyOwner {
112         
113         require(msg.sender == owner);
114         _;
115     }
116 
117     function transferOwnerShip(address newOwer) public onlyOwner {
118         
119         owner = newOwer;
120     }
121 
122 }
123 
124 contract CSCY is ERC20,owned{
125     mapping (address => bool) public frozenAccount;
126 
127     event FrozenFunds(address target, bool frozen);
128     event Burn(address target, uint amount);
129 
130     constructor (string memory _name) ERC20(_name) public {
131 
132     }
133 
134     function freezeAccount(address target, bool freeze) public onlyOwner {
135         
136         frozenAccount[target] = freeze;
137         emit FrozenFunds(target, freeze);
138     }
139 
140     function transfer(address _to, uint256 _value) public returns (bool success) {
141         
142         success = _transfer(msg.sender, _to, _value);
143     }
144 
145     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
146         require(allowed[_from][msg.sender] >= _value);
147         require(!frozenAccount[_from]);
148         require(!frozenAccount[_to]);
149         
150         success =  _transfer(_from, _to, _value);
151         allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender],_value) ;
152     }
153 
154     function _transfer(address _from, address _to, uint256 _value) internal returns (bool success) {
155         require(_to != address(0));
156         require(!frozenAccount[_from]);
157         require(!frozenAccount[_to]);
158 
159         require(balanceOf[_from] >= _value);
160         require(balanceOf[ _to] + _value >= balanceOf[ _to]);
161 
162         balanceOf[_from] =SafeMath.safeSub(balanceOf[_from],_value) ;
163         balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to],_value) ;
164 
165         emit Transfer(_from, _to, _value);
166        return true;
167     }
168 
169     function burn(uint256 _value) public returns (bool success) {
170         require(owner == msg.sender);
171         require(balanceOf[msg.sender] >= _value);
172 
173         totalSupply =SafeMath.safeSub(totalSupply,_value) ;
174         balanceOf[msg.sender] =SafeMath.safeSub(balanceOf[msg.sender],_value) ;
175 
176         emit Burn(msg.sender, _value);
177         return true;
178     }
179 
180     function burnFrom(address _from, uint256 _value)  public returns (bool success) {
181         require(owner == msg.sender);
182         require(balanceOf[_from] >= _value);
183         require(allowed[_from][msg.sender] >= _value);
184 
185         totalSupply =SafeMath.safeSub(totalSupply,_value) ;
186         balanceOf[msg.sender] =SafeMath.safeSub(balanceOf[msg.sender], _value);
187         allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender],_value);
188 
189         emit Burn(msg.sender, _value);
190         return true;
191     }
192 }