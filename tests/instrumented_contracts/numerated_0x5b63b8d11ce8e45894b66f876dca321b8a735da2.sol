1 pragma solidity ^0.4.24;
2 
3 contract SafeMath {
4   function safeMul(uint256 a, uint256 b) public pure  returns (uint256)  {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeDiv(uint256 a, uint256 b)public pure returns (uint256) {
11     assert(b > 0);
12     uint256 c = a / b;
13     assert(a == b * c + a % b);
14     return c;
15   }
16 
17   function safeSub(uint256 a, uint256 b)public pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function safeAdd(uint256 a, uint256 b)public pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c>=a && c>=b);
25     return c;
26   }
27 
28   function _assert(bool assertion)public pure {
29     assert(!assertion);
30   }
31 }
32 
33 
34 contract ERC20Interface {
35   string public name;
36   string public symbol;
37   uint8 public  decimals;
38   uint public totalSupply;
39   function transfer(address _to, uint256 _value)public returns (bool success);
40   function transferFrom(address _from, address _to, uint256 _value)public returns (bool success);
41   
42   function approve(address _spender, uint256 _value)public returns (bool success);
43   function allowance(address _owner, address _spender)public view returns (uint256 remaining);
44   event Transfer(address indexed _from, address indexed _to, uint256 _value);
45   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46  }
47  
48 contract ERC20 is ERC20Interface,SafeMath {
49 
50 
51     mapping(address => uint256) public balanceOf;
52 
53     mapping(address => mapping(address => uint256)) allowed;
54 
55     constructor(string _name) public {
56        name = _name;  
57        symbol = "COM";
58        decimals = 4;
59        totalSupply = 1000000000000;
60        balanceOf[msg.sender] = totalSupply;
61     }
62 
63   function transfer(address _to, uint256 _value)public returns (bool success) {
64       require(_to != address(0));
65       require(balanceOf[msg.sender] >= _value);
66       require(balanceOf[ _to] + _value >= balanceOf[ _to]);  
67 
68       balanceOf[msg.sender] =SafeMath.safeSub(balanceOf[msg.sender],_value) ;
69       balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to] ,_value);
70 
71    
72       emit Transfer(msg.sender, _to, _value);
73 
74       return true;
75   }
76 
77 
78   function transferFrom(address _from, address _to, uint256 _value)public returns (bool success) {
79       require(_to != address(0));
80       require(allowed[_from][msg.sender] >= _value);
81       require(balanceOf[_from] >= _value);
82       require(balanceOf[_to] + _value >= balanceOf[_to]);
83 
84       balanceOf[_from] =SafeMath.safeSub(balanceOf[_from],_value) ;
85       balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to],_value);
86 
87       allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender], _value);
88 
89       emit Transfer(msg.sender, _to, _value);
90       return true;
91   }
92 
93   function approve(address _spender, uint256 _value)public returns (bool success) {
94       allowed[msg.sender][_spender] = _value;
95 
96       emit Approval(msg.sender, _spender, _value);
97       return true;
98   }
99 
100   function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
101       return allowed[_owner][_spender];
102   }
103 
104 }
105 
106 
107 contract owned {
108     address public owner;
109 
110     constructor () public {
111         owner = msg.sender;
112     }
113 
114     modifier onlyOwner {
115         require(msg.sender == owner);
116         _;
117     }
118 
119     function transferOwnerShip(address newOwer) public onlyOwner {
120         owner = newOwer;
121     }
122 
123 }
124 
125 contract SelfDesctructionContract is owned {
126    
127    string  public someValue;
128    modifier ownerRestricted {
129       require(owner == msg.sender);
130       _;
131    } 
132  
133    function SelfDesctruction()public {
134       owner = msg.sender;
135    }
136    
137    function setSomeValue(string value)public{
138       someValue = value;
139    } 
140 
141    function destroyContract() ownerRestricted public{
142      selfdestruct(owner);
143    }
144 }
145 
146 
147 
148 contract COM is ERC20, SelfDesctructionContract{
149 
150     mapping (address => bool) public frozenAccount;
151 
152     event AddSupply(uint amount);
153     event FrozenFunds(address target, bool frozen);
154     event Burn(address target, uint amount);
155 
156     constructor (string _name) ERC20(_name) public {
157 
158     }
159 
160     function mine(address target, uint amount) public onlyOwner {
161         totalSupply =SafeMath.safeAdd(totalSupply,amount) ;
162         balanceOf[target] = SafeMath.safeAdd(balanceOf[target],amount);
163 
164         emit AddSupply(amount);
165         emit Transfer(0, target, amount);
166     }
167 
168     function freezeAccount(address target, bool freeze) public onlyOwner {
169         frozenAccount[target] = freeze;
170         emit FrozenFunds(target, freeze);
171     }
172 
173 
174   function transfer(address _to, uint256 _value) public returns (bool success) {
175         success = _transfer(msg.sender, _to, _value);
176   }
177 
178 
179   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
180         require(allowed[_from][msg.sender] >= _value);
181         success =  _transfer(_from, _to, _value);
182         allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender],_value) ;
183   }
184 
185   function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
186       require(_to != address(0));
187       require(!frozenAccount[_from]);
188 
189       require(balanceOf[_from] >= _value);
190       require(balanceOf[ _to] + _value >= balanceOf[ _to]);
191 
192       balanceOf[_from] =SafeMath.safeSub(balanceOf[_from],_value) ;
193       balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to],_value) ;
194 
195       emit Transfer(_from, _to, _value);
196       return true;
197   }
198 
199     function burn(uint256 _value) public returns (bool success) {
200         require(owner == msg.sender);
201         require(balanceOf[msg.sender] >= _value);
202 
203         totalSupply =SafeMath.safeSub(totalSupply,_value) ;
204         balanceOf[msg.sender] =SafeMath.safeSub(balanceOf[msg.sender],_value) ;
205 
206         emit Burn(msg.sender, _value);
207         return true;
208     }
209 
210     function burnFrom(address _from, uint256 _value)  public returns (bool success) {
211         require(owner == msg.sender);
212         require(balanceOf[_from] >= _value);
213         require(allowed[_from][msg.sender] >= _value);
214 
215         totalSupply =SafeMath.safeSub(totalSupply,_value) ;
216         balanceOf[msg.sender] =SafeMath.safeSub(balanceOf[msg.sender], _value);
217         allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender],_value);
218 
219         emit Burn(msg.sender, _value);
220         return true;
221     }
222 }