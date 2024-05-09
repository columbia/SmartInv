1 pragma solidity ^0.4.18;
2 
3 contract MyOwned {
4 
5     address public owner;
6 
7     function MyOwned () 
8 
9         public { 
10             owner = msg.sender; 
11     }
12 
13     modifier onlyOwner { 
14 
15         require (msg.sender == owner); 
16         _; 
17     }
18 
19     function transferOwnership ( 
20 
21         address newOwner) 
22 
23         public onlyOwner { 
24             owner = newOwner; 
25         }
26 }
27 
28 interface tokenRecipient { 
29 
30     function receiveApproval (
31 
32         address _from, 
33         uint256 _value, 
34         address _token, 
35         bytes _extraData) 
36         public; 
37 }
38 
39 contract MyToken is MyOwned {   
40 
41     string public name;
42     string public symbol;
43     uint8 public decimals;
44     uint256 public totalSupply;
45     
46     uint256 public sellPrice;
47     uint256 public buyPrice;    
48     
49     mapping (address => uint256) public balanceOf;
50     mapping (address => bool) public frozenAccount;
51     mapping (address => mapping (address => uint256)) public allowance;
52     event Burn (address indexed from, uint256 value);
53     event FrozenFunds (address target,bool frozen);
54     event Transfer (address indexed from,address indexed to,uint256 value);
55     
56     function MyToken (
57 
58         string tokenName,
59         string tokenSymbol,
60         uint8 decimalUnits,
61         uint256 initialSupply) 
62 
63         public {        
64 
65         name = tokenName;
66         symbol = tokenSymbol;
67         decimals = decimalUnits;
68         totalSupply = initialSupply;
69         balanceOf[msg.sender] = initialSupply;
70     }
71     
72     function freezeAccount (
73 
74         address target,
75         bool freeze) 
76 
77         public onlyOwner {
78 
79         frozenAccount[target] = freeze;
80         FrozenFunds(target, freeze);
81     }
82 
83     function _transfer (
84 
85         address _from, 
86         address _to, 
87         uint _value) 
88 
89         internal {
90 
91         require (_to != 0x0); 
92         require (balanceOf[_from] >= _value); 
93         require (balanceOf[_to] + _value >= balanceOf[_to]); 
94 
95         require(!frozenAccount[_from]); 
96         require(!frozenAccount[_to]); 
97 
98         balanceOf[_from] -= _value;  
99         balanceOf[_to] += _value; 
100         Transfer(_from, _to, _value);
101 
102         uint previousBalances = balanceOf[_from] + balanceOf[_to];
103         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
104     }
105 
106     function transfer (
107 
108         address _to, 
109         uint256 _value) 
110 
111         public {
112 
113         _transfer(msg.sender, _to, _value);
114     }
115 
116     function transferFrom (
117 
118         address _from, 
119         address _to, 
120         uint256 _value) 
121 
122         public returns (bool success) {
123 
124         require(_value <= allowance[_from][msg.sender]); 
125         allowance[_from][msg.sender] -= _value;
126         _transfer(_from, _to, _value);
127         return true;
128     }
129 
130     function approve (
131 
132         address _spender, 
133         uint256 _value) 
134 
135         public returns (bool success) {
136 
137         allowance[msg.sender][_spender] = _value;
138         return true;
139     }
140 
141     function approveAndCall (
142 
143         address _spender, 
144         uint256 _value, 
145         bytes _extraData)
146 
147         public returns (bool success) {
148 
149         tokenRecipient spender = tokenRecipient(_spender);
150 
151         if (approve(_spender, _value)) {
152 
153             spender.receiveApproval(
154                 msg.sender, _value, this, _extraData);
155             return true;
156         }
157     }
158 
159     function burnSupply (
160 
161         uint256 _value) 
162 
163         public onlyOwner returns (bool success) {
164 
165         totalSupply -= _value;  
166 
167         return true;
168     }
169 
170     function burnFrom (
171 
172         address _from, 
173         uint256 _value) 
174 
175         public onlyOwner returns (bool success) {
176 
177         require(balanceOf[_from] >= _value); 
178 
179         balanceOf[_from] -= _value; 
180 
181         Burn(_from, _value);
182 
183         return true;
184     }
185 
186     function mintToken (
187 
188         address target, 
189         uint256 mintedAmount) 
190 
191         public onlyOwner {
192 
193         balanceOf[target] += mintedAmount;
194         totalSupply += mintedAmount;
195         Transfer(0, this, mintedAmount);
196         Transfer(this, target, mintedAmount);
197     }
198 
199     function mintTo (
200 
201         address target, 
202         uint256 mintedTo) 
203 
204         public onlyOwner {
205 
206         balanceOf[target] += mintedTo;
207 
208         Transfer(0, this, mintedTo);
209         Transfer(this, target, mintedTo);
210     }
211 
212     function setPrices (
213 
214         uint256 newSellPrice, 
215         uint256 newBuyPrice) 
216 
217         public onlyOwner {
218 
219         sellPrice = newSellPrice;
220         buyPrice = newBuyPrice;
221     }
222 
223     function buy () 
224 
225         public payable {
226 
227         uint amount = msg.value / buyPrice; 
228         _transfer(this, msg.sender, amount);
229     }
230 
231     function sell (
232 
233         uint256 amount) 
234 
235         public {
236 
237         require(this.balance >= amount * sellPrice); 
238         _transfer(msg.sender, this, amount); 
239         msg.sender.transfer(amount * sellPrice);  
240     }    
241     
242     function setName (
243 
244         string newName) 
245 
246         public onlyOwner {
247 
248         name = newName;
249     }
250     
251     function setSymbol (
252 
253         string newSymbol) 
254 
255         public onlyOwner {
256 
257         symbol = newSymbol;
258     }
259 
260 }