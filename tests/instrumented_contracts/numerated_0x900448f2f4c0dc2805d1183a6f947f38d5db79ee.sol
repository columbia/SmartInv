1 pragma solidity ^0.4.21;
2 
3 interface IERC20Token {
4     function totalSupply() public constant returns (uint);
5     function balanceOf(address tokenlender) public constant returns (uint balance);
6     function allowance(address tokenlender, address spender) public constant returns (uint remaining);
7     function transfer(address to, uint tokens) public returns (bool success);
8     function approve(address spender, uint tokens) public returns (bool success);
9     function transferFrom(address from, address to, uint tokens) public returns (bool success);
10 
11     event Transfer(address indexed from, address indexed to, uint tokens);
12     event Approval(address indexed tokenlender, address indexed spender, uint tokens);
13 }
14 
15 contract LoanRequest_iii {
16     address public borrower = msg.sender;
17     IERC20Token public token;
18     uint256 public collateralAmount;
19     uint256 public loanAmount;
20     uint256 public payoffAmount;
21     uint256 public loanDuration;
22 
23     function LoanRequest(
24         IERC20Token _token,
25         uint256 _collateralAmount,
26         uint256 _loanAmount,
27         uint256 _payoffAmount,
28         uint256 _loanDuration
29     )
30         public
31     {
32         token = _token;
33         collateralAmount = _collateralAmount;
34         loanAmount = _loanAmount;
35         payoffAmount = _payoffAmount;
36         loanDuration = _loanDuration;
37     }
38 
39     Loan public loan;
40 
41     event LoanRequestAccepted(address loan);
42 
43     function lendEther() public payable {
44         require(msg.value == loanAmount);
45         loan = new Loan(
46             msg.sender,
47             borrower,
48             token,
49             collateralAmount,
50             payoffAmount,
51             loanDuration
52         );
53         require(token.transferFrom(borrower, loan, collateralAmount));
54         borrower.transfer(loanAmount);
55         emit LoanRequestAccepted(loan);
56     }
57 }
58 
59 contract Loan {
60     address public lender;
61     address public borrower;
62     IERC20Token public token;
63     uint256 public collateralAmount;
64     uint256 public payoffAmount;
65     uint256 public dueDate;
66 
67     function Loan(
68         address _lender,
69         address _borrower,
70         IERC20Token _token,
71         uint256 _collateralAmount,
72         uint256 _payoffAmount,
73         uint256 loanDuration
74     )
75         public
76     {
77         lender = _lender;
78         borrower = _borrower;
79         token = _token;
80         collateralAmount = _collateralAmount;
81         payoffAmount = _payoffAmount;
82         dueDate = now + loanDuration;
83     }
84 
85     event LoanPaid();
86 
87     function payLoan() public payable {
88         require(now <= dueDate);
89         require(msg.value == payoffAmount);
90 
91         require(token.transfer(borrower, collateralAmount));
92         emit LoanPaid();
93         selfdestruct(lender);
94     }
95 
96     function repossess() public {
97         require(now > dueDate);
98 
99         require(token.transfer(lender, collateralAmount));
100         selfdestruct(lender);
101     }
102 }