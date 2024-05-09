1 pragma solidity 0.5.6;
2 
3 // ---------------------------------------------------------------------------
4 //  Message_Transport
5 // ---------------------------------------------------------------------------
6 //import './SafeMath.sol';
7 /*
8     Overflow protected math functions
9 */
10 contract SafeMath {
11     /**
12         constructor
13     */
14     constructor() public {
15     }
16 
17     /**
18         @dev returns the sum of _x and _y, asserts if the calculation overflows
19 
20         @param _x   value 1
21         @param _y   value 2
22 
23         @return sum
24     */
25     function safeAdd(uint256 _x, uint256 _y) pure internal returns (uint256) {
26         uint256 z = _x + _y;
27         assert(z >= _x);
28         return z;
29     }
30 
31     /**
32         @dev returns the difference of _x minus _y, asserts if the subtraction results in a negative number
33 
34         @param _x   minuend
35         @param _y   subtrahend
36 
37         @return difference
38     */
39     function safeSub(uint256 _x, uint256 _y) pure internal returns (uint256) {
40         assert(_x >= _y);
41         return _x - _y;
42     }
43 
44     /**
45         @dev returns the product of multiplying _x by _y, asserts if the calculation overflows
46 
47         @param _x   factor 1
48         @param _y   factor 2
49 
50         @return product
51     */
52     function safeMul(uint256 _x, uint256 _y) pure internal returns (uint256) {
53         uint256 z = _x * _y;
54         assert(_x == 0 || z / _x == _y);
55         return z;
56     }
57 }
58 
59 //import './Ownable.sol';
60 /**
61  * @title Ownable
62  * @dev The Ownable contract has an owner address, and provides basic authorization control
63  * functions, this simplifies the implementation of "user permissions".
64  */
65 contract Ownable {
66     address private _owner;
67 
68     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70     /**
71      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
72      * account.
73      */
74     constructor () internal {
75         _owner = msg.sender;
76         emit OwnershipTransferred(address(0), _owner);
77     }
78 
79     /**
80      * @return the address of the owner.
81      */
82     function owner() public view returns (address) {
83         return _owner;
84     }
85 
86     /**
87      * @dev Throws if called by any account other than the owner.
88      */
89     modifier onlyOwner() {
90         require(isOwner());
91         _;
92     }
93 
94     /**
95      * @return true if `msg.sender` is the owner of the contract.
96      */
97     function isOwner() public view returns (bool) {
98         return msg.sender == _owner;
99     }
100 
101     /**
102      * @dev Allows the current owner to relinquish control of the contract.
103      * It will not be possible to call the functions with the `onlyOwner`
104      * modifier anymore.
105      * @notice Renouncing ownership will leave the contract without an owner,
106      * thereby removing any functionality that is only available to the owner.
107      */
108     function renounceOwnership() public onlyOwner {
109         emit OwnershipTransferred(_owner, address(0));
110         _owner = address(0);
111     }
112 
113     /**
114      * @dev Allows the current owner to transfer control of the contract to a newOwner.
115      * @param newOwner The address to transfer ownership to.
116      */
117     function transferOwnership(address newOwner) public onlyOwner {
118         _transferOwnership(newOwner);
119     }
120 
121     /**
122      * @dev Transfers control of the contract to a newOwner.
123      * @param newOwner The address to transfer ownership to.
124      */
125     function _transferOwnership(address newOwner) internal {
126         require(newOwner != address(0));
127         emit OwnershipTransferred(_owner, newOwner);
128         _owner = newOwner;
129     }
130 }
131 
132 
133 contract MessageTransport is SafeMath, Ownable {
134 
135   // -------------------------------------------------------------------------
136   // events
137   // etherscan.io's Event Log API does not have an option to match multiple values
138   // in an individual topic. so in order to match any one of three message id's we
139   // duplicate the message id into 3 topic position.
140   // -------------------------------------------------------------------------
141   event InviteEvent(address indexed _toAddr, address indexed _fromAddr);
142   event MessageEvent(uint indexed _id1, uint indexed _id2, uint indexed _id3,
143                      address _fromAddr, address _toAddr, address _via, uint _txCount, uint _rxCount, uint _attachmentIdx, uint _ref, bytes message);
144   event MessageTxEvent(address indexed _fromAddr, uint indexed _txCount, uint _id);
145   event MessageRxEvent(address indexed _toAddr, uint indexed _rxCount, uint _id);
146 
147 
148   // -------------------------------------------------------------------------
149   // Account structure
150   // there is a single account structure for all account types
151   // -------------------------------------------------------------------------
152   struct Account {
153     bool isValid;
154     uint messageFee;           // pay this much for every non-spam message sent to this account
155     uint spamFee;              // pay this much for every spam message sent to this account
156     uint feeBalance;           // includes spam and non-spam fees
157     uint recvMessageCount;     // total messages received
158     uint sentMessageCount;     // total messages sent
159     bytes publicKey;           // encryption parameter
160     bytes encryptedPrivateKey; // encryption parameter
161     mapping (address => uint256) peerRecvMessageCount;
162     mapping (uint256 => uint256) recvIds;
163     mapping (uint256 => uint256) sentIds;
164   }
165 
166 
167   // -------------------------------------------------------------------------
168   // data storage
169   // -------------------------------------------------------------------------
170   bool public isLocked;
171   address public tokenAddr;
172   uint public messageCount;
173   uint public retainedFeesBalance;
174   mapping (address => bool) public trusted;
175   mapping (address => Account) public accounts;
176 
177 
178   // -------------------------------------------------------------------------
179   // modifiers
180   // -------------------------------------------------------------------------
181   modifier trustedOnly {
182     require(trusted[msg.sender] == true, "trusted only");
183     _;
184   }
185 
186 
187   // -------------------------------------------------------------------------
188   //  MessageTransport constructor
189   // -------------------------------------------------------------------------
190   constructor(address _tokenAddr) public {
191     tokenAddr = _tokenAddr;
192   }
193   function setTrust(address _trustedAddr, bool _trust) public onlyOwner {
194     trusted[_trustedAddr] = _trust;
195   }
196 
197 
198   // -------------------------------------------------------------------------
199   // register a message account
200   // the decryption key for the encryptedPrivateKey should be guarded with the
201   // same secrecy and caution as the ethereum private key. in fact the decryption
202   // key should never be tranmitted or stored at all -- but always derived from a
203   // message signature; that is, through metamask.
204   // -------------------------------------------------------------------------
205   function register(uint256 _messageFee, uint256 _spamFee, bytes memory _publicKey, bytes memory _encryptedPrivateKey) public {
206     Account storage _account = accounts[msg.sender];
207     require(_account.isValid == false, "account already registered");
208     _account.publicKey = _publicKey;
209     _account.encryptedPrivateKey = _encryptedPrivateKey;
210     _account.isValid = true;
211     _modifyAccount(_account, _messageFee, _spamFee);
212   }
213   function modifyAccount(uint256 _messageFee, uint256 _spamFee) public {
214     Account storage _account = accounts[msg.sender];
215     require(_account.isValid == true, "not registered");
216     _modifyAccount(_account, _messageFee, _spamFee);
217   }
218   function _modifyAccount(Account storage _account, uint256 _messageFee, uint256 _spamFee) internal {
219     _account.messageFee = _messageFee;
220     _account.spamFee = _spamFee;
221   }
222 
223 
224   // -------------------------------------------------------------------------
225   // get the number of messages that have been sent from one peer to another
226   // -------------------------------------------------------------------------
227   function getPeerMessageCount(address _from, address _to) public view returns(uint256 _messageCount) {
228     Account storage _account = accounts[_to];
229     _messageCount = _account.peerRecvMessageCount[_from];
230   }
231 
232 
233 
234   // -------------------------------------------------------------------------
235   // get _maxResults message id's of received messages
236   // note that array will always have _maxResults entries. ignore messageID = 0
237   // -------------------------------------------------------------------------
238   function getRecvMsgs(address _to, uint256 _startIdx, uint256 _maxResults) public view returns(uint256 _idx, uint256[] memory _messageIds) {
239     uint _count = 0;
240     Account storage _recvAccount = accounts[_to];
241     uint256 _recvMessageCount = _recvAccount.recvMessageCount;
242     _messageIds = new uint256[](_maxResults);
243     mapping(uint256 => uint256) storage _recvIds = _recvAccount.recvIds;
244     //first messageID is at recvIds[0];
245     for (_idx = _startIdx; _idx < _recvMessageCount; ++_idx) {
246       _messageIds[_count] = _recvIds[_idx];
247       if (++_count >= _maxResults)
248         break;
249     }
250   }
251 
252   // -------------------------------------------------------------------------
253   // get _maxResults message id's of sent messages
254   // note that array will always have _maxResults entries. ignore messageID = 0
255   // -------------------------------------------------------------------------
256   function getSentMsgs(address _from, uint256 _startIdx, uint256 _maxResults) public view returns(uint256 _idx, uint256[] memory _messageIds) {
257     uint _count = 0;
258     Account storage _sentAccount = accounts[_from];
259     uint256 _sentMessageCount = _sentAccount.sentMessageCount;
260     _messageIds = new uint256[](_maxResults);
261     mapping(uint256 => uint256) storage _sentIds = _sentAccount.sentIds;
262     //note first messageID is at recvIds[0];
263     for (_idx = _startIdx; _idx < _sentMessageCount; ++_idx) {
264       _messageIds[_count] = _sentIds[_idx];
265       if (++_count >= _maxResults)
266         break;
267     }
268   }
269 
270 
271   // -------------------------------------------------------------------------
272   // get the required fee in order to send a message (or spam message)
273   // the second version is handy for calls from partner contract(s)
274   // -------------------------------------------------------------------------
275   function getFee(address _toAddr) public view returns(uint256 _fee) {
276     Account storage _sendAccount = accounts[msg.sender];
277     Account storage _recvAccount = accounts[_toAddr];
278     if (_sendAccount.peerRecvMessageCount[_toAddr] == 0)
279       _fee = _recvAccount.spamFee;
280     else
281       _fee = _recvAccount.messageFee;
282   }
283   function getFee(address _fromAddr, address _toAddr) public view trustedOnly returns(uint256 _fee) {
284     Account storage _sendAccount = accounts[_fromAddr];
285     Account storage _recvAccount = accounts[_toAddr];
286     if (_sendAccount.peerRecvMessageCount[_toAddr] == 0)
287       _fee = _recvAccount.spamFee;
288     else
289       _fee = _recvAccount.messageFee;
290   }
291 
292 
293   // -------------------------------------------------------------------------
294   // send message
295   // the via address is set to the address of the trusted contract (or zero in
296   // case the fromAddr is msg.sender). in this way a DApp can indicate the via
297   // address to the recipient when the message was not sent directly from the
298   // sender.
299   // -------------------------------------------------------------------------
300   function sendMessage(address _toAddr, uint attachmentIdx, uint _ref, bytes memory _message) public payable returns (uint _messageId) {
301     uint256 _noDataLength = 4 + 32 + 32 + 32 + 64;
302     _messageId = doSendMessage(_noDataLength, msg.sender, _toAddr, address(0), attachmentIdx, _ref, _message);
303   }
304   function sendMessage(address _fromAddr, address _toAddr, uint attachmentIdx, uint _ref, bytes memory _message) public payable trustedOnly returns (uint _messageId) {
305     uint256 _noDataLength = 4 + 32 + 32 + 32 + 32 + 64;
306     _messageId = doSendMessage(_noDataLength, _fromAddr, _toAddr, msg.sender, attachmentIdx, _ref, _message);
307   }
308 
309 
310   function doSendMessage(uint256 _noDataLength, address _fromAddr, address _toAddr, address _via, uint attachmentIdx, uint _ref, bytes memory _message) internal returns (uint _messageId) {
311     Account storage _sendAccount = accounts[_fromAddr];
312     Account storage _recvAccount = accounts[_toAddr];
313     require(_sendAccount.isValid == true, "sender not registered");
314     require(_recvAccount.isValid == true, "recipient not registered");
315     //if message text is empty then no fees are necessary, and we don't create a log entry.
316     //after you introduce yourself to someone this way their subsequent message to you won't
317     //incur your spamFee.
318     if (msg.data.length > _noDataLength) {
319       if (_sendAccount.peerRecvMessageCount[_toAddr] == 0)
320         require(msg.value >= _recvAccount.spamFee, "spam fee is insufficient");
321       else
322         require(msg.value >= _recvAccount.messageFee, "fee is insufficient");
323       messageCount = safeAdd(messageCount, 1);
324       _recvAccount.recvIds[_recvAccount.recvMessageCount] = messageCount;
325       _sendAccount.sentIds[_sendAccount.sentMessageCount] = messageCount;
326       _recvAccount.recvMessageCount = safeAdd(_recvAccount.recvMessageCount, 1);
327       _sendAccount.sentMessageCount = safeAdd(_sendAccount.sentMessageCount, 1);
328       emit MessageEvent(messageCount, messageCount, messageCount, _fromAddr, _toAddr, _via, _sendAccount.sentMessageCount, _recvAccount.recvMessageCount, attachmentIdx, _ref, _message);
329       emit MessageTxEvent(_fromAddr, _sendAccount.sentMessageCount, messageCount);
330       emit MessageRxEvent(_toAddr, _recvAccount.recvMessageCount, messageCount);
331       //return message id, which a calling function might want to log
332       _messageId = messageCount;
333     } else {
334       emit InviteEvent(_toAddr, _fromAddr);
335       _messageId = 0;
336     }
337     uint _retainAmount = safeMul(msg.value, 30) / 100;
338     retainedFeesBalance = safeAdd(retainedFeesBalance, _retainAmount);
339     _recvAccount.feeBalance = safeAdd(_recvAccount.feeBalance, safeSub(msg.value, _retainAmount));
340     _recvAccount.peerRecvMessageCount[_fromAddr] = safeAdd(_recvAccount.peerRecvMessageCount[_fromAddr], 1);
341   }
342 
343 
344   // -------------------------------------------------------------------------
345   // withdraw accumulated message & spam fees
346   // -------------------------------------------------------------------------
347   function withdraw() public {
348     Account storage _account = accounts[msg.sender];
349     uint _amount = _account.feeBalance;
350     _account.feeBalance = 0;
351     msg.sender.transfer(_amount);
352   }
353 
354 
355   // -------------------------------------------------------------------------
356   // pay retained fees funds to token contract; burn half.
357   // -------------------------------------------------------------------------
358   function withdrawRetainedFees() public {
359     uint _amount = retainedFeesBalance / 2;
360     address(0).transfer(_amount);
361     _amount = safeSub(retainedFeesBalance, _amount);
362     retainedFeesBalance = 0;
363     (bool paySuccess, ) = tokenAddr.call.value(_amount)("");
364     require(paySuccess, "failed to transfer fees");
365   }
366 
367 }