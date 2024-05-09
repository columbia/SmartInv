1 pragma solidity ^0.4.15;
2 
3     /****************************************************************
4      *
5      * Name of the project: Genevieve GXVC New ICO
6      * Contract name: NewIco
7      * Author: Juan Livingston @ Ethernity.live
8 	 *
9      ****************************************************************/
10 
11 contract ERC20Basic {
12   uint256 public totalSupply;
13   function balanceOf(address who) constant returns (uint256);
14   function transfer(address to, uint256 value) returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 contract ERC20 is ERC20Basic {
19   function allowance(address owner, address spender) constant returns (uint256);
20   function transferFrom(address from, address to, uint256 value) returns (bool);
21   function approve(address spender, uint256 value) returns (bool);
22   function burn(address spender, uint256 value) returns (bool); // Optional 
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 contract ERC223 {
27   uint public totalSupply;
28   function balanceOf(address who) constant returns (uint);
29   
30   function name() constant returns (string _name);
31   function symbol() constant returns (string _symbol);
32   function decimals() constant returns (uint8 _decimals);
33   function totalSupply() constant returns (uint256 _supply);
34 
35   function transfer(address to, uint value) returns (bool ok);
36   function transfer(address to, uint value, bytes data) returns (bool ok);
37   function transfer(address to, uint value, bytes data, string custom_fallback) returns (bool ok);
38   function transferFrom(address from, address to, uint256 value) returns (bool);
39   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
40 }
41 
42 contract Whitelist {
43   mapping (address => bool) public registered;
44 }
45 
46 contract IcoExt {
47 
48     address public authorizedCaller;
49     address public collectorAddress;
50     address public owner;
51     address public whitelistAdd;
52 
53     address public tokenAdd; 
54     address public tokenSpender;
55 
56     uint public initialPrice;
57     uint public initialTime;
58     uint tokenPrice;
59 
60     uint increasePerBlock;
61     uint increasePerBlockDiv;
62 
63     bool public autoPrice;
64     bool public isPaused;
65 
66     uint public minAcceptedETH;
67 
68     uint public tokenDecimals;
69     uint public tokenMult;
70 
71     uint8 public stage;
72 
73     // Main counters
74 
75     uint public totalReceived;
76     uint public totalSent;
77 
78     // Constructor function with main constants and variables 
79  
80  	function IcoExt() {
81 		authorizedCaller = msg.sender;
82 		owner = msg.sender;
83 
84 		collectorAddress = 0x6835706E8e58544deb6c4EC59d9815fF6C20417f;
85 		tokenAdd = 0x22f0af8d78851b72ee799e05f54a77001586b18a;
86 		tokenSpender = 0x6835706E8e58544deb6c4EC59d9815fF6C20417f;
87 
88 		whitelistAdd = 0xad56C554f32D51526475d541F5DeAabE1534854d;
89 
90 		authorized[authorizedCaller] = true;
91 
92 		minAcceptedETH = 0.05 ether;
93 
94 		tokenDecimals = 10;
95 		tokenMult = 10 ** tokenDecimals;
96 
97 		initialPrice = 10000 * tokenMult; // 10,000 tokens per ether (0,0001 eth/token)
98 		tokenPrice = initialPrice;
99 		autoPrice = true;
100 
101 		initialTime = 1520627210 ; // March 9th, 2018
102 		increasePerBlock = 159; // Percentage to add per each block respect original price, in cents
103 		increasePerBlockDiv = 1000000000; // According to specs: 1.59% x 10 ^ -5 (= 159 / 10 ^ 7) == 0.055 % per day
104 
105 		stage = 1;
106 	}
107 
108 
109 	// Mapping to store swaps made and authorized callers
110 
111     mapping(address => uint) public receivedFrom;
112     mapping(address => uint) public sentTo;
113     mapping(address => bool) public authorized;
114 
115     // Event definitions
116 
117     event TokensSent(address _address , uint _received , uint _sent);
118 
119     // Modifier for authorized calls
120 
121     modifier isAuthorized() {
122         require(authorized[msg.sender]);
123         _;
124     }
125 
126     modifier isNotPaused() {
127     	require(!isPaused);
128     	_;
129     }
130 
131     // Function borrowed from ds-math.
132 
133     function mul(uint x, uint y) internal returns (uint z) {
134         require(y == 0 || (z = x * y) / y == x);
135     }
136 
137     // Falback function, invoked each time ethers are received
138 
139     function () payable { 
140         makeSwapInternal();
141     }
142 
143 
144     // Ether swap, activated by the fallback function after receiving ethers
145 
146    function makeSwapInternal() private isNotPaused { // Main function, called internally when ethers are received
147 
148    	require(stage>0 && stage<3 && msg.value >= minAcceptedETH);
149 
150     Whitelist wl = Whitelist(whitelistAdd);
151 
152    	if (stage==1 || stage==2 ) require(wl.registered(msg.sender));
153 
154     ERC223 GXVCtoken = ERC223(tokenAdd);
155 
156     address _address = msg.sender;
157     uint _value = msg.value;
158     uint _price = getPrice();
159 
160 	  uint tokensToSend = _price * _value / 10 ** 18;
161 
162     receivedFrom[_address] += _value;
163     totalReceived += _value;
164     sentTo[_address] += tokensToSend;
165     totalSent = tokensToSend;
166 
167     //Send tokens
168     require(GXVCtoken.transferFrom(tokenSpender,_address,tokensToSend));
169 	// Log tokens sent for ethers;
170     TokensSent(_address,_value,tokensToSend);
171     // Send ethers to collector
172     require(collectorAddress.send(_value));
173     }
174 
175   
176 
177 function getPrice() constant public returns(uint _price){
178     if (autoPrice) {
179         return calculatePrice(now);
180     	} else {
181     		return tokenPrice;
182     		}
183 }
184 
185 function getCurrentStage() public constant returns(uint8 _stage){
186 	return stage;
187 }
188 
189 function calculatePrice(uint _when) constant public returns(uint _result){
190 	if (_when == 0) _when = now;
191 	// 25 are estimated of 25 seconds per block
192 	uint delay = (_when - initialTime) / 25;
193 	uint factor = delay * increasePerBlock;
194 	uint multip = initialPrice * factor;
195 	uint result = initialPrice - multip / increasePerBlockDiv;
196 	require (result <= initialPrice);
197 	return result;
198  }
199 
200 
201 function changeToStage(uint8 _stage) isAuthorized returns(bool) {
202 	require(stage < _stage && _stage < 4);
203 	stage = _stage;
204 	return true;
205 }
206 
207 function pause() public isAuthorized {
208 	isPaused = true;
209 }
210 
211 function resume() public isAuthorized {
212 	isPaused = false;
213 }
214 
215 function setManualPrice(uint _price) public isAuthorized {
216     autoPrice = false;
217     tokenPrice = _price;
218 }
219 
220 function setAutoPrice() public isAuthorized {
221     autoPrice = true;
222 }
223 
224 function setInitialTime() public isAuthorized {
225     initialTime = now;
226 }
227 
228 function getNow() public constant returns(uint _now){
229 	return now;
230 }
231 
232 function flushEthers() public isAuthorized { // Send ether to collector
233   require( collectorAddress.send( this.balance ) );
234 }
235 
236 function changeMinAccEthers(uint _newMin) public isAuthorized {
237   minAcceptedETH = _newMin;
238 }
239 
240 function addAuthorized(address _address) public isAuthorized {
241 	authorized[_address] = true;
242 
243 }
244 
245 function removeAuthorized(address _address) public isAuthorized {
246 	require(_address != owner);
247 	authorized[_address] = false;
248 }
249 
250 function changeOwner(address _address) public {
251 	require(msg.sender == owner);
252 	owner = _address;
253 }
254 
255 // To manage ERC20 tokens in case of accidental sending to the contract
256 
257 function sendTokens(address _address , uint256 _amount) isAuthorized returns (bool success) {
258     ERC20Basic token = ERC20Basic( tokenAdd );
259     require( token.transfer(_address , _amount ) );
260     return true;
261 }
262 
263 
264 }