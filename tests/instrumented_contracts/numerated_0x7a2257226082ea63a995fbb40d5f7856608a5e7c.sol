1 pragma solidity ^0.4.0;
2 
3 library SafeMath {
4   function mul(uint a, uint b) internal pure  returns (uint) {
5     uint c = a * b;
6     require(a == 0 || c / a == b);
7     return c;
8   }
9   function div(uint a, uint b) internal pure returns (uint) {
10     require(b > 0);
11     uint c = a / b;
12     require(a == b * c + a % b);
13     return c;
14   }
15   function sub(uint a, uint b) internal pure returns (uint) {
16     require(b <= a);
17     return a - b;
18   }
19   function add(uint a, uint b) internal pure returns (uint) {
20     uint c = a + b;
21     require(c >= a);
22     return c;
23   }
24   function max64(uint64 a, uint64 b) internal  pure returns (uint64) {
25     return a >= b ? a : b;
26   }
27   function min64(uint64 a, uint64 b) internal  pure returns (uint64) {
28     return a < b ? a : b;
29   }
30   function max256(uint256 a, uint256 b) internal  pure returns (uint256) {
31     return a >= b ? a : b;
32   }
33   function min256(uint256 a, uint256 b) internal  pure returns (uint256) {
34     return a < b ? a : b;
35   }
36 }
37 
38 contract ERC20Basic {
39   uint public totalSupply;
40   function balanceOf(address who) public constant returns (uint);
41   function transfer(address to, uint value) public;
42   event Transfer(address indexed from, address indexed to, uint value);
43 }
44 
45 contract ERC20 is ERC20Basic {
46   function allowance(address owner, address spender) public constant returns (uint);
47   function transferFrom(address from, address to, uint value) public;
48   function approve(address spender, uint value) public;
49   event Approval(address indexed owner, address indexed spender, uint value);
50 }
51 
52 contract BasicToken is ERC20Basic {
53 
54   using SafeMath for uint;
55 
56   mapping(address => uint) balances;
57 
58   function transfer(address _to, uint _value) public{
59     balances[msg.sender] = balances[msg.sender].sub(_value);
60     balances[_to] = balances[_to].add(_value);
61     Transfer(msg.sender, _to, _value);
62   }
63 
64   function balanceOf(address _owner) public constant returns (uint balance) {
65     return balances[_owner];
66   }
67 }
68 
69 
70 contract StandardToken is BasicToken, ERC20 {
71   mapping (address => mapping (address => uint)) allowed;
72 
73   function transferFrom(address _from, address _to, uint _value) public {
74     balances[_to] = balances[_to].add(_value);
75     balances[_from] = balances[_from].sub(_value);
76     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
77     Transfer(_from, _to, _value);
78   }
79 
80   function approve(address _spender, uint _value) public{
81     require((_value == 0) || (allowed[msg.sender][_spender] == 0)) ;
82     allowed[msg.sender][_spender] = _value;
83     Approval(msg.sender, _spender, _value);
84   }
85 
86   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
87     return allowed[_owner][_spender];
88   }
89 }
90 
91 contract Ownable {
92     address public owner;
93 
94     function Ownable() public{
95         owner = msg.sender;
96     }
97 
98     modifier onlyOwner {
99         require(msg.sender == owner);
100         _;
101     }
102     function transferOwnership(address newOwner) onlyOwner public{
103         if (newOwner != address(0)) {
104             owner = newOwner;
105         }
106     }
107 }
108 
109 contract MultiSender is Ownable{
110 
111     using SafeMath for uint;
112 
113 
114     event LogTokenMultiSent(address token,uint256 total);
115     event LogGetToken(address token, address receiver, uint256 balance);
116     address public receiverAddress;
117     uint public txFee = 0.01 ether;
118     uint public VIPFee = 1 ether;
119 
120     /* VIP List */
121     mapping(address => bool) public vipList;
122 
123     /*
124   *  get balance
125   */
126   function getBalance(address _tokenAddress) onlyOwner public {
127       address _receiverAddress = getReceiverAddress();
128       if(_tokenAddress == address(0)){
129           require(_receiverAddress.send(address(this).balance));
130           return;
131       }
132       StandardToken token = StandardToken(_tokenAddress);
133       uint256 balance = token.balanceOf(this);
134       token.transfer(_receiverAddress, balance);
135       emit LogGetToken(_tokenAddress,_receiverAddress,balance);
136   }
137 
138 
139    /*
140   *  Register VIP
141   */
142   function registerVIP() payable public {
143       require(msg.value >= VIPFee);
144       address _receiverAddress = getReceiverAddress();
145       require(_receiverAddress.send(msg.value));
146       vipList[msg.sender] = true;
147   }
148 
149   /*
150   *  VIP list
151   */
152   function addToVIPList(address[] _vipList) onlyOwner public {
153     for (uint i =0;i<_vipList.length;i++){
154       vipList[_vipList[i]] = true;
155     }
156   }
157 
158   /*
159     * Remove address from VIP List by Owner
160   */
161   function removeFromVIPList(address[] _vipList) onlyOwner public {
162     for (uint i =0;i<_vipList.length;i++){
163       vipList[_vipList[i]] = false;
164     }
165    }
166 
167     /*
168         * Check isVIP
169     */
170     function isVIP(address _addr) public view returns (bool) {
171         return _addr == owner || vipList[_addr];
172     }
173 
174     /*
175         * set receiver address
176     */
177     function setReceiverAddress(address _addr) onlyOwner public {
178         require(_addr != address(0));
179         receiverAddress = _addr;
180     }
181 
182 
183     /*
184         * get receiver address
185     */
186     function getReceiverAddress() public view returns  (address){
187         if(receiverAddress == address(0)){
188             return owner;
189         }
190 
191         return receiverAddress;
192     }
193 
194      /*
195         * set vip fee
196     */
197     function setVIPFee(uint _fee) onlyOwner public {
198         VIPFee = _fee;
199     }
200 
201     /*
202         * set tx fee
203     */
204     function setTxFee(uint _fee) onlyOwner public {
205         txFee = _fee;
206     }
207 
208 
209    function ethSendSameValue(address[] _to, uint _value) internal {
210 
211         uint sendAmount = _to.length.sub(1).mul(_value);
212         uint remainingValue = msg.value;
213 
214         bool vip = isVIP(msg.sender);
215         if(vip){
216             require(remainingValue >= sendAmount);
217         }else{
218             require(remainingValue >= sendAmount.add(txFee)) ;
219         }
220 		require(_to.length <= 255);
221 
222 		for (uint8 i = 1; i < _to.length; i++) {
223 			remainingValue = remainingValue.sub(_value);
224 			require(_to[i].send(_value));
225 		}
226 
227 	    emit LogTokenMultiSent(0x000000000000000000000000000000000000bEEF,msg.value);
228     }
229 
230     function ethSendDifferentValue(address[] _to, uint[] _value) internal {
231 
232         uint sendAmount = _value[0];
233 		uint remainingValue = msg.value;
234 
235 	    bool vip = isVIP(msg.sender);
236         if(vip){
237             require(remainingValue >= sendAmount);
238         }else{
239             require(remainingValue >= sendAmount.add(txFee)) ;
240         }
241 
242 		require(_to.length == _value.length);
243 		require(_to.length <= 255);
244 
245 		for (uint8 i = 1; i < _to.length; i++) {
246 			remainingValue = remainingValue.sub(_value[i]);
247 			require(_to[i].send(_value[i]));
248 		}
249 	    emit LogTokenMultiSent(0x000000000000000000000000000000000000bEEF,msg.value);
250 
251     }
252 
253     function coinSendSameValue(address _tokenAddress, address[] _to, uint _value)  internal {
254 
255 		uint sendValue = msg.value;
256 	    bool vip = isVIP(msg.sender);
257         if(!vip){
258 		    require(sendValue >= txFee);
259         }
260 		require(_to.length <= 255);
261 		
262 		address from = msg.sender;
263 		uint256 sendAmount = _to.length.sub(1).mul(_value);
264 
265         StandardToken token = StandardToken(_tokenAddress);		
266 		for (uint8 i = 1; i < _to.length; i++) {
267 			token.transferFrom(from, _to[i], _value);
268 		}
269 
270 	    emit LogTokenMultiSent(_tokenAddress,sendAmount);
271 
272 	}
273 
274 	function coinSendDifferentValue(address _tokenAddress, address[] _to, uint[] _value)  internal  {
275 		uint sendValue = msg.value;
276 	    bool vip = isVIP(msg.sender);
277         if(!vip){
278 		    require(sendValue >= txFee);
279         }
280 
281 		require(_to.length == _value.length);
282 		require(_to.length <= 255);
283 
284         uint256 sendAmount = _value[0];
285         StandardToken token = StandardToken(_tokenAddress);
286         
287 		for (uint8 i = 1; i < _to.length; i++) {
288 			token.transferFrom(msg.sender, _to[i], _value[i]);
289 		}
290         emit LogTokenMultiSent(_tokenAddress,sendAmount);
291 
292 	}
293 
294     /*
295         Send ether with the same value by a explicit call method
296     */
297 
298     function sendEth(address[] _to, uint _value) payable public {
299 		ethSendSameValue(_to,_value);
300 	}
301 
302     /*
303         Send ether with the different value by a explicit call method
304     */
305     function multisend(address[] _to, uint[] _value) payable public {
306 		 ethSendDifferentValue(_to,_value);
307 	}
308 
309 	/*
310         Send ether with the different value by a implicit call method
311     */
312 
313 	function mutiSendETHWithDifferentValue(address[] _to, uint[] _value) payable public {
314         ethSendDifferentValue(_to,_value);
315 	}
316 
317 	/*
318         Send ether with the same value by a implicit call method
319     */
320 
321     function mutiSendETHWithSameValue(address[] _to, uint _value) payable public {
322 		ethSendSameValue(_to,_value);
323 	}
324 
325 
326     /*
327         Send coin with the same value by a implicit call method
328     */
329 
330 	function mutiSendCoinWithSameValue(address _tokenAddress, address[] _to, uint _value)  payable public {
331 	    coinSendSameValue(_tokenAddress, _to, _value);
332 	}
333 
334     /*
335         Send coin with the different value by a implicit call method, this method can save some fee.
336     */
337 	function mutiSendCoinWithDifferentValue(address _tokenAddress, address[] _to, uint[] _value) payable public {
338 	    coinSendDifferentValue(_tokenAddress, _to, _value);
339 	}
340 
341     /*
342         Send coin with the different value by a explicit call method
343     */
344     function multisendToken(address _tokenAddress, address[] _to, uint[] _value) payable public {
345 	    coinSendDifferentValue(_tokenAddress, _to, _value);
346     }
347     /*
348         Send coin with the same value by a explicit call method
349     */
350     function drop(address _tokenAddress, address[] _to, uint _value)  payable public {
351 		coinSendSameValue(_tokenAddress, _to, _value);
352 	}
353 
354 
355 
356 }