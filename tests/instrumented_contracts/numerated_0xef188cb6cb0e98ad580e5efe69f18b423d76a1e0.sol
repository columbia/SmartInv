1 pragma solidity ^0.4.15;
2 
3     /****************************************************************
4      *
5      * Name of the project: Genevieve VC Token Swapper
6      * Contract name: Swap
7      * Author: Juan Livingston @ Ethernity.live
8      * Developed for: Genevieve Co.
9      * GXVC is an ERC223 Token Swapper
10      *
11      * This swapper has 2 main functions: 
12      * - makeSwapInternal will send new tokens when ether are received
13      * - makeSwap will send new tokens when old tokens are received
14      *  
15      * makeSwap is called by a javascript through an authorized address
16      *
17      ****************************************************************/
18 
19 contract ERC20Basic {
20   uint256 public totalSupply;
21   function balanceOf(address who) constant returns (uint256);
22   function transfer(address to, uint256 value) returns (bool);
23   event Transfer(address indexed from, address indexed to, uint256 value);
24 }
25 
26 contract ERC20 is ERC20Basic {
27   function allowance(address owner, address spender) constant returns (uint256);
28   function transferFrom(address from, address to, uint256 value) returns (bool);
29   function approve(address spender, uint256 value) returns (bool);
30   function burn(address spender, uint256 value) returns (bool); // Optional 
31   event Approval(address indexed owner, address indexed spender, uint256 value);
32 }
33 
34 contract ERC223 {
35   uint public totalSupply;
36   function balanceOf(address who) constant returns (uint);
37   
38   function name() constant returns (string _name);
39   function symbol() constant returns (string _symbol);
40   function decimals() constant returns (uint8 _decimals);
41   function totalSupply() constant returns (uint256 _supply);
42 
43   function transfer(address to, uint value) returns (bool ok);
44   function transfer(address to, uint value, bytes data) returns (bool ok);
45   function transfer(address to, uint value, bytes data, string custom_fallback) returns (bool ok);
46   function transferFrom(address from, address to, uint256 value) returns (bool);
47   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
48 }
49 
50 
51 contract Swap {
52 
53     address authorizedCaller;
54     address collectorAddress;
55     address collectorTokens;
56 
57     address oldTokenAdd;
58     address newTokenAdd; 
59     address tokenSpender;
60 
61     uint Etherrate;
62     uint Tokenrate;
63 
64     bool pausedSwap;
65 
66     uint public lastBlock;
67 
68     // Constructor function with main constants and variables 
69  
70  	function Swap() {
71 	    authorizedCaller = msg.sender;
72 
73 	    oldTokenAdd = 0x58ca3065C0F24C7c96Aee8d6056b5B5deCf9c2f8;
74 	    newTokenAdd = 0x22f0af8d78851b72ee799e05f54a77001586b18a; 
75 
76 	    Etherrate = 3000;
77 	    Tokenrate = 10;
78 
79 	    authorized[authorizedCaller] = 1;
80 
81 	    lastBlock = 0;
82 	}
83 
84 
85 	// Mapping to store swaps made and authorized callers
86 
87     mapping(bytes32 => uint) internal payments;
88     mapping(address => uint8) internal authorized;
89 
90     // Event definitions
91 
92     event EtherReceived(uint _n , address _address , uint _value);
93     event GXVCSentByEther(uint _n , address _address , uint _value);
94 
95     event GXVCReplay(uint _n , address _address);
96     event GXVCNoToken(uint _n , address _address);
97 
98     event TokensReceived(uint _n , address _address , uint _value);
99     event GXVCSentByToken(uint _n , address _address , uint _value );
100 
101     event SwapPaused(uint _n);
102     event SwapResumed(uint _n);
103 
104     event EtherrateUpd(uint _n , uint _rate);
105     event TokenrateUpd(uint _n , uint _rate);
106 
107     // Modifier for authorized calls
108 
109     modifier isAuthorized() {
110         if ( authorized[msg.sender] != 1 ) revert();
111         _;
112     }
113 
114     modifier isNotPaused() {
115     	if (pausedSwap) revert();
116     	_;
117     }
118 
119     // Function borrowed from ds-math.
120 
121     function mul(uint x, uint y) internal returns (uint z) {
122         require(y == 0 || (z = x * y) / y == x);
123     }
124 
125     // Falback function, invoked each time ethers are received
126 
127     function () payable { 
128         makeSwapInternal ();
129     }
130 
131 
132     // Ether swap, activated by the fallback function after receiving ethers
133 
134    function makeSwapInternal () private isNotPaused { // Main function, called internally when ethers are received
135 
136      ERC223 newTok = ERC223 ( newTokenAdd );
137 
138      address _address = msg.sender;
139      uint _value = msg.value;
140 
141      // Calculate the amount to send based on the rates supplied
142 
143      uint etherstosend = mul( _value , Etherrate ) / 100000000; // Division to equipare 18 decimals to 10
144 
145      // ---------------------------------------- Ether exchange --------------------------------------------
146 
147     if ( etherstosend > 0 ) {   
148 
149         // Log Ether received
150         EtherReceived ( 1, _address , _value);
151 
152         //Send new tokens
153         require( newTok.transferFrom( tokenSpender , _address , etherstosend ) );
154 		// Log tokens sent for ethers;
155         GXVCSentByEther ( 2, _address , etherstosend) ;
156         // Send ethers to collector
157         require( collectorAddress.send( _value ) );
158         }
159 
160     }
161 
162     // This function is called from a javascript through an authorized address to inform of a transfer 
163     // of old token.
164     // Parameters are trusted, but they may be accidentally replayed (specially if a rescan is made) 
165     // so we store them in a mapping to avoid reprocessing
166     // We store the tx_hash, to allow many different swappings per address
167 
168     function makeSwap (address _address , uint _value , bytes32 _hash) public isAuthorized isNotPaused {
169 
170     ERC223 newTok = ERC223 ( newTokenAdd );
171 
172 	// Calculate the amount to send based on the rates supplied
173 
174     uint gpxtosend = mul( _value , Tokenrate ); 
175 
176      // ----------------------------------- No tokens or already used -------------------------------------
177 
178     if ( payments[_hash] > 0 ) { // Check for accidental replay
179         GXVCReplay( 3, _address ); // Log "Done before";
180         return;
181      }
182 
183      if ( gpxtosend == 0 ) {
184         GXVCNoToken( 4, _address ); // Log "No GXC tokens found";
185         return;
186      }
187       // ---------------------------------------- GPX exchange --------------------------------------------
188               
189      TokensReceived( 5, _address , _value ); // Log balance detected
190 
191      payments[_hash] = gpxtosend; // To avoid future accidental replays
192 
193       // Transfer new tokens to caller
194      require( newTok.transferFrom( tokenSpender , _address , gpxtosend ) );
195 
196      GXVCSentByToken( 6, _address , gpxtosend ); // Log "New token sent";
197 
198      lastBlock = block.number + 1;
199 
200     }
201 
202 function pauseSwap () public isAuthorized {
203 	pausedSwap = true;
204 	SwapPaused(7);
205 }
206 
207 function resumeSwap () public isAuthorized {
208 	pausedSwap = false;
209 	SwapResumed(8);
210 }
211 
212 function updateOldToken (address _address) public isAuthorized {
213     oldTokenAdd = _address;
214 }
215 
216 function updateNewToken (address _address , address _spender) public isAuthorized {
217     newTokenAdd = _address;
218     tokenSpender = _spender;   
219 }
220 
221 
222 function updateEthRate (uint _rate) public isAuthorized {
223     Etherrate = _rate;
224     EtherrateUpd(9,_rate);
225 }
226 
227 
228 function updateTokenRate (uint _rate) public isAuthorized {
229     Tokenrate = _rate;
230     TokenrateUpd(10,_rate);
231 }
232 
233 
234 function flushEthers () public isAuthorized { // Send ether to collector
235     require( collectorAddress.send( this.balance ) );
236 }
237 
238 function flushTokens () public isAuthorized {
239 	ERC20 oldTok = ERC20 ( oldTokenAdd );
240 	require( oldTok.transfer(collectorTokens , oldTok.balanceOf(this) ) );
241 }
242 
243 function addAuthorized(address _address) public isAuthorized {
244 	authorized[_address] = 1;
245 
246 }
247 
248 function removeAuthorized(address _address) public isAuthorized {
249 	authorized[_address] = 0;
250 
251 }
252 
253 
254 }