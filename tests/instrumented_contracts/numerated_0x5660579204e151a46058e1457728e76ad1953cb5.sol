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
37 contract erc20 is erc20interface {
38     
39     mapping(address => uint256) public balanceOf;
40     mapping(address => mapping(address => uint256)) allowed;
41     
42     constructor(string name, string symbol) public {
43        name = name;  // "UpChain";
44        symbol = symbol;
45        decimals = 0;
46        totalSupply = 50000000000;
47        balanceOf[msg.sender] = totalSupply;
48     }
49     
50     
51   function transfer(address _to, uint256 _value) returns (bool success) {
52       require(_to != address(0));
53       require(balanceOf[msg.sender] >= _value);
54       require(balanceOf[ _to] + _value >= balanceOf[ _to]);
55       
56       
57       balanceOf[msg.sender] -= _value;
58       balanceOf[_to] += _value;
59       
60       emit Transfer(msg.sender, _to, _value);
61       
62       return true;
63   }
64   
65   
66   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
67       require(_to != address(0));
68       require(allowed[_from][msg.sender] >= _value);
69       require(balanceOf[_from] >= _value);
70       require(balanceOf[ _to] + _value >= balanceOf[ _to]);
71       
72       balanceOf[_from] -= _value;
73       balanceOf[_to] += _value;
74       
75       allowed[_from][msg.sender] -= _value;
76       
77       emit Transfer(msg.sender, _to, _value);
78       return true;
79   }
80   
81   function approve(address _spender, uint256 _value) returns (bool success) {
82       allowed[msg.sender][_spender] = _value;
83       
84       emit Approval(msg.sender, _spender, _value);
85       return true;
86   }
87   
88   function allowance(address _owner, address _spender) view returns (uint256 remaining) {
89       return allowed[_owner][_spender];
90   }
91 
92 }
93 
94 contract AdvenceToken is erc20, owned {
95 
96     mapping (address => bool) public frozenAccount;
97 
98     event AddSupply(uint amount);
99     event FrozenFunds(address target, bool frozen);
100     event Burn(address target, uint amount);
101 
102     constructor (string _name, string _symbol) erc20(_name, _symbol) public {
103 
104     }
105 
106     function mine(address target, uint amount) public onlyOwner {
107         totalSupply += amount;
108         balanceOf[target] += amount;
109 
110         emit AddSupply(amount);
111         emit Transfer(0, target, amount);
112     }
113 
114     function freezeAccount(address target, bool freeze) public onlyOwner {
115         frozenAccount[target] = freeze;
116         emit FrozenFunds(target, freeze);
117     }
118 
119 
120   function transfer(address _to, uint256 _value) public returns (bool success) {
121         success = _transfer(msg.sender, _to, _value);
122   }
123 
124 
125   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
126         require(allowed[_from][msg.sender] >= _value);
127         success =  _transfer(_from, _to, _value);
128         allowed[_from][msg.sender] -= _value;
129   }
130 
131   function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
132       require(_to != address(0));
133       require(!frozenAccount[_from]);
134 
135       require(balanceOf[_from] >= _value);
136       require(balanceOf[ _to] + _value >= balanceOf[ _to]);
137 
138       balanceOf[_from] -= _value;
139       balanceOf[_to] += _value;
140 
141       emit Transfer(_from, _to, _value);
142       return true;
143   }
144 
145     function burn(uint256 _value) public returns (bool success) {
146         require(balanceOf[msg.sender] >= _value);
147 
148         totalSupply -= _value;
149         balanceOf[msg.sender] -= _value;
150 
151         emit Burn(msg.sender, _value);
152         return true;
153     }
154 
155     function burnFrom(address _from, uint256 _value)  public returns (bool success) {
156         require(balanceOf[_from] >= _value);
157         require(allowed[_from][msg.sender] >= _value);
158 
159         totalSupply -= _value;
160         balanceOf[msg.sender] -= _value;
161         allowed[_from][msg.sender] -= _value;
162 
163         emit Burn(msg.sender, _value);
164         return true;
165     }
166 }