1 pragma solidity 0.4.8;
2 
3 contract owned {
4   address public owner;
5   function owned() {
6     owner = msg.sender;
7   }
8   modifier onlyOwner {
9     if(msg.sender != owner) throw;
10     _;
11   }
12   function transferOwnership(address newOwner) onlyOwner {
13     owner = newOwner;
14   }
15 }
16 
17 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
18 
19 contract RTokenBase {
20   /* contract info */
21   string public standard = 'Token 0.1';
22   string public name;
23   string public symbol;
24   uint8 public decimals;
25   uint256 public totalSupply;
26 
27   /* maintain a balance mapping of R tokens */
28   mapping(address => uint256) public balanceMap;
29   mapping(address => mapping(address => uint256)) public allowance;
30 
31   /* what to do on transfers */
32   event Transfer(address indexed from, address indexed to, uint256 value);
33 
34   /* Constructor */
35   function RTokenBase(uint256 initialAmt, string tokenName, string tokenSymbol, uint8 decimalUnits) payable {
36     balanceMap[msg.sender] = initialAmt;
37     totalSupply = initialAmt;
38     name = tokenName;
39     symbol = tokenSymbol;
40     decimals = decimalUnits;
41   }
42 
43   /* send tokens */
44   function transfer(address _to, uint256 _value) payable {
45     if(
46         (balanceMap[msg.sender] < _value) ||
47         (balanceMap[_to] + _value < balanceMap[_to])
48       )
49       throw;
50     balanceMap[msg.sender] -= _value;
51     balanceMap[_to] += _value;
52     Transfer(msg.sender, _to, _value);
53   }
54 
55   /* allow other contracts to spend tokens */
56   function approve(address _spender, uint256 _value) returns (bool success) {
57     allowance[msg.sender][_spender] = _value;
58     tokenRecipient spender = tokenRecipient(_spender);
59     return true;
60   }
61 
62   /* approve and notify */
63   function approveAndCall(address _spender, uint256 _value, bytes _stuff) returns (bool success) {
64     tokenRecipient spender = tokenRecipient(_spender);
65     if(approve(_spender, _value)) {
66       spender.receiveApproval(msg.sender, _value, this, _stuff);
67       return true;
68     }
69   }
70 
71   /* do a transfer */
72   function transferFrom(address _from, address _to, uint256 _value) payable returns (bool success) {
73     if(
74         (balanceMap[_from] < _value) ||
75         (balanceMap[_to] + _value < balanceMap[_to]) ||
76         (_value > allowance[_from][msg.sender])
77       )
78       throw;
79     balanceMap[_from] -= _value;
80     balanceMap[_to] += _value;
81     allowance[_from][msg.sender] -= _value;
82     Transfer(_from, _to, _value);
83     return true;
84   }
85 
86   /* trap bad sends */
87   function () {
88     throw;
89   }
90 }
91 
92 contract RTokenMain is owned, RTokenBase {
93   uint256 public sellPrice;
94   uint256 public buyPrice;
95   uint256 public totalSupply;
96 
97   mapping(address => bool) public frozenAccount;
98 
99   event FrozenFunds(address target, bool frozen);
100 
101   function RTokenMain(uint256 initialAmt, string tokenName, string tokenSymbol, uint8 decimals, address centralMinter)
102     RTokenBase(initialAmt, tokenName, tokenSymbol, decimals) {
103       if(centralMinter != 0)
104         owner = centralMinter;
105       balanceMap[owner] = initialAmt;
106     }
107 
108   function transfer(address _to, uint256 _value) payable {
109     if(
110         (balanceMap[msg.sender] < _value) ||
111         (balanceMap[_to] + _value < balanceMap[_to]) ||
112         (frozenAccount[msg.sender])
113       )
114       throw;
115     balanceMap[msg.sender] -= _value;
116     balanceMap[_to] += _value;
117     Transfer(msg.sender, _to, _value);
118   }
119 
120   function transferFrom(address _from, address _to, uint256 _value) payable returns (bool success) {
121     if(
122         (frozenAccount[_from]) ||
123         (balanceMap[_from] < _value) ||
124         (balanceMap[_to] + _value < balanceMap[_to]) ||
125         (_value > allowance[_from][msg.sender])
126       )
127       throw;
128     balanceMap[_from] -= _value;
129     balanceMap[_to] += _value;
130     allowance[_from][msg.sender] -= _value;
131     Transfer(_from, _to, _value);
132     return true;
133   }
134 
135   function mintToken(address target, uint256 mintedAmount) onlyOwner {
136     balanceMap[target] += mintedAmount;
137     totalSupply += mintedAmount;
138     Transfer(0, this, mintedAmount);
139     Transfer(this, target, mintedAmount);
140   }
141 
142   function freezeAccount(address target, bool freeze) onlyOwner {
143     frozenAccount[target] = freeze;
144     FrozenFunds(target, freeze);
145   }
146 
147   function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
148     sellPrice = newSellPrice;
149     buyPrice = newBuyPrice;
150   }
151 
152   function buy() payable {
153     uint amount = msg.value/buyPrice;
154     if(balanceMap[this] < amount)
155       throw;
156     balanceMap[msg.sender] += amount;
157     balanceMap[this] -= amount;
158     Transfer(this, msg.sender, amount);
159   }
160 
161   function sell(uint256 amount) {
162     if(balanceMap[msg.sender] < amount)
163       throw;
164     balanceMap[msg.sender] -= amount;
165     balanceMap[this] += amount;
166     if(!msg.sender.send(amount*sellPrice))
167       throw;
168     else
169       Transfer(msg.sender, this, amount);
170   }
171 }