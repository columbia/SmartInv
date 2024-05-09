1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title Owned contract with safe ownership pass.
5  *
6  * Note: all the non constant functions return false instead of throwing in case if state change
7  * didn't happen yet.
8  */
9 contract Owned {
10     /**
11      * Contract owner address
12      */
13     address public contractOwner;
14 
15     /**
16      * Contract owner address
17      */
18     address public pendingContractOwner;
19 
20     function Owned() {
21         contractOwner = msg.sender;
22     }
23 
24     /**
25     * @dev Owner check modifier
26     */
27     modifier onlyContractOwner() {
28         if (contractOwner == msg.sender) {
29             _;
30         }
31     }
32 
33     /**
34      * @dev Destroy contract and scrub a data
35      * @notice Only owner can call it
36      */
37     function destroy() onlyContractOwner {
38         suicide(msg.sender);
39     }
40 
41     /**
42      * Prepares ownership pass.
43      *
44      * Can only be called by current owner.
45      *
46      * @param _to address of the next owner. 0x0 is not allowed.
47      *
48      * @return success.
49      */
50     function changeContractOwnership(address _to) onlyContractOwner() returns(bool) {
51         if (_to  == 0x0) {
52             return false;
53         }
54 
55         pendingContractOwner = _to;
56         return true;
57     }
58 
59     /**
60      * Finalize ownership pass.
61      *
62      * Can only be called by pending owner.
63      *
64      * @return success.
65      */
66     function claimContractOwnership() returns(bool) {
67         if (pendingContractOwner != msg.sender) {
68             return false;
69         }
70 
71         contractOwner = pendingContractOwner;
72         delete pendingContractOwner;
73 
74         return true;
75     }
76 }
77 
78 
79 contract ERC20Interface {
80     event Transfer(address indexed from, address indexed to, uint256 value);
81     event Approval(address indexed from, address indexed spender, uint256 value);
82     string public symbol;
83 
84     function totalSupply() constant returns (uint256 supply);
85     function balanceOf(address _owner) constant returns (uint256 balance);
86     function transfer(address _to, uint256 _value) returns (bool success);
87     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
88     function approve(address _spender, uint256 _value) returns (bool success);
89     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
90 }
91 
92 /**
93  * @title Generic owned destroyable contract
94  */
95 contract Object is Owned {
96     /**
97     *  Common result code. Means everything is fine.
98     */
99     uint constant OK = 1;
100     uint constant OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER = 8;
101 
102     function withdrawnTokens(address[] tokens, address _to) onlyContractOwner returns(uint) {
103         for(uint i=0;i<tokens.length;i++) {
104             address token = tokens[i];
105             uint balance = ERC20Interface(token).balanceOf(this);
106             if(balance != 0)
107                 ERC20Interface(token).transfer(_to,balance);
108         }
109         return OK;
110     }
111 
112     function checkOnlyContractOwner() internal constant returns(uint) {
113         if (contractOwner == msg.sender) {
114             return OK;
115         }
116 
117         return OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER;
118     }
119 }
120 
121 
122 /**
123  * @title General MultiEventsHistory user.
124  *
125  */
126 contract MultiEventsHistoryAdapter {
127 
128     /**
129     *   @dev It is address of MultiEventsHistory caller assuming we are inside of delegate call.
130     */
131     function _self() constant internal returns (address) {
132         return msg.sender;
133     }
134 }
135 
136 contract DelayedPaymentsEmitter is MultiEventsHistoryAdapter {
137         event Error(bytes32 message);
138 
139         function emitError(bytes32 _message) {
140            Error(_message);
141         }
142 }
143 
144 contract TeamVesting is Object {
145 
146     uint constant TIME_LOCK_SCOPE = 51000;
147     uint constant TIME_LOCK_TRANSFER_ERROR = TIME_LOCK_SCOPE + 10;
148     uint constant TIME_LOCK_TRANSFERFROM_ERROR = TIME_LOCK_SCOPE + 11;
149     uint constant TIME_LOCK_BALANCE_ERROR = TIME_LOCK_SCOPE + 12;
150     uint constant TIME_LOCK_TIMESTAMP_ERROR = TIME_LOCK_SCOPE + 13;
151     uint constant TIME_LOCK_INVALID_INVOCATION = TIME_LOCK_SCOPE + 17;
152 
153     // custom data structure to hold locked funds and time
154     struct accountData {
155         uint balance;
156         uint initDate;
157         uint lastSpending;
158     }
159 
160     // Should use interface of the emitter, but address of events history.
161     address public eventsHistory;
162 
163     address asset;
164 
165     accountData lock;
166 
167     function TeamVesting(address _asset) {
168         asset = _asset;
169     }
170 
171     /**
172      * Emits Error event with specified error message.
173      *
174      * Should only be used if no state changes happened.
175      *
176      * @param _errorCode code of an error
177      * @param _message error message.
178      */
179     function _error(uint _errorCode, bytes32 _message) internal returns(uint) {
180         DelayedPaymentsEmitter(eventsHistory).emitError(_message);
181         return _errorCode;
182     }
183 
184     /**
185      * Sets EventsHstory contract address.
186      *
187      * Can be set only once, and only by contract owner.
188      *
189      * @param _eventsHistory MultiEventsHistory contract address.
190      *
191      * @return success.
192      */
193     function setupEventsHistory(address _eventsHistory) returns(uint errorCode) {
194         errorCode = checkOnlyContractOwner();
195         if (errorCode != OK) {
196             return errorCode;
197         }
198         if (eventsHistory != 0x0 && eventsHistory != _eventsHistory) {
199             return TIME_LOCK_INVALID_INVOCATION;
200         }
201         eventsHistory = _eventsHistory;
202         return OK;
203     }
204 
205     function payIn() onlyContractOwner returns (uint errorCode) {
206         // send some amount (in Wei) when calling this function.
207         // the amount will then be placed in a locked account
208         // the funds will be released once the indicated lock time in seconds
209         // passed and can only be retrieved by the same account which was
210         // depositing them - highlighting the intrinsic security model
211         // offered by a blockchain system like Ethereum
212         uint amount = ERC20Interface(asset).balanceOf(this); 
213         if(lock.balance != 0) {
214             if(lock.balance != amount) {
215 				lock.balance == amount;
216 				return OK;
217             }
218             return TIME_LOCK_INVALID_INVOCATION;
219         }
220         if (amount == 0) {
221             return TIME_LOCK_BALANCE_ERROR;
222         }
223         lock = accountData(amount,now,0);
224         return OK;
225     }
226     
227     function payOut(address reciever) onlyContractOwner returns (uint errorCode) {
228         // check if user has funds due for pay out because lock time is over
229         uint amount = getVesting();
230         if(amount == 0) {
231             return TIME_LOCK_INVALID_INVOCATION;
232         }
233         if(!ERC20Interface(asset).transfer(reciever,amount)) {
234             return TIME_LOCK_TRANSFER_ERROR;
235         }
236         return OK;
237     }
238 
239     // used to calculate amount we are able to spend according to current timestamp 
240     function getVesting() returns (uint) {
241         uint amount;
242         for(uint i = 24; i >= 6;) {
243            uint date = 30 days * i;
244            if(now > (lock.initDate + date)) {
245               if(lock.lastSpending == i) {
246                  break;
247               }
248 		      if(lock.lastSpending == 0)
249               {
250                  amount = (lock.balance * 125 * (i/3)) / 1000;
251                  lock.lastSpending = i;
252                  break;
253               }
254               else {
255                  amount = ((lock.balance * 125 * (i/3)) / 1000) - ((lock.balance * 125 * (lock.lastSpending/3)) / 1000);
256                  lock.lastSpending = i;
257                  break;
258               }
259           }
260             i-=3;
261         }
262         return amount;   
263     }
264 
265     function getLockedFunds() constant returns (uint) {
266         return ERC20Interface(asset).balanceOf(this);
267     }
268     
269     function getLockedFundsLastSpending() constant returns (uint) {
270 	    return lock.lastSpending;
271     }
272 
273 }