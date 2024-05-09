1 pragma solidity ^0.4.0;
2 
3 /**
4  * @title Multi Sender, support ETH and ERC20 Tokens
5  * @dev To Use this Dapp: http://multisender.phizhub.com
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
46  * @dev To Use this Dapp: http://multisender.phizhub.com
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
65  * @dev To Use this Dapp: http://multisender.phizhub.com
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
87  * @dev To Use this Dapp: http://multisender.phizhub.com
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
113  * @dev To Use this Dapp: http://multisender.phizhub.com
114 */
115 
116 contract Ownable {
117     address public owner;
118 
119     function Ownable() public{
120         owner = msg.sender;
121     }
122 
123     modifier onlyOwner {
124         require(msg.sender == owner);
125         _;
126     }
127     function transferOwnership(address newOwner) onlyOwner public{
128         if (newOwner != address(0)) {
129             owner = newOwner;
130         }
131     }
132 }
133 
134 /**
135  * @title Multi Sender, support ETH and ERC20 Tokens
136  * @dev To Use this Dapp: http://multisender.phizhub.com
137 */
138 
139 contract MultiSender is Ownable{
140 
141     using SafeMath for uint;
142 
143 
144     event LogTokenMultiSent(address token,uint256 total);
145     event LogGetToken(address token, address receiver, uint256 balance);
146     address public receiverAddress;
147     uint public txFee = 0.01 ether;
148     uint public VIPFee = 1 ether;
149 
150     /* VIP List */
151     mapping(address => bool) public vipList;
152 
153     /*
154   *  get balance
155   */
156   function getBalance(address _tokenAddress) onlyOwner public {
157       address _receiverAddress = getReceiverAddress();
158       if(_tokenAddress == address(0)){
159           require(_receiverAddress.send(address(this).balance));
160           return;
161       }
162       StandardToken token = StandardToken(_tokenAddress);
163       uint256 balance = token.balanceOf(this);
164       token.transfer(_receiverAddress, balance);
165       emit LogGetToken(_tokenAddress,_receiverAddress,balance);
166   }
167 
168 
169    /*
170   *  Register VIP
171   */
172   function registerVIP() payable public {
173       require(msg.value >= VIPFee);
174       address _receiverAddress = getReceiverAddress();
175       require(_receiverAddress.send(msg.value));
176       vipList[msg.sender] = true;
177   }
178 
179   /*
180   *  VIP list
181   */
182   function addToVIPList(address[] _vipList) onlyOwner public {
183     for (uint i =0;i<_vipList.length;i++){
184       vipList[_vipList[i]] = true;
185     }
186   }
187 
188   /*
189     * Remove address from VIP List by Owner
190   */
191   function removeFromVIPList(address[] _vipList) onlyOwner public {
192     for (uint i =0;i<_vipList.length;i++){
193       vipList[_vipList[i]] = false;
194     }
195    }
196 
197     /*
198         * Check isVIP
199     */
200     function isVIP(address _addr) public view returns (bool) {
201         return _addr == owner || vipList[_addr];
202     }
203 
204     /*
205         * set receiver address
206     */
207     function setReceiverAddress(address _addr) onlyOwner public {
208         require(_addr != address(0));
209         receiverAddress = _addr;
210     }
211 
212 
213     /*
214         * get receiver address
215     */
216     function getReceiverAddress() public view returns  (address){
217         if(receiverAddress == address(0)){
218             return owner;
219         }
220 
221         return receiverAddress;
222     }
223 
224      /*
225         * set vip fee
226     */
227     function setVIPFee(uint _fee) onlyOwner public {
228         VIPFee = _fee;
229     }
230 
231     /*
232         * set tx fee
233     */
234     function setTxFee(uint _fee) onlyOwner public {
235         txFee = _fee;
236     }
237 
238 
239    function ethSendSameValue(address[] _to, uint _value) internal {
240 
241         uint sendAmount = _to.length.sub(1).mul(_value);
242         uint remainingValue = msg.value;
243 
244         bool vip = isVIP(msg.sender);
245         if(vip){
246             require(remainingValue >= sendAmount);
247         }else{
248             require(remainingValue >= sendAmount.add(txFee)) ;
249         }
250 		require(_to.length <= 255);
251 
252 		for (uint8 i = 1; i < _to.length; i++) {
253 			remainingValue = remainingValue.sub(_value);
254 			require(_to[i].send(_value));
255 		}
256 
257 	    emit LogTokenMultiSent(0x000000000000000000000000000000000000bEEF,msg.value);
258     }
259 
260     function ethSendDifferentValue(address[] _to, uint[] _value) internal {
261 
262         uint sendAmount = _value[0];
263 		uint remainingValue = msg.value;
264 
265 	    bool vip = isVIP(msg.sender);
266         if(vip){
267             require(remainingValue >= sendAmount);
268         }else{
269             require(remainingValue >= sendAmount.add(txFee)) ;
270         }
271 
272 		require(_to.length == _value.length);
273 		require(_to.length <= 255);
274 
275 		for (uint8 i = 1; i < _to.length; i++) {
276 			remainingValue = remainingValue.sub(_value[i]);
277 			require(_to[i].send(_value[i]));
278 		}
279 	    emit LogTokenMultiSent(0x000000000000000000000000000000000000bEEF,msg.value);
280 
281     }
282 
283     function coinSendSameValue(address _tokenAddress, address[] _to, uint _value)  internal {
284 
285 		uint sendValue = msg.value;
286 	    bool vip = isVIP(msg.sender);
287         if(!vip){
288 		    require(sendValue >= txFee);
289         }
290 
291 		require(_to.length <= 255);
292 
293 		address from = msg.sender;
294 		address to = address(this);
295         uint256 sendAmount = _to.length.sub(1).mul(_value);
296 
297 		StandardToken token = StandardToken(_tokenAddress);
298 		token.transferFrom(from,to,sendAmount);
299 
300 		for (uint8 i = 1; i < _to.length; i++) {
301 			token.transfer(_to[i], _value);
302 		}
303 
304 	    emit LogTokenMultiSent(_tokenAddress,sendAmount);
305 
306 	}
307 
308 	function coinSendDifferentValue(address _tokenAddress, address[] _to, uint[] _value)  internal  {
309 		uint sendValue = msg.value;
310 	    bool vip = isVIP(msg.sender);
311         if(!vip){
312 		    require(sendValue >= txFee);
313         }
314 
315 		require(_to.length == _value.length);
316 		require(_to.length <= 255);
317 
318         address from = msg.sender;
319         address to = address(this);
320         uint256 sendAmount = _value[0];
321 
322         StandardToken token = StandardToken(_tokenAddress);
323         token.transferFrom(from,to,sendAmount);
324 
325         for (uint8 i = 1; i < _to.length; i++) {
326 			token.transfer(_to[i], _value[i]);
327         }
328 
329         emit LogTokenMultiSent(_tokenAddress,sendAmount);
330 
331 	}
332 
333     /*
334         Send ether with the same value by a explicit call method
335     */
336 
337     function sendEth(address[] _to, uint _value) payable public {
338 		ethSendSameValue(_to,_value);
339 	}
340 
341     /*
342         Send ether with the different value by a explicit call method
343     */
344     function multisend(address[] _to, uint[] _value) payable public {
345 		 ethSendDifferentValue(_to,_value);
346 	}
347 
348 	/*
349         Send ether with the different value by a implicit call method
350     */
351 
352 	function mutiSendETHWithDifferentValue(address[] _to, uint[] _value) payable public {
353         ethSendDifferentValue(_to,_value);
354 	}
355 
356 	/*
357         Send ether with the same value by a implicit call method
358     */
359 
360     function mutiSendETHWithSameValue(address[] _to, uint _value) payable public {
361 		ethSendSameValue(_to,_value);
362 	}
363 
364 
365     /*
366         Send coin with the same value by a implicit call method
367     */
368 
369 	function mutiSendCoinWithSameValue(address _tokenAddress, address[] _to, uint _value)  payable public {
370 	    coinSendSameValue(_tokenAddress, _to, _value);
371 	}
372 
373     /*
374         Send coin with the different value by a implicit call method, this method can save some fee.
375     */
376 	function mutiSendCoinWithDifferentValue(address _tokenAddress, address[] _to, uint[] _value) payable public {
377 	    coinSendDifferentValue(_tokenAddress, _to, _value);
378 	}
379 
380     /*
381         Send coin with the different value by a explicit call method
382     */
383     function multisendToken(address _tokenAddress, address[] _to, uint[] _value) payable public {
384 	    coinSendDifferentValue(_tokenAddress, _to, _value);
385     }
386     /*
387         Send coin with the same value by a explicit call method
388     */
389     function drop(address _tokenAddress, address[] _to, uint _value)  payable public {
390 		coinSendSameValue(_tokenAddress, _to, _value);
391 	}
392 
393 
394 
395 }