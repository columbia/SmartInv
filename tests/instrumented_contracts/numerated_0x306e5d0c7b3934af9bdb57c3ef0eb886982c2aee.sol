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
73         collectorAddress = 0x6835706E8e58544deb6c4EC59d9815fF6C20417f;
74         collectorTokens = 0x08A735E8DA11d3ecf9ED684B8013ab53E9D226c2;
75 	    oldTokenAdd = 0x58ca3065C0F24C7c96Aee8d6056b5B5deCf9c2f8;
76 	    newTokenAdd = 0x22f0af8d78851b72ee799e05f54a77001586b18a;
77         tokenSpender = 0x6835706E8e58544deb6c4EC59d9815fF6C20417f;
78 
79 	    Etherrate = 3000;
80 	    Tokenrate = 10;
81 
82 	    authorized[authorizedCaller] = 1;
83 
84 	    lastBlock = 0;
85 	}
86 
87 
88 	// Mapping to store swaps made and authorized callers
89 
90     mapping(bytes32 => uint) internal payments;
91     mapping(address => uint8) internal authorized;
92 
93     // Event definitions
94 
95     event EtherReceived(uint _n , address _address , uint _value);
96     event GXVCSentByEther(uint _n , address _address , uint _value);
97 
98     event GXVCReplay(uint _n , address _address);
99     event GXVCNoToken(uint _n , address _address);
100 
101     event TokensReceived(uint _n , address _address , uint _value);
102     event GXVCSentByToken(uint _n , address _address , uint _value );
103 
104     event SwapPaused(uint _n);
105     event SwapResumed(uint _n);
106 
107     event EtherrateUpd(uint _n , uint _rate);
108     event TokenrateUpd(uint _n , uint _rate);
109 
110     // Modifier for authorized calls
111 
112     modifier isAuthorized() {
113         if ( authorized[msg.sender] != 1 ) revert();
114         _;
115     }
116 
117     modifier isNotPaused() {
118     	if (pausedSwap) revert();
119     	_;
120     }
121 
122     // Function borrowed from ds-math.
123 
124     function mul(uint x, uint y) internal returns (uint z) {
125         require(y == 0 || (z = x * y) / y == x);
126     }
127 
128     // Falback function, invoked each time ethers are received
129 
130     function () payable { 
131         makeSwapInternal ();
132     }
133 
134 
135     // Ether swap, activated by the fallback function after receiving ethers
136 
137    function makeSwapInternal () private isNotPaused { // Main function, called internally when ethers are received
138 
139      ERC223 newTok = ERC223 ( newTokenAdd );
140 
141      address _address = msg.sender;
142      uint _value = msg.value;
143 
144      // Calculate the amount to send based on the rates supplied
145 
146      uint etherstosend = mul( _value , Etherrate ) / 100000000; // Division to equipare 18 decimals to 10
147 
148      // ---------------------------------------- Ether exchange --------------------------------------------
149 
150     if ( etherstosend > 0 ) {   
151 
152         // Log Ether received
153         EtherReceived ( 1, _address , _value);
154 
155         //Send new tokens
156         require( newTok.transferFrom( tokenSpender , _address , etherstosend ) );
157 		// Log tokens sent for ethers;
158         GXVCSentByEther ( 2, _address , etherstosend) ;
159         // Send ethers to collector
160         require( collectorAddress.send( _value ) );
161         }
162 
163     }
164 
165     // This function is called from a javascript through an authorized address to inform of a transfer 
166     // of old token.
167     // Parameters are trusted, but they may be accidentally replayed (specially if a rescan is made) 
168     // so we store them in a mapping to avoid reprocessing
169     // We store the tx_hash, to allow many different swappings per address
170 
171     function makeSwap (address _address , uint _value , bytes32 _hash) public isAuthorized isNotPaused {
172 
173     ERC223 newTok = ERC223 ( newTokenAdd );
174 
175 	// Calculate the amount to send based on the rates supplied
176 
177     uint gpxtosend = mul( _value , Tokenrate ); 
178 
179      // ----------------------------------- No tokens or already used -------------------------------------
180 
181     if ( payments[_hash] > 0 ) { // Check for accidental replay
182         GXVCReplay( 3, _address ); // Log "Done before";
183         return;
184      }
185 
186      if ( gpxtosend == 0 ) {
187         GXVCNoToken( 4, _address ); // Log "No GXC tokens found";
188         return;
189      }
190       // ---------------------------------------- GPX exchange --------------------------------------------
191               
192      TokensReceived( 5, _address , _value ); // Log balance detected
193 
194      payments[_hash] = gpxtosend; // To avoid future accidental replays
195 
196       // Transfer new tokens to caller
197      require( newTok.transferFrom( tokenSpender , _address , gpxtosend ) );
198 
199      GXVCSentByToken( 6, _address , gpxtosend ); // Log "New token sent";
200 
201      lastBlock = block.number + 1;
202 
203     }
204 
205 function pauseSwap () public isAuthorized {
206 	pausedSwap = true;
207 	SwapPaused(7);
208 }
209 
210 function resumeSwap () public isAuthorized {
211 	pausedSwap = false;
212 	SwapResumed(8);
213 }
214 
215 function updateOldToken (address _address) public isAuthorized {
216     oldTokenAdd = _address;
217 }
218 
219 function updateNewToken (address _address , address _spender) public isAuthorized {
220     newTokenAdd = _address;
221     tokenSpender = _spender;   
222 }
223 
224 
225 function updateEthRate (uint _rate) public isAuthorized {
226     Etherrate = _rate;
227     EtherrateUpd(9,_rate);
228 }
229 
230 
231 function updateTokenRate (uint _rate) public isAuthorized {
232     Tokenrate = _rate;
233     TokenrateUpd(10,_rate);
234 }
235 
236 
237 function flushEthers () public isAuthorized { // Send ether to collector
238     require( collectorAddress.send( this.balance ) );
239 }
240 
241 function flushTokens () public isAuthorized {
242 	ERC20 oldTok = ERC20 ( oldTokenAdd );
243 	require( oldTok.transfer(collectorTokens , oldTok.balanceOf(this) ) );
244 }
245 
246 function addAuthorized(address _address) public isAuthorized {
247 	authorized[_address] = 1;
248 
249 }
250 
251 function removeAuthorized(address _address) public isAuthorized {
252 	authorized[_address] = 0;
253 
254 }
255 
256 
257 }