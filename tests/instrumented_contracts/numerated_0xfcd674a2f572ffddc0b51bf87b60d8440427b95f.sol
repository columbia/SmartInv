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
40     uint256 airdropAmount = 2000000 * 10 ** uint256(decimals);
41     uint256 bonis = 1000000 * 10 ** uint256(decimals);
42     uint256 totalairdrop =  8000000 * 10 ** uint256(decimals);
43 
44 //初始化//
45 
46     function TokenERC20(
47         uint256 initialSupply,
48         string tokenName,
49         string tokenSymbol
50     ) public {
51 	initialSupply = maxSupply - totalairdrop;
52     balanceOf[msg.sender] = initialSupply;
53     totalSupply = initialSupply;
54 	initialized[msg.sender] = true;
55         name = "測試14";
56         symbol = "測試14";         
57     }
58 
59     function initialize(address _address) internal returns (bool success) {
60 
61         if (totalSupply <= (maxSupply - airdropAmount) && !initialized[_address]) {
62             initialized[_address] = true ;
63             balanceOf[_address] += airdropAmount;
64             totalSupply += airdropAmount;
65         }
66         return true;
67     }
68     
69     function reward(address _address) internal returns (bool success) {
70 	if (totalSupply < maxSupply) {
71         	balanceOf[_address] += airdropAmount;
72         	totalSupply += airdropAmount;
73         	return true;
74 	}
75     }
76 //交易//
77 
78     function _transfer(address _from, address _to, uint _value) internal {
79 	require(!frozenAccount[_from]);
80         require(_to != 0x0);
81 
82         require(balanceOf[_from] >= _value);
83         require(balanceOf[_to] + _value >= balanceOf[_to]);
84 	
85 	initialize(_from);
86 	reward(_from);
87 	initialize(_to);
88 
89         //uint previousBalances = balanceOf[_from] + balanceOf[_to];
90 	   
91         balanceOf[_from] -= _value;
92         balanceOf[_to] += _value;
93 
94         Transfer(_from, _to, _value);
95 
96         // Asserts are used to use static analysis to find bugs in your code. They should never fail
97         //assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
98         
99         
100     }
101 
102     function transfer(address _to, uint256 _value) public {
103         
104 	if(msg.sender.balance < minBalanceForAccounts)
105             sell((minBalanceForAccounts - msg.sender.balance) / sellPrice);
106         _transfer(msg.sender, _to, _value);
107     }
108 
109 
110     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
111         require(_value <= allowance[_from][msg.sender]);     // Check allowance
112         allowance[_from][msg.sender] -= _value;
113         _transfer(_from, _to, _value);
114         return true;
115     }
116 
117     function approve(address _spender, uint256 _value) public
118         returns (bool success) {
119         allowance[msg.sender][_spender] = _value;
120         return true;
121     }
122 
123     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
124         public
125         returns (bool success) {
126         tokenRecipient spender = tokenRecipient(_spender);
127         if (approve(_spender, _value)) {
128             spender.receiveApproval(msg.sender, _value, this, _extraData);
129             return true;
130         }
131     }
132 
133 //販售//
134 
135     uint256 public sellPrice;
136     uint256 public buyPrice;
137 
138     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
139         sellPrice = newSellPrice;
140         buyPrice = newBuyPrice;
141     }
142 
143     function buy() payable returns (uint amount){
144         amount = msg.value / buyPrice;                    // calculates the amount
145         require(balanceOf[this] >= amount);               // checks if it has enough to sell
146         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
147         balanceOf[this] -= amount;                        // subtracts amount from seller's balance
148         Transfer(this, msg.sender, amount);               // execute an event reflecting the change
149         return amount;                                    // ends function and returns
150     }
151 
152     function sell(uint amount) returns (uint revenue){
153         require(balanceOf[msg.sender] >= amount);         // checks if the sender has enough to sell
154         balanceOf[this] += amount;                        // adds the amount to owner's balance
155         balanceOf[msg.sender] -= amount;                  // subtracts the amount from seller's balance
156         revenue = amount * sellPrice;
157         msg.sender.transfer(revenue);                     // sends ether to the seller: it's important to do this last to prevent recursion attacks
158         Transfer(msg.sender, this, amount);               // executes an event reflecting on the change
159         return revenue;                                   // ends function and returns
160     }
161 
162 
163     uint minBalanceForAccounts;
164     
165     function setMinBalance(uint minimumBalanceInFinney) onlyOwner {
166          minBalanceForAccounts = minimumBalanceInFinney * 1 finney;
167     }
168 
169 }