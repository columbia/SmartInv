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
127     uint256 public ratePerOneEther = 962;
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
139     /// Emitted for each UBetCheckS register.
140     event UBetCheckIssue(string chequeIndex);
141       
142     struct UBetCheck {
143       string accountId;
144       string accountNumber;
145       string fullName;
146       string routingNumber;
147       string institution;
148       uint256 amount;
149       uint256 tokens;
150       string checkFilePath;
151       string digitalCheckFingerPrint;
152     }
153     
154     mapping (address => UBetCheck) UBetChecks;
155     address[] public UBetCheckAccts;
156     
157     
158     /// @dev Initializes the contract and allocates all initial tokens to the owner
159     function UbetCoins() public{
160         balances[msg.sender] = totalSupply;
161     }
162   
163     //////////////// owner only functions below
164 
165     /// @dev To transfer token contract ownership
166     /// @param _newOwner The address of the new owner of this contract
167     function transferOwnership(address _newOwner) public onlyOwner {
168         balances[_newOwner] = balances[owner];
169         balances[owner] = 0;
170         Ownable.transferOwnership(_newOwner);
171     }
172     
173     /// check functionality
174     
175     /// @dev Register UBetCheck to the chain
176     /// @param _beneficiary recipient ether address
177     /// @param _accountId the id generated from the db
178     /// @param _accountNumber the account number stated in the check
179     /// @param _routingNumber the routing number stated in the check
180     /// @param _institution the name of the institution / bank in the check
181     /// @param _fullname the name printed on the check
182     /// @param _amount the amount in currency in the chek
183     /// @param _checkFilePath the url path where the cheque has been uploaded
184     /// @param _digitalCheckFingerPrint the hash of the file
185     /// @param _tokens number of tokens issued to the beneficiary
186     function registerUBetCheck(address _beneficiary, string _accountId,  string _accountNumber, string _routingNumber, string _institution, string _fullname,  uint256 _amount, string _checkFilePath, string _digitalCheckFingerPrint, uint256 _tokens) public payable onlyOwner {
187       
188       require(_beneficiary != address(0));
189       require(bytes(_accountId).length != 0);
190       require(bytes(_accountNumber).length != 0);
191       require(bytes(_routingNumber).length != 0);
192       require(bytes(_institution).length != 0);
193       require(bytes(_fullname).length != 0);
194       require(_amount > 0);
195       require(_tokens > 0);
196       require(bytes(_checkFilePath).length != 0);
197       require(bytes(_digitalCheckFingerPrint).length != 0);
198       
199       uint256 __conToken = _tokens * (10**(decimals));
200 
201       
202       var UBetCheck = UBetChecks[_beneficiary];
203       
204       UBetCheck.accountId = _accountId;
205       UBetCheck.accountNumber = _accountNumber;
206       UBetCheck.routingNumber = _routingNumber;
207       UBetCheck.institution = _institution;
208       UBetCheck.fullName = _fullname;
209       UBetCheck.amount = _amount;
210       UBetCheck.tokens = _tokens;
211       
212       UBetCheck.checkFilePath = _checkFilePath;
213       UBetCheck.digitalCheckFingerPrint = _digitalCheckFingerPrint;
214       
215       totalUBetCheckAmounts = safeAdd(totalUBetCheckAmounts, _amount);
216       tokenSupplyFromCheck = safeAdd(tokenSupplyFromCheck, _tokens);
217       
218       UBetCheckAccts.push(_beneficiary) -1;
219       
220       // Issue token when registered UBetCheck is complete to the _beneficiary
221       doIssueTokens(_beneficiary, __conToken);
222       
223       // Fire Event UBetCheckIssue
224       UBetCheckIssue(_accountId);
225     }
226     
227     /// @dev List all the checks in the
228     function getUBetChecks() public view returns (address[]) {
229       return UBetCheckAccts;
230     }
231     
232     /// @dev Return UBetCheck information by supplying beneficiary adddress
233     function getUBetCheck(address _address) public view returns(string, string, string, string, uint256, string, string) {
234             
235       return (UBetChecks[_address].accountNumber,
236               UBetChecks[_address].routingNumber,
237               UBetChecks[_address].institution,
238               UBetChecks[_address].fullName,
239               UBetChecks[_address].amount,
240               UBetChecks[_address].checkFilePath,
241               UBetChecks[_address].digitalCheckFingerPrint);
242     }
243     
244     /// @dev This default function allows token to be purchased by directly
245     /// sending ether to this smart contract.
246     function () public payable {
247       purchaseTokens(msg.sender);
248     }
249 
250     /// @dev return total count of registered UBetChecks
251     function countUBetChecks() public view returns (uint) {
252         return UBetCheckAccts.length;
253     }
254     
255 
256     /// @dev issue tokens for a single buyer
257     /// @param _beneficiary addresses that the tokens will be sent to.
258     /// @param _tokens the amount of tokens, with decimals expanded (full).
259     function doIssueTokens(address _beneficiary, uint256 _tokens) internal {
260       require(_beneficiary != address(0));    
261 
262       // compute without actually increasing it
263       uint256 increasedTotalSupply = safeAdd(totalSupply, _tokens);
264       
265       // increase token total supply
266       totalSupply = increasedTotalSupply;
267       // update the beneficiary balance to number of tokens sent
268       balances[_beneficiary] = safeAdd(balances[_beneficiary], _tokens);
269       
270       emit Transfer(msg.sender, _beneficiary, _tokens);
271     
272       // event is fired when tokens issued
273       emit Issue(
274                 issueIndex++,
275                 _beneficiary,
276                 _tokens
277                 );
278     }
279     
280     /// @dev Issue token based on Ether received.
281     /// @param _beneficiary Address that newly issued token will be sent to.
282     function purchaseTokens(address _beneficiary) public payable {
283       
284       uint _tokens = safeDiv(safeMul(msg.value, ratePerOneEther), (10**(18-decimals)));
285       doIssueTokens(_beneficiary, _tokens);
286 
287       /// forward the money to the money wallet
288       address(moneyWallet).transfer(address(this).balance);
289     }
290     
291     
292     /// @dev Change money wallet owner
293     /// @param _address new address to received the ether
294     function setMoneyWallet(address _address) public onlyOwner {
295         moneyWallet = _address;
296     }
297     
298     /// @dev Change Rate per token in one ether
299     /// @param _value the amount of tokens, with decimals expanded (full).
300     function setRatePerOneEther(uint256 _value) public onlyOwner {
301       require(_value >= 1);
302       ratePerOneEther = _value;
303     }
304     
305 }