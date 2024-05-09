1 pragma solidity ^ 0.4 .11;
2 
3 contract tokenRecipient {
4     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
5 }
6 
7 
8 contract ERC20 {
9 
10     function totalSupply() constant returns(uint _totalSupply);
11 
12     function balanceOf(address who) constant returns(uint256);
13 
14     function transfer(address to, uint value) returns(bool ok);
15 
16     function transferFrom(address from, address to, uint value) returns(bool ok);
17 
18     function approve(address spender, uint value) returns(bool ok);
19 
20     function allowance(address owner, address spender) constant returns(uint);
21     event Transfer(address indexed from, address indexed to, uint value);
22     event Approval(address indexed owner, address indexed spender, uint value);
23 
24 }
25 
26 
27  
28 contract Kash is ERC20 {
29 
30 
31     string public standard = 'KASH 1.1';
32     string public name;
33     string public symbol;
34     uint8 public decimals;
35     uint256 public totalSupply;
36   
37     
38    
39     mapping( address => uint256) public balanceOf;
40     mapping( uint => address) public accountIndex;
41     uint accountCount;
42     
43     mapping(address => mapping(address => uint256)) public allowance;
44    
45     
46     event Transfer(address indexed from, address indexed to, uint256 value);
47     event Approval(address indexed _owner, address indexed spender, uint value);
48     event Message ( address a, uint256 amount );
49     event Burn(address indexed from, uint256 value);
50 
51     
52     function Kash() {
53          
54         uint supply = 7500000000000000; 
55         appendTokenHolders( msg.sender );
56         balanceOf[msg.sender] =  supply;
57         totalSupply = supply; // 
58         name = "KASH"; // Set the name for display purposes
59         symbol = "KASH"; // Set the symbol for display purposes
60         decimals = 8; // Amount of decimals for display purposes
61  
62         
63   
64     }
65     
66   
67   
68     function balanceOf(address tokenHolder) constant returns(uint256) {
69 
70         return balanceOf[tokenHolder];
71     }
72 
73     function totalSupply() constant returns(uint256) {
74 
75         return totalSupply;
76     }
77 
78     function getAccountCount() constant returns(uint256) {
79 
80         return accountCount;
81     }
82 
83     function getAddress(uint slot) constant returns(address) {
84 
85         return accountIndex[slot];
86 
87     }
88 
89     
90     function appendTokenHolders(address tokenHolder) private {
91 
92         if (balanceOf[tokenHolder] == 0) {
93           
94             accountIndex[accountCount] = tokenHolder;
95             accountCount++;
96         }
97 
98     }
99 
100     
101     function transfer(address _to, uint256 _value) returns(bool ok) {
102         if (_to == 0x0) throw; 
103         if (balanceOf[msg.sender] < _value) throw; 
104         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
105         
106         appendTokenHolders(_to);
107         balanceOf[msg.sender] -= _value; 
108         balanceOf[_to] += _value; 
109         Transfer(msg.sender, _to, _value); 
110     
111         
112         return true;
113     }
114     
115     function approve(address _spender, uint256 _value)
116     returns(bool success) {
117         allowance[msg.sender][_spender] = _value;
118         Approval( msg.sender ,_spender, _value);
119         return true;
120     }
121 
122  
123     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
124     returns(bool success) {
125         tokenRecipient spender = tokenRecipient(_spender);
126         if (approve(_spender, _value)) {
127             spender.receiveApproval(msg.sender, _value, this, _extraData);
128             return true;
129         }
130     }
131 
132     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
133         return allowance[_owner][_spender];
134     }
135 
136  
137     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
138         if (_to == 0x0) throw;  
139         if (balanceOf[_from] < _value) throw;  
140         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  
141         if (_value > allowance[_from][msg.sender]) throw; 
142         appendTokenHolders(_to);
143         balanceOf[_from] -= _value; 
144         balanceOf[_to] += _value; 
145         allowance[_from][msg.sender] -= _value;
146         Transfer(_from, _to, _value);
147        
148         return true;
149     }
150   
151     function burn(uint256 _value) returns(bool success) {
152         if (balanceOf[msg.sender] < _value) throw; 
153         balanceOf[msg.sender] -= _value; 
154         totalSupply -= _value; 
155         Burn(msg.sender, _value);
156         return true;
157     }
158 
159     function burnFrom(address _from, uint256 _value) returns(bool success) {
160     
161         if (balanceOf[_from] < _value) throw; 
162         if (_value > allowance[_from][msg.sender]) throw; 
163         balanceOf[_from] -= _value; 
164         allowance[_from][msg.sender] -= _value; 
165         totalSupply -= _value; 
166         Burn(_from, _value);
167         return true;
168     }
169  
170     
171 }