1 pragma solidity ^0.4.11;
2 
3 contract Multisig {
4   event Deposit(address _from, uint value);
5   event SingleTransact(address owner, uint value, address to, bytes data);
6   event MultiTransact(address owner, bytes32 operation, uint value, address to, bytes data);
7   event ConfirmationNeeded(bytes32 operation, address initiator, uint value, address to, bytes data);
8   function changeOwner(address _from, address _to) external;
9   function execute(address _to, uint _value, bytes _data) external returns (bytes32);
10   function confirm(bytes32 _h) returns (bool);
11 }
12 
13 
14 contract Shareable {
15   struct PendingState {
16     uint yetNeeded;
17     uint ownersDone;
18     uint index;
19   }
20   uint public required;
21   address[256] owners;
22   mapping(address => uint) ownerIndex;
23   mapping(bytes32 => PendingState) pendings;
24   bytes32[] pendingsIndex;
25   event Confirmation(address owner, bytes32 operation);
26   event Revoke(address owner, bytes32 operation);
27   modifier onlyOwner {
28     if (!isOwner(msg.sender)) {
29       throw;
30     }
31     _;
32   }
33   modifier onlymanyowners(bytes32 _operation) {
34     if (confirmAndCheck(_operation)) {
35       _;
36     }
37   }
38   function Shareable(address[] _owners, uint _required) {
39     owners[1] = msg.sender;
40     ownerIndex[msg.sender] = 1;
41     for (uint i = 0; i < _owners.length; ++i) {
42       owners[2 + i] = _owners[i];
43       ownerIndex[_owners[i]] = 2 + i;
44     }
45     required = _required;
46     if (required > owners.length) {
47       throw;
48     }
49   }
50   function revoke(bytes32 _operation) external {
51     uint index = ownerIndex[msg.sender];
52     if (index == 0) {
53       return;
54     }
55     uint ownerIndexBit = 2**index;
56     var pending = pendings[_operation];
57     if (pending.ownersDone & ownerIndexBit > 0) {
58       pending.yetNeeded++;
59       pending.ownersDone -= ownerIndexBit;
60       Revoke(msg.sender, _operation);
61     }
62   }
63   function getOwner(uint ownerIndex) external constant returns (address) {
64     return address(owners[ownerIndex + 1]);
65   }
66   function isOwner(address _addr) constant returns (bool) {
67     return ownerIndex[_addr] > 0;
68   }
69   function hasConfirmed(bytes32 _operation, address _owner) constant returns (bool) {
70     var pending = pendings[_operation];
71     uint index = ownerIndex[_owner];
72     if (index == 0) {
73       return false;
74     }
75     uint ownerIndexBit = 2**index;
76     return !(pending.ownersDone & ownerIndexBit == 0);
77   }
78   function confirmAndCheck(bytes32 _operation) internal returns (bool) {
79     uint index = ownerIndex[msg.sender];
80     if (index == 0) {
81       throw;
82     }
83 
84     var pending = pendings[_operation];
85     if (pending.yetNeeded == 0) {
86       pending.yetNeeded = required;
87       pending.ownersDone = 0;
88       pending.index = pendingsIndex.length++;
89       pendingsIndex[pending.index] = _operation;
90     }
91     uint ownerIndexBit = 2**index;
92     if (pending.ownersDone & ownerIndexBit == 0) {
93       Confirmation(msg.sender, _operation);
94       if (pending.yetNeeded <= 1) {
95         delete pendingsIndex[pendings[_operation].index];
96         delete pendings[_operation];
97         return true;
98       } else {
99         pending.yetNeeded--;
100         pending.ownersDone |= ownerIndexBit;
101       }
102     }
103     return false;
104   }
105   function clearPending() internal {
106     uint length = pendingsIndex.length;
107     for (uint i = 0; i < length; ++i) {
108       if (pendingsIndex[i] != 0) {
109         delete pendings[pendingsIndex[i]];
110       }
111     }
112     delete pendingsIndex;
113   }
114 
115 }
116 
117 
118 contract DayLimit {
119 
120   uint public dailyLimit;
121   uint public spentToday;
122   uint public lastDay;
123   function DayLimit(uint _limit) {
124     dailyLimit = _limit;
125     lastDay = today();
126   }
127   function _setDailyLimit(uint _newLimit) internal {
128     dailyLimit = _newLimit;
129   }
130   function _resetSpentToday() internal {
131     spentToday = 0;
132   }
133   function underLimit(uint _value) internal returns (bool) {
134     if (today() > lastDay) {
135       spentToday = 0;
136       lastDay = today();
137     }
138     if (spentToday + _value >= spentToday && spentToday + _value <= dailyLimit) {
139       spentToday += _value;
140       return true;
141     }
142     return false;
143   }
144   function today() private constant returns (uint) {
145     return now / 1 days;
146   }
147   modifier limitedDaily(uint _value) {
148     if (!underLimit(_value)) {
149       throw;
150     }
151     _;
152   }
153 }
154 
155 
156 
157 contract MultisigWalletZeppelin is Multisig, Shareable, DayLimit {
158 
159   struct Transaction {
160     address to;
161     uint value;
162     bytes data;
163   }
164   function MultisigWalletZeppelin(address[] _owners, uint _required, uint _daylimit)       
165     Shareable(_owners, _required)        
166     DayLimit(_daylimit) { 
167     }
168   function destroy(address _to) onlymanyowners(keccak256(msg.data)) external {
169     selfdestruct(_to);
170   }
171   function() payable {
172     if (msg.value > 0)
173       Deposit(msg.sender, msg.value);
174   }
175   function execute(address _to, uint _value, bytes _data) external onlyOwner returns (bytes32 _r) {
176     if (underLimit(_value)) {
177       SingleTransact(msg.sender, _value, _to, _data);
178       if (!_to.call.value(_value)(_data)) {
179         throw;
180       }
181       return 0;
182     }
183     _r = keccak256(msg.data, block.number);
184     if (!confirm(_r) && txs[_r].to == 0) {
185       txs[_r].to = _to;
186       txs[_r].value = _value;
187       txs[_r].data = _data;
188       ConfirmationNeeded(_r, msg.sender, _value, _to, _data);
189     }
190   }
191   function confirm(bytes32 _h) onlymanyowners(_h) returns (bool) {
192     if (txs[_h].to != 0) {
193       if (!txs[_h].to.call.value(txs[_h].value)(txs[_h].data)) {
194         throw;
195       }
196       MultiTransact(msg.sender, _h, txs[_h].value, txs[_h].to, txs[_h].data);
197       delete txs[_h];
198       return true;
199     }
200   }
201   function setDailyLimit(uint _newLimit) onlymanyowners(keccak256(msg.data)) external {
202     _setDailyLimit(_newLimit);
203   }
204   function resetSpentToday() onlymanyowners(keccak256(msg.data)) external {
205     _resetSpentToday();
206   }
207   function clearPending() internal {
208     uint length = pendingsIndex.length;
209     for (uint i = 0; i < length; ++i) {
210       delete txs[pendingsIndex[i]];
211     }
212     super.clearPending();
213   }
214   mapping (bytes32 => Transaction) txs;
215 }
216 
217 
218 contract MultisigWallet is MultisigWalletZeppelin {
219   uint public totalSpending;
220 
221   function MultisigWallet(address[] _owners, uint _required, uint _daylimit)
222     MultisigWalletZeppelin(_owners, _required, _daylimit) payable { }
223 
224   function changeOwner(address _from, address _to) external { }
225 
226 }