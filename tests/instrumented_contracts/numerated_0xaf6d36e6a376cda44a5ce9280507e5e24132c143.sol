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
22 	/* Public variables of the token */
23     string public standard = 'Token 0.1';
24     string public name;
25     string public symbol;
26     uint8 public decimalUnits;
27     uint256 public totalSupply;
28 	GSIToken public exchangeToken;
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
75     function mintToken(address target, uint256 mintedAmount) {
76 	    if(msg.sender!=owner) throw;
77         balanceOf[target] += mintedAmount;
78         totalSupply += mintedAmount;
79         Transfer(0, owner, mintedAmount);
80         Transfer(owner, target, mintedAmount);
81     }
82 
83     function freezeAccount(address target, bool freeze) {
84 		if(msg.sender!=owner) throw;
85         frozenAccount[target] = freeze;
86         FrozenFunds(target, freeze);
87     }
88 
89 	function setExchangeToken(GSIToken _exchangeToken) {
90 		if(msg.sender!=owner) throw;
91 		exchangeToken=_exchangeToken;
92 	}
93 	    
94 	function demintTokens(address target,uint8 amount)  {
95 		if(msg.sender!=owner) throw;
96 		if(balanceOf[target]<amount) throw;
97 		balanceOf[msg.sender]+=amount;
98 		balanceOf[target]-=amount;
99 		Transfer(target,owner,amount);
100 	}
101 	
102     /* This creates an array with all balances */
103     mapping (address => uint256) public balanceOf;
104     mapping (address => mapping (address => uint256)) public allowance;
105 
106     /* This generates a public event on the blockchain that will notify clients */
107     event Transfer(address indexed from, address indexed to, uint256 value);
108 
109 
110     /* Allow another contract to spend some tokens in your behalf */
111     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
112         returns (bool success) {
113         allowance[msg.sender][_spender] = _value;
114         tokenRecipient spender = tokenRecipient(_spender);
115         spender.receiveApproval(msg.sender, _value, this, _extraData);
116         return true;
117     }
118 	
119     /* This unnamed function is called whenever someone tries to send ether to it */
120     function () {
121         throw;     // Prevents accidental sending of ether
122     }
123 }
124 
125 contract GSI is owned {
126 		event OracleRequest(address target);
127 		event MintedGreen(address target,uint256 amount);
128 		event MintedGrey(address target,uint256 amount);
129 		
130 		GSIToken public greenToken;
131 		GSIToken public greyToken;
132 		uint256 public requiredGas;
133 		uint256 public secondsBetweenReadings;
134 		uint8 public pricegreengrey;
135 		
136 		mapping(address=>Reading) public lastReading;
137 		mapping(address=>Reading) public requestReading;
138 		mapping(address=>uint8) public freeReadings;
139 		mapping(address=>string) public plz;
140 		mapping(address=>uint8) public oracles;
141 		
142 		struct Reading {
143 			uint256 timestamp;
144 			uint256 value;
145 			string zip;
146 		}
147 		
148 		function GSI() {
149 			greenToken = new GSIToken(
150 							0,
151 							'GreenPower',
152 							0,
153 							'P+',
154 							this
155 			);			
156 			greyToken = new GSIToken(
157 							0,
158 							'GreyPower',
159 							0,
160 							'P-',
161 							this
162 			);		
163 			greenToken.setExchangeToken(greyToken);
164 			greyToken.setExchangeToken(greenToken);
165 			oracles[msg.sender]=1;
166 		}
167 		
168 		function oracalizeReading(uint256 _reading) {
169 			if(msg.value<requiredGas) {  
170 				if(freeReadings[msg.sender]==0) throw;
171 				freeReadings[msg.sender]--;
172 			} 		
173 			if(_reading<lastReading[msg.sender].value) throw;
174 			if(_reading<requestReading[msg.sender].value) throw;
175 			if(now<lastReading[msg.sender].timestamp+secondsBetweenReadings) throw;			
176 			//lastReading[msg.sender]=requestReading[msg.sender];
177 			requestReading[msg.sender]=Reading(now,_reading,plz[msg.sender]);
178 			OracleRequest(msg.sender);
179 			owner.send(msg.value);
180 		}	
181 		
182 		function addOracle(address oracle) {
183 			if(msg.sender!=owner) throw;
184 			oracles[oracle]=1;
185 			
186 		}
187 		function setPlz(string _plz) {
188 			plz[msg.sender]=_plz;
189 		}
190 		function setReadingDelay(uint256 delay) {
191 			if(msg.sender!=owner) throw;
192 			secondsBetweenReadings=delay;
193 		}
194 		
195 		function assignFreeReadings(address _receiver,uint8 _count)  {
196 			if(oracles[msg.sender]!=1) throw;
197 			freeReadings[_receiver]+=_count;
198 		}	
199 		
200 		function mintGreen(address recipient,uint256 tokens) {
201 			if(oracles[msg.sender]!=1) throw;
202 			greenToken.mintToken(recipient, tokens);	
203 			MintedGreen(recipient,tokens);
204 		}
205 		
206 		function mintGrey(address recipient,uint256 tokens) {
207 			if(oracles[msg.sender]!=1) throw;	
208 			greyToken.mintToken(recipient, tokens);		
209 			MintedGrey(recipient,tokens);
210 		}
211 		
212 		function commitReading(address recipient) {
213 		  if(oracles[msg.sender]!=1) throw;
214 		  lastReading[recipient]=requestReading[recipient];
215 		  if(this.balance>10*requiredGas) {
216 			owner.send(this.balance);
217 		  }
218 		  //owner.send(this.balance);
219 		}
220 		
221 		function setGreenToken(GSIToken _greenToken) {
222 			if(msg.sender!=owner) throw;
223 			greenToken=_greenToken;			
224 		} 
225 		
226 		function setGreyToken(GSIToken _greyToken) {
227 			if(msg.sender!=owner) throw;
228 			greyToken=_greyToken;			
229 		} 
230 		
231 		function setOracleGas(uint256 _requiredGas)  {
232 			if(msg.sender!=owner) throw;
233 			requiredGas=_requiredGas;
234 		}
235 
236 		function setGreyGreenPrice(uint8 price) {
237 			if(msg.sender!=owner) throw;
238 			pricegreengrey=price;
239 		}
240 		
241 		function convertGreyGreen(uint8 price,uint8 amount) {
242 			if(price<pricegreengrey) throw;
243 			if(greenToken.balanceOf(msg.sender)<amount*price) throw;
244 			if(greyToken.balanceOf(msg.sender)<amount) throw;
245 			greyToken.demintTokens(msg.sender,amount);
246 		}
247 		function() {
248 			if(msg.value>0) {
249 				owner.send(this.balance);
250 			}
251 		}
252 }