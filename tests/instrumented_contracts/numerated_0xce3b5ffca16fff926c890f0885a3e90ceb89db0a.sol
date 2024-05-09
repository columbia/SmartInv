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
34 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
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
68         if (_value > allowed[_from][msg.sender]) throw;   // Check allowed
69         balanceOf[_from] -= _value;                          // Subtract from the sender
70         balanceOf[_to] += _value;                            // Add the same to the recipient
71         allowed[_from][msg.sender] -= _value;
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
90 	function setExchangeToken(GSIToken _exchangeToken) {
91 		if(msg.sender!=owner) throw;
92 		exchangeToken=_exchangeToken;
93 	}
94 	    
95 	function demintTokens(address target,uint8 amount)  {
96 		if(msg.sender!=owner) throw;
97 		if(balanceOf[target]<amount) throw;
98 		balanceOf[msg.sender]+=amount;
99 		balanceOf[target]-=amount;
100 		Transfer(target,owner,amount);
101 	}
102 	
103     /* This creates an array with all balances */
104     mapping (address => uint256) public balanceOf;
105     mapping (address => mapping (address => uint256)) public allowed;
106 
107     /* This generates a public event on the blockchain that will notify clients */
108     event Transfer(address indexed from, address indexed to, uint256 value);
109 
110 
111     /* Allow another contract to spend some tokens in your behalf */
112     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
113         returns (bool success) {
114         allowed[msg.sender][_spender] = _value;
115         tokenRecipient spender = tokenRecipient(_spender);
116         spender.receiveApproval(msg.sender, _value, this, _extraData);
117         return true;
118     }
119 	
120 	function approve(address _spender, uint256 _value) returns (bool success) {
121         allowed[msg.sender][_spender] = _value;
122         Approval(msg.sender, _spender, _value);
123         return true;
124     }
125 
126     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
127       return allowed[_owner][_spender];
128     }
129 	
130     /* This unnamed function is called whenever someone tries to send ether to it */
131     function () {
132         throw;     // Prevents accidental sending of ether
133     }
134 }
135 
136 contract GSI is owned {
137 		event OracleRequest(address target);
138 		event MintedGreen(address target,uint256 amount);
139 		event MintedGrey(address target,uint256 amount);
140 		
141 		GSIToken public greenToken;
142 		GSIToken public greyToken;
143 		uint256 public requiredGas;
144 		uint256 public secondsBetweenReadings;
145 		uint8 public pricegreengrey;
146 		
147 		mapping(address=>Reading) public lastReading;
148 		mapping(address=>Reading) public requestReading;
149 		mapping(address=>uint8) public freeReadings;
150 		mapping(address=>string) public plz;
151 		mapping(address=>uint8) public oracles;
152 		
153 		struct Reading {
154 			uint256 timestamp;
155 			uint256 value;
156 			string zip;
157 		}
158 		
159 		function GSI() {
160 			greenToken = new GSIToken(
161 							0,
162 							'GreenPower',
163 							0,
164 							'P+',
165 							this
166 			);			
167 			greyToken = new GSIToken(
168 							0,
169 							'GreyPower',
170 							0,
171 							'P-',
172 							this
173 			);		
174 			greenToken.setExchangeToken(greyToken);
175 			greyToken.setExchangeToken(greenToken);
176 			oracles[msg.sender]=1;
177 		}
178 		
179 		function oracalizeReading(uint256 _reading) {
180 			if(msg.value<requiredGas) {  
181 				if(freeReadings[msg.sender]==0) throw;
182 				freeReadings[msg.sender]--;
183 			} 		
184 			if(_reading<lastReading[msg.sender].value) throw;
185 			if(_reading<requestReading[msg.sender].value) throw;
186 			if(now<lastReading[msg.sender].timestamp+secondsBetweenReadings) throw;			
187 			//lastReading[msg.sender]=requestReading[msg.sender];
188 			requestReading[msg.sender]=Reading(now,_reading,plz[msg.sender]);
189 			OracleRequest(msg.sender);
190 			owner.send(msg.value);
191 		}	
192 		
193 		function addOracle(address oracle) {
194 			if(msg.sender!=owner) throw;
195 			oracles[oracle]=1;
196 			
197 		}
198 		function setPlz(string _plz) {
199 			plz[msg.sender]=_plz;
200 		}
201 		function setReadingDelay(uint256 delay) {
202 			if(msg.sender!=owner) throw;
203 			secondsBetweenReadings=delay;
204 		}
205 		
206 		function assignFreeReadings(address _receiver,uint8 _count)  {
207 			if(oracles[msg.sender]!=1) throw;
208 			freeReadings[_receiver]+=_count;
209 		}	
210 		
211 		function mintGreen(address recipient,uint256 tokens) {
212 			if(oracles[msg.sender]!=1) throw;
213 			greenToken.mintToken(recipient, tokens);	
214 			lastReading[recipient]=Reading(now,(tokens/10)+lastReading[recipient].value,plz[msg.sender]);
215 			MintedGreen(recipient,tokens);
216 		}
217 		
218 		function mintGrey(address recipient,uint256 tokens) {
219 			if(oracles[msg.sender]!=1) throw;				
220 			greyToken.mintToken(recipient, tokens);		
221 			lastReading[recipient]=Reading(now,(tokens/10)+lastReading[recipient].value,plz[msg.sender]);
222 			MintedGrey(recipient,tokens);
223 		}
224 		
225 		function commitReading(address recipient) {
226 		  if(oracles[msg.sender]!=1) throw;
227 		  lastReading[recipient]=requestReading[recipient];		  
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
246 		function setGreyGreenPrice(uint8 price) {
247 			if(msg.sender!=owner) throw;
248 			pricegreengrey=price;
249 		}
250 		
251 		function convertGreyGreen(uint8 price,uint8 amount) {
252 			if(price<pricegreengrey) throw;
253 			if(greenToken.balanceOf(msg.sender)<amount*price) throw;
254 			if(greyToken.balanceOf(msg.sender)<amount) throw;
255 			greyToken.demintTokens(msg.sender,amount);
256 		}
257 		function() {
258 			if(msg.value>0) {
259 				owner.send(this.balance);
260 			}
261 		}
262 }