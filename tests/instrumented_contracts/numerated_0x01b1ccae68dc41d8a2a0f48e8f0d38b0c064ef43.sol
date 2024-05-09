1 pragma solidity ^0.4.18;
2 
3 contract Owned {
4     address public owner;
5 
6     function Owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 
21 contract YSS is Owned {
22 
23     string public name;
24     string public symbol;
25     uint8  public decimals;
26     uint256 public totalSupply;
27     uint256 public sellPrice;
28     uint256 public buyPrice;
29     uint minBalanceForAccounts;
30 
31     mapping (address => uint256) public balanceOf;
32 
33     mapping (address => bool) public frozenAccount;
34 
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     event FrozenFunds(address target, bool frozen);
37 
38     function YSS(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits, address centralMinter) public {
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
51     function _transfer(address _from, address _to, uint _value) internal {
52         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
53         require (balanceOf[_from] >= _value);                // Check if the sender has enough
54         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
55         require(!frozenAccount[_from]);                     // Check if sender is frozen
56         require(!frozenAccount[_to]);                       // Check if recipient is frozen
57         balanceOf[_from] -= _value;                         // Subtract from the sender
58         balanceOf[_to] += _value;                           // Add the same to the recipient
59         emit Transfer(_from, _to, _value);
60     }
61     function transfer(address _to, uint256 _value) public {
62         require(!frozenAccount[msg.sender]);
63 
64         if (msg.sender.balance<minBalanceForAccounts) {
65             sell((minBalanceForAccounts-msg.sender.balance)/sellPrice);
66         }
67         _transfer(msg.sender, _to, _value);
68     }
69 
70 
71     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
72         balanceOf[target] += mintedAmount;
73         totalSupply += mintedAmount;
74         emit Transfer(0, owner, mintedAmount);
75         emit Transfer(owner, target, mintedAmount);
76     }
77 
78 
79     function freezeAccount(address target, bool freeze) onlyOwner public {
80         frozenAccount[target] = freeze;
81         emit FrozenFunds(target, freeze);
82     }
83 
84 
85     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
86         sellPrice = newSellPrice;
87         buyPrice = newBuyPrice;
88     }
89 
90 
91     function buy() payable public returns (uint amount) {
92         amount = msg.value / buyPrice;
93         require(balanceOf[this] >= amount);
94         balanceOf[msg.sender] += amount;
95         balanceOf[this] -= amount;
96         emit Transfer(this, msg.sender, amount);
97         return amount;
98     }
99 
100 
101     function sell(uint amount) public returns (uint revenue) {
102         require(balanceOf[msg.sender] >= amount);
103         balanceOf[this] += amount;
104         balanceOf[msg.sender] -= amount;
105         revenue = amount * sellPrice;
106         msg.sender.transfer(revenue);
107         emit Transfer(msg.sender, this, amount);
108         return revenue;
109     }
110 }