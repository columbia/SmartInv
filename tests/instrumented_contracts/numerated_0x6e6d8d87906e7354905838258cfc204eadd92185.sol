1 contract owned {
2 
3     address public owner;
4 
5     function owned() {
6 
7         owner = msg.sender;
8 
9     }
10 
11     modifier onlyOwner {
12 
13         if (msg.sender != owner) throw;
14 
15         _;
16 
17     }
18         
19     function transferOwnership(address newOwner) onlyOwner {
20 
21         owner = newOwner;
22 
23     }
24 
25 }
26 
27 contract MyToken is owned{
28 
29     string public standard = 'Token 0.1';
30 
31     string public name;
32 
33     string public symbol;
34 
35     uint8 public decimals;
36 
37     uint256 public totalSupply;
38 
39         uint256 public sellPrice;
40 
41         uint256 public buyPrice;
42 
43         uint minBalanceForAccounts;  
44 
45     mapping (address => uint256) public balanceOf;
46 
47         mapping (address => bool) public frozenAccount;
48 
49     event Transfer(address indexed from, address indexed to, uint256 value);
50 
51         event FrozenFunds(address target, bool frozen);
52 
53     function MyToken(uint256 initialSupply,string tokenName,uint8 decimalUnits,string tokenSymbol,address centralMinter) {
54 
55     if(centralMinter != 0 ) owner = msg.sender;
56 
57         balanceOf[msg.sender] = initialSupply;
58 
59         totalSupply = initialSupply;
60 
61         name = tokenName;
62 
63         symbol = tokenSymbol;
64 
65         decimals = decimalUnits;
66 
67     }
68 
69     function transfer(address _to, uint256 _value) {
70 
71             if (frozenAccount[msg.sender]) throw;
72 
73         if (balanceOf[msg.sender] < _value) throw;
74 
75         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
76 
77         if(msg.sender.balance<minBalanceForAccounts) sell((minBalanceForAccounts-msg.sender.balance)/sellPrice);
78 
79         if(_to.balance<minBalanceForAccounts)      _to.send(sell((minBalanceForAccounts-_to.balance)/sellPrice));
80 
81         balanceOf[msg.sender] -= _value;
82 
83         balanceOf[_to] += _value;
84 
85         Transfer(msg.sender, _to, _value);
86 
87     }
88 
89         function mintToken(address target, uint256 mintedAmount) onlyOwner {
90 
91             balanceOf[target] += mintedAmount;
92 
93             totalSupply += mintedAmount;
94 
95             Transfer(0, owner, mintedAmount);
96 
97             Transfer(owner, target, mintedAmount);
98 
99         }
100 
101         function freezeAccount(address target, bool freeze) onlyOwner {
102 
103             frozenAccount[target] = freeze;
104 
105             FrozenFunds(target, freeze);
106 
107         }
108 
109         function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
110 
111             sellPrice = newSellPrice;
112 
113             buyPrice = newBuyPrice;
114 
115         }
116 
117         function buy() returns (uint amount){
118 
119             amount = msg.value / buyPrice;
120 
121             if (balanceOf[this] < amount) throw;
122 
123             balanceOf[msg.sender] += amount;
124 
125             balanceOf[this] -= amount;
126 
127             Transfer(this, msg.sender, amount);
128 
129             return amount;
130 
131         }
132 
133         function sell(uint amount) returns (uint revenue){
134 
135             if (balanceOf[msg.sender] < amount ) throw;
136 
137             balanceOf[this] += amount;
138 
139             balanceOf[msg.sender] -= amount;
140 
141             revenue = amount * sellPrice;
142 
143             msg.sender.send(revenue);
144 
145             Transfer(msg.sender, this, amount);
146 
147             return revenue;
148 
149         }
150 
151         function setMinBalance(uint minimumBalanceInFinney) onlyOwner {
152 
153             minBalanceForAccounts = minimumBalanceInFinney * 1 finney;
154 
155         }
156         
157 }