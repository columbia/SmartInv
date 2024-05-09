1 pragma solidity ^0.4.19;
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
22 contract SMUToken {
23     string public name;
24     string public symbol;
25     uint8 public decimals = 8;
26     uint256 public totalSupply;
27 
28     mapping (address => uint256) public balanceOf;
29     mapping (address => mapping (address => uint256)) public allowance;
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 
33     event Burn(address indexed from, uint256 value);
34 
35     function SMUToken(
36         uint256 initialSupply,
37         string tokenName,
38         string tokenSymbol
39     ) public {
40         totalSupply = initialSupply * 10 ** uint256(decimals);
41         balanceOf[msg.sender] = totalSupply;    
42         name = tokenName;                    
43         symbol = tokenSymbol;                
44     }
45 
46     function _transfer(address _from, address _to, uint _value) internal {
47 
48         require(_to != 0x0);
49         require(balanceOf[_from] >= _value);
50         require(balanceOf[_to] + _value > balanceOf[_to]);
51         uint previousBalances = balanceOf[_from] + balanceOf[_to];
52         balanceOf[_from] -= _value;
53         balanceOf[_to] += _value;
54         Transfer(_from, _to, _value);
55         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
56     }
57 
58     function transfer(address _to, uint256 _value) public {
59         _transfer(msg.sender, _to, _value);
60     }
61 
62     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
63         require(_value <= allowance[_from][msg.sender]); 
64         allowance[_from][msg.sender] -= _value;
65         _transfer(_from, _to, _value);
66         return true;
67     }
68 
69     function approve(address _spender, uint256 _value) public
70         returns (bool success) {
71         allowance[msg.sender][_spender] = _value;
72         return true;
73     }
74 
75     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
76         public
77         returns (bool success) {
78         tokenRecipient spender = tokenRecipient(_spender);
79         if (approve(_spender, _value)) {
80             spender.receiveApproval(msg.sender, _value, this, _extraData);
81             return true;
82         }
83     }
84 
85 
86     function burn(uint256 _value) public returns (bool success) {
87         require(balanceOf[msg.sender] >= _value);   
88         balanceOf[msg.sender] -= _value;           
89         totalSupply -= _value;                   
90         Burn(msg.sender, _value);
91         return true;
92     }
93 
94     function burnFrom(address _from, uint256 _value) public returns (bool success) {
95         require(balanceOf[_from] >= _value);               
96         require(_value <= allowance[_from][msg.sender]); 
97         balanceOf[_from] -= _value;                 
98         allowance[_from][msg.sender] -= _value;     
99         totalSupply -= _value;      
100         Burn(_from, _value);
101         return true;
102     }
103 }
104 
105 contract MyAdvancedToken is owned, SMUToken {
106 
107     uint256 public sellPrice;
108     uint256 public buyPrice;
109 
110     mapping (address => bool) public frozenAccount;
111 
112     event FrozenFunds(address target, bool frozen);
113 
114     function MyAdvancedToken(
115         uint256 initialSupply,
116         string tokenName,
117         string tokenSymbol
118     ) SMUToken(initialSupply, tokenName, tokenSymbol) public {}
119 
120     function _transfer(address _from, address _to, uint _value) internal {
121         require (_to != 0x0);                               
122         require (balanceOf[_from] >= _value);             
123         require (balanceOf[_to] + _value > balanceOf[_to]); 
124         require(!frozenAccount[_from]);                    
125         require(!frozenAccount[_to]);                    
126         balanceOf[_from] -= _value;                       
127         balanceOf[_to] += _value;                 
128         Transfer(_from, _to, _value);
129     }
130 
131     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
132         balanceOf[target] += mintedAmount;
133         totalSupply += mintedAmount;
134         Transfer(0, this, mintedAmount);
135         Transfer(this, target, mintedAmount);
136     }
137 
138     function freezeAccount(address target, bool freeze) onlyOwner public {
139         frozenAccount[target] = freeze;
140         FrozenFunds(target, freeze);
141     }
142 
143     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
144         sellPrice = newSellPrice;
145         buyPrice = newBuyPrice;
146     }
147 
148     function buy() payable public {
149         uint amount = msg.value / buyPrice;       
150         _transfer(this, msg.sender, amount);    
151     }
152 
153     function sell(uint256 amount) public {
154         require(this.balance >= amount * sellPrice);     
155         _transfer(msg.sender, this, amount);       
156         msg.sender.transfer(amount * sellPrice);   
157     }
158 }