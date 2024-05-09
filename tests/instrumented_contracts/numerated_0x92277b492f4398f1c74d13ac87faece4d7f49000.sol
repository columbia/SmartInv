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
81 	    authorizedCaller = msg.sender;
82 	    owner = msg.sender;
83 
84       collectorAddress = 0x6835706E8e58544deb6c4EC59d9815fF6C20417f;
85 	    tokenAdd = 0x22f0af8d78851b72ee799e05f54a77001586b18a;
86       tokenSpender = 0x6835706E8e58544deb6c4EC59d9815fF6C20417f;
87 
88       whitelistAdd = 0xad56C554f32D51526475d541F5DeAabE1534854d;
89 
90 	    autoPrice = true;
91 	    authorized[authorizedCaller] = true;
92 
93       minAcceptedETH = 0.05 ether;
94 
95 	    tokenDecimals = 10;
96 	    tokenMult = 10 ** tokenDecimals;
97 
98 	   	initialPrice = 10000 * tokenMult; // 10,000 tokens per ether (0,0001 eth/token)
99       tokenPrice = initialPrice;
100       autoPrice = false;
101 
102 	    initialTime = now; // 1521590400; // March 21st, 2018
103 	    increasePerBlock = 159; // Percentage to add per each block respect original price, in cents
104 	    increasePerBlockDiv = 1000000000; // According to specs: 1,59% x 10 ^ -5 (= 159 / 10 ^ 7)
105 
106 	    stage = 0;
107 	}
108 
109 
110 	// Mapping to store swaps made and authorized callers
111 
112     mapping(address => uint) public receivedFrom;
113     mapping(address => uint) public sentTo;
114     mapping(address => bool) public authorized;
115 
116     // Event definitions
117 
118     event TokensSent(address _address , uint _received , uint _sent);
119 
120     // Modifier for authorized calls
121 
122     modifier isAuthorized() {
123         require(authorized[msg.sender]);
124         _;
125     }
126 
127     modifier isNotPaused() {
128     	require(!isPaused);
129     	_;
130     }
131 
132     // Function borrowed from ds-math.
133 
134     function mul(uint x, uint y) internal returns (uint z) {
135         require(y == 0 || (z = x * y) / y == x);
136     }
137 
138     // Falback function, invoked each time ethers are received
139 
140     function () payable { 
141         makeSwapInternal();
142     }
143 
144 
145     // Ether swap, activated by the fallback function after receiving ethers
146 
147    function makeSwapInternal() private isNotPaused { // Main function, called internally when ethers are received
148 
149    	require(stage>0 && stage<3 && msg.value >= minAcceptedETH);
150 
151     Whitelist wl = Whitelist(whitelistAdd);
152 
153    	if (stage==1 || stage==2 ) require(wl.registered(msg.sender));
154 
155     ERC223 GXVCtoken = ERC223(tokenAdd);
156 
157     address _address = msg.sender;
158     uint _value = msg.value;
159     uint _price = getPrice();
160 
161 	  uint tokensToSend = _price * _value / 10 ** 18;
162 
163     receivedFrom[_address] += _value;
164     totalReceived += _value;
165     sentTo[_address] += tokensToSend;
166     totalSent = tokensToSend;
167 
168     //Send tokens
169     require(GXVCtoken.transferFrom(tokenSpender,_address,tokensToSend));
170 	// Log tokens sent for ethers;
171     TokensSent(_address,_value,tokensToSend);
172     // Send ethers to collector
173     require(collectorAddress.send(_value));
174     }
175 
176   
177 
178 function getPrice() constant public returns(uint _price){
179     if (autoPrice) {
180         return calculatePrice(now);
181     	} else {
182     		return tokenPrice;
183     		}
184 }
185 
186 function getCurrentStage() public constant returns(uint8 _stage){
187 	return stage;
188 }
189 
190 function calculatePrice(uint _when) constant public returns(uint _result){
191 	if (_when == 0) _when = now;
192 	// 25 are estimated of 25 seconds per block
193 	uint delay = (_when - initialTime) / 25;
194 	uint factor = delay * increasePerBlock;
195 	uint multip = initialPrice * factor;
196 	uint result = initialPrice - multip / increasePerBlockDiv / 100; // 100 = percent
197 	require (result<=initialPrice);
198 	return result;
199    	//return initialPrice - initialPrice * (_when - initialTime) / 25 * increasePerBlock / increasePerBlockDiv;
200 }
201 
202 
203 function changeToStage(uint8 _stage) isAuthorized returns(bool) {
204 	require(stage<_stage && _stage < 4);
205 	stage = _stage;
206 	return true;
207 }
208 
209 function pause() public isAuthorized {
210 	isPaused = true;
211 }
212 
213 function resume() public isAuthorized {
214 	isPaused = false;
215 }
216 
217 function setManualPrice(uint _price) public isAuthorized {
218     autoPrice = false;
219     tokenPrice = _price;
220 }
221 
222 function setAutoPrice() public isAuthorized {
223     autoPrice = true;
224 }
225 
226 function setInitialTime() public isAuthorized {
227     initialTime = now;
228 }
229 
230 function getNow() public constant returns(uint _now){
231 	return now;
232 }
233 
234 function flushEthers() public isAuthorized { // Send ether to collector
235   require( collectorAddress.send( this.balance ) );
236 }
237 
238 function changeMinAccEthers(uint _newMin) public isAuthorized {
239   minAcceptedETH = _newMin;
240 }
241 
242 function addAuthorized(address _address) public isAuthorized {
243 	authorized[_address] = true;
244 
245 }
246 
247 function removeAuthorized(address _address) public isAuthorized {
248 	require(_address != owner);
249 	authorized[_address] = false;
250 }
251 
252 function changeOwner(address _address) public {
253 	require(msg.sender == owner);
254 	owner = _address;
255 }
256 
257 // To manage ERC20 tokens in case of accidental sending to the contract
258 
259 function sendTokens(address _address , uint256 _amount) isAuthorized returns (bool success) {
260     ERC20Basic token = ERC20Basic( tokenAdd );
261     require( token.transfer(_address , _amount ) );
262     return true;
263 }
264 
265 
266 }