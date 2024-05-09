1 pragma solidity ^0.4.23;
2 //pragma experimental ABIEncoderV2;
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 contract SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function safeMul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     if (a == 0) {
16       return 0;
17     }
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 //-------------------------------------------------------------------------------------
51 /*
52  * ERC20 interface
53  * see https://github.com/ethereum/EIPs/issues/20
54  */
55 contract ERC20 {
56     uint public totalSupply;
57     function balanceOf(address who) public view returns (uint);
58     function allowance(address owner, address spender) public view returns (uint);
59 
60     function transfer(address to, uint value) public returns (bool ok);
61     function transferFrom(address from, address to, uint value) public returns (bool ok);
62     function approve(address spender, uint value) public returns (bool ok);
63     event Transfer(address indexed from, address indexed to, uint value);
64     event Approval(address indexed owner, address indexed spender, uint value);
65 }
66 
67 contract ERC223 is ERC20 {
68     function transfer(address to, uint value, bytes data) public returns (bool ok);
69     function transferFrom(address from, address to, uint value, bytes data) public returns (bool ok);
70 }
71 
72 /*
73 Base class contracts willing to accept ERC223 token transfers must conform to.
74 
75 Sender: msg.sender to the token contract, the address originating the token transfer.
76           - For user originated transfers sender will be equal to tx.origin
77           - For contract originated transfers, tx.origin will be the user that made the tx that produced the transfer.
78 Origin: the origin address from whose balance the tokens are sent
79           - For transfer(), origin = msg.sender
80           - For transferFrom() origin = _from to token contract
81 Value is the amount of tokens sent
82 Data is arbitrary data sent with the token transfer. Simulates ether tx.data
83 
84 From, origin and value shouldn't be trusted unless the token contract is trusted.
85 If sender == tx.origin, it is safe to trust it regardless of the token.
86 */
87 
88 contract ERC223Receiver {
89     function tokenFallback(address _sender, address _origin, uint _value, bytes _data) public returns (bool ok);
90 }
91 
92 contract Standard223Receiver is ERC223Receiver {
93     function supportsToken(address token) public view returns (bool);
94 }
95 
96 
97 //-------------------------------------------------------------------------------------
98 //Implementation
99 
100 //contract WeSingCoin223Token_8 is ERC20, ERC223, Standard223Receiver, SafeMath {
101 contract LiveBox223Token is ERC20, ERC223, Standard223Receiver, SafeMath {
102 
103     mapping(address => uint) balances;
104     mapping (address => mapping (address => uint)) allowed;
105   
106     string public name;                   //fancy name: eg Simon Bucks
107     uint8 public decimals;                //How many decimals to show.
108     string public symbol;                 //An identifier: eg SBX
109 
110     address /*public*/ contrInitiator;
111     address /*public*/ thisContract;
112     bool /*public*/ isTokenSupport;
113   
114     mapping(address => bool) isSendingLocked;
115     bool isAllTransfersLocked;
116   
117     uint oneTransferLimit;
118     uint oneDayTransferLimit;
119  
120 
121     struct TransferInfo {
122         //address sender;    //maybe use in the future
123         //address from;      //no need because all this is kept in transferInfo[_from]
124         //address to;        //maybe use in the future
125         uint256 value;
126         uint time;
127     }
128 
129     struct TransferInfos {
130         mapping (uint => TransferInfo) ti;
131         uint tc;
132     }
133   
134     mapping (address => TransferInfos) transferInfo;
135 
136 //-------------------------------------------------------------------------------------
137 //from ExampleToken
138 
139     constructor(/*uint initialBalance*/) public {
140     
141         decimals    = 6;                                // Amount of decimals for display purposes
142 //      name        = "WeSingCoin";                     // Set the name for display purposes
143 //      symbol      = 'WSC';                            // Set the symbol for display purposes
144         name        = "LiveBoxCoin";                     // Set the name for display purposes
145         symbol      = 'LBC';                            // Set the symbol for display purposes
146 
147         uint initialBalance  = (10 ** uint256(decimals)) * 5000*1000*1000;
148     
149         balances[msg.sender] = initialBalance;
150         totalSupply = initialBalance;
151     
152         contrInitiator = msg.sender;
153         thisContract = this;
154         isTokenSupport = false;
155     
156         isAllTransfersLocked = true;
157     
158         oneTransferLimit    = (10 ** uint256(decimals)) * 10*1000*1000;
159         oneDayTransferLimit = (10 ** uint256(decimals)) * 50*1000*1000;
160 
161     // Ideally call token fallback here too
162     }
163 
164 //-------------------------------------------------------------------------------------
165 //from StandardToken
166 
167     function super_transfer(address _to, uint _value) /*public*/ internal returns (bool success) {
168 
169         require(!isSendingLocked[msg.sender]);
170         require(_value <= oneTransferLimit);
171         require(balances[msg.sender] >= _value);
172 
173         if(msg.sender == contrInitiator) {
174             //no restricton
175         } else {
176             require(!isAllTransfersLocked);  
177             require(safeAdd(getLast24hSendingValue(msg.sender), _value) <= oneDayTransferLimit);
178         }
179 
180 
181         balances[msg.sender] = safeSub(balances[msg.sender], _value);
182         balances[_to] = safeAdd(balances[_to], _value);
183     
184         uint tc=transferInfo[msg.sender].tc;
185         transferInfo[msg.sender].ti[tc].value = _value;
186         transferInfo[msg.sender].ti[tc].time = now;
187         transferInfo[msg.sender].tc = safeAdd(transferInfo[msg.sender].tc, 1);
188 
189         emit Transfer(msg.sender, _to, _value);
190         return true;
191     }
192 
193     function super_transferFrom(address _from, address _to, uint _value) /*public*/ internal returns (bool success) {
194         
195         require(!isSendingLocked[_from]);
196         require(_value <= oneTransferLimit);
197         require(balances[_from] >= _value);
198 
199         if(msg.sender == contrInitiator && _from == thisContract) {
200             // no restriction
201         } else {
202             require(!isAllTransfersLocked);  
203             require(safeAdd(getLast24hSendingValue(_from), _value) <= oneDayTransferLimit);
204             uint allowance = allowed[_from][msg.sender];
205             require(allowance >= _value);
206             allowed[_from][msg.sender] = safeSub(allowance, _value);
207         }
208 
209         balances[_from] = safeSub(balances[_from], _value);
210         balances[_to] = safeAdd(balances[_to], _value);
211     
212         uint tc=transferInfo[_from].tc;
213         transferInfo[_from].ti[tc].value = _value;
214         transferInfo[_from].ti[tc].time = now;
215         transferInfo[_from].tc = safeAdd(transferInfo[_from].tc, 1);
216 
217         emit Transfer(_from, _to, _value);
218         return true;
219     }
220 
221     function balanceOf(address _owner) public view returns (uint balance) {
222         return balances[_owner];
223     }
224 
225     function approve(address _spender, uint _value) public returns (bool success) {
226         allowed[msg.sender][_spender] = _value;
227         emit Approval(msg.sender, _spender, _value);
228         return true;
229     }
230 
231     function allowance(address _owner, address _spender) public view returns (uint remaining) {
232         return allowed[_owner][_spender];
233     }
234   
235 //-------------------------------------------------------------------------------------
236 //from Standard223Token
237 
238     //function that is called when a user or another contract wants to transfer funds
239     function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
240         //filtering if the target is a contract with bytecode inside it
241         if (!super_transfer(_to, _value)) assert(false); // do a normal token transfer
242         if (isContract(_to)) {
243             if(!contractFallback(msg.sender, _to, _value, _data)) assert(false);
244         }
245         return true;
246     }
247 
248     function transferFrom(address _from, address _to, uint _value, bytes _data) public returns (bool success) {
249         if (!super_transferFrom(_from, _to, _value)) assert(false); // do a normal token transfer
250         if (isContract(_to)) {
251             if(!contractFallback(_from, _to, _value, _data)) assert(false);
252         }
253         return true;
254     }
255 
256     function transfer(address _to, uint _value) public returns (bool success) {
257         return transfer(_to, _value, new bytes(0));
258     }
259 
260     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
261         return transferFrom(_from, _to, _value, new bytes(0));
262     }
263 
264     //function that is called when transaction target is a contract
265     function contractFallback(address _origin, address _to, uint _value, bytes _data) private returns (bool success) {
266         ERC223Receiver reciever = ERC223Receiver(_to);
267         return reciever.tokenFallback(msg.sender, _origin, _value, _data);
268     }
269 
270     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
271     function isContract(address _addr) private view returns (bool is_contract) {
272         // retrieve the size of the code on target address, this needs assembly
273         uint length;
274         assembly { length := extcodesize(_addr) }
275         return length > 0;
276     }
277 
278 //-------------------------------------------------------------------------------------
279 //from Standard223Receiver
280 
281     Tkn tkn;
282 
283     struct Tkn {
284         address addr;
285         address sender;
286         address origin;
287         uint256 value;
288         bytes data;
289         bytes4 sig;
290     }
291 
292     function tokenFallback(address _sender, address _origin, uint _value, bytes _data) public returns (bool ok) {
293         if (!supportsToken(msg.sender)) return false;
294 
295         // Problem: This will do a sstore which is expensive gas wise. Find a way to keep it in memory.
296         tkn = Tkn(msg.sender, _sender, _origin, _value, _data, getSig(_data));
297         __isTokenFallback = true;
298         if (!address(this).delegatecall(_data)) return false;
299 
300         // avoid doing an overwrite to .token, which would be more expensive
301         // makes accessing .tkn values outside tokenPayable functions unsafe
302         __isTokenFallback = false;
303 
304         return true;
305     }
306 
307     function getSig(bytes _data) private pure returns (bytes4 sig) {
308         uint l = _data.length < 4 ? _data.length : 4;
309         for (uint i = 0; i < l; i++) {
310             sig = bytes4(uint(sig) + uint(_data[i]) * (2 ** (8 * (l - 1 - i))));
311         }
312     }
313 
314     bool __isTokenFallback;
315 
316     modifier tokenPayable {
317         if (!__isTokenFallback) assert(false);
318         _;                                                              //_ is a special character used in modifiers
319     }
320 
321     //function supportsToken(address token) public pure returns (bool);  //moved up
322 
323 //-------------------------------------------------------------------------------------
324 //from ExampleReceiver
325 
326 /*
327 //we do not use dedicated function to receive Token in contract associated account
328     function foo(
329         //uint i
330         ) tokenPayable public {
331         emit LogTokenPayable(1, tkn.addr, tkn.sender, tkn.value);
332     }
333 */
334     function () tokenPayable public {
335         emit LogTokenPayable(0, tkn.addr, tkn.sender, tkn.value);
336     }
337 
338       function supportsToken(address token) public view returns (bool) {
339         //do not need to to anything with that token address?
340         //if (token == 0) { //attila addition
341         if (token != thisContract) { //attila addition, support only our own token, not others' token
342             return false;
343         }
344         if(!isTokenSupport) {  //attila addition
345             return false;
346         }
347         return true;
348     }
349 
350     event LogTokenPayable(uint i, address token, address sender, uint value);
351   
352 //-------------------------------------------------------------------------------------
353 // My extensions
354 /*
355     function enableTokenSupport(bool _tokenSupport) public returns (bool success) {
356         if(msg.sender == contrInitiator) {
357             isTokenSupport = _tokenSupport;
358             return true;
359         } else {
360             return false;  
361         }
362     }
363 */
364     function setIsAllTransfersLocked(bool _lock) public {
365         require(msg.sender == contrInitiator);
366         isAllTransfersLocked = _lock;
367     }
368 
369     function setIsSendingLocked(address _from, bool _lock) public {
370         require(msg.sender == contrInitiator);
371         isSendingLocked[_from] = _lock;
372     }
373 
374     function getIsAllTransfersLocked() public view returns (bool ok) {
375         return isAllTransfersLocked;
376     }
377 
378     function getIsSendingLocked(address _from ) public view returns (bool ok) {
379         return isSendingLocked[_from];
380     }
381  
382 /*  
383     function getTransferInfoCount(address _from) public view returns (uint count) {
384         return transferInfo[_from].tc;
385     }
386 */    
387 /*
388     // use experimental feature
389     function getTransferInfo(address _from, uint index) public view returns (TransferInfo ti) {
390         return transferInfo[_from].ti[index];
391     }
392 */ 
393 /*
394     function getTransferInfoTime(address _from, uint index) public view returns (uint time) {
395         return transferInfo[_from].ti[index].time;
396     }
397 */
398 /*
399     function getTransferInfoValue(address _from, uint index) public view returns (uint value) {
400         return transferInfo[_from].ti[index].value;
401     }
402 */
403     function getLast24hSendingValue(address _from) public view returns (uint totVal) {
404       
405         totVal = 0;  //declared above;
406         uint tc = transferInfo[_from].tc;
407       
408         if(tc > 0) {
409             for(uint i = tc-1 ; i >= 0 ; i--) {
410 //              if(now - transferInfo[_from].ti[i].time < 10 minutes) {
411 //              if(now - transferInfo[_from].ti[i].time < 1 hours) {
412                 if(now - transferInfo[_from].ti[i].time < 1 days) {
413                     totVal = safeAdd(totVal, transferInfo[_from].ti[i].value );
414                 } else {
415                     break;
416                 }
417             }
418         }
419     }
420 
421     
422     function airdropIndividual(address[] _recipients, uint256[] _values, uint256 _elemCount, uint _totalValue)  public returns (bool success) {
423         
424         require(_recipients.length == _elemCount);
425         require(_values.length == _elemCount); 
426         
427         uint256 totalValue = 0;
428         for(uint i = 0; i< _recipients.length; i++) {
429             totalValue = safeAdd(totalValue, _values[i]);
430         }
431         
432         require(totalValue == _totalValue);
433         
434         for(i = 0; i< _recipients.length; i++) {
435             transfer(_recipients[i], _values[i]);
436         }
437         return true;
438     }
439 
440 
441 }