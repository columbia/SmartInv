1 pragma solidity ^0.4.13;
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
48   function totalSupply() constant returns (uint256 totalSupply);
49 
50   function balanceOf(address _owner) constant returns (uint256 balance);
51 
52   function transfer(address _to, uint256 _value) returns (bool success);
53 
54   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
55 
56   function approve(address _spender, uint256 _value) returns (bool success);
57 
58   function allowance(address _owner, address _spender) constant returns (uint256 remaining);
59 
60   event Transfer(address indexed _from, address indexed _to, uint256 _value);
61 
62   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
63 
64  }
65 
66 contract GMPToken is Ownable, ERC20Interface {
67 
68   /* Public variables of the token */
69   string public name;
70   string public symbol;
71   uint8 public decimals;
72   uint256 public totalSupply;
73 
74   /* This creates an array with all balances */
75   mapping (address => uint256) public balances;
76   mapping (address => mapping (address => uint256)) public allowed;
77 
78   /* Constuctor: Initializes contract with initial supply tokens to the creator of the contract */
79   function GMPToken(
80         uint256 initialSupply,
81         string tokenName,
82         uint8 decimalUnits,
83         string tokenSymbol
84       ) {
85       balances[msg.sender] = initialSupply;              // Give the creator all initial tokens
86       totalSupply = initialSupply;                        // Update total supply
87       name = tokenName;                                   // Set the name for display purposes
88       symbol = tokenSymbol;                               // Set the symbol for display purposes
89       decimals = decimalUnits;                            // Amount of decimals for display purposes
90   }
91 
92   /* Implementation of ERC20Interface */
93 
94   function totalSupply() constant returns (uint256 totalSupply) { return totalSupply; }
95 
96   function balanceOf(address _owner) constant returns (uint256 balance) { return balances[_owner]; }
97 
98   /* Internal transfer, only can be called by this contract */
99   function _transfer(address _from, address _to, uint _amount) internal {
100       require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
101       require (balances[_from] > _amount);                // Check if the sender has enough
102       require (balances[_to] + _amount > balances[_to]); // Check for overflows
103       balances[_from] -= _amount;                         // Subtract from the sender
104       balances[_to] += _amount;                            // Add the same to the recipient
105       Transfer(_from, _to, _amount);
106 
107   }
108 
109   function transfer(address _to, uint256 _amount) returns (bool success) {
110     _transfer(msg.sender, _to, _amount);
111     return true;
112   }
113 
114   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
115     require (_value < allowed[_from][msg.sender]);     // Check allowance
116     allowed[_from][msg.sender] -= _value;
117     _transfer(_from, _to, _value);
118     return true;
119   }
120 
121   function approve(address _spender, uint256 _amount) returns (bool success) {
122     allowed[msg.sender][_spender] = _amount;
123     Approval(msg.sender, _spender, _amount);
124     return true;
125   }
126 
127   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
128     return allowed[_owner][_spender];
129   }
130 
131   function mintToken(uint256 mintedAmount) onlyOwner {
132       balances[Ownable.owner] += mintedAmount;
133       totalSupply += mintedAmount;
134       Transfer(0, Ownable.owner, mintedAmount);
135   }
136 
137 }
138 
139 
140 contract Crowdsale is Ownable {
141 
142   using SafeMath for uint256;
143 
144   // The token being sold
145   GMPToken public token;
146 
147   // Flag setting that investments are allowed (both inclusive)
148   bool public saleIsActive;
149 
150   // address where funds are collected
151   address public wallet;
152 
153   // Price for 1 token in wei. i.e. 562218890554723
154   uint256 public rate;
155 
156   // amount of raised money in wei
157   uint256 public weiRaised;
158 
159   /**
160    * event for token purchase logging
161    * @param purchaser who paid for the tokens
162    * @param beneficiary who got the tokens
163    * @param value weis paid for purchase
164    * @param amount amount of tokens purchased
165    */
166   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
167 
168 
169   /* -----------   A D M I N        F U N C T I O N S    ----------- */
170 
171   function Crowdsale(uint256 initialRate, address targetWallet, uint256 initialSupply, string tokenName, uint8 decimalUnits, string tokenSymbol) {
172 
173     //Checks
174     require(initialRate > 0);
175     require(targetWallet != 0x0);
176 
177     //Init
178     token = new GMPToken(initialSupply, tokenName, decimalUnits, tokenSymbol);
179     rate = initialRate;
180     wallet = targetWallet;
181     saleIsActive = true;
182 
183   }
184 
185   function close() onlyOwner {
186     selfdestruct(owner);
187   }
188 
189   //Transfer token to
190   function transferToAddress(address targetWallet, uint256 tokenAmount) onlyOwner {
191     token.transfer(targetWallet, tokenAmount);
192   }
193 
194 
195   //Setters
196   function enableSale() onlyOwner {
197     saleIsActive = true;
198   }
199 
200   function disableSale() onlyOwner {
201     saleIsActive = false;
202   }
203 
204   function setRate(uint256 newRate)  onlyOwner {
205     rate = newRate;
206   }
207 
208   //Mint new tokens
209   function mintToken(uint256 mintedAmount) onlyOwner {
210     token.mintToken(mintedAmount);
211   }
212 
213 
214 
215   /* -----------   P U B L I C      C A L L B A C K       F U N C T I O N     ----------- */
216 
217   function () payable {
218 
219     require(msg.sender != 0x0);
220     require(saleIsActive);
221     require(msg.value > rate);
222 
223     uint256 weiAmount = msg.value;
224 
225     //Update total wei counter
226     weiRaised = weiRaised.add(weiAmount);
227 
228     //Calc number of tokents
229     uint256 tokenAmount = weiAmount.div(rate);
230 
231     //Forward wei to wallet account
232     wallet.transfer(msg.value);
233 
234     //Transfer token to sender
235     token.transfer(msg.sender, tokenAmount);
236     TokenPurchase(msg.sender, wallet, weiAmount, tokenAmount);
237 
238   }
239 
240 
241 
242 }