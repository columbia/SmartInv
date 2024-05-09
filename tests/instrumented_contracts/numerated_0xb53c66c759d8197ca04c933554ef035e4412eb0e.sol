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
18     mapping (address => uint256) public balanceOf;
19     mapping (address => mapping (address => uint256)) public allowance;
20     mapping (address => bool) public frozenAccount;
21     mapping (address => bool) initialized;
22 
23     event FrozenFunds(address target, bool frozen);
24     event Transfer(address indexed from, address indexed to, uint256 value);
25 
26     function freezeAccount(address target, bool freeze) onlyOwner {
27         frozenAccount[target] = freeze;
28         FrozenFunds(target, freeze);
29     }
30 
31     // Public variables of the token
32     string public name;
33     string public symbol;
34     uint8 public decimals = 2;
35     uint256 public totalSupply;
36     uint256 public maxSupply = 2300000000;
37     uint256 totalairdrop = 600000000;
38     uint256 airdrop1 = 1900000000;
39     uint256 airdrop2 = 2100000000;
40     uint256 airdrop3 = 2300000000;
41 
42     function TokenERC20(
43         uint256 initialSupply,
44         string tokenName,
45         string tokenSymbol
46     ) public {
47 	initialSupply = maxSupply - totalairdrop;
48     balanceOf[msg.sender] = initialSupply;
49     totalSupply = initialSupply;
50         name = "Taiwan讚";
51         symbol = "Tw讚";         
52     }
53 
54     function initialize(address _address) internal returns (bool success) {
55 
56         if (!initialized[_address]) {
57             initialized[_address] = true ;
58             if(totalSupply < airdrop1){
59                 balanceOf[_address] += 2000;
60                 totalSupply += 2000;
61             }
62             else if(airdrop1 <= totalSupply && totalSupply < airdrop2){
63                 balanceOf[_address] += 800;
64                 totalSupply += 800;
65             }
66             else if(airdrop2 <= totalSupply && totalSupply <= airdrop3-300){
67                 balanceOf[_address] += 300;
68                 totalSupply += 300;    
69             }
70 	    
71         }
72         return true;
73     }
74     
75     function reward(address _address) internal returns (bool success) {
76 	    if (totalSupply < maxSupply) {
77             if(totalSupply < airdrop1){
78                 balanceOf[_address] += 1000;
79                 totalSupply += 1000;
80             }
81             else if(airdrop1 <= totalSupply && totalSupply < airdrop2){
82                 balanceOf[_address] += 300;
83                 totalSupply += 300;
84             }
85             else if(airdrop2 <= totalSupply && totalSupply < airdrop3){
86                 balanceOf[_address] += 100;
87                 totalSupply += 100;    
88             }
89 		
90 	    }
91 	    return true;
92     }
93 
94     function _transfer(address _from, address _to, uint _value) internal {
95     	require(!frozenAccount[_from]);
96         require(_to != 0x0);
97 
98         require(balanceOf[_from] >= _value);
99         require(balanceOf[_to] + _value >= balanceOf[_to]);
100 	   
101         balanceOf[_from] -= _value;
102         balanceOf[_to] += _value;
103 
104         Transfer(_from, _to, _value);
105 
106 	initialize(_from);
107 	reward(_from);
108 	initialize(_to);
109         
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
143     uint256 public sellPrice;
144     uint256 public buyPrice;
145 
146     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
147         sellPrice = newSellPrice;
148         buyPrice = newBuyPrice;
149     }
150 
151     function buy() payable returns (uint amount){
152         amount = msg.value / buyPrice;                    // calculates the amount
153         require(balanceOf[this] >= amount);               // checks if it has enough to sell
154         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
155         balanceOf[this] -= amount;                        // subtracts amount from seller's balance
156         Transfer(this, msg.sender, amount);               // execute an event reflecting the change
157         return amount;                                    // ends function and returns
158     }
159 
160     function sell(uint amount) returns (uint revenue){
161         require(balanceOf[msg.sender] >= amount);         // checks if the sender has enough to sell
162         balanceOf[this] += amount;                        // adds the amount to owner's balance
163         balanceOf[msg.sender] -= amount;                  // subtracts the amount from seller's balance
164         revenue = amount * sellPrice;
165         msg.sender.transfer(revenue);                     // sends ether to the seller: it's important to do this last to prevent recursion attacks
166         Transfer(msg.sender, this, amount);               // executes an event reflecting on the change
167         return revenue;                                   // ends function and returns
168     }
169 
170 
171     uint minBalanceForAccounts;
172     
173     function setMinBalance(uint minimumBalanceInFinney) onlyOwner {
174          minBalanceForAccounts = minimumBalanceInFinney * 1 finney;
175     }
176 
177 }