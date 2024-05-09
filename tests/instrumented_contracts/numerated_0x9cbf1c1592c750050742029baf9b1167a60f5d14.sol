1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * @title Ownable
38  * @dev The Ownable contract has an owner address, and provides basic authorization control
39  * functions, this simplifies the implementation of "user permissions".
40  */
41 contract Ownable {
42   address public owner;
43 
44 
45   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47 
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   function Ownable() public {
53     owner = msg.sender;
54   }
55 
56 
57   /**
58    * @dev Throws if called by any account other than the owner.
59    */
60   modifier onlyOwner() {
61     require(msg.sender == owner);
62     _;
63   }
64 
65 
66   /**
67    * @dev Allows the current owner to transfer control of the contract to a newOwner.
68    * @param newOwner The address to transfer ownership to.
69    */
70   function transferOwnership(address newOwner) public onlyOwner {
71     require(newOwner != address(0));
72     OwnershipTransferred(owner, newOwner);
73     owner = newOwner;
74   }
75 
76 }
77 
78 /**
79  * @title ERC20Basic
80  * @dev Simpler version of ERC20 interface
81  * @dev see https://github.com/ethereum/EIPs/issues/179
82  */
83 contract ERC20Basic {
84   uint256 public totalSupply;
85   function balanceOf(address who) public view returns (uint256);
86   function transfer(address to, uint256 value) public returns (bool);
87   event Transfer(address indexed from, address indexed to, uint256 value);
88 }
89 
90 contract ALT1Token is Ownable, ERC20Basic {
91   using SafeMath for uint256;
92 
93   string public constant name     = "Altair VR presale token";
94   string public constant symbol   = "ALT1";
95   uint8  public constant decimals = 18;
96 
97   bool public mintingFinished = false;
98 
99   mapping(address => uint256) public balances;
100   address[] public holders;
101 
102   event Mint(address indexed to, uint256 amount);
103   event MintFinished();
104 
105   /**
106   * @dev Function to mint tokens
107   * @param _to The address that will receive the minted tokens.
108   * @param _amount The amount of tokens to mint.
109   * @return A boolean that indicates if the operation was successful.
110   */
111   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
112     totalSupply = totalSupply.add(_amount);
113     if (balances[_to] == 0) { 
114       holders.push(_to);
115     }
116     balances[_to] = balances[_to].add(_amount);
117 
118     Mint(_to, _amount);
119     Transfer(address(0), _to, _amount);
120     return true;
121   }
122 
123   /**
124   * @dev Function to stop minting new tokens.
125   * @return True if the operation was successful.
126   */
127   function finishMinting() onlyOwner canMint public returns (bool) {
128     mintingFinished = true;
129     MintFinished();
130     return true;
131   }
132 
133   /**
134   * @dev Current token is not transferred.
135   * After start official token sale ALT, you can exchange your ALT1 to ALT
136   */
137   function transfer(address, uint256) public returns (bool) {
138     revert();
139     return false;
140   }
141 
142   /**
143   * @dev Gets the balance of the specified address.
144   * @param _owner The address to query the the balance of.
145   * @return An uint256 representing the amount owned by the passed address.
146   */
147   function balanceOf(address _owner) public view returns (uint256 balance) {
148     return balances[_owner];
149   }
150 
151   modifier canMint() {
152     require(!mintingFinished);
153     _;
154   }
155 }
156 
157 /**
158  * @title Crowdsale ALT1 presale token
159  */
160 
161 contract Crowdsale is Ownable {
162   using SafeMath for uint256;
163 
164   uint256   public constant rate = 10000;                  // How many token units a buyer gets per wei
165   uint256   public constant cap = 80000000 ether;          // Maximum amount of funds
166 
167   bool      public isFinalized = false;
168 
169   uint256   public endTime = 1525046400;                  // End timestamps where investments are allowed
170                                                           // 30-Apr-18 00:00:00 UTC
171 
172   ALT1Token     public token;                                 // ALT1 token itself
173   ALT1Token     public oldToken;                              // Old ALT1 token for balance converting
174   address       public wallet;                                // Wallet of funds
175   uint256       public weiRaised;                             // Amount of raised money in wei
176 
177   uint256   public firstBonus = 35;
178   uint256   public secondBonus = 70;
179 
180   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
181   event Finalized();
182 
183   function Crowdsale (ALT1Token _ALT1, ALT1Token _OldALT1, address _wallet) public {
184     assert(address(_ALT1) != address(0));
185     assert(address(_OldALT1) != address(0));
186     assert(_wallet != address(0));
187     assert(endTime > now);
188     assert(rate > 0);
189     assert(cap > 0);
190 
191     token = _ALT1;
192     oldToken = _OldALT1;
193 
194     wallet = _wallet;
195   }
196 
197   function () public payable {
198     buyTokens(msg.sender);
199   }
200 
201   function buyTokens(address beneficiary) public payable {
202     require(beneficiary != address(0));
203     require(validPurchase());
204 
205     uint256 weiAmount = msg.value;
206     uint256 tokens = tokensForWei(weiAmount);
207     
208     weiRaised = weiRaised.add(weiAmount);
209 
210     token.mint(beneficiary, tokens);
211     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
212 
213     forwardFunds();
214   }
215 
216   function getBonus(uint256 _tokens, uint256 _weiAmount) public view returns (uint256) {
217     if (_weiAmount >= 50 ether) {
218       return _tokens.mul(secondBonus).div(100);
219     }
220     return _tokens.mul(firstBonus).div(100);
221   }
222 
223   function setFirstBonus(uint256 _newBonus) onlyOwner public {
224     firstBonus = _newBonus;
225   }
226 
227   function setSecondBonus(uint256 _newBonus) onlyOwner public {
228     secondBonus = _newBonus;
229   }
230 
231   function changeEndTime(uint256 _endTime) onlyOwner public {
232     require(_endTime >= now);
233     endTime = _endTime;
234   }
235   /**
236    * @dev Calls the contract's finalization function.
237    */
238   function finalize() onlyOwner public {
239     require(!isFinalized);
240 
241     finalization();
242     Finalized();
243 
244     isFinalized = true;
245   }
246 
247   // send ether to the fund collection wallet
248   // override to create custom fund forwarding mechanisms
249   function forwardFunds() internal {
250     wallet.transfer(msg.value);
251   }
252 
253   // @return true if the transaction can buy tokens
254   function validPurchase() internal view returns (bool) {
255     bool tokenMintingFinished = token.mintingFinished();
256     bool withinCap = token.totalSupply().add(tokensForWei(msg.value)) <= cap;
257     bool withinPeriod = now <= endTime;
258     bool nonZeroPurchase = msg.value != 0;
259     bool moreThanMinimumPayment = msg.value >= 0.05 ether;
260 
261     return !tokenMintingFinished && withinCap && withinPeriod && nonZeroPurchase && moreThanMinimumPayment;
262   }
263 
264   function tokensForWei(uint weiAmount) public view returns (uint tokens) {
265     tokens = weiAmount.mul(rate);
266     tokens = tokens.add(getBonus(tokens, weiAmount));
267   }
268 
269   function finalization() internal {
270     token.finishMinting();
271     endTime = now;
272   }
273 
274   // @return true if crowdsale event has ended
275   function hasEnded() public view returns (bool) {
276     return now > endTime;
277   }
278 
279 }