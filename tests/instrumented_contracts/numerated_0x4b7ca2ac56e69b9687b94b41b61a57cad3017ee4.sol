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
22 contract TokenERC20 {
23 
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     uint256 public totalSupply;
28 
29    
30     mapping (address => uint256) public balanceOf;
31     mapping (address => mapping (address => uint256)) public allowance;
32 
33     event Transfer(address indexed from, address indexed to, uint256 value);
34 
35     event Burn(address indexed from, uint256 value);
36 
37     function TokenERC20(
38         uint256 initialSupply,
39         string tokenName,
40         string tokenSymbol
41     ) public {
42         totalSupply = initialSupply * 10 ** uint256(decimals);  
43         balanceOf[msg.sender] = totalSupply;                
44         name = tokenName;                                  
45         symbol = tokenSymbol;                               
46     }
47 
48     function _transfer(address _from, address _to, uint _value) internal {
49         require(_to != 0x0);
50         require(balanceOf[_from] >= _value);
51         require(balanceOf[_to] + _value > balanceOf[_to]);
52         uint previousBalances = balanceOf[_from] + balanceOf[_to];
53         balanceOf[_from] -= _value;
54         balanceOf[_to] += _value;
55         Transfer(_from, _to, _value);
56         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
57     }
58 
59     function transfer(address _to, uint256 _value) public {
60         _transfer(msg.sender, _to, _value);
61     }
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
102 }
103 
104 
105 contract FansChainToken is owned, TokenERC20 {
106 
107     uint256 public sellPrice;
108     uint256 public buyPrice;
109 
110     mapping (address => bool) public frozenAccount;
111 
112     event FrozenFunds(address target, bool frozen);
113     function FansChainToken(
114         uint256 initialSupply,
115         string tokenName,
116         string tokenSymbol
117     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
118 
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
129 
130     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
131         balanceOf[target] += mintedAmount;
132         totalSupply += mintedAmount;
133         Transfer(0, this, mintedAmount);
134         Transfer(this, target, mintedAmount);
135     }
136 
137     function freezeAccount(address target, bool freeze) onlyOwner public {
138         frozenAccount[target] = freeze;
139         FrozenFunds(target, freeze);
140     }
141 
142     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
143         sellPrice = newSellPrice;
144         buyPrice = newBuyPrice;
145     }
146 
147     function buy() payable public {
148         uint amount = msg.value / buyPrice;              
149         _transfer(this, msg.sender, amount);             
150     }
151 
152     function sell(uint256 amount) public {
153         require(this.balance >= amount * sellPrice);     
154         _transfer(msg.sender, this, amount);              
155         msg.sender.transfer(amount * sellPrice);         
156     }
157 }