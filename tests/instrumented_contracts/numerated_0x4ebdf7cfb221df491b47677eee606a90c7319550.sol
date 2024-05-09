1 pragma solidity ^0.4.20;
2 
3 contract ERC20Interface {
4     
5     string public name;
6     string public symbol;
7     uint8 public decimals;
8     uint public totalSupply;
9     
10 
11     function transfer(address _to, uint256 _value) returns (bool success);
12     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
13     function approve(address _spender, uint256 _value) returns (bool success);
14     function allowance(address _owner, address _spender) returns (uint256 remaining);
15     
16    
17     event Transfer(address indexed _from, address indexed _to, uint256 _value);
18     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
19     
20 }
21 contract ERC20 is ERC20Interface {
22     
23     mapping(address => uint256) public balanceOf;
24     mapping(address => mapping(address => uint256)) allowed;
25     
26 
27     constructor(string _name, string _symbol, uint8 _decimals, uint _totalSupply) public {
28        name =  _name;
29        symbol = _symbol;
30        decimals = _decimals;
31        totalSupply = _totalSupply;
32        balanceOf[msg.sender] = totalSupply;
33     }
34 
35 
36     function transfer(address _to, uint256 _value) returns (bool success){
37         require(_to != address(0));
38         require(balanceOf[msg.sender] >= _value);
39         require(balanceOf[ _to] + _value >= balanceOf[ _to]); 
40 
41         balanceOf[msg.sender] -= _value;
42         balanceOf[_to] += _value;
43 
44         emit Transfer(msg.sender, _to, _value);
45 
46         return true;
47     }
48     
49     function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
50         require(_to != address(0));
51         require(allowed[msg.sender][_from] >= _value);
52         require(balanceOf[_from] >= _value);
53         require(balanceOf[ _to] + _value >= balanceOf[ _to]);
54 
55         balanceOf[_from] -= _value;
56         balanceOf[_to] += _value;
57 
58         allowed[msg.sender][_from] -= _value;
59 
60         emit Transfer(msg.sender, _to, _value);
61         return true;
62     }
63     
64     function approve(address _spender, uint256 _value) returns (bool success){
65         allowed[msg.sender][_spender] = _value;
66 
67         emit Approval(msg.sender, _spender, _value);
68         return true;
69     }
70     
71  
72     function allowance(address _owner, address _spender) returns (uint256 remaining){
73          return allowed[_owner][_spender];
74     }
75 
76 }
77 contract owned {
78     address public owner;
79 
80     constructor () public {
81         owner = msg.sender;
82     }
83    
84   
85     modifier onlyOwner {
86         require(msg.sender == owner);
87         _;
88     }
89    
90 
91     function transferOwnerShip(address newOwer) public onlyOwner {
92         owner = newOwer;
93     }
94 }
95 
96 contract GDChainToken is ERC20, owned {
97 
98     mapping (address => bool) public frozenAccount;
99 
100     event AddSupply(uint amount);
101     event FrozenFunds(address target, bool frozen);
102     event Burn(address target, uint amount);
103 
104  
105     constructor (string _name, string _symbol, uint8 _decimals, uint _totalSupply) 
106         ERC20(_name, _symbol, _decimals, _totalSupply) public {
107         
108     }
109    
110     function mine(address target, uint amount) public onlyOwner {
111         totalSupply += amount;
112         balanceOf[target] += amount;
113 
114         emit AddSupply(amount);
115         emit Transfer(0, target, amount);
116     }
117     
118     function freezeAccount(address target, bool freeze) public onlyOwner {
119         frozenAccount[target] = freeze;
120         emit FrozenFunds(target, freeze);
121     }
122 
123     function transfer(address _to, uint256 _value) public returns (bool success) {
124         success = _transfer(msg.sender, _to, _value);
125     }
126 
127     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
128         require(allowed[_from][msg.sender] >= _value);
129         success =  _transfer(_from, _to, _value);
130         allowed[_from][msg.sender]  -= _value;
131     }
132 
133     function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
134       require(_to != address(0));
135       require(!frozenAccount[_from]);
136 
137       require(balanceOf[_from] >= _value);
138       require(balanceOf[ _to] + _value >= balanceOf[ _to]);
139 
140       balanceOf[_from] -= _value;
141       balanceOf[_to] += _value;
142 
143    
144       emit Transfer(_from, _to, _value);
145       return true;
146     }
147 
148     function burn(uint256 _value) public returns (bool success) {
149        require(balanceOf[msg.sender] >= _value);
150 
151        totalSupply -= _value; 
152        balanceOf[msg.sender] -= _value;
153 
154        emit Burn(msg.sender, _value);
155        return true;
156     }
157 
158 
159     function burnFrom(address _from, uint256 _value)  public returns (bool success) {
160         require(balanceOf[_from] >= _value);
161         require(allowed[_from][msg.sender] >= _value);
162 
163         totalSupply -= _value; 
164         balanceOf[msg.sender] -= _value;
165         allowed[_from][msg.sender] -= _value;
166 
167         emit Burn(msg.sender, _value);
168         return true;
169     }
170 }