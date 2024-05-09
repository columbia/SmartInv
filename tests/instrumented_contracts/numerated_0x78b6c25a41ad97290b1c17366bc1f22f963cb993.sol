1 pragma solidity ^0.4.22;
2 
3 // File: contracts/zeppelin/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 /**
52  * @title ERC20 interface
53  * @dev GangTokenSale contract using this function to send tokens to buyer
54  */
55 contract ERC20 {
56   function transfer(address to, uint256 value) public returns (bool);
57   function balanceOf(address _owner) public view returns (uint256 balance);
58 }
59 
60 //standard contract to identify owner
61 contract Ownable {
62 
63   address public owner;
64 
65   address public newOwner;
66 
67   modifier onlyOwner() {
68     require(msg.sender == owner);
69     _;
70   }
71 
72   function transferOwnership(address _newOwner) public onlyOwner {
73     require(_newOwner != address(0));
74     newOwner = _newOwner;
75   }
76 
77   function acceptOwnership() public {
78     if (msg.sender == newOwner) {
79       owner = newOwner;
80     }
81   }
82 }
83 
84 
85 
86 // File: contracts/GangTokensale.sol
87 
88 /**
89  * @title Crowdsale
90  * @dev Crowdsale is a base contract for managing a token crowdsale,
91  * allowing investors to purchase tokens with ether. This contract implements
92  * such functionality in its most fundamental form and can be extended to provide additional
93  * functionality and/or custom behavior.
94  * The external interface represents the basic interface for purchasing tokens, and conform
95  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
96  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
97  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
98  * behavior.
99  */
100 contract GangTokenSale is Ownable{
101   using SafeMath for uint256;
102 
103   // The token being sold
104   ERC20 public token;
105 
106   // Address where funds are collected
107   address public wallet;
108 
109   // How many token units a buyer gets per wei
110   uint256 public rate;
111 
112   // Amount of wei raised
113   uint256 public weiRaised;
114 
115   /**
116    * Event for token purchase logging
117    * @param purchaser who paid for the tokens
118    * @param beneficiary who got the tokens
119    * @param etherValue weis paid for purchase
120    * @param tokenAmount amount of tokens purchased
121    */
122   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 indexed etherValue, uint256 tokenAmount);
123 
124   /**
125    * @param _rate Number of token units a buyer gets per wei
126    * @param _wallet Address where collected funds will be forwarded to
127    * @param _token Address of the token being sold
128    */
129   constructor (address _token, address _wallet, address _owner, uint256 _rate) public {
130     require(_rate > 0);
131     require(_wallet != address(0));
132     require(_token != address(0));
133 
134     owner = _owner;
135 
136     rate = _rate;
137     wallet = _wallet;
138     token = ERC20(_token);
139   }
140 
141 
142 
143   // -----------------------------------------
144   // Crowdsale external interface
145   // -----------------------------------------
146 
147   /**
148    * @dev fallback function ***DO NOT OVERRIDE***
149    */
150   function () external payable {
151     require(buyTokens(msg.sender, msg.value));
152   }
153 
154   function buyTokens(address _beneficiary, uint _value) internal returns(bool) {
155     require(_value > 0);
156 
157     // calculate token amount to be created
158     uint256 tokens = getTokenAmount(_value);
159 
160     // update state
161     weiRaised = weiRaised.add(_value);
162 
163     // send tokens
164     token.transfer(_beneficiary, tokens);
165     emit TokenPurchase(msg.sender, _beneficiary, _value, tokens);
166 
167     //send ether to wallet
168     wallet.transfer(address(this).balance);
169 
170     return true;
171   }
172 
173   // -----------------------------------------
174   // Public interface (extensible)
175   // -----------------------------------------
176 
177   /**
178    * @dev Override to extend the way in which ether is converted to tokens.
179    * @param _weiAmount Value in wei to be converted into tokens
180    * @return Number of tokens that can be purchased with the specified _weiAmount
181    */
182   function getTokenAmount(uint256 _weiAmount) public view returns (uint256) {
183     return _weiAmount.mul(rate);
184   }
185 
186   function getRemainingTokens () public view returns(uint) {
187     return token.balanceOf(address(this));
188   }
189   
190   function setNewRate (uint _rate) onlyOwner public {
191     require(_rate > 0);
192     rate = _rate;
193   }
194 
195   function destroyContract () onlyOwner public {
196     uint tokens = token.balanceOf(address(this));
197     token.transfer(wallet, tokens);
198 
199     selfdestruct(wallet);
200   }
201 }