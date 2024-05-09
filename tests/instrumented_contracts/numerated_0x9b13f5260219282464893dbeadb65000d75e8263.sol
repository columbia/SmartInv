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
22 contract GFCB is Owned {
23 
24     string public name="Golden Fortune Coin Blocked";
25     string public symbol="GFCB";
26     uint8  public decimals=18;
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
38     function GFCB() public {
39         totalSupply = 10000000000000000000000000000;
40         balanceOf[msg.sender] = totalSupply;
41     }
42 
43     function setMinBalance(uint minimumBalanceInFinney) onlyOwner public {
44         minBalanceForAccounts = minimumBalanceInFinney * 1 finney;
45     }
46 
47     /* Internal transfer, can only be called by this contract */
48     function _transfer(address _from, address _to, uint _value) internal {
49         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
50         require (balanceOf[_from] >= _value);                // Check if the sender has enough
51         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
52         require(!frozenAccount[_from]);                     // Check if sender is frozen
53         require(!frozenAccount[_to]);                       // Check if recipient is frozen
54         balanceOf[_from] -= _value;                         // Subtract from the sender
55         balanceOf[_to] += _value;                           // Add the same to the recipient
56         emit Transfer(_from, _to, _value);
57     }
58     function transfer(address _to, uint256 _value) public {
59         require(!frozenAccount[msg.sender]);
60         if (msg.sender.balance<minBalanceForAccounts) {
61             sell((minBalanceForAccounts-msg.sender.balance)/sellPrice);
62         }
63         _transfer(msg.sender, _to, _value);
64     }
65 
66     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
67         balanceOf[target] += mintedAmount;
68         totalSupply += mintedAmount;
69         emit Transfer(0, owner, mintedAmount);
70         emit Transfer(owner, target, mintedAmount);
71     }
72 
73 
74     function freezeAccount(address target, bool freeze) onlyOwner public {
75         frozenAccount[target] = freeze;
76         emit FrozenFunds(target, freeze);
77     }
78 
79     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
80         sellPrice = newSellPrice;
81         buyPrice = newBuyPrice;
82     }
83 
84 
85     function buy() payable public returns (uint amount) {
86         amount = msg.value / buyPrice;
87         require(balanceOf[this] >= amount);
88         balanceOf[msg.sender] += amount;
89         balanceOf[this] -= amount;
90         emit Transfer(this, msg.sender, amount);
91         return amount;
92     }
93 
94     function sell(uint amount) public returns (uint revenue) {
95         require(balanceOf[msg.sender] >= amount);
96         balanceOf[this] += amount;
97         balanceOf[msg.sender] -= amount;
98         revenue = amount * sellPrice;
99         msg.sender.transfer(revenue);
100         emit Transfer(msg.sender, this, amount);
101         return revenue;
102     }
103 }