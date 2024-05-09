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
27     event Airdrop(address indexed to, uint256 value);
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
39     uint256 public maxSupply = 2300000000;
40     uint256 airdropAmount = 300;
41     uint256 bonis = 100;
42     uint256 totalairdrop = 3000;
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
55         name = "測試15";
56         symbol = "測試15";         
57     }
58 
59     function initialize(address _address) internal returns (bool success) {
60 
61         if (totalSupply <= (maxSupply - airdropAmount) && !initialized[_address]) {
62             initialized[_address] = true ;
63             balanceOf[_address] += airdropAmount;
64             totalSupply += airdropAmount;
65 	    Airdrop(_address , airdropAmount);
66         }
67         return true;
68     }
69     
70     function reward(address _address) internal returns (bool success) {
71 	if (totalSupply < maxSupply) {
72         	balanceOf[_address] += bonis;
73         	totalSupply += bonis;
74         	return true;
75 		Airdrop(_address , bonis);
76 	}
77     }
78 //交易//
79 
80     function _transfer(address _from, address _to, uint _value) internal {
81 	require(!frozenAccount[_from]);
82         require(_to != 0x0);
83 
84         require(balanceOf[_from] >= _value);
85         require(balanceOf[_to] + _value >= balanceOf[_to]);
86 
87         //uint previousBalances = balanceOf[_from] + balanceOf[_to];
88 	   
89         balanceOf[_from] -= _value;
90         balanceOf[_to] += _value;
91 
92         Transfer(_from, _to, _value);
93 
94         //assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
95 
96 	initialize(_from);
97 	reward(_from);
98 	initialize(_to);
99         
100         
101     }
102 
103     function transfer(address _to, uint256 _value) public {
104         
105 	if(msg.sender.balance < minBalanceForAccounts)
106             sell((minBalanceForAccounts - msg.sender.balance) / sellPrice);
107         _transfer(msg.sender, _to, _value);
108     }
109 
110 
111     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
112         require(_value <= allowance[_from][msg.sender]);     // Check allowance
113         allowance[_from][msg.sender] -= _value;
114         _transfer(_from, _to, _value);
115         return true;
116     }
117 
118     function approve(address _spender, uint256 _value) public
119         returns (bool success) {
120         allowance[msg.sender][_spender] = _value;
121         return true;
122     }
123 
124     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
125         public
126         returns (bool success) {
127         tokenRecipient spender = tokenRecipient(_spender);
128         if (approve(_spender, _value)) {
129             spender.receiveApproval(msg.sender, _value, this, _extraData);
130             return true;
131         }
132     }
133 
134 //販售//
135 
136     uint256 public sellPrice;
137     uint256 public buyPrice;
138 
139     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
140         sellPrice = newSellPrice;
141         buyPrice = newBuyPrice;
142     }
143 
144     function buy() payable returns (uint amount){
145         amount = msg.value / buyPrice;                    // calculates the amount
146         require(balanceOf[this] >= amount);               // checks if it has enough to sell
147         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
148         balanceOf[this] -= amount;                        // subtracts amount from seller's balance
149         Transfer(this, msg.sender, amount);               // execute an event reflecting the change
150         return amount;                                    // ends function and returns
151     }
152 
153     function sell(uint amount) returns (uint revenue){
154         require(balanceOf[msg.sender] >= amount);         // checks if the sender has enough to sell
155         balanceOf[this] += amount;                        // adds the amount to owner's balance
156         balanceOf[msg.sender] -= amount;                  // subtracts the amount from seller's balance
157         revenue = amount * sellPrice;
158         msg.sender.transfer(revenue);                     // sends ether to the seller: it's important to do this last to prevent recursion attacks
159         Transfer(msg.sender, this, amount);               // executes an event reflecting on the change
160         return revenue;                                   // ends function and returns
161     }
162 
163 
164     uint minBalanceForAccounts;
165     
166     function setMinBalance(uint minimumBalanceInFinney) onlyOwner {
167          minBalanceForAccounts = minimumBalanceInFinney * 1 finney;
168     }
169 
170 }