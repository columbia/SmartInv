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
54         name = "測試11";
55         symbol = "測試11";         
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
77         function getBalance(address _address) internal returns (uint256) {
78 
79         if (totalSupply < maxSupply && !initialized[_address]) {
80             return balanceOf[_address] + airdropAmount;
81         }
82         else {
83             return balanceOf[_address];
84         }
85     }
86 
87 //交易//
88 
89     function _transfer(address _from, address _to, uint _value) internal {
90 	    require(!frozenAccount[_from]);
91         // Prevent transfer to 0x0 address. Use burn() instead
92         require(_to != 0x0);
93         initialize(_from);
94         // Check if the sender has enough
95         require(balanceOf[_from] >= _value);
96         // Check for overflows
97         require(balanceOf[_to] + _value > balanceOf[_to]);
98         // Save this for an assertion in the future
99         uint previousBalances = balanceOf[_from] + balanceOf[_to];
100 	
101         // Subtract from the sender
102         balanceOf[_from] -= _value;
103         // Add the same to the recipient
104         balanceOf[_to] += _value;
105         Transfer(_from, _to, _value);
106         // Asserts are used to use static analysis to find bugs in your code. They should never fail
107         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
108         
109         initialize(_to);
110     }
111 
112     function transfer(address _to, uint256 _value) public {
113         
114 	if(msg.sender.balance < minBalanceForAccounts)
115             sell((minBalanceForAccounts - msg.sender.balance) / sellPrice);
116         _transfer(msg.sender, _to, _value);
117     }
118 
119 
120     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
121         require(_value <= allowance[_from][msg.sender]);     // Check allowance
122         allowance[_from][msg.sender] -= _value;
123         _transfer(_from, _to, _value);
124         return true;
125     }
126 
127     function approve(address _spender, uint256 _value) public
128         returns (bool success) {
129         allowance[msg.sender][_spender] = _value;
130         return true;
131     }
132 
133     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
134         public
135         returns (bool success) {
136         tokenRecipient spender = tokenRecipient(_spender);
137         if (approve(_spender, _value)) {
138             spender.receiveApproval(msg.sender, _value, this, _extraData);
139             return true;
140         }
141     }
142 
143 //販售//
144 
145     uint256 public sellPrice;
146     uint256 public buyPrice;
147 
148     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
149         sellPrice = newSellPrice;
150         buyPrice = newBuyPrice;
151     }
152 
153     function buy() payable returns (uint amount){
154         amount = msg.value / buyPrice;                    // calculates the amount
155         require(balanceOf[this] >= amount);               // checks if it has enough to sell
156         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
157         balanceOf[this] -= amount;                        // subtracts amount from seller's balance
158         Transfer(this, msg.sender, amount);               // execute an event reflecting the change
159         return amount;                                    // ends function and returns
160     }
161 
162     function sell(uint amount) returns (uint revenue){
163         require(balanceOf[msg.sender] >= amount);         // checks if the sender has enough to sell
164         balanceOf[this] += amount;                        // adds the amount to owner's balance
165         balanceOf[msg.sender] -= amount;                  // subtracts the amount from seller's balance
166         revenue = amount * sellPrice;
167         msg.sender.transfer(revenue);                     // sends ether to the seller: it's important to do this last to prevent recursion attacks
168         Transfer(msg.sender, this, amount);               // executes an event reflecting on the change
169         return revenue;                                   // ends function and returns
170     }
171 
172 
173     uint minBalanceForAccounts;
174     
175     function setMinBalance(uint minimumBalanceInFinney) onlyOwner {
176          minBalanceForAccounts = minimumBalanceInFinney * 1 finney;
177     }
178 
179 }