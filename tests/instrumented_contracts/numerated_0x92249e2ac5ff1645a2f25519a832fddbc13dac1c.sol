1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract Ownable {
34 
35   address public owner;
36   function Ownable() { owner = msg.sender; }
37 
38   modifier onlyOwner {
39     require(msg.sender == owner);
40     _;
41   }
42 
43   function transferOwnership(address newOwner) onlyOwner {owner = newOwner;}
44 }
45 
46 contract ERC20Interface {
47 
48   function totalSupply() constant returns (uint256);
49 
50   function balanceOf(address _owner) constant returns (uint256);
51 
52   function transfer(address _to, uint256 _value) returns (bool);
53 
54   function transferFrom(address _from, address _to, uint256 _value) returns (bool);
55 
56   function approve(address _spender, uint256 _value) returns (bool);
57 
58   function allowance(address _owner, address _spender) constant returns (uint256);
59 
60   event Transfer(address indexed _from, address indexed _to, uint256 _value);
61 
62   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
63 
64  }
65 
66 contract GMPToken is Ownable, ERC20Interface {
67 
68   using SafeMath for uint256;
69 
70   /* Public variables of the token */
71   string public constant name = "GMP Coin";
72   string public constant symbol = "GMP";
73   uint public constant decimals = 18;
74   uint256 public constant initialSupply = 220000000 * 1 ether;
75   uint256 public totalSupply;
76 
77   /* This creates an array with all balances */
78   mapping (address => uint256) public balances;
79   mapping (address => mapping (address => uint256)) public allowed;
80 
81   /* Events */
82   event Burn(address indexed burner, uint256 value);
83   event Mint(address indexed to, uint256 amount);
84 
85   /* Constuctor: Initializes contract with initial supply tokens to the creator of the contract */
86   function GMPToken() {
87       balances[msg.sender] = initialSupply;              // Give the creator all initial tokens
88       totalSupply = initialSupply;                        // Update total supply
89   }
90 
91 
92   /* Implementation of ERC20Interface */
93 
94   function totalSupply() constant returns (uint256) { return totalSupply; }
95 
96   function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
97 
98   /* Internal transfer, only can be called by this contract */
99   function _transfer(address _from, address _to, uint _amount) internal {
100       require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
101       require (balances[_from] > _amount);                // Check if the sender has enough
102       balances[_from] = balances[_from].sub(_amount);
103       balances[_to] = balances[_to].add(_amount);
104       Transfer(_from, _to, _amount);
105 
106   }
107 
108   function transfer(address _to, uint256 _amount) returns (bool) {
109     _transfer(msg.sender, _to, _amount);
110     return true;
111   }
112 
113   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
114     require (_value < allowed[_from][msg.sender]);     // Check allowance
115     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
116     _transfer(_from, _to, _value);
117     return true;
118   }
119 
120   function approve(address _spender, uint256 _amount) returns (bool) {
121     allowed[msg.sender][_spender] = _amount;
122     Approval(msg.sender, _spender, _amount);
123     return true;
124   }
125 
126   function allowance(address _owner, address _spender) constant returns (uint256) {
127     return allowed[_owner][_spender];
128   }
129 
130   function mintToken(uint256 _mintedAmount) onlyOwner {
131     balances[Ownable.owner] = balances[Ownable.owner].add(_mintedAmount);
132     totalSupply = totalSupply.add(_mintedAmount);
133     Mint(Ownable.owner, _mintedAmount);
134   }
135 
136   //For refund only
137   function burnToken(address _burner, uint256 _value) onlyOwner {
138     require(_value > 0);
139     require(_value <= balances[_burner]);
140 
141     balances[_burner] = balances[_burner].sub(_value);
142     totalSupply = totalSupply.sub(_value);
143     Burn(_burner, _value);
144   }
145 
146 
147 }
148 
149 
150 contract Crowdsale is Ownable {
151 
152   using SafeMath for uint256;
153 
154   // The token being sold
155   GMPToken public token;
156 
157   // Flag setting that investments are allowed (both inclusive)
158   bool public saleIsActive;
159 
160   // address where funds are collected
161   address public wallet;
162 
163   // Number of tokents for 1 ETH, i.e. 683 tokens for 1 ETH
164   uint256 public rate;
165 
166   // amount of raised money in wei
167   uint256 public weiRaised;
168 
169   /**
170    * event for token purchase logging
171    * @param purchaser who paid for the tokens
172    * @param beneficiary who got the tokens
173    * @param value weis paid for purchase
174    * @param amount amount of tokens purchased
175    */
176   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
177 
178 
179   /* -----------   A D M I N        F U N C T I O N S    ----------- */
180 
181   function Crowdsale(uint256 _initialRate, address _targetWallet) {
182 
183     //Checks
184     require(_initialRate > 0);
185     require(_targetWallet != 0x0);
186 
187     //Init
188     token = new GMPToken();
189     rate = _initialRate;
190     wallet = _targetWallet;
191     saleIsActive = true;
192 
193   }
194 
195   function close() onlyOwner {
196     selfdestruct(owner);
197   }
198 
199   //Transfer token to
200   function transferToAddress(address _targetWallet, uint256 _tokenAmount) onlyOwner {
201     token.transfer(_targetWallet, _tokenAmount * 1 ether);
202   }
203 
204 
205   //Setters
206   function enableSale() onlyOwner {
207     saleIsActive = true;
208   }
209 
210   function disableSale() onlyOwner {
211     saleIsActive = false;
212   }
213 
214   function setRate(uint256 _newRate)  onlyOwner {
215     rate = _newRate;
216   }
217 
218   //Mint new tokens
219   function mintToken(uint256 _mintedAmount) onlyOwner {
220     token.mintToken(_mintedAmount);
221   }
222 
223 
224 
225   /* -----------   P U B L I C      C A L L B A C K       F U N C T I O N     ----------- */
226 
227   function () payable {
228 
229     require(msg.sender != 0x0);
230     require(saleIsActive);
231     require(msg.value > 0.01 * 1 ether);
232 
233     uint256 weiAmount = msg.value;
234 
235     //Update total wei counter
236     weiRaised = weiRaised.add(weiAmount);
237 
238     //Calc number of tokents
239     uint256 tokenAmount = weiAmount.mul(rate);
240 
241     //Forward wei to wallet account
242     wallet.transfer(weiAmount);
243 
244     //Transfer token to sender
245     token.transfer(msg.sender, tokenAmount);
246     TokenPurchase(msg.sender, wallet, weiAmount, tokenAmount);
247 
248   }
249 
250 
251 
252 }