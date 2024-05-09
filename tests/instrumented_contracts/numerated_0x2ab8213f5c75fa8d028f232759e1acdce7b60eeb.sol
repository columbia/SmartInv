1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title MultiSigStub  
5  * @author Ricardo Guilherme Schmidt (Status Research & Development GmbH)
6  * @dev Contract that delegates calls to a library to build a full MultiSigWallet that is cheap to create. 
7  */
8 contract MultiSigStub {
9 
10     address[] public owners;
11     address[] public tokens;
12     mapping (uint => Transaction) public transactions;
13     mapping (uint => mapping (address => bool)) public confirmations;
14     uint public transactionCount;
15 
16     struct Transaction {
17         address destination;
18         uint value;
19         bytes data;
20         bool executed;
21     }
22     
23     function MultiSigStub(address[] _owners, uint256 _required) {
24         //bytes4 sig = bytes4(sha3("constructor(address[],uint256)"));
25         bytes4 sig = 0x36756a23;
26         uint argarraysize = (2 + _owners.length);
27         uint argsize = (1 + argarraysize) * 32;
28         uint size = 4 + argsize;
29         bytes32 mData = _malloc(size);
30 
31         assembly {
32             mstore(mData, sig)
33             codecopy(add(mData, 0x4), sub(codesize, argsize), argsize)
34         }
35         _delegatecall(mData, size);
36     }
37     
38     modifier delegated {
39         uint size = msg.data.length;
40         bytes32 mData = _malloc(size);
41 
42         assembly {
43             calldatacopy(mData, 0x0, size)
44         }
45 
46         bytes32 mResult = _delegatecall(mData, size);
47         _;
48         assembly {
49             return(mResult, 0x20)
50         }
51     }
52     
53     function()
54         payable
55         delegated
56     {
57 
58     }
59 
60     function submitTransaction(address destination, uint value, bytes data)
61         public
62         delegated
63         returns (uint)
64     {
65         
66     }
67     
68     function confirmTransaction(uint transactionId)
69         public
70         delegated
71     {
72         
73     }
74     
75     function watch(address _tokenAddr)
76         public
77         delegated
78     {
79         
80     }
81     
82     function setMyTokenList(address[] _tokenList)  
83         public
84         delegated
85     {
86 
87     }
88     /// @dev Returns the confirmation status of a transaction.
89     /// @param transactionId Transaction ID.
90     /// @return Confirmation status.
91     function isConfirmed(uint transactionId)
92         public
93         constant
94         delegated
95         returns (bool)
96     {
97 
98     }
99     
100     /*
101     * Web3 call functions
102     */
103     function tokenBalances(address tokenAddress) 
104         public
105         constant 
106         delegated 
107         returns (uint)
108     {
109 
110     }
111 
112 
113     /// @dev Returns number of confirmations of a transaction.
114     /// @param transactionId Transaction ID.
115     /// @return Number of confirmations.
116     function getConfirmationCount(uint transactionId)
117         public
118         constant
119         delegated
120         returns (uint)
121     {
122 
123     }
124 
125     /// @dev Returns total number of transactions after filters are applied.
126     /// @param pending Include pending transactions.
127     /// @param executed Include executed transactions.
128     /// @return Total number of transactions after filters are applied.
129     function getTransactionCount(bool pending, bool executed)
130         public
131         constant
132         delegated
133         returns (uint)
134     {
135 
136     }
137 
138     /// @dev Returns list of owners.
139     /// @return List of owner addresses.
140     function getOwners()
141         public
142         constant
143         returns (address[])
144     {
145         return owners;
146     }
147 
148     /// @dev Returns list of tokens.
149     /// @return List of token addresses.
150     function getTokenList()
151         public
152         constant
153         returns (address[])
154     {
155         return tokens;
156     }
157 
158     /// @dev Returns array with owner addresses, which confirmed transaction.
159     /// @param transactionId Transaction ID.
160     /// @return Returns array of owner addresses.
161     function getConfirmations(uint transactionId)
162         public
163         constant
164         returns (address[] _confirmations)
165     {
166         address[] memory confirmationsTemp = new address[](owners.length);
167         uint count = 0;
168         uint i;
169         for (i = 0; i < owners.length; i++) {
170             if (confirmations[transactionId][owners[i]]) {
171                 confirmationsTemp[count] = owners[i];
172                 count += 1;
173             }
174         }
175         _confirmations = new address[](count);
176         for (i = 0; i < count; i++) {
177             _confirmations[i] = confirmationsTemp[i];
178         }
179     }
180 
181     /// @dev Returns list of transaction IDs in defined range.
182     /// @param from Index start position of transaction array.
183     /// @param to Index end position of transaction array.
184     /// @param pending Include pending transactions.
185     /// @param executed Include executed transactions.
186     /// @return Returns array of transaction IDs.
187     function getTransactionIds(uint from, uint to, bool pending, bool executed)
188         public
189         constant
190         returns (uint[] _transactionIds)
191     {
192         uint[] memory transactionIdsTemp = new uint[](transactionCount);
193         uint count = 0;
194         uint i;
195         for (i = 0; i < transactionCount; i++) {
196             if (pending && !transactions[i].executed || executed && transactions[i].executed) {
197                 transactionIdsTemp[count] = i;
198                 count += 1;
199             }
200         }
201         _transactionIds = new uint[](to - from);
202         for (i = from; i < to; i++) {
203             _transactionIds[i - from] = transactionIdsTemp[i];
204         }
205     }
206 
207 
208     function _malloc(uint size) 
209         private 
210         returns(bytes32 mData) 
211     {
212         assembly {
213             mData := mload(0x40)
214             mstore(0x40, add(mData, size))
215         }
216     }
217 
218     function _delegatecall(bytes32 mData, uint size) 
219         private 
220         returns(bytes32 mResult) 
221     {
222         address target = 0xc0FFeEE61948d8993864a73a099c0E38D887d3F4; //Multinetwork
223         mResult = _malloc(32);
224         bool failed;
225 
226         assembly {
227             failed := iszero(delegatecall(sub(gas, 10000), target, mData, size, mResult, 0x20))
228         }
229 
230         assert(!failed);
231     }
232     
233 }
234 
235 contract MultiSigFactory {
236     
237     event Create(address indexed caller, address createdContract);
238 
239     function create(address[] owners, uint256 required) returns (address wallet){
240         wallet = new MultiSigStub(owners, required); 
241         Create(msg.sender, wallet);
242     }
243     
244 }