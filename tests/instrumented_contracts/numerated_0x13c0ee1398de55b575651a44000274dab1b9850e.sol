1 /**
2  * @title Ownable Contract
3  * @dev contract that has a user and can implement user access restrictions based on it
4  */
5 pragma solidity 0.4.21;
6 
7 contract Ownable {
8 
9   address public owner;
10 
11   /**
12    * @dev sets owner of contract
13    */
14   function Ownable() public {
15     owner = msg.sender;
16   }
17 
18   /**
19    * @dev changes owner of contract
20    * @param newOwner New owner
21    */
22   function changeOwner(address newOwner) public ownerOnly {
23     require(newOwner != address(0));
24     owner = newOwner;
25   }
26 
27   /**
28    * @dev Throws if called by other account than owner
29    */
30   modifier ownerOnly() {
31     require(msg.sender == owner);
32     _;
33   }
34 }
35 
36 /**
37  * @title Emergency Safety contract
38  * @dev Allows token and ether drain and pausing of contract
39  */ 
40 contract EmergencySafe is Ownable{ 
41 
42   event PauseToggled(bool isPaused);
43 
44   bool public paused;
45 
46 
47   /**
48    * @dev Throws if contract is paused
49    */
50   modifier isNotPaused() {
51     require(!paused);
52     _;
53   }
54 
55   /**
56    * @dev Throws if contract is not paused
57    */
58   modifier isPaused() {
59     require(paused);
60     _; 
61   }
62 
63   /**
64    * @dev Initialises contract to non-paused
65    */
66   function EmergencySafe() public {
67     paused = false;
68   }
69 
70   /**
71    * @dev Allows draining of tokens (to owner) that might accidentally be sent to this address
72    * @param token Address of ERC20 token
73    * @param amount Amount to drain
74    */
75   function emergencyERC20Drain(ERC20Interface token, uint amount) public ownerOnly{
76     token.transfer(owner, amount);
77   }
78 
79   /**
80    * @dev Allows draining of Ether
81    * @param amount Amount to drain
82    */
83   function emergencyEthDrain(uint amount) public ownerOnly returns (bool){
84     return owner.send(amount);
85   }
86 
87   /**
88    * @dev Switches the contract from paused to non-paused or vice-versa
89    */
90   function togglePause() public ownerOnly {
91     paused = !paused;
92     emit PauseToggled(paused);
93   }
94 }
95 
96 
97 /**
98  * @title Upgradeable Conract
99  * @dev contract that implements doubly linked list to keep track of old and new 
100  * versions of this contract
101  */ 
102 contract Upgradeable is Ownable{
103 
104   address public lastContract;
105   address public nextContract;
106   bool public isOldVersion;
107   bool public allowedToUpgrade;
108 
109   /**
110    * @dev makes contract upgradeable 
111    */
112   function Upgradeable() public {
113     allowedToUpgrade = true;
114   }
115 
116   /**
117    * @dev signals that new upgrade is available, contract must be most recent 
118    * upgrade and allowed to upgrade
119    * @param newContract Address of upgraded contract 
120    */
121   function upgradeTo(Upgradeable newContract) public ownerOnly{
122     require(allowedToUpgrade && !isOldVersion);
123     nextContract = newContract;
124     isOldVersion = true;
125     newContract.confirmUpgrade();   
126   }
127 
128   /**
129    * @dev confirmation that this is indeed the next version,
130    * called from previous version of contract. Anyone can call this function,
131    * which basically makes this instance unusable if that happens. Once called,
132    * this contract can not serve as upgrade to another contract. Not an ideal solution
133    * but will work until we have a more sophisticated approach using a dispatcher or similar
134    */
135   function confirmUpgrade() public {
136     require(lastContract == address(0));
137     lastContract = msg.sender;
138   }
139 }
140 
141 /**
142  * @title Validator Contract
143  * @dev validated that contract has been created through IXlegder
144  */ 
145 contract Validator is Ownable, EmergencySafe, Upgradeable{
146 
147   mapping(address => bool) private valid_contracts;
148   string public whoAmI;
149 
150   function Validator(string _whoAmI) public {
151     whoAmI = _whoAmI;
152   }
153 
154   /**
155    * @dev adds validated contract
156    * @param addr Address of contract that's validated
157    */
158   function add(address addr) public ownerOnly {
159     valid_contracts[addr] = true;
160   }
161 
162   /**
163    * @dev removes validated contract
164    * @param addr Address of contract to be removed 
165    */
166   function remove(address addr) public ownerOnly {
167     valid_contracts[addr] = false;
168   }
169 
170   /**
171    * @dev checks whether contract is valid 
172    * @param addr Address of contract to be ckecked
173    */
174   function validate(address addr) public view returns (bool) {
175     return valid_contracts[addr];
176   }
177 }
178 
179 /**
180  * @title IXT payment contract in charge of administaring IXT payments 
181  * @dev contract looks up price for appropriate tasks and sends transferFrom() for user,
182  * user must approve this contract to spend IXT for them before being able to use it
183  */ 
184 contract IXTPaymentContract is Ownable, EmergencySafe, Upgradeable{
185 
186   event IXTPayment(address indexed from, address indexed to, uint value, string indexed action);
187 
188   ERC20Interface public tokenContract;
189 
190   mapping(string => uint) private actionPrices;
191   mapping(address => bool) private allowed;
192 
193   /**
194    * @dev Throws if called by non-allowed contract
195    */
196   modifier allowedOnly() {
197     require(allowed[msg.sender] || msg.sender == owner);
198     _;
199   }
200 
201   /**
202    * @dev sets up token address of IXT token
203    * adds owner to allowds, if owner is changed in the future, remember to remove old
204    * owner if desired
205    * @param tokenAddress IXT token address
206    */
207   function IXTPaymentContract(address tokenAddress) public {
208     tokenContract = ERC20Interface(tokenAddress);
209     allowed[owner] = true;
210   }
211 
212   /**
213    * @dev transfers IXT 
214    * @param from User address
215    * @param to Recipient
216    * @param action Service the user is paying for 
217    */
218   function transferIXT(address from, address to, string action) public allowedOnly isNotPaused returns (bool) {
219     if (isOldVersion) {
220       IXTPaymentContract newContract = IXTPaymentContract(nextContract);
221       return newContract.transferIXT(from, to, action);
222     } else {
223       uint price = actionPrices[action];
224 
225       if(price != 0 && !tokenContract.transferFrom(from, to, price)){
226         return false;
227       } else {
228         emit IXTPayment(from, to, price, action);     
229         return true;
230       }
231     }
232   }
233 
234   /**
235    * @dev sets new token address in case of update
236    * @param erc20Token Token address
237    */
238   function setTokenAddress(address erc20Token) public ownerOnly isNotPaused {
239     tokenContract = ERC20Interface(erc20Token);
240   }
241 
242   /**
243    * @dev creates/updates action
244    * @param action Action to be paid for 
245    * @param price Price (in units * 10 ^ (<decimal places of token>))
246    */
247   function setAction(string action, uint price) public ownerOnly isNotPaused {
248     actionPrices[action] = price;
249   }
250 
251   /**
252    * @dev retrieves price for action
253    * @param action Name of action, e.g. 'create_insurance_contract'
254    */
255   function getActionPrice(string action) public view returns (uint) {
256     return actionPrices[action];
257   }
258 
259 
260   /**
261    * @dev add account to allow calling of transferIXT
262    * @param allowedAddress Address of account 
263    */
264   function setAllowed(address allowedAddress) public ownerOnly {
265     allowed[allowedAddress] = true;
266   }
267 
268   /**
269    * @dev remove account from allowed accounts
270    * @param allowedAddress Address of account 
271    */
272   function removeAllowed(address allowedAddress) public ownerOnly {
273     allowed[allowedAddress] = false;
274   }
275 }
276 
277 contract ERC20Interface {
278     uint public totalSupply;
279     function balanceOf(address tokenOwner) public constant returns (uint balance);
280     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
281     function transfer(address to, uint tokens) public returns (bool success);
282     function approve(address spender, uint tokens) public returns (bool success);
283     function transferFrom(address from, address to, uint tokens) public returns (bool success);
284 
285     event Transfer(address indexed from, address indexed to, uint tokens);
286     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
287 }