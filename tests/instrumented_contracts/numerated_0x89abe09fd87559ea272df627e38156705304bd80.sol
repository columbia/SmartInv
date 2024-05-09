1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error.
6  */
7 library SafeMath {
8     // Multiplies two numbers, throws on overflow./
9     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
10         if (a == 0) return 0;
11         c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15     // Integer division of two numbers, truncating the quotient.
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         return a / b;
18     }
19     // Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24     // Adds two numbers, throws on overflow.
25     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
26         c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 
33 /**
34  * @title Smart-Mining 'mining-pool & token-distribution'-contract - https://smart-mining.io - mail@smart-mining.io
35  */
36 contract SmartMining {
37     using SafeMath for uint256;
38     
39     // -------------------------------------------------------------------------
40     // Variables
41     // -------------------------------------------------------------------------
42     
43     string  constant public name     = "smart-mining.io"; // EIP-20
44     string  constant public symbol   = "SMT";             // EIP-20
45     uint8   constant public decimals = 18;                // EIP-20
46     uint256 public totalSupply       = 10000;             // EIP-20
47     
48     struct Member {                                       // 'Member'-struct
49         bool    crowdsalePrivateSale;                     // If 'true', member can participate in crowdsale before crowdsaleOpen == true
50         uint256 crowdsaleMinPurchase;                     // Approved minimum crowdsale purchase in Wei
51         uint256 balance;                                  // Token balance in Ici, represents the percent of mining profits
52         uint256 unpaid;                                   // Available Wei for withdrawal, + 1 in storage for gas optimization and indicator if address is member of SmartMining contract
53     }                                                  
54     mapping (address => Member) public members;           // All Crowdsale members as 'Member'-struct
55     
56     uint16    public memberCount;                         // Count of all SmartMining members inclusive the team-contract
57     address[] public memberIndex;                         // Lookuptable of all member addresses to iterate on deposit over and assign unpaid Ether to members
58     address   public owner;                               // Owner of this contract
59     address   public withdrawer;                          // Allowed executor of automatic processed member whitdrawals (SmartMining-API)
60     address   public depositor;                           // Allowed depositor of mining profits
61     
62     bool      public crowdsaleOpen;                       // 'true' if crowdsale is open for investors
63     bool      public crowdsaleFinished;                   // 'true' after crowdsaleCap was reached
64     address   public crowdsaleWallet;                     // Address where crowdsale funds are collected
65     uint256   public crowdsaleCap;                        // Wei after crowdsale is finished
66     uint256   public crowdsaleRaised;                     // Amount of wei raised in crowdsale
67     
68     
69     // -------------------------------------------------------------------------
70     // Constructor
71     // -------------------------------------------------------------------------
72     
73     constructor (uint256 _crowdsaleCapEth, address _crowdsaleWallet, address _teamContract, uint256 _teamShare, address _owner) public {
74         require(_crowdsaleCapEth != 0 && _crowdsaleWallet != 0x0 && _teamContract != 0x0 && _teamShare != 0 && _owner != 0x0);
75         
76         // Initialize contract owner and trigger 'SetOwner'-event
77         owner = _owner;
78         emit SetOwner(owner);
79         
80         // Update totalSupply with the decimal amount
81         totalSupply = totalSupply.mul(10 ** uint256(decimals));
82         
83         // Convert '_crowdsaleCapEth' from Ether to Wei
84         crowdsaleCap = _crowdsaleCapEth.mul(10 ** 18);
85         
86         // Initialize withdrawer and crowdsaleWallet
87         withdrawer = msg.sender;
88         crowdsaleWallet = _crowdsaleWallet;
89         
90         // Assign totalSupply to contract address and trigger 'from 0x0'-'Transfer'-event for token creation
91         members[address(this)].balance = totalSupply;
92         emit Transfer(0x0, address(this), totalSupply);
93         
94         // Initialize team-contract
95         members[_teamContract].unpaid = 1;
96         memberIndex.push(_teamContract); // memberIndex[0] will become team-contract address
97         memberCount++;
98         
99         // Transfer team tokens
100         uint256 teamTokens = totalSupply.mul(_teamShare).div(100);
101         members[address(this)].balance = members[address(this)].balance.sub(teamTokens);
102         members[_teamContract].balance = teamTokens;
103         emit Transfer(address(this), _teamContract, teamTokens);
104     }
105     
106     
107     // -------------------------------------------------------------------------
108     // Events
109     // -------------------------------------------------------------------------
110     
111     event SetOwner(address indexed owner);
112     event SetDepositor(address indexed depositor);
113     event SetWithdrawer(address indexed withdrawer);
114     event SetTeamContract(address indexed teamContract);
115     event Approve(address indexed member, uint256 crowdsaleMinPurchase, bool privateSale);
116     event Participate(address indexed member, uint256 value, uint256 tokens);
117     event Transfer(address indexed from, address indexed to, uint256 value);
118     event ForwardCrowdsaleFunds(address indexed to, uint256 value);
119     event CrowdsaleStarted(bool value);
120     event CrowdsaleFinished(bool value);
121     event Withdraw(address indexed member, uint256 value);
122     event Deposit(address indexed from, uint256 value);
123     
124     
125     // -------------------------------------------------------------------------
126     // WITHDRAWER (SmartMining-API) & OWNER ONLY external maintenance interface
127     // -------------------------------------------------------------------------
128     
129     function approve (address _beneficiary, uint256 _ethMinPurchase, bool _privateSale) external {
130         require(msg.sender == owner || msg.sender == withdrawer, "Only SmartMining-API and contract owner allowed to approve.");
131         require(crowdsaleFinished == false, "No new approvals after crowdsale finished.");
132         require(_beneficiary != 0x0);
133         
134         if( members[_beneficiary].unpaid == 1 ) {
135             members[_beneficiary].crowdsaleMinPurchase = _ethMinPurchase.mul(10 ** 18);
136             members[_beneficiary].crowdsalePrivateSale = _privateSale;
137         } else {
138             members[_beneficiary].unpaid = 1;
139             members[_beneficiary].crowdsaleMinPurchase = _ethMinPurchase.mul(10 ** 18);
140             members[_beneficiary].crowdsalePrivateSale = _privateSale;
141             
142             memberIndex.push(_beneficiary);
143             memberCount++;
144         }
145         
146         emit Approve(_beneficiary, members[_beneficiary].crowdsaleMinPurchase, _privateSale);
147     }
148     
149     
150     // -------------------------------------------------------------------------
151     // OWNER ONLY external maintenance interface
152     // -------------------------------------------------------------------------
153     
154     modifier onlyOwner () {
155         require(msg.sender == owner);
156         _;
157     }
158     
159     function setTeamContract (address _newTeamContract) external onlyOwner {
160         require(_newTeamContract != 0x0 && _newTeamContract != memberIndex[0]);
161         
162         // Move team-contract member to new addresss
163         members[_newTeamContract] = members[memberIndex[0]];
164         delete members[memberIndex[0]];
165         
166         // Trigger 'SetTeamContract' & 'Transfer'-event for token movement
167         emit SetTeamContract(_newTeamContract);
168         emit Transfer(memberIndex[0], _newTeamContract, members[_newTeamContract].balance);
169         
170         // Update memberIndex[0] to new team-contract address
171         memberIndex[0] = _newTeamContract;
172     }
173     
174     function setOwner (address _newOwner) external onlyOwner {
175         if( _newOwner != 0x0 ) { owner = _newOwner; } else { owner = msg.sender; }
176         emit SetOwner(owner);
177     }
178     
179     function setDepositor (address _newDepositor) external onlyOwner {
180         depositor = _newDepositor;
181         emit SetDepositor(_newDepositor);
182     }
183     
184     function setWithdrawer (address _newWithdrawer) external onlyOwner {
185         withdrawer = _newWithdrawer;
186         emit SetWithdrawer(_newWithdrawer);
187     }
188     
189     function startCrowdsale () external onlyOwner {
190         require(crowdsaleFinished == false, "Crowdsale can only be started once.");
191         
192         crowdsaleOpen = true;
193         emit CrowdsaleStarted(true);
194     }
195     
196     function cleanupMember (uint256 _memberIndex) external onlyOwner {
197         require(members[memberIndex[_memberIndex]].unpaid == 1, "Not a member.");
198         require(members[memberIndex[_memberIndex]].balance == 0, "Only members without participation can be deleted.");
199         
200         // Delete whitelisted member which not participated in crowdsale
201         delete members[memberIndex[_memberIndex]];
202         memberIndex[_memberIndex] = memberIndex[memberIndex.length-1];
203         memberIndex.length--;
204         memberCount--;
205     }
206     
207     
208     // -------------------------------------------------------------------------
209     // Public external interface
210     // -------------------------------------------------------------------------
211     
212     function () external payable {
213         require(crowdsaleOpen || members[msg.sender].crowdsalePrivateSale || crowdsaleFinished, "smart-mining.io crowdsale not started yet.");
214         
215         if(crowdsaleFinished)
216             deposit();
217         if(crowdsaleOpen || members[msg.sender].crowdsalePrivateSale)
218             participate();
219     }
220     
221     function deposit () public payable {
222         // Pre validate deposit
223         require(crowdsaleFinished, "Deposits only possible after crowdsale finished.");
224         require(msg.sender == depositor, "Only 'depositor' allowed to deposit.");
225         require(msg.value >= 10**9, "Minimum deposit 1 gwei.");
226         
227         // Distribute deposited Ether to all SmartMining members related to their profit-share which is representat by their ICE token balance
228         for (uint i=0; i<memberIndex.length; i++) {
229             members[memberIndex[i]].unpaid = 
230                 // Adding current deposit to members unpaid Wei amount
231                 members[memberIndex[i]].unpaid.add(
232                     // MemberTokenBalance * DepositedWei / totalSupply = WeiAmount of member-share to be added to members unpaid holdings
233                     members[memberIndex[i]].balance.mul(msg.value).div(totalSupply)
234                 );
235         }
236         
237         // Trigger 'Deposit'-event
238         emit Deposit(msg.sender, msg.value);
239     }
240     
241     function participate () public payable {
242         // Pre validate purchase
243         require(members[msg.sender].unpaid == 1, "Only whitelisted members are allowed to participate!");
244         require(crowdsaleOpen || members[msg.sender].crowdsalePrivateSale, "Crowdsale is not open.");
245         require(msg.value != 0, "No Ether attached to this buy order.");
246         require(members[msg.sender].crowdsaleMinPurchase == 0 || msg.value >= members[msg.sender].crowdsaleMinPurchase,
247             "Send at least your whitelisted crowdsaleMinPurchase Ether amount!");
248             
249         // Get token count and validate that enaugh tokens are available
250         uint256 tokens = crowdsaleCalcTokenAmount(msg.value);
251         require(members[address(this)].balance >= tokens, "There are not enaugh Tokens left for this order.");
252         emit Participate(msg.sender, msg.value, tokens);
253         
254         // Remove members crowdsaleMinPurchase for further orders
255         members[msg.sender].crowdsaleMinPurchase = 0;
256         
257         // Subtract tokens from contract and add tokens to members current holdings (Transfer)
258         members[address(this)].balance = members[address(this)].balance.sub(tokens);
259         members[msg.sender].balance = members[msg.sender].balance.add(tokens);
260         emit Transfer(address(this), msg.sender, tokens);
261         
262         // Update crowdsale states
263         crowdsaleRaised = crowdsaleRaised.add(msg.value);
264         if(members[address(this)].balance == 0) {
265             // Close crowdsale if all tokens are sold out
266             crowdsaleOpen = false;
267             crowdsaleFinished = true;
268             emit CrowdsaleFinished(true);
269         }
270         
271         // Forward msg.value (attached Ether) to crowdsaleWallet and trigger 'ForwardCrowdsaleFunds'-event
272         emit ForwardCrowdsaleFunds(crowdsaleWallet, msg.value);
273         crowdsaleWallet.transfer(msg.value);
274     }
275     
276     function crowdsaleCalcTokenAmount (uint256 _weiAmount) public view returns (uint256) {
277         // Multiplied by totalSupply to avoid floats in calculation
278         return 
279             // _weiAmount * totalSupply / crowdsaleCap * crowdsaleSupply / totalSupply
280             _weiAmount
281             .mul(totalSupply)
282             .div(crowdsaleCap)
283             .mul( totalSupply.sub(members[memberIndex[0]].balance) )
284             .div(totalSupply);
285     }
286     
287     function withdrawOf              (address _beneficiary) external                      { _withdraw(_beneficiary); }
288     function withdraw                ()                     external                      { _withdraw(msg.sender); }
289     function balanceOf               (address _beneficiary) public view returns (uint256) { return members[_beneficiary].balance; }
290     function unpaidOf                (address _beneficiary) public view returns (uint256) { return members[_beneficiary].unpaid.sub(1); }
291     function crowdsaleIsMemberOf     (address _beneficiary) public view returns (bool)    { return members[_beneficiary].unpaid >= 1; }
292     function crowdsaleRemainingWei   ()                     public view returns (uint256) { return crowdsaleCap.sub(crowdsaleRaised); }
293     function crowdsaleRemainingToken ()                     public view returns (uint256) { return members[address(this)].balance; }
294     function crowdsalePercentOfTotalSupply ()               public view returns (uint256) { return totalSupply.sub(members[memberIndex[0]].balance).mul(100).div(totalSupply); }
295     
296     
297     // -------------------------------------------------------------------------
298     // Private functions, can only be called by this contract
299     // -------------------------------------------------------------------------
300     
301     function _withdraw (address _beneficiary) private {
302         // Pre-validate withdrawal
303         if(msg.sender != _beneficiary) {
304             require(msg.sender == owner || msg.sender == withdrawer, "Only 'owner' and 'withdrawer' can withdraw for other members.");
305         }
306         require(members[_beneficiary].unpaid >= 1, "Not a member account.");
307         require(members[_beneficiary].unpaid > 1, "No unpaid balance on account.");
308         
309         // Remember members unpaid amount but remove it from his contract holdings before initiating the withdrawal for security reasons
310         uint256 unpaid = members[_beneficiary].unpaid.sub(1);
311         members[_beneficiary].unpaid = 1;
312         
313         // Trigger 'Withdraw'-event
314         emit Withdraw(_beneficiary, unpaid);
315         
316         // Transfer the unpaid Wei amount to member address
317         if(_beneficiary != memberIndex[0]) {
318             // Client withdrawals rely on the 'gas stipend' (2300 gas) which has been checked during KYC
319             _beneficiary.transfer(unpaid);
320         } else {
321             // Team-contract withdrawals obtain up to 100 times more gas for further automatic processing
322             require( _beneficiary.call.gas(230000).value(unpaid)() );
323         }
324     }
325     
326     
327 }