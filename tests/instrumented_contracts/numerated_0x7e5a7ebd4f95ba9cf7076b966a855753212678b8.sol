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
33 
34 contract ERC20Interface {
35     string public name;
36     string public symbol;
37     uint8 public  decimals;
38     uint public totalSupply;
39     
40     function transfer(address _to, uint256 _value) public returns (bool success);
41     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
42     function approve(address _spender, uint256 _value) public returns (bool success);
43     function allowance(address _owner, address _spender)public view returns (uint256 remaining);
44     
45     event Transfer(address indexed _from, address indexed _to, uint256 _value);
46     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
47  }
48  
49 contract ERC20 is ERC20Interface,SafeMath {
50     mapping(address => uint256) public balanceOf;
51     mapping(address => mapping(address => uint256)) allowed;
52 
53     constructor(string memory _name) public {
54         name = _name;
55         symbol = "CPYT";
56         decimals = 18;
57         totalSupply = 10000000000000000000000000000;
58         balanceOf[msg.sender] = totalSupply;
59     }
60 
61     function transfer(address _to, uint256 _value) public returns (bool success) {
62         require(_to != address(0));
63         require(balanceOf[msg.sender] >= _value);
64         require(balanceOf[ _to] + _value >= balanceOf[ _to]);  
65 
66         balanceOf[msg.sender] =SafeMath.safeSub(balanceOf[msg.sender],_value) ;
67         balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to] ,_value);
68 
69    
70         emit Transfer(msg.sender, _to, _value);
71  
72         return true;
73     }
74 
75 
76     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
77         require(_to != address(0));
78         require(allowed[_from][msg.sender] >= _value);
79         require(balanceOf[_from] >= _value);
80         require(balanceOf[_to] + _value >= balanceOf[_to]);
81 
82         balanceOf[_from] =SafeMath.safeSub(balanceOf[_from],_value) ;
83         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to],_value);
84 
85         allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender], _value);
86 
87         emit Transfer(msg.sender, _to, _value);
88         return true;
89     }
90 
91     function approve(address _spender, uint256 _value) public returns (bool success) {
92         allowed[msg.sender][_spender] = _value;
93  
94         emit Approval(msg.sender, _spender, _value);
95         return true;
96     }
97 
98     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
99       
100         return allowed[_owner][_spender];
101     }
102 
103 }
104 
105 
106 contract owned {
107     address public owner;
108 
109     constructor () public {
110         
111         owner = msg.sender;
112     }
113 
114     modifier onlyOwner {
115         
116         require(msg.sender == owner);
117         _;
118     }
119 
120     function transferOwnerShip(address newOwer) public onlyOwner {
121         
122         owner = newOwer;
123     }
124 
125 }
126 
127 contract CPYT is ERC20,owned{
128     mapping (address => bool) public frozenAccount;
129 
130     event FrozenFunds(address target, bool frozen);
131     event Burn(address target, uint amount);
132 
133     constructor (string memory _name) ERC20(_name) public {
134 
135     }
136 
137 
138     function freezeAccount(address target, bool freeze) public onlyOwner {
139         
140         frozenAccount[target] = freeze;
141         emit FrozenFunds(target, freeze);
142     }
143 
144 
145     function transfer(address _to, uint256 _value) public returns (bool success) {
146         
147         success = _transfer(msg.sender, _to, _value);
148     }
149 
150 
151     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
152         require(allowed[_from][msg.sender] >= _value);
153         success =  _transfer(_from, _to, _value);
154         allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender],_value) ;
155     }
156 
157     function _transfer(address _from, address _to, uint256 _value) internal returns (bool success) {
158         require(_to != address(0));
159         require(!frozenAccount[_from]);
160 
161         require(balanceOf[_from] >= _value);
162         require(balanceOf[ _to] + _value >= balanceOf[ _to]);
163 
164         balanceOf[_from] =SafeMath.safeSub(balanceOf[_from],_value) ;
165         balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to],_value) ;
166 
167         emit Transfer(_from, _to, _value);
168        return true;
169     }
170 
171     function burn(uint256 _value) public returns (bool success) {
172         require(owner == msg.sender);
173         require(balanceOf[msg.sender] >= _value);
174 
175         totalSupply =SafeMath.safeSub(totalSupply,_value) ;
176         balanceOf[msg.sender] =SafeMath.safeSub(balanceOf[msg.sender],_value) ;
177 
178         emit Burn(msg.sender, _value);
179         return true;
180     }
181 
182     function burnFrom(address _from, uint256 _value)  public returns (bool success) {
183         require(owner == msg.sender);
184         require(balanceOf[_from] >= _value);
185         require(allowed[_from][msg.sender] >= _value);
186 
187         totalSupply =SafeMath.safeSub(totalSupply,_value) ;
188         balanceOf[msg.sender] =SafeMath.safeSub(balanceOf[msg.sender], _value);
189         allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender],_value);
190 
191         emit Burn(msg.sender, _value);
192         return true;
193     }
194 }