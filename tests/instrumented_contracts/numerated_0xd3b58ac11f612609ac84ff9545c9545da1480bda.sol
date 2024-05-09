1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56   function totalSupply() public view returns (uint256);
57   function balanceOf(address who) public view returns (uint256);
58   function transfer(address to, uint256 value) public returns (bool);
59   event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 
63 /**
64  * @title ERC20 interface
65  * @dev see https://github.com/ethereum/EIPs/issues/20
66  */
67 contract ERC20 is ERC20Basic {
68   function allowance(address owner, address spender) public view returns (uint256);
69   function transferFrom(address from, address to, uint256 value) public returns (bool);
70   function approve(address spender, uint256 value) public returns (bool);
71   event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 
75 /**
76  * @title Ownable
77  * @dev The Ownable contract has an owner address, and provides basic authorization control
78  * functions, this simplifies the implementation of "user permissions".
79  */
80 contract Ownable {
81   address public owner;
82 
83 
84   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
85 
86 
87   /**
88    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
89    * account.
90    */
91   function Ownable() public {
92     owner = msg.sender;
93   }
94 
95   /**
96    * @dev Throws if called by any account other than the owner.
97    */
98   modifier onlyOwner() {
99     require(msg.sender == owner);
100     _;
101   }
102 
103   /**
104    * @dev Allows the current owner to transfer control of the contract to a newOwner.
105    * @param newOwner The address to transfer ownership to.
106    */
107   function transferOwnership(address newOwner) public onlyOwner {
108     require(newOwner != address(0));
109     emit OwnershipTransferred(owner, newOwner);
110     owner = newOwner;
111   }
112 
113 }
114 
115 
116 /**
117  * @title Pausable
118  * @dev Base contract which allows children to implement an emergency stop mechanism.
119  */
120 contract Pausable is Ownable {
121   event Pause();
122   event Unpause();
123 
124   bool public paused = false;
125 
126 
127   /**
128    * @dev Modifier to make a function callable only when the contract is not paused.
129    */
130   modifier whenNotPaused() {
131     require(!paused);
132     _;
133   }
134 
135   /**
136    * @dev Modifier to make a function callable only when the contract is paused.
137    */
138   modifier whenPaused() {
139     require(paused);
140     _;
141   }
142 
143   /**
144    * @dev called by the owner to pause, triggers stopped state
145    */
146   function pause() onlyOwner whenNotPaused public {
147     paused = true;
148     emit Pause();
149   }
150 
151   /**
152    * @dev called by the owner to unpause, returns to normal state
153    */
154   function unpause() onlyOwner whenPaused public {
155     paused = false;
156     emit Unpause();
157   }
158 }
159 
160 
161 
162 contract DateTime {
163         function getYear(uint timestamp) public constant returns (uint16);
164         function getMonth(uint timestamp) public constant returns (uint8);
165         function getDay(uint timestamp) public constant returns (uint8);
166 }
167 
168 contract TokenDistributor {
169 
170     using SafeMath for uint256;
171 
172     address public owner;
173     address public newOwnerCandidate;
174 
175     ERC20 public token;
176     uint public neededAmountTotal;
177     uint public releasedTokenTotal;
178 
179     address public approver;
180     uint public distributedBountyTotal;
181 
182     struct DistributeList {
183         uint totalAmount;
184         uint releasedToken;
185         LockUpData[] lockUpData;
186     }    
187 
188     struct LockUpData {
189         uint amount;
190         uint releaseDate;
191     }
192 
193     /*
194     //
195     // address for DateTime should be changed before contract deploying.
196     //
197     */
198     //address public dateTimeAddr = 0xF0847087aAf608b4732be58b63151bDf4d548612;
199     //DateTime public dateTime = DateTime(dateTimeAddr);    
200     DateTime public dateTime;
201     
202     mapping (address => DistributeList) public distributeList;    
203 
204     /*
205     //  events
206     */
207     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
208     event OwnershipTransferRequsted(address indexed previousOwner, address indexed newOwner);
209     
210     event ReceiverChanged(address indexed previousReceiver, address indexed newReceiver);
211     event ReceiverRemoved(address indexed tokenReceiver);
212     
213     event ReleaseToken(address indexed tokenReceiver, uint amount);
214 
215     event BountyDistributed(uint listCount, uint amount);
216    
217    /*
218    //   modifiers
219    */
220     modifier onlyOwner() {
221         require(msg.sender == owner);
222         _;
223     }
224     
225     /* constructor */
226     function TokenDistributor(ERC20 _tokenAddr, address _dateTimeAddr) public {
227         owner = msg.sender;
228         token = _tokenAddr;
229         dateTime = DateTime(_dateTimeAddr); 
230     }
231 
232     /* fallback */
233     function () external  {
234         releaseToken();
235     }
236 
237     function requestTransferOwnership(address newOwner) public onlyOwner {
238         require(newOwner != address(0));
239         emit OwnershipTransferRequsted(owner, newOwner);
240         newOwnerCandidate = newOwner;
241     }
242 
243     function receiveTransferOwnership() public {
244         require(newOwnerCandidate == msg.sender);
245         emit OwnershipTransferred(owner, newOwnerCandidate);
246         owner = newOwnerCandidate;
247     }
248 
249     function addLockUpData(address _receiver, uint[] _amount, uint[] _releaseDate) public payable onlyOwner {
250         require(_amount.length == _releaseDate.length && _receiver != address(0));
251 
252         uint tokenReserve;
253         DistributeList storage dl = distributeList[_receiver];
254 
255         // check amount of lock token
256         for (uint i = 0; i < _amount.length; i++) {
257             tokenReserve += _amount[i];
258         }
259         
260         require(neededAmountTotal.add(tokenReserve) <= token.balanceOf(this));
261 
262         for (i = 0; i < _amount.length; i++) {
263             dl.lockUpData.push(LockUpData(_amount[i], _releaseDate[i]));
264         }
265         
266         dl.totalAmount += tokenReserve;
267         neededAmountTotal += tokenReserve;
268         
269     }
270     
271     function changeReceiver(address _from, address _to) public onlyOwner {
272         //change only when _to address has 0 amount (means new address)
273         require(_to != address(0) && distributeList[_to].totalAmount == 0);
274         
275         distributeList[_to] = distributeList[_from];
276         delete distributeList[_from];
277         emit ReceiverChanged(_from, _to);
278     }
279     
280     function removeReceiver(address _receiver) public onlyOwner {
281         require(distributeList[_receiver].totalAmount >= distributeList[_receiver].releasedToken);
282         
283         //adjust neededAmountTotal when lockupdata removing.
284         neededAmountTotal -= (distributeList[_receiver].totalAmount).sub(distributeList[_receiver].releasedToken);
285 
286         delete distributeList[_receiver];
287 
288         emit ReceiverRemoved(_receiver);
289     }
290     
291     function releaseTokenByOwner(address _tokenReceiver) public onlyOwner {
292         _releaseToken(_tokenReceiver);
293     }
294     
295     function releaseToken() public {
296         _releaseToken(msg.sender);
297     }
298     
299     function _releaseToken(address _tokenReceiver) internal {
300 
301         DistributeList storage dl = distributeList[_tokenReceiver];
302         uint releasableToken;
303 
304         for (uint i=0; i < dl.lockUpData.length ; i++){
305 
306             if(dl.lockUpData[i].releaseDate <= now && dl.lockUpData[i].amount > 0){
307                 releasableToken += dl.lockUpData[i].amount;
308                 dl.lockUpData[i].amount = 0;
309             }
310         }
311         
312         dl.releasedToken    += releasableToken;
313         releasedTokenTotal  += releasableToken;
314         neededAmountTotal   -= releasableToken;
315         
316         token.transfer(_tokenReceiver, releasableToken);
317         emit ReleaseToken(_tokenReceiver, releasableToken);
318     }
319     
320     function transfer(address _to, uint _amount) public onlyOwner {
321         require(neededAmountTotal.add(_amount) <= token.balanceOf(this) && token.balanceOf(this) > 0);
322         token.transfer(_to, _amount);
323     }
324     
325     //should be set for distributeBounty function. and set appropriate approve amount for bounty. 
326     function setApprover(address _approver) public onlyOwner {
327         approver = _approver;
328     }
329     
330     //should be checked approved amount and the sum of _amount
331     function distributeBounty(address[] _receiver, uint[] _amount) public payable onlyOwner {
332         require(_receiver.length == _amount.length);
333         uint bountyAmount;
334         
335         for (uint i = 0; i < _amount.length; i++) {
336             distributedBountyTotal += _amount[i];
337             bountyAmount += _amount[i];
338             token.transferFrom(approver, _receiver[i], _amount[i]);
339         }
340         emit BountyDistributed(_receiver.length, bountyAmount);
341     }
342 
343     function viewLockUpStatus(address _tokenReceiver) public view returns (uint _totalLockedToken, uint _releasedToken, uint _releasableToken) {
344     
345         DistributeList storage dl = distributeList[_tokenReceiver];
346         uint releasableToken;
347 
348         for (uint i=0; i < dl.lockUpData.length ; i++) {
349             if(dl.lockUpData[i].releaseDate <= now && dl.lockUpData[i].amount > 0) {
350                 releasableToken += dl.lockUpData[i].amount;
351             }
352         }
353         
354         return (dl.totalAmount, dl.releasedToken, releasableToken);
355         
356     }
357 
358     function viewNextRelease(address _tokenRecv) public view returns (uint _amount, uint _year, uint _month, uint _day) {
359     
360         DistributeList storage dl = distributeList[_tokenRecv];
361         uint _releasableToken;
362         uint _releaseDate;
363 
364         for (uint i=0; i < dl.lockUpData.length ; i++){
365             if(dl.lockUpData[i].releaseDate > now && dl.lockUpData[i].amount > 0){
366                 if(_releaseDate < dl.lockUpData[i].releaseDate || _releaseDate == 0 ){
367                     _releasableToken = dl.lockUpData[i].amount;
368                     _releaseDate = dl.lockUpData[i].releaseDate;
369                 }
370             }
371         }
372         
373         return (_releasableToken, dateTime.getYear(_releaseDate), dateTime.getMonth(_releaseDate), dateTime.getDay(_releaseDate) );
374 
375     }
376 
377     function viewContractHoldingToken() public view returns (uint _amount) {
378         return (token.balanceOf(this));
379     }
380 
381 }