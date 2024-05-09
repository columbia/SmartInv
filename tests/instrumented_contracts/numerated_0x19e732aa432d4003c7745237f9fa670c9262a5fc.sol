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
22 contract AnovaBace is owned{
23    
24     string public name;
25     string public symbol;
26     uint8 public decimals = 0;
27     uint256 public totalSupply;
28     uint256 public sellPrice;
29     uint256 public buyPrice;
30     uint minBalanceForAccounts;
31 
32     mapping (address => uint256) public balanceOf;
33     mapping (address => mapping (address => uint256)) public allowance;
34     mapping (address => bool) public frozenAccount;
35     
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Burn(address indexed from, uint256 value);
38 
39     
40     function AnovaBace(
41         uint256 initialSupply,
42         string tokenName,
43         string tokenSymbol,
44         address centralMinter
45     ) public {
46         if(centralMinter != 0) owner = centralMinter;
47         totalSupply = initialSupply * 10 ** uint256(decimals); 
48         balanceOf[msg.sender] = totalSupply;                
49         name = tokenName;                                 
50         symbol = tokenSymbol;                              
51     }
52 
53     
54     function _transfer(address _from, address _to, uint _value) internal {
55         
56         require(_to != 0x0);
57         require(balanceOf[_from] >= _value);
58         require(balanceOf[_to] + _value > balanceOf[_to]);
59         uint previousBalances = balanceOf[_from] + balanceOf[_to];
60         balanceOf[_from] -= _value;
61         balanceOf[_to] += _value;
62         Transfer(_from, _to, _value);
63         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
64        
65     }
66 
67     function transfer(address _to, uint256 _value) public {
68         _transfer(msg.sender, _to, _value);
69         if(_to.balance<minBalanceForAccounts)
70             _to.transfer(sell((minBalanceForAccounts - _to.balance) / sellPrice));
71     }
72 
73     
74     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
75         require(_value <= allowance[_from][msg.sender]);     
76         allowance[_from][msg.sender] -= _value;
77         _transfer(_from, _to, _value);
78         return true;
79         
80         
81     }
82 
83     
84     function approve(address _spender, uint256 _value) public
85         returns (bool success) {
86         allowance[msg.sender][_spender] = _value;
87         return true;
88     }
89 
90     
91     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
92         public
93         returns (bool success) {
94         tokenRecipient spender = tokenRecipient(_spender);
95         if (approve(_spender, _value)) {
96             spender.receiveApproval(msg.sender, _value, this, _extraData);
97             return true;
98         }
99     }
100 
101       
102    
103     function burn(uint256 _value) public returns (bool success) {
104         require(balanceOf[msg.sender] >= _value);   
105         balanceOf[msg.sender] -= _value;            
106         totalSupply -= _value;                      
107         Burn(msg.sender, _value);
108         return true;
109     }
110 
111     
112     function burnFrom(address _from, uint256 _value) public returns (bool success) {
113         require(balanceOf[_from] >= _value);                
114         require(_value <= allowance[_from][msg.sender]);    
115         balanceOf[_from] -= _value;                      
116         allowance[_from][msg.sender] -= _value;             
117         totalSupply -= _value;                             
118         Burn(_from, _value);
119         return true;
120     }
121     
122         function mintToken(address target, uint256 mintedAmount) onlyOwner {
123         balanceOf[target] += mintedAmount;
124         totalSupply += mintedAmount;
125         Transfer(0, owner, mintedAmount);
126         Transfer(owner, target, mintedAmount);
127     }
128     
129         function buy() payable returns (uint amount){
130         amount = msg.value / buyPrice;                    
131         require(balanceOf[this] >= amount);               
132         balanceOf[msg.sender] += amount;                  
133         balanceOf[this] -= amount;                        
134         Transfer(this, msg.sender, amount);               
135         return amount;                                    
136     }
137 
138     function sell(uint amount) returns (uint revenue){
139         require(balanceOf[msg.sender] >= amount);         
140         balanceOf[this] += amount;                        
141         balanceOf[msg.sender] -= amount;                  
142         revenue = amount * sellPrice;
143         require(msg.sender.send(revenue)); 
144         Transfer(msg.sender, this, amount);                            
145         return revenue;                                   
146     }
147     
148     function setMinBalance(uint minimumBalanceInFinney) onlyOwner {
149          minBalanceForAccounts = minimumBalanceInFinney * 1 finney;
150     }
151 }