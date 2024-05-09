1 pragma solidity ^ 0.4.18;
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
18     function transfer(address to, uint256 value) returns(bool ok);
19 
20     function transferFrom(address from, address to, uint256 value) returns(bool ok);
21 
22     function approve(address spender, uint256 value) returns(bool ok);
23 
24     function allowance(address owner, address spender) constant returns(uint256);
25     event Transfer(address indexed from, address indexed to, uint256 value);
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 
28 }
29 
30 
31 contract OsherCoin is ERC20 {
32 
33 
34     string public standard = 'OsherCoin 1.0';
35     string public constant name = "OsherCoin";
36     string public constant symbol = "OSH";
37     uint8 public decimals;
38     uint256 public totalSupply;
39   
40     
41     address public owner;
42     mapping( address => uint256) public balanceOf;
43     mapping( uint => address) public accountIndex;
44     uint public accountCount;
45     
46     mapping(address => mapping(address => uint256)) public allowance;
47  
48     
49     event Transfer(address indexed from, address indexed to, uint256 value);
50     event Approval(address indexed _owner, address indexed spender, uint value);
51     
52     event Burn(address indexed from, uint256 value);
53 
54     
55     function OsherCoin() {
56          
57         uint supply = 100000000000000000; 
58         appendTokenHolders( msg.sender );
59         balanceOf[msg.sender] =  supply;
60         totalSupply = supply; // 
61         
62         decimals = 8; // Amount of decimals for display purposes
63         owner = msg.sender;
64         
65   
66     }
67     
68     
69     modifier onlyOwner() {
70         if (msg.sender != owner) {
71             throw;
72         }
73         _;
74     }
75 
76 
77     function balanceOf(address tokenHolder) constant returns(uint256) {
78 
79         return balanceOf[tokenHolder];
80     }
81 
82     function totalSupply() constant returns(uint256) {
83 
84         return totalSupply;
85     }
86 
87     function getAccountCount() constant returns(uint256) {
88 
89         return accountCount;
90     }
91 
92     function getAddress(uint256 slot) constant returns(address) {
93 
94         return accountIndex[slot];
95 
96     }
97 
98     
99     function appendTokenHolders(address tokenHolder) private {
100 
101         if (balanceOf[tokenHolder] == 0) {
102             accountIndex[accountCount] = tokenHolder;
103             accountCount++;
104         }
105 
106     }
107 
108     
109     function transfer(address _to, uint256 _value) returns(bool ok) {
110    
111         if (balanceOf[msg.sender] < _value) throw; 
112         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
113         
114         appendTokenHolders(_to);
115         balanceOf[msg.sender] -= _value; 
116         balanceOf[_to] += _value; 
117         Transfer(msg.sender, _to, _value); 
118 
119         return true;
120     }
121     
122     function approve(address _spender, uint256 _value)
123     returns(bool success) {
124         allowance[msg.sender][_spender] = _value;
125         Approval( msg.sender ,_spender, _value);
126         return true;
127     }
128 
129  
130     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
131     returns(bool success) {
132         tokenRecipient spender = tokenRecipient(_spender);
133         if (approve(_spender, _value)) {
134             spender.receiveApproval(msg.sender, _value, this, _extraData);
135             return true;
136         }
137     }
138 
139     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
140         return allowance[_owner][_spender];
141     }
142 
143  
144     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
145      
146         if (balanceOf[_from] < _value) throw;  
147         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  
148         if (_value > allowance[_from][msg.sender]) throw; 
149         appendTokenHolders(_to);
150         balanceOf[_from] -= _value; 
151         balanceOf[_to] += _value; 
152         allowance[_from][msg.sender] -= _value;
153         Transfer(_from, _to, _value);
154        
155         return true;
156     }
157   
158     function burn(uint256 _value) returns(bool success) {
159         if (balanceOf[msg.sender] < _value) throw; 
160         if( totalSupply -  _value < 2100000000000000) throw;
161         balanceOf[msg.sender] -= _value; 
162         totalSupply -= _value; 
163         Burn(msg.sender, _value);
164         return true;
165     }
166 
167     function burnFrom(address _from, uint256 _value) returns(bool success) {
168         
169         if( totalSupply -  _value < 2100000000000000) throw;
170         if (balanceOf[_from] < _value) throw; 
171         if (_value > allowance[_from][msg.sender]) throw; 
172         balanceOf[_from] -= _value; 
173         allowance[_from][msg.sender] -= _value; 
174         totalSupply -= _value; 
175         Burn(_from, _value);
176         return true;
177     }
178  
179     
180 }