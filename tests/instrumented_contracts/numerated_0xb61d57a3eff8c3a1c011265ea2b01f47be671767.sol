1 pragma solidity ^0.4.11;
2 
3 contract token {
4     function transfer(address receiver, uint amount);
5     function balanceOf( address _address )returns(uint256);
6 }
7 
8 contract DragonCrowdsale {
9     address public beneficiary;
10     address public owner;
11   
12     uint public amountRaised;
13     uint public tokensSold;
14     uint public deadline;
15     uint public price;
16     token public tokenReward;
17     mapping(address => uint256) public contributions;
18     bool crowdSaleStart;
19     bool crowdSalePause;
20     bool crowdSaleClosed;
21 
22    
23     event FundTransfer(address participant, uint amount);
24 
25     modifier onlyOwner() {
26         if (msg.sender != owner) {
27             throw;
28         }
29         _;
30     }
31 
32     function DragonCrowdsale() {
33         beneficiary = msg.sender;
34         owner = msg.sender;
35         price =  .003333333333333 ether;
36         tokenReward = token(0x5b29a6277c996b477d6632E60EEf41268311cE1c);
37     }
38 
39     function () payable {
40         require(!crowdSaleClosed);
41         require(!crowdSalePause);
42         if ( crowdSaleStart) require( now < deadline );
43         uint amount = msg.value;
44         contributions[msg.sender] += amount;
45         amountRaised += amount;
46         tokensSold += amount / price;
47         tokenReward.transfer(msg.sender, amount / price);
48         FundTransfer(msg.sender, amount );
49         beneficiary.transfer( amount );
50     }
51 
52     // Start this October 27
53     function startCrowdsale() onlyOwner  {
54         
55         crowdSaleStart = true;
56         deadline = now + 60 days;
57     }
58 
59     function endCrowdsale() onlyOwner  {
60         
61         
62         crowdSaleClosed = true;
63     }
64 
65 
66     function pauseCrowdsale() onlyOwner {
67         
68         crowdSalePause = true;
69         
70         
71     }
72 
73     function unpauseCrowdsale() onlyOwner {
74         
75         crowdSalePause = false;
76         
77         
78     }
79     
80     function transferOwnership ( address _newowner ) onlyOwner {
81         
82         owner = _newowner;
83         
84     }
85     
86     function transferBeneficiary ( address _newbeneficiary ) onlyOwner {
87         
88         beneficiary = _newbeneficiary;
89         
90     }
91     
92     function withdrawDragons() onlyOwner{
93         
94         uint256 balance = tokenReward.balanceOf(address(this));
95         
96         tokenReward.transfer( beneficiary, balance );
97         
98         
99     }
100     
101 }