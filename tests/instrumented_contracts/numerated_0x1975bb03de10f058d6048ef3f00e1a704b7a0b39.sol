1 pragma solidity ^0.4.16;
2 
3 contract CherryCoinFoundation {
4     string public name = "Cherry Coin Foundation";
5     string public symbol = "CHY";
6     uint8 public decimals = 18;
7     uint256 public totalSupply = 10000000000000000000000000;
8     uint256 public sellPrice;
9     uint256 public buyPrice;
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13     mapping (address => bool) public frozenAccount;
14     mapping (address => bool) public FrozenFunds;
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Burn(address indexed from, uint256 value);
18     event FrozenFunds(address target, bool frozen);
19     event frozenAccount(address target, bool frozen);
20         
21     function _transfer(address _from, address _to, uint _value) internal {
22         require(_to != 0x0);
23         require(balanceOf[_from] >= _value);
24         require(balanceOf[_to] + _value > balanceOf[_to]);
25         require(!frozenAccount[_from]);                      
26         require(!frozenAccount[_to]);  
27         require(!FrozenFunds[_from]);                      
28         require(!FrozenFunds[_to]);
29         uint previousBalances = balanceOf[_from] + balanceOf[_to];
30         balanceOf[_from] -= _value;
31         balanceOf[_to] += _value;
32         Transfer(_from, _to, _value);
33         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
34     }
35 
36     function transfer(address _to, uint256 _value) public {
37         _transfer(msg.sender, _to, _value);
38     }
39 
40     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
41         require(_value <= allowance[_from][msg.sender]);     
42         allowance[_from][msg.sender] -= _value;
43         _transfer(_from, _to, _value);
44         return true;
45     }
46 
47     function approve(address _spender, uint256 _value) public
48         returns (bool success) {
49         allowance[msg.sender][_spender] = _value;
50         return true;
51     }
52     
53     function buy() payable public {
54         uint amount = msg.value / buyPrice;               
55         _transfer(this, msg.sender, amount);              
56     }
57     
58     function sell(uint256 amount) public {
59         require(this.balance >= amount * sellPrice);      
60         _transfer(msg.sender, this, amount);              
61         msg.sender.transfer(amount * sellPrice); 
62     }
63     
64     function freezeAccount(address target, bool freeze) public {   
65         frozenAccount[target] = freeze;
66         FrozenFunds(target, freeze);
67     }
68     
69     function mintToken(address target, uint256 mintedAmount) public {
70         balanceOf[target] += mintedAmount;
71         totalSupply += mintedAmount;
72         Transfer(0, this, mintedAmount);
73         Transfer(this, target, mintedAmount);
74     }
75     
76     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) public {
77         sellPrice = newSellPrice;
78         buyPrice = newBuyPrice;
79     }
80 
81     function burn(uint256 _value) public returns (bool success) {
82         require(balanceOf[msg.sender] >= _value);   
83         balanceOf[msg.sender] -= _value;             
84         totalSupply -= _value;                      
85         Burn(msg.sender, _value);
86         return true;
87     }
88     
89     function burnFrom(address _from, uint256 _value) public returns (bool success) {
90         require(balanceOf[_from] >= _value);                 
91         require(_value <= allowance[_from][msg.sender]);    
92         balanceOf[_from] -= _value;                         
93         allowance[_from][msg.sender] -= _value;             
94         totalSupply -= _value;                              
95         Burn(_from, _value);
96         return true;
97     }
98 }