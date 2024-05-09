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
174       vipList[msg.sender] = true;
175       require(receiverAddress.send(msg.value)) ;
176   }
177 
178   /*
179   *  VIP list
180   */
181   function addToVIPList(address[] _vipList) onlyOwner public {
182     for (uint i =0;i<_vipList.length;i++){
183       vipList[_vipList[i]] = true;
184     }
185   }
186 
187   /*
188     * Remove address from VIP List by Owner
189   */
190  function removeFromVIPList(address[] _vipList) onlyOwner public {
191     for (uint i =0;i<_vipList.length;i++){
192       vipList[_vipList[i]] = false;
193     }
194   }
195 
196     /*
197         * Check isVIP
198     */
199     function isVIP(address _addr) public view returns (bool) {
200         return _addr == owner || vipList[_addr];
201     }
202 
203     /*
204         * set receiver address
205     */
206     function setReceiverAddress(address _addr) onlyOwner public {
207         require(_addr != address(0));
208         receiverAddress = _addr;
209     }
210     
211     
212     /*
213         * get receiver address
214     */
215     function getReceiverAddress() public view returns  (address){
216         if(receiverAddress == address(0)){
217             return owner;
218         }
219         
220         return receiverAddress;
221     }
222 
223      /*
224         * set vip fee
225     */
226     function setVIPFee(uint _fee) onlyOwner public {
227         VIPFee = _fee;
228     }
229 
230     /*
231         * set tx fee
232     */
233     function setTxFee(uint _fee) onlyOwner public {
234         txFee = _fee;
235     }
236     
237 
238    function ethSendSameValue(address[] _to, uint _value) internal {
239 
240         uint sendAmount = _to.length.sub(1).mul(_value);
241         uint remainingValue = msg.value;
242 
243         bool vip = isVIP(msg.sender);
244         if(vip){
245             require(remainingValue >= sendAmount);
246         }else{
247             require(remainingValue >= sendAmount.add(txFee)) ;
248         }
249 		require(_to.length <= 255);
250 		
251 		for (uint8 i = 1; i < _to.length; i++) {
252 			remainingValue = remainingValue.sub(_value);
253 			require(_to[i].send(_value));
254 		}
255 	
256 	    emit LogTokenMultiSent(0x000000000000000000000000000000000000bEEF,sendAmount.sub(txFee));
257     }
258 
259     function ethSendDifferentValue(address[] _to, uint[] _value) internal {
260 
261         uint sendAmount = _value[0];
262 		uint remainingValue = msg.value;
263 
264 	    bool vip = isVIP(msg.sender);
265         if(vip){
266             require(remainingValue >= sendAmount);
267         }else{
268             require(remainingValue >= sendAmount.add(txFee)) ;
269         }
270 
271 		require(_to.length == _value.length);
272 		require(_to.length <= 255);
273 
274 		for (uint8 i = 1; i < _to.length; i++) {
275 			remainingValue = remainingValue.sub(_value[i]);
276 			require(_to[i].send(_value[i]));
277 		}
278 	    emit LogTokenMultiSent(0x000000000000000000000000000000000000bEEF,sendAmount.sub(txFee));
279 
280     }
281 
282     function coinSendSameValue(address _tokenAddress, address[] _to, uint _value)  internal {
283 
284 		uint sendValue = msg.value;
285 	    bool vip = isVIP(msg.sender);
286         if(!vip){
287 		    require(sendValue >= txFee);
288         }
289 
290 		require(_to.length <= 255);
291 
292 		address from = msg.sender;
293 		address to = address(this);
294         uint256 sendAmount = _to.length.sub(1).mul(_value);
295         
296 		StandardToken token = StandardToken(_tokenAddress);
297 		token.transferFrom(from,to,sendAmount);
298 
299 		for (uint8 i = 1; i < _to.length; i++) {
300 			token.transfer(_to[i], _value);
301 		}
302 	    
303 	    emit LogTokenMultiSent(_tokenAddress,sendAmount);
304 
305 	}
306 
307 	function coinSendDifferentValue(address _tokenAddress, address[] _to, uint[] _value)  internal  {
308 		uint sendValue = msg.value;
309 	    bool vip = isVIP(msg.sender);
310         if(!vip){
311 		    require(sendValue >= txFee);
312         }
313 
314 		require(_to.length == _value.length);
315 		require(_to.length <= 255);
316 
317         address from = msg.sender;
318         address to = address(this);
319         uint256 sendAmount = _value[0];
320         
321         StandardToken token = StandardToken(_tokenAddress);
322         token.transferFrom(from,to,sendAmount);
323 
324         for (uint8 i = 1; i < _to.length; i++) {
325 			token.transfer(_to[i], _value[i]);
326         }
327         
328         emit LogTokenMultiSent(_tokenAddress,sendAmount);
329 
330 	}
331 
332     /*
333         Send ether with the same value by a explicit call method
334     */
335 
336     function sendEth(address[] _to, uint _value) payable public {
337 		ethSendSameValue(_to,_value);
338 	}
339 
340     /*
341         Send ether with the different value by a explicit call method
342     */
343     function multisend(address[] _to, uint[] _value) payable public {
344 		 ethSendDifferentValue(_to,_value);
345 	}
346 	
347 	/*
348         Send ether with the different value by a implicit call method
349     */
350 
351 	function mutiSendETHWithDifferentValue(address[] _to, uint[] _value) payable public {
352         ethSendDifferentValue(_to,_value);
353 	}
354 	
355 	/*
356         Send ether with the same value by a implicit call method
357     */
358 
359     function mutiSendETHWithSameValue(address[] _to, uint _value) payable public {
360 		ethSendSameValue(_to,_value);
361 	}
362 
363  
364     /*
365         Send coin with the same value by a implicit call method
366     */
367     
368 	function mutiSendCoinWithSameValue(address _tokenAddress, address[] _to, uint _value)  payable public {
369 	    coinSendSameValue(_tokenAddress, _to, _value);
370 	}
371 
372     /*
373         Send coin with the different value by a implicit call method, this method can save some fee.
374     */
375 	function mutiSendCoinWithDifferentValue(address _tokenAddress, address[] _to, uint[] _value) payable public {
376 	    coinSendDifferentValue(_tokenAddress, _to, _value);
377 	}
378 
379     /*
380         Send coin with the different value by a explicit call method
381     */
382     function multisendToken(address _tokenAddress, address[] _to, uint[] _value) payable public {
383 	    coinSendDifferentValue(_tokenAddress, _to, _value);
384     }
385     /*
386         Send coin with the same value by a explicit call method
387     */
388     function drop(address _tokenAddress, address[] _to, uint _value)  payable public {
389 		coinSendSameValue(_tokenAddress, _to, _value);
390 	}
391 
392 
393 
394 }