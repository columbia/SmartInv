1 pragma solidity ^0.5.0;
2 
3 
4 
5 // https://github.com/ethereum/EIPs/issues/20
6 interface IERC20 {
7   function totalSupply() external view returns (uint totalSupply_);
8   function balanceOf(address _owner) external view returns (uint balance_);
9   function transfer(address _to, uint _value) external returns (bool success_);
10   function transferFrom(address _from, address _to, uint _value) external returns (bool success_);
11   function approve(address _spender, uint _value) external returns (bool success_);
12   function allowance(address _owner, address _spender) external view returns (uint remaining_);
13   // Triggered when tokens are transferred
14   event Transfer(address indexed _from, address indexed _to, uint _value);
15   // Triggered whenever approve(address _spender, uint _value) is called
16   event Approval(address indexed _owner, address indexed _spender, uint _value);
17 }
18 
19 contract StaffAVTScheme {
20   address public owner;
21   IERC20 public avt;
22   uint public schemeStartTimestamp;
23   uint8 public numDaysBetweenPayments;
24   uint8 public numPayments;
25 
26   mapping(address => uint) public AmountPerPayment;
27   mapping(address => uint) public NextPaymentDueTimestamp;
28   mapping(address => uint) public NumPaymentsLeft;
29 
30   modifier onlyOwner {
31     require(owner == msg.sender, "Sender must be owner");
32    _;
33   }
34 
35   /**
36    * @param _avt address of AVT ERC20 contract
37    * @param _schemeStartTimestamp no accounts can be added that start before this time
38    * @param _numDaysBetweenPayments number of days between each payment for accounts
39    * @param _numPayments number of payments for each account
40    */
41   constructor(IERC20 _avt, uint _schemeStartTimestamp, uint8 _numDaysBetweenPayments, uint8 _numPayments)
42     public
43   {
44     owner = msg.sender;
45     avt = _avt;
46     schemeStartTimestamp = _schemeStartTimestamp;
47     numDaysBetweenPayments = _numDaysBetweenPayments;
48     numPayments = _numPayments;
49   }
50 
51   function transferOwnership(address _newOwner)
52     public
53     onlyOwner
54   {
55     owner = _newOwner;
56   }
57 
58   /**
59    * NOTE: This method can only be called ONCE per address.
60    * @param _account address of the AVT claimant
61    * @param _firstPaymentTimestamp timestamp for the claimant's first payment
62    * @param _amountPerPayment amount of AVT (to 18 decimal places, aka NAT) to pay the claimant on each payment
63    */
64   function addAccount(address _account, uint _firstPaymentTimestamp, uint _amountPerPayment)
65     public
66     onlyOwner
67   {
68     require(AmountPerPayment[_account] == 0, "Already registered");
69     require(_firstPaymentTimestamp >= schemeStartTimestamp, "First payment timestamp is invalid");
70     require(_amountPerPayment != 0, "Amount is zero");
71     AmountPerPayment[_account] = _amountPerPayment;
72     NumPaymentsLeft[_account] = numPayments;
73     NextPaymentDueTimestamp[_account] = _firstPaymentTimestamp;
74   }
75 
76   /**
77    * Clear an account from the scheme. ONLY Use this if a staff member leaves the scheme.
78    */
79   function removeAccount(address _account)
80     public
81     onlyOwner
82   {
83     AmountPerPayment[_account] = 0;
84     NumPaymentsLeft[_account] = 0;
85     NextPaymentDueTimestamp[_account] = 0;
86   }
87 
88   /**
89    * Transfers AVT to the caller if they are in the scheme and have a valid claim. Reverts if not.
90    */
91   function claimAVT()
92     public
93   {
94     transferAVT(msg.sender);
95   }
96 
97   /**
98    * Transfers AVT to the specified account if they are in the scheme and have a valid claim. Reverts if not.
99    * @param _account the account to send AVT to
100    */
101   function sendAVT(address _account)
102     public
103   {
104     transferAVT(_account);
105   }
106 
107   function transferAVT(address _account)
108     private
109   {
110     uint paymentDueTimestamp = NextPaymentDueTimestamp[_account];
111     require(paymentDueTimestamp != 0, "Address is not registered on the scheme");
112 
113     uint numPaymentsLeft = NumPaymentsLeft[_account];
114     require(numPaymentsLeft != 0, "Address has claimed all their AVT");
115 
116     require(paymentDueTimestamp <= now, "Address is not eligible for a payment yet");
117 
118     uint numWholeDaysSincePaymentDueTimestamp = (now - paymentDueTimestamp)/1 days;
119 
120     uint numPaymentsToMake = 1 + numWholeDaysSincePaymentDueTimestamp/numDaysBetweenPayments;
121     if (numPaymentsToMake > numPaymentsLeft) {
122       numPaymentsToMake = numPaymentsLeft;
123     }
124     NumPaymentsLeft[_account] = numPaymentsLeft - numPaymentsToMake;
125     uint totalPayment = numPaymentsToMake * AmountPerPayment[_account];
126 
127     NextPaymentDueTimestamp[_account] = paymentDueTimestamp + (1 days * numDaysBetweenPayments * numPaymentsToMake);
128 
129     require(avt.balanceOf(address(this)) >= totalPayment, "Insufficient funds!");
130     assert(avt.transfer(_account, totalPayment));
131   }
132 }