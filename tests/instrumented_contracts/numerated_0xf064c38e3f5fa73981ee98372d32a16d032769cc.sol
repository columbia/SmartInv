1 pragma solidity ^ 0.4 .11;
2 
3 
4 
5 
6 
7 contract tokenRecipient {
8     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
9 }
10 
11 
12 contract ERC20 {
13 
14     function totalSupply() constant returns(uint _totalSupply);
15 
16     function balanceOf(address who) constant returns(uint256);
17 
18     function transfer(address to, uint value) returns(bool ok);
19 
20     function transferFrom(address from, address to, uint value) returns(bool ok);
21 
22     function approve(address spender, uint value) returns(bool ok);
23 
24     function allowance(address owner, address spender) constant returns(uint);
25     event Transfer(address indexed from, address indexed to, uint value);
26     event Approval(address indexed owner, address indexed spender, uint value);
27 
28 }
29 
30  
31 contract Studio is ERC20 {
32 
33 
34     string public standard = 'STUDIO 1.0';
35     string public name;
36     string public symbol;
37     uint8 public decimals;
38     uint256 public totalSupply;
39     
40     address public owner;
41     mapping( address => uint256) public balanceOf;
42     mapping( uint => address) public accountIndex;
43     uint accountCount;
44     
45     mapping(address => mapping(address => uint256)) public allowance;
46     event Transfer(address indexed from, address indexed to, uint256 value);
47     event Approval(address indexed _owner, address indexed spender, uint value);
48     event Message ( address a, uint256 amount );
49     event Burn(address indexed from, uint256 value);
50 
51     
52     function Studio() {
53          
54         uint supply = 50000000; 
55         appendTokenHolders( msg.sender );
56         balanceOf[msg.sender] =  supply;
57         totalSupply = supply; // 
58         name = "STUDIO"; // Set the name for display purposes
59         symbol = "STDO"; // Set the symbol for display purposes
60         decimals = 0; // Amount of decimals for display purposes
61         owner = msg.sender;
62         
63   
64     }
65 
66     
67     function balanceOf(address tokenHolder) constant returns(uint256) {
68 
69         return balanceOf[tokenHolder];
70     }
71 
72     function totalSupply() constant returns(uint256) {
73 
74         return totalSupply;
75     }
76 
77     function getAccountCount() constant returns(uint256) {
78 
79         return accountCount;
80     }
81 
82     function getAddress(uint slot) constant returns(address) {
83 
84         return accountIndex[slot];
85 
86     }
87 
88     
89     function appendTokenHolders(address tokenHolder) private {
90 
91         if (balanceOf[tokenHolder] == 0) {
92             accountIndex[accountCount] = tokenHolder;
93             accountCount++;
94         }
95 
96     }
97 
98     
99     function transfer(address _to, uint256 _value) returns(bool ok) {
100         if (_to == 0x0) throw; 
101         if (balanceOf[msg.sender] < _value) throw; 
102         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
103         
104         appendTokenHolders(_to);
105         balanceOf[msg.sender] -= _value; 
106         balanceOf[_to] += _value; 
107         Transfer(msg.sender, _to, _value); 
108         
109         return true;
110     }
111     
112     function approve(address _spender, uint256 _value)
113     returns(bool success) {
114         allowance[msg.sender][_spender] = _value;
115         Approval( msg.sender ,_spender, _value);
116         return true;
117     }
118 
119  
120     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
121     returns(bool success) {
122         tokenRecipient spender = tokenRecipient(_spender);
123         if (approve(_spender, _value)) {
124             spender.receiveApproval(msg.sender, _value, this, _extraData);
125             return true;
126         }
127     }
128 
129     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
130         return allowance[_owner][_spender];
131     }
132 
133  
134     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
135         if (_to == 0x0) throw;  
136         if (balanceOf[_from] < _value) throw;  
137         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  
138         if (_value > allowance[_from][msg.sender]) throw; 
139         appendTokenHolders(_to);
140         balanceOf[_from] -= _value; 
141         balanceOf[_to] += _value; 
142         allowance[_from][msg.sender] -= _value;
143         Transfer(_from, _to, _value);
144         return true;
145     }
146   
147     function burn(uint256 _value) returns(bool success) {
148         if (balanceOf[msg.sender] < _value) throw; 
149         balanceOf[msg.sender] -= _value; 
150         totalSupply -= _value; 
151         Burn(msg.sender, _value);
152         return true;
153     }
154 
155     function burnFrom(address _from, uint256 _value) returns(bool success) {
156     
157         if (balanceOf[_from] < _value) throw; 
158         if (_value > allowance[_from][msg.sender]) throw; 
159         balanceOf[_from] -= _value; 
160         totalSupply -= _value; 
161         Burn(_from, _value);
162         return true;
163     }
164  
165     
166 }