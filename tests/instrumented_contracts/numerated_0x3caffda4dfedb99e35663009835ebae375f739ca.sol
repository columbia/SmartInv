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
24 
25 }
26 
27 /**
28  * @title SafeMath
29  * @dev Math operations with safety checks that throw on error
30  */
31 library SafeMath {
32 
33   /**
34   * @dev Multiplies two numbers, throws on overflow.
35   */
36   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
37     if (a == 0) {
38       return 0;
39     }
40     c = a * b;
41     assert(c / a == b);
42     return c;
43   }
44 
45   /**
46   * @dev Integer division of two numbers, truncating the quotient.
47   */
48   function div(uint256 a, uint256 b) internal pure returns (uint256) {
49     // assert(b > 0); // Solidity automatically throws when dividing by 0
50     // uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52     return a / b;
53   }
54 
55   /**
56   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
57   */
58   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   /**
64   * @dev Adds two numbers, throws on overflow.
65   */
66   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
67     c = a + b;
68     assert(c >= a);
69     return c;
70   }
71 }
72 
73 
74 contract ERC20Basic {
75   function totalSupply() public view returns (uint256);
76   function balanceOf(address who) public view returns (uint256);
77   function transfer(address to, uint256 value) public returns (bool);
78   event Transfer(address indexed from, address indexed to, uint256 value);
79 }
80 
81 
82 contract ERC20 is ERC20Basic {
83   function allowance(address owner, address spender) public view returns (uint256);
84   function transferFrom(address from, address to, uint256 value) public returns (bool);
85   function approve(address spender, uint256 value) public returns (bool);
86   event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 
90 
91 contract DMPNGCrowdsale is Ownable {
92   using SafeMath for uint256;
93 
94   // The token being sold
95   ERC20 public token;
96 
97   // Address where funds are collected
98   address public wallet;
99 
100   // How many token units a buyer gets per wei
101   uint256 public rate;
102 
103   // Amount of wei raised
104   uint256 public weiRaised;
105 
106   
107   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
108 
109   
110   function DMPNGCrowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
111     require(_rate > 0);
112     require(_wallet != address(0));
113     require(_token != address(0));
114 
115     rate = _rate;
116     wallet = _wallet;
117     token = _token;
118 }
119 
120   
121 
122   // -----------------------------------------
123   // Crowdsale external interface
124   // -----------------------------------------
125 
126   function allocateRemainingTokens() onlyOwner public {    
127     uint256 remaining = token.balanceOf(this);
128     token.transfer(owner, remaining);
129   }
130   
131   function () external payable {
132     buyTokens(msg.sender);
133   }
134 
135   
136   function buyTokens(address _beneficiary) public payable {
137 
138     uint256 weiAmount = msg.value;
139     _preValidatePurchase(_beneficiary, weiAmount);
140 
141     // calculate token amount to be created
142     uint256 tokens = _getTokenAmount(weiAmount);
143 
144     // update state
145     weiRaised = weiRaised.add(weiAmount);
146 
147     _processPurchase(_beneficiary, tokens);
148     emit TokenPurchase(
149       msg.sender,
150       _beneficiary,
151       weiAmount,
152       tokens
153     );   
154 
155     _forwardFunds();
156    
157   }
158 
159   // -----------------------------------------
160   // Internal interface (extensible)
161   // -----------------------------------------
162 
163   
164   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) pure internal {
165     require(_beneficiary != address(0));
166     require(_weiAmount != 0);
167   }  
168   
169 
170   
171   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
172     token.transfer(_beneficiary, _tokenAmount);
173   }
174 
175   
176   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
177     _deliverTokens(_beneficiary, _tokenAmount);
178   }   
179 
180   
181   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
182 
183     uint256 tokensIssued = _weiAmount.mul(rate);
184     
185     if( 10 * (10 ** 18) < tokensIssued && 100 * (10 ** 18) > tokensIssued ) tokensIssued = tokensIssued + (1 * (10 ** 18));
186     else if( 100 * (10 ** 18) <= tokensIssued ) tokensIssued = tokensIssued + (15 * (10 ** 18));
187    
188 
189     return tokensIssued;
190    
191   }
192   
193   function _forwardFunds() internal {
194     wallet.transfer(msg.value);
195   }
196 
197 }