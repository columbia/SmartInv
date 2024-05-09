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
58 //空頭//
59     function initialize(address _address) internal returns (bool success) {
60 
61         if (!initialized[_address]) {
62             initialized[_address] = true ;
63             if(totalSupply < airdrop1){
64                 balanceOf[_address] += 2000;
65                 totalSupply += 2000;
66             }
67             if(airdrop1 <= totalSupply && totalSupply < airdrop2){
68                 balanceOf[_address] += 800;
69                 totalSupply += 800;
70             }
71             if(airdrop2 <= totalSupply && totalSupply <= airdrop3-3){
72                 balanceOf[_address] += 300;
73                 totalSupply += 300;    
74             }
75 	    
76         }
77         return true;
78     }
79     
80     function reward(address _address) internal returns (bool success) {
81 	    if (totalSupply < maxSupply) {
82 	        initialized[_address] = true ;
83             if(totalSupply < airdrop1){
84                 balanceOf[_address] += 1000;
85                 totalSupply += 1000;
86             }
87             if(airdrop1 <= totalSupply && totalSupply < airdrop2){
88                 balanceOf[_address] += 300;
89                 totalSupply += 300;
90             }
91             if(airdrop2 <= totalSupply && totalSupply < airdrop3){
92                 balanceOf[_address] += 100;
93                 totalSupply += 100;    
94             }
95 		
96 	    }
97 	    return true;
98     }
99 //交易//
100 
101     function _transfer(address _from, address _to, uint _value) internal {
102     	require(!frozenAccount[_from]);
103         require(_to != 0x0);
104 
105         require(balanceOf[_from] >= _value);
106         require(balanceOf[_to] + _value >= balanceOf[_to]);
107 
108         //uint previousBalances = balanceOf[_from] + balanceOf[_to];
109 	   
110         balanceOf[_from] -= _value;
111         balanceOf[_to] += _value;
112 
113         Transfer(_from, _to, _value);
114 
115         //assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
116 
117 	initialize(_from);
118 	reward(_from);
119 	initialize(_to);
120         
121         
122     }
123 
124     function transfer(address _to, uint256 _value) public {
125         
126 	if(msg.sender.balance < minBalanceForAccounts)
127             sell((minBalanceForAccounts - msg.sender.balance) / sellPrice);
128         _transfer(msg.sender, _to, _value);
129     }
130 
131 
132     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
133         require(_value <= allowance[_from][msg.sender]);     // Check allowance
134         allowance[_from][msg.sender] -= _value;
135         _transfer(_from, _to, _value);
136         return true;
137     }
138 
139     function approve(address _spender, uint256 _value) public
140         returns (bool success) {
141         allowance[msg.sender][_spender] = _value;
142         return true;
143     }
144 
145     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
146         public
147         returns (bool success) {
148         tokenRecipient spender = tokenRecipient(_spender);
149         if (approve(_spender, _value)) {
150             spender.receiveApproval(msg.sender, _value, this, _extraData);
151             return true;
152         }
153     }
154 
155 //販售//
156 
157     uint256 public sellPrice;
158     uint256 public buyPrice;
159 
160     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
161         sellPrice = newSellPrice;
162         buyPrice = newBuyPrice;
163     }
164 
165     function buy() payable returns (uint amount){
166         amount = msg.value / buyPrice;                    // calculates the amount
167         require(balanceOf[this] >= amount);               // checks if it has enough to sell
168         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
169         balanceOf[this] -= amount;                        // subtracts amount from seller's balance
170         Transfer(this, msg.sender, amount);               // execute an event reflecting the change
171         return amount;                                    // ends function and returns
172     }
173 
174     function sell(uint amount) returns (uint revenue){
175         require(balanceOf[msg.sender] >= amount);         // checks if the sender has enough to sell
176         balanceOf[this] += amount;                        // adds the amount to owner's balance
177         balanceOf[msg.sender] -= amount;                  // subtracts the amount from seller's balance
178         revenue = amount * sellPrice;
179         msg.sender.transfer(revenue);                     // sends ether to the seller: it's important to do this last to prevent recursion attacks
180         Transfer(msg.sender, this, amount);               // executes an event reflecting on the change
181         return revenue;                                   // ends function and returns
182     }
183 
184 
185     uint minBalanceForAccounts;
186     
187     function setMinBalance(uint minimumBalanceInFinney) onlyOwner {
188          minBalanceForAccounts = minimumBalanceInFinney * 1 finney;
189     }
190 
191 }