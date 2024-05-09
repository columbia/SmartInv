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
28 contract Maccabi is ERC20 {
29 
30 
31     string public standard = 'MCB 1.0';
32     string public name;
33     string public symbol;
34     uint8 public decimals;
35     uint256 public totalSupply;
36     
37     
38     
39    
40     mapping( address => uint256) public balanceOf;
41     mapping( uint => address) public accountIndex;
42     uint accountCount;
43     
44     mapping(address => mapping(address => uint256)) public allowance;
45    
46     
47     event Transfer(address indexed from, address indexed to, uint256 value);
48     event Approval(address indexed _owner, address indexed spender, uint value);
49     event Message ( address a, uint256 amount );
50     event Burn(address indexed from, uint256 value);
51 
52 
53    
54     
55     function Maccabi() {
56          
57         uint supply = 15200000000000000; 
58         appendTokenHolders( msg.sender );
59         balanceOf[msg.sender] =  supply;
60         totalSupply = supply; 
61         name = "MACCABI"; 
62         symbol = "MCB"; 
63         decimals = 8; 
64        
65  
66         
67   
68     }
69     
70   
71   
72     function balanceOf(address tokenHolder) constant returns(uint256) {
73 
74         return balanceOf[tokenHolder];
75     }
76 
77     function totalSupply() constant returns(uint256) {
78 
79         return totalSupply;
80     }
81 
82     function getAccountCount() constant returns(uint256) {
83 
84         return accountCount;
85     }
86 
87     function getAddress(uint slot) constant returns(address) {
88 
89         return accountIndex[slot];
90 
91     }
92 
93     
94     function appendTokenHolders(address tokenHolder) private {
95 
96         if (balanceOf[tokenHolder] == 0) {
97           
98             accountIndex[accountCount] = tokenHolder;
99             accountCount++;
100         }
101 
102     }
103 
104     
105     function transfer(address _to, uint256 _value) returns(bool ok) {
106         if (_to == 0x0) throw; 
107         if (balanceOf[msg.sender] < _value) throw; 
108         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
109         
110         appendTokenHolders(_to);
111         balanceOf[msg.sender] -= _value; 
112         balanceOf[_to] += _value; 
113         Transfer(msg.sender, _to, _value); 
114     
115         
116         return true;
117     }
118     
119     function approve(address _spender, uint256 _value)
120     returns(bool success) {
121         allowance[msg.sender][_spender] = _value;
122         Approval( msg.sender ,_spender, _value);
123         return true;
124     }
125 
126  
127     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
128     returns(bool success) {
129         tokenRecipient spender = tokenRecipient(_spender);
130         if (approve(_spender, _value)) {
131             spender.receiveApproval(msg.sender, _value, this, _extraData);
132             return true;
133         }
134     }
135 
136     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
137         return allowance[_owner][_spender];
138     }
139 
140  
141     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
142         if (_to == 0x0) throw;  
143         if (balanceOf[_from] < _value) throw;  
144         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  
145         if (_value > allowance[_from][msg.sender]) throw; 
146         appendTokenHolders(_to);
147         balanceOf[_from] -= _value; 
148         balanceOf[_to] += _value; 
149         allowance[_from][msg.sender] -= _value;
150         Transfer(_from, _to, _value);
151        
152         return true;
153     }
154   
155     function burn(uint256 _value) returns(bool success) {
156         if (balanceOf[msg.sender] < _value) throw; 
157         if( totalSupply -  _value < 2100000000000000) throw;
158         balanceOf[msg.sender] -= _value; 
159         totalSupply -= _value; 
160         Burn(msg.sender, _value);
161         return true;
162     }
163 
164     function burnFrom(address _from, uint256 _value) returns(bool success) {
165     
166         if (balanceOf[_from] < _value) throw; 
167         if (_value > allowance[_from][msg.sender]) throw; 
168         balanceOf[_from] -= _value; 
169         totalSupply -= _value; 
170         Burn(_from, _value);
171         return true;
172     }
173     
174   
175  
176     
177 }