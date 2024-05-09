1 /**
2  * Source Code first verified at https://etherscan.io on Friday, February 1, 2019
3  (UTC) */
4 
5 pragma solidity ^0.4.24;
6 
7 
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 contract ERC20Basic {
38   // events
39   event Transfer(address indexed from, address indexed to, uint256 value);
40 
41   // public functions
42   function totalSupply() public view returns (uint256);
43   function balanceOf(address addr) public view returns (uint256);
44   function transfer(address to, uint256 value) public returns (bool);
45 }
46 
47 contract ERC20 is ERC20Basic {
48   // events
49   event Approval(address indexed owner, address indexed agent, uint256 value);
50 
51   // public functions
52   function allowance(address owner, address agent) public view returns (uint256);
53   function transferFrom(address from, address to, uint256 value) public returns (bool);
54   function approve(address agent, uint256 value) public returns (bool);
55 
56 }
57 
58 library SafeERC20 {
59   
60   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
61     require(token.transfer(to, value));
62   }
63 
64   function safeTransferFrom(
65     ERC20 token,
66     address from,
67     address to,
68     uint256 value
69   )
70     internal
71   {
72     require(token.transferFrom(from, to, value));
73   }
74 
75   function safeApprove(ERC20 token, address spender, uint256 value) internal {
76     require(token.approve(spender, value));
77   }
78 }
79 
80 contract Ownable {
81 
82   // public variables
83   address public owner;
84 
85   // internal variables
86 
87   // events
88   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89 
90   // public functions
91   constructor() public {
92     owner = msg.sender;
93   }
94 
95   modifier onlyOwner() {
96     require(msg.sender == owner);
97     _;
98   }
99 
100   function transferOwnership(address newOwner) public onlyOwner {
101     require(newOwner != address(0));
102     emit OwnershipTransferred(owner, newOwner);
103     owner = newOwner;
104   }
105 
106   // internal functions
107 }
108 
109 
110 contract TokenBatchTransfer is Ownable {
111   using SafeERC20 for ERC20Basic;
112   using SafeMath for uint256;
113 
114   // public variables
115   ERC20Basic public token;
116   // events
117   // public functions
118   constructor (ERC20Basic tokenAddr) public {
119     token = ERC20Basic(tokenAddr);
120   }
121 
122   function changeToken(ERC20Basic tokenAddr) public onlyOwner {
123     token = ERC20Basic(tokenAddr);
124   }
125 
126   function balanceOfToken() public view returns (uint256 amount) {
127     return token.balanceOf(address(this));
128   }
129 
130   function safeTransfer(address funder, uint256 amount) public onlyOwner {
131     token.safeTransfer(funder, amount);
132   }
133 
134   function batchTransfer(address[] funders, uint256[] amounts) public onlyOwner {
135     require(funders.length > 0 && funders.length == amounts.length);
136 
137     uint256 total = token.balanceOf(this);
138     require(total > 0);
139 
140     uint256 fundersTotal = 0;
141     for (uint i = 0; i < amounts.length; i++) {
142       fundersTotal = fundersTotal.add(amounts[i]);
143     }
144     require(total >= fundersTotal);
145 
146     for (uint j = 0; j < funders.length; j++) {
147       token.safeTransfer(funders[j], amounts[j]);
148     }
149   }
150 }