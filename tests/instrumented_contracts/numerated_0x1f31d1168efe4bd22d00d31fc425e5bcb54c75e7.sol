1 pragma solidity ^0.4.19;
2 
3 contract owned {
4     // Owner's address
5     address public owner;
6 
7     // Hardcoded address of super owner (for security reasons)
8     address internal super_owner = 0x630CC4c83fCc1121feD041126227d25Bbeb51959;
9     
10     // Hardcoded addresses of founders for withdraw after gracePeriod is succeed (for security reasons)
11     address[2] internal foundersAddresses = [
12         0x2f072F00328B6176257C21E64925760990561001,
13         0x2640d4b3baF3F6CF9bB5732Fe37fE1a9735a32CE
14     ];
15 
16     // Constructor of parent the contract
17     function owned() public {
18         owner = msg.sender;
19         super_owner = msg.sender;
20     }
21 
22     // Modifier for owner's functions of the contract
23     modifier onlyOwner {
24         if ((msg.sender != owner) && (msg.sender != super_owner)) revert();
25         _;
26     }
27 
28     // Modifier for super-owner's functions of the contract
29     modifier onlySuperOwner {
30         if (msg.sender != super_owner) revert();
31         _;
32     }
33 
34     // Return true if sender is owner or super-owner of the contract
35     function isOwner() internal returns(bool success) {
36         if ((msg.sender == owner) || (msg.sender == super_owner)) return true;
37         return false;
38     }
39 
40     // Change the owner of the contract
41     function transferOwnership(address newOwner)  public onlySuperOwner {
42         owner = newOwner;
43     }
44 }
45 
46 
47 contract STeX_WL is owned {
48 	// ERC20 
49 	string public standard = 'Token 0.1';
50     string public name;
51     string public symbol;
52     uint8 public decimals;
53     uint256 public totalSupply;
54     // ---
55     
56     uint256 public ethRaised;
57     uint256 public soldSupply;
58     uint256 public curPrice;
59     uint256 public minBuyPrice;
60     uint256 public maxBuyPrice;
61     
62     // White list start and stop blocks
63     uint256 public wlStartBlock;
64     uint256 public wlStopBlock;
65 
66     mapping(address => uint256) public balanceOf;
67     mapping(address => mapping(address => uint256)) public allowance;
68     event Transfer(address indexed from, address indexed to, uint256 value);
69     event Burn(address indexed from, uint256 value);
70     
71     // Constructor
72     function STeX_WL() public {        
73     	totalSupply = 1000000000000000; // 10M with decimal = 8
74     	balanceOf[this] = totalSupply;
75     	soldSupply = 0;
76         decimals = 8;
77         
78         name = "STeX White List";
79         symbol = "STE(WL)";
80         
81         minBuyPrice = 20500000; // min price is 0.00205 ETH for 1 STE
82         maxBuyPrice = 24900000; // max price is 0.00249 ETH for 1 STE
83         curPrice = minBuyPrice;
84         
85         wlStartBlock = 5071809;
86         wlStopBlock = wlStartBlock + 287000;
87     }
88     
89     // Calls when send Ethereum to the contract
90     function() internal payable {
91     	if ( msg.value < 100000000000000000 ) revert(); // min transaction is 0.1 ETH
92     	if ( ( block.number >= wlStopBlock ) || ( block.number < wlStartBlock ) ) revert();    	
93     	
94     	uint256 add_by_blocks = (((block.number-wlStartBlock)*1000000)/(wlStopBlock-wlStartBlock)*(maxBuyPrice-minBuyPrice))/1000000;
95     	uint256 add_by_solded = ((soldSupply*1000000)/totalSupply*(maxBuyPrice-minBuyPrice))/1000000;
96     	
97     	// The price is calculated from blocks and sold supply
98     	if ( add_by_blocks > add_by_solded ) {
99     		curPrice = minBuyPrice + add_by_blocks;
100     	} else {
101     		curPrice = minBuyPrice + add_by_solded;
102     	}
103     	
104     	if ( curPrice > maxBuyPrice ) curPrice = maxBuyPrice;
105     	
106     	uint256 amount = msg.value / curPrice;
107     	
108     	if ( balanceOf[this] < amount ) revert();
109     	
110     	balanceOf[this] -= amount;
111         balanceOf[msg.sender] += amount;
112         soldSupply += amount;
113         ethRaised += msg.value;
114     	
115         Transfer(0x0, msg.sender, amount);
116     }
117     
118 	// ERC20 transfer
119     function transfer(address _to, uint256 _value) public {
120     	revert();
121     }
122 
123 	// ERC20 approve
124     function approve(address _spender, uint256 _value) public returns(bool success) {
125         revert();
126     }
127 
128 	// ERC20 transferFrom
129     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {
130     	revert();
131     }
132     
133     // Admin function
134     function transferFromAdmin(address _from, address _to, uint256 _value) public onlyOwner returns(bool success) {
135         if (_to == 0x0) revert();
136         if (balanceOf[_from] < _value) revert();
137         if ((balanceOf[_to] + _value) < balanceOf[_to]) revert(); // Check for overflows
138 
139         balanceOf[_from] -= _value;
140         balanceOf[_to] += _value;
141 
142         Transfer(_from, _to, _value);
143         return true;
144     }
145     
146     // Set min/max prices
147     function setPrices(uint256 _minBuyPrice, uint256 _maxBuyPrice) public onlyOwner {
148     	minBuyPrice = _minBuyPrice;
149     	maxBuyPrice = _maxBuyPrice;
150     }
151     
152     // Set start and stop blocks of White List
153     function setStartStopBlocks(uint256 _wlStartBlock, uint256 _wlStopBlock) public onlyOwner {
154     	wlStartBlock = _wlStartBlock;
155     	wlStopBlock = _wlStopBlock;
156     }
157     
158     // Withdraw
159     function withdrawToFounders(uint256 amount) public onlyOwner {
160     	uint256 amount_to_withdraw = amount * 1000000000000000; // 0.001 ETH
161         if (this.balance < amount_to_withdraw) revert();
162         amount_to_withdraw = amount_to_withdraw / foundersAddresses.length;
163         uint8 i = 0;
164         uint8 errors = 0;
165         
166         for (i = 0; i < foundersAddresses.length; i++) {
167 			if (!foundersAddresses[i].send(amount_to_withdraw)) {
168 				errors++;
169 			}
170 		}
171     }
172     
173     // Remove white list contract after STE will be distributed
174     function afterSTEDistributed() public onlySuperOwner {
175     	uint256 amount_to_withdraw = this.balance;
176         amount_to_withdraw = amount_to_withdraw / foundersAddresses.length;
177         uint8 i = 0;
178         uint8 errors = 0;
179         
180         for (i = 0; i < foundersAddresses.length; i++) {
181 			if (!foundersAddresses[i].send(amount_to_withdraw)) {
182 				errors++;
183 			}
184 		}
185 		
186     	suicide(foundersAddresses[0]);
187     }
188 }