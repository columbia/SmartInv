1 pragma solidity 0.4.21;
2 /**
3  * @title Ownable Contract
4  * @dev contract that has a user and can implement user access restrictions based on it
5  */
6 contract Ownable {
7 
8   address public owner;
9 
10   /**
11    * @dev sets owner of contract
12    */
13   function Ownable() public {
14     owner = msg.sender;
15   }
16 
17   /**
18    * @dev changes owner of contract
19    * @param newOwner New owner
20    */
21   function changeOwner(address newOwner) public ownerOnly {
22     require(newOwner != address(0));
23     owner = newOwner;
24   }
25 
26   /**
27    * @dev Throws if called by other account than owner
28    */
29   modifier ownerOnly() {
30     require(msg.sender == owner);
31     _;
32   }
33 }
34 
35 /**
36  * @title Emergency Safety contract
37  * @dev Allows token and ether drain and pausing of contract
38  */ 
39 contract EmergencySafe is Ownable{ 
40 
41   event PauseToggled(bool isPaused);
42 
43   bool public paused;
44 
45 
46   /**
47    * @dev Throws if contract is paused
48    */
49   modifier isNotPaused() {
50     require(!paused);
51     _;
52   }
53 
54   /**
55    * @dev Throws if contract is not paused
56    */
57   modifier isPaused() {
58     require(paused);
59     _; 
60   }
61 
62   /**
63    * @dev Initialises contract to non-paused
64    */
65   function EmergencySafe() public {
66     paused = false;
67   }
68 
69   /**
70    * @dev Allows draining of tokens (to owner) that might accidentally be sent to this address
71    * @param token Address of ERC20 token
72    * @param amount Amount to drain
73    */
74   function emergencyERC20Drain(ERC20Interface token, uint amount) public ownerOnly{
75     token.transfer(owner, amount);
76   }
77 
78   /**
79    * @dev Allows draining of Ether
80    * @param amount Amount to drain
81    */
82   function emergencyEthDrain(uint amount) public ownerOnly returns (bool){
83     return owner.send(amount);
84   }
85 
86   /**
87    * @dev Switches the contract from paused to non-paused or vice-versa
88    */
89   function togglePause() public ownerOnly {
90     paused = !paused;
91     emit PauseToggled(paused);
92   }
93 }
94 
95 
96 /**
97  * @title Upgradeable Conract
98  * @dev contract that implements doubly linked list to keep track of old and new 
99  * versions of this contract
100  */ 
101 contract Upgradeable is Ownable{
102 
103   address public lastContract;
104   address public nextContract;
105   bool public isOldVersion;
106   bool public allowedToUpgrade;
107 
108   /**
109    * @dev makes contract upgradeable 
110    */
111   function Upgradeable() public {
112     allowedToUpgrade = true;
113   }
114 
115   /**
116    * @dev signals that new upgrade is available, contract must be most recent 
117    * upgrade and allowed to upgrade
118    * @param newContract Address of upgraded contract 
119    */
120   function upgradeTo(Upgradeable newContract) public ownerOnly{
121     require(allowedToUpgrade && !isOldVersion);
122     nextContract = newContract;
123     isOldVersion = true;
124     newContract.confirmUpgrade();   
125   }
126 
127   /**
128    * @dev confirmation that this is indeed the next version,
129    * called from previous version of contract. Anyone can call this function,
130    * which basically makes this instance unusable if that happens. Once called,
131    * this contract can not serve as upgrade to another contract. Not an ideal solution
132    * but will work until we have a more sophisticated approach using a dispatcher or similar
133    */
134   function confirmUpgrade() public {
135     require(lastContract == address(0));
136     lastContract = msg.sender;
137   }
138 }
139 
140 /**
141  * @title IXT payment contract in charge of administaring IXT payments 
142  * @dev contract looks up price for appropriate tasks and sends transferFrom() for user,
143  * user must approve this contract to spend IXT for them before being able to use it
144  */ 
145 contract IXTPaymentContract is Ownable, EmergencySafe, Upgradeable{
146 
147   event IXTPayment(address indexed from, address indexed to, uint value, string indexed action);
148 
149   ERC20Interface public tokenContract;
150 
151   mapping(string => uint) private actionPrices;
152   mapping(address => bool) private allowed;
153 
154   /**
155    * @dev Throws if called by non-allowed contract
156    */
157   modifier allowedOnly() {
158     require(allowed[msg.sender] || msg.sender == owner);
159     _;
160   }
161 
162   /**
163    * @dev sets up token address of IXT token
164    * adds owner to allowds, if owner is changed in the future, remember to remove old
165    * owner if desired
166    * @param tokenAddress IXT token address
167    */
168   function IXTPaymentContract(address tokenAddress) public {
169     tokenContract = ERC20Interface(tokenAddress);
170     allowed[owner] = true;
171   }
172 
173   /**
174    * @dev transfers IXT 
175    * @param from User address
176    * @param to Recipient
177    * @param action Service the user is paying for 
178    */
179   function transferIXT(address from, address to, string action) public allowedOnly isNotPaused returns (bool) {
180     if (isOldVersion) {
181       IXTPaymentContract newContract = IXTPaymentContract(nextContract);
182       return newContract.transferIXT(from, to, action);
183     } else {
184       uint price = actionPrices[action];
185 
186       if(price != 0 && !tokenContract.transferFrom(from, to, price)){
187         return false;
188       } else {
189         emit IXTPayment(from, to, price, action);     
190         return true;
191       }
192     }
193   }
194 
195   /**
196    * @dev sets new token address in case of update
197    * @param erc20Token Token address
198    */
199   function setTokenAddress(address erc20Token) public ownerOnly isNotPaused {
200     tokenContract = ERC20Interface(erc20Token);
201   }
202 
203   /**
204    * @dev creates/updates action
205    * @param action Action to be paid for 
206    * @param price Price (in units * 10 ^ (<decimal places of token>))
207    */
208   function setAction(string action, uint price) public ownerOnly isNotPaused {
209     actionPrices[action] = price;
210   }
211 
212   /**
213    * @dev retrieves price for action
214    * @param action Name of action, e.g. 'create_insurance_contract'
215    */
216   function getActionPrice(string action) public view returns (uint) {
217     return actionPrices[action];
218   }
219 
220 
221   /**
222    * @dev add account to allow calling of transferIXT
223    * @param allowedAddress Address of account 
224    */
225   function setAllowed(address allowedAddress) public ownerOnly {
226     allowed[allowedAddress] = true;
227   }
228 
229   /**
230    * @dev remove account from allowed accounts
231    * @param allowedAddress Address of account 
232    */
233   function removeAllowed(address allowedAddress) public ownerOnly {
234     allowed[allowedAddress] = false;
235   }
236 }
237 
238 contract ERC20Interface {
239     uint public totalSupply;
240     function balanceOf(address tokenOwner) public constant returns (uint balance);
241     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
242     function transfer(address to, uint tokens) public returns (bool success);
243     function approve(address spender, uint tokens) public returns (bool success);
244     function transferFrom(address from, address to, uint tokens) public returns (bool success);
245 
246     event Transfer(address indexed from, address indexed to, uint tokens);
247     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
248 }