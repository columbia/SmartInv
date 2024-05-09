1 pragma solidity 0.4.24;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract owned {
6     address public owner;
7     constructor() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         require (msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address newOwner) onlyOwner public {
17         if (newOwner != address(0)) {
18         owner = newOwner;
19       }
20     }
21 }
22 
23 
24 contract token {
25     string public name; 
26     string public symbol; 
27     uint8 public decimals = 8;  
28     uint256 public totalSupply; 
29 
30     mapping (address => uint256) public balances;
31     mapping (address => mapping (address => uint256)) public allowance;
32 
33     event Transfer(address indexed from, address indexed to, uint256 value); 
34     event Burn(address indexed from, uint256 value);  
35 
36     constructor(uint256 initialSupply, string tokenName, string tokenSymbol) public {
37         totalSupply = initialSupply * 10 ** uint256(decimals);  
38         balances[msg.sender] = totalSupply;                        //balanceOf[msg.sender] = totalSupply;
39         name = tokenName;
40         symbol = tokenSymbol;
41 
42     }
43 
44     function balanceOf(address _owner) public constant returns (uint256 balance) {
45         return balances[_owner];
46     }
47 
48     function _transfer(address _from, address _to, uint256 _value) internal {
49       require(_to != 0x0);
50       require(balances[_from] >= _value);
51       require(balances[_to] + _value > balances[_to]);
52       uint previousBalances = balances[_from] + balances[_to];
53       balances[_from] -= _value;
54       balances[_to] += _value;
55       emit Transfer(_from, _to, _value);
56       assert(balances[_from] + balances[_to] == previousBalances);
57 
58     }
59 
60     function transfer(address _to, uint256 _value) public {
61         _transfer(msg.sender, _to, _value);
62     }
63 
64   
65     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
66         require(_value <= allowance[_from][msg.sender]);         // Check allowance
67         allowance[_from][msg.sender] -= _value;
68         _transfer(_from, _to, _value);
69         return true;
70     }
71 
72 
73     function approve(address _spender, uint256 _value) public returns (bool success) {
74         allowance[msg.sender][_spender] = _value;
75         return true;
76     }
77 
78  
79     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
80         tokenRecipient spender = tokenRecipient(_spender);
81         if (approve(_spender, _value)) {
82             spender.receiveApproval(msg.sender, _value, this, _extraData);
83             return true;
84         }
85     }
86 
87 
88     function burn(uint256 _value) public returns (bool success) {
89         require(balances[msg.sender] >= _value);   // Check if the sender has enough
90         balances[msg.sender] -= _value;
91         totalSupply -= _value;
92         emit Burn(msg.sender, _value);
93         return true;
94     }
95 
96     function burnFrom(address _from, uint256 _value) public returns (bool success) {
97         require(balances[_from] >= _value);
98         require(_value <= allowance[_from][msg.sender]);
99         balances[_from] -= _value;
100         allowance[_from][msg.sender] -= _value;
101         totalSupply -= _value;
102         emit Burn(_from, _value);
103         return true;
104     }
105 
106 }
107 
108 contract SVC is owned, token {
109     mapping (address => bool) public frozenAccount;
110     event FrozenFunds(address target, bool frozen);
111 
112     constructor(
113       uint256 initialSupply,
114       string tokenName,
115       string tokenSymbol
116     ) token (initialSupply, tokenName, tokenSymbol) public {}
117 
118 
119     function _transfer(address _from, address _to, uint _value) internal {
120         require (_to != 0x0);
121         require (balances[_from] > _value);
122         require (balances[_to] + _value > balances[_to]);
123         require(!frozenAccount[_from]);
124         require(!frozenAccount[_to]);
125         balances[_from] -= _value;
126         balances[_to] += _value;
127         emit Transfer(_from, _to, _value);
128 
129     }
130 
131  
132     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
133 
134         balances[target] += mintedAmount;
135         totalSupply += mintedAmount;
136 
137         emit Transfer(0, this, mintedAmount);
138         emit Transfer(this, target, mintedAmount);
139     }
140 
141   
142     function freezeAccount(address target, bool freeze) onlyOwner public {
143         frozenAccount[target] = freeze;
144         emit FrozenFunds(target, freeze);
145     }
146 
147 }