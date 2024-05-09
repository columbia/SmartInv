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
50     // ?????????????balanceOf????
51     mapping(address => uint256) public balanceOf;
52 
53     // allowed?????????????????address?? ????????????(?????address)?????uint256??
54     mapping(address => mapping(address => uint256)) allowed;
55 
56     constructor(string _name) public {
57        name = _name;  // "UpChain";
58        symbol = "REL";
59        decimals = 18;
60        totalSupply = 10000000000000000000000000000;
61        balanceOf[msg.sender] = totalSupply;
62     }
63 
64   // ???
65   function transfer(address _to, uint256 _value) returns (bool success) {
66       require(_to != address(0));
67       require(balanceOf[msg.sender] >= _value);
68       require(balanceOf[ _to] + _value >= balanceOf[ _to]);  
69 
70       balanceOf[msg.sender] =SafeMath.safeSub(balanceOf[msg.sender],_value) ;
71       balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to] ,_value);
72 
73    
74       emit Transfer(msg.sender, _to, _value);
75 
76       return true;
77   }
78 
79 
80   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
81       require(_to != address(0));
82       require(allowed[_from][msg.sender] >= _value);
83       require(balanceOf[_from] >= _value);
84       require(balanceOf[_to] + _value >= balanceOf[_to]);
85 
86       balanceOf[_from] =SafeMath.safeSub(balanceOf[_from],_value) ;
87       balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to],_value);
88 
89       allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender], _value);
90 
91       emit Transfer(msg.sender, _to, _value);
92       return true;
93   }
94 
95   function approve(address _spender, uint256 _value) returns (bool success) {
96       allowed[msg.sender][_spender] = _value;
97 
98       emit Approval(msg.sender, _spender, _value);
99       return true;
100   }
101 
102   function allowance(address _owner, address _spender) view returns (uint256 remaining) {
103       return allowed[_owner][_spender];
104   }
105 
106 }
107 
108 
109 contract owned {
110     address public owner;
111 
112     constructor () public {
113         owner = msg.sender;
114     }
115 
116     modifier onlyOwner {
117         require(msg.sender == owner);
118         _;
119     }
120 
121     function transferOwnerShip(address newOwer) public onlyOwner {
122         owner = newOwer;
123     }
124 
125 }
126 
127 contract SelfDesctructionContract is owned {
128    
129    string  public someValue;
130    modifier ownerRestricted {
131       require(owner == msg.sender);
132       _;
133    } 
134  
135    function SelfDesctructionContract() {
136       owner = msg.sender;
137    }
138    
139    function setSomeValue(string value){
140       someValue = value;
141    } 
142 
143    function destroyContract() ownerRestricted {
144      selfdestruct(owner);
145    }
146 }
147 
148 
149 
150 contract AdvanceToken is ERC20, owned,SelfDesctructionContract{
151 
152     mapping (address => bool) public frozenAccount;
153 
154     event FrozenFunds(address target, bool frozen);
155     event Burn(address target, uint amount);
156 
157     constructor (string _name) ERC20(_name) public {
158 
159     }
160 
161   function freezeAccount(address target, bool freeze) public onlyOwner {
162         frozenAccount[target] = freeze;
163         emit FrozenFunds(target, freeze);
164     }
165 
166 
167   function transfer(address _to, uint256 _value) public returns (bool success) {
168         success = _transfer(msg.sender, _to, _value);
169   }
170 
171 
172   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
173         require(allowed[_from][msg.sender] >= _value);
174         success =  _transfer(_from, _to, _value);
175         allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender],_value) ;
176   }
177 
178   function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
179       require(_to != address(0));
180       require(!frozenAccount[_from]);
181 
182       require(balanceOf[_from] >= _value);
183       require(balanceOf[ _to] + _value >= balanceOf[ _to]);
184 
185       balanceOf[_from] =SafeMath.safeSub(balanceOf[_from],_value) ;
186       balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to],_value) ;
187 
188       emit Transfer(_from, _to, _value);
189       return true;
190   }
191 
192     function burn(uint256 _value) public returns (bool success) {
193         require(balanceOf[msg.sender] >= _value);
194 
195         totalSupply =SafeMath.safeSub(totalSupply,_value) ;
196         balanceOf[msg.sender] =SafeMath.safeSub(balanceOf[msg.sender],_value) ;
197 
198         emit Burn(msg.sender, _value);
199         return true;
200     }
201 
202     function burnFrom(address _from, uint256 _value)  public returns (bool success) {
203         require(balanceOf[_from] >= _value);
204         require(allowed[_from][msg.sender] >= _value);
205 
206         totalSupply =SafeMath.safeSub(totalSupply,_value) ;
207         balanceOf[msg.sender] =SafeMath.safeSub(balanceOf[msg.sender], _value);
208         allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender],_value);
209 
210         emit Burn(msg.sender, _value);
211         return true;
212     }
213 }