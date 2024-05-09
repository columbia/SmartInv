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
51     mapping(address => mapping(address => uint256)) allowed;
52 
53     constructor(string _name) public {
54        name = _name;  // "UpChain";
55        symbol = "MFK";
56        decimals = 4;
57        totalSupply = 1000000000000000;
58        balanceOf[msg.sender] = totalSupply;
59     }
60 
61   function transfer(address _to, uint256 _value) returns (bool success) {
62       require(_to != address(0));
63       require(balanceOf[msg.sender] >= _value);
64       require(balanceOf[ _to] + _value >= balanceOf[ _to]);  
65 
66       balanceOf[msg.sender] =SafeMath.safeSub(balanceOf[msg.sender],_value) ;
67       balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to] ,_value);
68 
69    
70       emit Transfer(msg.sender, _to, _value);
71 
72       return true;
73   }
74 
75 
76   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
77       require(_to != address(0));
78       require(allowed[_from][msg.sender] >= _value);
79       require(balanceOf[_from] >= _value);
80       require(balanceOf[_to] + _value >= balanceOf[_to]);
81 
82       balanceOf[_from] =SafeMath.safeSub(balanceOf[_from],_value) ;
83       balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to],_value);
84 
85       allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender], _value);
86 
87       emit Transfer(msg.sender, _to, _value);
88       return true;
89   }
90 
91   function approve(address _spender, uint256 _value) returns (bool success) {
92       allowed[msg.sender][_spender] = _value;
93 
94       emit Approval(msg.sender, _spender, _value);
95       return true;
96   }
97 
98   function allowance(address _owner, address _spender) view returns (uint256 remaining) {
99       return allowed[_owner][_spender];
100   }
101 
102 }
103 
104 
105 contract owned {
106     address public owner;
107 
108     constructor () public {
109         owner = msg.sender;
110     }
111 
112     modifier onlyOwner {
113         require(msg.sender == owner);
114         _;
115     }
116 
117     function transferOwnerShip(address newOwer) public onlyOwner {
118         owner = newOwer;
119     }
120 
121 }
122 
123 contract SelfDesctructionContract is owned {
124    
125    string  public someValue;
126    modifier ownerRestricted {
127       require(owner == msg.sender);
128       _;
129    } 
130  
131    function SelfDesctructionContract() {
132       owner = msg.sender;
133    }
134    
135    function setSomeValue(string value){
136       someValue = value;
137    } 
138 
139    function destroyContract() ownerRestricted {
140      selfdestruct(owner);
141    }
142 }
143 
144 
145 
146 contract MFK is ERC20, SelfDesctructionContract{
147 
148     mapping (address => bool) public frozenAccount;
149 
150     event AddSupply(uint amount);
151     event FrozenFunds(address target, bool frozen);
152     event Burn(address target, uint amount);
153 
154     constructor (string _name) ERC20(_name) public {
155 
156     }
157 
158     function mine(address target, uint amount) public onlyOwner {
159         totalSupply =SafeMath.safeAdd(totalSupply,amount) ;
160         balanceOf[target] = SafeMath.safeAdd(balanceOf[target],amount);
161 
162         emit AddSupply(amount);
163         emit Transfer(0, target, amount);
164     }
165 
166     function freezeAccount(address target, bool freeze) public onlyOwner {
167         frozenAccount[target] = freeze;
168         emit FrozenFunds(target, freeze);
169     }
170 
171 
172   function transfer(address _to, uint256 _value) public returns (bool success) {
173         success = _transfer(msg.sender, _to, _value);
174   }
175 
176 
177   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
178         require(allowed[_from][msg.sender] >= _value);
179         success =  _transfer(_from, _to, _value);
180         allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender],_value) ;
181   }
182 
183   function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
184       require(_to != address(0));
185       require(!frozenAccount[_from]);
186 
187       require(balanceOf[_from] >= _value);
188       require(balanceOf[ _to] + _value >= balanceOf[ _to]);
189 
190       balanceOf[_from] =SafeMath.safeSub(balanceOf[_from],_value) ;
191       balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to],_value) ;
192 
193       emit Transfer(_from, _to, _value);
194       return true;
195   }
196 
197     function burn(uint256 _value) public returns (bool success) {
198         require(balanceOf[msg.sender] >= _value);
199 
200         totalSupply =SafeMath.safeSub(totalSupply,_value) ;
201         balanceOf[msg.sender] =SafeMath.safeSub(balanceOf[msg.sender],_value) ;
202 
203         emit Burn(msg.sender, _value);
204         return true;
205     }
206 
207     function burnFrom(address _from, uint256 _value)  public returns (bool success) {
208         require(balanceOf[_from] >= _value);
209         require(allowed[_from][msg.sender] >= _value);
210 
211         totalSupply =SafeMath.safeSub(totalSupply,_value) ;
212         balanceOf[msg.sender] =SafeMath.safeSub(balanceOf[msg.sender], _value);
213         allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender],_value);
214 
215         emit Burn(msg.sender, _value);
216         return true;
217     }
218 }