1 pragma solidity ^0.4.8;
2 
3 
4 // 'interface':
5 //  this is expected from another contract,
6 //  where tokens (ERC20) are managed
7 contract Erc20TokensContract {
8     function transfer(address _to, uint256 _value);
9     // returns (bool success); // not in CoinOffering Corporation.sol
10     function balanceOf(address acc) returns (uint);
11 }
12 
13 
14 contract ICO {
15 
16     Erc20TokensContract erc20TokensContract;
17 
18     address public erc20TokensContractAddress;
19 
20     bool erc20TokensContractSet = false;
21 
22     // address public erc20TokensContractAddress;
23     // bool erc20TokensContractAddressSet = false;
24 
25     uint public priceToBuyInFinney; // price in finney (0.001 ETH)
26     uint priceToBuyInWei; // --> to reduce gas in buyTokens
27 
28     address public owner;
29 
30     mapping (address => bool) public isManager; // holds managers
31 
32     // for price chart:
33     mapping (uint => uint[3]) public priceChange;
34     // number of change => [priceToBuyInFinney, block.number, block.timestamp]
35     uint public currentPriceChangeNumber = 0;
36 
37     // for deals chart:
38     mapping (uint => uint[4]) public deals;
39     // number of change => [priceInFinney, quantity, block.number, block.timestamp]
40     uint public dealsNumber = 0;
41 
42     /* ---- Creates contract */
43     function ICO() {// - truffle compiles only no args Constructor
44         owner = msg.sender;
45         isManager[msg.sender] = true;
46         priceToBuyInFinney = 0;
47         // with price 0 tokens sale stopped
48         priceToBuyInWei = finneyToWei(priceToBuyInFinney);
49         priceChange[0] = [priceToBuyInFinney, block.number, block.timestamp];
50     }
51 
52     function setErc20TokensContract(address _erc20TokensContractAddress) returns (bool){
53         if (msg.sender != owner) {throw;}
54         if (erc20TokensContractSet) {throw;}
55         erc20TokensContract = Erc20TokensContract(_erc20TokensContractAddress);
56         erc20TokensContractAddress = _erc20TokensContractAddress;
57         erc20TokensContractSet = true;
58         TokensContractAddressSet(_erc20TokensContractAddress, msg.sender);
59         return true;
60     }
61 
62     event TokensContractAddressSet(address tokensContractAddress, address setBy);
63 
64     /* ------- Utilities:  */
65     //    function weiToEther(uint _wei) internal returns (uint){
66     //        return _wei / 1000000000000000000;
67     //    }
68     //
69     //    function etherToWei(uint _ether) internal returns (uint){
70     //        return _ether * 1000000000000000000;
71     //    }
72 
73     function weiToFinney(uint _wei) internal returns (uint){
74         return _wei / (1000000000000000000 * 1000);
75     }
76 
77     function finneyToWei(uint _finney) internal returns (uint){
78         return _finney * (1000000000000000000 / 1000);
79     }
80 
81     /* --- universal Event */
82     event Result(address transactionInitiatedBy, string message);
83 
84     /* administrative functions */
85     // change owner:
86     function changeOwner(address _newOwner) returns (bool){
87         if (msg.sender != owner) {throw;}
88         owner = _newOwner;
89         isManager[_newOwner] = true;
90         OwnerChanged(msg.sender, owner);
91         return true;
92     }
93 
94     event OwnerChanged(address oldOwner, address newOwner);
95 
96     // --- set managers
97     function setManager(address _newManager) returns (bool){
98         if (msg.sender == owner) {
99             isManager[_newManager] = true;
100             ManagersChanged("manager added", _newManager);
101             return true;
102         }
103         else throw;
104     }
105 
106     // remove managers
107     function removeManager(address _manager) returns (bool){
108         if (msg.sender == owner) {
109             isManager[_manager] = false;
110             ManagersChanged("manager removed", _manager);
111             return true;
112         }
113         else throw;
114     }
115 
116     event ManagersChanged(string change, address manager);
117 
118     // set new price for tokens:
119     function setNewPriceInFinney(uint _priceToBuyInFinney) returns (bool){
120 
121         if (msg.sender != owner || !isManager[msg.sender]) {throw;}
122 
123         priceToBuyInFinney = _priceToBuyInFinney;
124         priceToBuyInWei = finneyToWei(priceToBuyInFinney);
125         currentPriceChangeNumber++;
126         priceChange[currentPriceChangeNumber] = [priceToBuyInFinney, block.number, block.timestamp];
127         PriceChanged(priceToBuyInFinney, msg.sender);
128         return true;
129     }
130 
131     event PriceChanged(uint newPriceToBuyInFinney, address changedBy);
132 
133     function getPriceChange(uint _index) constant returns (uint[3]){
134         return priceChange[_index];
135         // array
136     }
137 
138     // ---- buy tokens:
139     // if you get message:
140     // "It seems this transaction will fail. If you submit it, it may consume
141     // all the gas you send",
142     // or
143     // "The contract won't allow this transaction to be executed"
144     // that may be means that price has changed, just wait a few minutes
145     // and repeat transaction
146     function buyTokens(uint _quantity, uint _priceToBuyInFinney) payable returns (bool){
147 
148         if (priceToBuyInFinney <= 0) {throw;}
149         // if priceToBuy == 0 selling stops;
150 
151         // if (_priceToBuyInFinney <= 0) {throw;}
152         // if (_quantity <= 0) {throw;}
153 
154         if (priceToBuyInFinney != _priceToBuyInFinney) {
155             //    Result(msg.sender, "transaction failed: price already changed");
156             throw;
157         }
158 
159         if (
160         (msg.value / priceToBuyInWei) != _quantity
161         ) {
162             // Result(msg.sender, "provided sum is not correct for this amount of tokens");
163             throw;
164         }
165         // if everything is O.K. make transfer (~ 37046 gas):
166         // check balance in token contract:
167         uint currentBalance = erc20TokensContract.balanceOf(this);
168         if (erc20TokensContract.balanceOf(this) < _quantity) {throw;}
169         else {
170             // make transfer
171             erc20TokensContract.transfer(msg.sender, _quantity);
172             // check if tx changed erc20TokensContract:
173             if (currentBalance == erc20TokensContract.balanceOf(this)) {
174                 throw;
175             }
176             // record this :
177             dealsNumber = dealsNumber + 1;
178             deals[dealsNumber] = [_priceToBuyInFinney, _quantity, block.number, block.timestamp];
179             // event
180             Deal(msg.sender, _priceToBuyInFinney, _quantity);
181             return true;
182         }
183     }
184 
185     // event BuyTokensError(address transactionFrom, string error); // if throw - no events
186 
187     event Deal(address to, uint priceInFinney, uint quantity);
188 
189     function transferTokensTo(address _to, uint _quantity) returns (bool) {
190 
191         if (msg.sender != owner) {throw;}
192         if (_quantity <= 0) {throw;}
193 
194         // check balance in token contract:
195         if (erc20TokensContract.balanceOf(this) < _quantity) {
196             throw;
197 
198         }
199         else {
200             // make transfer
201             erc20TokensContract.transfer(_to, _quantity);
202             // event:
203             TokensTransfer(msg.sender, _to, _quantity);
204             return true;
205         }
206     }
207 
208     function transferAllTokensToOwner() returns (bool) {
209         return transferTokensTo(owner, erc20TokensContract.balanceOf(this));
210     }
211 
212     event TokensTransfer (address from, address to, uint quantity);
213 
214     function transferTokensToContractOwner(uint _quantity) returns (bool) {
215         return transferTokensTo(msg.sender, _quantity);
216     }
217 
218     /* --- functions for ETH */
219     function withdraw(uint _sumToWithdrawInFinney) returns (bool) {
220         if (msg.sender != owner) {throw;}
221         if (_sumToWithdrawInFinney <= 0) {throw;}
222         if (this.balance < finneyToWei(_sumToWithdrawInFinney)) {
223             throw;
224         }
225 
226         if (msg.sender == owner) {// double check
227 
228             if (!msg.sender.send(finneyToWei(_sumToWithdrawInFinney))) {// makes withdrawal and returns true or false
229                 //  Withdrawal(msg.sender, _sumToWithdrawInFinney, "withdrawal: failed");
230                 return false;
231             }
232             else {
233                 Withdrawal(msg.sender, _sumToWithdrawInFinney, "withdrawal: success");
234                 return true;
235             }
236         }
237     }
238 
239     function withdrawAllToOwner() returns (bool) {
240         return withdraw(this.balance);
241     }
242 
243     event Withdrawal(address to, uint sumToWithdrawInFinney, string message);
244 
245 }