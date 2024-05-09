1 pragma solidity ^0.4.24;
2 
3 contract CryptoPunk
4 {
5   function punkIndexToAddress(uint256 punkIndex) public view returns (address ownerAddress);
6   function balanceOf(address tokenOwner) public view returns (uint balance);
7   function transferPunk(address to, uint punkIndex) public;
8 }
9 
10 contract ERC20
11 {
12   function balanceOf(address tokenOwner) public view returns (uint balance);
13   function transfer(address to, uint tokens) public returns (bool success);
14 }
15 
16 contract PunkLombard
17 {
18   address public CryptoPunksContract;
19 
20   uint256 public loanAmount; //amount of loan in wei
21   uint256 public punkIndex; //punk identifier
22   uint256 public annualInterestRate; // 10% = 100000000000000000
23   uint256 public loanTenor; //loan term; seconds after start of loan when default occurs and punk can be claimed
24   uint256 public loanPeriod; //effective number of seconds until loan was repaid
25   address public lender; //address providing loan proceeds
26   address public borrower; //address putting the CryptoPunk up as collateral
27   uint256 public loanStart; //time when lender sent ETH
28   uint256 public loanEnd; //time when borrower repaid loan + interest
29   uint256 public interest; //effective interest amount in ETH
30 
31   address public contractOwner;
32 
33   modifier onlyOwner
34   {
35     if (msg.sender != contractOwner) revert();
36     _;
37   }
38 
39   modifier onlyLender
40   {
41     if (msg.sender != lender) revert();
42     _;
43   }
44 
45   constructor () public
46   {
47     CryptoPunksContract = 0xb47e3cd837dDF8e4c57F05d70Ab865de6e193BBB; //MainNet
48     contractOwner = msg.sender;
49     borrower = msg.sender;
50   }
51 
52   function transferContractOwnership(address newContractOwner) public onlyOwner
53   {
54     contractOwner = newContractOwner;
55   }
56 
57   function setTerms(uint256 _loanAmount, uint256 _annualInterestRate, uint256 _loanTenor, uint256 _punkIndex) public onlyOwner
58   {
59     require(CryptoPunk(CryptoPunksContract).balanceOf(address(this)) == 1);
60     loanAmount = _loanAmount;
61     annualInterestRate = _annualInterestRate;
62     loanTenor = _loanTenor;
63     punkIndex = _punkIndex;
64   }
65 
66 
67   function claimCollateral() public onlyLender //in case of default
68   {
69     require(now > (loanStart + loanTenor));
70     CryptoPunk(CryptoPunksContract).transferPunk(lender, punkIndex); //lender now gets ownership of punk
71   }
72 
73   function () payable public
74   {
75 
76     if(msg.sender == borrower) //repaying loan
77     {
78       require(now <= (loanStart + loanTenor)); //if loan tenor lapses, loan defaults and repayment no longer possible
79       uint256 loanPeriodCheck = (now - loanStart);
80       interest = (((loanAmount * annualInterestRate) / 10 ** 18) * loanPeriodCheck) / 365 days;
81       require(msg.value >= loanAmount + interest);
82       loanPeriod = loanPeriodCheck;
83       loanEnd = now;
84       uint256 change = msg.value - (loanAmount + interest);
85       lender.transfer(loanAmount + interest);
86       if(change > 0)
87       {
88         borrower.transfer(change);
89       }
90       CryptoPunk(CryptoPunksContract).transferPunk(borrower, punkIndex); //transfer punk ownership back to borrower after successful repayment
91     }
92 
93     if(msg.sender != borrower) // lender sending loan principal
94     {
95       require(loanStart == 0); //Loan proceeds can only be sent once
96       require(CryptoPunk(CryptoPunksContract).balanceOf(address(this)) == 1); //lombard contract should only own 1 punk
97       require(CryptoPunk(CryptoPunksContract).punkIndexToAddress(punkIndex) == address(this));  //ensure the lombard contract owns the punk specified
98       require(msg.value >= loanAmount); //primitive interest
99       lender = msg.sender;
100       loanStart = now;
101       if(msg.value > loanAmount) //lender sent amount in excess of loanAmount
102       {
103         msg.sender.transfer(msg.value-loanAmount); //return excess amount
104       }
105       borrower.transfer(loanAmount); //send loan proceeds through to borrower
106     }
107 
108   }
109 
110   //to rescue trapped tokens
111   function transfer_targetToken(address target, address to, uint256 quantity) public onlyOwner
112   {
113     ERC20(target).transfer(to, quantity);
114   }
115 
116   //abiltiy to reclaim pumk before loan has begun
117   function reclaimPunkBeforeLoan(address _to, uint256 _punkIndex) public onlyOwner
118   {
119     require(loanStart == 0);
120     CryptoPunk(CryptoPunksContract).transferPunk(_to, _punkIndex);
121   }
122 }