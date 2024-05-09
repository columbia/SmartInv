1 pragma solidity ^0.4.16;
2 
3 contract Athleticoin {
4 
5     string public name = "Athleticoin";      //  token name
6     string public symbol = "ATHA";           //  token symbol
7     //string public version = "realversion 1.0";
8     uint256 public decimals = 18;            //  token digit
9 
10     mapping (address => uint256) public balanceOf;
11     mapping (address => mapping (address => uint256)) public allowance;
12 
13     uint256 public totalSupply = 0;
14     bool public stopped = false;
15     
16     uint256 public sellPrice = 1530000000000;
17     uint256 public buyPrice = 1530000000000;
18     //000000000000000000
19     uint256 constant valueFounder = 500000000000000000000000000;
20 
21     address owner = 0xA9F6e166D73D4b2CAeB89ca84101De2c763F8E86;
22     address redeem_address = 0xA1b36225858809dd41c3BE9f601638F3e673Ef48;
23     address owner2 = 0xC58ceD5BA5B1daa81BA2eD7062F5bBC9cE76dA8d;
24     address owner3 = 0x06c7d7981D360D953213C6C99B01957441068C82;
25     
26     modifier isOwner {
27         assert(owner == msg.sender);
28         _;
29     }
30 
31     modifier isRunning {
32         assert (!stopped);
33         _;
34     }
35 
36     modifier validAddress {
37         assert(0x0 != msg.sender);
38         _;
39     }
40 
41     constructor () public {
42         totalSupply = 2000000000000000000000000000;
43         balanceOf[owner] = valueFounder;
44         emit Transfer(0x0, owner, valueFounder);
45         
46         balanceOf[owner2] = valueFounder;
47         emit Transfer(0x0, owner2, valueFounder);
48         
49         balanceOf[owner3] = valueFounder;
50         emit Transfer(0x0, owner3, valueFounder);
51     }
52 
53     function giveBlockReward() public {
54         balanceOf[block.coinbase] += 15000;
55     }
56 
57     function mintToken(address target, uint256 mintedAmount) isOwner public {
58       balanceOf[target] += mintedAmount;
59       totalSupply += mintedAmount;
60       emit Transfer(0, this, mintedAmount);
61       emit Transfer(this, target, mintedAmount);
62     }
63 
64     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) isOwner public {
65         sellPrice = newSellPrice;
66         buyPrice = newBuyPrice;
67     }
68 
69     function redeem(address target, uint256 token_amount) public payable returns (uint amount){
70         token_amount = token_amount * 1000000000000000000;
71         uint256 fee_amount = token_amount * 2 / 102;
72         uint256 redeem_amount = token_amount - fee_amount;
73         uint256 sender_amount = balanceOf[msg.sender];
74         uint256 fee_value = fee_amount * buyPrice / 1000000000000000000;
75         if (sender_amount >= redeem_amount){
76             require(msg.value >= fee_value);
77             balanceOf[target] += redeem_amount;                  // adds the amount to buyer's balance
78             balanceOf[msg.sender] -= redeem_amount; 
79             emit Transfer(msg.sender, target, redeem_amount);               // execute an event reflecting the change
80             redeem_address.transfer(msg.value);
81         } else {
82             uint256 lack_amount = token_amount - sender_amount;
83             uint256 eth_value = lack_amount * buyPrice / 1000000000000000000;
84             lack_amount = redeem_amount - sender_amount;
85             require(msg.value >= eth_value);
86             require(balanceOf[owner] >= lack_amount);    // checks if it has enough to sell
87             
88             balanceOf[target] += redeem_amount;                  // adds the amount to buyer's balance
89             balanceOf[owner] -= lack_amount;                        // subtracts amount from seller's balance  
90             balanceOf[msg.sender] = 0;
91             
92             eth_value = msg.value - fee_value;
93             owner.transfer(eth_value);
94             redeem_address.transfer(fee_value);
95             emit Transfer(msg.sender, target, sender_amount);               // execute an event reflecting the change
96             emit Transfer(owner, target, lack_amount);               // execute an event reflecting the change
97         }
98         return token_amount;                                    // ends function and returns
99     }
100     
101     function buy() public payable returns (uint amount){
102         amount = msg.value / buyPrice;                    // calculates the amount
103         require(balanceOf[owner] >= amount);               // checks if it has enough to sell
104         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
105         balanceOf[owner] -= amount;                        // subtracts amount from seller's balance
106         emit Transfer(owner, msg.sender, amount);               // execute an event reflecting the change
107         return amount;                                    // ends function and returns
108     }
109 
110     function sell(uint amount) public isRunning validAddress returns (uint revenue){
111         require(balanceOf[msg.sender] >= amount);         // checks if the sender has enough to sell
112         balanceOf[owner] += amount;                        // adds the amount to owner's balance
113         balanceOf[msg.sender] -= amount;                  // subtracts the amount from seller's balance
114         revenue = amount * sellPrice;
115         msg.sender.transfer(revenue);                     // sends ether to the seller: it's important to do this last to prevent recursion attacks
116         emit Transfer(msg.sender, owner, amount);               // executes an event reflecting on the change
117         return revenue;                                   // ends function and returns
118     }
119 
120 
121     function transfer(address _to, uint256 _value) public returns (bool success) {
122         require(balanceOf[msg.sender] >= _value);
123         require(balanceOf[_to] + _value >= balanceOf[_to]);
124         balanceOf[msg.sender] -= _value;
125         balanceOf[_to] += _value;
126         emit Transfer(msg.sender, _to, _value);
127         return true;
128     }
129 
130     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
131         require(balanceOf[_from] >= _value);
132         require(balanceOf[_to] + _value >= balanceOf[_to]);
133         require(allowance[_from][msg.sender] >= _value);
134         balanceOf[_to] += _value;
135         balanceOf[_from] -= _value;
136         allowance[_from][msg.sender] -= _value;
137         emit Transfer(_from, _to, _value);
138         return true;
139     }
140 
141     function approve(address _spender, uint256 _value) public returns (bool success) {
142         require(_value == 0 || allowance[msg.sender][_spender] == 0);
143         allowance[msg.sender][_spender] = _value;
144         emit Approval(msg.sender, _spender, _value);
145         return true;
146     }
147 
148     function stop() public isOwner {
149         stopped = true;
150     }
151 
152     function start() public isOwner {
153         stopped = false;
154     }
155 
156     function burn(uint256 _value) public {
157         require(balanceOf[msg.sender] >= _value);
158         balanceOf[msg.sender] -= _value;
159         balanceOf[0x0] += _value;
160         emit Transfer(msg.sender, 0x0, _value);
161     }
162 
163     event Transfer(address indexed _from, address indexed _to, uint256 _value);
164     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
165 }