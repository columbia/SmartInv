1 pragma solidity ^0.4.24;
2 
3 contract Ownable{}
4 contract CREDITS is Ownable {
5     mapping (address => uint256) internal balanceOf;
6     function transfer (address _to, uint256 _value) public returns (bool);
7    // function balanceOf (address _owner) public view returns (uint256 balance);
8 }
9 
10 contract SwapContractDateumtoPDATA {
11     //storage
12     address public owner;
13     CREDITS public company_token;
14 
15     address public PartnerAccount;
16     uint public originalBalance;
17     uint public currentBalance;
18     uint public alreadyTransfered;
19     uint public startDateOfPayments;
20     uint public endDateOfPayments;
21     uint public periodOfOnePayments;
22     uint public limitPerPeriod;
23     uint public daysOfPayments;
24 
25     //modifiers
26     modifier onlyOwner
27     {
28         require(owner == msg.sender);
29         _;
30     }
31   
32   
33     //Events
34     event Transfer(address indexed to, uint indexed value);
35     event OwnerChanged(address indexed owner);
36 
37 
38     //constructor
39     constructor (CREDITS _company_token) public {
40         owner = msg.sender;
41         PartnerAccount = 0x9fb9Ec557A13779C69cfA3A6CA297299Cb55E992;
42         company_token = _company_token;
43         //originalBalance = 10000000   * 10**8; // 10 000 000   XDT
44         //currentBalance = originalBalance;
45         //alreadyTransfered = 0;
46         //startDateOfPayments = 1561939200; //From 01 Jun 2019, 00:00:00
47         //endDateOfPayments = 1577836800; //To 01 Jan 2020, 00:00:00
48         //periodOfOnePayments = 24 * 60 * 60; // 1 day in seconds
49         //daysOfPayments = (endDateOfPayments - startDateOfPayments) / periodOfOnePayments; // 184 days
50         //limitPerPeriod = originalBalance / daysOfPayments;
51     }
52 
53 
54     /// @dev Fallback function: don't accept ETH
55     function()
56         public
57         payable
58     {
59         revert();
60     }
61 
62 
63 
64 
65     function setOwner(address _owner) 
66         public 
67         onlyOwner 
68     {
69         require(_owner != 0);
70      
71         owner = _owner;
72         emit OwnerChanged(owner);
73     }
74   
75     function sendCurrentPayment() public {
76         if (now > startDateOfPayments) {
77             //uint currentPeriod = (now - startDateOfPayments) / periodOfOnePayments;
78             //uint currentLimit = currentPeriod * limitPerPeriod;
79             //uint unsealedAmount = currentLimit - alreadyTransfered;
80             company_token.transfer(PartnerAccount, 1);
81             
82 	    }
83     }
84 }