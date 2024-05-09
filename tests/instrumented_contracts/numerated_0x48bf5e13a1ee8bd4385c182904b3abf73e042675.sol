1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 
4 
5 // ----------------------------------------------------------------------------
6 // ERC Token Standard #20 Interface
7 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
8 // ----------------------------------------------------------------------------
9 contract VerifyToken {
10     function totalSupply() public constant returns (uint);
11     function balanceOf(address tokenOwner) public constant returns (uint balance);
12     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
13     function transfer(address to, uint tokens) public returns (bool success);
14     function approve(address spender, uint tokens) public returns (bool success);
15     function transferFrom(address from, address to, uint tokens) public returns (bool success);
16     bool public activated;
17 
18     event Transfer(address indexed from, address indexed to, uint tokens);
19     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
20 }
21 
22 contract ApproveAndCallFallBack {
23     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
24 }
25 
26 contract AutomatedExchange is ApproveAndCallFallBack{
27 
28     uint256 PSN=100000000000000;
29     uint256 PSNH=50000000000000;
30     address vrfAddress=0x5BD574410F3A2dA202bABBa1609330Db02aD64C2; //0x96357e75B7Ccb1a7Cf10Ac6432021AEa7174c803; //0x9E129e47213589C5Da4d92CC6Bb056425d60b0e1; //0xe0832c4f024D2427bBC6BD0C4931096d2ab5CCaF;//0x64F82571C326487cac31669F1e797EA0c9650879;
31     VerifyToken vrfcontract=VerifyToken(vrfAddress);
32     event BoughtToken(uint tokens,uint eth,address indexed to);
33     event SoldToken(uint tokens,uint eth,address indexed to);
34 
35     //Tokens are sold by sending them to this contract with ApproveAndCall
36     function receiveApproval(address from, uint256 tokens, address token, bytes data) public{
37         //only allow this to be called from the token contract once activated
38         require(vrfcontract.activated());
39         require(msg.sender==vrfAddress);
40         uint256 tokenValue=calculateTokenSell(tokens);
41         vrfcontract.transferFrom(from,this,tokens);
42         from.transfer(tokenValue);
43         emit SoldToken(tokens,tokenValue,from);
44     }
45     function buyTokens() public payable{
46         require(vrfcontract.activated());
47         uint256 tokensBought=calculateTokenBuy(msg.value,SafeMath.sub(this.balance,msg.value));
48         vrfcontract.transfer(msg.sender,tokensBought);
49         emit BoughtToken(tokensBought,msg.value,msg.sender);
50     }
51     //magic trade balancing algorithm
52     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
53         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
54         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
55     }
56     function calculateTokenSell(uint256 tokens) public view returns(uint256){
57         return calculateTrade(tokens,vrfcontract.balanceOf(this),this.balance);
58     }
59     function calculateTokenBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
60         return calculateTrade(eth,contractBalance,vrfcontract.balanceOf(this));
61     }
62     function calculateTokenBuySimple(uint256 eth) public view returns(uint256){
63         return calculateTokenBuy(eth,this.balance);
64     }
65 
66     //allow sending eth to the contract
67     function () public payable {}
68 
69     function getBalance() public view returns(uint256){
70         return this.balance;
71     }
72     function getTokenBalance() public view returns(uint256){
73         return vrfcontract.balanceOf(this);
74     }
75     function min(uint256 a, uint256 b) private pure returns (uint256) {
76         return a < b ? a : b;
77     }
78 }
79 
80 library SafeMath {
81 
82   /**
83   * @dev Multiplies two numbers, throws on overflow.
84   */
85   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
86     if (a == 0) {
87       return 0;
88     }
89     uint256 c = a * b;
90     assert(c / a == b);
91     return c;
92   }
93 
94   /**
95   * @dev Integer division of two numbers, truncating the quotient.
96   */
97   function div(uint256 a, uint256 b) internal pure returns (uint256) {
98     // assert(b > 0); // Solidity automatically throws when dividing by 0
99     uint256 c = a / b;
100     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
101     return c;
102   }
103 
104   /**
105   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
106   */
107   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
108     assert(b <= a);
109     return a - b;
110   }
111 
112   /**
113   * @dev Adds two numbers, throws on overflow.
114   */
115   function add(uint256 a, uint256 b) internal pure returns (uint256) {
116     uint256 c = a + b;
117     assert(c >= a);
118     return c;
119   }
120 }