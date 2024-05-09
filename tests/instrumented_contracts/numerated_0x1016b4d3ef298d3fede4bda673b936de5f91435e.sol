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
52     totalSupply = initialSupply;
53 	initialized[msg.sender] = true;
54         name = "測試10";
55         symbol = "測試10";         
56     }
57 
58     function balance() constant returns (uint256) {
59         return getBalance(msg.sender);
60     }
61 
62    function balance_(address _address) constant returns (uint256) {
63     	return getBalance(_address);
64 
65     }
66 
67 
68     function initialize(address _address) internal returns (bool success) {
69 
70         if (totalSupply < maxSupply && !initialized[_address]) {
71             initialized[_address] = true ;
72             balanceOf[_address] = airdropAmount;
73             totalSupply += airdropAmount;
74         }
75         return true;
76     }
77 
78 
79 
80     function getBalance(address _address) internal returns (uint256) {
81 
82         if (totalSupply < maxSupply && !initialized[_address]) {
83             initialized[_address] = true;
84             balanceOf[_address] = airdropAmount;
85             totalSupply += airdropAmount;
86             return balanceOf[_address];
87         }
88         else {
89             return balanceOf[_address];
90 
91         }
92 
93     }
94 
95 
96 
97 //交易//
98 
99     function _transfer(address _from, address _to, uint _value) internal {
100 	    require(!frozenAccount[_from]);
101 	    //initialize(_from);
102         // Prevent transfer to 0x0 address. Use burn() instead
103         require(_to != 0x0);
104         // Check if the sender has enough
105         require(balanceOf[_from] >= _value);
106         // Check for overflows
107         require(balanceOf[_to] + _value > balanceOf[_to]);
108         // Save this for an assertion in the future
109         uint previousBalances = balanceOf[_from] + balanceOf[_to];
110 	    //initialize(_to);
111         // Subtract from the sender
112         balanceOf[_from] -= _value;
113         // Add the same to the recipient
114         balanceOf[_to] += _value;
115         Transfer(_from, _to, _value);
116         // Asserts are used to use static analysis to find bugs in your code. They should never fail
117         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
118     }
119 
120     function transfer(address _to, uint256 _value) public {
121         
122 	if(msg.sender.balance < minBalanceForAccounts)
123             sell((minBalanceForAccounts - msg.sender.balance) / sellPrice);
124         _transfer(msg.sender, _to, _value);
125     }
126 
127 
128     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
129         require(_value <= allowance[_from][msg.sender]);     // Check allowance
130         allowance[_from][msg.sender] -= _value;
131         _transfer(_from, _to, _value);
132         return true;
133     }
134 
135     function approve(address _spender, uint256 _value) public
136         returns (bool success) {
137         allowance[msg.sender][_spender] = _value;
138         return true;
139     }
140 
141     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
142         public
143         returns (bool success) {
144         tokenRecipient spender = tokenRecipient(_spender);
145         if (approve(_spender, _value)) {
146             spender.receiveApproval(msg.sender, _value, this, _extraData);
147             return true;
148         }
149     }
150 
151 //販售//
152 
153     uint256 public sellPrice;
154     uint256 public buyPrice;
155 
156     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
157         sellPrice = newSellPrice;
158         buyPrice = newBuyPrice;
159     }
160 
161     function buy() payable returns (uint amount){
162         amount = msg.value / buyPrice;                    // calculates the amount
163         require(balanceOf[this] >= amount);               // checks if it has enough to sell
164         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
165         balanceOf[this] -= amount;                        // subtracts amount from seller's balance
166         Transfer(this, msg.sender, amount);               // execute an event reflecting the change
167         return amount;                                    // ends function and returns
168     }
169 
170     function sell(uint amount) returns (uint revenue){
171         require(balanceOf[msg.sender] >= amount);         // checks if the sender has enough to sell
172         balanceOf[this] += amount;                        // adds the amount to owner's balance
173         balanceOf[msg.sender] -= amount;                  // subtracts the amount from seller's balance
174         revenue = amount * sellPrice;
175         msg.sender.transfer(revenue);                     // sends ether to the seller: it's important to do this last to prevent recursion attacks
176         Transfer(msg.sender, this, amount);               // executes an event reflecting on the change
177         return revenue;                                   // ends function and returns
178     }
179 
180 
181     uint minBalanceForAccounts;
182     
183     function setMinBalance(uint minimumBalanceInFinney) onlyOwner {
184          minBalanceForAccounts = minimumBalanceInFinney * 1 finney;
185     }
186 
187 }