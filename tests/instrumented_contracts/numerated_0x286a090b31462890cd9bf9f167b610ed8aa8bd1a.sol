1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 
4 
5 // ----------------------------------------------------------------------------
6 // ERC Token Standard #20 Interface
7 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
8 // ----------------------------------------------------------------------------
9 contract ERC20Interface {
10     function totalSupply() public constant returns (uint);
11     function balanceOf(address tokenOwner) public constant returns (uint balance);
12     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
13     function transfer(address to, uint tokens) public returns (bool success);
14     function approve(address spender, uint tokens) public returns (bool success);
15     function transferFrom(address from, address to, uint tokens) public returns (bool success);
16 
17     event Transfer(address indexed from, address indexed to, uint tokens);
18     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
19 }
20 
21 contract ApproveAndCallFallBack {
22     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
23 }
24 
25 // ----------------------------------------------------------------------------
26 // This is an automated token exchange. It lets you buy and sell a specific token for Ethereum.
27 // The more eth in the contract the higher the token price, the more tokens in the contract
28 // the lower the token price. The formula is the same as for Ether Shrimp Farm.
29 // There are no fees except gas cost.
30 // ----------------------------------------------------------------------------
31 
32 contract AutomatedExchange is ApproveAndCallFallBack{
33 
34     uint256 PSN=100000000000000;
35     uint256 PSNH=50000000000000;
36     address tokenAddress=0x841D34aF2018D9487199678eDd47Dd46B140690B;
37     ERC20Interface tokenContract=ERC20Interface(tokenAddress);
38     function AutomatedExchange() public{
39     }
40     //Tokens are sold by sending them to this contract with ApproveAndCall
41     function receiveApproval(address from, uint256 tokens, address token, bytes data) public{
42         //only allow this to be called from the token contract
43         require(msg.sender==tokenAddress);
44         uint256 tokenValue=calculateTokenSell(tokens);
45         tokenContract.transferFrom(from,this,tokens);
46         from.transfer(tokenValue);
47     }
48     function buyTokens() public payable{
49         uint256 tokensBought=calculateTokenBuy(msg.value,SafeMath.sub(this.balance,msg.value));
50         tokenContract.transfer(msg.sender,tokensBought);
51     }
52     //magic trade balancing algorithm
53     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
54         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
55         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
56     }
57     function calculateTokenSell(uint256 tokens) public view returns(uint256){
58         return calculateTrade(tokens,tokenContract.balanceOf(this),this.balance);
59     }
60     function calculateTokenBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
61         return calculateTrade(eth,contractBalance,tokenContract.balanceOf(this));
62     }
63     function calculateTokenBuySimple(uint256 eth) public view returns(uint256){
64         return calculateTokenBuy(eth,this.balance);
65     }
66 
67     //allow sending eth to the contract
68     function () public payable {}
69 
70     function getBalance() public view returns(uint256){
71         return this.balance;
72     }
73     function getTokenBalance() public view returns(uint256){
74         return tokenContract.balanceOf(this);
75     }
76     function min(uint256 a, uint256 b) private pure returns (uint256) {
77         return a < b ? a : b;
78     }
79 }
80 
81 library SafeMath {
82 
83   /**
84   * @dev Multiplies two numbers, throws on overflow.
85   */
86   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
87     if (a == 0) {
88       return 0;
89     }
90     uint256 c = a * b;
91     assert(c / a == b);
92     return c;
93   }
94 
95   /**
96   * @dev Integer division of two numbers, truncating the quotient.
97   */
98   function div(uint256 a, uint256 b) internal pure returns (uint256) {
99     // assert(b > 0); // Solidity automatically throws when dividing by 0
100     uint256 c = a / b;
101     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
102     return c;
103   }
104 
105   /**
106   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
107   */
108   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109     assert(b <= a);
110     return a - b;
111   }
112 
113   /**
114   * @dev Adds two numbers, throws on overflow.
115   */
116   function add(uint256 a, uint256 b) internal pure returns (uint256) {
117     uint256 c = a + b;
118     assert(c >= a);
119     return c;
120   }
121 }