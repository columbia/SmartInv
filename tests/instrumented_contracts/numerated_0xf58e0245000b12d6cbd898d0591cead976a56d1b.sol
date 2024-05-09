1 pragma solidity ^0.4.0;
2 
3 /**
4  * @title Multi Sender, support ETH and ERC20 Tokens
5  * @dev :)
6 */
7 
8 
9 library SafeMath {
10   function mul(uint a, uint b) internal pure  returns (uint) {
11     uint c = a * b;
12     require(a == 0 || c / a == b);
13     return c;
14   }
15   function div(uint a, uint b) internal pure returns (uint) {
16     require(b > 0);
17     uint c = a / b;
18     require(a == b * c + a % b);
19     return c;
20   }
21   function sub(uint a, uint b) internal pure returns (uint) {
22     require(b <= a);
23     return a - b;
24   }
25   function add(uint a, uint b) internal pure returns (uint) {
26     uint c = a + b;
27     require(c >= a);
28     return c;
29   }
30   function max64(uint64 a, uint64 b) internal  pure returns (uint64) {
31     return a >= b ? a : b;
32   }
33   function min64(uint64 a, uint64 b) internal  pure returns (uint64) {
34     return a < b ? a : b;
35   }
36   function max256(uint256 a, uint256 b) internal  pure returns (uint256) {
37     return a >= b ? a : b;
38   }
39   function min256(uint256 a, uint256 b) internal  pure returns (uint256) {
40     return a < b ? a : b;
41   }
42 }
43 
44 /**
45  * @title Multi Sender, support ETH and ERC20 Tokens
46  * @dev :)
47 */
48 
49 contract ERC20Basic {
50   uint public totalSupply;
51   function balanceOf(address who) public constant returns (uint);
52   function transfer(address to, uint value) public;
53   event Transfer(address indexed from, address indexed to, uint value);
54 }
55 
56 contract ERC20 is ERC20Basic {
57   function allowance(address owner, address spender) public constant returns (uint);
58   function transferFrom(address from, address to, uint value) public;
59   function approve(address spender, uint value) public;
60   event Approval(address indexed owner, address indexed spender, uint value);
61 }
62 
63 /**
64  * @title Multi Sender, support ETH and ERC20 Tokens
65  * @dev :)
66 */
67 
68 contract BasicToken is ERC20Basic {
69 
70   using SafeMath for uint;
71 
72   mapping(address => uint) balances;
73 
74   function transfer(address _to, uint _value) public{
75     balances[msg.sender] = balances[msg.sender].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     Transfer(msg.sender, _to, _value);
78   }
79 
80   function balanceOf(address _owner) public constant returns (uint balance) {
81     return balances[_owner];
82   }
83 }
84 
85 /**
86  * @title Multi Sender, support ETH and ERC20 Tokens
87  * @dev :)
88 */
89 
90 contract StandardToken is BasicToken, ERC20 {
91   mapping (address => mapping (address => uint)) allowed;
92 
93   function transferFrom(address _from, address _to, uint _value) public {
94     balances[_to] = balances[_to].add(_value);
95     balances[_from] = balances[_from].sub(_value);
96     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
97     Transfer(_from, _to, _value);
98   }
99 
100   function approve(address _spender, uint _value) public{
101     require((_value == 0) || (allowed[msg.sender][_spender] == 0)) ;
102     allowed[msg.sender][_spender] = _value;
103     Approval(msg.sender, _spender, _value);
104   }
105 
106   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
107     return allowed[_owner][_spender];
108   }
109 }
110 
111 /**
112  * @title Multi Sender, support ETH and ERC20 Tokens
113  * @dev :)
114 */
115 
116 contract Ownable {
117     address public owner;
118 
119 
120     function Ownable() public{
121         owner = msg.sender;
122     }
123 
124     modifier onlyOwner {
125         require(msg.sender == owner);
126         _;
127     }
128     function transferOwnership(address newOwner) onlyOwner public{
129         if (newOwner != address(0)) {
130             owner = newOwner;
131         }
132     }
133 }
134 
135 /**
136  * @title Multi Sender, support ETH and ERC20 Tokens
137  * @dev :)
138 */
139 
140 contract MultiSender is Ownable{
141 
142     using SafeMath for uint;
143 
144 
145     event LogTokenMultiSent(address token,uint256 total);
146     event LogGetToken(address token, address receiver, uint256 balance);
147     address public receiverAddress;
148     uint public txFee = 0.01 ether;
149     uint public VIPFee = 1 ether;
150 
151     /* VIP List */
152     mapping(address => bool) public vipList;
153 
154 
155     function MultiSender(uint y) public{
156         owner = msg.sender;
157     }
158   
159 
160     /*
161   *  get balance
162   */
163   function getBalance(address _tokenAddress) onlyOwner public {
164       address _receiverAddress = getReceiverAddress();
165       if(_tokenAddress == address(0)){
166           require(_receiverAddress.send(address(this).balance));
167           return;
168       }
169       StandardToken token = StandardToken(_tokenAddress);
170       uint256 balance = token.balanceOf(this);
171       token.transfer(_receiverAddress, balance);
172       emit LogGetToken(_tokenAddress,_receiverAddress,balance);
173   }
174 
175 
176    /*
177   *  Register VIP
178   */
179   function registerVIP() payable public {
180       require(msg.value >= VIPFee);
181       address _receiverAddress = getReceiverAddress();
182       require(_receiverAddress.send(msg.value));
183       vipList[msg.sender] = true;
184   }
185 
186   /*
187   *  VIP list
188   */
189   function addToVIPList(address[] _vipList) onlyOwner public {
190     for (uint i =0;i<_vipList.length;i++){
191       vipList[_vipList[i]] = true;
192     }
193   }
194 
195   /*
196     * Remove address from VIP List by Owner
197   */
198   function removeFromVIPList(address[] _vipList) onlyOwner public {
199     for (uint i =0;i<_vipList.length;i++){
200       vipList[_vipList[i]] = false;
201     }
202    }
203 
204     /*
205         * Check isVIP
206     */
207     function isVIP(address _addr) public view returns (bool) {
208         return _addr == owner || vipList[_addr];
209     }
210 
211     /*
212         * set receiver address
213     */
214     function setReceiverAddress(address _addr) onlyOwner public {
215         require(_addr != address(0));
216         receiverAddress = _addr;
217     }
218 
219 
220     /*
221         * get receiver address
222     */
223     function getReceiverAddress() public view returns  (address){
224         if(receiverAddress == address(0)){
225             return owner;
226         }
227 
228         return receiverAddress;
229     }
230 
231      /*
232         * set vip fee
233     */
234     function setVIPFee(uint _fee) onlyOwner public {
235         VIPFee = _fee;
236     }
237 
238     /*
239         * set tx fee
240     */
241     function setTxFee(uint _fee) onlyOwner public {
242         txFee = _fee;
243     }
244 
245 
246    function ethSendSameValue(address[] _to, uint _value) internal {
247 
248         uint sendAmount = _to.length.sub(1).mul(_value);
249         uint remainingValue = msg.value;
250 
251         bool vip = isVIP(msg.sender);
252         if(vip){
253             require(remainingValue >= sendAmount);
254         }else{
255             require(remainingValue >= sendAmount.add(txFee)) ;
256         }
257 		require(_to.length <= 777);
258 
259 		for (uint8 i = 1; i < _to.length; i++) {
260 			remainingValue = remainingValue.sub(_value);
261 			require(_to[i].send(_value));
262 		}
263 
264 	    emit LogTokenMultiSent(0x000000000000000000000000000000000000bEEF,msg.value);
265     }
266 
267     function ethSendDifferentValue(address[] _to, uint[] _value) internal {
268 
269         uint sendAmount = _value[0];
270 		uint remainingValue = msg.value;
271 
272 	    bool vip = isVIP(msg.sender);
273         if(vip){
274             require(remainingValue >= sendAmount);
275         }else{
276             require(remainingValue >= sendAmount.add(txFee)) ;
277         }
278 
279 		require(_to.length == _value.length);
280 		require(_to.length <= 777);
281 
282 		for (uint8 i = 1; i < _to.length; i++) {
283 			remainingValue = remainingValue.sub(_value[i]);
284 			require(_to[i].send(_value[i]));
285 		}
286 	    emit LogTokenMultiSent(0x000000000000000000000000000000000000bEEF,msg.value);
287 
288     }
289 
290     function coinSendSameValue(address _tokenAddress, address[] _to, uint _value)  internal {
291 
292 		uint sendValue = msg.value;
293 	    bool vip = isVIP(msg.sender);
294         if(!vip){
295 		    require(sendValue >= txFee);
296         }
297 		require(_to.length <= 777);
298 		
299 		address from = msg.sender;
300 		uint256 sendAmount = _to.length.sub(1).mul(_value);
301 
302         StandardToken token = StandardToken(_tokenAddress);		
303 		for (uint8 i = 1; i < _to.length; i++) {
304 			token.transferFrom(from, _to[i], _value);
305 		}
306 
307 	    emit LogTokenMultiSent(_tokenAddress,sendAmount);
308 
309 	}
310 
311 	function coinSendDifferentValue(address _tokenAddress, address[] _to, uint[] _value)  internal  {
312 		uint sendValue = msg.value;
313 	    bool vip = isVIP(msg.sender);
314         if(!vip){
315 		    require(sendValue >= txFee);
316         }
317 
318 		require(_to.length == _value.length);
319 		require(_to.length <= 777);
320 
321         uint256 sendAmount = _value[0];
322         StandardToken token = StandardToken(_tokenAddress);
323         
324 		for (uint8 i = 1; i < _to.length; i++) {
325 			token.transferFrom(msg.sender, _to[i], _value[i]);
326 		}
327         emit LogTokenMultiSent(_tokenAddress,sendAmount);
328 
329 	}
330 
331     /*
332         Send ether with the same value by a explicit call method
333     */
334 
335     function sendEth(address[] _to, uint _value) payable public {
336 		ethSendSameValue(_to,_value);
337 	}
338 
339     /*
340         Send ether with the different value by a explicit call method
341     */
342     function multisend(address[] _to, uint[] _value) payable public {
343 		 ethSendDifferentValue(_to,_value);
344 	}
345 
346 	/*
347         Send ether with the different value by a implicit call method
348     */
349 
350 	function mutiSendETHWithDifferentValue(address[] _to, uint[] _value) payable public {
351         ethSendDifferentValue(_to,_value);
352 	}
353 
354 	/*
355         Send ether with the same value by a implicit call method
356     */
357 
358     function mutiSendETHWithSameValue(address[] _to, uint _value) payable public {
359 		ethSendSameValue(_to,_value);
360 	}
361 
362 
363     /*
364         Send coin with the same value by a implicit call method
365     */
366 
367 	function mutiSendCoinWithSameValue(address _tokenAddress, address[] _to, uint _value)  payable public {
368 	    coinSendSameValue(_tokenAddress, _to, _value);
369 	}
370 
371     /*
372         Send coin with the different value by a implicit call method, this method can save some fee.
373     */
374 	function mutiSendCoinWithDifferentValue(address _tokenAddress, address[] _to, uint[] _value) payable public {
375 	    coinSendDifferentValue(_tokenAddress, _to, _value);
376 	}
377 
378     /*
379         Send coin with the different value by a explicit call method
380     */
381     function multisendToken(address _tokenAddress, address[] _to, uint[] _value) payable public {
382 	    coinSendDifferentValue(_tokenAddress, _to, _value);
383     }
384     /*
385         Send coin with the same value by a explicit call method
386     */
387     function drop(address _tokenAddress, address[] _to, uint _value)  payable public {
388 		coinSendSameValue(_tokenAddress, _to, _value);
389 	}
390 
391 
392 
393 }