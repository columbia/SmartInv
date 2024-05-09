1 pragma solidity ^0.4.21;
2 
3 contract Ownable {
4   address public owner;
5 
6   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7   
8   function Ownable() public {
9     owner = msg.sender;
10   }
11 
12  
13   modifier onlyOwner() {
14     require(msg.sender == owner);
15     _;
16   }
17   
18   function transferOwnership(address newOwner) public onlyOwner {
19     require(newOwner != address(0));
20     emit OwnershipTransferred(owner, newOwner);
21     owner = newOwner;
22   }
23 
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31 
32   /**
33   * @dev Multiplies two numbers, throws on overflow.
34   */
35   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
36     if (a == 0) {
37       return 0;
38     }
39     c = a * b;
40     assert(c / a == b);
41     return c;
42   }
43 
44   /**
45   * @dev Integer division of two numbers, truncating the quotient.
46   */
47   function div(uint256 a, uint256 b) internal pure returns (uint256) {
48     // assert(b > 0); // Solidity automatically throws when dividing by 0
49     // uint256 c = a / b;
50     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51     return a / b;
52   }
53 
54   /**
55   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
56   */
57   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58     assert(b <= a);
59     return a - b;
60   }
61 
62   /**
63   * @dev Adds two numbers, throws on overflow.
64   */
65   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
66     c = a + b;
67     assert(c >= a);
68     return c;
69   }
70 }
71 
72 
73 contract ERC20Basic {
74   function totalSupply() public view returns (uint256);
75   function balanceOf(address who) public view returns (uint256);
76   function transfer(address to, uint256 value) public returns (bool);
77   event Transfer(address indexed from, address indexed to, uint256 value);
78 }
79 
80 
81 contract ERC20 is ERC20Basic {
82   function allowance(address owner, address spender) public view returns (uint256);
83   function transferFrom(address from, address to, uint256 value) public returns (bool);
84   function approve(address spender, uint256 value) public returns (bool);
85   event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 
89 
90 contract Crowdsale is Ownable {
91   using SafeMath for uint256;
92 
93   // The token being sold
94   ERC20 public token;
95 
96   // Address where funds are collected
97   address public wallet;
98 
99   // How many token units a buyer gets per wei
100   uint256 public rate;
101 
102   // Amount of wei raised
103   uint256 public weiRaised;
104 
105   
106   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
107 
108   
109   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
110     require(_rate > 0);
111     require(_wallet != address(0));
112     require(_token != address(0));
113 
114     rate = _rate;
115     wallet = _wallet;
116     token = _token;
117   }
118 
119   // -----------------------------------------
120   // Crowdsale external interface
121   // -----------------------------------------
122 
123   
124   function () external payable {
125     buyTokens(msg.sender);
126   }
127 
128   
129   function buyTokens(address _beneficiary) public payable {
130 
131     uint256 weiAmount = msg.value;
132     _preValidatePurchase(_beneficiary, weiAmount);
133 
134     // calculate token amount to be created
135     uint256 tokens = _getTokenAmount(weiAmount);
136 
137     // update state
138     weiRaised = weiRaised.add(weiAmount);
139 
140     _processPurchase(_beneficiary, tokens);
141     emit TokenPurchase(
142       msg.sender,
143       _beneficiary,
144       weiAmount,
145       tokens
146     );   
147 
148     _forwardFunds();
149    
150   }
151 
152   // -----------------------------------------
153   // Internal interface (extensible)
154   // -----------------------------------------
155 
156   
157   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) pure internal {
158     require(_beneficiary != address(0));
159     require(_weiAmount != 0);
160   }  
161   
162 
163   
164   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
165     token.transfer(_beneficiary, _tokenAmount);
166   }
167 
168   
169   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
170     _deliverTokens(_beneficiary, _tokenAmount);
171   }   
172 
173   
174   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
175 
176     uint256 tokensIssued = _weiAmount.mul(rate);
177     
178     if( 20 * (10 ** 18) < tokensIssued && 100 * (10 ** 18) > tokensIssued ) tokensIssued = tokensIssued * 103 / 100;
179 
180     else if( 100 * (10 ** 18) <= tokensIssued && 500 * (10 ** 18) > tokensIssued ) tokensIssued = tokensIssued * 105 / 100;
181 
182     else if( 500 * (10 ** 18) <= tokensIssued && 1000 * (10 ** 18) > tokensIssued ) tokensIssued = tokensIssued * 107 / 100;
183 
184     else if( 1000 * (10 ** 18) <= tokensIssued && 5000 * (10 ** 18) > tokensIssued ) tokensIssued = tokensIssued * 110 / 100;
185 
186     else if( 5000 * (10 ** 18) <= tokensIssued && 10000 * (10 ** 18) > tokensIssued ) tokensIssued = tokensIssued * 115 / 100;
187 
188     else if( 10000 * (10 ** 18) <= tokensIssued ) tokensIssued = tokensIssued * 120 / 100;
189 
190     return tokensIssued;
191    
192   }
193   
194   function _forwardFunds() internal {
195     wallet.transfer(msg.value);
196   }
197 
198 }