1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
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
20 interface tokenRecipient 
21 { 
22 function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; 
23 }
24 
25 contract StandardToken {
26     
27     string public name;
28     string public symbol;
29     uint8 public decimals = 18;    
30     uint256 public totalSupply;
31 
32     mapping (address => uint256) public balanceOf;
33     mapping (address => mapping (address => uint256)) public allowance;
34 
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     event Burn(address indexed from, uint256 value);
38 
39     function StandardToken(
40         uint256 initialSupply,
41         string tokenName,
42         string tokenSymbol
43     ) public {
44         totalSupply = initialSupply * 10 ** uint256(decimals);  
45         balanceOf[msg.sender] = totalSupply;                
46         name = tokenName;                                   
47         symbol = tokenSymbol;                               
48     }
49 
50     function _transfer(address _from, address _to, uint _value) {
51         require(_to != 0x0);
52         require(balanceOf[_from] >= _value);
53         require(balanceOf[_to] + _value > balanceOf[_to]);
54         uint previousBalances = balanceOf[_from] + balanceOf[_to];
55         balanceOf[_from] -= _value;
56         balanceOf[_to] += _value;
57         Transfer(_from, _to, _value);
58         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
59     }
60 
61 
62     function transfer(address _to, uint256 _value) public returns (bool success) 
63 	{
64         _transfer(msg.sender, _to, _value);
65 		return true;
66     }
67 
68     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
69         require(_value <= allowance[_from][msg.sender]);     
70         allowance[_from][msg.sender] -= _value;
71         _transfer(_from, _to, _value);
72         return true;
73     }
74 
75     function approve(address _spender, uint256 _value) public
76         returns (bool success) {
77         allowance[msg.sender][_spender] = _value;
78         return true;
79     }
80 
81     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
82         public
83         returns (bool success) {
84         tokenRecipient spender = tokenRecipient(_spender);
85         if (approve(_spender, _value)) {
86             spender.receiveApproval(msg.sender, _value, this, _extraData);
87             return true;
88         }
89     }
90     
91     function burn(uint256 _value) public returns (bool success) {
92         require(balanceOf[msg.sender] >= _value);   
93         balanceOf[msg.sender] -= _value;            
94         totalSupply -= _value;                      
95         Burn(msg.sender, _value);
96         return true;
97     }
98 
99     function burnFrom(address _from, uint256 _value) public returns (bool success) {
100         require(balanceOf[_from] >= _value);                
101         require(_value <= allowance[_from][msg.sender]);    
102         balanceOf[_from] -= _value;                         
103         allowance[_from][msg.sender] -= _value;             
104         totalSupply -= _value;                              
105         Burn(_from, _value);
106         return true;
107     }
108 }
109 
110 contract GoodTimeCoin is owned, StandardToken {
111 
112     uint256 public sellPrice;
113     uint256 public buyPrice;
114 
115     mapping (address => bool) public frozenAccount;
116 
117     event FrozenFunds(address target, bool frozen);
118 
119     function GoodTimeCoin(
120         uint256 initialSupply,
121         string tokenName,
122         string tokenSymbol
123     ) StandardToken(initialSupply, tokenName, tokenSymbol) public {}
124 
125     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
126         balanceOf[target] += mintedAmount;
127         totalSupply += mintedAmount;
128         Transfer(0, this, mintedAmount);
129         Transfer(this, target, mintedAmount);
130     }
131 
132     function freezeAccount(address target, bool freeze) onlyOwner public {
133         frozenAccount[target] = freeze;
134         FrozenFunds(target, freeze);
135     }
136 
137     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
138         sellPrice = newSellPrice;
139         buyPrice = newBuyPrice;
140     }
141 
142     function buy() payable public {
143         uint amount = msg.value / buyPrice;               
144         _transfer(this, msg.sender, amount);              
145     }
146 
147     function sell(uint256 amount) public {
148         require(this.balance >= amount * sellPrice);      
149         _transfer(msg.sender, this, amount);              
150         msg.sender.transfer(amount * sellPrice);          
151     }
152 }