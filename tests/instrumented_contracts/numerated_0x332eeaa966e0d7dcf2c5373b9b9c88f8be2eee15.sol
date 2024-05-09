1 pragma solidity ^0.4.20;
2 contract ERC20Interface {
3   string public name;
4   string public symbol;
5   uint8 public  decimals;
6   uint public totalSupply;
7 
8 
9   function transfer(address _to, uint256 _value) returns (bool success);
10   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
11   
12   function approve(address _spender, uint256 _value) returns (bool success);
13   function allowance(address _owner, address _spender) view returns (uint256 remaining);
14 
15   event Transfer(address indexed _from, address indexed _to, uint256 _value);
16   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17 
18 }
19 contract owned {
20     address public owner;
21 
22     constructor () public {
23         owner = msg.sender;
24     }
25 
26     modifier onlyOwner {
27         require(msg.sender == owner);
28         _;
29     }
30 
31     function transferOwnerShip(address newOwer) public onlyOwner {
32         owner = newOwer;
33     }
34 
35 }
36 contract ERC20 is ERC20Interface {
37     
38     mapping(address => uint256) public balanceOf;
39     mapping(address => mapping(address => uint256)) allowed;
40     
41     constructor() public {
42        name = "Epidermal Growth Factor";  // "UpChain";
43        symbol = "EGF";
44        decimals = 0;
45        totalSupply = 1000000000;
46        balanceOf[msg.sender] = totalSupply;
47     }
48     
49     
50   function transfer(address _to, uint256 _value) returns (bool success) {
51       require(_to != address(0));
52       require(balanceOf[msg.sender] >= _value);
53       require(balanceOf[ _to] + _value >= balanceOf[ _to]);
54       
55       
56       balanceOf[msg.sender] -= _value;
57       balanceOf[_to] += _value;
58       
59       emit Transfer(msg.sender, _to, _value);
60       
61       return true;
62   }
63   
64   
65   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
66       require(_to != address(0));
67       require(allowed[_from][msg.sender] >= _value);
68       require(balanceOf[_from] >= _value);
69       require(balanceOf[ _to] + _value >= balanceOf[ _to]);
70       
71       balanceOf[_from] -= _value;
72       balanceOf[_to] += _value;
73       
74       allowed[_from][msg.sender] -= _value;
75       
76       emit Transfer(msg.sender, _to, _value);
77       return true;
78   }
79   
80   function approve(address _spender, uint256 _value) returns (bool success) {
81       allowed[msg.sender][_spender] = _value;
82       
83       emit Approval(msg.sender, _spender, _value);
84       return true;
85   }
86   
87   function allowance(address _owner, address _spender) view returns (uint256 remaining) {
88       return allowed[_owner][_spender];
89   }
90 
91 }
92 
93 
94 contract EGFToken is ERC20, owned {
95 
96     mapping (address => bool) public frozenAccount;
97 
98     event AddSupply(uint amount);
99     event FrozenFunds(address target, bool frozen);
100     event Burn(address target, uint amount);
101 
102     constructor () ERC20() public {
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