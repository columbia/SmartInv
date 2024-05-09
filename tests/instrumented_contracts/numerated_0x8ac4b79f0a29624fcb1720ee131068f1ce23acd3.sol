1 pragma solidity ^0.4.11;
2 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
3 
4 contract PirateNinjaCoin {
5     /* Public variables of the token */
6     string public standard = 'Token 0.1';
7     string public name;
8     string public symbol;
9     uint8 public decimals;
10     uint256 public totalSupply;
11     
12     address profit;
13     uint256 public buyPrice;
14     uint256 public sellPrice;
15     uint256 flame;
16     uint256 maxBuyPrice;
17 
18     /* This creates an array with all balances */
19     mapping (address => uint256) public balanceOf;
20     mapping (address => mapping (address => uint256)) public allowance;
21 
22     /* This generates a public event on the blockchain that will notify clients */
23     event Transfer(address indexed from, address indexed to, uint256 value);
24 
25     /* This notifies clients about the amount burnt */
26     event Burn(address indexed from, uint256 value);
27 
28     /* Initializes contract with initial supply tokens to the creator of the contract */
29     function PirateNinjaCoin(
30         string tokenName,
31         uint8 decimalUnits,
32         string tokenSymbol,
33         uint256 initPrice,
34         uint256 finalPrice
35         ) {
36         name = tokenName;                                   // Set the name for display purposes
37         symbol = tokenSymbol;                               // Set the symbol for display purposes
38         decimals = decimalUnits;                            // Amount of decimals for display purposes
39         
40         buyPrice = initPrice;
41         profit = msg.sender;
42         maxBuyPrice = finalPrice;
43         
44         flame = 60000;                                      //set the initial flame to 50%
45     }
46 
47     /* Send coins */
48     function transfer(address _to, uint256 _value) {
49         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
50         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
51         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
52         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
53         balanceOf[_to] += _value;                            // Add the same to the recipient
54         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
55     }
56 
57     /* Allow another contract to spend some tokens in your behalf */
58     function approve(address _spender, uint256 _value)
59         returns (bool success) {
60         allowance[msg.sender][_spender] = _value;
61         return true;
62     }
63 
64     /* Approve and then communicate the approved contract in a single tx */
65     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
66         returns (bool success) {
67         tokenRecipient spender = tokenRecipient(_spender);
68         if (approve(_spender, _value)) {
69             spender.receiveApproval(msg.sender, _value, this, _extraData);
70             return true;
71         }
72     }        
73 
74     /* A contract attempts to get the coins */
75     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
76         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
77         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
78         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
79         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
80         balanceOf[_from] -= _value;                           // Subtract from the sender
81         balanceOf[_to] += _value;                             // Add the same to the recipient
82         allowance[_from][msg.sender] -= _value;
83         Transfer(_from, _to, _value);
84         return true;
85     }
86 
87     function burn(uint256 _value) returns (bool success) {
88         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
89         balanceOf[msg.sender] -= _value;                      // Subtract from the sender
90         totalSupply -= _value;                                // Updates totalSupply
91         profit.transfer(((_value * (110000 - flame) / 100000) ) * sellPrice);
92         setSellPrice();
93         Burn(msg.sender, _value);
94         return true;
95     }
96 
97     function burnFrom(address _from, uint256 _value) returns (bool success) {
98         if (balanceOf[_from] < _value) throw;                // Check if the sender has enough
99         if (_value > allowance[_from][msg.sender]) throw;    // Check allowance
100         balanceOf[_from] -= _value;                          // Subtract from the sender
101         totalSupply -= _value;                               // Updates totalSupply
102         profit.transfer((_value * (110000 - flame) / 100000) * sellPrice); 
103         setSellPrice();
104         Burn(_from, _value);
105         return true;
106     }
107 
108     /* start of pirateNinjaCoin specific function */
109     event NewSellPrice(uint256 value);
110     event NewBuyPrice(uint256 value);
111     
112     function setSellPrice(){
113         if(totalSupply > 0){
114             sellPrice = this.balance / totalSupply;
115             if(buyPrice == maxBuyPrice && sellPrice > buyPrice) sellPrice = buyPrice;
116             if(sellPrice > buyPrice) sellPrice = buyPrice * 99984 / 100000;
117             NewSellPrice(sellPrice);
118         }
119     }
120     
121     modifier onlyOwner {
122         require(msg.sender == profit);
123         _;
124     }
125     
126     function adjustFlame(uint256 _flame) onlyOwner{
127         flame = _flame;
128     }
129 
130     function buy() payable {
131         uint256 fee = (msg.value * 42 / 100000);
132         if(msg.value < (buyPrice + fee)) throw; //check if enough ether was send
133         uint256 amount = (msg.value - fee) / buyPrice;
134         
135         if (totalSupply + amount < totalSupply) throw; //check for overflows
136         if (balanceOf[msg.sender] + amount < balanceOf[msg.sender]) throw; //check for overflows
137         balanceOf[msg.sender] += amount;
138         
139         profit.transfer(fee);
140         msg.sender.transfer(msg.value - fee - (amount * buyPrice)); //send back ethers left
141         
142         totalSupply += amount; 
143         
144         if(buyPrice < maxBuyPrice){
145             buyPrice = buyPrice * 100015 / 100000;
146             if(buyPrice > maxBuyPrice) buyPrice = maxBuyPrice;
147             NewBuyPrice(buyPrice);
148         }
149         
150         setSellPrice();
151     }
152 
153     function sell(uint256 _amount) {
154         if (balanceOf[msg.sender] < _amount) throw;    
155        
156         uint256 ethAmount = sellPrice * _amount;
157         uint256 fee = (ethAmount * 42 / 100000);
158         profit.transfer(fee);
159         msg.sender.transfer(ethAmount - fee);
160         balanceOf[msg.sender] -= _amount;
161         totalSupply -= _amount; 
162     }
163 
164 }