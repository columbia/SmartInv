1 pragma solidity ^0.4.21;
2 
3 // File: node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol
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
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     if (a == 0) {
16       return 0;
17     }
18     c = a * b;
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
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: contracts/cupExchange/CupExchange.sol
52 
53 interface token {
54     function transfer(address receiver, uint amount) external returns(bool);
55     function transferFrom(address from, address to, uint amount) external returns(bool);
56     function allowance(address owner, address spender) external returns(uint256);
57     function balanceOf(address owner) external returns(uint256);
58 }
59 
60 contract CupExchange {
61     using SafeMath for uint256;
62     using SafeMath for int256;
63 
64     address public owner;
65     token internal teamCup;
66     token internal cup;
67     uint256 public exchangePrice; // with decimals
68     bool public halting = true;
69 
70     event Halted(bool halting);
71     event Exchange(address user, uint256 distributedAmount, uint256 collectedAmount);
72 
73     /**
74      * Constructor function
75      *
76      * Setup the contract owner
77      */
78     constructor(address cupToken, address teamCupToken) public {
79         owner = msg.sender;
80         teamCup = token(teamCupToken);
81         cup = token(cupToken);
82     }
83 
84     modifier onlyOwner() {
85         require(msg.sender == owner);
86         _;
87     }
88 
89     /**
90      * User exchange for team cup
91      */
92     function exchange() public {
93         require(msg.sender != address(0x0));
94         require(msg.sender != address(this));
95         require(!halting);
96 
97         // collect cup token
98         uint256 allowance = cup.allowance(msg.sender, this);
99         require(allowance > 0);
100         require(cup.transferFrom(msg.sender, this, allowance));
101 
102         // transfer team cup token
103         uint256 teamCupBalance = teamCup.balanceOf(address(this));
104         uint256 teamCupAmount = allowance * exchangePrice;
105         require(teamCupAmount <= teamCupBalance);
106         require(teamCup.transfer(msg.sender, teamCupAmount));
107 
108         emit Exchange(msg.sender, teamCupAmount, allowance);
109     }
110 
111     /**
112      * Withdraw the funds
113      */
114     function safeWithdrawal(address safeAddress) public onlyOwner {
115         require(safeAddress != address(0x0));
116         require(safeAddress != address(this));
117 
118         uint256 balance = teamCup.balanceOf(address(this));
119         teamCup.transfer(safeAddress, balance);
120     }
121 
122     /**
123     * Set finalPriceForThisCoin
124     */
125     function setExchangePrice(int256 price) public onlyOwner {
126         require(price > 0);
127         exchangePrice = uint256(price);
128     }
129 
130     function halt() public onlyOwner {
131         halting = true;
132         emit Halted(halting);
133     }
134 
135     function unhalt() public onlyOwner {
136         halting = false;
137         emit Halted(halting);
138     }
139 }
140 
141 // File: contracts/cupExchange/cupExchangeImpl/EUCupExchange.sol
142 
143 contract EUCupExchange is CupExchange {
144     address public cup = 0x0750167667190A7Cd06a1e2dBDd4006eD5b522Cc;
145     address public teamCup = 0x8Aa2CA659280F7A2CCbF80061900d61F05712bc7;
146     constructor() CupExchange(cup, teamCup) public {}
147 }