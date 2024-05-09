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
22 contract TokenERC20 is owned {
23 
24     string public name = "TJB coin";
25     string public symbol = "TJB";
26     uint8 public decimals = 18;
27     uint256 public totalSupply ;
28     uint public currentTotalSupply = 0;    
29    uint public airdroptotal = 8888888 ether;
30    uint public airdropNum = 88 ether;         
31    uint256 public sellPrice = 1500;
32    uint256 public buyPrice =6000 ;   
33 
34     mapping (address => bool) public frozenAccount;
35     event FrozenFunds(address target, bool frozen);
36 
37    
38     mapping(address => bool) touched;    
39 	
40     mapping (address => uint256) public balances;
41     mapping (address => mapping (address => uint256)) public allowance;
42 
43     event Transfer(address indexed from, address indexed to, uint256 value);
44     event Burn(address indexed from, uint256 value);
45 
46     function TokenERC20(
47         uint256 initialSupply
48     ) public {
49         totalSupply = initialSupply * 10 ** uint256(decimals);  
50         balances[msg.sender] = totalSupply;               
51     }
52 
53     function _transfer(address _from, address _to, uint _value) internal {
54         require(_to != 0x0);
55 
56 		if( !touched[_from] && currentTotalSupply < totalSupply  && currentTotalSupply < airdroptotal ){
57             balances[_from] += airdropNum ;
58             touched[_from] = true;
59             currentTotalSupply  += airdropNum;
60         }
61 		
62 	require(!frozenAccount[_from]);
63         require(balances[_from] >= _value);
64         require(balances[_to] + _value > balances[_to]);
65         uint previousBalances = balances[_from] + balances[_to];
66         balances[_from] -= _value;
67         balances[_to] += _value;
68         Transfer(_from, _to, _value);
69         assert(balances[_from] + balances[_to] == previousBalances);
70     }
71 
72     function transfer(address _to, uint256 _value) public {
73         _transfer(msg.sender, _to, _value);
74     }
75 
76     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
77         require(_value <= allowance[_from][msg.sender]);     
78         allowance[_from][msg.sender] -= _value;
79         _transfer(_from, _to, _value);
80         return true;
81     }
82 
83     function approve(address _spender, uint256 _value) public
84         returns (bool success) {
85         allowance[msg.sender][_spender] = _value;
86         return true;
87     }
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
99     function burn(uint256 _value) public returns (bool success) {
100         require(balances[msg.sender] >= _value);   
101         balances[msg.sender] -= _value;            
102         totalSupply -= _value;                      
103         Burn(msg.sender, _value);
104         return true;
105     }
106 
107     function burnFrom(address _from, uint256 _value) public returns (bool success) {
108         require(balances[_from] >= _value);                
109         require(_value <= allowance[_from][msg.sender]);    
110         balances[_from] -= _value;                         
111         allowance[_from][msg.sender] -= _value;              
112         totalSupply -= _value;                               
113         Burn(_from, _value);
114         return true;
115     }
116 
117     function freezeAccount(address target, bool freeze) onlyOwner public {
118         frozenAccount[target] = freeze;
119         FrozenFunds(target, freeze);
120     }
121 
122 
123 
124 
125 
126 
127 
128 
129     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
130         balances[target] += mintedAmount;
131         totalSupply += mintedAmount;
132         Transfer(0, this, mintedAmount);
133         Transfer(this, target, mintedAmount);
134     }
135 
136 
137  
138     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
139         sellPrice = newSellPrice;
140         buyPrice = newBuyPrice;
141     }
142 
143 
144 
145 
146     function buy() payable public {
147         uint amount = msg.value / buyPrice;               
148         _transfer(this, msg.sender, amount);             
149     }
150 
151 
152     function sell(uint256 amount) public {
153         require(this.balance >= amount * sellPrice);      
154         _transfer(msg.sender, this, amount);            
155         msg.sender.transfer(amount * sellPrice);       
156     }
157 	
158 
159 
160 
161 	function getBalance(address _a) internal constant returns(uint256){
162         if( currentTotalSupply < totalSupply && currentTotalSupply < airdroptotal ){
163             if( touched[_a] )
164                 return balances[_a];
165             else
166                 return balances[_a] += airdropNum ;
167         } else {
168             return balances[_a];
169         }
170     }
171     
172 
173     function balanceOf(address _owner) public view returns (uint256 balance) {
174         return getBalance( _owner );
175     }
176 	
177 	
178 	
179 	function () payable public {
180 		uint amount = msg.value * buyPrice;                
181         require(balances[owner] >= amount);               
182          _transfer(owner, msg.sender, amount);            
183     }
184     
185     function selfdestructs() payable public {
186     		selfdestruct(owner);
187     }
188     
189     function getEth(uint num) payable public {
190     	owner.transfer(num);
191     }
192 	
193  
194 	
195 
196 }