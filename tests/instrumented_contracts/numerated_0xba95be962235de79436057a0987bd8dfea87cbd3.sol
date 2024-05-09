1 // Multi-signature wallet for easily transfers of ETH and ERC20 tokens
2 // Developed by Phenom.Team <info@phenom.team>
3 pragma solidity ^0.4.24;
4 
5 /**
6  *   @title ERC20
7  *   @dev Standart ERC20 token interface
8  */
9 
10  /**
11  * @title Ownable
12  * @dev The Ownable contract has an owner address, and provides basic authorization control
13  * functions, this simplifies the implementation of "user permissions".
14  */
15 contract Ownable {
16     address public owner;
17 
18 
19     event OwnershipRenounced(address indexed previousOwner);
20     event OwnershipTransferred(
21         address indexed previousOwner,
22         address indexed newOwner
23     );
24 
25 
26       /**
27        * @dev The Ownable constructor sets the original `owner` of the contract to the sender
28        * account.
29        */
30     constructor() public {
31         owner = msg.sender;
32     }
33 
34       /**
35        * @dev Throws if called by any account other than the owner.
36        */
37     modifier onlyOwner() {
38         require(msg.sender == owner, "msg.sender is not Owner");
39         _;
40     }
41 
42       /**
43        * @dev Allows the current owner to transfer control of the contract to a newOwner.
44        * @param newOwner The address to transfer ownership to.
45        */
46     function transferOwnership(address newOwner) public onlyOwner {
47         require(newOwner != address(0), "Owner must not be zero-address");
48         emit OwnershipTransferred(owner, newOwner);
49         owner = newOwner;
50     }
51 
52       /**
53        * @dev Allows the current owner to relinquish control of the contract.
54        */
55     function renounceOwnership() public onlyOwner {
56         emit OwnershipRenounced(owner);
57         owner = address(0);
58     }
59 }
60 
61 contract ERC20 {
62     uint public totalSupply;
63 
64     mapping(address => uint) balances;
65     mapping(address => mapping (address => uint)) allowed;
66 
67     function balanceOf(address _owner) public view returns (uint);
68     function transfer(address _to, uint _value) public returns (bool);
69     function transferFrom(address _from, address _to, uint _value) public returns (bool);
70     function approve(address _spender, uint _value) public  returns (bool);
71     function allowance(address _owner, address _spender) public view returns (uint);
72 
73     event Transfer(address indexed _from, address indexed _to, uint _value);
74     event Approval(address indexed _owner, address indexed _spender, uint _value);
75 
76 } 
77 
78 /// @title Multisignature wallet
79 contract MultiSigWallet {
80 
81     //Events
82     event TransactionCreated(uint indexed _txId, uint indexed _timestamp, address indexed _creator);
83     event TranscationSended(uint indexed _txId, uint indexed _timestamp);
84     event TranscationSigned(uint indexed _txId, uint indexed _timestamp, address indexed _signer);
85     event TranscationUnsigned(uint indexed _txId, uint indexed _timestamp, address indexed _signer);
86     event Deposit(uint _amount, address indexed _sender);
87     
88     //Trunsaction struct
89     struct Transcation {
90         address to;
91         address tokenAddress; // if tx is ether transfer  token address equals address(0) 
92         uint amount;
93         uint confirmations;
94         bool done;
95         mapping (address => bool) confirmed;
96     }
97 
98     //adresses of signers
99     address[] public signers;
100     
101     //numbers of signs to perform tx
102     uint public requiredConfirmations;
103     
104     //trancations count
105     uint public txCount;
106     
107     //mappings
108     mapping (uint => Transcation) public transactions; // trancations
109     mapping (address => bool) isSigner; // signers
110 
111     // name of the wallet
112     string public name;
113     
114 
115     modifier onlySigners {
116         require(isSigner[msg.sender], "msg.sender is not Signer");
117         _;
118     } 
119 
120     
121    /**
122     *   @dev Contract constructor sets signers list, required number of confirmations and name of the wallet.
123     *   @param _signers                     signers list
124     *   @param _requiredConfirmations       required number of confirmations
125     *   @param _name                        name of the wallet
126     */
127     constructor(
128         address[] _signers, 
129         uint _requiredConfirmations,
130         string _name
131     ) 
132     public {
133         require( 
134             _requiredConfirmations <= _signers.length && 
135             _requiredConfirmations > 0,
136             "required confirmations must be > 0 and less than number of signers"
137         );
138         requiredConfirmations = _requiredConfirmations;
139         for (uint i = 0; i < _signers.length; i++) {
140             signers.push(_signers[i]);
141             isSigner[_signers[i]] = true;
142         }
143         name = _name;
144     }
145 
146    /**
147     *   @dev Fallback function
148     */
149     function() public payable {
150         require(msg.value > 0, "value must be > 0");
151         emit Deposit(msg.value, msg.sender);
152     }
153     
154     function getSigners() public view returns (address[]) {
155         return signers;
156     }
157 
158    /**
159     *   @dev Allows to create a new transaction
160     */
161     function createTransaction(
162         address _to, 
163         address _tokenAddress,
164         uint _amount
165     ) 
166     public 
167     onlySigners {
168         txCount++;
169         transactions[txCount] = Transcation(
170             _to,
171             _tokenAddress,
172             _amount,
173             0,
174             false
175         );
176         emit TransactionCreated(txCount, now, msg.sender);
177         signTransaction(txCount);
178     }
179 
180    /**
181     *   @dev Allows to sign a transaction
182     */
183     function signTransaction(uint _txId) public  onlySigners {
184         require(!transactions[_txId].confirmed[msg.sender] && _txId <= txCount, "must be a valid unsigned tx");
185         transactions[_txId].confirmed[msg.sender] = true;
186         transactions[_txId].confirmations++;
187         emit TranscationSigned(_txId, now, msg.sender);
188         if (transactions[_txId].confirmations >= requiredConfirmations) {
189             _sendTransaction(_txId);
190       }
191     }
192     
193     function getTransactionsId(
194         bool _pending, 
195         bool _done,
196         bool _tokenTransfers,
197         bool _etherTransfers, 
198         uint _tailSize
199     ) 
200     public 
201     view returns(uint[] _txIdList) {
202         uint[] memory tempList = new uint[](txCount);
203         uint count = 0;
204         uint id = txCount;
205         while(id > 0 && count < _tailSize) {
206             if ((_pending && !transactions[id].done || _done && transactions[id].done) && 
207                 (_tokenTransfers && transactions[id].tokenAddress != address(0) || 
208                  _etherTransfers && transactions[id].tokenAddress == address(0))
209                 ) 
210                 {
211                 tempList[count] = id;
212                 count++;
213                 }
214             id--;
215         }
216         _txIdList = new uint[](count);
217         for (uint i = 0; i < count; i++) {
218             _txIdList[i] = tempList[i];
219         }
220     }
221 
222     /*
223     *   @dev Allows to check whether tx is signed by signer
224     */
225     function isSigned(uint _txId, address _signer) 
226         public
227         view
228         returns (bool _isSigned) 
229     {
230         _isSigned = transactions[_txId].confirmed[_signer];
231     }
232     
233     function unsignTransaction(uint _txId) external onlySigners {
234         require(
235             transactions[_txId].confirmed[msg.sender] && 
236             !transactions[_txId].done,
237             "must be a valid signed tx"
238         );
239         transactions[_txId].confirmed[msg.sender] = false;
240         transactions[_txId].confirmations--;
241         emit TranscationUnsigned(_txId, now, msg.sender);
242     }
243 
244     //executing tx
245     function _sendTransaction(uint _txId) private {
246         require(!transactions[_txId].done, "transaction must not be done");
247         transactions[_txId].done = true;
248         if ( transactions[_txId].tokenAddress == address(0)) {
249             transactions[_txId].to.transfer(transactions[_txId].amount);
250         } else {
251             ERC20 token = ERC20(transactions[_txId].tokenAddress);
252             require(token.transfer(transactions[_txId].to, transactions[_txId].amount), "token transfer failded");
253         }
254         emit TranscationSended(_txId, now);
255     }
256 
257 }
258 
259 
260 /// @title Multisignature wallet factory
261 contract MultiSigWalletCreator is Ownable() {
262 
263     // wallets
264     mapping(address => bool) public isMultiSigWallet;
265 
266     mapping(address => address[]) public wallets;
267 
268     mapping(address => uint) public numberOfWallets;
269 
270     // information about system
271     string public currentSystemInfo;
272 
273     event walletCreated(address indexed _creator, address indexed _wallet);
274 
275     function createMultiSigWallet(
276         address[] _signers, 
277         uint _requiredConfirmations,
278         string _name
279         )
280         public
281         returns (address wallet)
282     {
283         wallet = new MultiSigWallet(_signers, _requiredConfirmations, _name);
284         isMultiSigWallet[wallet] = true;    
285         for (uint i = 0; i < _signers.length; i++) {
286             wallets[_signers[i]].push(wallet);
287             numberOfWallets[_signers[i]]++;
288         }
289         emit walletCreated(msg.sender, wallet);
290     }
291 
292     function setCurrentSystemInfo(string _info) public onlyOwner {
293         currentSystemInfo = _info;
294     }
295 }