1 pragma solidity 0.4.23;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     if (a == 0) {
15       return 0;
16     }
17     c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
44     c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 /**
52  * @title MintableTokenInterface interface
53  */
54 contract MintableTokenIface {
55     function mint(address to, uint256 amount) public returns (bool);
56 }
57 
58 
59 /**
60  * @title TempusCrowdsale
61  * @dev TempusCrowdsale is a base contract for managing IQ-300 token crowdsale,
62  * allowing investors to purchase project tokens with ether.
63  */
64 contract TempusCrowdsale {
65     using SafeMath for uint256;
66 
67     // Crowdsale owners
68     mapping(address => bool) public owners;
69 
70     // The token being sold
71     MintableTokenIface public token;
72 
73     // Addresses where funds are collected
74     address[] public wallets;
75 
76     // Current phase Id
77     uint256 public currentRoundId;
78 
79     // Maximum amount of tokens this contract can mint
80     uint256 public tokensCap;
81 
82     // Amount of issued tokens
83     uint256 public tokensIssued;
84 
85     // Amount of received Ethers in wei
86     uint256 public weiRaised;
87 
88     // Minimum Deposit 0.1 ETH in wei
89     uint256 public minInvestment = 100000000000000000;
90 
91     // Crowdsale phase with its own parameters
92     struct Round {
93         uint256 startTime;
94         uint256 endTime;
95         uint256 weiRaised;
96         uint256 tokensIssued;
97         uint256 tokensCap;
98         uint256 tokenPrice;
99     }
100 
101     Round[5] public rounds;
102 
103     /**
104      * @dev TokenPurchase event emitted on token purchase
105      * @param beneficiary who got the tokens
106      * @param value weis paid for purchase
107      * @param amount amount of tokens purchased
108      */
109     event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);
110 
111     /**
112      * @dev WalletAdded event emitted on wallet add
113      * @param wallet the address of added account
114      */
115     event WalletAdded(address indexed wallet);
116 
117     /**
118      * @dev WalletRemoved event emitted on wallet deletion
119      * @param wallet the address of removed account
120      */
121     event WalletRemoved(address indexed wallet);
122 
123     /**
124      * @dev OwnerAdded event emitted on owner add
125      * @param newOwner is the address of added account
126      */
127     event OwnerAdded(address indexed newOwner);
128 
129     /**
130      * @dev OwnerRemoved event emitted on owner removal
131      * @param removedOwner is the address of removed account
132      */
133     event OwnerRemoved(address indexed removedOwner);
134 
135     /**
136      * @dev SwitchedToNextRound event triggered when contract changes its phase
137      * @param id is the index of the new phase
138      */
139     event SwitchedToNextRound(uint256 id);
140 
141     constructor(MintableTokenIface _token) public {
142         token = _token;
143         tokensCap = 100000000000000000;
144         rounds[0] = Round(now, now.add(30 * 1 days), 0, 0, 20000000000000000, 50000000);
145         rounds[1] = Round(now.add(30 * 1 days).add(1), now.add(60 * 1 days), 0, 0, 20000000000000000, 100000000);
146         rounds[2] = Round(now.add(60 * 1 days).add(1), now.add(90 * 1 days), 0, 0, 20000000000000000, 200000000);
147         rounds[3] = Round(now.add(90 * 1 days).add(1), now.add(120 * 1 days), 0, 0, 20000000000000000, 400000000);
148         rounds[4] = Round(now.add(120 * 1 days).add(1), 1599999999, 0, 0, 20000000000000000, 800000000);
149         currentRoundId = 0;
150         owners[msg.sender] = true;
151     }
152 
153     function() external payable {
154         require(msg.sender != address(0));
155         require(msg.value >= minInvestment);
156         if (now > rounds[currentRoundId].endTime) {
157             switchToNextRound();
158         }
159         uint256 tokenPrice = rounds[currentRoundId].tokenPrice;
160         uint256 tokens = msg.value.div(tokenPrice);
161         token.mint(msg.sender, tokens);
162         emit TokenPurchase(msg.sender, msg.value, tokens);
163         tokensIssued = tokensIssued.add(tokens);
164         rounds[currentRoundId].tokensIssued = rounds[currentRoundId].tokensIssued.add(tokens);
165         weiRaised = weiRaised.add(msg.value);
166         rounds[currentRoundId].weiRaised = rounds[currentRoundId].weiRaised.add(msg.value);
167         if (rounds[currentRoundId].tokensIssued >= rounds[currentRoundId].tokensCap) {
168             switchToNextRound();
169         }
170         forwardFunds();
171     }
172 
173     /**
174      * @dev switchToNextRound sets the startTime, endTime and tokenCap of the next phase
175      * and sets the next phase as current phase.
176      */
177     function switchToNextRound() public {
178         uint256 prevRoundId = currentRoundId;
179         uint256 nextRoundId = currentRoundId + 1;
180         require(nextRoundId < rounds.length);
181         rounds[prevRoundId].endTime = now;
182         rounds[nextRoundId].startTime = now + 1;
183         rounds[nextRoundId].endTime = now + 30;
184         if (nextRoundId == rounds.length - 1) {
185             rounds[nextRoundId].tokensCap = tokensCap.sub(tokensIssued);
186         } else {
187             rounds[nextRoundId].tokensCap = tokensCap.sub(tokensIssued).div(5);
188         }
189         currentRoundId = nextRoundId;
190         emit SwitchedToNextRound(currentRoundId);
191     }
192 
193     /**
194      * @dev Add collecting wallet address to the list
195      * @param _address Address of the wallet
196      */
197     function addWallet(address _address) public onlyOwner {
198         require(_address != address(0));
199         for (uint256 i = 0; i < wallets.length; i++) {
200             require(_address != wallets[i]);
201         }
202         wallets.push(_address);
203         emit WalletAdded(_address);
204     }
205 
206     /**
207      * @dev Delete wallet by its index
208      * @param index Index of the wallet in the list
209      */
210     function delWallet(uint256 index) public onlyOwner {
211         require(index < wallets.length);
212         address walletToRemove = wallets[index];
213         for (uint256 i = index; i < wallets.length - 1; i++) {
214             wallets[i] = wallets[i + 1];
215         }
216         wallets.length--;
217         emit WalletRemoved(walletToRemove);
218     }
219 
220     /**
221      * @dev Adds administrative role to address
222      * @param _address The address that will get administrative privileges
223      */
224     function addOwner(address _address) public onlyOwner {
225         owners[_address] = true;
226         emit OwnerAdded(_address);
227     }
228 
229     /**
230      * @dev Removes administrative role from address
231      * @param _address The address to remove administrative privileges from
232      */
233     function delOwner(address _address) public onlyOwner {
234         owners[_address] = false;
235         emit OwnerRemoved(_address);
236     }
237 
238     /**
239      * @dev Throws if called by any account other than the owner.
240      */
241     modifier onlyOwner() {
242         require(owners[msg.sender]);
243         _;
244     }
245 
246     /**
247      * @dev forwardFunds splits received funds ~equally between wallets
248      * and sends receiwed ethers to them.
249      */
250     function forwardFunds() internal {
251         uint256 value = msg.value.div(wallets.length);
252         uint256 rest = msg.value.sub(value.mul(wallets.length));
253         for (uint256 i = 0; i < wallets.length - 1; i++) {
254             wallets[i].transfer(value);
255         }
256         wallets[wallets.length - 1].transfer(value + rest);
257     }
258 }