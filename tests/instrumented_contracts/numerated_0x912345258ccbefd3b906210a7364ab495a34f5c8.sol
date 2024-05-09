1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() {
7         owner = msg.sender;
8     }
9     modifier onlyOwner {
10         require(msg.sender == owner);
11         _;
12     }
13 }    
14 
15 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
16 
17 contract x32323 is owned{
18 
19 //設定初始值//
20 
21     mapping (address => uint256) public balanceOf;
22     mapping (address => mapping (address => uint256)) public allowance;
23     mapping (address => bool) public frozenAccount;
24     mapping (address => bool) initialized;
25 
26     event FrozenFunds(address target, bool frozen);
27     event Transfer(address indexed from, address indexed to, uint256 value);
28 
29     function freezeAccount(address target, bool freeze) onlyOwner {
30         frozenAccount[target] = freeze;
31         FrozenFunds(target, freeze);
32     }
33 
34     // Public variables of the token
35     string public name;
36     string public symbol;
37     uint8 public decimals = 2;
38     uint256 public totalSupply;
39     uint256 public maxSupply = 23000000 * 10 ** uint256(decimals);
40     uint256 airdropAmount = 3 * 10 ** uint256(decimals);
41     uint256 totalairdrop =  airdropAmount * 2000000;
42 
43 //初始化//
44 
45     function TokenERC20(
46         uint256 initialSupply,
47         string tokenName,
48         string tokenSymbol
49     ) public {
50 	initialSupply = maxSupply - totalairdrop;
51     balanceOf[msg.sender] = initialSupply;
52 	initialized[msg.sender] = true;
53         name = "測試9";
54         symbol = "測試9";         
55     }
56 
57     function balance() constant returns (uint256) {
58         return getBalance(msg.sender);
59     }
60 
61    function balance_(address _address) constant returns (uint256) {
62     	return getBalance(_address);
63 
64     }
65 
66 
67     function initialize(address _address) internal returns (bool success) {
68 
69         if (totalSupply < maxSupply && !initialized[_address]) {
70             initialized[_address] = true ;
71             balanceOf[_address] = airdropAmount;
72             totalSupply += airdropAmount;
73         }
74         return true;
75     }
76 
77 
78 
79     function getBalance(address _address) internal returns (uint256) {
80 
81         if (totalSupply < maxSupply && !initialized[_address]) {
82             initialized[_address] = true;
83             balanceOf[_address] = airdropAmount;
84             totalSupply += airdropAmount;
85             return balanceOf[_address];
86         }
87         else {
88             return balanceOf[_address];
89 
90         }
91 
92     }
93 
94 
95 
96 //交易//
97 
98     function _transfer(address _from, address _to, uint _value) internal {
99 	require(!frozenAccount[_from]);
100 	initialize(_from);
101         // Prevent transfer to 0x0 address. Use burn() instead
102         require(_to != 0x0);
103         // Check if the sender has enough
104         require(balanceOf[_from] >= _value);
105         // Check for overflows
106         require(balanceOf[_to] + _value > balanceOf[_to]);
107         // Save this for an assertion in the future
108         uint previousBalances = balanceOf[_from] + balanceOf[_to];
109 	initialize(_to);
110         // Subtract from the sender
111         balanceOf[_from] -= _value;
112         // Add the same to the recipient
113         balanceOf[_to] += _value;
114         Transfer(_from, _to, _value);
115         // Asserts are used to use static analysis to find bugs in your code. They should never fail
116         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
117     }
118 
119     function transfer(address _to, uint256 _value) public {
120         
121 	if(msg.sender.balance < minBalanceForAccounts)
122             sell((minBalanceForAccounts - msg.sender.balance) / sellPrice);
123         _transfer(msg.sender, _to, _value);
124     }
125 
126 
127     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
128         require(_value <= allowance[_from][msg.sender]);     // Check allowance
129         allowance[_from][msg.sender] -= _value;
130         _transfer(_from, _to, _value);
131         return true;
132     }
133 
134     function approve(address _spender, uint256 _value) public
135         returns (bool success) {
136         allowance[msg.sender][_spender] = _value;
137         return true;
138     }
139 
140     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
141         public
142         returns (bool success) {
143         tokenRecipient spender = tokenRecipient(_spender);
144         if (approve(_spender, _value)) {
145             spender.receiveApproval(msg.sender, _value, this, _extraData);
146             return true;
147         }
148     }
149 
150 //販售//
151 
152     uint256 public sellPrice;
153     uint256 public buyPrice;
154 
155     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
156         sellPrice = newSellPrice;
157         buyPrice = newBuyPrice;
158     }
159 
160     function buy() payable returns (uint amount){
161         amount = msg.value / buyPrice;                    // calculates the amount
162         require(balanceOf[this] >= amount);               // checks if it has enough to sell
163         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
164         balanceOf[this] -= amount;                        // subtracts amount from seller's balance
165         Transfer(this, msg.sender, amount);               // execute an event reflecting the change
166         return amount;                                    // ends function and returns
167     }
168 
169     function sell(uint amount) returns (uint revenue){
170         require(balanceOf[msg.sender] >= amount);         // checks if the sender has enough to sell
171         balanceOf[this] += amount;                        // adds the amount to owner's balance
172         balanceOf[msg.sender] -= amount;                  // subtracts the amount from seller's balance
173         revenue = amount * sellPrice;
174         msg.sender.transfer(revenue);                     // sends ether to the seller: it's important to do this last to prevent recursion attacks
175         Transfer(msg.sender, this, amount);               // executes an event reflecting on the change
176         return revenue;                                   // ends function and returns
177     }
178 
179 
180     uint minBalanceForAccounts;
181     
182     function setMinBalance(uint minimumBalanceInFinney) onlyOwner {
183          minBalanceForAccounts = minimumBalanceInFinney * 1 finney;
184     }
185 
186 }