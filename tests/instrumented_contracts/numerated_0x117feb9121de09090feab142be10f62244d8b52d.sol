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
55         symbol = "BGD";
56         decimals = 18;
57         totalSupply = 600000000000000000000000;
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
92         require((_value==0)||(allowed[msg.sender][_spender]==0));
93         allowed[msg.sender][_spender] = _value;
94  
95         emit Approval(msg.sender, _spender, _value);
96         return true;
97     }
98 
99     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
100       
101         return allowed[_owner][_spender];
102     }
103 
104 }
105 
106 
107 contract owned {
108     address public owner;
109 
110     constructor () public {
111         
112         owner = msg.sender;
113     }
114 
115     modifier onlyOwner {
116         
117         require(msg.sender == owner);
118         _;
119     }
120 
121     function transferOwnerShip(address newOwer) public onlyOwner {
122         
123         owner = newOwer;
124     }
125 
126 }
127 
128 contract BGD is ERC20,owned{
129     mapping (address => bool) public frozenAccount;
130 
131     event FrozenFunds(address target, bool frozen);
132     event Burn(address target, uint amount);
133 
134     constructor (string memory _name) ERC20(_name) public {
135 
136     }
137 
138 
139     function freezeAccount(address target, bool freeze) public onlyOwner {
140         
141         frozenAccount[target] = freeze;
142         emit FrozenFunds(target, freeze);
143     }
144 
145 
146     function transfer(address _to, uint256 _value) public returns (bool success) {
147         
148         success = _transfer(msg.sender, _to, _value);
149     }
150 
151 
152     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
153         require(allowed[_from][msg.sender] >= _value);
154         require(!frozenAccount[msg.sender]);
155         require(!frozenAccount[_from]);
156 	    require(!frozenAccount[_to]);
157         
158         success =  _transfer(_from, _to, _value);
159         allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender],_value) ;
160     }
161 
162     function _transfer(address _from, address _to, uint256 _value) internal returns (bool success) {
163         require(_to != address(0));
164         require(!frozenAccount[_from]);
165         require(!frozenAccount[_to]);
166 
167         require(balanceOf[_from] >= _value);
168         require(balanceOf[ _to] + _value >= balanceOf[ _to]);
169 
170         balanceOf[_from] =SafeMath.safeSub(balanceOf[_from],_value) ;
171         balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to],_value) ;
172 
173         emit Transfer(_from, _to, _value);
174         return true;
175     }
176 
177     function burn(uint256 _value) public returns (bool success) {
178         require(owner == msg.sender);
179         require(balanceOf[msg.sender] >= _value);
180 
181         totalSupply =SafeMath.safeSub(totalSupply,_value) ;
182         balanceOf[msg.sender] =SafeMath.safeSub(balanceOf[msg.sender],_value) ;
183 
184         emit Burn(msg.sender, _value);
185         return true;
186     }
187 
188     function burnFrom(address _from, uint256 _value)  public returns (bool success) {
189         require(owner == msg.sender);
190         require(balanceOf[_from] >= _value);
191         require(allowed[_from][msg.sender] >= _value);
192 
193         totalSupply =SafeMath.safeSub(totalSupply,_value) ;
194         balanceOf[_from] =SafeMath.safeSub(balanceOf[_from], _value);
195         allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender],_value);
196 
197         emit Burn(_from, _value);
198         return true;
199     }
200 }