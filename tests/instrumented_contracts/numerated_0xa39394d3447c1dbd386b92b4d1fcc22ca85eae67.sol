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
12     function transferOwnership(address newOwner)  {
13 		if(msg.sender!=owner) throw;
14         owner = newOwner;
15     }
16 }
17 
18 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
19 
20 contract GSIToken is owned  {
21 
22     uint256 public sellPrice;
23     uint256 public buyPrice;
24 		    /* Public variables of the token */
25     string public standard = 'Token 0.1';
26     string public name;
27     string public symbol;
28     uint8 public decimalUnits;
29     uint256 public totalSupply;
30 
31     mapping (address => bool) public frozenAccount;
32 
33     /* This generates a public event on the blockchain that will notify clients */
34     event FrozenFunds(address target, bool frozen);
35 
36     /* Initializes contract with initial supply tokens to the creator of the contract */
37     function GSIToken(
38         uint256 initialSupply,
39         string _tokenName,
40         uint8 _decimalUnits,
41         string _tokenSymbol,
42         address centralMinter
43     )  {
44         if(centralMinter != 0 ) owner = centralMinter;      // Sets the owner as specified (if centralMinter is not specified the owner is msg.sender)
45         balanceOf[owner] = initialSupply;                   // Give the owner all initial tokens
46 		totalSupply=initialSupply;
47 		name=_tokenName;
48 		decimalUnits=_decimalUnits;
49 		symbol=_tokenSymbol;
50     }
51 
52     /* Send coins */
53     function transfer(address _to, uint256 _value) {
54         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
55         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
56         if (frozenAccount[msg.sender]) throw;                // Check if frozen
57         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
58         balanceOf[_to] += _value;                            // Add the same to the recipient
59         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
60     }
61 
62 
63     /* A contract attempts to get the coins */
64     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
65         if (frozenAccount[_from]) throw;                        // Check if frozen            
66         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
67         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
68         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
69         balanceOf[_from] -= _value;                          // Subtract from the sender
70         balanceOf[_to] += _value;                            // Add the same to the recipient
71         allowance[_from][msg.sender] -= _value;
72         Transfer(_from, _to, _value);
73         return true;
74     }
75 
76     function mintToken(address target, uint256 mintedAmount) {
77 	    if(msg.sender!=owner) throw;
78         balanceOf[target] += mintedAmount;
79         totalSupply += mintedAmount;
80         Transfer(0, owner, mintedAmount);
81         Transfer(owner, target, mintedAmount);
82     }
83 
84     function freezeAccount(address target, bool freeze) {
85 		if(msg.sender!=owner) throw;
86         frozenAccount[target] = freeze;
87         FrozenFunds(target, freeze);
88     }
89 
90     function setPrices(uint256 newSellPrice, uint256 newBuyPrice)  {
91 		if(msg.sender!=owner) throw;
92         sellPrice = newSellPrice;
93         buyPrice = newBuyPrice;
94     }
95 
96     function buy() {
97         uint amount = msg.value / buyPrice;                // calculates the amount
98         if (balanceOf[this] < amount) throw;               // checks if it has enough to sell
99         balanceOf[msg.sender] += amount;                   // adds the amount to buyer's balance
100         balanceOf[this] -= amount;                         // subtracts amount from seller's balance
101         Transfer(this, msg.sender, amount);                // execute an event reflecting the change
102     }
103 
104     function sell(uint256 amount) {
105         if (balanceOf[msg.sender] < amount ) throw;        // checks if the sender has enough to sell
106         balanceOf[this] += amount;                         // adds the amount to owner's balance
107         balanceOf[msg.sender] -= amount;                   // subtracts the amount from seller's balance
108         if (!msg.sender.send(amount * sellPrice)) {        // sends ether to the seller. It's important
109             throw;                                         // to do this last to avoid recursion attacks
110         } else {
111             Transfer(msg.sender, this, amount);            // executes an event reflecting on the change
112         }               
113     }
114 
115 
116     /* This creates an array with all balances */
117     mapping (address => uint256) public balanceOf;
118     mapping (address => mapping (address => uint256)) public allowance;
119 
120     /* This generates a public event on the blockchain that will notify clients */
121     event Transfer(address indexed from, address indexed to, uint256 value);
122 
123 
124     /* Allow another contract to spend some tokens in your behalf */
125     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
126         returns (bool success) {
127         allowance[msg.sender][_spender] = _value;
128         tokenRecipient spender = tokenRecipient(_spender);
129         spender.receiveApproval(msg.sender, _value, this, _extraData);
130         return true;
131     }
132 
133 
134     /* This unnamed function is called whenever someone tries to send ether to it */
135     function () {
136         throw;     // Prevents accidental sending of ether
137     }
138 }
139 
140 contract GSI is owned {
141 		event OracleRequest(address target);
142 		event MintedGreen(address target,uint256 amount);
143 		event MintedGrey(address target,uint256 amount);
144 		
145 		GSIToken public greenToken;
146 		GSIToken public greyToken;
147 		uint256 public requiredGas;
148 		uint256 public secondsBetweenReadings;
149 		
150 		mapping(address=>Reading) public lastReading;
151 		mapping(address=>Reading) public requestReading;
152 		mapping(address=>uint8) public freeReadings;
153 		mapping(address=>string) public plz;
154 		mapping(address=>uint8) public oracles;
155 		
156 		struct Reading {
157 			uint256 timestamp;
158 			uint256 value;
159 			string zip;
160 		}
161 		
162 		function GSI() {
163 			greenToken = new GSIToken(
164 							0,
165 							'GreenPower',
166 							0,
167 							'P+',
168 							this
169 			);			
170 			greyToken = new GSIToken(
171 							0,
172 							'GreyPower',
173 							0,
174 							'P-',
175 							this
176 			);		
177 			oracles[msg.sender]=1;
178 		}
179 		
180 		function oracalizeReading(uint256 _reading) {
181 			if(msg.value<requiredGas) {  
182 				if(freeReadings[msg.sender]==0) throw;
183 				freeReadings[msg.sender]--;
184 			} 		
185 			if(_reading<lastReading[msg.sender].value) throw;
186 			if(_reading<requestReading[msg.sender].value) throw;
187 			if(now<lastReading[msg.sender].timestamp+secondsBetweenReadings) throw;			
188 			//lastReading[msg.sender]=requestReading[msg.sender];
189 			requestReading[msg.sender]=Reading(now,_reading,plz[msg.sender]);
190 			OracleRequest(msg.sender);
191 			owner.send(msg.value);
192 		}	
193 		
194 		function addOracle(address oracle) {
195 			if(msg.sender!=owner) throw;
196 			oracles[oracle]=1;
197 			
198 		}
199 		function setPlz(string _plz) {
200 			plz[msg.sender]=_plz;
201 		}
202 		function setReadingDelay(uint256 delay) {
203 			if(msg.sender!=owner) throw;
204 			secondsBetweenReadings=delay;
205 		}
206 		
207 		function assignFreeReadings(address _receiver,uint8 _count)  {
208 			if(oracles[msg.sender]!=1) throw;
209 			freeReadings[_receiver]+=_count;
210 		}	
211 		
212 		function mintGreen(address recipient,uint256 tokens) {
213 			if(oracles[msg.sender]!=1) throw;
214 			greenToken.mintToken(recipient, tokens);	
215 			MintedGreen(recipient,tokens);
216 		}
217 		
218 		function mintGrey(address recipient,uint256 tokens) {
219 			if(oracles[msg.sender]!=1) throw;	
220 			greyToken.mintToken(recipient, tokens);		
221 			MintedGrey(recipient,tokens);
222 		}
223 		
224 		function commitReading(address recipient) {
225 		  if(oracles[msg.sender]!=1) throw;
226 		  lastReading[recipient]=requestReading[recipient];
227 		  msg.sender.send(this.balance);
228 		  //owner.send(this.balance);
229 		}
230 		
231 		function setGreenToken(GSIToken _greenToken) {
232 			if(msg.sender!=owner) throw;
233 			greenToken=_greenToken;			
234 		} 
235 		
236 		function setGreyToken(GSIToken _greyToken) {
237 			if(msg.sender!=owner) throw;
238 			greyToken=_greyToken;			
239 		} 
240 		
241 		function setOracleGas(uint256 _requiredGas)  {
242 			if(msg.sender!=owner) throw;
243 			requiredGas=_requiredGas;
244 		}
245 		
246 		function() {
247 			if(msg.value>0) {
248 				owner.send(msg.value);
249 			}
250 		}
251 }