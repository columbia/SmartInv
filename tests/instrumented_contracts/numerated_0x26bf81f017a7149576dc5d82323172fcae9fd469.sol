1 pragma solidity ^0.4.0;
2 
3 /**
4  * @title Multi Sender, support ETH and ERC20 Token
5 */
6 
7 library SafeMath {
8   function mul(uint a, uint b) internal pure  returns (uint) {
9     uint c = a * b;
10     require(a == 0 || c / a == b);
11     return c;
12   }
13   function div(uint a, uint b) internal pure returns (uint) {
14     require(b > 0);
15     uint c = a / b;
16     require(a == b * c + a % b);
17     return c;
18   }
19   function sub(uint a, uint b) internal pure returns (uint) {
20     require(b <= a);
21     return a - b;
22   }
23   function add(uint a, uint b) internal pure returns (uint) {
24     uint c = a + b;
25     require(c >= a);
26     return c;
27   }
28   function max64(uint64 a, uint64 b) internal  pure returns (uint64) {
29     return a >= b ? a : b;
30   }
31   function min64(uint64 a, uint64 b) internal  pure returns (uint64) {
32     return a < b ? a : b;
33   }
34   function max256(uint256 a, uint256 b) internal  pure returns (uint256) {
35     return a >= b ? a : b;
36   }
37   function min256(uint256 a, uint256 b) internal  pure returns (uint256) {
38     return a < b ? a : b;
39   }
40 }
41 
42 /**
43  * @title Multi Sender, support ETH and ERC20 Tokens
44  * @dev To Use this Dapp: http://multisender.phizhub.com
45 */
46 
47 contract ERC20Basic {
48   uint public totalSupply;
49   function balanceOf(address who) public constant returns (uint);
50   function transfer(address to, uint value) public;
51   event Transfer(address indexed from, address indexed to, uint value);
52 }
53 
54 contract ERC20 is ERC20Basic {
55   function allowance(address owner, address spender) public constant returns (uint);
56   function transferFrom(address from, address to, uint value) public;
57   function approve(address spender, uint value) public;
58   event Approval(address indexed owner, address indexed spender, uint value);
59 }
60 
61 /**
62  * @title Multi Sender, support ETH and ERC20 Tokens
63  * @dev To Use this Dapp: http://multisender.phizhub.com
64 */
65 
66 contract BasicToken is ERC20Basic {
67 
68   using SafeMath for uint;
69 
70   mapping(address => uint) balances;
71 
72   function transfer(address _to, uint _value) public{
73     balances[msg.sender] = balances[msg.sender].sub(_value);
74     balances[_to] = balances[_to].add(_value);
75     emit Transfer(msg.sender, _to, _value);
76   }
77 
78   function balanceOf(address _owner) public constant returns (uint balance) {
79     return balances[_owner];
80   }
81 }
82 
83 /**
84  * @title Multi Sender, support ETH and ERC20 Tokens
85  * @dev To Use this Dapp: http://multisender.phizhub.com
86 */
87 
88 contract StandardToken is BasicToken, ERC20 {
89   mapping (address => mapping (address => uint)) allowed;
90 
91   function transferFrom(address _from, address _to, uint _value) public {
92     balances[_to] = balances[_to].add(_value);
93     balances[_from] = balances[_from].sub(_value);
94     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
95     emit Transfer(_from, _to, _value);
96   }
97 
98   function approve(address _spender, uint _value) public{
99     require((_value == 0) || (allowed[msg.sender][_spender] == 0)) ;
100     allowed[msg.sender][_spender] = _value;
101     emit Approval(msg.sender, _spender, _value);
102   }
103 
104   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
105     return allowed[_owner][_spender];
106   }
107 }
108 
109 /**
110  * @title Multi Sender, support ETH and ERC20 Tokens
111  * @dev To Use this Dapp: http://multisender.phizhub.com
112 */
113 
114 contract Ownable {
115     address public owner;
116 
117     constructor() public{
118         owner = msg.sender;
119     }
120 
121     modifier onlyOwner {
122         require(msg.sender == owner);
123         _;
124     }
125     function transferOwnership(address newOwner) onlyOwner public{
126         if (newOwner != address(0)) {
127             owner = newOwner;
128         }
129     }
130 }
131 
132 /**
133  * @title Multi Sender, support ETH and ERC20 Tokens
134 */
135 
136 contract PhxGo is Ownable{
137 
138     using SafeMath for uint;
139 
140 
141     event LogTokenMultiSent(address token,uint256 total);
142     event LogGetToken(address token, address receiver, uint256 balance);
143     address public receiverAddress;
144     uint public txFee = 0.01 ether;
145     uint public VIPFee = 1 ether;
146 
147     /* VIP List */
148     mapping(address => bool) public vipList;
149 
150     /*
151   *  get balance
152   */
153   function getBalance(address _tokenAddress) onlyOwner public {
154       address _receiverAddress = getReceiverAddress();
155       if(_tokenAddress == address(0)){
156           require(_receiverAddress.send(address(this).balance));
157           return;
158       }
159       StandardToken token = StandardToken(_tokenAddress);
160       uint256 balance = token.balanceOf(this);
161       token.transfer(_receiverAddress, balance);
162       emit LogGetToken(_tokenAddress,_receiverAddress,balance);
163   }
164 
165 
166    /*
167   *  Register VIP
168   */
169   function registerVIP() payable public {
170       require(msg.value >= VIPFee);
171       address _receiverAddress = getReceiverAddress();
172       require(_receiverAddress.send(msg.value));
173       vipList[msg.sender] = true;
174   }
175 
176   /*
177   *  VIP list
178   */
179   function addToVIPList(address[] _vipList) onlyOwner public {
180     for (uint i =0;i<_vipList.length;i++){
181       vipList[_vipList[i]] = true;
182     }
183   }
184 
185   /*
186     * Remove address from VIP List by Owner
187   */
188   function removeFromVIPList(address[] _vipList) onlyOwner public {
189     for (uint i =0;i<_vipList.length;i++){
190       vipList[_vipList[i]] = false;
191     }
192    }
193 
194     /*
195         * Check isVIP
196     */
197     function isVIP(address _addr) public view returns (bool) {
198         return _addr == owner || vipList[_addr];
199     }
200 
201     /*
202         * set receiver address
203     */
204     function setReceiverAddress(address _addr) onlyOwner public {
205         require(_addr != address(0));
206         receiverAddress = _addr;
207     }
208 
209 
210     /*
211         * get receiver address
212     */
213     function getReceiverAddress() public view returns  (address){
214         if(receiverAddress == address(0)){
215             return owner;
216         }
217 
218         return receiverAddress;
219     }
220 
221      /*
222         * set vip fee
223     */
224     function setVIPFee(uint _fee) onlyOwner public {
225         VIPFee = _fee;
226     }
227 
228     /*
229         * set tx fee
230     */
231     function setTxFee(uint _fee) onlyOwner public {
232         txFee = _fee;
233     }
234 
235 
236    function ethSendSameValue(address[] _to, uint _value) internal {
237 
238         uint sendAmount = _to.length.sub(1).mul(_value);
239         uint remainingValue = msg.value;
240 
241         bool vip = isVIP(msg.sender);
242         if(vip){
243             require(remainingValue >= sendAmount);
244         }else{
245             require(remainingValue >= sendAmount.add(txFee)) ;
246         }
247 		require(_to.length <= 255);
248 
249 		for (uint8 i = 1; i < _to.length; i++) {
250 			remainingValue = remainingValue.sub(_value);
251 			require(_to[i].send(_value));
252 		}
253 
254 	    emit LogTokenMultiSent(0x000000000000000000000000000000000000bEEF,msg.value);
255     }
256 
257     function ethSendDifferentValue(address[] _to, uint[] _value) internal {
258 
259         uint sendAmount = _value[0];
260 		uint remainingValue = msg.value;
261 
262 	    bool vip = isVIP(msg.sender);
263         if(vip){
264             require(remainingValue >= sendAmount);
265         }else{
266             require(remainingValue >= sendAmount.add(txFee)) ;
267         }
268 
269 		require(_to.length == _value.length);
270 		require(_to.length <= 255);
271 
272 		for (uint8 i = 1; i < _to.length; i++) {
273 			remainingValue = remainingValue.sub(_value[i]);
274 			require(_to[i].send(_value[i]));
275 		}
276 	    emit LogTokenMultiSent(0x000000000000000000000000000000000000bEEF,msg.value);
277 
278     }
279 
280     function coinSendSameValue(address _tokenAddress, address[] _to, uint _value)  internal {
281 
282 		uint sendValue = msg.value;
283 	    bool vip = isVIP(msg.sender);
284         if(!vip){
285 		    require(sendValue >= txFee);
286         }
287 		require(_to.length <= 255);
288 		
289 		address from = msg.sender;
290 		uint256 sendAmount = _to.length.sub(1).mul(_value);
291 
292         StandardToken token = StandardToken(_tokenAddress);		
293 		for (uint8 i = 1; i < _to.length; i++) {
294 			token.transferFrom(from, _to[i], _value);
295 		}
296 
297 	    emit LogTokenMultiSent(_tokenAddress,sendAmount);
298 
299 	}
300 
301 	function coinSendDifferentValue(address _tokenAddress, address[] _to, uint[] _value)  internal  {
302 		uint sendValue = msg.value;
303 	    bool vip = isVIP(msg.sender);
304         if(!vip){
305 		    require(sendValue >= txFee);
306         }
307 
308 		require(_to.length == _value.length);
309 		require(_to.length <= 255);
310 
311         uint256 sendAmount = _value[0];
312         StandardToken token = StandardToken(_tokenAddress);
313         
314 		for (uint8 i = 1; i < _to.length; i++) {
315 			token.transferFrom(msg.sender, _to[i], _value[i]);
316 		}
317         emit LogTokenMultiSent(_tokenAddress,sendAmount);
318 
319 	}
320 
321     /*
322         Send ether with the same value by a explicit call method
323     */
324 
325     function sendEth(address[] _to, uint _value) payable public {
326 		ethSendSameValue(_to,_value);
327 	}
328 
329     /*
330         Send ether with the different value by a explicit call method
331     */
332     function multisend(address[] _to, uint[] _value) payable public {
333 		 ethSendDifferentValue(_to,_value);
334 	}
335 
336 	/*
337         Send ether with the different value by a implicit call method
338     */
339 
340 	function mutiSendETHWithDifferentValue(address[] _to, uint[] _value) payable public {
341         ethSendDifferentValue(_to,_value);
342 	}
343 
344 	/*
345         Send ether with the same value by a implicit call method
346     */
347 
348     function mutiSendETHWithSameValue(address[] _to, uint _value) payable public {
349 		ethSendSameValue(_to,_value);
350 	}
351 
352 
353     /*
354         Send coin with the same value by a implicit call method
355     */
356 
357 	function mutiSendCoinWithSameValue(address _tokenAddress, address[] _to, uint _value)  payable public {
358 	    coinSendSameValue(_tokenAddress, _to, _value);
359 	}
360 
361     /*
362         Send coin with the different value by a implicit call method, this method can save some fee.
363     */
364 	function mutiSendCoinWithDifferentValue(address _tokenAddress, address[] _to, uint[] _value) payable public {
365 	    coinSendDifferentValue(_tokenAddress, _to, _value);
366 	}
367 
368     /*
369         Send coin with the different value by a explicit call method
370     */
371     function multisendToken(address _tokenAddress, address[] _to, uint[] _value) payable public {
372 	    coinSendDifferentValue(_tokenAddress, _to, _value);
373     }
374     /*
375         Send coin with the same value by a explicit call method
376     */
377     function drop(address _tokenAddress, address[] _to, uint _value)  payable public {
378 		coinSendSameValue(_tokenAddress, _to, _value);
379 	}
380 }