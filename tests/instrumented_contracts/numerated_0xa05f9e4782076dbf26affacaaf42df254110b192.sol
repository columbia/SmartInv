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
22 contract SEACASHTokenERC20 {
23     string public constant _myTokeName = 'SEACASH';
24     string public constant _mySymbol = 'SEACASH';
25     uint public constant _myinitialSupply = 1000000000;
26     uint8 public constant _myDecimal = 18;
27    
28     string public name;
29     string public symbol;
30     uint8 public decimals;
31     uint256 public totalSupply;
32     
33     mapping (address => uint256) public balanceOf;
34     mapping (address => mapping (address => uint256)) public allowance;
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     event Burn(address indexed from, uint256 value);
37 
38     function SEACASHTokenERC20 (
39         uint256 initialSupply,
40         string tokenName,
41         string tokenSymbol
42     ) 
43     public {
44         decimals = _myDecimal;
45         totalSupply = _myinitialSupply * (10 ** uint256(_myDecimal));  
46         balanceOf[msg.sender] = totalSupply;                
47         name = _myTokeName;                                   
48         symbol = _mySymbol;                              
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
67         require(_value <= allowance[_from][msg.sender]);     
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
107 contract SEACASH is owned, SEACASHTokenERC20 {
108 
109     uint256 public sellPrice;
110     uint256 public buyPrice;
111 
112     mapping (address => bool) public frozenAccount;
113     event FrozenFunds(address target, bool frozen);
114     
115     function SEACASH(
116         uint256 initialSupply,
117         string tokenName,
118         string tokenSymbol
119     ) SEACASHTokenERC20(initialSupply, tokenName, tokenSymbol) public {}
120     
121     function _transfer(address _from, address _to, uint _value) internal {
122         require (_to != 0x0);                               
123         require (balanceOf[_from] >= _value);               
124         require (balanceOf[_to] + _value > balanceOf[_to]); 
125         require(!frozenAccount[_from]);                     
126         require(!frozenAccount[_to]);                       
127         balanceOf[_from] -= _value;                         
128         balanceOf[_to] += _value;                           
129         Transfer(_from, _to, _value);
130     }
131 
132     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
133         balanceOf[target] += mintedAmount;
134         totalSupply += mintedAmount;
135         Transfer(0, this, mintedAmount);
136         Transfer(this, target, mintedAmount);
137     }
138 
139     function freezeAccount(address target, bool freeze) onlyOwner public {
140         frozenAccount[target] = freeze;
141         FrozenFunds(target, freeze);
142     }
143 
144     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
145         sellPrice = newSellPrice;
146         buyPrice = newBuyPrice;
147     }
148 
149     function buy() payable public {
150         uint amount = msg.value / buyPrice;               
151         _transfer(this, msg.sender, amount);             
152     }
153 
154     function sell(uint256 amount) public {
155         require(this.balance >= amount * sellPrice);      
156         _transfer(msg.sender, this, amount);              
157         msg.sender.transfer(amount * sellPrice);          
158     }
159 }