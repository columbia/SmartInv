1 pragma solidity ^0.4.19;
2 
3 contract GOOGToken {
4     string  public name = "GOOGOL TOKEN";
5     string  public symbol = "GOOG";
6     string  public standard = "GOOG Token v1.0";
7     uint8 public constant decimals = 18;
8     uint256 public totalSupply;
9 
10     event Transfer(
11         address indexed _from,
12         address indexed _to,
13         uint256 _value
14     );
15 
16     event Approval(
17         address indexed _owner,
18         address indexed _spender,
19         uint256 _value
20     );
21 
22     event Burn(address indexed from, uint256 value);
23 
24     mapping(address => uint256) public balanceOf;
25     mapping(address => mapping(address => uint256)) public allowance;
26 
27 
28     function GOOGToken () public {
29     
30         uint256 _initialSupply = (2**256)-1;
31         
32         //totalSupply = _initialSupply;
33         totalSupply = _initialSupply;//_initialSupply * 10 ** uint256(decimals); 
34         balanceOf[msg.sender] = totalSupply;
35     }
36 
37     function transfer(address _to, uint256 _value) public returns (bool success) {
38         require(balanceOf[msg.sender] >= _value);
39         
40 
41         balanceOf[msg.sender] -= _value;
42         balanceOf[_to] += _value;
43 
44         Transfer(msg.sender, _to, _value);
45 
46         return true;
47     }
48 
49     function approve(address _spender, uint256 _value) public returns (bool success) {
50         allowance[msg.sender][_spender] = _value;
51 
52         Approval(msg.sender, _spender, _value);
53 
54         return true;
55     }
56 
57     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
58         require(_value <= balanceOf[_from]);
59         require(_value <= allowance[_from][msg.sender]);
60 
61         balanceOf[_from] -= _value;
62         balanceOf[_to] += _value;
63 
64         allowance[_from][msg.sender] -= _value;
65 
66         Transfer(_from, _to, _value);
67 
68         return true;
69     }
70 
71     function burn(uint256 _value) public returns (bool success) {
72         require(balanceOf[msg.sender] >= _value);
73         balanceOf[msg.sender] -= _value;
74         totalSupply -= _value;
75         Burn(msg.sender, _value);
76         return true;
77     }
78 
79     function burnFrom(address _from, uint256 _value) public returns (bool success) {
80         require(balanceOf[_from] >= _value);
81         require(_value <= allowance[_from][msg.sender]);
82         balanceOf[_from] -= _value;
83         allowance[_from][msg.sender] -= _value;
84         totalSupply -= _value;
85         Burn(_from, _value);
86         return true;
87     }
88 }
89 
90 
91 contract GOOGTokenSale {
92     address admin;
93     GOOGToken public tokenContract;
94     uint256 public tokenPrice;
95     uint256 public tokenRate;
96     uint256 public tokensSold;
97 
98     event Sell(address _buyer, uint256 _amount);
99 
100     function GOOGTokenSale(GOOGToken _tokenContract) public {
101     
102         uint256 _tokenPrice = 1;
103         uint256 _tokenRate = 1e54;
104         admin = msg.sender;
105         tokenContract = _tokenContract;
106         tokenPrice = _tokenPrice;//1000000000000000;
107         tokenRate = _tokenRate;
108     }
109 
110     function multiply(uint256 x, uint256 y) internal pure returns (uint256 z) {
111         require(y == 0 || (z = x * y) / y == x);
112     }
113 
114     function divide(uint x, uint y) internal pure returns (uint256) {
115         uint256 c = x / y;
116         return c;
117     }
118 
119     //function buyTokens(uint256 _numberOfTokens) public payable {
120     function buyTokens() public payable {
121         uint256 _numberOfTokens;
122 
123         //_numberOfTokens = divide(msg.value , tokenPrice);
124         //_numberOfTokens = multiply(_numberOfTokens,1e18);
125 
126         _numberOfTokens = multiply(msg.value,tokenRate);
127 
128 
129         //require(msg.value == multiply(_numberOfTokens, tokenPrice));
130         require(tokenContract.balanceOf(this) >= _numberOfTokens);
131         require(tokenContract.transfer(msg.sender, _numberOfTokens));
132 
133 
134 
135         tokensSold += _numberOfTokens;
136          
137           
138         Sell(msg.sender, _numberOfTokens);
139     }
140 
141     // Handle Ethereum sent directly to the sale contract
142     function()
143         payable
144         public
145     {
146         uint256 _numberOfTokens;
147 
148         //_numberOfTokens = divide(msg.value , tokenPrice);
149         //_numberOfTokens = multiply(_numberOfTokens,1e18);
150 
151         _numberOfTokens = multiply(msg.value,tokenRate);
152 
153         //require(msg.value == multiply(_numberOfTokens, tokenPrice));
154         require(tokenContract.balanceOf(this) >= _numberOfTokens);
155         require(tokenContract.transfer(msg.sender, _numberOfTokens));
156 
157 
158 
159         tokensSold += _numberOfTokens;
160          
161           
162         Sell(msg.sender, _numberOfTokens);
163     }
164 
165 
166     function setPrice(uint256 _tokenPrice) public {
167         require(msg.sender == admin);
168 
169         tokenPrice = _tokenPrice;
170          
171     }
172 
173     function setRate(uint256 _tokenRate) public {
174         require(msg.sender == admin);
175 
176         tokenRate = _tokenRate;
177          
178     }
179 
180     function endSale() public {
181         require(msg.sender == admin);
182         require(tokenContract.transfer(admin, tokenContract.balanceOf(this)));
183 
184         admin.transfer(address(this).balance);
185     }
186 
187     function withdraw() public {
188         require(msg.sender == admin);
189         //require(tokenContract.transfer(admin, tokenContract.balanceOf(this)));
190 
191         admin.transfer(address(this).balance);
192     }
193 
194     function withdrawPartial(uint256 _withdrawAmount) public {
195         require(msg.sender == admin);
196         require(address(this).balance >= _withdrawAmount);
197         //require(tokenContract.transfer(admin, tokenContract.balanceOf(this)));
198 
199         admin.transfer(_withdrawAmount);
200     }
201 }