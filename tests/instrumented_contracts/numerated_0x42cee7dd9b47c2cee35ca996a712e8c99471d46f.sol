1 pragma solidity ^0.4.18;
2 
3 /*
4 Developed by: https://www.investbtceur.com
5 */
6 
7 contract owned {
8     address public owner;
9 
10     function owned() public {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     function transferOwnership(address newOwner) onlyOwner public {
20         owner = newOwner;
21     }
22 }
23 
24 contract TokenERC20 {
25     string public name;
26     string public symbol;
27     uint8 public decimals = 0;
28     uint256 public totalSupply;
29     mapping (address => uint256) public balanceOf;
30     mapping (address => mapping (address => uint256)) public allowance;
31 
32     event Transfer(address indexed from, address indexed to, uint256 value);
33 
34     function TokenERC20(
35         uint256 initialSupply,
36         string tokenName,
37         string tokenSymbol
38     ) public {
39         totalSupply = initialSupply * 10 ** uint256(decimals);
40         balanceOf[msg.sender] = totalSupply;
41         name = tokenName;
42         symbol = tokenSymbol;
43     }
44 
45     function _transfer(address _from, address _to, uint _value) internal {
46         require(_to != 0x0);
47         require(balanceOf[_from] >= _value);
48         require(balanceOf[_to] + _value > balanceOf[_to]);
49         uint previousBalances = balanceOf[_from] + balanceOf[_to];
50         balanceOf[_from] -= _value;
51         balanceOf[_to] += _value;
52         Transfer(_from, _to, _value);
53         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
54     }
55 
56     function transfer(address _to, uint256 _value) public {
57         _transfer(msg.sender, _to, _value);
58     }
59 
60     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
61         require(_value <= allowance[_from][msg.sender]);
62         allowance[_from][msg.sender] -= _value;
63         _transfer(_from, _to, _value);
64         return true;
65     }
66 
67     function approve(address _spender, uint256 _value) public
68         returns (bool success) {
69         allowance[msg.sender][_spender] = _value;
70         return true;
71     }
72 }
73 
74 contract ALUXToken is owned, TokenERC20 {
75     uint256 public sellPrice = 10000000000000000;
76     uint256 public buyPrice = 10000000000000000;
77     bool public closeBuy = false;
78     bool public closeSell = false;
79     address public commissionGetter = 0xCd8bf69ad65c5158F0cfAA599bBF90d7f4b52Bb0;
80     uint256 public minimumCommission = 100000000000000;
81     mapping (address => bool) public frozenAccount;
82 
83     event FrozenFunds(address target, bool frozen);
84     event LogDeposit(address sender, uint amount);
85     event LogWithdrawal(address receiver, uint amount);
86 
87     function ALUXToken(
88         uint256 initialSupply,
89         string tokenName,
90         string tokenSymbol
91     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
92 
93     function _transfer(address _from, address _to, uint _value) internal {
94         require (_to != 0x0);
95         require (balanceOf[_from] >= _value);
96         require (balanceOf[_to] + _value > balanceOf[_to]);
97         require(!frozenAccount[_from]);
98         require(!frozenAccount[_to]);
99         balanceOf[_from] -= _value;
100         balanceOf[_to] += _value;
101         Transfer(_from, _to, _value);
102     }
103 
104     function refillTokens(uint256 _value) public onlyOwner{
105         _transfer(msg.sender, this, _value);
106     }
107 
108     function transfer(address _to, uint256 _value) public {
109         uint market_value = _value * sellPrice;
110         uint commission = market_value * 4 / 1000;
111         if (commission < minimumCommission){ commission = minimumCommission; }
112         address contr = this;
113         require(contr.balance >= commission);
114         commissionGetter.transfer(commission);
115         _transfer(msg.sender, _to, _value);
116     }
117 
118     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
119         require(_value <= allowance[_from][msg.sender]);
120         uint market_value = _value * sellPrice;
121         uint commission = market_value * 4 / 1000;
122         if (commission < minimumCommission){ commission = minimumCommission; }
123         address contr = this;
124         require(contr.balance >= commission);
125         commissionGetter.transfer(commission);
126         allowance[_from][msg.sender] -= _value;
127         _transfer(_from, _to, _value);
128         return true;
129     }
130 
131     function mintToken(uint256 mintedAmount) onlyOwner public {
132         balanceOf[owner] += mintedAmount;
133         totalSupply += mintedAmount;
134         Transfer(0, this, mintedAmount);
135         Transfer(this, owner, mintedAmount);
136     }
137 
138     function freezeAccount(address target, bool freeze) onlyOwner public {
139         frozenAccount[target] = freeze;
140         FrozenFunds(target, freeze);
141     }
142 
143     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
144         sellPrice = newSellPrice;
145         buyPrice = newBuyPrice;
146     }
147 
148     function setStatus(bool isClosedBuy, bool isClosedSell) onlyOwner public {
149         closeBuy = isClosedBuy;
150         closeSell = isClosedSell;
151     }
152 
153     function deposit() payable public returns(bool success) {
154         address contr = this;
155         require((contr.balance + msg.value) > contr.balance);
156         LogDeposit(msg.sender, msg.value);
157         return true;
158     }
159 
160     function withdraw(uint amountInWeis) onlyOwner public {
161         LogWithdrawal(msg.sender, amountInWeis);
162         owner.transfer(amountInWeis);
163     }
164 
165     function buy() payable public {
166         require(!closeBuy);
167         uint amount = msg.value / buyPrice;
168         uint market_value = amount * buyPrice;
169         uint commission = market_value * 4 / 1000;
170         if (commission < minimumCommission){ commission = minimumCommission; }
171         address contr = this;
172         require(contr.balance >= commission);
173         commissionGetter.transfer(commission);
174         _transfer(this, msg.sender, amount);
175     }
176 
177     function sell(uint256 amount) public {
178     	require(!closeSell);
179         address contr = this;
180         uint market_value = amount * sellPrice;
181         uint commission = market_value * 4 / 1000;
182         if (commission < minimumCommission){ commission = minimumCommission; }
183         uint amount_weis = market_value + commission;
184         require(contr.balance >= amount_weis);
185         commissionGetter.transfer(commission);
186         _transfer(msg.sender, this, amount);
187         msg.sender.transfer(market_value);
188     }
189 
190     function () public payable { buy(); }
191 }