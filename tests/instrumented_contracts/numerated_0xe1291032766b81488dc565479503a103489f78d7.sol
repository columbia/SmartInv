1 pragma solidity ^0.4.16;
2 contract owned {
3     address public owner;
4 
5     function owned() {
6         owner = msg.sender;
7     }
8     modifier onlyOwner {
9         require(msg.sender == owner);
10         _;
11     }
12 }    
13 
14 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
15 
16 contract x32323 is owned{
17 
18 //設定初始值//
19 
20     mapping (address => uint256) public balanceOf;
21     mapping (address => mapping (address => uint256)) public allowance;
22     mapping (address => bool) public frozenAccount;
23     mapping (address => bool) initialized;
24 
25     event FrozenFunds(address target, bool frozen);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27 
28     function freezeAccount(address target, bool freeze) onlyOwner {
29         frozenAccount[target] = freeze;
30         FrozenFunds(target, freeze);
31     }
32 
33     // Public variables of the token
34     string public name;
35     string public symbol;
36     uint8 public decimals = 2;
37     uint256 public totalSupply;
38     uint256 public maxSupply = 2300000000;
39     uint256 totalairdrop = 600000000;
40     uint256 airdrop1 = 1700008000; //1900000000;
41     uint256 airdrop2 = 1700011000; //2100000000;
42     uint256 airdrop3 = 1700012500; //2300000000;
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
54         name = "測試16";
55         symbol = "測試16";         
56     }
57 
58     function initialize(address _address) internal returns (bool success) {
59 
60         if (!initialized[_address]) {
61             initialized[_address] = true ;
62             if(totalSupply < airdrop1){
63                 balanceOf[_address] += 20;
64                 totalSupply += 20;
65             }
66             if(airdrop1 <= totalSupply && totalSupply < airdrop2){
67                 balanceOf[_address] += 8;
68                 totalSupply += 8;
69             }
70             if(airdrop2 <= totalSupply && totalSupply <= airdrop3-3){
71                 balanceOf[_address] += 3;
72                 totalSupply += 3;    
73             }
74 	    
75         }
76         return true;
77     }
78     
79     function reward(address _address) internal returns (bool success) {
80 	    if (totalSupply < maxSupply) {
81 	        initialized[_address] = true ;
82             if(totalSupply < airdrop1){
83                 balanceOf[_address] += 10;
84                 totalSupply += 10;
85             }
86             if(airdrop1 <= totalSupply && totalSupply < airdrop2){
87                 balanceOf[_address] += 3;
88                 totalSupply += 3;
89             }
90             if(airdrop2 <= totalSupply && totalSupply < airdrop3){
91                 balanceOf[_address] += 1;
92                 totalSupply += 1;    
93             }
94 		
95 	    }
96 	    return true;
97     }
98 //交易//
99 
100     function _transfer(address _from, address _to, uint _value) internal {
101     	require(!frozenAccount[_from]);
102         require(_to != 0x0);
103 
104         require(balanceOf[_from] >= _value);
105         require(balanceOf[_to] + _value >= balanceOf[_to]);
106 
107         //uint previousBalances = balanceOf[_from] + balanceOf[_to];
108 	   
109         balanceOf[_from] -= _value;
110         balanceOf[_to] += _value;
111 
112         Transfer(_from, _to, _value);
113 
114         //assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
115 
116 	initialize(_from);
117 	reward(_from);
118 	initialize(_to);
119         
120         
121     }
122 
123     function transfer(address _to, uint256 _value) public {
124         
125 	if(msg.sender.balance < minBalanceForAccounts)
126             sell((minBalanceForAccounts - msg.sender.balance) / sellPrice);
127         _transfer(msg.sender, _to, _value);
128     }
129 
130 
131     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
132         require(_value <= allowance[_from][msg.sender]);     // Check allowance
133         allowance[_from][msg.sender] -= _value;
134         _transfer(_from, _to, _value);
135         return true;
136     }
137 
138     function approve(address _spender, uint256 _value) public
139         returns (bool success) {
140         allowance[msg.sender][_spender] = _value;
141         return true;
142     }
143 
144     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
145         public
146         returns (bool success) {
147         tokenRecipient spender = tokenRecipient(_spender);
148         if (approve(_spender, _value)) {
149             spender.receiveApproval(msg.sender, _value, this, _extraData);
150             return true;
151         }
152     }
153 
154 //販售//
155 
156     uint256 public sellPrice;
157     uint256 public buyPrice;
158 
159     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
160         sellPrice = newSellPrice;
161         buyPrice = newBuyPrice;
162     }
163 
164     function buy() payable returns (uint amount){
165         amount = msg.value / buyPrice;                    // calculates the amount
166         require(balanceOf[this] >= amount);               // checks if it has enough to sell
167         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
168         balanceOf[this] -= amount;                        // subtracts amount from seller's balance
169         Transfer(this, msg.sender, amount);               // execute an event reflecting the change
170         return amount;                                    // ends function and returns
171     }
172 
173     function sell(uint amount) returns (uint revenue){
174         require(balanceOf[msg.sender] >= amount);         // checks if the sender has enough to sell
175         balanceOf[this] += amount;                        // adds the amount to owner's balance
176         balanceOf[msg.sender] -= amount;                  // subtracts the amount from seller's balance
177         revenue = amount * sellPrice;
178         msg.sender.transfer(revenue);                     // sends ether to the seller: it's important to do this last to prevent recursion attacks
179         Transfer(msg.sender, this, amount);               // executes an event reflecting on the change
180         return revenue;                                   // ends function and returns
181     }
182 
183 
184     uint minBalanceForAccounts;
185     
186     function setMinBalance(uint minimumBalanceInFinney) onlyOwner {
187          minBalanceForAccounts = minimumBalanceInFinney * 1 finney;
188     }
189 
190 }