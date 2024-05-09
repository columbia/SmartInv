1 pragma solidity ^0.4.18;
2 
3 interface tokenRecipient {
4     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
5 }
6 
7 contract ArtyCoin {
8     string public name;
9     string public symbol;
10     uint8 public decimals = 18;
11     uint256 public totalSupply;
12     
13     uint256 public tokensPerOneETH;
14     uint256 public totalEthInWei;
15     uint256 public totalETHRaised;
16     uint256 public totalDeposit;
17     uint256 public sellPrice;
18     uint256 public buyPrice;
19     address public owner; 
20     
21     bool public isCanSell;
22     bool public isCanBuy;
23 
24     mapping (address => uint256) public balanceOf;
25     mapping (address => mapping (address => uint256)) public allowance;
26 
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Burn(address indexed from, uint256 value);
29     
30     modifier onlyOwner {
31         require(msg.sender == owner);
32         _;
33     }
34 
35     function ArtyCoin(uint256 initialSupply, string tokenName, string tokenSymbol, address ownerAddress) public {
36         totalSupply = initialSupply * 10 ** uint256(decimals);
37         balanceOf[ownerAddress] = totalSupply;
38         owner = ownerAddress;
39         name = tokenName;
40         symbol = tokenSymbol;
41     }
42     
43     function setIsTokenCanBeBuy(bool condition) onlyOwner public returns (bool success) {
44         isCanBuy = condition;
45         return true;
46     }
47     
48     function setIsTokenCanBeSell(bool condition) onlyOwner public returns (bool success) {
49         isCanSell = condition;
50         return true;
51     }
52     
53     function setSellPrice(uint256 newSellPrice) onlyOwner public returns (bool success) {
54         require(newSellPrice > 0);
55         sellPrice = newSellPrice;
56         return true;
57     }
58     
59     function setBuyPrice(uint256 newBuyPrice) onlyOwner public returns (bool success) {
60         require(newBuyPrice > 0);
61         buyPrice = newBuyPrice;
62         return true;
63     }
64     
65     function sellTokens(uint amount) public returns (uint revenue){
66         require(isCanSell);
67         require(sellPrice > 0);
68         require(balanceOf[msg.sender] >= amount);
69         
70         uint256 divideValue = 1 * 10 ** uint256(decimals);
71         
72         revenue = (amount / divideValue) * sellPrice;
73         require(this.balance >= revenue);
74         
75         balanceOf[owner] += amount;
76         balanceOf[msg.sender] -= amount;
77         
78         msg.sender.transfer(revenue);
79         
80         Transfer(msg.sender, owner, amount);
81         return revenue;
82     }
83     
84     function buyTokens() payable public {
85         require(msg.value > 0);
86         totalEthInWei += msg.value;
87         uint256 amount = msg.value * tokensPerOneETH;
88         require(balanceOf[owner] >= amount);
89         
90         balanceOf[owner] -= amount;
91         balanceOf[msg.sender] += amount;
92         Transfer(owner, msg.sender, amount);
93 
94         owner.transfer(msg.value);
95     }
96     
97     function createTokensToOwner(uint256 amount) onlyOwner public {
98         require(amount > 0);
99         uint256 newAmount = amount * 10 ** uint256(decimals);
100         totalSupply += newAmount;
101         balanceOf[owner] += newAmount;
102         Transfer(0, owner, newAmount);
103     }
104     
105     function createTokensTo(address target, uint256 mintedAmount) onlyOwner public {
106         require(mintedAmount > 0);
107         uint256 newAmount = mintedAmount * 10 ** uint256(decimals);
108         balanceOf[target] += newAmount;
109         totalSupply += newAmount;
110         Transfer(0, target, newAmount);
111     }
112     
113     function setTokensPerOneETH(uint256 value) onlyOwner public returns (bool success) {
114         require(value > 0);
115         tokensPerOneETH = value;
116         return true;
117     }
118     
119     function depositFunds() payable public {
120         totalDeposit += msg.value;
121     }
122     
123     function() payable public {
124         require(msg.value > 0);
125         totalEthInWei += msg.value;
126         totalETHRaised += msg.value;
127         uint256 amount = msg.value * tokensPerOneETH;
128         require(balanceOf[owner] >= amount);
129         
130         balanceOf[owner] -= amount;
131         balanceOf[msg.sender] += amount;
132         Transfer(owner, msg.sender, amount);
133 
134         owner.transfer(msg.value);
135     }
136     
137     function getMyBalance() view public returns (uint256) {
138         return this.balance;
139     }
140     
141     function withdrawEthToOwner(uint256 amount) onlyOwner public {
142         require(amount > 0);
143         require(this.balance >= amount);
144         owner.transfer(amount);
145     }
146     
147     function withdrawAllEthToOwner() onlyOwner public {
148         require(this.balance > 0);
149         owner.transfer(this.balance);
150     }
151     
152     function transferOwnership(address newOwner) onlyOwner public {
153         address oldOwner = owner;
154         uint256 amount = balanceOf[oldOwner];
155         balanceOf[newOwner] += amount;
156         balanceOf[oldOwner] -= amount;
157         Transfer(oldOwner, newOwner, amount);
158         owner = newOwner;
159     }
160     
161     function sendMultipleAddress(address[] dests, uint256[] values) public returns (uint256) {
162         uint256 i = 0;
163         while (i < dests.length) {
164             transfer(dests[i], values[i]);
165             i += 1;
166         }
167         return i;
168     }
169 
170     function _transfer(address _from, address _to, uint _value) internal {
171         require(_to != 0x0);
172         require(balanceOf[_from] >= _value);
173         require(balanceOf[_to] + _value > balanceOf[_to]);
174         uint previousBalances = balanceOf[_from] + balanceOf[_to];
175         balanceOf[_from] -= _value;
176         balanceOf[_to] += _value;
177         Transfer(_from, _to, _value);
178         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
179     }
180 
181     function transfer(address _to, uint256 _value) public {
182         _transfer(msg.sender, _to, _value);
183     }
184 
185     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
186         require(_value <= allowance[_from][msg.sender]);
187         allowance[_from][msg.sender] -= _value;
188         _transfer(_from, _to, _value);
189         return true;
190     }
191 
192     function approve(address _spender, uint256 _value) public returns (bool success) {
193         allowance[msg.sender][_spender] = _value;
194         return true;
195     }
196 
197     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
198         tokenRecipient spender = tokenRecipient(_spender);
199         if (approve(_spender, _value)) {
200             spender.receiveApproval(msg.sender, _value, this, _extraData);
201             return true;
202         }
203     }
204 
205     function burn(uint256 _value) public returns (bool success) {
206         require(balanceOf[msg.sender] >= _value);
207         balanceOf[msg.sender] -= _value;
208         totalSupply -= _value;
209         Burn(msg.sender, _value);
210         return true;
211     }
212 
213     function burnFrom(address _from, uint256 _value) public returns (bool success) {
214         require(balanceOf[_from] >= _value);
215         require(_value <= allowance[_from][msg.sender]);
216         balanceOf[_from] -= _value;
217         allowance[_from][msg.sender] -= _value;
218         totalSupply -= _value;
219         Burn(_from, _value);
220         return true;
221     }
222 }