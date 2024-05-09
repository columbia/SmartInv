1 pragma solidity ^0.4.23;
2 
3 
4 // @title ERC20 interface
5 // @dev see https://github.com/ethereum/EIPs/issues/20
6 contract iERC20 {
7   function allowance(address owner, address spender)
8     public view returns (uint256);
9 
10   function transferFrom(address from, address to, uint256 value)
11     public returns (bool);
12 
13   function approve(address spender, uint256 value) public returns (bool);
14 
15   function totalSupply() public view returns (uint256);
16   function balanceOf(address who) public view returns (uint256);
17   function transfer(address to, uint256 value) public returns (bool);
18   event Transfer(address indexed from, address indexed to, uint256 tokens);
19   event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
20 }
21 
22 
23 
24 
25 
26 // @title SafeMath
27 // @dev Math operations with safety checks that throw on error
28 library SafeMath {
29 
30   // @dev Multiplies two numbers, throws on overflow.
31   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
32     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
33     // benefit is lost if 'b' is also tested.
34     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
35     if (a == 0) {
36       return 0;
37     }
38 
39     c = a * b;
40     require(c / a == b, "mul failed");
41     return c;
42   }
43 
44   // @dev Integer division of two numbers, truncating the quotient.
45   function div(uint256 a, uint256 b) internal pure returns (uint256) {
46     // assert(b > 0); // Solidity automatically throws when dividing by 0
47     // uint256 c = a / b;
48     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
49     return a / b;
50   }
51 
52   // @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54     require(b <= a, "sub fail");
55     return a - b;
56   }
57 
58   // @dev Adds two numbers, throws on overflow.
59   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
60     c = a + b;
61     require(c >= a, "add fail");
62     return c;
63   }
64 }
65 
66 /* 
67   Copyright 2018 Token Sales Network (https://tokensales.io)
68   Licensed under the MIT license (https://opensource.org/licenses/MIT)
69 
70   Permission is hereby granted, free of charge, to any person obtaining a copy of this software 
71   and associated documentation files (the "Software"), to deal in the Software without restriction, 
72   including without limitation the rights to use, copy, modify, merge, publish, distribute, 
73   sublicense, and/or sell copies of the Software, and to permit persons to whom the Software 
74   is furnished to do so, subject to the following conditions:
75 
76   The above copyright notice and this permission notice shall be included in all copies or 
77   substantial portions of the Software.
78 
79   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING 
80   BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
81   NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
82   DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
83   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
84 */
85 
86 // @title Token Sale Network
87 // A contract allowing users to buy a supply of tokens
88 // Adapted from OpenZeppelin's Crowdsale contract
89 // 
90 contract TokenSales {
91   using SafeMath for uint256;
92 
93   // Event for token purchase logging
94   // @param token that was sold
95   // @param seller who sold the tokens
96   // @param purchaser who paid for the tokens
97   // @param value weis paid for purchase
98   // @param amount amount of tokens purchased
99   event TokenPurchase(
100     address indexed token,
101     address indexed seller,
102     address indexed purchaser,
103     uint256 value,
104     uint256 amount
105   );
106 
107   mapping(address => mapping(address => uint)) public saleAmounts;
108   mapping(address => mapping(address => uint)) public saleRates;
109 
110   // @dev create a sale of tokens.
111   // @param _token - must be an ERC20 token
112   // @param _rate - how many token units a buyer gets per wei.
113   //   The rate is the conversion between wei and the smallest and indivisible token unit.
114   //   So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
115   //   1 wei will give you 1 unit, or 0.001 TOK.
116   // @param _addedTokens - the number of tokens to add to the sale
117   function createSale(iERC20 token, uint256 rate, uint256 addedTokens) public {
118     uint currentSaleAmount = saleAmounts[msg.sender][token];
119     if(addedTokens > 0 || currentSaleAmount > 0) {
120       saleRates[msg.sender][token] = rate;
121     }
122     if (addedTokens > 0) {
123       saleAmounts[msg.sender][token] = currentSaleAmount.add(addedTokens);
124       token.transferFrom(msg.sender, address(this), addedTokens);
125     }
126   }
127 
128   // @dev A payable function that takes ETH, and pays out in the token specified.
129   // @param seller - address selling the token
130   // @param token - the token address
131   function buy(iERC20 token, address seller) public payable {
132     uint size;
133     address sender = msg.sender;
134     assembly { size := extcodesize(sender) }
135     require(size == 0); // Disallow calling from contracts, for safety
136     uint256 weiAmount = msg.value;
137     require(weiAmount > 0);
138 
139     uint rate = saleRates[seller][token];
140     uint amount = saleAmounts[seller][token];
141     require(rate > 0);
142 
143     uint256 tokens = weiAmount.mul(rate);
144     saleAmounts[seller][token] = amount.sub(tokens);
145 
146     emit TokenPurchase(
147       token,
148       seller,
149       msg.sender,
150       weiAmount,
151       tokens
152     );
153 
154     token.transfer(msg.sender, tokens);
155     seller.transfer(msg.value);
156   }
157 
158   // dev Cancels all the sender's sales of a given token
159   // @param token - the address of the token to be cancelled.
160   function cancelSale(iERC20 token) public {
161     uint amount = saleAmounts[msg.sender][token];
162     require(amount > 0);
163 
164     delete saleAmounts[msg.sender][token];
165     delete saleRates[msg.sender][token];
166 
167     if (amount > 0) {
168       token.transfer(msg.sender, amount);
169     }
170   }
171 
172   // @dev fallback function always throws
173   function () external payable {
174     revert();
175   }
176 }