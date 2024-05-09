1 pragma solidity ^0.4.16;
2 
3 contract AthletiCoin {
4 
5     string public name = "AthletiCoin";      //  token name
6     string public symbol = "ATH";           //  token symbol
7     uint256 public decimals = 18;            //  token digit
8 
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12     uint256 public totalSupply = 0;
13     bool public stopped = false;
14 
15     uint256 public sellPrice = 1000000000;
16     uint256 public buyPrice = 1000000000;
17     //000000000000000000
18     uint256 constant valueFounder = 500000000000000000000000000;
19     address owner = 0x0;
20 
21     modifier isOwner {
22         assert(owner == msg.sender);
23         _;
24     }
25 
26     modifier isRunning {
27         assert (!stopped);
28         _;
29     }
30 
31     modifier validAddress {
32         assert(0x0 != msg.sender);
33         _;
34     }
35 
36     function AthletiCoin (address _addressFounder) public {
37         owner = msg.sender;
38         totalSupply = 2000000000000000000000000000;
39         balanceOf[_addressFounder] = valueFounder;
40         emit Transfer(0x0, _addressFounder, valueFounder);
41     }
42 
43     function giveBlockReward() public {
44         balanceOf[block.coinbase] += 15000;
45     }
46 
47     function mintToken(address target, uint256 mintedAmount) isOwner public {
48       balanceOf[target] += mintedAmount;
49       totalSupply += mintedAmount;
50       emit Transfer(0, this, mintedAmount);
51       emit Transfer(this, target, mintedAmount);
52     }
53 
54     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) isOwner public {
55         sellPrice = newSellPrice;
56         buyPrice = newBuyPrice;
57     }
58 
59     function buy() public payable returns (uint amount){
60         amount = msg.value / buyPrice;                    // calculates the amount
61         require(balanceOf[this] >= amount);               // checks if it has enough to sell
62         balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
63         balanceOf[this] -= amount;                        // subtracts amount from seller's balance
64         emit Transfer(this, msg.sender, amount);               // execute an event reflecting the change
65         return amount;                                    // ends function and returns
66     }
67 
68     function sell(uint amount) public returns (uint revenue){
69         require(balanceOf[msg.sender] >= amount);         // checks if the sender has enough to sell
70         balanceOf[this] += amount;                        // adds the amount to owner's balance
71         balanceOf[msg.sender] -= amount;                  // subtracts the amount from seller's balance
72         revenue = amount * sellPrice;
73         msg.sender.transfer(revenue);                     // sends ether to the seller: it's important to do this last to prevent recursion attacks
74         emit Transfer(msg.sender, this, amount);               // executes an event reflecting on the change
75         return revenue;                                   // ends function and returns
76     }
77 
78 
79     function transfer(address _to, uint256 _value) public isRunning validAddress returns (bool success) {
80         require(balanceOf[msg.sender] >= _value);
81         require(balanceOf[_to] + _value >= balanceOf[_to]);
82         balanceOf[msg.sender] -= _value;
83         balanceOf[_to] += _value;
84         emit Transfer(msg.sender, _to, _value);
85         return true;
86     }
87 
88     function transferFrom(address _from, address _to, uint256 _value) public isRunning validAddress returns (bool success) {
89         require(balanceOf[_from] >= _value);
90         require(balanceOf[_to] + _value >= balanceOf[_to]);
91         require(allowance[_from][msg.sender] >= _value);
92         balanceOf[_to] += _value;
93         balanceOf[_from] -= _value;
94         allowance[_from][msg.sender] -= _value;
95         emit Transfer(_from, _to, _value);
96         return true;
97     }
98 
99     function approve(address _spender, uint256 _value) public isRunning validAddress returns (bool success) {
100         require(_value == 0 || allowance[msg.sender][_spender] == 0);
101         allowance[msg.sender][_spender] = _value;
102         emit Approval(msg.sender, _spender, _value);
103         return true;
104     }
105 
106     function stop() public isOwner {
107         stopped = true;
108     }
109 
110     function start() public isOwner {
111         stopped = false;
112     }
113 
114     function burn(uint256 _value) public {
115         require(balanceOf[msg.sender] >= _value);
116         balanceOf[msg.sender] -= _value;
117         balanceOf[0x0] += _value;
118         emit Transfer(msg.sender, 0x0, _value);
119     }
120 
121     event Transfer(address indexed _from, address indexed _to, uint256 _value);
122     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
123 }