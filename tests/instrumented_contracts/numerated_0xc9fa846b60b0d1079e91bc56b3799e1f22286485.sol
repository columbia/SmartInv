1 pragma solidity ^0.4.20;
2 
3 contract owned {
4     address public owner;
5 
6     constructor () public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnerShip(address newOwer) public onlyOwner {
16         owner = newOwer;
17     }
18 
19 }
20 contract erc20interface {
21   string public name;
22   string public symbol;
23   uint8 public  decimals;
24   uint public totalSupply;
25 
26 
27   function transfer(address _to, uint256 _value) returns (bool success);
28   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
29   
30   function approve(address _spender, uint256 _value) returns (bool success);
31   function allowance(address _owner, address _spender) view returns (uint256 remaining);
32 
33   event Transfer(address indexed _from, address indexed _to, uint256 _value);
34   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
35 
36 }
37 
38 
39 contract erc20 is erc20interface {
40     
41     mapping(address => uint256) public balanceOf;
42     mapping(address => mapping(address => uint256)) allowed;
43     
44     constructor(string name, string symbol) public {
45        name = name;  // "UpChain";
46        symbol = symbol;
47        decimals = 0;
48        totalSupply = 80000000;
49        balanceOf[msg.sender] = totalSupply;
50     }
51     
52     
53   function transfer(address _to, uint256 _value) returns (bool success) {
54       require(_to != address(0));
55       require(balanceOf[msg.sender] >= _value);
56       require(balanceOf[ _to] + _value >= balanceOf[ _to]);
57       
58       
59       balanceOf[msg.sender] -= _value;
60       balanceOf[_to] += _value;
61       
62       emit Transfer(msg.sender, _to, _value);
63       
64       return true;
65   }
66   
67   
68   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
69       require(_to != address(0));
70       require(allowed[_from][msg.sender] >= _value);
71       require(balanceOf[_from] >= _value);
72       require(balanceOf[ _to] + _value >= balanceOf[ _to]);
73       
74       balanceOf[_from] -= _value;
75       balanceOf[_to] += _value;
76       
77       allowed[_from][msg.sender] -= _value;
78       
79       emit Transfer(msg.sender, _to, _value);
80       return true;
81   }
82   
83   function approve(address _spender, uint256 _value) returns (bool success) {
84       allowed[msg.sender][_spender] = _value;
85       
86       emit Approval(msg.sender, _spender, _value);
87       return true;
88   }
89   
90   function allowance(address _owner, address _spender) view returns (uint256 remaining) {
91       return allowed[_owner][_spender];
92   }
93 
94 }
95 
96 
97 contract AdvenceToken is erc20, owned {
98 
99     mapping (address => bool) public frozenAccount;
100 
101     event AddSupply(uint amount);
102     event FrozenFunds(address target, bool frozen);
103     event Burn(address target, uint amount);
104 
105     constructor (string _name, string _symbol) erc20(_name, _symbol) public {
106 
107     }
108 
109     function mine(address target, uint amount) public onlyOwner {
110         totalSupply += amount;
111         balanceOf[target] += amount;
112 
113         emit AddSupply(amount);
114         emit Transfer(0, target, amount);
115     }
116 
117     function freezeAccount(address target, bool freeze) public onlyOwner {
118         frozenAccount[target] = freeze;
119         emit FrozenFunds(target, freeze);
120     }
121 
122 
123   function transfer(address _to, uint256 _value) public returns (bool success) {
124         success = _transfer(msg.sender, _to, _value);
125   }
126 
127 
128   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
129         require(allowed[_from][msg.sender] >= _value);
130         success =  _transfer(_from, _to, _value);
131         allowed[_from][msg.sender] -= _value;
132   }
133 
134   function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
135       require(_to != address(0));
136       require(!frozenAccount[_from]);
137 
138       require(balanceOf[_from] >= _value);
139       require(balanceOf[ _to] + _value >= balanceOf[ _to]);
140 
141       balanceOf[_from] -= _value;
142       balanceOf[_to] += _value;
143 
144       emit Transfer(_from, _to, _value);
145       return true;
146   }
147 
148     function burn(uint256 _value) public returns (bool success) {
149         require(balanceOf[msg.sender] >= _value);
150 
151         totalSupply -= _value;
152         balanceOf[msg.sender] -= _value;
153 
154         emit Burn(msg.sender, _value);
155         return true;
156     }
157 
158     function burnFrom(address _from, uint256 _value)  public returns (bool success) {
159         require(balanceOf[_from] >= _value);
160         require(allowed[_from][msg.sender] >= _value);
161 
162         totalSupply -= _value;
163         balanceOf[msg.sender] -= _value;
164         allowed[_from][msg.sender] -= _value;
165 
166         emit Burn(msg.sender, _value);
167         return true;
168     }
169 }