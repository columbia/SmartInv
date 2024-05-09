1 pragma solidity ^0.4.16;
2 
3 /// @title Ownable
4 /// @dev The Ownable contract has an owner address, and provides basic authorization control functions, this simplifies
5 /// & the implementation of "user permissions".
6 
7 contract Ownable {
8     address public owner;
9     address public newOwnerCandidate;
10 
11     event OwnershipRequested(address indexed _by, address indexed _to);
12     event OwnershipTransferred(address indexed _from, address indexed _to);
13 
14     /// @dev The Ownable constructor sets the original `owner` of the contract to the sender account.
15     function Ownable() {
16         owner = msg.sender;
17     }
18 
19     /// @dev Throws if called by any account other than the owner.
20     modifier onlyOwner() {
21         if (msg.sender != owner) {
22             throw;
23         }
24 
25         _;
26     }
27 
28     /// @dev Proposes to transfer control of the contract to a newOwnerCandidate.
29     /// @param _newOwnerCandidate address The address to transfer ownership to.
30     function transferOwnership(address _newOwnerCandidate) onlyOwner {
31         require(_newOwnerCandidate != address(0));
32 
33         newOwnerCandidate = _newOwnerCandidate;
34 
35         OwnershipRequested(msg.sender, newOwnerCandidate);
36     }
37 
38     /// @dev Accept ownership transfer. This method needs to be called by the perviously proposed owner.
39     function acceptOwnership() {
40         if (msg.sender == newOwnerCandidate) {
41             owner = newOwnerCandidate;
42             newOwnerCandidate = address(0);
43 
44             OwnershipTransferred(owner, newOwnerCandidate);
45         }
46     }
47 }
48 
49 interface token {
50     function transfer(address _to, uint256 _amount);
51 }
52  
53 contract Crowdsale is Ownable {
54     
55     address public beneficiary = msg.sender;
56     token public epm;
57     
58     uint256 public constant EXCHANGE_RATE = 100; // 100 TKN for ETH
59     uint256 public constant DURATION = 30 days;
60     uint256 public startTime = 0;
61     uint256 public endTime = 0;
62     
63     uint public amount = 0;
64 
65     mapping(address => uint256) public balanceOf;
66     
67     event FundTransfer(address backer, uint amount, bool isContribution);
68 
69     /**
70      * Constructor function
71      *
72      */
73      
74     function Crowdsale() {
75         epm = token(0xA81b980c9FAAFf98ebA21DC05A9Be63f4C733979);
76         startTime = now;
77         endTime = startTime + DURATION;
78     }
79 
80     /**
81      * Fallback function
82      *
83      * The function without name is the default function that is called whenever anyone sends funds to a contract
84      */
85      
86     function () payable onlyDuringSale() {
87         uint SenderAmount = msg.value;
88         balanceOf[msg.sender] += SenderAmount;
89         amount = amount + SenderAmount;
90         epm.transfer(msg.sender, SenderAmount * EXCHANGE_RATE);
91         FundTransfer(msg.sender,  SenderAmount * EXCHANGE_RATE, true);
92     }
93 
94  /// @dev Throws if called when not during sale.
95     modifier onlyDuringSale() {
96         if (now < startTime || now >= endTime) {
97             throw;
98         }
99 
100         _;
101     }
102     
103     function Withdrawal()  {
104             if (amount > 0) {
105                 if (beneficiary.send(amount)) {
106                     FundTransfer(msg.sender, amount, false);
107                 } else {
108                     balanceOf[beneficiary] = amount;
109                 }
110             }
111 
112     }
113 }