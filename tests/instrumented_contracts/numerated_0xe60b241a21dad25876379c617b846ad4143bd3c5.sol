1 pragma solidity ^0.4.11;
2 
3 contract token {
4     function transfer(address receiver, uint amount);
5     function balanceOf( address _address )returns(uint256);
6 }
7 
8 contract StudioCrowdsale {
9     address public beneficiary;
10     address public owner;
11   
12     uint public amountRaised;
13     uint public tokensSold;
14     uint public deadline;
15     uint public price;
16     token public tokenReward;
17     
18     mapping(address => uint256) public contributions;
19     bool crowdSaleStart;
20     bool crowdSalePause;
21     bool crowdSaleClosed;
22 
23    
24     event FundTransfer(address participant, uint amount);
25 
26     modifier onlyOwner() {
27         if (msg.sender != owner) {
28             throw;
29         }
30         _;
31     }
32 
33     function StudioCrowdsale() {
34         beneficiary = msg.sender;
35         owner = msg.sender;
36         price =  .00000000002222222 ether;
37         tokenReward = token(0xe31f159cdc3370aec8ef5fbf3b7fce23766155f5);
38     }
39 
40     function () payable {
41         require(!crowdSaleClosed);
42         require(!crowdSalePause);
43         if ( crowdSaleStart) require( now < deadline );
44         if ( !crowdSaleStart && tokensSold > 250000000000000 ) throw;
45         uint amount = msg.value;
46         contributions[msg.sender] += amount;
47         amountRaised += amount;
48         tokensSold += amount / price;
49         
50         if (tokensSold >  250000000000000 && tokensSold  <=  850000000000000 ) { price = .00000000003333333 ether; }
51         if (tokensSold >  850000000000000 && tokensSold  <= 1350000000000000 ) { price = .00000000003636363 ether; }
52         if (tokensSold > 1350000000000000 && tokensSold <=  1850000000000000 ) { price = .00000000004444444 ether; }
53         if (tokensSold > 1850000000000000 ) { price = .00000000005 ether; }
54         
55         tokenReward.transfer(msg.sender, amount / price);
56         FundTransfer(msg.sender, amount );
57         beneficiary.transfer( amount );
58        
59     }
60 
61     // Start this October 27
62     function startCrowdsale() onlyOwner  {
63         
64         crowdSaleStart = true;
65         deadline = now + 120 days;
66         price =  .000000000033333333 ether;
67     }
68 
69     function endCrowdsale() onlyOwner  {
70         
71         
72         crowdSaleClosed = true;
73     }
74 
75 
76     function pauseCrowdsale() onlyOwner {
77         
78         crowdSalePause = true;
79         
80         
81     }
82 
83     function unpauseCrowdsale() onlyOwner {
84         
85         crowdSalePause = false;
86         
87         
88     }
89     
90     function transferOwnership ( address _newowner ) onlyOwner {
91         
92         owner = _newowner;
93         
94     }
95     
96     function transferBeneficiary ( address _newbeneficiary ) onlyOwner {
97         
98         beneficiary = _newbeneficiary;
99         
100     }
101     
102     function withdrawStudios() onlyOwner{
103         
104         uint256 balance = tokenReward.balanceOf(address(this));
105         
106         tokenReward.transfer( beneficiary, balance );
107         
108         
109     }
110     
111 }