1 pragma solidity 0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a * b;
10         require(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         require(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a);
29         return c;
30     }
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39     uint256 public totalSupply;
40     function balanceOf(address who) public view returns (uint256);
41     function transfer(address to, uint256 value) public returns (bool);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title Basic token
47  * @dev Basic version of StandardToken, with no allowances.
48  */
49 contract BasicToken is ERC20Basic {
50     using SafeMath for uint256;
51 
52     mapping(address => uint256) public balances;
53 
54     /**
55     * @dev transfer token for a specified address
56     * @param _to The address to transfer to.
57     * @param _value The amount to be transferred.
58     */
59     function transfer(address _to, uint256 _value) public returns (bool) {
60         require(_to != address(0));
61         require(_value <= balances[msg.sender]);
62 
63         // SafeMath.sub will throw if there is not enough balance.
64         balances[msg.sender] = balances[msg.sender].sub(_value);
65         balances[_to] = balances[_to].add(_value);
66         Transfer(msg.sender, _to, _value);
67         return true;
68     }
69 
70     /**
71     * @dev Gets the balance of the specified address.
72     * @param _owner The address to query the the balance of.
73     * @return An uint256 representing the amount owned by the passed address.
74     */
75     function balanceOf(address _owner) public view returns (uint256 balance) {
76         return balances[_owner];
77     }
78 
79 }
80 
81 /**
82  * @title ERC20 interface
83  * @dev see https://github.com/ethereum/EIPs/issues/20
84  */
85 contract ERC20 is ERC20Basic {
86   function allowance(address owner, address spender) public view returns (uint256);
87   function transferFrom(address from, address to, uint256 value) public returns (bool);
88   function approve(address spender, uint256 value) public returns (bool);
89   event Approval(address indexed owner, address indexed spender, uint256 value);
90 }
91 
92 /**
93  * @title SafeERC20
94  * @dev Wrappers around ERC20 operations that throw on failure.
95  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
96  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
97  */
98 library SafeERC20 {
99   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
100       assert(token.transfer(to, value));
101   }
102 
103   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
104       assert(token.transferFrom(from, to, value));
105   }
106 
107   function safeApprove(ERC20 token, address spender, uint256 value) internal {
108       assert(token.approve(spender, value));
109   }
110 }
111 
112 /**
113  * @title Standard ERC20 token
114  *
115  * @dev Implementation of the basic standard token.
116  * @dev https://github.com/ethereum/EIPs/issues/20
117  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
118  */
119 contract StandardToken is ERC20, BasicToken {
120 
121     mapping (address => mapping (address => uint256)) internal allowed;
122 
123     /**
124      * @dev Transfer tokens from one address to another
125      * @param _from address The address which you want to send tokens from
126      * @param _to address The address which you want to transfer to
127      * @param _value uint256 the amount of tokens to be transferred
128      */
129     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
130         require(_to != address(0));
131         require(_value <= balances[_from]);
132         require(_value <= allowed[_from][msg.sender]);
133 
134         balances[_from] = balances[_from].sub(_value);
135         balances[_to] = balances[_to].add(_value);
136         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
137         Transfer(_from, _to, _value);
138         return true;
139     }
140 
141     /**
142      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
143      *
144      * Beware that changing an allowance with this method brings the risk that someone may use both the old
145      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
146      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
147      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
148      * @param _spender The address which will spend the funds.
149      * @param _value The amount of tokens to be spent.
150      */
151     function approve(address _spender, uint256 _value) public returns (bool) {
152         allowed[msg.sender][_spender] = _value;
153         Approval(msg.sender, _spender, _value);
154         return true;
155     }
156 
157     /**
158      * @dev Function to check the amount of tokens that an owner allowed to a spender.
159      * @param _owner address The address which owns the funds.
160      * @param _spender address The address which will spend the funds.
161      * @return A uint256 specifying the amount of tokens still available for the spender.
162      */
163     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
164         return allowed[_owner][_spender];
165     }
166 
167     /**
168      * approve should be called when allowed[_spender] == 0. To increment
169      * allowed value is better to use this function to avoid 2 calls (and wait until
170      * the first transaction is mined)
171      * From MonolithDAO Token.sol
172      */
173     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
174         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
175         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
176         return true;
177     }
178 
179     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
180         uint oldValue = allowed[msg.sender][_spender];
181         if (_subtractedValue > oldValue) {
182             allowed[msg.sender][_spender] = 0;
183         } else {
184             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
185         }
186         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
187         return true;
188     }
189 
190 }
191 
192 /**
193  * @title Ownable
194  * @dev The Ownable contract has an owner address, and provides basic authorization control
195  * functions, this simplifies the implementation of "user permissions".
196  */
197 contract Ownable {
198   address public owner;
199 
200 
201   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
202 
203 
204   /**
205    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
206    * account.
207    */
208   function Ownable() public {
209     owner = msg.sender;
210   }
211 
212   /**
213    * @dev Throws if called by any account other than the owner.
214    */
215   modifier onlyOwner() {
216     require(msg.sender == owner);
217     _;
218   }
219 
220   /**
221    * @dev Allows the current owner to transfer control of the contract to a newOwner.
222    * @param newOwner The address to transfer ownership to.
223    */
224   function transferOwnership(address newOwner) public onlyOwner {
225     require(newOwner != address(0));
226     OwnershipTransferred(owner, newOwner);
227     owner = newOwner;
228   }
229 
230 }
231 
232 
233 contract UBetCoin is StandardToken, Ownable {
234   
235     string public constant name = "UBetCoin";
236     string public constant symbol = "UBET";
237     
238     string public constant YOU_BET_MINE_DOCUMENT_PATH = "https://s3.amazonaws.com/s3-ubetcoin-user-signatures/document/GOLD-MINES-assigned+TO-SAINT-NICOLAS-SNADCO-03-22-2016.pdf";
239     string public constant YOU_BET_MINE_DOCUMENT_SHA512 = "7e9dc6362c5bf85ff19d75df9140b033c4121ba8aaef7e5837b276d657becf0a0d68fcf26b95e76023a33251ac94f35492f2f0af882af4b87b1b1b626b325cf8";
240     string public constant UBETCOIN_LEDGER_TO_LEDGER_ENTRY_DOCUMENT_PATH = "https://s3.amazonaws.com/s3-ubetcoin-user-signatures/document/LEDGER-TO-LEDGER+ENTRY-FOR-UBETCOIN+03-20-2018.pdf";
241     string public constant UBETCOIN_LEDGER_TO_LEDGER_ENTRY_DOCUMENT_SHA512 = "c8f0ae2602005dd88ef908624cf59f3956107d0890d67d3baf9c885b64544a8140e282366cae6a3af7bfbc96d17f856b55fc4960e2287d4a03d67e646e0e88c6";
242     
243     uint8 public constant decimals = 0;
244     uint256 public constant totalCoinSupply = 4000000000 * (10 ** uint256(decimals));  
245 
246     /// Base exchange rate is set to 1 ETH = 962 UBET.
247     uint256 public ratePerOneEther = 962;
248     uint256 public totalUBetCheckAmounts = 0;
249 
250     /// Issue event index starting from 0.
251     uint64 public issueIndex = 0;
252 
253     /// Emitted for each sucuessful token purchase.
254     event Issue(uint64 issueIndex, address addr, uint256 tokenAmount);
255     
256     /// Emitted for each UBETCHECKS register.
257     event UbetCheckIssue(string chequeIndex);
258     
259     // All funds will be transferred in this wallet.
260     address public moneyWallet = 0xe5688167Cb7aBcE4355F63943aAaC8bb269dc953;
261   
262     struct UBetCheck {
263       string accountId;
264       string accountNumber;
265       string fullName;
266       string routingNumber;
267       string institution;
268       uint256 amount;
269       uint256 tokens;
270       string checkFilePath;
271       string digitalCheckFingerPrint;
272     }
273     
274     mapping (address => UBetCheck) UBetChecks;
275     address[] public uBetCheckAccts;
276     
277     
278     function UBetCoin() public {
279     }
280 
281     /// @dev This default function allows token to be purchased by directly
282     /// sending ether to this smart contract.
283     function () public payable {
284       purchaseTokens(msg.sender);
285     }
286     
287     /// @dev Register UBetCheck to the chain
288     
289     /// @param _beneficiary recipient ether address
290     /// @param _accountId the id generated from the db
291     /// @param _accountNumber the account number stated in the check
292     /// @param _routingNumber the routing number stated in the check
293     /// @param _institution the name of the institution / bank in the check
294     /// @param _fullname the name printed on the check
295     /// @param _amount the amount in currency in the chek
296     /// @param _checkFilePath the url path where the cheque has been uploaded
297     /// @param _digitalCheckFingerPrint the hash of the file
298     function registerUBetCheck(address _beneficiary, string _accountId,  string _accountNumber, string _routingNumber, string _institution, string _fullname,  uint256 _amount, string _checkFilePath, string _digitalCheckFingerPrint, uint256 _tokens) public payable onlyOwner {
299       
300       require(_beneficiary != address(0));
301       
302       require(bytes(_accountId).length != 0);
303       require(bytes(_accountNumber).length != 0);
304       require(bytes(_routingNumber).length != 0);
305       require(bytes(_institution).length != 0);
306       require(bytes(_fullname).length != 0);
307       require(_amount > 0);
308       require(_tokens > 0);
309       require(bytes(_checkFilePath).length != 0);
310       require(bytes(_digitalCheckFingerPrint).length != 0);
311       
312       var uBetCheck = UBetChecks[_beneficiary];
313       
314       uBetCheck.accountId = _accountId;
315       uBetCheck.accountNumber = _accountNumber;
316       uBetCheck.routingNumber = _routingNumber;
317       uBetCheck.institution = _institution;
318       uBetCheck.fullName = _fullname;
319       uBetCheck.amount = _amount;
320       uBetCheck.tokens = _tokens;
321       
322       uBetCheck.checkFilePath = _checkFilePath;
323       uBetCheck.digitalCheckFingerPrint = _digitalCheckFingerPrint;
324       
325       totalUBetCheckAmounts += _amount;
326       
327       uBetCheckAccts.push(_beneficiary) -1;
328       
329       
330       // Issue token when registered UBetCheck is complete to the _beneficiary
331       doIssueTokens(_beneficiary, _tokens);
332       
333       // Fire Event UbetCheckIssue
334       UbetCheckIssue(_accountId);
335     }
336     
337     /// @dev List all the checks in the
338     function getUBetChecks() view public returns (address[]) {
339       return uBetCheckAccts;
340     }
341     
342     /// @dev Return UBetCheck information by supplying beneficiary adddress
343     function getUBetCheck(address _address) view public returns(string, string, string, string, uint256, string, string) {
344             
345       return (UBetChecks[_address].accountNumber,
346               UBetChecks[_address].routingNumber,
347               UBetChecks[_address].institution,
348               UBetChecks[_address].fullName,
349               UBetChecks[_address].amount,
350               UBetChecks[_address].checkFilePath,
351               UBetChecks[_address].digitalCheckFingerPrint);
352     }
353         
354     /// @dev Issue token based on Ether received.
355     /// @param _beneficiary Address that newly issued token will be sent to.
356     function purchaseTokens(address _beneficiary) public payable {
357       // only accept a minimum amount of ETH?
358       require(msg.value >= 0.00104 ether);
359 
360       uint256 tokens = computeTokenAmount(msg.value);
361       doIssueTokens(_beneficiary, tokens);
362 
363       /// forward the funds to the money wallet
364       moneyWallet.transfer(this.balance);
365     }
366     
367     /// @dev return total count of registered UBet Checks
368     function countUBetChecks() view public returns (uint) {
369         return uBetCheckAccts.length;
370     }
371     
372     /// @dev Issue tokens for a single buyer on the sale
373     /// @param _beneficiary addresses that the sale tokens will be sent to.
374     /// @param _tokens the amount of tokens, with decimals expanded (full).
375     function issueTokens(address _beneficiary, uint256 _tokens) public onlyOwner {
376       doIssueTokens(_beneficiary, _tokens);
377     }
378 
379     /// @dev issue tokens for a single buyer
380     /// @param _beneficiary addresses that the tokens will be sent to.
381     /// @param _tokens the amount of tokens, with decimals expanded (full).
382     function doIssueTokens(address _beneficiary, uint256 _tokens) internal {
383       require(_beneficiary != address(0));    
384 
385       // compute without actually increasing it
386       uint256 increasedTotalSupply = totalSupply.add(_tokens);
387     
388       // increase token total supply
389       totalSupply = increasedTotalSupply;
390       // update the beneficiary balance to number of tokens sent
391       balances[_beneficiary] = balances[_beneficiary].add(_tokens);
392 
393       // event is fired when tokens issued
394       Issue(
395           issueIndex++,
396           _beneficiary,
397           _tokens
398       );
399     }
400 
401     /// @dev Compute the amount of UBET token that can be purchased.
402     /// @param ethAmount Amount of Ether to purchase UBET.
403     /// @return Amount of UBET token to purchase
404     function computeTokenAmount(uint256 ethAmount) internal view returns (uint256 tokens) {
405       tokens = ethAmount.mul(ratePerOneEther).div(10**18);
406     }
407 }