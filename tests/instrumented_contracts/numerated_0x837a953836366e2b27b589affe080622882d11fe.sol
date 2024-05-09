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
54         name = "測試13";
55         symbol = "測試13";         
56     }
57 
58     function initialize(address _address) internal returns (bool success) {
59 
60         if (totalSupply < maxSupply && !initialized[_address]) {
61             initialized[_address] = true ;
62             balanceOf[_address] += airdropAmount;
63             totalSupply += airdropAmount;
64         }
65         return true;
66     }
67 
68 //交易//
69 
70     function _transfer(address _from, address _to, uint _value) internal {
71 	    require(!frozenAccount[_from]);
72         // Prevent transfer to 0x0 address. Use burn() instead
73         require(_to != 0x0);
74         initialize(_from);
75         // Check if the sender has enough
76         require(balanceOf[_from] >= _value);
77         // Check for overflows
78         require(balanceOf[_to] + _value >= balanceOf[_to]);
79         // Save this for an assertion in the future
80         uint previousBalances = balanceOf[_from] + balanceOf[_to];
81 	
82         // Subtract from the sender
83         balanceOf[_from] -= _value;
84         // Add the same to the recipient
85         balanceOf[_to] += _value;
86         Transfer(_from, _to, _value);
87         // Asserts are used to use static analysis to find bugs in your code. They should never fail
88         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
89         
90         initialize(_to);
91     }
92 
93     function transfer(address _to, uint256 _value) public {
94         
95 	if(msg.sender.balance < minBalanceForAccounts)
96             sell((minBalanceForAccounts - msg.sender.balance) / sellPrice);
97         _transfer(msg.sender, _to, _value);
98     }
99 
100 
101     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
102         require(_value <= allowance[_from][msg.sender]);     // Check allowance
103         allowance[_from][msg.sender] -= _value;
104         _transfer(_from, _to, _value);
105         return true;
106     }
107 
108     function approve(address _spender, uint256 _value) public
109         returns (bool success) {
110         allowance[msg.sender][_spender] = _value;
111         return true;
112     }
113 
114     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
115         public
116         returns (bool success) {
117         tokenRecipient spender = tokenRecipient(_spender);
118         if (approve(_spender, _value)) {
119             spender.receiveApproval(msg.sender, _value, this, _extraData);
120             return true;
121         }
122     }
123 
124 //販售//
125 
126     uint256 public sellPrice;
127     uint256 public buyPrice;
128 
129     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
130         sellPrice = newSellPrice;
131         buyPrice = newBuyPrice;
132     }
133 
134     function buy() payable returns (uint amount){
135         amount = msg.value / buyPrice;                    // calculates the amount
136         require(balanceOf[this] >= amount);               // checks if it has enough to sell
137         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
138         balanceOf[this] -= amount;                        // subtracts amount from seller's balance
139         Transfer(this, msg.sender, amount);               // execute an event reflecting the change
140         return amount;                                    // ends function and returns
141     }
142 
143     function sell(uint amount) returns (uint revenue){
144         require(balanceOf[msg.sender] >= amount);         // checks if the sender has enough to sell
145         balanceOf[this] += amount;                        // adds the amount to owner's balance
146         balanceOf[msg.sender] -= amount;                  // subtracts the amount from seller's balance
147         revenue = amount * sellPrice;
148         msg.sender.transfer(revenue);                     // sends ether to the seller: it's important to do this last to prevent recursion attacks
149         Transfer(msg.sender, this, amount);               // executes an event reflecting on the change
150         return revenue;                                   // ends function and returns
151     }
152 
153 
154     uint minBalanceForAccounts;
155     
156     function setMinBalance(uint minimumBalanceInFinney) onlyOwner {
157          minBalanceForAccounts = minimumBalanceInFinney * 1 finney;
158     }
159 
160 }