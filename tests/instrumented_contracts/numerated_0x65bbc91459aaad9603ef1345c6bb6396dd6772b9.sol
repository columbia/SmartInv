1 contract owned {
2     address public owner;
3 
4     function owned() {
5         owner = msg.sender;
6     }
7 
8     modifier onlyOwner {
9         if (msg.sender != owner) throw;       
10     }
11 
12     function transferOwnership(address newOwner) onlyOwner {
13         owner = newOwner;
14     }
15 }
16 
17 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
18 
19 contract GSIToken is owned  {
20 
21     uint256 public sellPrice;
22     uint256 public buyPrice;
23 		    /* Public variables of the token */
24     string public standard = 'Token 0.1';
25     string public name;
26     string public symbol;
27     uint8 public decimalUnits;
28     uint256 public totalSupply;
29 
30     mapping (address => bool) public frozenAccount;
31 
32     /* This generates a public event on the blockchain that will notify clients */
33     event FrozenFunds(address target, bool frozen);
34 
35     /* Initializes contract with initial supply tokens to the creator of the contract */
36     function GSIToken(
37         uint256 initialSupply,
38         string _tokenName,
39         uint8 _decimalUnits,
40         string _tokenSymbol,
41         address centralMinter
42     )  {
43         if(centralMinter != 0 ) owner = centralMinter;      // Sets the owner as specified (if centralMinter is not specified the owner is msg.sender)
44         balanceOf[owner] = initialSupply;                   // Give the owner all initial tokens
45 		totalSupply=initialSupply;
46 		name=_tokenName;
47 		decimalUnits=_decimalUnits;
48 		symbol=_tokenSymbol;
49     }
50 
51     /* Send coins */
52     function transfer(address _to, uint256 _value) {
53         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
54         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
55         if (frozenAccount[msg.sender]) throw;                // Check if frozen
56         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
57         balanceOf[_to] += _value;                            // Add the same to the recipient
58         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
59     }
60 
61 
62     /* A contract attempts to get the coins */
63     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
64         if (frozenAccount[_from]) throw;                        // Check if frozen            
65         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
66         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
67         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
68         balanceOf[_from] -= _value;                          // Subtract from the sender
69         balanceOf[_to] += _value;                            // Add the same to the recipient
70         allowance[_from][msg.sender] -= _value;
71         Transfer(_from, _to, _value);
72         return true;
73     }
74 
75     function mintToken(address target, uint256 mintedAmount) onlyOwner {
76         balanceOf[target] += mintedAmount;
77         totalSupply += mintedAmount;
78         Transfer(0, owner, mintedAmount);
79         Transfer(owner, target, mintedAmount);
80     }
81 
82     function freezeAccount(address target, bool freeze) onlyOwner {
83         frozenAccount[target] = freeze;
84         FrozenFunds(target, freeze);
85     }
86 
87     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
88         sellPrice = newSellPrice;
89         buyPrice = newBuyPrice;
90     }
91 
92     function buy() {
93         uint amount = msg.value / buyPrice;                // calculates the amount
94         if (balanceOf[this] < amount) throw;               // checks if it has enough to sell
95         balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
96         balanceOf[this] -= amount;                         // subtracts amount from seller's balance
97         Transfer(this, msg.sender, amount);                // execute an event reflecting the change
98     }
99 
100     function sell(uint256 amount) {
101         if (balanceOf[msg.sender] < amount ) throw;        // checks if the sender has enough to sell
102         balanceOf[this] += amount;                         // adds the amount to owner's balance
103         balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller's balance
104         if (!msg.sender.send(amount * sellPrice)) {        // sends ether to the seller. It's important
105             throw;                                         // to do this last to avoid recursion attacks
106         } else {
107             Transfer(msg.sender, this, amount);            // executes an event reflecting on the change
108         }               
109     }
110 
111 
112     /* This creates an array with all balances */
113     mapping (address => uint256) public balanceOf;
114     mapping (address => mapping (address => uint256)) public allowance;
115 
116     /* This generates a public event on the blockchain that will notify clients */
117     event Transfer(address indexed from, address indexed to, uint256 value);
118 
119 
120     /* Allow another contract to spend some tokens in your behalf */
121     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
122         returns (bool success) {
123         allowance[msg.sender][_spender] = _value;
124         tokenRecipient spender = tokenRecipient(_spender);
125         spender.receiveApproval(msg.sender, _value, this, _extraData);
126         return true;
127     }
128 
129 
130     /* This unnamed function is called whenever someone tries to send ether to it */
131     function () {
132         throw;     // Prevents accidental sending of ether
133     }
134 }
135 
136 contract GSI is owned {
137 		event OracleRequest(address target);
138 		
139 		GSIToken public greenToken;
140 		GSIToken public greyToken;
141 		uint256 public requiredGas;
142 		uint256 public secondsBetweenReadings;
143 		
144 		mapping(address=>Reading) public lastReading;
145 		mapping(address=>Reading) public requestReading;
146 		mapping(address=>uint8) public freeReadings;
147 		
148 		struct Reading {
149 			uint256 timestamp;
150 			uint256 value;
151 			string zip;
152 		}
153 		
154 		function GSI() {
155 			greenToken = new GSIToken(
156 							0,
157 							'GreenPower',
158 							0,
159 							'P+',
160 							this
161 			);
162 			//greenToken.mintToken(msg.sender,10000);
163 			greyToken = new GSIToken(
164 							0,
165 							'GreyPower',
166 							0,
167 							'P-',
168 							this
169 			);							
170 		}
171 		
172 		function oracalizeReading(uint256 _reading,string _zip) {
173 			if(msg.value<requiredGas) {  
174 				if(freeReadings[msg.sender]==0) throw;
175 				freeReadings[msg.sender]--;
176 			} 		
177 			if(_reading<lastReading[msg.sender].value) throw;
178 			if(_reading<requestReading[msg.sender].value) throw;
179 			if(now<lastReading[msg.sender].timestamp+secondsBetweenReadings) throw;
180 			//lastReading[msg.sender]=requestReading[msg.sender];
181 			requestReading[msg.sender]=Reading(now,_reading,_zip);
182 			OracleRequest(msg.sender);
183 			owner.send(msg.value);
184 		}	
185 			
186 		function setReadingDelay(uint256 delay) onlyOwner {
187 			secondsBetweenReadings=delay;
188 		}
189 		
190 		function assignFreeReadings(address _receiver,uint8 _count) onlyOwner {
191 			freeReadings[_receiver]+=_count;
192 		}	
193 		
194 		function mintGreen(address recipient,uint256 tokens) onlyOwner {			
195 			greenToken.mintToken(recipient, tokens);			
196 		}
197 		
198 		function mintGrey(address recipient,uint256 tokens) onlyOwner {			
199 			greyToken.mintToken(recipient, tokens);			
200 		}
201 		
202 		function commitReading(address recipient,uint256 timestamp,uint256 reading,string zip) onlyOwner {			
203 			if(this.balance>0) {
204 				owner.send(this.balance);
205 			} 
206 		  lastReading[recipient]=Reading(timestamp,reading,zip);
207 		}
208 		
209 		function setOracleGas(uint256 _requiredGas) onlyOwner {
210 			requiredGas=_requiredGas;
211 		}
212 		
213 		function() {
214 			if(msg.value>0) {
215 				owner.send(msg.value);
216 			}
217 		}
218 }