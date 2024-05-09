1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // 'UBETCOINS' token contract
5 //
6 // Symbol      : UBETS
7 // Name        : UBET COINS
8 // Total supply: 4000000000
9 // Decimals    : 18
10 //
11 // ----------------------------------------------------------------------------
12 
13 
14 contract Ownable {
15   address public owner;
16 
17   function Ownable() public{
18     owner = msg.sender;
19   }
20 
21   modifier onlyOwner() {
22     if (msg.sender != owner) {
23       revert();
24     }
25     _;
26   }
27 
28   function transferOwnership(address newOwner) onlyOwner public{
29     if (newOwner != address(0)) {
30       owner = newOwner;
31     }
32   }
33 
34 }
35 
36 contract SafeMath {
37   function safeMul(uint a, uint b) pure internal returns (uint) {
38     uint c = a * b;
39     assert(a == 0 || c / a == b);
40     return c;
41   }
42 
43   function safeDiv(uint a, uint b) pure internal returns (uint) {
44     assert(b > 0);
45     uint c = a / b;
46     assert(a == b * c + a % b);
47     return c;
48   }
49 
50   function safeSub(uint a, uint b) pure internal returns (uint) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   function safeAdd(uint a, uint b) pure internal returns (uint) {
56     uint c = a + b;
57     assert(c>=a && c>=b);
58     return c;
59   }
60 }
61 
62 contract ERC20 {
63   uint public totalSupply;
64   function balanceOf(address who) public constant returns (uint);
65   function allowance(address owner, address spender) public constant returns (uint);
66 
67   function transfer(address to, uint value) public returns (bool ok);
68   function transferFrom(address from, address to, uint value) public returns (bool ok);
69   function approve(address spender, uint value) public returns (bool ok);
70   event Transfer(address indexed from, address indexed to, uint value);
71   event Approval(address indexed owner, address indexed spender, uint value);
72 }
73 
74 contract StandardToken is ERC20, SafeMath {
75 
76   mapping(address => uint) balances;
77   mapping (address => mapping (address => uint)) allowed;
78 
79   function transfer(address _to, uint _value) public returns (bool success) {
80       
81     balances[msg.sender] = safeSub(balances[msg.sender], _value);
82     balances[_to] = safeAdd(balances[_to], _value);
83     emit Transfer(msg.sender, _to, _value);
84     return true;
85   }
86 
87   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
88     var _allowance = allowed[_from][msg.sender];
89 
90     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
91     // if (_value > _allowance) throw;
92     
93     balances[_to] = safeAdd(balances[_to], _value);
94     balances[_from] = safeSub(balances[_from], _value);
95     allowed[_from][msg.sender] = safeSub(_allowance, _value);
96     Transfer(_from, _to, _value);
97     return true;
98   }
99 
100   function balanceOf(address _owner) public constant returns (uint balance) {
101     return balances[_owner];
102   }
103 
104   function approve(address _spender, uint _value) public returns (bool success) {
105       
106     allowed[msg.sender][_spender] = _value;
107     Approval(msg.sender, _spender, _value);
108     return true;
109   }
110 
111   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
112     return allowed[_owner][_spender];
113   }
114 
115 }
116 
117 contract UbetCoins is Ownable, StandardToken {
118 
119     string public name = "Ubet Coins";
120     string public symbol = "UBETS"; 
121     uint public decimals = 18;      
122 
123     uint256 public totalSupply =  4000000000 * (10**decimals);
124     uint256 public tokenSupplyFromCheck = 0;              
125         
126     /// Base exchange rate is set
127     uint256 public ratePerOneEther = 135;
128     uint256 public totalUBetCheckAmounts = 0;
129 
130     /// Issue event index starting from 0.
131     uint64 public issueIndex = 0;
132 
133     /// Emitted for each sucuessful token purchase.
134     event Issue(uint64 issueIndex, address addr, uint256 tokenAmount);
135     
136     // All funds will be transferred in this wallet.
137     address public moneyWallet = 0xe5688167Cb7aBcE4355F63943aAaC8bb269dc953;
138     
139     string public constant UBETCOINS_LEDGER_TO_LEDGER_ENTRY_INSTRUMENT_DOCUMENT_PATH = "https://s3.amazonaws.com/s3-ubetcoin-user-signatures/document/LEDGER-TO-LEDGER-ENTRY-FOR-UBETCOINS.pdf";
140     string public constant UBETCOINS_LEDGER_TO_LEDGER_ENTRY_INSTRUMENT_DOCUMENT_SHA512 = "c8f0ae2602005dd88ef908624cf59f3956107d0890d67d3baf9c885b64544a8140e282366cae6a3af7bfbc96d17f856b55fc4960e2287d4a03d67e646e0e88c6";
141 
142     /// Emitted for each UBetCheckS register.
143     event UBetCheckIssue(string chequeIndex);
144       
145     struct UBetCheck {
146       string accountId;
147       string accountNumber;
148       string fullName;
149       string routingNumber;
150       string institution;
151       uint256 amount;
152       uint256 tokens;
153       string checkFilePath;
154       string digitalCheckFingerPrint;
155     }
156     
157     mapping (address => UBetCheck) UBetChecks;
158     address[] public UBetCheckAccts;
159     
160     
161     /// @dev Initializes the contract and allocates all initial tokens to the owner
162     function UbetCoins() public{
163         balances[msg.sender] = totalSupply;
164     }
165   
166     //////////////// owner only functions below
167 
168     /// @dev To transfer token contract ownership
169     /// @param _newOwner The address of the new owner of this contract
170     function transferOwnership(address _newOwner) public onlyOwner {
171         balances[_newOwner] = balances[owner];
172         balances[owner] = 0;
173         Ownable.transferOwnership(_newOwner);
174     }
175     
176     /// check functionality
177     
178     /// @dev Register UBetCheck to the chain
179     /// @param _beneficiary recipient ether address
180     /// @param _accountId the id generated from the db
181     /// @param _accountNumber the account number stated in the check
182     /// @param _routingNumber the routing number stated in the check
183     /// @param _institution the name of the institution / bank in the check
184     /// @param _fullname the name printed on the check
185     /// @param _amount the amount in currency in the chek
186     /// @param _checkFilePath the url path where the cheque has been uploaded
187     /// @param _digitalCheckFingerPrint the hash of the file
188     /// @param _tokens number of tokens issued to the beneficiary
189     function registerUBetCheck(address _beneficiary, string _accountId,  string _accountNumber, string _routingNumber, string _institution, string _fullname,  uint256 _amount, string _checkFilePath, string _digitalCheckFingerPrint, uint256 _tokens) public payable onlyOwner {
190       
191       require(_beneficiary != address(0));
192       require(bytes(_accountId).length != 0);
193       require(bytes(_accountNumber).length != 0);
194       require(bytes(_routingNumber).length != 0);
195       require(bytes(_institution).length != 0);
196       require(bytes(_fullname).length != 0);
197       require(_amount > 0);
198       require(_tokens > 0);
199       require(bytes(_checkFilePath).length != 0);
200       require(bytes(_digitalCheckFingerPrint).length != 0);
201       
202       uint256 __conToken = _tokens * (10**(decimals));
203 
204       
205       var UBetCheck = UBetChecks[_beneficiary];
206       
207       UBetCheck.accountId = _accountId;
208       UBetCheck.accountNumber = _accountNumber;
209       UBetCheck.routingNumber = _routingNumber;
210       UBetCheck.institution = _institution;
211       UBetCheck.fullName = _fullname;
212       UBetCheck.amount = _amount;
213       UBetCheck.tokens = _tokens;
214       
215       UBetCheck.checkFilePath = _checkFilePath;
216       UBetCheck.digitalCheckFingerPrint = _digitalCheckFingerPrint;
217       
218       totalUBetCheckAmounts = safeAdd(totalUBetCheckAmounts, _amount);
219       tokenSupplyFromCheck = safeAdd(tokenSupplyFromCheck, _tokens);
220       
221       UBetCheckAccts.push(_beneficiary) -1;
222       
223       // Issue token when registered UBetCheck is complete to the _beneficiary
224       doIssueTokens(_beneficiary, __conToken);
225       
226       // Fire Event UBetCheckIssue
227       UBetCheckIssue(_accountId);
228     }
229     
230     /// @dev List all the checks in the
231     function getUBetChecks() public view returns (address[]) {
232       return UBetCheckAccts;
233     }
234     
235     /// @dev Return UBetCheck information by supplying beneficiary adddress
236     function getUBetCheck(address _address) public view returns(string, string, string, string, uint256, string, string) {
237             
238       return (UBetChecks[_address].accountNumber,
239               UBetChecks[_address].routingNumber,
240               UBetChecks[_address].institution,
241               UBetChecks[_address].fullName,
242               UBetChecks[_address].amount,
243               UBetChecks[_address].checkFilePath,
244               UBetChecks[_address].digitalCheckFingerPrint);
245     }
246     
247     /// @dev This default function allows token to be purchased by directly
248     /// sending ether to this smart contract.
249     function () public payable {
250       purchaseTokens(msg.sender);
251     }
252 
253     /// @dev return total count of registered UBetChecks
254     function countUBetChecks() public view returns (uint) {
255         return UBetCheckAccts.length;
256     }
257     
258 
259     /// @dev issue tokens for a single buyer
260     /// @param _beneficiary addresses that the tokens will be sent to.
261     /// @param _tokens the amount of tokens, with decimals expanded (full).
262     function doIssueTokens(address _beneficiary, uint256 _tokens) internal {
263       require(_beneficiary != address(0));    
264 
265       // compute without actually increasing it
266       uint256 increasedTotalSupply = safeAdd(totalSupply, _tokens);
267       
268       // increase token total supply
269       totalSupply = increasedTotalSupply;
270       // update the beneficiary balance to number of tokens sent
271       balances[_beneficiary] = safeAdd(balances[_beneficiary], _tokens);
272       
273       emit Transfer(msg.sender, _beneficiary, _tokens);
274     
275       // event is fired when tokens issued
276       emit Issue(
277                 issueIndex++,
278                 _beneficiary,
279                 _tokens
280                 );
281     }
282     
283     /// @dev Issue token based on Ether received.
284     /// @param _beneficiary Address that newly issued token will be sent to.
285     function purchaseTokens(address _beneficiary) public payable {
286       
287       uint _tokens = safeDiv(safeMul(msg.value, ratePerOneEther), (10**(18-decimals)));
288       doIssueTokens(_beneficiary, _tokens);
289 
290       /// forward the money to the money wallet
291       address(moneyWallet).transfer(address(this).balance);
292     }
293     
294     
295     /// @dev Change money wallet owner
296     /// @param _address new address to received the ether
297     function setMoneyWallet(address _address) public onlyOwner {
298         moneyWallet = _address;
299     }
300     
301     /// @dev Change Rate per token in one ether
302     /// @param _value the amount of tokens, with decimals expanded (full).
303     function setRatePerOneEther(uint256 _value) public onlyOwner {
304       require(_value >= 1);
305       ratePerOneEther = _value;
306     }
307     
308 }