1 pragma solidity ^0.4.12;
2 
3 contract Ownable {
4   address public owner;
5 
6   function Ownable() {
7     owner = msg.sender;
8   }
9 
10   modifier onlyOwner() {
11     if (msg.sender != owner) {
12       throw;
13     }
14     _;
15   }
16 
17   function transferOwnership(address newOwner) onlyOwner {
18     if (newOwner != address(0)) {
19       owner = newOwner;
20     }
21   }
22 
23 }
24 
25 contract SafeMath {
26   function safeMul(uint a, uint b) internal returns (uint) {
27     uint c = a * b;
28     assert(a == 0 || c / a == b);
29     return c;
30   }
31 
32   function safeDiv(uint a, uint b) internal returns (uint) {
33     assert(b > 0);
34     uint c = a / b;
35     assert(a == b * c + a % b);
36     return c;
37   }
38 
39   function safeSub(uint a, uint b) internal returns (uint) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   function safeAdd(uint a, uint b) internal returns (uint) {
45     uint c = a + b;
46     assert(c>=a && c>=b);
47     return c;
48   }
49 
50   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
51     return a >= b ? a : b;
52   }
53 
54   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
55     return a < b ? a : b;
56   }
57 
58   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
59     return a >= b ? a : b;
60   }
61 
62   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
63     return a < b ? a : b;
64   }
65 
66   function assert(bool assertion) internal {
67     if (!assertion) {
68       throw;
69     }
70   }
71 }
72 
73 contract ERC20 {
74   uint public totalSupply;
75   function balanceOf(address who) constant returns (uint);
76   function allowance(address owner, address spender) constant returns (uint);
77 
78   function transfer(address to, uint value) returns (bool ok);
79   function transferFrom(address from, address to, uint value) returns (bool ok);
80   function approve(address spender, uint value) returns (bool ok);
81   event Transfer(address indexed from, address indexed to, uint value);
82   event Approval(address indexed owner, address indexed spender, uint value);
83 }
84 
85 contract StandardToken is ERC20, SafeMath {
86 
87   mapping(address => uint) balances;
88   mapping (address => mapping (address => uint)) allowed;
89 
90   function transfer(address _to, uint _value) returns (bool success) {
91       
92     balances[msg.sender] = safeSub(balances[msg.sender], _value);
93     balances[_to] = safeAdd(balances[_to], _value);
94     Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
99     var _allowance = allowed[_from][msg.sender];
100 
101     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
102     // if (_value > _allowance) throw;
103     
104     balances[_to] = safeAdd(balances[_to], _value);
105     balances[_from] = safeSub(balances[_from], _value);
106     allowed[_from][msg.sender] = safeSub(_allowance, _value);
107     Transfer(_from, _to, _value);
108     return true;
109   }
110 
111   function balanceOf(address _owner) constant returns (uint balance) {
112     return balances[_owner];
113   }
114 
115   function approve(address _spender, uint _value) returns (bool success) {
116       
117     allowed[msg.sender][_spender] = _value;
118     Approval(msg.sender, _spender, _value);
119     return true;
120   }
121 
122   function allowance(address _owner, address _spender) constant returns (uint remaining) {
123     return allowed[_owner][_spender];
124   }
125 
126 }
127 
128 contract UBetCoin is Ownable, StandardToken {
129 
130     string public name = "UBetCoin";               // name of the token
131     string public symbol = "UBET";                 // ERC20 compliant 4 digit token code
132     uint public decimals = 2;                      // token has 2 digit precision
133 
134     uint256 public totalSupply =  400000000000;      // 4 BILLION INITIAL SUPPLY
135     uint256 public tokenSupplyFromCheck = 0;             // Total from check!
136     uint256 public tokenSupplyBackedByGold = 4000000000; // Supply Backed By Gold
137     
138     string public constant YOU_BET_MINE_DOCUMENT_PATH = "https://s3.amazonaws.com/s3-ubetcoin-user-signatures/document/GOLD-MINES-assigned+TO-SAINT-NICOLAS-SNADCO-03-22-2016.pdf";
139     string public constant YOU_BET_MINE_DOCUMENT_SHA512 = "7e9dc6362c5bf85ff19d75df9140b033c4121ba8aaef7e5837b276d657becf0a0d68fcf26b95e76023a33251ac94f35492f2f0af882af4b87b1b1b626b325cf8";
140     string public constant UBETCOIN_LEDGER_TO_LEDGER_ENTRY_DOCUMENT_PATH = "https://s3.amazonaws.com/s3-ubetcoin-user-signatures/document/LEDGER-TO-LEDGER+ENTRY-FOR-UBETCOIN+03-20-2018.pdf";
141     string public constant UBETCOIN_LEDGER_TO_LEDGER_ENTRY_DOCUMENT_SHA512 = "c8f0ae2602005dd88ef908624cf59f3956107d0890d67d3baf9c885b64544a8140e282366cae6a3af7bfbc96d17f856b55fc4960e2287d4a03d67e646e0e88c6";
142     
143     /// Base exchange rate is set
144     uint256 public ratePerOneEther = 962;
145     uint256 public totalUBetCheckAmounts = 0;
146 
147     /// Issue event index starting from 0.
148     uint64 public issueIndex = 0;
149 
150     /// Emitted for each sucuessful token purchase.
151     event Issue(uint64 issueIndex, address addr, uint256 tokenAmount);
152     
153     // All funds will be transferred in this wallet.
154     address public moneyWallet = 0xe5688167Cb7aBcE4355F63943aAaC8bb269dc953;
155 
156     /// Emitted for each UBETCHECKS register.
157     event UbetCheckIssue(string chequeIndex);
158       
159     struct UBetCheck {
160       string accountId;
161       string accountNumber;
162       string fullName;
163       string routingNumber;
164       string institution;
165       uint256 amount;
166       uint256 tokens;
167       string checkFilePath;
168       string digitalCheckFingerPrint;
169     }
170     
171     mapping (address => UBetCheck) UBetChecks;
172     address[] public uBetCheckAccts;
173     
174     
175     /// @dev Initializes the contract and allocates all initial tokens to the owner
176     function UBetCoin() {
177         balances[msg.sender] = totalSupply;
178     }
179   
180     //////////////// owner only functions below
181 
182     /// @dev To transfer token contract ownership
183     /// @param _newOwner The address of the new owner of this contract
184     function transferOwnership(address _newOwner) onlyOwner {
185         balances[_newOwner] = balances[owner];
186         balances[owner] = 0;
187         Ownable.transferOwnership(_newOwner);
188     }
189     
190     /// check functionality
191     
192     /// @dev Register UBetCheck to the chain
193     /// @param _beneficiary recipient ether address
194     /// @param _accountId the id generated from the db
195     /// @param _accountNumber the account number stated in the check
196     /// @param _routingNumber the routing number stated in the check
197     /// @param _institution the name of the institution / bank in the check
198     /// @param _fullname the name printed on the check
199     /// @param _amount the amount in currency in the chek
200     /// @param _checkFilePath the url path where the cheque has been uploaded
201     /// @param _digitalCheckFingerPrint the hash of the file
202     /// @param _tokens number of tokens issued to the beneficiary
203     function registerUBetCheck(address _beneficiary, string _accountId,  string _accountNumber, string _routingNumber, string _institution, string _fullname,  uint256 _amount, string _checkFilePath, string _digitalCheckFingerPrint, uint256 _tokens) public payable onlyOwner {
204       
205       require(_beneficiary != address(0));
206       require(bytes(_accountId).length != 0);
207       require(bytes(_accountNumber).length != 0);
208       require(bytes(_routingNumber).length != 0);
209       require(bytes(_institution).length != 0);
210       require(bytes(_fullname).length != 0);
211       require(_amount > 0);
212       require(_tokens > 0);
213       require(bytes(_checkFilePath).length != 0);
214       require(bytes(_digitalCheckFingerPrint).length != 0);
215       
216       var __conToken = _tokens * (10**(decimals));
217       
218       var uBetCheck = UBetChecks[_beneficiary];
219       
220       uBetCheck.accountId = _accountId;
221       uBetCheck.accountNumber = _accountNumber;
222       uBetCheck.routingNumber = _routingNumber;
223       uBetCheck.institution = _institution;
224       uBetCheck.fullName = _fullname;
225       uBetCheck.amount = _amount;
226       uBetCheck.tokens = _tokens;
227       
228       uBetCheck.checkFilePath = _checkFilePath;
229       uBetCheck.digitalCheckFingerPrint = _digitalCheckFingerPrint;
230       
231       totalUBetCheckAmounts = safeAdd(totalUBetCheckAmounts, _amount);
232       tokenSupplyFromCheck = safeAdd(tokenSupplyFromCheck, _tokens);
233       
234       uBetCheckAccts.push(_beneficiary) -1;
235       
236       // Issue token when registered UBetCheck is complete to the _beneficiary
237       doIssueTokens(_beneficiary, __conToken);
238       
239       // Fire Event UbetCheckIssue
240       UbetCheckIssue(_accountId);
241     }
242     
243     /// @dev List all the checks in the
244     function getUBetChecks() public returns (address[]) {
245       return uBetCheckAccts;
246     }
247     
248     /// @dev Return UBetCheck information by supplying beneficiary adddress
249     function getUBetCheck(address _address) public returns(string, string, string, string, uint256, string, string) {
250             
251       return (UBetChecks[_address].accountNumber,
252               UBetChecks[_address].routingNumber,
253               UBetChecks[_address].institution,
254               UBetChecks[_address].fullName,
255               UBetChecks[_address].amount,
256               UBetChecks[_address].checkFilePath,
257               UBetChecks[_address].digitalCheckFingerPrint);
258     }
259     
260     /// @dev This default function allows token to be purchased by directly
261     /// sending ether to this smart contract.
262     function () public payable {
263       purchaseTokens(msg.sender);
264     }
265 
266     /// @dev return total count of registered UBet Checks
267     function countUBetChecks() public returns (uint) {
268         return uBetCheckAccts.length;
269     }
270     
271 
272     /// @dev issue tokens for a single buyer
273     /// @param _beneficiary addresses that the tokens will be sent to.
274     /// @param _tokens the amount of tokens, with decimals expanded (full).
275     function doIssueTokens(address _beneficiary, uint256 _tokens) internal {
276       require(_beneficiary != address(0));    
277 
278       // compute without actually increasing it
279       uint256 increasedTotalSupply = safeAdd(totalSupply, _tokens);
280       
281       // increase token total supply
282       totalSupply = increasedTotalSupply;
283       // update the beneficiary balance to number of tokens sent
284       balances[_beneficiary] = safeAdd(balances[_beneficiary], _tokens);
285       
286       Transfer(msg.sender, _beneficiary, _tokens);
287     
288       // event is fired when tokens issued
289       Issue(
290           issueIndex++,
291           _beneficiary,
292           _tokens
293       );
294     }
295     
296     /// @dev Issue token based on Ether received.
297     /// @param _beneficiary Address that newly issued token will be sent to.
298     function purchaseTokens(address _beneficiary) public payable {
299       // only accept a minimum amount of ETH?
300       require(msg.value >= 0.00104 ether);
301      
302       uint _tokens = safeDiv(safeMul(msg.value, ratePerOneEther), (10**(18-decimals)));
303       doIssueTokens(_beneficiary, _tokens);
304 
305       /// forward the money to the money wallet
306       moneyWallet.transfer(this.balance);
307     }
308     
309     
310     /// @dev Change money wallet owner
311     /// @param _address new address to received the ether
312     function setMoneyWallet(address _address) public onlyOwner {
313         moneyWallet = _address;
314     }
315     
316     /// @dev Change Rate per token in one ether
317     /// @param _value the amount of tokens, with decimals expanded (full).
318     function setRatePerOneEther(uint256 _value) public onlyOwner {
319       require(_value >= 1);
320       ratePerOneEther = _value;
321     }
322     
323 }