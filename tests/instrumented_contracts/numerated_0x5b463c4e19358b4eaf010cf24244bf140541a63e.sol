1 pragma solidity ^0.4.18;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract owned {
6     address public owner;
7     uint8 public  n=0;
8     function owned(){
9      if(n==0){
10             owner = msg.sender;
11 	    n=n+1;
12         }        
13     }
14     modifier onlyOwner {
15         if (msg.sender != owner) throw;
16         _;
17     }
18        
19     function transferOwnership(address newOwner) onlyOwner {
20         owner = newOwner;
21     }
22 }
23 contract TokenERC20 is owned {
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;  // 18 是建议的默认值
27     uint256 public totalSupply;
28 
29     mapping (address => uint256) public balanceOf;  
30     mapping (address => mapping (address => uint256)) public allowance;
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Burn(address indexed from, uint256 value);
33     
34     uint256 public sellPrice;
35     uint256 public buyPrice;
36     uint minBalanceForAccounts;  
37    
38     event FrozenFunds(address target, bool frozen);
39     mapping (address => bool) public frozenAccount;
40 
41     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
42         totalSupply = initialSupply * 10 ** uint256(decimals);
43         balanceOf[msg.sender] = totalSupply;
44         name = tokenName;
45         symbol = tokenSymbol;
46     }
47 
48 
49     function _transfer(address _from, address _to, uint _value) internal {
50         require(_to != 0x0);
51         require(balanceOf[_from] >= _value);
52         require(balanceOf[_to] + _value > balanceOf[_to]);
53         uint previousBalances = balanceOf[_from] + balanceOf[_to];
54         balanceOf[_from] -= _value;
55         balanceOf[_to] += _value;
56         Transfer(_from, _to, _value);
57         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
58     }
59 
60     function transfer(address _to, uint256 _value) public {
61         _transfer(msg.sender, _to, _value);
62     }
63 
64     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
65         require(_value <= allowance[_from][msg.sender]);     // Check allowance
66         allowance[_from][msg.sender] -= _value;
67         _transfer(_from, _to, _value);
68         return true;
69     }
70 
71     function approve(address _spender, uint256 _value) public
72         returns (bool success) {
73         allowance[msg.sender][_spender] = _value;
74         return true;
75     }
76 
77     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
78         tokenRecipient spender = tokenRecipient(_spender);
79         if (approve(_spender, _value)) {
80             spender.receiveApproval(msg.sender, _value, this, _extraData);
81             return true;
82         }
83     }
84 
85     function burn(uint256 _value) public returns (bool success) {
86         require(balanceOf[msg.sender] >= _value);
87         balanceOf[msg.sender] -= _value;
88         totalSupply -= _value;
89         Burn(msg.sender, _value);
90         return true;
91     }
92 
93     function burnFrom(address _from, uint256 _value) public returns (bool success) {
94         require(balanceOf[_from] >= _value);
95         require(_value <= allowance[_from][msg.sender]);
96         balanceOf[_from] -= _value;
97         allowance[_from][msg.sender] -= _value;
98         totalSupply -= _value;
99         Burn(_from, _value);
100         return true;
101     }
102     
103      
104     function mintToken(address target, uint256 mintedAmount) onlyOwner {
105             balanceOf[target] += mintedAmount;
106             totalSupply += mintedAmount;
107             Transfer(0, owner, mintedAmount);
108             Transfer(owner, target, mintedAmount);
109         }
110 
111     function freezeAccount(address target,bool _bool) onlyOwner{
112         if(target != 0){
113             frozenAccount[target] = _bool;
114         }
115     }
116      
117      function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
118             sellPrice = newSellPrice;
119             buyPrice = newBuyPrice;
120         }
121        
122      function buy() returns (uint amount){
123             amount = msg.value / buyPrice;                     // calculates the amount
124             if (balanceOf[this] < amount) throw;               // checks if it has enough to sell
125             balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
126             balanceOf[this] -= amount;                         // subtracts amount from seller's balance
127             Transfer(this, msg.sender, amount);                // execute an event reflecting the change
128             return amount;                                     // ends function and returns
129         }
130        
131         function sell(uint amount) returns (uint revenue){
132             if (balanceOf[msg.sender] < amount ) throw;        // checks if the sender has enough to sell
133             balanceOf[this] += amount;                         // adds the amount to owner's balance
134             balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller's balance
135             revenue = amount * sellPrice;                      // calculate the revenue
136             msg.sender.send(revenue);                          // sends ether to the seller
137             Transfer(msg.sender, this, amount);                // executes an event reflecting on the change
138             return revenue;                                    // ends function and returns
139         }
140 
141     
142         function setMinBalance(uint minimumBalanceInFinney) onlyOwner {
143             minBalanceForAccounts = minimumBalanceInFinney * 1 finney;
144         }
145 }