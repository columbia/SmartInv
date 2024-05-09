1 //SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.7;
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13         uint256 c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         // assert(b > 0); // Solidity automatically throws when dividing by 0
20         uint256 c = a / b;
21         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22         return c;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         assert(c >= a);
33         return c;
34     }
35 }
36 
37 
38 contract Ownable  {
39     address payable public _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     /**
44      * @dev Initializes the contract setting the deployer as the initial owner.
45      */
46     constructor ()  {
47         _owner = payable(msg.sender);
48         emit OwnershipTransferred(address(0), msg.sender);
49     }
50 
51     /**
52      * @dev Returns the address of the current owner.
53      */
54     function owner() public view returns (address) {
55         return _owner;
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         require(_owner == msg.sender, "Ownable: caller is not the owner");
63         _;
64     }
65 
66 
67     /**
68      * @dev Transfers ownership of the contract to a new account (`newOwner`).
69      * Can only be called by the current owner.
70      */
71     function transferOwnership(address payable newOwner) public onlyOwner {
72         require(newOwner != address(0), "Ownable: new owner is the zero address");
73         emit OwnershipTransferred(_owner, newOwner);
74         _owner = newOwner;
75     }
76 }
77 
78 
79 interface Token {
80     function transfer(address to, uint256 value) external returns (bool);
81     function transferFrom(address from, address to, uint256 value) external returns (bool);
82     function balanceOf(address who) external view returns (uint256);
83     function approve(address spender, uint256 value) external returns (bool);
84 
85 }
86 
87 
88 contract AIETokenPresaleRound1 is Ownable {
89     using SafeMath for uint;
90 
91     address public tokenAddr;
92     
93     uint256 public tokenPriceBnb = 60000000000000;
94     uint256 public tokenDecimal = 18;
95     uint256 public bnbDecimal = 18;
96     uint256 public totalTransaction;
97     uint256 public totalHardCap;
98     uint256 public minContribution = 81000000000000000; 
99     uint256 public maxContribution = 41000000000000000000; 
100     uint256 public hardCap = 660000000000000000000; 
101     
102 
103     event TokenTransfer(address beneficiary, uint amount);
104     event amountTransfered(address indexed fromAddress,address contractAddress,address indexed toAddress, uint256 indexed amount);
105     event TokenDeposited(address indexed beneficiary, uint amount);
106     event BnbDeposited(address indexed beneficiary, uint amount);
107     
108     mapping(address => uint256) public balances;
109     mapping(address => bool) public whitelisted;
110     mapping(address => uint256) public tokenExchanged;
111 
112     bool public whitelist = false;
113     bool public claim = true;
114  
115 
116     constructor(address _tokenAddr)  {
117         tokenAddr = _tokenAddr;
118     }
119    
120     /* This Function Will Airdrop ETH to Multiple Users */
121     function transferCrypto(uint256[] memory amounts, address payable[] memory receivers) payable public  onlyOwner returns (bool){
122         uint total = 0;
123         require(amounts.length == receivers.length);
124         require(receivers.length <= 100); //maximum receievers can be 100
125         for(uint j = 0; j < amounts.length; j++) {
126             total = total.add(amounts[j]);
127         }
128         require(total <= msg.value);
129             
130         for(uint i = 0; i< receivers.length; i++){
131             receivers[i].transfer(amounts[i]);
132             emit amountTransfered(msg.sender,address(this) ,receivers[i],amounts[i]);
133         }
134         return true;
135     }
136     
137     /* This Function will Airdrop Tokens to Multiple Users */
138     function AirdropTokens(address[] memory _recipients, uint256[] memory _amount) public onlyOwner returns (bool) {
139         uint total = 0;
140         require(_recipients.length == _amount.length);
141         require(_recipients.length <= 100); //maximum receievers can be 100
142         for(uint j = 0; j < _amount.length; j++) {
143             total = total.add(_amount[j]);
144         }        
145 
146         for (uint i = 0; i < _recipients.length; i++) {
147             require(_recipients[i] != address(0),"Address should not be Zero");
148             balances[_recipients[i]] = _amount[i];
149         }
150 
151         return true;
152     }
153 
154     /* This Function will whitelist Addresses for presale */
155     function whitelistAddress(address[] memory _recipients) public onlyOwner returns (bool) {
156         require(_recipients.length <= 100); //maximum receievers can be 500
157         for (uint i = 0; i < _recipients.length; i++) {
158             whitelisted[_recipients[i]] = true;
159         }
160         return true;
161     }
162 
163     /* This Function will Remove Whitelist addresss */
164     function RemoveWhitelist(address[] memory _recipients) public onlyOwner returns (bool) {
165         require(_recipients.length <= 100); //maximum receievers can be 500
166         for (uint i = 0; i < _recipients.length; i++) {
167             whitelisted[_recipients[i]] = false;
168         }
169         return true;
170     }
171     
172 
173     /* This function will deposit Tokens in the smart contract (Token must be approved first) */    
174     function depositTokens(uint256  _amount) public returns (bool) {
175         require(_amount <= Token(tokenAddr).balanceOf(msg.sender),"Token Balance of user is less");
176         require(Token(tokenAddr).transferFrom(msg.sender,address(this), _amount));
177         emit TokenDeposited(msg.sender, _amount);
178         return true;
179     }
180 
181     /* This will deposit BNB to Contract */
182     function depositCrypto() payable public returns (bool){
183         uint256 amount = msg.value;
184         address userAddress = msg.sender;
185         emit BnbDeposited(userAddress, amount);
186         return true;
187     }
188     
189     /* This Function will be used by users to claim token */
190     function claimToken() public returns (bool){
191         address userAdd = msg.sender;
192         uint256 amountToClaim = tokenExchanged[userAdd];
193         require(claim,"Cannot Claim Now");
194         require(amountToClaim>0,"There is no amount to claim");
195         require(amountToClaim <= Token(tokenAddr).balanceOf(address(this)),"Token Balance of contract is less");
196         Token(tokenAddr).transfer(userAdd, amountToClaim);
197         
198         emit TokenTransfer(userAdd, amountToClaim);
199         tokenExchanged[userAdd] = 0;
200         return true;
201     }
202     
203     /* This function will accept ETH directly sent to the address */
204     receive() payable external {
205         ExchangeBNBforToken(msg.sender, msg.value);
206     }
207 
208     /* This Function will exchange BNB to Token */    
209     function ExchangeBNBforToken(address _addr, uint256 _amount) private {
210         uint256 amount = _amount;
211         address userAdd = _addr;
212         uint256 bnbAmount = 0;
213          balances[msg.sender] = balances[msg.sender].add(msg.value);
214         
215         if(whitelist){
216             require(whitelisted[userAdd],"User is not Whitelisted");
217         }
218         require(totalHardCap < hardCap, "BNB Hardcap Reached");
219         require(balances[msg.sender] >= minContribution && balances[msg.sender] <= maxContribution,"Contribution should satisfy min max case");
220         totalTransaction.add(1);
221         totalHardCap.add(_amount);
222         bnbAmount = ((amount.mul(10 ** uint256(tokenDecimal)).div(tokenPriceBnb)).mul(10 ** uint256(tokenDecimal))).div(10 ** uint256(tokenDecimal));
223         tokenExchanged[userAdd] += bnbAmount;
224         
225         emit BnbDeposited(msg.sender,msg.value);
226     }
227 
228 
229     /* This Function will exchange BNB to Token in Mannual Call */
230     function ExchangeETHforTokenMannual() public payable {
231         uint256 amount = msg.value;
232         address userAdd = msg.sender;
233         uint256 bnbAmount = 0;
234         balances[msg.sender] = balances[msg.sender].add(msg.value);
235         
236         if(whitelist){
237             require(whitelisted[userAdd],"User is not Whitelisted");
238         }
239         require(totalHardCap < hardCap, "BNB Hardcap Reached");
240         require(balances[msg.sender] >= minContribution && balances[msg.sender] <= maxContribution,"Contribution should satisfy min max case");
241         totalTransaction.add(1);
242         totalHardCap.add(amount);
243         bnbAmount = ((amount.mul(10 ** uint256(tokenDecimal)).div(tokenPriceBnb)).mul(10 ** uint256(tokenDecimal))).div(10 ** uint256(tokenDecimal));
244         tokenExchanged[userAdd] += bnbAmount;
245         
246         emit BnbDeposited(msg.sender,msg.value);
247 
248         
249     }
250     
251     /* ONLY OWNER FUNCTIONS */
252 
253     /* This Function will be used to turn on or off whitelisting process */
254     function turnWhitelist() public onlyOwner returns (bool success)  {
255         if (whitelist) {
256             whitelist = false;
257         } else {
258             whitelist = true;
259         }
260         return true;
261         
262     }
263 
264     /* This Function will be used to turn on or off claim process */
265     function claimIn() public onlyOwner returns (bool success)  {
266         if (claim) {
267             claim = false;
268         } else {
269             claim = true;
270         }
271         return true;
272         
273     }
274     
275     /* Update Token Price */
276     function updateTokenPrice(uint256 newTokenValue) public onlyOwner {
277         tokenPriceBnb = newTokenValue;
278     }
279 
280     /* Update Hard Cap */
281     function updateHardCap(uint256 newHardcapValue) public onlyOwner {
282         hardCap = newHardcapValue;
283     }
284 
285     /* Update Min Max Contribution */
286     function updateTokenContribution(uint256 min, uint256 max) public onlyOwner {
287         minContribution = min;
288         maxContribution = max;
289     }
290     
291     /* Update Token Decimal */
292     function updateTokenDecimal(uint256 newDecimal) public onlyOwner {
293         tokenDecimal = newDecimal;
294     }
295 
296     /* Update Token Address */
297     function updateTokenAddress(address newTokenAddr) public onlyOwner {
298         tokenAddr = newTokenAddr;
299     }
300 
301     /* Withdraw Remaining token after sale */
302     function withdrawTokens(address beneficiary) public onlyOwner {
303         require(Token(tokenAddr).transfer(beneficiary, Token(tokenAddr).balanceOf(address(this))));
304     }
305 
306     /* Withdraw Crypto remaining in contract */
307     function withdrawCrypto(address payable beneficiary) public onlyOwner {
308         beneficiary.transfer(address(this).balance);
309     }
310 
311     /* ONLY OWNER FUNCTION ENDS HERE */
312 
313 
314     /* VIEW FUNCTIONS */
315 
316     /* View Token Balance */
317     function tokenBalance() public view returns (uint256){
318         return Token(tokenAddr).balanceOf(address(this));
319     }
320 
321     /* View BNB Balance */
322     function bnbBalance() public view returns (uint256){
323         return address(this).balance;
324     }
325 }