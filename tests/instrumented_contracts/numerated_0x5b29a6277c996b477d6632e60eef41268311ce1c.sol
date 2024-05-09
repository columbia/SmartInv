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
31 contract Dragon is ERC20 {
32 
33 
34     string public standard = 'DRAGON 1.0';
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
52     function Dragon() {
53          
54         uint supply = 500000000; 
55         appendTokenHolders( msg.sender );
56         balanceOf[msg.sender] =  supply;
57         totalSupply = supply; // 
58         name = "DRAGON"; // Set the name for display purposes
59         symbol = "DRG"; // Set the symbol for display purposes
60         decimals = 0; // Amount of decimals for display purposes
61         
62   
63     }
64 
65     
66     function balanceOf(address tokenHolder) constant returns(uint256) {
67 
68         return balanceOf[tokenHolder];
69     }
70 
71     function totalSupply() constant returns(uint256) {
72 
73         return totalSupply;
74     }
75 
76     function getAccountCount() constant returns(uint256) {
77 
78         return accountCount;
79     }
80 
81     function getAddress(uint slot) constant returns(address) {
82 
83         return accountIndex[slot];
84 
85     }
86 
87     
88     function appendTokenHolders(address tokenHolder) private {
89 
90         if (balanceOf[tokenHolder] == 0) {
91             accountIndex[accountCount] = tokenHolder;
92             accountCount++;
93         }
94 
95     }
96 
97     
98     function transfer(address _to, uint256 _value) returns(bool ok) {
99         if (_to == 0x0) throw; 
100         if (balanceOf[msg.sender] < _value) throw; 
101         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
102         
103         appendTokenHolders(_to);
104         balanceOf[msg.sender] -= _value; 
105         balanceOf[_to] += _value; 
106         Transfer(msg.sender, _to, _value); 
107         
108         return true;
109     }
110     
111     function approve(address _spender, uint256 _value)
112     returns(bool success) {
113         allowance[msg.sender][_spender] = _value;
114         Approval( msg.sender ,_spender, _value);
115         return true;
116     }
117 
118  
119     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
120     returns(bool success) {
121         tokenRecipient spender = tokenRecipient(_spender);
122         if (approve(_spender, _value)) {
123             spender.receiveApproval(msg.sender, _value, this, _extraData);
124             return true;
125         }
126     }
127 
128     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
129         return allowance[_owner][_spender];
130     }
131 
132  
133     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
134         if (_to == 0x0) throw;  
135         if (balanceOf[_from] < _value) throw;  
136         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  
137         if (_value > allowance[_from][msg.sender]) throw; 
138         appendTokenHolders(_to);
139         balanceOf[_from] -= _value; 
140         balanceOf[_to] += _value; 
141         allowance[_from][msg.sender] -= _value;
142         Transfer(_from, _to, _value);
143         return true;
144     }
145   
146     function burn(uint256 _value) returns(bool success) {
147         if (balanceOf[msg.sender] < _value) throw; 
148         balanceOf[msg.sender] -= _value; 
149         totalSupply -= _value; 
150         Burn(msg.sender, _value);
151         return true;
152     }
153 
154     function burnFrom(address _from, uint256 _value) returns(bool success) {
155     
156         if (balanceOf[_from] < _value) throw; 
157         if (_value > allowance[_from][msg.sender]) throw; 
158         balanceOf[_from] -= _value; 
159         totalSupply -= _value; 
160         Burn(_from, _value);
161         return true;
162     }
163  
164     
165 }