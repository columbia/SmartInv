1 pragma solidity ^0.4.11;
2 
3 contract token {
4     function transfer(address receiver, uint amount);
5     function balanceOf( address _address )returns(uint256);
6     function burn ( uint256 amount ); 
7 }
8 
9 contract StudioCrowdsale {
10     address public beneficiary;
11     address public owner;
12   
13     uint public amountRaised;
14     uint public tokensSold;
15     uint public deadline;
16     uint public price;
17     token public tokenReward;
18     
19     mapping(address => uint256) public contributions;
20     bool crowdSaleStart;
21     bool crowdSalePause;
22     bool crowdSaleClosed;
23 
24    
25     event FundTransfer(address participant, uint amount);
26 
27     modifier onlyOwner() {
28         if (msg.sender != owner) {
29             throw;
30         }
31         _;
32     }
33 
34     function StudioCrowdsale() {
35         beneficiary = msg.sender;
36         owner = msg.sender;
37         price =  .00222222222 ether;
38         tokenReward = token(0xf064c38e3f5fa73981ee98372d32a16d032769cc);
39     }
40 
41     function () payable {
42         require(!crowdSaleClosed);
43         require(!crowdSalePause);
44         if ( crowdSaleStart) require( now < deadline );
45         if ( !crowdSaleStart && tokensSold > 2500000 ) throw;
46         uint amount = msg.value;
47         contributions[msg.sender] += amount;
48         amountRaised += amount;
49         tokensSold += amount / price;
50         
51         if (tokensSold >  2500000 && tokensSold  <=  8500000 ) { price = .00333333333 ether; }
52         if (tokensSold >  8500000 && tokensSold  <= 13500000 ) { price = .00363636363 ether; }
53         if (tokensSold > 13500000 && tokensSold <=  18500000 ) { price = .00444444444 ether; }
54         if (tokensSold > 18500000 ) { price = .005 ether; }
55         
56         tokenReward.transfer(msg.sender, amount / price);
57         FundTransfer(msg.sender, amount );
58         beneficiary.transfer( amount );
59        
60     }
61 
62     // Start this November 1
63     function startCrowdsale() onlyOwner  {
64         
65         crowdSaleStart = true;
66         deadline = now + 120 days;
67         price =  .0033333333333 ether;
68     }
69 
70     function endCrowdsale() onlyOwner  {
71         
72         
73         crowdSaleClosed = true;
74     }
75 
76 
77     function pauseCrowdsale() onlyOwner {
78         
79         crowdSalePause = true;
80         
81         
82     }
83 
84     function unpauseCrowdsale() onlyOwner {
85         
86         crowdSalePause = false;
87         
88         
89     }
90     
91     function transferOwnership ( address _newowner ) onlyOwner {
92         
93         owner = _newowner;
94         
95     }
96     
97     function transferBeneficiary ( address _newbeneficiary ) onlyOwner {
98         
99         beneficiary = _newbeneficiary;
100         
101     }
102     
103     function withdrawStudios() onlyOwner{
104         if ( now < deadline ){
105         uint256 balance = tokenReward.balanceOf(address(this));
106         tokenReward.transfer( beneficiary, balance );}
107         else tokenReward.burn(tokenReward.balanceOf(address(this)));
108         
109         
110     }
111     
112 }