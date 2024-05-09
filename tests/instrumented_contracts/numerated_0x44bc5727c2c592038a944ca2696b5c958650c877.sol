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
79 
80 contract ERC20Interface {
81     event Transfer(address indexed from, address indexed to, uint256 value);
82     event Approval(address indexed from, address indexed spender, uint256 value);
83     string public symbol;
84 
85     function totalSupply() constant returns (uint256 supply);
86     function balanceOf(address _owner) constant returns (uint256 balance);
87     function transfer(address _to, uint256 _value) returns (bool success);
88     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
89     function approve(address _spender, uint256 _value) returns (bool success);
90     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
91 }
92 
93 
94 /**
95  * @title Generic owned destroyable contract
96  */
97 contract Object is Owned {
98     /**
99     *  Common result code. Means everything is fine.
100     */
101     uint constant OK = 1;
102     uint constant OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER = 8;
103 
104     function withdrawnTokens(address[] tokens, address _to) onlyContractOwner returns(uint) {
105         for(uint i=0;i<tokens.length;i++) {
106             address token = tokens[i];
107             uint balance = ERC20Interface(token).balanceOf(this);
108             if(balance != 0)
109                 ERC20Interface(token).transfer(_to,balance);
110         }
111         return OK;
112     }
113 
114     function checkOnlyContractOwner() internal constant returns(uint) {
115         if (contractOwner == msg.sender) {
116             return OK;
117         }
118 
119         return OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER;
120     }
121 }
122 
123 
124 
125 //import "../contracts/ContractsManagerInterface.sol";
126 
127 /**
128  * @title General MultiEventsHistory user.
129  *
130  */
131 contract MultiEventsHistoryAdapter {
132 
133     /**
134     *   @dev It is address of MultiEventsHistory caller assuming we are inside of delegate call.
135     */
136     function _self() constant internal returns (address) {
137         return msg.sender;
138     }
139 }
140 
141 
142 contract DelayedPaymentsEmitter is MultiEventsHistoryAdapter {
143         event Error(bytes32 message);
144 
145         function emitError(bytes32 _message) {
146            Error(_message);
147         }
148 }
149 
150 contract Lockup6m_20180801 is Object {
151 
152     uint constant TIME_LOCK_SCOPE = 51000;
153     uint constant TIME_LOCK_TRANSFER_ERROR = TIME_LOCK_SCOPE + 10;
154     uint constant TIME_LOCK_TRANSFERFROM_ERROR = TIME_LOCK_SCOPE + 11;
155     uint constant TIME_LOCK_BALANCE_ERROR = TIME_LOCK_SCOPE + 12;
156     uint constant TIME_LOCK_TIMESTAMP_ERROR = TIME_LOCK_SCOPE + 13;
157     uint constant TIME_LOCK_INVALID_INVOCATION = TIME_LOCK_SCOPE + 17;
158 
159 
160     // custom data structure to hold locked funds and time
161     struct accountData {
162         uint balance;
163         uint releaseTime;
164     }
165 
166     // Should use interface of the emitter, but address of events history.
167     address public eventsHistory;
168 
169     address asset;
170 
171     accountData lock;
172 
173     function Lockup6m_20180801(address _asset) {
174         asset = _asset;
175     }
176 
177     /**
178      * Emits Error event with specified error message.
179      *
180      * Should only be used if no state changes happened.
181      *
182      * @param _errorCode code of an error
183      * @param _message error message.
184      */
185     function _error(uint _errorCode, bytes32 _message) internal returns(uint) {
186         DelayedPaymentsEmitter(eventsHistory).emitError(_message);
187         return _errorCode;
188     }
189 
190     /**
191      * Sets EventsHstory contract address.
192      *
193      * Can be set only once, and only by contract owner.
194      *
195      * @param _eventsHistory MultiEventsHistory contract address.
196      *
197      * @return success.
198      */
199     function setupEventsHistory(address _eventsHistory) returns(uint errorCode) {
200         errorCode = checkOnlyContractOwner();
201         if (errorCode != OK) {
202             return errorCode;
203         }
204         if (eventsHistory != 0x0 && eventsHistory != _eventsHistory) {
205             return TIME_LOCK_INVALID_INVOCATION;
206         }
207         eventsHistory = _eventsHistory;
208         return OK;
209     }
210 
211     function payIn() onlyContractOwner returns(uint errorCode) {
212         // send some amount (in Wei) when calling this function.
213         // the amount will then be placed in a locked account
214         // the funds will be released once the indicated lock time in seconds
215         // passed and can only be retrieved by the same account which was
216         // depositing them - highlighting the intrinsic security model
217         // offered by a blockchain system like Ethereum
218         uint amount = ERC20Interface(asset).balanceOf(this);
219         if(lock.balance != 0) {
220             if(lock.balance != amount) {
221                 lock.balance = amount;
222                 return OK;
223             }
224             return TIME_LOCK_INVALID_INVOCATION;
225         }
226         if (amount == 0) {
227             return TIME_LOCK_BALANCE_ERROR;
228         }
229         //1533081600 => 2018-08-01
230         lock = accountData(amount, 1533081600);
231         return OK;
232     }
233 
234     function payOut(address _getter) onlyContractOwner returns(uint errorCode) {
235         // check if user has funds due for pay out because lock time is over
236         uint amount = lock.balance;
237         if (now < lock.releaseTime) {
238             return TIME_LOCK_TIMESTAMP_ERROR;
239         }
240         if (amount == 0) {
241             return TIME_LOCK_BALANCE_ERROR;
242         }
243         if(!ERC20Interface(asset).transfer(_getter,amount)) {
244             return TIME_LOCK_TRANSFER_ERROR;
245         } 
246         selfdestruct(msg.sender);     
247         return OK;
248     }
249 
250     function getLockedFunds() constant returns (uint) {
251         return lock.balance;
252     }
253     
254     function getLockedFundsReleaseTime() constant returns (uint) {
255 	    return lock.releaseTime;
256     }
257 
258 }