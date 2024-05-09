1 pragma solidity ^0.4.23;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
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
33 contract ERC20Basic {
34   // events
35   event Transfer(address indexed from, address indexed to, uint256 value);
36 
37   // public functions
38   function totalSupply() public view returns (uint256);
39   function balanceOf(address addr) public view returns (uint256);
40   function transfer(address to, uint256 value) public returns (bool);
41 }
42 
43 contract ERC20 is ERC20Basic {
44   // events
45   event Approval(address indexed owner, address indexed agent, uint256 value);
46 
47   // public functions
48   function allowance(address owner, address agent) public view returns (uint256);
49   function transferFrom(address from, address to, uint256 value) public returns (bool);
50   function approve(address agent, uint256 value) public returns (bool);
51 
52 }
53 
54 library SafeERC20 {
55 
56   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
57     require(token.transfer(to, value));
58   }
59 
60   function safeTransferFrom(
61     ERC20 token,
62     address from,
63     address to,
64     uint256 value
65   )
66     internal
67   {
68     require(token.transferFrom(from, to, value));
69   }
70 
71   function safeApprove(ERC20 token, address spender, uint256 value) internal {
72     require(token.approve(spender, value));
73   }
74 }
75 
76 contract Ownable {
77 
78   // public variables
79   address public owner;
80 
81   // internal variables
82 
83   // events
84   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
85 
86   // public functions
87   constructor() public {
88     owner = msg.sender;
89   }
90 
91   modifier onlyOwner() {
92     require(msg.sender == owner);
93     _;
94   }
95 
96   function transferOwnership(address newOwner) public onlyOwner {
97     require(newOwner != address(0));
98     emit OwnershipTransferred(owner, newOwner);
99     owner = newOwner;
100   }
101 
102   // internal functions
103 }
104 
105 
106 contract TokenBatchTransfer is Ownable {
107   using SafeERC20 for ERC20Basic;
108   using SafeMath for uint256;
109 
110   // public variables
111   ERC20Basic public ERC20Token;
112 
113   // internal variables
114   uint256 _totalSupply;
115 
116   // events
117 
118   // public functions
119   constructor (
120     ERC20Basic token
121   )
122     public
123   {
124     ERC20Token = ERC20Basic(token);
125   }
126 
127   function amountOf() public view returns (uint256 amount) {
128     return ERC20Token.balanceOf(address(this));
129   }
130 
131   function safeTransfer(address funder, uint256 amount) public onlyOwner {
132     ERC20Token.safeTransfer(funder, amount);
133   }
134 
135   function changeToken(ERC20Basic token) public onlyOwner {
136     ERC20Token = ERC20Basic(token);
137   }
138 
139   function batchTransfer(address[] funders, uint256[] amounts) public onlyOwner {
140     require(funders.length > 0 && funders.length == amounts.length);
141 
142     uint256 total = ERC20Token.balanceOf(this);
143     require(total > 0);
144 
145     uint256 fundersTotal = 0;
146     for (uint i = 0; i < amounts.length; i++) {
147       fundersTotal = fundersTotal.add(amounts[i]);
148     }
149     require(total >= fundersTotal);
150 
151     for (uint j = 0; j < funders.length; j++) {
152       ERC20Token.safeTransfer(funders[j], amounts[j]);
153     }
154   }
155 }