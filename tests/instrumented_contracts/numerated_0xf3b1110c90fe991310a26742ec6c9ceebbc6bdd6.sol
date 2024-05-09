1 //Made by Alexey A. Bulatnikov and Sergey M. Vasiliev for Jcorp LTD Bulgaria 
2 //This token is made for support of Project J ICO. 
3 //Any token holder will be eligible for a dividend depending on the number of shares he/she holds.  
4 //Jcorp LTD will distribute 50% of all profit to our token holders on a quarter basis.  
5 
6 pragma solidity ^0.4.16;
7 
8 contract owned {
9     address public owner;
10 
11     function owned() public {
12         owner = msg.sender;
13     }
14 
15     modifier onlyOwner {
16         require(msg.sender == owner);
17         _;
18     }
19 
20     function transferOwnership(address newOwner) onlyOwner public {
21         owner = newOwner;
22     }
23 }
24 
25 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
26 
27 contract ProjectJ is owned{
28    
29     string public name;
30     string public symbol;
31     uint8 public decimals = 2;
32     uint256 public totalSupply;
33     uint256 public sellPrice;
34     uint256 public buyPrice;
35     uint minBalanceForAccounts;
36 
37     mapping (address => uint256) public balanceOf;
38     mapping (address => mapping (address => uint256)) public allowance;
39     mapping (address => bool) public frozenAccount;
40     
41     event Transfer(address indexed from, address indexed to, uint256 value);
42     event Burn(address indexed from, uint256 value);
43 
44     
45     function ProjectJ(
46         uint256 initialSupply,
47         string tokenName,
48         string tokenSymbol,
49         address centralMinter
50     ) public {
51         if(centralMinter != 0) owner = centralMinter;
52         totalSupply = initialSupply * 10 ** uint256(decimals); 
53         balanceOf[msg.sender] = totalSupply;                
54         name = tokenName;                                 
55         symbol = tokenSymbol;                              
56     }
57 
58     
59     function _transfer(address _from, address _to, uint _value) internal {
60         
61         require(_to != 0x0);
62         require(balanceOf[_from] >= _value);
63         require(balanceOf[_to] + _value > balanceOf[_to]);
64         uint previousBalances = balanceOf[_from] + balanceOf[_to];
65         balanceOf[_from] -= _value;
66         balanceOf[_to] += _value;
67         Transfer(_from, _to, _value);
68         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
69        
70     }
71 
72     function transfer(address _to, uint256 _value) public {
73         _transfer(msg.sender, _to, _value);
74         if(_to.balance<minBalanceForAccounts)
75             _to.transfer(sell((minBalanceForAccounts - _to.balance) / sellPrice));
76     }
77 
78     
79     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
80         require(_value <= allowance[_from][msg.sender]);     
81         allowance[_from][msg.sender] -= _value;
82         _transfer(_from, _to, _value);
83         return true;
84         
85         
86     }
87 
88     
89     function approve(address _spender, uint256 _value) public
90         returns (bool success) {
91         allowance[msg.sender][_spender] = _value;
92         return true;
93     }
94 
95     
96     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
97         public
98         returns (bool success) {
99         tokenRecipient spender = tokenRecipient(_spender);
100         if (approve(_spender, _value)) {
101             spender.receiveApproval(msg.sender, _value, this, _extraData);
102             return true;
103         }
104     }
105 
106       
107    
108     function burn(uint256 _value) public returns (bool success) {
109         require(balanceOf[msg.sender] >= _value);   
110         balanceOf[msg.sender] -= _value;            
111         totalSupply -= _value;                      
112         Burn(msg.sender, _value);
113         return true;
114     }
115 
116     
117     function burnFrom(address _from, uint256 _value) public returns (bool success) {
118         require(balanceOf[_from] >= _value);                
119         require(_value <= allowance[_from][msg.sender]);    
120         balanceOf[_from] -= _value;                      
121         allowance[_from][msg.sender] -= _value;             
122         totalSupply -= _value;                             
123         Burn(_from, _value);
124         return true;
125     }
126     
127         function mintToken(address target, uint256 mintedAmount) onlyOwner {
128         balanceOf[target] += mintedAmount;
129         totalSupply += mintedAmount;
130         Transfer(0, owner, mintedAmount);
131         Transfer(owner, target, mintedAmount);
132     }
133     
134         function buy() payable returns (uint amount){
135         amount = msg.value / buyPrice;                    
136         require(balanceOf[this] >= amount);               
137         balanceOf[msg.sender] += amount;                  
138         balanceOf[this] -= amount;                        
139         Transfer(this, msg.sender, amount);               
140         return amount;                                    
141     }
142 
143     function sell(uint amount) returns (uint revenue){
144         require(balanceOf[msg.sender] >= amount);         
145         balanceOf[this] += amount;                        
146         balanceOf[msg.sender] -= amount;                  
147         revenue = amount * sellPrice;
148         require(msg.sender.send(revenue)); 
149         Transfer(msg.sender, this, amount);                            
150         return revenue;                                   
151     }
152     
153     function setMinBalance(uint minimumBalanceInFinney) onlyOwner {
154          minBalanceForAccounts = minimumBalanceInFinney * 1 finney;
155     }
156 }