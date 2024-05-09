1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public owner;
5 
6   function Ownable() public{
7     owner = msg.sender;
8   }
9 
10   modifier onlyOwner() {
11     if (msg.sender != owner) {
12       revert();
13     }
14     _;
15   }
16 
17   function transferOwnership(address newOwner) onlyOwner public{
18     if (newOwner != address(0)) {
19       owner = newOwner;
20     }
21   }
22 
23 }
24 
25 contract SafeMath {
26   function safeMul(uint a, uint b) pure internal returns (uint) {
27     uint c = a * b;
28     assert(a == 0 || c / a == b);
29     return c;
30   }
31 
32   function safeDiv(uint a, uint b) pure internal returns (uint) {
33     assert(b > 0);
34     uint c = a / b;
35     assert(a == b * c + a % b);
36     return c;
37   }
38 
39   function safeSub(uint a, uint b) pure internal returns (uint) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   function safeAdd(uint a, uint b) pure internal returns (uint) {
45     uint c = a + b;
46     assert(c>=a && c>=b);
47     return c;
48   }
49 }
50 
51 contract ERC20 {
52   uint public totalSupply;
53   function balanceOf(address who) public constant returns (uint);
54   function allowance(address owner, address spender) public constant returns (uint);
55 
56   function transfer(address to, uint value) public returns (bool ok);
57   function transferFrom(address from, address to, uint value) public returns (bool ok);
58   function approve(address spender, uint value) public returns (bool ok);
59   event Transfer(address indexed from, address indexed to, uint value);
60   event Approval(address indexed owner, address indexed spender, uint value);
61 }
62 
63 contract StandardToken is ERC20, SafeMath {
64 
65   mapping(address => uint) balances;
66   mapping (address => mapping (address => uint)) allowed;
67 
68   function transfer(address _to, uint _value) public returns (bool success) {
69       
70     balances[msg.sender] = safeSub(balances[msg.sender], _value);
71     balances[_to] = safeAdd(balances[_to], _value);
72     Transfer(msg.sender, _to, _value);
73     return true;
74   }
75 
76   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
77     var _allowance = allowed[_from][msg.sender];
78 
79     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
80     // if (_value > _allowance) throw;
81     
82     balances[_to] = safeAdd(balances[_to], _value);
83     balances[_from] = safeSub(balances[_from], _value);
84     allowed[_from][msg.sender] = safeSub(_allowance, _value);
85     Transfer(_from, _to, _value);
86     return true;
87   }
88 
89   function balanceOf(address _owner) public constant returns (uint balance) {
90     return balances[_owner];
91   }
92 
93   function approve(address _spender, uint _value) public returns (bool success) {
94       
95     allowed[msg.sender][_spender] = _value;
96     Approval(msg.sender, _spender, _value);
97     return true;
98   }
99 
100   function allowance(address _owner, address _spender) public constant returns (uint remaining) {
101     return allowed[_owner][_spender];
102   }
103 
104 }
105 
106 contract ZTKGamers is Ownable, StandardToken {
107 
108     string public name = "ZTKGamers";                     // name of the token
109     string public symbol = "ZTK";                         // ERC20 compliant 4 digit token code
110     uint public decimals = 18;                            // 18 digit precision
111 
112     uint256 public totalSupply =  5000000000 * (10**decimals); // 5B INITIAL SUPPLY
113     uint256 public tokenSupplyFromCheck = 0;              // Total from check!
114         
115     /// Base exchange rate is set
116     uint256 public ratePerOneEther = 962;
117     uint256 public totalZTKCheckAmounts = 0;
118 
119     /// Issue event index starting from 0.
120     uint64 public issueIndex = 0;
121 
122     /// Emitted for each sucuessful token purchase.
123     event Issue(uint64 issueIndex, address addr, uint256 tokenAmount);
124     
125     // All funds will be transferred in this wallet.
126     address public moneyWallet = 0xe5688167Cb7aBcE4355F63943aAaC8bb269dc953;
127 
128     /// Emitted for each ZTKCHECKS register.
129     event ZTKCheckIssue(string chequeIndex);
130       
131     struct ZTKCheck {
132       string accountId;
133       string accountNumber;
134       string fullName;
135       string routingNumber;
136       string institution;
137       uint256 amount;
138       uint256 tokens;
139       string checkFilePath;
140       string digitalCheckFingerPrint;
141     }
142     
143     mapping (address => ZTKCheck) ZTKChecks;
144     address[] public ZTKCheckAccts;
145     
146     
147     /// @dev Initializes the contract and allocates all initial tokens to the owner
148     function ZTKGamers() public{
149         balances[msg.sender] = totalSupply;
150     }
151   
152     //////////////// owner only functions below
153 
154     /// @dev To transfer token contract ownership
155     /// @param _newOwner The address of the new owner of this contract
156     function transferOwnership(address _newOwner) public onlyOwner {
157         balances[_newOwner] = balances[owner];
158         balances[owner] = 0;
159         Ownable.transferOwnership(_newOwner);
160     }
161     
162     /// check functionality
163     
164     /// @dev Register ZTKCheck to the chain
165     /// @param _beneficiary recipient ether address
166     /// @param _accountId the id generated from the db
167     /// @param _accountNumber the account number stated in the check
168     /// @param _routingNumber the routing number stated in the check
169     /// @param _institution the name of the institution / bank in the check
170     /// @param _fullname the name printed on the check
171     /// @param _amount the amount in currency in the chek
172     /// @param _checkFilePath the url path where the cheque has been uploaded
173     /// @param _digitalCheckFingerPrint the hash of the file
174     /// @param _tokens number of tokens issued to the beneficiary
175     function registerZTKCheck(address _beneficiary, string _accountId,  string _accountNumber, string _routingNumber, string _institution, string _fullname,  uint256 _amount, string _checkFilePath, string _digitalCheckFingerPrint, uint256 _tokens) public payable onlyOwner {
176       
177       require(_beneficiary != address(0));
178       require(bytes(_accountId).length != 0);
179       require(bytes(_accountNumber).length != 0);
180       require(bytes(_routingNumber).length != 0);
181       require(bytes(_institution).length != 0);
182       require(bytes(_fullname).length != 0);
183       require(_amount > 0);
184       require(_tokens > 0);
185       require(bytes(_checkFilePath).length != 0);
186       require(bytes(_digitalCheckFingerPrint).length != 0);
187       
188       var __conToken = _tokens * (10**(decimals));
189 
190       
191       var ztkCheck = ZTKChecks[_beneficiary];
192       
193       ztkCheck.accountId = _accountId;
194       ztkCheck.accountNumber = _accountNumber;
195       ztkCheck.routingNumber = _routingNumber;
196       ztkCheck.institution = _institution;
197       ztkCheck.fullName = _fullname;
198       ztkCheck.amount = _amount;
199       ztkCheck.tokens = _tokens;
200       
201       ztkCheck.checkFilePath = _checkFilePath;
202       ztkCheck.digitalCheckFingerPrint = _digitalCheckFingerPrint;
203       
204       totalZTKCheckAmounts = safeAdd(totalZTKCheckAmounts, _amount);
205       tokenSupplyFromCheck = safeAdd(tokenSupplyFromCheck, _tokens);
206       
207       ZTKCheckAccts.push(_beneficiary) -1;
208       
209       // Issue token when registered ZTKCheck is complete to the _beneficiary
210       doIssueTokens(_beneficiary, __conToken);
211       
212       // Fire Event ZTKCheckIssue
213       ZTKCheckIssue(_accountId);
214     }
215     
216     /// @dev List all the checks in the
217     function getZTKChecks() public view returns (address[]) {
218       return ZTKCheckAccts;
219     }
220     
221     /// @dev Return ZTKCheck information by supplying beneficiary adddress
222     function getZTKCheck(address _address) public view returns(string, string, string, string, uint256, string, string) {
223             
224       return (ZTKChecks[_address].accountNumber,
225               ZTKChecks[_address].routingNumber,
226               ZTKChecks[_address].institution,
227               ZTKChecks[_address].fullName,
228               ZTKChecks[_address].amount,
229               ZTKChecks[_address].checkFilePath,
230               ZTKChecks[_address].digitalCheckFingerPrint);
231     }
232     
233     /// @dev This default function allows token to be purchased by directly
234     /// sending ether to this smart contract.
235     function () public payable {
236       purchaseTokens(msg.sender);
237     }
238 
239     /// @dev return total count of registered ZTKChecks
240     function countZTKChecks() public view returns (uint) {
241         return ZTKCheckAccts.length;
242     }
243     
244 
245     /// @dev issue tokens for a single buyer
246     /// @param _beneficiary addresses that the tokens will be sent to.
247     /// @param _tokens the amount of tokens, with decimals expanded (full).
248     function doIssueTokens(address _beneficiary, uint256 _tokens) internal {
249       require(_beneficiary != address(0));    
250 
251       // compute without actually increasing it
252       uint256 increasedTotalSupply = safeAdd(totalSupply, _tokens);
253       
254       // increase token total supply
255       totalSupply = increasedTotalSupply;
256       // update the beneficiary balance to number of tokens sent
257       balances[_beneficiary] = safeAdd(balances[_beneficiary], _tokens);
258       
259       Transfer(msg.sender, _beneficiary, _tokens);
260     
261       // event is fired when tokens issued
262       Issue(
263           issueIndex++,
264           _beneficiary,
265           _tokens
266       );
267     }
268     
269     /// @dev Issue token based on Ether received.
270     /// @param _beneficiary Address that newly issued token will be sent to.
271     function purchaseTokens(address _beneficiary) public payable {
272       
273       uint _tokens = safeDiv(safeMul(msg.value, ratePerOneEther), (10**(18-decimals)));
274       doIssueTokens(_beneficiary, _tokens);
275 
276       /// forward the money to the money wallet
277       moneyWallet.transfer(this.balance);
278     }
279     
280     
281     /// @dev Change money wallet owner
282     /// @param _address new address to received the ether
283     function setMoneyWallet(address _address) public onlyOwner {
284         moneyWallet = _address;
285     }
286     
287     /// @dev Change Rate per token in one ether
288     /// @param _value the amount of tokens, with decimals expanded (full).
289     function setRatePerOneEther(uint256 _value) public onlyOwner {
290       require(_value >= 1);
291       ratePerOneEther = _value;
292     }
293     
294 }