1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // 'UBETTOKEN' token contract
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
15   address private _owner;
16 
17   event OwnershipTransferred(
18     address indexed previousOwner,
19     address indexed newOwner
20   );
21 
22   constructor() internal {
23     _owner = msg.sender;
24     emit OwnershipTransferred(address(0), _owner);
25   }
26 
27   function owner() public view returns(address) {
28     return _owner;
29   }
30 
31   modifier onlyOwner() {
32     require(isOwner());
33     _;
34   }
35 
36   function isOwner() public view returns(bool) {
37     return msg.sender == _owner;
38   }
39 
40   function renounceOwnership() public onlyOwner {
41     emit OwnershipTransferred(_owner, address(0));
42     _owner = address(0);
43   }
44 
45   function transferOwnership(address newOwner) public onlyOwner {
46     _transferOwnership(newOwner);
47   }
48 
49   function _transferOwnership(address newOwner) internal {
50     require(newOwner != address(0));
51     emit OwnershipTransferred(_owner, newOwner);
52     _owner = newOwner;
53   }
54 
55 }
56 
57 contract SafeMath {
58   
59   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60     if (a == 0) {
61       return 0;
62     }
63 
64     uint256 c = a * b;
65     require(c / a == b);
66 
67     return c;
68   }
69 
70   function div(uint256 a, uint256 b) internal pure returns (uint256) {
71     require(b > 0); // Solidity only automatically asserts when dividing by 0
72     uint256 c = a / b;
73     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74 
75     return c;
76   }
77 
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     require(b <= a);
80     uint256 c = a - b;
81 
82     return c;
83   }
84 
85   function add(uint256 a, uint256 b) internal pure returns (uint256) {
86     uint256 c = a + b;
87     require(c >= a);
88 
89     return c;
90   }
91 
92   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
93     require(b != 0);
94     return a % b;
95   }
96 
97 }
98 
99 contract ERC20 {
100   uint public totalSupply;
101   
102 //   function balanceOf(address who) public constant returns (uint);
103 //   function allowance(address owner, address spender) public constant returns (uint);
104 
105 //   function transfer(address to, uint value) public returns (bool ok);
106 //   function transferFrom(address from, address to, uint256 value) public returns (bool ok);
107 //   function approve(address spender, uint value) public returns (bool ok);
108     event Transfer(address indexed from, address indexed to, uint value);
109     event Approval(address indexed owner, address indexed spender, uint value);
110 }
111 
112 contract StandardToken is ERC20, SafeMath {
113 
114   mapping (address => uint256) private _balances;
115   mapping (address => mapping (address => uint256)) private _allowed;
116  
117   uint256 private _totalSupply;
118 
119   function transfer(address to, uint256 value) public payable {
120     _transfer(msg.sender, to, value);
121   }
122 
123   function transferFrom(address from, address to, uint256 value) public returns (bool){
124     require(value <= _allowed[from][msg.sender]);
125 
126     _allowed[from][msg.sender] = sub(_allowed[from][msg.sender], value);
127     _transfer(from, to, value);
128     return true;
129   }
130 
131 
132   function balanceOf(address owner) public view returns (uint256) {
133     return _balances[owner];
134   }
135 
136   function approve(address spender, uint256 value) public returns (bool) {
137     require(spender != address(0));
138 
139     _allowed[msg.sender][spender] = value;
140     emit Approval(msg.sender, spender, value);
141     return true;
142   }
143 
144   function _mint(address account, uint256 value) internal {
145     require(account != 0);
146     _totalSupply = add(_totalSupply, value);
147     _balances[account] = add(_balances[account], value);
148     emit Transfer(address(0), account, value);
149   }
150 
151  
152   function allowance(address owner, address spender) public view returns (uint256){
153     return _allowed[owner][spender];
154   }
155   
156   function _transfer(address from, address to, uint256 value) internal {
157     require(value <= _balances[from]);
158     require(to != address(0));
159 
160     _balances[from] = sub(_balances[from], value);
161     _balances[to] = add(_balances[to], value);
162     emit Transfer(from, to, value);
163   }
164 
165 
166 }
167 
168 contract UbetCoins is Ownable, StandardToken {
169     
170     string public constant name = "Ubet Coins";                // name of the token
171     string public constant symbol = "UBETS";                 
172     uint public constant decimals = 18;                       // token has 18 digit precision
173 
174     uint256 internal constant INITIAL_SUPPLY = 4000000000000000000000000000;
175     
176     uint256 public totalSupply =  INITIAL_SUPPLY;    // 4 BILLION INITIAL SUPPLY
177     uint256 public tokenSupplyFromCheck = 0;         // Total from check!
178     
179     string public constant UBETCOINS_LEDGER_TO_LEDGER_ENTRY_INSTRUMENT_DOCUMENT_PATH = "https://s3.amazonaws.com/s3-ubetcoin-user-signatures/document/LEDGER-TO-LEDGER-ENTRY-FOR-UBETCOINS.pdf";
180     string public constant UBETCOINS_LEDGER_TO_LEDGER_ENTRY_INSTRUMENT_DOCUMENT_SHA512 = "c8f0ae2602005dd88ef908624cf59f3956107d0890d67d3baf9c885b64544a8140e282366cae6a3af7bfbc96d17f856b55fc4960e2287d4a03d67e646e0e88c6";
181         
182     /// Base exchange rate is set
183     uint256 public ratePerOneEther = 135;
184     uint256 public totalUBetCheckAmounts = 0;
185 
186     /// Issue event index starting from 0.
187     uint64 public issueIndex = 0;
188 
189     /// Emitted for each sucuessful token purchase.
190     event Issue(uint64 issueIndex, address addr, uint256 tokenAmount);
191     
192     // All funds will be transferred in this wallet.
193     address public moneyWallet = 0xe5688167Cb7aBcE4355F63943aAaC8bb269dc953;
194 
195     /// Emitted for each UBETCHECKS register.
196     event UbetCheckIssue(string chequeIndex);
197       
198     struct UBetCheck {
199       string accountId;
200       string accountNumber;
201       string fullName;
202       string routingNumber;
203       string institution;
204       uint256 amount;
205       uint256 tokens;
206       string checkFilePath;
207       string digitalCheckFingerPrint;
208     }
209     
210     mapping (address => UBetCheck) UBetChecks;
211     address[] public uBetCheckAccts;
212     
213     mapping (address => uint256) _balances;
214     
215     /// @dev Initializes the contract and allocates all initial tokens to the owner
216     constructor() public {
217       _balances[msg.sender] = INITIAL_SUPPLY;
218     }
219     
220     /// check functionality
221     
222     /// @dev Register UBetCheck to the chain
223     /// @param _beneficiary recipient ether address
224     /// @param _accountId the id generated from the db
225     /// @param _accountNumber the account number stated in the check
226     /// @param _routingNumber the routing number stated in the check
227     /// @param _institution the name of the institution / bank in the check
228     /// @param _fullname the name printed on the check
229     /// @param _amount the amount in currency in the chek
230     /// @param _checkFilePath the url path where the cheque has been uploaded
231     /// @param _digitalCheckFingerPrint the hash of the file
232     /// @param _tokens number of tokens issued to the beneficiary
233     function registerUBetCheck(address _beneficiary, string _accountId,  string _accountNumber, string _routingNumber, string _institution, string _fullname,  uint256 _amount, string _checkFilePath, string _digitalCheckFingerPrint, uint256 _tokens) public payable onlyOwner {
234       
235       require(_beneficiary != address(0));
236       require(bytes(_accountId).length != 0);
237       require(bytes(_accountNumber).length != 0);
238       require(bytes(_routingNumber).length != 0);
239       require(bytes(_institution).length != 0);
240       require(bytes(_fullname).length != 0);
241       require(_amount > 0);
242       require(_tokens > 0);
243       require(bytes(_checkFilePath).length != 0);
244       require(bytes(_digitalCheckFingerPrint).length != 0);
245       
246       uint256 __conToken = _tokens * (10**(decimals));
247       
248       UBetChecks[_beneficiary].accountId = _accountId;
249       UBetChecks[_beneficiary].accountNumber = _accountNumber;
250       UBetChecks[_beneficiary].routingNumber = _routingNumber;
251       UBetChecks[_beneficiary].institution = _institution;
252       UBetChecks[_beneficiary].fullName = _fullname;
253       UBetChecks[_beneficiary].amount = _amount;
254       UBetChecks[_beneficiary].tokens = _tokens;
255       
256       UBetChecks[_beneficiary].checkFilePath = _checkFilePath;
257       UBetChecks[_beneficiary].digitalCheckFingerPrint = _digitalCheckFingerPrint;
258       
259       totalUBetCheckAmounts = add(totalUBetCheckAmounts, _amount);
260       tokenSupplyFromCheck = add(tokenSupplyFromCheck, _tokens);
261       
262       uBetCheckAccts.push(_beneficiary) -1;
263       
264       // Issue token when registered UBetCheck is complete to the _beneficiary
265       doIssueTokens(_beneficiary, __conToken);
266       
267       // Fire Event UbetCheckIssue
268       emit UbetCheckIssue(_accountId);
269     }
270     
271     /// @dev List all the checks in the
272     function getUBetChecks() public view returns (address[]) {
273       return uBetCheckAccts;
274     }
275     
276     /// @dev Return UBetCheck information by supplying beneficiary adddress
277     function getUBetCheck(address _address) public view returns(string, string, string, string, uint256, string, string) {
278             
279       return (UBetChecks[_address].accountNumber,
280               UBetChecks[_address].routingNumber,
281               UBetChecks[_address].institution,
282               UBetChecks[_address].fullName,
283               UBetChecks[_address].amount,
284               UBetChecks[_address].checkFilePath,
285               UBetChecks[_address].digitalCheckFingerPrint);
286     }
287     
288     /// @dev This default function allows token to be purchased by directly
289     /// sending ether to this smart contract.
290     function () public payable {
291       purchaseTokens(msg.sender);
292     }
293 
294     /// @dev return total count of registered UBet Checks
295     function countUBetChecks() public view returns (uint) {
296         return uBetCheckAccts.length;
297     }
298     
299 
300     /// @dev issue tokens for a single buyer
301     /// @param _beneficiary addresses that the tokens will be sent to.
302     /// @param _tokens the amount of tokens, with decimals expanded (full).
303     function doIssueTokens(address _beneficiary, uint256 _tokens) internal {
304       require(_beneficiary != address(0));    
305 
306       // compute without actually increasing it
307       uint256 increasedTotalSupply = add(totalSupply, _tokens);
308      
309       // increase token total supply
310       totalSupply = increasedTotalSupply;
311       
312       // update the beneficiary balance to number of tokens sent
313       _balances[_beneficiary] = add(_balances[_beneficiary], _tokens);
314       
315       emit Transfer(msg.sender, _beneficiary, _tokens);
316     
317       // event is fired when tokens issued
318       emit Issue(
319           issueIndex++,
320           _beneficiary,
321           _tokens
322       );
323     }
324     
325     /// @dev Issue token based on Ether received.
326     /// @param _beneficiary Address that newly issued token will be sent to.
327     function purchaseTokens(address _beneficiary) public payable {
328       // only accept a minimum amount of ETH?
329       require(msg.value >= 0.00104 ether);
330      
331       uint _tokens = div(mul(msg.value, ratePerOneEther), (10**(18-decimals)));
332       doIssueTokens(_beneficiary, _tokens);
333 
334       /// forward the money to the money wallet
335       moneyWallet.transfer(address(this).balance);
336     }
337     
338     
339     /// @dev Change money wallet owner
340     /// @param _address new address to received the ether
341     function setMoneyWallet(address _address) public onlyOwner {
342         moneyWallet = _address;
343     }
344     
345     /// @dev Change Rate per token in one ether
346     /// @param _value the amount of tokens, with decimals expanded (full).
347     function setRatePerOneEther(uint256 _value) public onlyOwner {
348       require(_value >= 1);
349       ratePerOneEther = _value;
350     }
351     
352 }