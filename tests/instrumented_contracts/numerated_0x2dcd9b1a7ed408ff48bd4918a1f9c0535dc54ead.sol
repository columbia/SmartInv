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
100 contract WeSingCoin223Token_11 is ERC20, ERC223, Standard223Receiver, SafeMath {
101 
102     mapping(address => uint) balances;
103     mapping (address => mapping (address => uint)) allowed;
104   
105     string public name;                   //fancy name: eg Simon Bucks
106     uint8 public decimals;                //How many decimals to show.
107     string public symbol;                 //An identifier: eg SBX
108 
109     address /*public*/ contrInitiator;
110     address /*public*/ thisContract;
111     bool /*public*/ isTokenSupport;
112   
113     mapping(address => bool) isSendingLocked;
114     bool isAllTransfersLocked;
115   
116     uint oneTransferLimit;
117     uint oneDayTransferLimit;
118  
119 
120     struct TransferInfo {
121         //address sender;    //maybe use in the future
122         //address from;      //no need because all this is kept in transferInfo[_from]
123         //address to;        //maybe use in the future
124         uint256 value;
125         uint time;
126     }
127 
128     struct TransferInfos {
129         mapping (uint => TransferInfo) ti;
130         uint tc;
131     }
132   
133     mapping (address => TransferInfos) transferInfo;
134 
135 //-------------------------------------------------------------------------------------
136 //from ExampleToken
137 
138     constructor(/*uint initialBalance*/) public {
139     
140         decimals    = 6;                                // Amount of decimals for display purposes
141         name        = "WeSingCoin";                     // Set the name for display purposes
142         symbol      = 'WSC';                            // Set the symbol for display purposes
143 
144         uint initialBalance  = (10 ** uint256(decimals)) * 5000*1000*1000;
145     
146         balances[msg.sender] = initialBalance;
147         totalSupply = initialBalance;
148     
149         contrInitiator = msg.sender;
150         thisContract = this;
151         isTokenSupport = false;
152     
153         isAllTransfersLocked = true;
154     
155         oneTransferLimit    = (10 ** uint256(decimals)) * 10*1000*1000;
156         oneDayTransferLimit = (10 ** uint256(decimals)) * 50*1000*1000;
157 
158     // Ideally call token fallback here too
159     }
160 
161 //-------------------------------------------------------------------------------------
162 //from StandardToken
163 
164     function super_transfer(address _to, uint _value) /*public*/ internal returns (bool success) {
165 
166         require(!isSendingLocked[msg.sender]);
167         require(_value <= oneTransferLimit);
168         require(balances[msg.sender] >= _value);
169 
170         if(msg.sender == contrInitiator) {
171             //no restricton
172         } else {
173             require(!isAllTransfersLocked);  
174             require(safeAdd(getLast24hSendingValue(msg.sender), _value) <= oneDayTransferLimit);
175         }
176 
177 
178         balances[msg.sender] = safeSub(balances[msg.sender], _value);
179         balances[_to] = safeAdd(balances[_to], _value);
180     
181         uint tc=transferInfo[msg.sender].tc;
182         transferInfo[msg.sender].ti[tc].value = _value;
183         transferInfo[msg.sender].ti[tc].time = now;
184         transferInfo[msg.sender].tc = safeAdd(transferInfo[msg.sender].tc, 1);
185 
186         emit Transfer(msg.sender, _to, _value);
187         return true;
188     }
189 
190     function super_transferFrom(address _from, address _to, uint _value) /*public*/ internal returns (bool success) {
191         
192         require(!isSendingLocked[_from]);
193         require(_value <= oneTransferLimit);
194         require(balances[_from] >= _value);
195 
196         if(msg.sender == contrInitiator && _from == thisContract) {
197             // no restriction
198         } else {
199             require(!isAllTransfersLocked);  
200             require(safeAdd(getLast24hSendingValue(_from), _value) <= oneDayTransferLimit);
201             uint allowance = allowed[_from][msg.sender];
202             require(allowance >= _value);
203             allowed[_from][msg.sender] = safeSub(allowance, _value);
204         }
205 
206         balances[_from] = safeSub(balances[_from], _value);
207         balances[_to] = safeAdd(balances[_to], _value);
208     
209         uint tc=transferInfo[_from].tc;
210         transferInfo[_from].ti[tc].value = _value;
211         transferInfo[_from].ti[tc].time = now;
212         transferInfo[_from].tc = safeAdd(transferInfo[_from].tc, 1);
213 
214         emit Transfer(_from, _to, _value);
215         return true;
216     }
217 
218     function balanceOf(address _owner) public view returns (uint balance) {
219         return balances[_owner];
220     }
221 
222     function approve(address _spender, uint _value) public returns (bool success) {
223         allowed[msg.sender][_spender] = _value;
224         emit Approval(msg.sender, _spender, _value);
225         return true;
226     }
227 
228     function allowance(address _owner, address _spender) public view returns (uint remaining) {
229         return allowed[_owner][_spender];
230     }
231   
232 //-------------------------------------------------------------------------------------
233 //from Standard223Token
234 
235     //function that is called when a user or another contract wants to transfer funds
236     function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
237         //filtering if the target is a contract with bytecode inside it
238         if (!super_transfer(_to, _value)) assert(false); // do a normal token transfer
239         if (isContract(_to)) {
240             if(!contractFallback(msg.sender, _to, _value, _data)) assert(false);
241         }
242         return true;
243     }
244 
245     function transferFrom(address _from, address _to, uint _value, bytes _data) public returns (bool success) {
246         if (!super_transferFrom(_from, _to, _value)) assert(false); // do a normal token transfer
247         if (isContract(_to)) {
248             if(!contractFallback(_from, _to, _value, _data)) assert(false);
249         }
250         return true;
251     }
252 
253     function transfer(address _to, uint _value) public returns (bool success) {
254         return transfer(_to, _value, new bytes(0));
255     }
256 
257     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
258         return transferFrom(_from, _to, _value, new bytes(0));
259     }
260 
261     //function that is called when transaction target is a contract
262     function contractFallback(address _origin, address _to, uint _value, bytes _data) private returns (bool success) {
263         ERC223Receiver reciever = ERC223Receiver(_to);
264         return reciever.tokenFallback(msg.sender, _origin, _value, _data);
265     }
266 
267     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
268     function isContract(address _addr) private view returns (bool is_contract) {
269         // retrieve the size of the code on target address, this needs assembly
270         uint length;
271         assembly { length := extcodesize(_addr) }
272         return length > 0;
273     }
274 
275 //-------------------------------------------------------------------------------------
276 //from Standard223Receiver
277 
278     Tkn tkn;
279 
280     struct Tkn {
281         address addr;
282         address sender;
283         address origin;
284         uint256 value;
285         bytes data;
286         bytes4 sig;
287     }
288 
289     function tokenFallback(address _sender, address _origin, uint _value, bytes _data) public returns (bool ok) {
290         if (!supportsToken(msg.sender)) return false;
291 
292         // Problem: This will do a sstore which is expensive gas wise. Find a way to keep it in memory.
293         tkn = Tkn(msg.sender, _sender, _origin, _value, _data, getSig(_data));
294         __isTokenFallback = true;
295         if (!address(this).delegatecall(_data)) return false;
296 
297         // avoid doing an overwrite to .token, which would be more expensive
298         // makes accessing .tkn values outside tokenPayable functions unsafe
299         __isTokenFallback = false;
300 
301         return true;
302     }
303 
304     function getSig(bytes _data) private pure returns (bytes4 sig) {
305         uint l = _data.length < 4 ? _data.length : 4;
306         for (uint i = 0; i < l; i++) {
307             sig = bytes4(uint(sig) + uint(_data[i]) * (2 ** (8 * (l - 1 - i))));
308         }
309     }
310 
311     bool __isTokenFallback;
312 
313     modifier tokenPayable {
314         if (!__isTokenFallback) assert(false);
315         _;                                                              //_ is a special character used in modifiers
316     }
317 
318     //function supportsToken(address token) public pure returns (bool);  //moved up
319 
320 //-------------------------------------------------------------------------------------
321 //from ExampleReceiver
322 
323 /*
324 //we do not use dedicated function to receive Token in contract associated account
325     function foo(
326         //uint i
327         ) tokenPayable public {
328         emit LogTokenPayable(1, tkn.addr, tkn.sender, tkn.value);
329     }
330 */
331     function () tokenPayable public {
332         emit LogTokenPayable(0, tkn.addr, tkn.sender, tkn.value);
333     }
334 
335       function supportsToken(address token) public view returns (bool) {
336         //do not need to to anything with that token address?
337         //if (token == 0) { //attila addition
338         if (token != thisContract) { //attila addition, support only our own token, not others' token
339             return false;
340         }
341         if(!isTokenSupport) {  //attila addition
342             return false;
343         }
344         return true;
345     }
346 
347     event LogTokenPayable(uint i, address token, address sender, uint value);
348   
349 //-------------------------------------------------------------------------------------
350 // My extensions
351 /*
352     function enableTokenSupport(bool _tokenSupport) public returns (bool success) {
353         if(msg.sender == contrInitiator) {
354             isTokenSupport = _tokenSupport;
355             return true;
356         } else {
357             return false;  
358         }
359     }
360 */
361     function setIsAllTransfersLocked(bool _lock) public {
362         require(msg.sender == contrInitiator);
363         isAllTransfersLocked = _lock;
364     }
365 
366     function setIsSendingLocked(address _from, bool _lock) public {
367         require(msg.sender == contrInitiator);
368         isSendingLocked[_from] = _lock;
369     }
370 
371     function getIsAllTransfersLocked() public view returns (bool ok) {
372         return isAllTransfersLocked;
373     }
374 
375     function getIsSendingLocked(address _from ) public view returns (bool ok) {
376         return isSendingLocked[_from];
377     }
378  
379 /*  
380     function getTransferInfoCount(address _from) public view returns (uint count) {
381         return transferInfo[_from].tc;
382     }
383 */    
384 /*
385     // use experimental feature
386     function getTransferInfo(address _from, uint index) public view returns (TransferInfo ti) {
387         return transferInfo[_from].ti[index];
388     }
389 */ 
390 /*
391     function getTransferInfoTime(address _from, uint index) public view returns (uint time) {
392         return transferInfo[_from].ti[index].time;
393     }
394 */
395 /*
396     function getTransferInfoValue(address _from, uint index) public view returns (uint value) {
397         return transferInfo[_from].ti[index].value;
398     }
399 */
400     function getLast24hSendingValue(address _from) public view returns (uint totVal) {
401       
402         totVal = 0;  //declared above;
403         uint tc = transferInfo[_from].tc;
404       
405         if(tc > 0) {
406             for(uint i = tc-1 ; i >= 0 ; i--) {
407 //              if(now - transferInfo[_from].ti[i].time < 10 minutes) {
408 //              if(now - transferInfo[_from].ti[i].time < 1 hours) {
409                 if(now - transferInfo[_from].ti[i].time < 1 days) {
410                     totVal = safeAdd(totVal, transferInfo[_from].ti[i].value );
411                 } else {
412                     break;
413                 }
414             }
415         }
416     }
417 
418     
419     function airdropIndividual(address[] _recipients, uint256[] _values, uint256 _elemCount, uint _totalValue)  public returns (bool success) {
420         
421         require(_recipients.length == _elemCount);
422         require(_values.length == _elemCount); 
423         require(_elemCount <= 50); 
424         
425         uint256 totalValue = 0;
426         for(uint i = 0; i< _recipients.length; i++) {
427             totalValue = safeAdd(totalValue, _values[i]);
428         }
429         
430         require(totalValue == _totalValue);
431         
432         for(i = 0; i< _recipients.length; i++) {
433             transfer(_recipients[i], _values[i]);
434         }
435         return true;
436     }
437 
438 
439 }