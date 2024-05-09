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
30 contract Burner { function dragonHandler( uint256 _amount){} }
31  
32 contract Dragon is ERC20 {
33 
34 
35     string public standard = 'DRAGON 1.1';
36     string public name;
37     string public symbol;
38     uint8 public decimals;
39     uint256 public totalSupply;
40   
41     
42     address public owner;
43     mapping( address => uint256) public balanceOf;
44     mapping( uint => address) public accountIndex;
45     uint accountCount;
46     
47     mapping(address => mapping(address => uint256)) public allowance;
48     address public burner;
49     bool public burnerSet;
50     
51     event Transfer(address indexed from, address indexed to, uint256 value);
52     event Approval(address indexed _owner, address indexed spender, uint value);
53     event Message ( address a, uint256 amount );
54     event Burn(address indexed from, uint256 value);
55 
56     
57     function Dragon() {
58          
59         uint supply = 50000000000000000; 
60         appendTokenHolders( msg.sender );
61         balanceOf[msg.sender] =  supply;
62         totalSupply = supply; // 
63         name = "DRAGON"; // Set the name for display purposes
64         symbol = "DRG"; // Set the symbol for display purposes
65         decimals = 8; // Amount of decimals for display purposes
66         owner = msg.sender;
67         
68   
69     }
70     
71     
72     modifier onlyOwner() {
73         if (msg.sender != owner) {
74             throw;
75         }
76         _;
77     }
78 
79      modifier onlyBurner() {
80         if (msg.sender != burner) {
81             throw;
82         }
83         _;
84     }
85     
86     function changeOwnership( address _owner ) onlyOwner {
87         
88         owner = _owner;
89         
90     }
91     
92     function setBurner( address _burner ) onlyOwner {
93         require ( !burnerSet );
94         burner = _burner;
95         burnerSet = true;
96         
97     }
98 
99     function burnCheck( address _tocheck , uint256 amount ) internal {
100         
101         if ( _tocheck != burner )return;
102         
103         Burner burn = Burner ( burner );
104         burn.dragonHandler( amount );
105         
106         
107     }
108     
109     function burnDragons ( uint256 _amount ) onlyBurner{
110         
111         
112         burn( _amount );
113         
114         
115     }
116     
117     function balanceOf(address tokenHolder) constant returns(uint256) {
118 
119         return balanceOf[tokenHolder];
120     }
121 
122     function totalSupply() constant returns(uint256) {
123 
124         return totalSupply;
125     }
126 
127     function getAccountCount() constant returns(uint256) {
128 
129         return accountCount;
130     }
131 
132     function getAddress(uint slot) constant returns(address) {
133 
134         return accountIndex[slot];
135 
136     }
137 
138     
139     function appendTokenHolders(address tokenHolder) private {
140 
141         if (balanceOf[tokenHolder] == 0) {
142             if ( tokenHolder == burner ) return;
143             accountIndex[accountCount] = tokenHolder;
144             accountCount++;
145         }
146 
147     }
148 
149     
150     function transfer(address _to, uint256 _value) returns(bool ok) {
151         if (_to == 0x0) throw; 
152         if (balanceOf[msg.sender] < _value) throw; 
153         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
154         
155         appendTokenHolders(_to);
156         balanceOf[msg.sender] -= _value; 
157         balanceOf[_to] += _value; 
158         Transfer(msg.sender, _to, _value); 
159         burnCheck( _to, _value );
160         
161         return true;
162     }
163     
164     function approve(address _spender, uint256 _value)
165     returns(bool success) {
166         allowance[msg.sender][_spender] = _value;
167         Approval( msg.sender ,_spender, _value);
168         return true;
169     }
170 
171  
172     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
173     returns(bool success) {
174         tokenRecipient spender = tokenRecipient(_spender);
175         if (approve(_spender, _value)) {
176             spender.receiveApproval(msg.sender, _value, this, _extraData);
177             return true;
178         }
179     }
180 
181     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
182         return allowance[_owner][_spender];
183     }
184 
185  
186     function transferFrom(address _from, address _to, uint256 _value) returns(bool success) {
187         if (_to == 0x0) throw;  
188         if (balanceOf[_from] < _value) throw;  
189         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  
190         if (_value > allowance[_from][msg.sender]) throw; 
191         appendTokenHolders(_to);
192         balanceOf[_from] -= _value; 
193         balanceOf[_to] += _value; 
194         allowance[_from][msg.sender] -= _value;
195         Transfer(_from, _to, _value);
196        
197         return true;
198     }
199   
200     function burn(uint256 _value) returns(bool success) {
201         if (balanceOf[msg.sender] < _value) throw; 
202         if( totalSupply -  _value < 2100000000000000) throw;
203         balanceOf[msg.sender] -= _value; 
204         totalSupply -= _value; 
205         Burn(msg.sender, _value);
206         return true;
207     }
208 
209     function burnFrom(address _from, uint256 _value) returns(bool success) {
210     
211         if (balanceOf[_from] < _value) throw; 
212         if (_value > allowance[_from][msg.sender]) throw; 
213         balanceOf[_from] -= _value; 
214         totalSupply -= _value; 
215         Burn(_from, _value);
216         return true;
217     }
218  
219     
220 }