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
16 		owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract Token {
23     
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     uint256 public totalSupply;
28     
29     mapping (address => uint256) public balanceOf;
30     mapping (address => mapping (address => uint256)) public allowance;
31 
32     event Transfer(address indexed from, address indexed to, uint256 value);
33 
34     event Burn(address indexed from, uint256 value);
35 	
36     /**
37      * Internal transfer, only can be called by this contract
38      */
39     function _transfer(address _from, address _to, uint _value) internal {
40         require(_to != 0x0);
41         require(balanceOf[_from] >= _value);
42         require(balanceOf[_to] + _value > balanceOf[_to]);
43         uint previousBalances = balanceOf[_from] + balanceOf[_to];
44         balanceOf[_from] -= _value;
45         balanceOf[_to] += _value;
46         Transfer(_from, _to, _value);
47         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
48     }
49 
50   
51     function transfer(address _to, uint256 _value) public {
52         _transfer(msg.sender, _to, _value);
53     }
54 
55     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
56         require(_value <= allowance[_from][msg.sender]);
57         allowance[_from][msg.sender] -= _value;
58         _transfer(_from, _to, _value);
59         return true;
60     }
61 
62     
63     function approve(address _spender, uint256 _value) public
64         returns (bool success) {
65         allowance[msg.sender][_spender] = _value;
66         return true;
67     }
68 
69     
70     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
71         public
72         returns (bool success) {
73         tokenRecipient spender = tokenRecipient(_spender);
74         if (approve(_spender, _value)) {
75             spender.receiveApproval(msg.sender, _value, this, _extraData);
76             return true;
77         }
78     }
79 
80     
81     function burn(uint256 _value) public returns (bool success) {
82         require(balanceOf[msg.sender] >= _value);   
83         balanceOf[msg.sender] -= _value;            
84         totalSupply -= _value;                      
85         Burn(msg.sender, _value);
86         return true;
87     }
88 
89     
90     function burnFrom(address _from, uint256 _value) public returns (bool success) {
91         require(balanceOf[_from] >= _value);            
92         require(_value <= allowance[_from][msg.sender]);    
93         balanceOf[_from] -= _value;                         
94         allowance[_from][msg.sender] -= _value;             
95         totalSupply -= _value;                              
96         Burn(_from, _value);
97         return true;
98     }
99 }
100 
101 contract IADOWR is owned, Token {
102 	string public name = "IADOWR Coin";                                      
103     string public symbol = "IAD";                                            
104     address public IADAddress = this;                                 
105     uint8 public decimals = 18;                                          
106     uint256 public initialSupply = 2000000000000000000000000000; 
107 	uint256 public totalSupply = 2000000000000000000000000000;          
108     uint256 public unitsOneEthCanBuy = 5000;
109     uint256 public buyPriceEth = 0.2 finney;                               
110     uint256 public sellPriceEth = 0.1 finney;                              
111     uint256 public gasForIAD = 30000 wei;                                    
112     uint256 public IADForGas = 1;                                        
113     uint256 public gasReserve = 0.1 ether;                                 
114     uint256 public minBalanceForAccounts = 2 finney;                    
115     bool public directTradeAllowed = false;                              
116 
117     
118 	function IADOWR() {
119         balanceOf[msg.sender] = totalSupply;                                
120     }
121 	
122 	uint256 public sellPrice;
123     uint256 public buyPrice;
124 
125     mapping (address => bool) public frozenAccount;
126 
127     event FrozenFunds(address target, bool frozen);
128 
129     
130     function _transfer(address _from, address _to, uint _value) internal {
131         require (_to != 0x0);                              
132         require (balanceOf[_from] >= _value);              
133         require (balanceOf[_to] + _value >= balanceOf[_to]);
134         require(!frozenAccount[_from]);                     
135         require(!frozenAccount[_to]);                       
136         balanceOf[_from] -= _value;                         
137         balanceOf[_to] += _value;                           
138         Transfer(_from, _to, _value);
139     }
140 
141     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
142         balanceOf[target] += mintedAmount;
143         totalSupply += mintedAmount;
144         Transfer(0, this, mintedAmount);
145         Transfer(this, target, mintedAmount);
146     }
147 
148     function freezeAccount(address target, bool freeze) onlyOwner public {
149         frozenAccount[target] = freeze;
150         FrozenFunds(target, freeze);
151     }
152 
153     
154     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
155         sellPrice = newSellPrice;
156         buyPrice = newBuyPrice;
157     }
158 
159 
160     function buy() payable public {
161         uint amount = msg.value / buyPrice;               
162         _transfer(this, msg.sender, amount);              
163     }
164 
165 
166     function sell(uint256 amount) public {
167         require(this.balance >= amount * sellPrice);      
168         _transfer(msg.sender, this, amount);              
169         msg.sender.transfer(amount * sellPrice);          
170     }
171 }