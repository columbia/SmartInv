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
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract SACT {
23     string public constant _myTokeName = 'Southeast Asian Cash Token';
24     string public constant _mySymbol = 'SACT';
25     uint public constant _myinitialSupply = 1000000000;
26     uint8 public constant _myDecimal = 8;
27     string public name;
28     string public symbol;
29     uint8 public decimals;
30     uint256 public totalSupply;
31 
32     mapping (address => uint256) public balanceOf;
33     mapping (address => mapping (address => uint256)) public allowance;
34 
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     event Burn(address indexed from, uint256 value);
38 
39     function SACT(
40         uint256 initialSupply,
41         string tokenName,
42         string tokenSymbol
43     ) public {
44         decimals = _myDecimal;
45         totalSupply = _myinitialSupply * (10 ** uint256(_myDecimal));  // Update total supply with the decimal amount
46         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
47         name = _myTokeName;                                   // Set the name for display purposes
48         symbol = _mySymbol;                               // Set the symbol for display purposes
49     }
50 
51     function _transfer(address _from, address _to, uint _value) internal {
52         require(_to != 0x0);
53         require(balanceOf[_from] >= _value);
54         require(balanceOf[_to] + _value > balanceOf[_to]);
55         uint previousBalances = balanceOf[_from] + balanceOf[_to];
56         balanceOf[_from] -= _value;
57         balanceOf[_to] += _value;
58         Transfer(_from, _to, _value);
59         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
60     }
61 
62     function transfer(address _to, uint256 _value) public {
63         _transfer(msg.sender, _to, _value);
64     }
65 
66     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
67         require(_value <= allowance[_from][msg.sender]);     // Check allowance
68         allowance[_from][msg.sender] -= _value;
69         _transfer(_from, _to, _value);
70         return true;
71     }
72 
73     function approve(address _spender, uint256 _value) public
74         returns (bool success) {
75         allowance[msg.sender][_spender] = _value;
76         return true;
77     }
78 
79     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
80         public
81         returns (bool success) {
82         tokenRecipient spender = tokenRecipient(_spender);
83         if (approve(_spender, _value)) {
84             spender.receiveApproval(msg.sender, _value, this, _extraData);
85             return true;
86         }
87     }
88 
89     function burn(uint256 _value) public returns (bool success) {
90         require(balanceOf[msg.sender] >= _value);   
91         balanceOf[msg.sender] -= _value;           
92         totalSupply -= _value;                      
93         Burn(msg.sender, _value);
94         return true;
95     }
96 
97     function burnFrom(address _from, uint256 _value) public returns (bool success) {
98         require(balanceOf[_from] >= _value);                
99         require(_value <= allowance[_from][msg.sender]);    
100         balanceOf[_from] -= _value;                         
101         allowance[_from][msg.sender] -= _value;             
102         totalSupply -= _value;                             
103         Burn(_from, _value);
104         return true;
105     }
106 }
107 
108 contract SoutheastAsianCash is owned, SACT{
109 
110     uint256 public sellPrice;
111     uint256 public buyPrice;
112     mapping (address => bool) public frozenAccount;
113     event FrozenFunds(address target, bool frozen);
114     function SoutheastAsianCash(
115         uint256 initialSupply,
116         string tokenName,
117         string tokenSymbol
118     ) SACT(initialSupply, tokenName, tokenSymbol) public {}
119     function _transfer(address _from, address _to, uint _value) internal {
120         require (_to != 0x0);                               
121         require (balanceOf[_from] >= _value);              
122         require (balanceOf[_to] + _value > balanceOf[_to]); 
123         require(!frozenAccount[_from]);                     
124         require(!frozenAccount[_to]);                       
125         balanceOf[_from] -= _value;                        
126         balanceOf[_to] += _value;                           
127         Transfer(_from, _to, _value);
128     }
129     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
130         balanceOf[target] += mintedAmount;
131         totalSupply += mintedAmount;
132         Transfer(0, this, mintedAmount);
133         Transfer(this, target, mintedAmount);
134     }
135     function freezeAccount(address target, bool freeze) onlyOwner public {
136         frozenAccount[target] = freeze;
137         FrozenFunds(target, freeze);
138     }
139     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
140         sellPrice = newSellPrice;
141         buyPrice = newBuyPrice;
142     }
143     function buy() payable public {
144         uint amount = msg.value / buyPrice;               
145         _transfer(this, msg.sender, amount);              
146     }
147     function sell(uint256 amount) public {
148         require(this.balance >= amount * sellPrice);      
149         _transfer(msg.sender, this, amount);              
150         msg.sender.transfer(amount * sellPrice);          
151     }
152 }