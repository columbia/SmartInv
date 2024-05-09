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
61     function transfer(address _to, uint256 _value) public returns (bool success) 
62 	{
63         _transfer(msg.sender, _to, _value);
64 		return true;
65     }
66 
67     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
68         require(_value <= allowance[_from][msg.sender]);     
69         allowance[_from][msg.sender] -= _value;
70         _transfer(_from, _to, _value);
71         return true;
72     }
73 
74     function approve(address _spender, uint256 _value) public
75         returns (bool success) {
76         allowance[msg.sender][_spender] = _value;
77         return true;
78     }
79 
80     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
81         public
82         returns (bool success) {
83         tokenRecipient spender = tokenRecipient(_spender);
84         if (approve(_spender, _value)) {
85             spender.receiveApproval(msg.sender, _value, this, _extraData);
86             return true;
87         }
88     }
89     
90     function burn(uint256 _value) public returns (bool success) {
91         require(balanceOf[msg.sender] >= _value);   
92         balanceOf[msg.sender] -= _value;            
93         totalSupply -= _value;                      
94         Burn(msg.sender, _value);
95         return true;
96     }
97 
98     function burnFrom(address _from, uint256 _value) public returns (bool success) {
99         require(balanceOf[_from] >= _value);                
100         require(_value <= allowance[_from][msg.sender]);    
101         balanceOf[_from] -= _value;                         
102         allowance[_from][msg.sender] -= _value;             
103         totalSupply -= _value;                              
104         Burn(_from, _value);
105         return true;
106     }
107 }
108 
109 contract GoodTimeCoin is owned, StandardToken {
110 
111     uint256 public sellPrice;
112     uint256 public buyPrice;
113 
114     mapping (address => bool) public frozenAccount;
115 
116     event FrozenFunds(address target, bool frozen);
117 
118     function GoodTimeCoin(
119         uint256 initialSupply,
120         string tokenName,
121         string tokenSymbol
122     ) StandardToken(initialSupply, tokenName, tokenSymbol) public {}
123 
124     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
125         balanceOf[target] += mintedAmount;
126         totalSupply += mintedAmount;
127         Transfer(0, this, mintedAmount);
128         Transfer(this, target, mintedAmount);
129     }
130 
131     function freezeAccount(address target, bool freeze) onlyOwner public {
132         frozenAccount[target] = freeze;
133         FrozenFunds(target, freeze);
134     }
135 
136     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
137         sellPrice = newSellPrice;
138         buyPrice = newBuyPrice;
139     }
140 
141     function buy() payable public {
142         uint amount = msg.value / buyPrice;               
143         _transfer(this, msg.sender, amount);              
144     }
145 
146     function sell(uint256 amount) public {
147         require(this.balance >= amount * sellPrice);      
148         _transfer(msg.sender, this, amount);              
149         msg.sender.transfer(amount * sellPrice);          
150     }
151 }