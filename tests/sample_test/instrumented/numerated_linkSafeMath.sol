1 1 // Sources flattened with hardhat v2.1.2 https://hardhat.org
2 
3 2 // File contracts/v0.4/token/linkERC20Basic.sol
4 
5 3 pragma solidity ^0.4.11;
6 
7 
8 4 /**
9 5  * @title ERC20Basic
10 6  * @dev Simpler version of ERC20 interface
11 7  * @dev see https://github.com/ethereum/EIPs/issues/179
12 8  */
13 9 contract linkERC20Basic {
14 10   uint256 public totalSupply;
15 11   function balanceOf(address who) constant returns (uint256);
16 12   function transfer(address to, uint256 value) returns (bool);
17 13   event Transfer(address indexed from, address indexed to, uint256 value);
18 14 }
19 
20 
21 15 // File contracts/v0.4/token/linkERC20.sol
22 
23 
24 16 /**
25 17  * @title ERC20 interface
26 18  * @dev see https://github.com/ethereum/EIPs/issues/20
27 19  */
28 20 contract linkERC20 is linkERC20Basic {
29 21   function allowance(address owner, address spender) constant returns (uint256);
30 22   function transferFrom(address from, address to, uint256 value) returns (bool);
31 23   function approve(address spender, uint256 value) returns (bool);
32 24   event Approval(address indexed owner, address indexed spender, uint256 value);
33 25 }
34 
35 
36 26 // File contracts/v0.4/token/ERC677.sol
37 
38 
39 27 contract ERC677 is linkERC20 {
40 28   function transferAndCall(address to, uint value, bytes data) returns (bool success);
41 
42 29   event Transfer(address indexed from, address indexed to, uint value, bytes data);
43 30 }
44 
45 
46 31 // File contracts/v0.4/token/ERC677Receiver.sol
47 
48 
49 
50 
51 32 contract ERC677Receiver {
52 33   function onTokenTransfer(address _sender, uint _value, bytes _data);
53 34 }
54 
55 
56 35 // File contracts/v0.4/ERC677Token.sol
57 
58 
59 
60 36 contract ERC677Token is ERC677 {
61 
62 37   /**
63 38   * @dev transfer token to a contract address with additional data if the recipient is a contact.
64 39   * @param _to The address to transfer to.
65 40   * @param _value The amount to be transferred.
66 41   * @param _data The extra data to be passed to the receiving contract.
67 42   */
68 43   function transferAndCall(address _to, uint _value, bytes _data)
69 44     public
70 45     returns (bool success)
71 46   {
72 47     super.transfer(_to, _value);
73 48     Transfer(msg.sender, _to, _value, _data);
74 49     if (isContract(_to)) {
75 50       contractFallback(_to, _value, _data);
76 51     }
77 52     return true;
78 53   }
79 
80 
81 54   // PRIVATE
82 55  //bug: this is the buggy fall back that allows reentrancy
83 56   function contractFallback(address _to, uint _value, bytes _data)
84 57     private
85 58   {
86 59     ERC677Receiver receiver = ERC677Receiver(_to);
87 60     receiver.onTokenTransfer(msg.sender, _value, _data);
88 61   }
89 
90 62   function isContract(address _addr)
91 63     private
92 64     returns (bool hasCode)
93 65   {
94 66     uint length;
95 67     assembly { length := extcodesize(_addr) }
96 68     return length > 0;
97 69   }
98 
99 70 }
100 
101 
102 
103 71 abstract contract CToken {
104         
105 72         function doTransferOut(address payable to, uint amount) virtual internal;
106 
107 73         doTransferOut(borrower, borrowAmount);
108         
109 74         /* We write the previously calculated values into storage */
110 75         accountBorrows[borrower].principal = vars.accountBorrowsNew;
111 76         accountBorrows[borrower].interestIndex = borrowIndex;
112 77         totalBorrows = vars.totalBorrowsNew;
113  
114 78         /* We emit a Borrow event */
115 79         emit Borrow(borrower, borrowAmount, vars.accountBorrowsNew, vars.totalBorrowsNew);
116 
117 80 }
118 81 // File contracts/v0.4/math/linkSafeMath.sol
119 
120 
121 
122 
123 82 /**
124 83  * @title SafeMath
125 84  * @dev Math operations with safety checks that throw on error
126 85  */
127 86 library linkSafeMath {
128 87   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
129 88     uint256 c = a * b;
130 89     return c;
131 90   }
132 
133 91   function div(uint256 a, uint256 b) internal constant returns (uint256) {
134 92     uint256 c = a / b;
135 93     return c;
136 94   }
137 
138 95   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
139 96     return a - b;
140 97   }
141 
142 98   function add(uint256 a, uint256 b) internal constant returns (uint256) {
143 99     uint256 c = a + b;
144 100     return c;
145 101   }
146 102 }
