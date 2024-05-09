1 pragma solidity ^0.4.17;
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
22 contract TokenERC20 {
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
35     
36     function TokenERC20() public {
37         totalSupply = 300000000 * 10 ** uint256(decimals);  
38         balanceOf[msg.sender] = totalSupply;                
39         name = 'BitPaction Shares';
40         symbol = 'BPS';
41     }
42 
43    
44     function _transfer(address _from, address _to, uint _value) internal {
45         require(_to != 0x0);
46         require(balanceOf[_from] >= _value);
47         require(balanceOf[_to] + _value > balanceOf[_to]);
48         uint previousBalances = balanceOf[_from] + balanceOf[_to];
49         balanceOf[_from] -= _value;
50         
51         balanceOf[_to] += _value;
52         Transfer(_from, _to, _value);
53         
54         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
55     }
56 
57     function transfer(address _to, uint256 _value) public {
58         _transfer(msg.sender, _to, _value);
59     }
60 
61     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
62         require(_value <= allowance[_from][msg.sender]);     // Check allowance
63         allowance[_from][msg.sender] -= _value;
64         _transfer(_from, _to, _value);
65         return true;
66     }
67 
68     function approve(address _spender, uint256 _value) public
69         returns (bool success) {
70         allowance[msg.sender][_spender] = _value;
71         return true;
72     }
73 
74     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
75         public
76         returns (bool success) {
77         tokenRecipient spender = tokenRecipient(_spender);
78         if (approve(_spender, _value)) {
79             spender.receiveApproval(msg.sender, _value, this, _extraData);
80             return true;
81         }
82     }
83 
84     function burn(uint256 _value) public returns (bool success) {
85         require(balanceOf[msg.sender] >= _value);   
86         balanceOf[msg.sender] -= _value;            
87         totalSupply -= _value;                     
88         Burn(msg.sender, _value);
89         return true;
90     }
91 
92     function burnFrom(address _from, uint256 _value) public returns (bool success) {
93         require(balanceOf[_from] >= _value);                
94         require(_value <= allowance[_from][msg.sender]);
95         balanceOf[_from] -= _value; 
96         allowance[_from][msg.sender] -= _value;             
97         totalSupply -= _value;                              
98         Burn(_from, _value);
99         return true;
100     }
101 }
102 
103 contract BpsToken is owned, TokenERC20 {
104 
105     uint256 public sellPrice;
106     uint256 public buyPrice;
107 
108     mapping (address => bool) public frozenAccount;
109 
110     
111     event FrozenFunds(address target, bool frozen);
112 
113    
114     function BpsToken(
115     ) TokenERC20() public {}
116 
117     
118     function _transfer(address _from, address _to, uint _value) internal {
119         require (_to != 0x0);                               
120         require (balanceOf[_from] >= _value);               
121         require (balanceOf[_to] + _value > balanceOf[_to]); 
122         require(!frozenAccount[_from]);                     
123         require(!frozenAccount[_to]);                       
124         balanceOf[_from] -= _value;                         
125         balanceOf[_to] += _value;                           
126         Transfer(_from, _to, _value);
127     }
128 
129     
130     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
131         balanceOf[target] += mintedAmount;
132         totalSupply += mintedAmount;
133         Transfer(0, this, mintedAmount);
134         Transfer(this, target, mintedAmount);
135     }
136 
137    
138     function freezeAccount(address target, bool freeze) onlyOwner public {
139         frozenAccount[target] = freeze;
140         FrozenFunds(target, freeze);
141     }
142 
143     
144     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
145         sellPrice = newSellPrice;
146         buyPrice = newBuyPrice;
147     }
148 
149     
150     function buy() payable public {
151         uint amount = msg.value / buyPrice;               
152         _transfer(this, msg.sender, amount);              
153     }
154 
155     
156     function sell(uint256 amount) public {
157         require(this.balance >= amount * sellPrice);      
158         _transfer(msg.sender, this, amount);
159         msg.sender.transfer(amount * sellPrice);
160     }
161 }