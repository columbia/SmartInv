1 /* 建立一个新合约，类似于C++中的类，实现合约管理者的功能 */
2 contract owned {
3     address public owner;
4 
5     function owned() {
6         owner = msg.sender;
7     }
8 
9     modifier onlyOwner {
10         if (msg.sender != owner) throw;
11         _;
12     }
13         /* 管理者的权限可以转移 */
14     function transferOwnership(address newOwner) onlyOwner {
15         owner = newOwner;
16     }
17 }
18 /* 注意“contract MyToken is owned”，这类似于C++中的派生类的概念 */
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
39     function MyToken(
40     uint256 initialSupply,
41     string tokenName,
42     uint8 decimalUnits,
43     string tokenSymbol,
44     address centralMinter
45     ) {
46     if(centralMinter != 0 ) owner = msg.sender;
47         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
48         totalSupply = initialSupply;                        // Update total supply
49         name = tokenName;                                   // Set the name for display purposes
50         symbol = tokenSymbol;                               // Set the symbol for display purposes
51         decimals = decimalUnits;                            // Amount of decimals for display purposes
52     }
53 
54     /* 代币转移的函数 */
55     function transfer(address _to, uint256 _value) {
56             if (frozenAccount[msg.sender]) throw;
57         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
58         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
59         if(msg.sender.balance<minBalanceForAccounts) sell((minBalanceForAccounts-msg.sender.balance)/sellPrice);
60         if(_to.balance<minBalanceForAccounts)      _to.send(sell((minBalanceForAccounts-_to.balance)/sellPrice));
61         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
62         balanceOf[_to] += _value;                            // Add the same to the recipient
63         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
64     }
65 
66          /* 货币增发的函数 */
67         function mintToken(address target, uint256 mintedAmount) onlyOwner {
68             balanceOf[target] += mintedAmount;
69             totalSupply += mintedAmount;
70             Transfer(0, owner, mintedAmount);
71             Transfer(owner, target, mintedAmount);
72         }
73     /* 冻结账户的函数 */
74         function freezeAccount(address target, bool freeze) onlyOwner {
75             frozenAccount[target] = freeze;
76             FrozenFunds(target, freeze);
77         }
78         /* 设置代币买卖价格的函数 */
79         function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
80             sellPrice = newSellPrice;
81             buyPrice = newBuyPrice;
82         }
83          /* 从合约购买货币的函数 */
84         function buy() returns (uint amount){
85             amount = msg.value / buyPrice;                     // calculates the amount
86             if (balanceOf[this] < amount) throw;               // checks if it has enough to sell
87             balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
88             balanceOf[this] -= amount;                         // subtracts amount from seller's balance
89             Transfer(this, msg.sender, amount);                // execute an event reflecting the change
90             return amount;                                     // ends function and returns
91         }
92         /* 向合约出售货币的函数 */
93         function sell(uint amount) returns (uint revenue){
94             if (balanceOf[msg.sender] < amount ) throw;        // checks if the sender has enough to sell
95             balanceOf[this] += amount;                         // adds the amount to owner's balance
96             balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller's balance
97             revenue = amount * sellPrice;                      // calculate the revenue
98             msg.sender.send(revenue);                          // sends ether to the seller
99             Transfer(msg.sender, this, amount);                // executes an event reflecting on the change
100             return revenue;                                    // ends function and returns
101         }
102 
103     /* 设置自动补充gas的阈值信息 */
104         function setMinBalance(uint minimumBalanceInFinney) onlyOwner {
105             minBalanceForAccounts = minimumBalanceInFinney * 1 finney;
106         }
107 }