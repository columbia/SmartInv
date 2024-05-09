1 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
2     //*************************************************************************************************************//
3    ///////////////////////////////////Global Chemical Research Token///////////////////////////////////////////////////////////////////////////////////////////
4   ///// Cryptocurrency for affordable fully automated modular synthesis apparatus in Global Chemical Research////////////////////////////
5  //***********************************************************************************************************////
6 //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
7 
8 pragma solidity ^0.4.16;
9 
10 contract owned {
11     address public owner;
12 
13     function owned() public {
14         owner = msg.sender;
15     }
16 
17     modifier onlyOwner {
18         require(msg.sender == owner);
19         _;
20     }
21 
22     function transferOwnership(address newOwner) onlyOwner public {
23         owner = newOwner;
24     }
25 }
26 
27 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
28 
29 contract GCRTokenERC20 {
30     string public constant _myTokeName = 'GlobalChemicalResearch Token';
31     string public constant _mySymbol = 'GCR';
32     uint public constant _myinitialSupply = 100000000;
33     uint8 public constant _myDecimal = 18;
34     string public name;
35     string public symbol;
36     uint8 public decimals;
37     uint256 public totalSupply;
38 
39     mapping (address => uint256) public balanceOf;
40     mapping (address => mapping (address => uint256)) public allowance;
41 
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 
44     event Burn(address indexed from, uint256 value);
45 
46 
47      function GCRTokenERC20() {
48         totalSupply = 100000000 * 10 ** uint256(decimals);
49         balanceOf[msg.sender] = 100000000;
50         name = "GlobalChemicalResearch Token";                                 
51         symbol = "GCR";                            
52 }
53      
54 
55 
56  
57     function _transfer(address _from, address _to, uint _value) internal {
58         require(_to != 0x0);
59         require(balanceOf[_from] >= _value);
60         require(balanceOf[_to] + _value > balanceOf[_to]);
61         uint previousBalances = balanceOf[_from] + balanceOf[_to];
62         balanceOf[_from] -= _value;
63         balanceOf[_to] += _value;
64         Transfer(_from, _to, _value);
65         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
66     }
67 
68 
69     function transfer(address _to, uint256 _value) public {
70         _transfer(msg.sender, _to, _value);
71     }
72 
73 
74     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
75         require(_value <= allowance[_from][msg.sender]);    
76         allowance[_from][msg.sender] -= _value;
77         _transfer(_from, _to, _value);
78         return true;
79     }
80 
81 
82     function approve(address _spender, uint256 _value) public
83         returns (bool success) {
84         allowance[msg.sender][_spender] = _value;
85         return true;
86     }
87 
88 
89     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
90         public
91         returns (bool success) {
92         tokenRecipient spender = tokenRecipient(_spender);
93         if (approve(_spender, _value)) {
94             spender.receiveApproval(msg.sender, _value, this, _extraData);
95             return true;
96         }
97     }
98 
99 
100     function burn(uint256 _value) public returns (bool success) {
101         require(balanceOf[msg.sender] >= _value);  
102         balanceOf[msg.sender] -= _value;            
103         totalSupply -= _value;                    
104         Burn(msg.sender, _value);
105         return true;
106     }
107 
108 
109     function burnFrom(address _from, uint256 _value) public returns (bool success) {
110         require(balanceOf[_from] >= _value);                
111         require(_value <= allowance[_from][msg.sender]);    
112         balanceOf[_from] -= _value;                         
113         allowance[_from][msg.sender] -= _value;            
114         totalSupply -= _value;                             
115         Burn(_from, _value);
116         return true;
117     }
118 }
119 
120 
121 contract MyAdvancedToken is owned, GCRTokenERC20 {
122 
123 
124 
125     uint256 public sellPrice;
126     uint256 public buyPrice;
127 
128     mapping (address => bool) public frozenAccount;
129 
130     event FrozenFunds(address target, bool frozen);
131 
132     function _transfer(address _from, address _to, uint _value) internal {
133         require (_to != 0x0);                               
134         require (balanceOf[_from] >= _value);               
135         require (balanceOf[_to] + _value > balanceOf[_to]); 
136         require(!frozenAccount[_from]);                     
137         require(!frozenAccount[_to]);                       
138         balanceOf[_from] -= _value;                         
139         balanceOf[_to] += _value;                           
140         Transfer(_from, _to, _value);
141     }
142 
143  
144     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
145         balanceOf[target] += mintedAmount;
146         totalSupply += mintedAmount;
147         Transfer(0, this, mintedAmount);
148         Transfer(this, target, mintedAmount);
149     }
150 
151   
152     function freezeAccount(address target, bool freeze) onlyOwner public {
153         frozenAccount[target] = freeze;
154         FrozenFunds(target, freeze);
155     }
156 
157   
158     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
159         sellPrice = newSellPrice;
160         buyPrice = newBuyPrice;
161     }
162 
163     function buy() payable public {
164         uint amount = msg.value / buyPrice;             
165         _transfer(this, msg.sender, amount);             
166     }
167 
168    
169     function sell(uint256 amount) public {
170         require(this.balance >= amount * sellPrice);     
171         _transfer(msg.sender, this, amount);             
172         msg.sender.transfer(amount * sellPrice);         
173     }
174 }