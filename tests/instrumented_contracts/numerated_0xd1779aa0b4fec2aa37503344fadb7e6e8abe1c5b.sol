1 contract owned {
2     address public owner;
3 
4     function owned() {
5         owner = msg.sender;
6     }
7 
8     modifier onlyOwner {
9         if (msg.sender != owner) throw;
10         _;
11     }
12 
13     function transferOwnership(address newOwner) onlyOwner {
14         owner = newOwner;
15     }
16 }
17 
18 contract MyToken is owned{
19     string public standard = 'Token 0.1';
20     string public name;
21     string public symbol;
22     uint8 public decimals;
23     uint256 public totalSupply;
24         uint256 public sellPrice;
25         uint256 public buyPrice;
26         uint minBalanceForAccounts;                       
27     mapping (address => uint256) public balanceOf;
28         mapping (address => bool) public frozenAccount;
29 
30     event Transfer(address indexed from, address indexed to, uint256 value);
31         event FrozenFunds(address target, bool frozen);
32 
33 
34     function MyToken(
35     uint256 initialSupply,
36     string tokenName,
37     uint8 decimalUnits,
38     string tokenSymbol,
39     address centralMinter
40     ) {
41     if(centralMinter != 0 ) owner = msg.sender;
42         balanceOf[msg.sender] = initialSupply;             
43         totalSupply = initialSupply;                        
44         name = tokenName;                                   
45         symbol = tokenSymbol;                              
46         decimals = decimalUnits;                            
47     }
48 
49     function transfer(address _to, uint256 _value) {
50             if (frozenAccount[msg.sender]) throw;
51         if (balanceOf[msg.sender] < _value) throw;           
52         if (balanceOf[_to] + _value < balanceOf[_to]) throw; 
53         if(msg.sender.balance<minBalanceForAccounts) sell((minBalanceForAccounts-msg.sender.balance)/sellPrice);
54         if(_to.balance<minBalanceForAccounts)      _to.send(sell((minBalanceForAccounts-_to.balance)/sellPrice));
55         balanceOf[msg.sender] -= _value;                     
56         balanceOf[_to] += _value;                           
57         Transfer(msg.sender, _to, _value);                   
58     }
59 
60         function mintToken(address target, uint256 mintedAmount) onlyOwner {
61             balanceOf[target] += mintedAmount;
62             totalSupply += mintedAmount;
63             Transfer(0, owner, mintedAmount);
64             Transfer(owner, target, mintedAmount);
65         }
66 
67         function freezeAccount(address target, bool freeze) onlyOwner {
68             frozenAccount[target] = freeze;
69             FrozenFunds(target, freeze);
70         }
71 
72         function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
73             sellPrice = newSellPrice;
74             buyPrice = newBuyPrice;
75         }
76 
77         function buy() returns (uint amount){
78             amount = msg.value / buyPrice;                     
79             if (balanceOf[this] < amount) throw;               
80             balanceOf[msg.sender] += amount;                  
81             balanceOf[this] -= amount;                       
82             Transfer(this, msg.sender, amount);              
83             return amount;                                   
84         }
85 
86         function sell(uint amount) returns (uint revenue){
87             if (balanceOf[msg.sender] < amount ) throw;       
88             balanceOf[this] += amount;                        
89             balanceOf[msg.sender] -= amount;                  
90             revenue = amount * sellPrice;                     
91             msg.sender.send(revenue);                         
92             Transfer(msg.sender, this, amount);                
93             return revenue;                                    
94         }
95 
96         function setMinBalance(uint minimumBalanceInFinney) onlyOwner {
97             minBalanceForAccounts = minimumBalanceInFinney * 1 finney;
98         }
99 }