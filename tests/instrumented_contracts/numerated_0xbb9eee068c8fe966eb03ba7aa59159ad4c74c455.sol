1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract Ownable {
34 
35   address public owner;
36   function Ownable() public { owner = msg.sender; }
37 
38   modifier onlyOwner {
39     require(msg.sender == owner);
40     _;
41   }
42 
43   function transferOwnership(address newOwner) public onlyOwner {owner = newOwner;}
44 }
45 
46 contract ERC20Interface {
47 
48   function totalSupply() public constant returns (uint256);
49 
50   function balanceOf(address _owner) public constant returns (uint256);
51 
52   function transfer(address _to, uint256 _value) public returns (bool);
53 
54   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
55 
56   function approve(address _spender, uint256 _value) public returns (bool);
57 
58   function allowance(address _owner, address _spender) public constant returns (uint256);
59 
60   event Transfer(address indexed _from, address indexed _to, uint256 _value);
61 
62   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
63 
64  }
65 
66 contract SmartOToken is Ownable, ERC20Interface {
67 
68   using SafeMath for uint256;
69 
70   /* Public variables of the token */
71   string public constant name = "STO";
72   string public constant symbol = "STO";
73   uint public constant decimals = 18;
74   uint256 public constant initialSupply = 12000000000 * 1 ether;
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
86   function SmartOToken() public {
87       balances[msg.sender] = initialSupply;              // Give the creator all initial tokens
88       totalSupply = initialSupply;                        // Update total supply
89   }
90 
91 
92   /* Implementation of ERC20Interface */
93 
94   function totalSupply() public constant returns (uint256) { return totalSupply; }
95 
96   function balanceOf(address _owner) public constant returns (uint256) { return balances[_owner]; }
97 
98   /* Internal transfer, only can be called by this contract */
99   function _transfer(address _from, address _to, uint _amount) internal {
100       require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
101       require (balances[_from] >= _amount);                // Check if the sender has enough
102       balances[_from] = balances[_from].sub(_amount);
103       balances[_to] = balances[_to].add(_amount);
104       Transfer(_from, _to, _amount);
105 
106   }
107 
108   function transfer(address _to, uint256 _amount) public returns (bool) {
109     _transfer(msg.sender, _to, _amount);
110     return true;
111   }
112 
113   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
114     require (_value <= allowed[_from][msg.sender]);     // Check allowance
115     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
116     _transfer(_from, _to, _value);
117     return true;
118   }
119 
120   function approve(address _spender, uint256 _amount) public returns (bool) {
121     allowed[msg.sender][_spender] = _amount;
122     Approval(msg.sender, _spender, _amount);
123     return true;
124   }
125 
126   function allowance(address _owner, address _spender) public constant returns (uint256) {
127     return allowed[_owner][_spender];
128   }
129 
130 }
131 
132 
133 contract Crowdsale is Ownable {
134 
135   using SafeMath for uint256;
136 
137   // The token being sold
138   SmartOToken public token;
139 
140   // Flag setting that investments are allowed (both inclusive)
141   bool public saleIsActive;
142 
143   // address where funds are collected
144   address public wallet;
145 
146   // Number of tokents for 1 ETH, i.e. 683 tokens for 1 ETH
147   uint256 public rate;
148 
149   // amount of raised money in wei
150   uint256 public weiRaised;
151 
152   /**
153    * event for token purchase logging
154    * @param purchaser who paid for the tokens
155    * @param beneficiary who got the tokens
156    * @param value weis paid for purchase
157    * @param amount amount of tokens purchased
158    */
159   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
160 
161 
162   /* -----------   A D M I N        F U N C T I O N S    ----------- */
163 
164   function Crowdsale(uint256 _initialRate, address _targetWallet) public {
165 
166     //Checks
167     require(_initialRate > 0);
168     require(_targetWallet != 0x0);
169 
170     //Init
171     token = new SmartOToken();
172     rate = _initialRate;
173     wallet = _targetWallet;
174     saleIsActive = true;
175 
176   }
177 
178   function close() public onlyOwner {
179     selfdestruct(owner);
180   }
181 
182   //Transfer token to
183   function transferToAddress(address _targetWallet, uint256 _tokenAmount) public onlyOwner {
184     token.transfer(_targetWallet, _tokenAmount * 1 ether);
185   }
186 
187 
188   //Setters
189   function enableSale() public onlyOwner {
190     saleIsActive = true;
191   }
192 
193   function disableSale() public onlyOwner {
194     saleIsActive = false;
195   }
196 
197   function setRate(uint256 _newRate) public onlyOwner {
198     rate = _newRate;
199   }
200 
201 
202   /* -----------   P U B L I C      C A L L B A C K       F U N C T I O N     ----------- */
203 
204   function () public payable {
205 
206     require(msg.sender != 0x0);
207     require(saleIsActive);
208     require(msg.value >= 0.1 * 1 ether);
209 
210     uint256 weiAmount = msg.value;
211 
212     //Update total wei counter
213     weiRaised = weiRaised.add(weiAmount);
214 
215     //Calc number of tokents
216     uint256 tokenAmount = weiAmount.mul(rate);
217 
218     //Forward wei to wallet account
219     wallet.transfer(weiAmount);
220 
221     //Transfer token to sender
222     token.transfer(msg.sender, tokenAmount);
223     TokenPurchase(msg.sender, wallet, weiAmount, tokenAmount);
224 
225   }
226 
227 
228 
229 }