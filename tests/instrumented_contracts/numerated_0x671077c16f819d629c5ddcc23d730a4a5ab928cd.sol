1 pragma solidity ^0.4.18;
2 
3 
4 contract Owned {
5     address public owner;
6 
7     function Owned() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address newOwner) onlyOwner public {
17         owner = newOwner;
18     }
19 }
20 
21 
22 contract GFC is Owned {
23 
24     string public name;
25     string public symbol;
26     uint8  public decimals;
27     uint256 public totalSupply;
28     uint256 public sellPrice;
29     uint256 public buyPrice;
30     uint minBalanceForAccounts;
31 
32     mapping (address => uint256) public balanceOf;
33     mapping (address => bool) public frozenAccount;
34 
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     event FrozenFunds(address target, bool frozen);
37 
38     function GFC(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits, address centralMinter) public {
39         balanceOf[msg.sender] = initialSupply;
40         totalSupply = initialSupply;
41         name = tokenName;
42         symbol = tokenSymbol;
43         decimals = decimalUnits;
44         if (centralMinter != 0) {owner = centralMinter;}
45     }
46 
47     function setMinBalance(uint minimumBalanceInFinney) onlyOwner public {
48         minBalanceForAccounts = minimumBalanceInFinney * 1 finney;
49     }
50 
51     /* Internal transfer, can only be called by this contract */
52     function _transfer(address _from, address _to, uint _value) internal {
53         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
54         require (balanceOf[_from] >= _value);                // Check if the sender has enough
55         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
56         require(!frozenAccount[_from]);                     // Check if sender is frozen
57         require(!frozenAccount[_to]);                       // Check if recipient is frozen
58         balanceOf[_from] -= _value;                         // Subtract from the sender
59         balanceOf[_to] += _value;                           // Add the same to the recipient
60         emit Transfer(_from, _to, _value);
61     }
62     function transfer(address _to, uint256 _value) public {
63         require(!frozenAccount[msg.sender]);
64         if (msg.sender.balance<minBalanceForAccounts) {
65             sell((minBalanceForAccounts-msg.sender.balance)/sellPrice);
66         }
67         _transfer(msg.sender, _to, _value);
68     }
69 
70     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
71         balanceOf[target] += mintedAmount;
72         totalSupply += mintedAmount;
73         emit Transfer(0, owner, mintedAmount);
74         emit Transfer(owner, target, mintedAmount);
75     }
76 
77 
78     function freezeAccount(address target, bool freeze) onlyOwner public {
79         frozenAccount[target] = freeze;
80         emit FrozenFunds(target, freeze);
81     }
82 
83     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
84         sellPrice = newSellPrice;
85         buyPrice = newBuyPrice;
86     }
87 
88 
89     function buy() payable public returns (uint amount) {
90         amount = msg.value / buyPrice;
91         require(balanceOf[this] >= amount);
92         balanceOf[msg.sender] += amount;
93         balanceOf[this] -= amount;
94         emit Transfer(this, msg.sender, amount);
95         return amount;
96     }
97 
98     function sell(uint amount) public returns (uint revenue) {
99         require(balanceOf[msg.sender] >= amount);
100         balanceOf[this] += amount;
101         balanceOf[msg.sender] -= amount;
102         revenue = amount * sellPrice;
103         msg.sender.transfer(revenue);
104         emit Transfer(msg.sender, this, amount);
105         return revenue;
106     }
107 }