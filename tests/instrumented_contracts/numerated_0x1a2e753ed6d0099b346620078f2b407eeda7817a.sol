1 pragma solidity ^0.4.20;
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
39   function transfer(address _to, uint256 _value) returns (bool success);
40   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
41   
42   function approve(address _spender, uint256 _value) returns (bool success);
43   function allowance(address _owner, address _spender) view returns (uint256 remaining);
44   event Transfer(address indexed _from, address indexed _to, uint256 _value);
45   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46  }
47  
48 contract ERC20 is ERC20Interface,SafeMath {
49 
50     mapping(address => uint256) public balanceOf;
51 
52     mapping(address => mapping(address => uint256)) allowed;
53 
54     constructor(string _name) public {
55        name = _name;  // "UpChain";
56        symbol = "ETYB";
57        decimals = 4;
58        totalSupply = 9000000000000;
59        balanceOf[msg.sender] = totalSupply;
60     }
61 
62   function transfer(address _to, uint256 _value) returns (bool success) {
63       require(_to != address(0));
64       require(balanceOf[msg.sender] >= _value);
65       require(balanceOf[ _to] + _value >= balanceOf[ _to]);  
66 
67       balanceOf[msg.sender] =SafeMath.safeSub(balanceOf[msg.sender],_value) ;
68       balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to] ,_value);
69 
70    
71       emit Transfer(msg.sender, _to, _value);
72 
73       return true;
74   }
75 
76 
77   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
78       require(_to != address(0));
79       require(allowed[_from][msg.sender] >= _value);
80       require(balanceOf[_from] >= _value);
81       require(balanceOf[_to] + _value >= balanceOf[_to]);
82 
83       balanceOf[_from] =SafeMath.safeSub(balanceOf[_from],_value) ;
84       balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to],_value);
85 
86       allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender], _value);
87 
88       emit Transfer(msg.sender, _to, _value);
89       return true;
90   }
91 
92   function approve(address _spender, uint256 _value) returns (bool success) {
93       allowed[msg.sender][_spender] = _value;
94 
95       emit Approval(msg.sender, _spender, _value);
96       return true;
97   }
98 
99   function allowance(address _owner, address _spender) view returns (uint256 remaining) {
100       return allowed[_owner][_spender];
101   }
102 
103 }
104 
105 
106 contract owned {
107     address public owner;
108 
109     constructor () public {
110         owner = msg.sender;
111     }
112 
113     modifier onlyOwner {
114         require(msg.sender == owner);
115         _;
116     }
117 
118     function transferOwnerShip(address newOwer) public onlyOwner {
119         owner = newOwer;
120     }
121 
122 }
123 
124 contract SelfDesctructionContract is owned {
125    
126    string  public someValue;
127    modifier ownerRestricted {
128       require(owner == msg.sender);
129       _;
130    } 
131  
132    function SelfDesctructionContract() {
133       owner = msg.sender;
134    }
135    
136    function setSomeValue(string value){
137       someValue = value;
138    } 
139 
140    function destroyContract() ownerRestricted {
141      selfdestruct(owner);
142    }
143 }
144 
145 
146 
147 contract ETYB is ERC20, SelfDesctructionContract{
148 
149     mapping (address => bool) public frozenAccount;
150 
151     event AddSupply(uint amount);
152     event FrozenFunds(address target, bool frozen);
153     event Burn(address target, uint amount);
154 
155     constructor (string _name) ERC20(_name) public {
156 
157     }
158 
159     function mine(address target, uint amount) public onlyOwner {
160         totalSupply =SafeMath.safeAdd(totalSupply,amount) ;
161         balanceOf[target] = SafeMath.safeAdd(balanceOf[target],amount);
162 
163         emit AddSupply(amount);
164         emit Transfer(0, target, amount);
165     }
166 
167     function freezeAccount(address target, bool freeze) public onlyOwner {
168         frozenAccount[target] = freeze;
169         emit FrozenFunds(target, freeze);
170     }
171 
172 
173   function transfer(address _to, uint256 _value) public returns (bool success) {
174         success = _transfer(msg.sender, _to, _value);
175   }
176 
177 
178   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
179         require(allowed[_from][msg.sender] >= _value);
180         success =  _transfer(_from, _to, _value);
181         allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender],_value) ;
182   }
183 
184   function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
185       require(_to != address(0));
186       require(!frozenAccount[_from]);
187 
188       require(balanceOf[_from] >= _value);
189       require(balanceOf[ _to] + _value >= balanceOf[ _to]);
190 
191       balanceOf[_from] =SafeMath.safeSub(balanceOf[_from],_value) ;
192       balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to],_value) ;
193 
194       emit Transfer(_from, _to, _value);
195       return true;
196   }
197 
198     function burn(uint256 _value) public returns (bool success) {
199         require(balanceOf[msg.sender] >= _value);
200 
201         totalSupply =SafeMath.safeSub(totalSupply,_value) ;
202         balanceOf[msg.sender] =SafeMath.safeSub(balanceOf[msg.sender],_value) ;
203 
204         emit Burn(msg.sender, _value);
205         return true;
206     }
207 
208     function burnFrom(address _from, uint256 _value)  public returns (bool success) {
209         require(balanceOf[_from] >= _value);
210         require(allowed[_from][msg.sender] >= _value);
211 
212         totalSupply =SafeMath.safeSub(totalSupply,_value) ;
213         balanceOf[msg.sender] =SafeMath.safeSub(balanceOf[msg.sender], _value);
214         allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender],_value);
215 
216         emit Burn(msg.sender, _value);
217         return true;
218     }
219 }