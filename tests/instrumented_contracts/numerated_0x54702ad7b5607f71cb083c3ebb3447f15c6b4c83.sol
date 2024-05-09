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
58        symbol = "CONG";
59        decimals = 4;
60        totalSupply = 100000000000000;
61        balanceOf[msg.sender] = totalSupply;
62     }
63 
64   // ???
65   function transfer(address _to, uint256 _value) returns (bool success) {
66       require(_to != address(0));
67       require(balanceOf[msg.sender] >= _value);
68       require(balanceOf[ _to] + _value >= balanceOf[ _to]);   // ??????
69 
70       balanceOf[msg.sender] =SafeMath.safeSub(balanceOf[msg.sender],_value) ;
71       balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to] ,_value);
72 
73       // ???????
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
134    // constructor
135    function SelfDesctructionContract() {
136       owner = msg.sender;
137    }
138    // a simple setter function
139    function setSomeValue(string value){
140       someValue = value;
141    } 
142    // you can call it anything you want
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
154     event AddSupply(uint amount);
155     event FrozenFunds(address target, bool frozen);
156     event Burn(address target, uint amount);
157 
158     constructor (string _name) ERC20(_name) public {
159 
160     }
161 
162     function mine(address target, uint amount) public onlyOwner {
163         totalSupply =SafeMath.safeAdd(totalSupply,amount) ;
164         balanceOf[target] = SafeMath.safeAdd(balanceOf[target],amount);
165 
166         emit AddSupply(amount);
167         emit Transfer(0, target, amount);
168     }
169 
170     function freezeAccount(address target, bool freeze) public onlyOwner {
171         frozenAccount[target] = freeze;
172         emit FrozenFunds(target, freeze);
173     }
174 
175 
176   function transfer(address _to, uint256 _value) public returns (bool success) {
177         success = _transfer(msg.sender, _to, _value);
178   }
179 
180 
181   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
182         require(allowed[_from][msg.sender] >= _value);
183         success =  _transfer(_from, _to, _value);
184         allowed[_from][msg.sender] =SafeMath.safeSub(allowed[_from][msg.sender],_value) ;
185   }
186 
187   function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
188       require(_to != address(0));
189       require(!frozenAccount[_from]);
190 
191       require(balanceOf[_from] >= _value);
192       require(balanceOf[ _to] + _value >= balanceOf[ _to]);
193 
194       balanceOf[_from] =SafeMath.safeSub(balanceOf[_from],_value) ;
195       balanceOf[_to] =SafeMath.safeAdd(balanceOf[_to],_value) ;
196 
197       emit Transfer(_from, _to, _value);
198       return true;
199   }
200 
201     function burn(uint256 _value) public returns (bool success) {
202         require(balanceOf[msg.sender] >= _value);
203 
204         totalSupply =SafeMath.safeSub(totalSupply,_value) ;
205         balanceOf[msg.sender] =SafeMath.safeSub(balanceOf[msg.sender],_value) ;
206 
207         emit Burn(msg.sender, _value);
208         return true;
209     }
210 
211     function burnFrom(address _from, uint256 _value)  public returns (bool success) {
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