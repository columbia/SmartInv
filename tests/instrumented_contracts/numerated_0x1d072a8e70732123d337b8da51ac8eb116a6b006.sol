1 pragma solidity ^0.4.0;
2 contract owned {
3     address public owner;
4     
5     function owned() public{
6         owner = msg.sender;
7     }
8 
9     modifier onlyOwner{
10         require(msg.sender == owner);
11         _;
12     }
13         /* 管理者的权限可以转移 */
14     function transferOwnership(address newOwner)public onlyOwner {
15         owner = newOwner;
16     }
17 }
18 
19 contract MyToken is owned{
20     /* Public variables of the token */
21     string public standard = 'Token 0.1';
22     string public name;
23     string public symbol;
24     uint8 public decimals;
25     uint256 public totalSupply;
26         uint256 public sellPrice;
27         uint256 public buyPrice;
28         uint minBalanceForAccounts;                                         //threshold amount
29 
30     /* This creates an array with all balances */
31     mapping (address => uint256) public balanceOf;
32         mapping (address => bool) public frozenAccount;
33 
34     /* This generates a public event on the blockchain that will notify clients */
35     event Transfer(address indexed from, address indexed to, uint256 value);
36         event FrozenFunds(address target, bool frozen);
37 
38     /* Initializes contract with initial supply tokens to the creator of the contract */
39     function MyToken (
40     uint256 initialSupply,
41     string tokenName,
42     uint8 decimalUnits,
43     string tokenSymbol,
44     address centralMinter
45     )public {
46     if(centralMinter != 0 ) owner = msg.sender;
47         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
48         totalSupply = initialSupply;                        // Update total supply
49         name = tokenName;                                   // Set the name for display purposes
50         symbol = tokenSymbol;                               // Set the symbol for display purposes
51         decimals = decimalUnits;                            // Amount of decimals for display purposes
52     }
53 
54 
55     function transfer(address _to, uint256 _value) public{
56         require(msg.sender != 0x00);
57         require(balanceOf[msg.sender] >= _value);
58                   // Check if the sender has enough
59         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
60         if(msg.sender.balance<minBalanceForAccounts) sell((minBalanceForAccounts-msg.sender.balance)/sellPrice);
61         if(_to.balance<minBalanceForAccounts){
62              _to.transfer (sell((minBalanceForAccounts-_to.balance)/sellPrice));
63         }      
64        
65         
66         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
67         balanceOf[_to] += _value;                            // Add the same to the recipient
68         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
69     }
70 
71 
72         function mintToken(address target, uint256 mintedAmount) public onlyOwner {
73             balanceOf[target] += mintedAmount;
74             totalSupply += mintedAmount;
75             emit Transfer(0, owner, mintedAmount);
76             emit Transfer(owner, target, mintedAmount);
77         }
78 
79         function freezeAccount(address target, bool freeze) public onlyOwner {
80             frozenAccount[target] = freeze;
81             emit FrozenFunds(target, freeze);
82         }
83 
84         function setPrices(uint256 newSellPrice, uint256 newBuyPrice) public onlyOwner {
85             sellPrice = newSellPrice;
86             buyPrice = newBuyPrice;
87         }
88 
89         function buy() public payable returns (uint amount){
90             amount =  msg.value / buyPrice;                     // calculates the amount
91             require(balanceOf[this] >= amount);
92            // if (balanceOf[this] < amount) throw;               // checks if it has enough to sell
93             balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
94             balanceOf[this] -= amount;                         // subtracts amount from seller's balance
95             emit Transfer(this, msg.sender, amount);                // execute an event reflecting the change
96             return amount;                                     // ends function and returns
97         }
98 
99         function sell(uint amount) public returns (uint revenue){
100             require(balanceOf[msg.sender] >= amount);
101            // if (balanceOf[msg.sender] < amount ) throw;        // checks if the sender has enough to sell
102             balanceOf[this] += amount;                         // adds the amount to owner's balance
103             balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller's balance
104             revenue = amount * sellPrice;                      // calculate the revenue
105             msg.sender.transfer(revenue);                          // sends ether to the seller
106             emit Transfer(msg.sender, this, amount);                // executes an event reflecting on the change
107             return revenue;                                    // ends function and returns
108         }
109 
110 
111         function setMinBalance(uint minimumBalanceInFinney) public onlyOwner {
112             minBalanceForAccounts = minimumBalanceInFinney * 1 finney;
113         }
114 }