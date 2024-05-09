1 pragma solidity ^0.4.2;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner {
16         owner = newOwner;
17         if (newOwner != address(0)) {
18           owner = newOwner;
19         }
20     }
21 }
22 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
23 
24 
25 contract RedTicket is owned {
26     string public standard = 'RedTicket 1.0';
27     string public constant name = "RedTicket";
28     string public constant symbol = "RED";
29     uint8 public constant decimals = 18; 
30     uint256 public totalSupply;
31 
32     mapping (address => uint256) balances;
33     mapping (address => mapping (address => uint256)) allowed;
34     mapping (address => bool) public frozenAccount;
35 
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(address indexed _owner, address indexed _spender, uint _value);
38     event Burn(address indexed from, uint256 value);
39     event FrozenFunds(address target, bool frozen);
40     event Issuance(address indexed to, uint256 value);
41 
42     function RedTicket(
43         uint256 initialSupply,
44         address centralMinter
45         ) {
46         if(centralMinter != 0 ) owner = centralMinter;
47 
48         balances[msg.sender] = initialSupply;
49         totalSupply = initialSupply;
50     }
51 
52     function transfer(address _to, uint256 _value) returns (bool success) {
53         if (balances[msg.sender] >= _value 
54             && _value > 0
55             && balances[_to] + _value > balances[_to]) {
56                 
57                 balances[msg.sender] -= _value;
58                 balances[_to] += _value;
59                 Transfer(msg.sender, _to, _value);
60             return true;
61         } else {
62             return false;
63         }
64     }
65 
66     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
67         if (!frozenAccount[msg.sender]
68             && balances[_from] >= _value
69             && allowed[_from][msg.sender] >= _value
70             && _value > 0
71             && balances[_to] + _value > balances[_to]) {
72 
73                 balances[_from] -= _value;
74                 allowed[_from][msg.sender] -= _value;
75                 balances[_to] += _value;
76                 Transfer(_from, _to, _value);
77             return true;
78 
79         } else {
80             return false;
81         }
82     }
83 
84     function balanceOf(address _owner) constant returns (uint256 balance) {
85         return balances[_owner];
86     }
87 
88     function approve(address _spender, uint256 _value) returns (bool success) {
89         allowed[msg.sender][_spender] = _value;
90         Approval(msg.sender, _spender, _value);
91         return true;
92     }
93 
94     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
95         returns (bool success) {
96         tokenRecipient spender = tokenRecipient(_spender);
97         if (approve(_spender, _value)) {
98             spender.receiveApproval(msg.sender, _value, this, _extraData);
99             return true;
100         }
101     }
102 
103     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
104       return allowed[_owner][_spender];
105     }
106 
107     function freezeAccount(address target, bool freeze) onlyOwner {
108         frozenAccount[target] = freeze;
109         FrozenFunds(target, freeze);
110     }
111 
112     function () {
113         revert();
114     }
115 
116     function burn(uint256 _value) returns (bool success) {
117         if (balances[msg.sender] < _value) return false; 
118         balances[msg.sender] -= _value;
119         totalSupply -= _value;
120         Burn(msg.sender, _value);
121         return true;
122     }
123 
124     function burnFrom(address _from, uint256 _value) returns (bool success) {
125         if (balances[_from] < _value) return false;
126         if (_value > allowed[_from][msg.sender]) return false;
127         balances[_from] -= _value;
128         totalSupply -= _value;
129         Burn(_from, _value);
130         return true;
131     }
132 
133     function mintToken(address target, uint256 mintedAmount) onlyOwner {
134         balances[target] += mintedAmount;
135         totalSupply += mintedAmount;
136         Transfer(0, owner, mintedAmount);
137         Transfer(owner, target, mintedAmount);
138     }
139 }