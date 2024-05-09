1 pragma solidity ^0.4.20;
2 
3 contract erc20interface {
4   string public name;
5   string public symbol;
6   uint8 public  decimals;
7   uint public totalSupply;
8 
9 
10   function transfer(address _to, uint256 _value) returns (bool success);
11   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
12   
13   function approve(address _spender, uint256 _value) returns (bool success);
14   function allowance(address _owner, address _spender) view returns (uint256 remaining);
15 
16   event Transfer(address indexed _from, address indexed _to, uint256 _value);
17   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
18 
19 }
20 contract erc20 is erc20interface {
21     
22     mapping(address => uint256) public balanceOf;
23     mapping(address => mapping(address => uint256)) allowed;
24     
25     constructor() public {
26        name = "Advertising Mall Block Chain";
27        symbol = "AMC";
28        decimals = 0;
29        totalSupply = 80000000;
30        balanceOf[msg.sender] = totalSupply;
31     }
32     
33     
34   function transfer(address _to, uint256 _value) returns (bool success) {
35       require(_to != address(0));
36       require(balanceOf[msg.sender] >= _value);
37       require(balanceOf[ _to] + _value >= balanceOf[ _to]);
38       
39       
40       balanceOf[msg.sender] -= _value;
41       balanceOf[_to] += _value;
42       
43       emit Transfer(msg.sender, _to, _value);
44       
45       return true;
46   }
47   
48   
49   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
50       require(_to != address(0));
51       require(allowed[_from][msg.sender] >= _value);
52       require(balanceOf[_from] >= _value);
53       require(balanceOf[ _to] + _value >= balanceOf[ _to]);
54       
55       balanceOf[_from] -= _value;
56       balanceOf[_to] += _value;
57       
58       allowed[_from][msg.sender] -= _value;
59       
60       emit Transfer(msg.sender, _to, _value);
61       return true;
62   }
63   
64   function approve(address _spender, uint256 _value) returns (bool success) {
65       allowed[msg.sender][_spender] = _value;
66       
67       emit Approval(msg.sender, _spender, _value);
68       return true;
69   }
70   
71   function allowance(address _owner, address _spender) view returns (uint256 remaining) {
72       return allowed[_owner][_spender];
73   }
74 
75 }
76 
77 contract owned {
78     address public owner;
79 
80     constructor () public {
81         owner = msg.sender;
82     }
83 
84     modifier onlyOwner {
85         require(msg.sender == owner);
86         _;
87     }
88 
89     function transferOwnerShip(address newOwer) public onlyOwner {
90         owner = newOwer;
91     }
92 
93 }
94 contract AMCToken is erc20, owned {
95 
96     mapping (address => bool) public frozenAccount;
97 
98     event AddSupply(uint amount);
99     event FrozenFunds(address target, bool frozen);
100     event Burn(address target, uint amount);
101 
102     constructor () erc20() public {
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