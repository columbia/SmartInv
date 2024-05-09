1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
39 
40 /**
41  * @title Ownable
42  * @dev The Ownable contract has an owner address, and provides basic authorization control
43  * functions, this simplifies the implementation of "user permissions".
44  */
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51 
52   /**
53    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
54    * account.
55    */
56   function Ownable() public {
57     owner = msg.sender;
58   }
59 
60 
61   /**
62    * @dev Throws if called by any account other than the owner.
63    */
64   modifier onlyOwner() {
65     require(msg.sender == owner);
66     _;
67   }
68 
69 
70   /**
71    * @dev Allows the current owner to transfer control of the contract to a newOwner.
72    * @param newOwner The address to transfer ownership to.
73    */
74   function transferOwnership(address newOwner) public onlyOwner {
75     require(newOwner != address(0));
76     OwnershipTransferred(owner, newOwner);
77     owner = newOwner;
78   }
79 
80 }
81 
82 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
83 
84 /**
85  * @title ERC20Basic
86  * @dev Simpler version of ERC20 interface
87  * @dev see https://github.com/ethereum/EIPs/issues/179
88  */
89 contract ERC20Basic {
90   uint256 public totalSupply;
91   function balanceOf(address who) public view returns (uint256);
92   function transfer(address to, uint256 value) public returns (bool);
93   event Transfer(address indexed from, address indexed to, uint256 value);
94 }
95 
96 // File: contracts/ALT0Token.sol
97 
98 contract ALT0Token is Ownable, ERC20Basic {
99   using SafeMath for uint256;
100 
101   string public constant name     = "Altair VR presale token";
102   string public constant symbol   = "ALT0";
103   uint8  public constant decimals = 18;
104 
105   bool public mintingFinished = false;
106 
107   mapping(address => uint256) public balances;
108 
109   event Mint(address indexed to, uint256 amount);
110   event MintFinished();
111 
112   /**
113   * @dev Function to mint tokens
114   * @param _to The address that will receive the minted tokens.
115   * @param _amount The amount of tokens to mint.
116   * @return A boolean that indicates if the operation was successful.
117   */
118   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
119     totalSupply = totalSupply.add(_amount);
120     balances[_to] = balances[_to].add(_amount);
121     Mint(_to, _amount);
122     Transfer(address(0), _to, _amount);
123     return true;
124   }
125 
126   /**
127   * @dev Function to stop minting new tokens.
128   * @return True if the operation was successful.
129   */
130   function finishMinting() onlyOwner canMint public returns (bool) {
131     mintingFinished = true;
132     MintFinished();
133     return true;
134   }
135 
136   /**
137   * @dev Current token is not transferred.
138   * After start official token sale ALT, you can exchange your ALT0 to ALT
139   */
140   function transfer(address, uint256) public returns (bool) {
141     revert();
142     return false;
143   }
144 
145   /**
146   * @dev Gets the balance of the specified address.
147   * @param _owner The address to query the the balance of.
148   * @return An uint256 representing the amount owned by the passed address.
149   */
150   function balanceOf(address _owner) public view returns (uint256 balance) {
151     return balances[_owner];
152   }
153 
154   modifier canMint() {
155     require(!mintingFinished);
156     _;
157   }
158 }
159 
160 // File: contracts/Crowdsale.sol
161 
162 /**
163  * @title Crowdsale ALT0 presale token
164  */
165 
166 contract Crowdsale is Ownable {
167   using SafeMath for uint256;
168 
169   uint256   public constant rate = 680;                   // How many token units a buyer gets per wei
170   uint256   public constant cap = 5000000 ether / rate;   // Maximum amount of funds
171 
172   bool      public isFinalized = false;
173   uint256   public endTime = 1517097600;                  // End timestamps where investments are allowed
174                                                           // Sunday, 28 January 2018, 00:00:00 GMT
175 
176   ALT0Token public token;                                 // ALT0 token itself
177   address   public wallet;                                // Wallet of funds
178   uint256   public weiRaised;                             // Amount of raised money in wei
179 
180   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
181   event Finalized();
182 
183   function Crowdsale (ALT0Token _ALT0, address _wallet) public {
184     assert(address(_ALT0) != address(0));
185     assert(_wallet != address(0));
186     assert(endTime > now);
187     assert(rate > 0);
188     assert(cap > 0);
189 
190     token = _ALT0;
191     wallet = _wallet;
192   }
193 
194   function () public payable {
195     buyTokens(msg.sender);
196   }
197 
198   function buyTokens(address beneficiary) public payable {
199     require(beneficiary != address(0));
200     require(validPurchase());
201 
202     uint256 weiAmount = msg.value;
203     uint256 tokens = weiAmount.mul(rate);
204 
205     weiRaised = weiRaised.add(weiAmount);
206 
207     token.mint(beneficiary, tokens);
208     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
209 
210     forwardFunds();
211   }
212 
213   /**
214    * @dev Calls the contract's finalization function.
215    */
216   function finalize() onlyOwner public {
217     require(!isFinalized);
218 
219     finalization();
220     Finalized();
221 
222     isFinalized = true;
223   }
224 
225   // send ether to the fund collection wallet
226   // override to create custom fund forwarding mechanisms
227   function forwardFunds() internal {
228     wallet.transfer(msg.value);
229   }
230 
231   // @return true if the transaction can buy tokens
232   function validPurchase() internal view returns (bool) {
233     bool tokenMintingFinished = token.mintingFinished();
234     bool withinCap = weiRaised.add(msg.value) <= cap;
235     bool withinPeriod = now <= endTime;
236     bool nonZeroPurchase = msg.value != 0;
237 
238     return !tokenMintingFinished && withinCap && withinPeriod && nonZeroPurchase;
239   }
240 
241   function finalization() internal {
242     token.finishMinting();
243     endTime = now;
244   }
245 
246   // @return true if crowdsale event has ended
247   function hasEnded() public view returns (bool) {
248     return now > endTime;
249   }
250 }