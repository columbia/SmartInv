1 pragma solidity ^0.5.0;
2 
3 contract Ownable {
4     address private _owner;
5 
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8     /**
9      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
10      * account.
11      */
12     constructor () internal {
13         _owner = msg.sender;
14         emit OwnershipTransferred(address(0), _owner);
15     }
16 
17     /**
18      * @return the address of the owner.
19      */
20     function owner() public view returns (address) {
21         return _owner;
22     }
23 
24     /**
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner() {
28         require(isOwner());
29         _;
30     }
31 
32     /**
33      * @return true if `msg.sender` is the owner of the contract.
34      */
35     function isOwner() public view returns (bool) {
36         return msg.sender == _owner;
37     }
38 
39     /**
40      * @dev Allows the current owner to relinquish control of the contract.
41      * @notice Renouncing to ownership will leave the contract without an owner.
42      * It will not be possible to call the functions with the `onlyOwner`
43      * modifier anymore.
44      */
45     function renounceOwnership() public onlyOwner {
46         emit OwnershipTransferred(_owner, address(0));
47         _owner = address(0);
48     }
49 
50     /**
51      * @dev Allows the current owner to transfer control of the contract to a newOwner.
52      * @param newOwner The address to transfer ownership to.
53      */
54     function transferOwnership(address newOwner) public onlyOwner {
55         _transferOwnership(newOwner);
56     }
57 
58     /**
59      * @dev Transfers control of the contract to a newOwner.
60      * @param newOwner The address to transfer ownership to.
61      */
62     function _transferOwnership(address newOwner) internal {
63         require(newOwner != address(0));
64         emit OwnershipTransferred(_owner, newOwner);
65         _owner = newOwner;
66     }
67 }
68 
69 
70 contract Whitelisting is Ownable {
71     mapping(address => bool) public isInvestorApproved;
72     mapping(address => bool) public isInvestorPaymentApproved;
73 
74     event Approved(address indexed investor);
75     event Disapproved(address indexed investor);
76 
77     event PaymentApproved(address indexed investor);
78     event PaymentDisapproved(address indexed investor);
79 
80 
81     //Token distribution approval (KYC results)
82     function approveInvestor(address toApprove) public onlyOwner {
83         isInvestorApproved[toApprove] = true;
84         emit Approved(toApprove);
85     }
86 
87     function approveInvestorsInBulk(address[] calldata toApprove) external onlyOwner {
88         for (uint i=0; i<toApprove.length; i++) {
89             isInvestorApproved[toApprove[i]] = true;
90             emit Approved(toApprove[i]);
91         }
92     }
93 
94     function disapproveInvestor(address toDisapprove) public onlyOwner {
95         delete isInvestorApproved[toDisapprove];
96         emit Disapproved(toDisapprove);
97     }
98 
99     function disapproveInvestorsInBulk(address[] calldata toDisapprove) external onlyOwner {
100         for (uint i=0; i<toDisapprove.length; i++) {
101             delete isInvestorApproved[toDisapprove[i]];
102             emit Disapproved(toDisapprove[i]);
103         }
104     }
105 
106     //Investor payment approval (For private sale)
107     function approveInvestorPayment(address toApprove) public onlyOwner {
108         isInvestorPaymentApproved[toApprove] = true;
109         emit PaymentApproved(toApprove);
110     }
111 
112     function approveInvestorsPaymentInBulk(address[] calldata toApprove) external onlyOwner {
113         for (uint i=0; i<toApprove.length; i++) {
114             isInvestorPaymentApproved[toApprove[i]] = true;
115             emit PaymentApproved(toApprove[i]);
116         }
117     }
118 
119     function disapproveInvestorapproveInvestorPayment(address toDisapprove) public onlyOwner {
120         delete isInvestorPaymentApproved[toDisapprove];
121         emit PaymentDisapproved(toDisapprove);
122     }
123 
124     function disapproveInvestorsPaymentInBulk(address[] calldata toDisapprove) external onlyOwner {
125         for (uint i=0; i<toDisapprove.length; i++) {
126             delete isInvestorPaymentApproved[toDisapprove[i]];
127             emit PaymentDisapproved(toDisapprove[i]);
128         }
129     }
130 
131 }