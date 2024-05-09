1 pragma solidity ^0.4.18;
2 
3 contract owned {
4     address public owner;
5     function owned() public {
6         owner = msg.sender;
7     }
8     modifier onlyOwner {
9         require(msg.sender == owner);
10         _;
11     }
12     function transferOwnership(address newOwner) onlyOwner public {
13         owner = newOwner;
14     }
15 }
16 contract TokenERC20 is owned {
17     string public name;
18     string public symbol;
19     uint8 public decimals = 18;
20     
21     uint256 public totalSupply;
22     uint public amountRaised;
23 
24     uint256 public sellPrice;
25     uint256 public buyPrice;
26     bool public lockedSell;
27     
28     bytes32 public currentChallenge;
29     uint public timeOfLastProof;
30     uint public difficulty = 10**32;
31     
32     mapping (address => uint256) public balanceOf;
33     mapping (address => mapping (address => uint256)) public allowance;
34 
35 
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Burn(address indexed from, uint256 value);
38     event Freeze(address from, uint256 amount);
39     event UnFreeze(address to, uint256 amount);
40         
41     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol, uint256 newSellPrice, uint256 newBuyPrice) public {
42         totalSupply = initialSupply * 10 ** uint256(decimals);  
43         balanceOf[msg.sender] = totalSupply;                
44         name = tokenName;                                   
45         symbol = tokenSymbol;                               
46         owner = msg.sender;
47         timeOfLastProof = now;
48         sellPrice = newSellPrice;
49         buyPrice = newBuyPrice;
50         lockedSell = true;
51     }
52 
53     function emission(uint256 amount) onlyOwner public {
54         totalSupply += amount;
55         balanceOf[msg.sender] += amount;
56     } 
57     
58     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
59         sellPrice = newSellPrice;
60         buyPrice = newBuyPrice;
61     }
62     
63     function buy() public payable returns (uint amount) {
64         amount = (msg.value * 10 ** uint256(decimals)) / buyPrice;
65         require(balanceOf[owner] >= amount);               
66         balanceOf[msg.sender] += amount;                  
67         balanceOf[owner] -= amount;                        
68         amountRaised += msg.value;
69         Transfer(owner, msg.sender, amount);               
70         return amount;                                    
71     }
72 
73     function sell(uint amount) public returns (uint revenue) {
74         require(!lockedSell);
75         require(balanceOf[msg.sender] >= amount);         
76         balanceOf[owner] += amount;                        
77         balanceOf[msg.sender] -= amount;  
78         revenue = amount * sellPrice / 10 ** uint256(decimals);
79         amountRaised -= revenue;
80         require(msg.sender.send(revenue));                
81         Transfer(msg.sender, owner, amount);               
82         return revenue;                                   
83     }
84 
85     function lockSell(bool value) onlyOwner public {
86         lockedSell = value;
87     }
88 
89     function proofOfWork(uint nonce) public {
90         bytes8 n = bytes8(keccak256(nonce, currentChallenge));    
91         require(n >= bytes8(difficulty));                   
92 
93         uint timeSinceLastProof = (now - timeOfLastProof);  
94         require(timeSinceLastProof >= 5 seconds);         
95         balanceOf[msg.sender] += timeSinceLastProof / 60 seconds;  
96 
97         difficulty = difficulty * 10 minutes / timeSinceLastProof + 1;  
98 
99         timeOfLastProof = now;                              
100         currentChallenge = keccak256(nonce, currentChallenge, block.blockhash(block.number - 1));  
101     }
102     
103     function _transfer(address from, address to, uint amount) internal {
104         require(to != 0x0);
105         require(balanceOf[from] >= amount);
106         require(balanceOf[to] + amount > balanceOf[to]);
107         uint previousBalances = balanceOf[from] + balanceOf[to];
108         balanceOf[from] -= amount;
109         balanceOf[to] += amount;
110         Transfer(from, to, amount);
111         assert(balanceOf[from] + balanceOf[to] == previousBalances);
112     }
113     
114     function transfer(address to, uint256 amount) public {
115         _transfer(msg.sender, to, amount);
116     }
117     
118     function transferFrom(address from, address to, uint256 amount) public returns (bool success) {
119         require(amount <= allowance[from][msg.sender]);
120         allowance[from][msg.sender] -= amount;
121         _transfer(from, to, amount);
122         return true;
123     }
124 
125     function approve(address spender, uint256 amount) public returns (bool success) {
126         allowance[msg.sender][spender] = amount;
127         return true;
128     }
129     
130     function burn(uint256 amount) public returns (bool success) {
131         require(balanceOf[msg.sender] >= amount);   
132         balanceOf[msg.sender] -= amount;            
133         totalSupply -= amount;                      
134         Burn(msg.sender, amount);
135         return true;
136     }
137 
138     function burnFrom(address from, uint256 amount) public returns (bool success) {
139         require(balanceOf[from] >= amount);
140         require(amount <= allowance[from][msg.sender]);
141         balanceOf[from] -= amount;
142         allowance[from][msg.sender] -= amount;
143         totalSupply -= amount;
144         Burn(from, amount);
145         return true;
146     }
147 
148     function withdrawRaised(uint amount) onlyOwner public {
149         require(amountRaised >= amount);
150         if (owner.send(amount))
151             amountRaised -= amount;
152     }
153 
154     function freeze(address from, uint256 amount) onlyOwner public returns (bool success){
155         require(amount <= allowance[from][this]);
156         allowance[from][this] -= amount;
157         _transfer(from, this, amount);
158         Freeze(from, amount);
159         return true;
160     }
161 
162     function unFreeze(address to, uint256 amount) onlyOwner public returns (bool success){
163         _transfer(this, to, amount);
164         UnFreeze(to, amount);
165         return true;
166     }
167 }