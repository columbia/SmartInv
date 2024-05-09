1 pragma solidity ^0.4.2;
2 contract token { 
3     function transfer(address, uint256){  }
4     function balanceOf(address) constant returns (uint256) { }
5 }
6 
7 /// @title FairAuction contract
8 /// @author Christopher Grant - <christopher@delphi.markets>
9 contract FairAuction {
10     /* State */
11     address public beneficiary;
12     uint public amountRaised; uint public startTime; uint public deadline; uint public memberCount; uint public crowdsaleCap;
13     uint256 public tokenSupply;
14     token public tokenReward;
15     mapping(address => uint256) public balanceOf;
16     mapping (uint => address) accountIndex;
17     bool public finalized;
18 
19     /* Events */
20     event TokenAllocation(address recipient, uint amount);
21     event Finalized(address beneficiary, uint amountRaised);
22     event FundTransfer(address backer, uint amount);
23     event FundClaim(address claimant, uint amount);
24 
25     /* Initialize relevant crowdsale contract details */
26     function FairAuction(
27         address fundedAddress,
28         uint epochStartTime,
29         uint durationInMinutes,
30         uint256 capOnCrowdsale,
31         token contractAddressOfRewardToken
32     ) {
33         beneficiary = fundedAddress;
34         startTime = epochStartTime;
35         deadline = startTime + (durationInMinutes * 1 minutes);
36         tokenReward = token(contractAddressOfRewardToken);
37         crowdsaleCap = capOnCrowdsale * 1 ether;
38         finalized = false;
39     }
40 
41     /* default function (called whenever funds are sent to the FairAuction) */
42     function () payable {
43         /* Ensure that auction is ongoing */
44         if (now < startTime) throw;
45         if (now >= deadline) throw;
46 
47         uint amount = msg.value;
48 
49         /* Ensure that we do not pass the cap */
50         if (amountRaised + amount > crowdsaleCap) throw;
51 
52         uint256 existingBalance = balanceOf[msg.sender];
53 
54         /* Tally new members (helps iteration later) */
55         if (existingBalance == 0) {
56             accountIndex[memberCount] = msg.sender;
57             memberCount += 1;
58         } 
59         
60         /* Track contribution amount */
61         balanceOf[msg.sender] = existingBalance + amount;
62         amountRaised += amount;
63 
64         /* Fire FundTransfer event */
65         FundTransfer(msg.sender, amount);
66     }
67 
68     /* finalize() can be called once the FairAuction has ended, which will allow withdrawals */
69     function finalize() {
70         /* Nothing to finalize */
71         if (amountRaised == 0) throw;
72 
73         /* Auction still ongoing */
74         if (now < deadline) {
75             /* Don't terminate auction before cap is reached */
76             if (amountRaised < crowdsaleCap) throw;
77         }
78 
79         /* Snapshot available supply of reward tokens */
80         tokenSupply = tokenReward.balanceOf(this);
81 
82         /* Mark the FairAuction as finalized */
83         finalized = true;
84         /* Fire Finalized event */
85         Finalized(beneficiary, amountRaised);
86     }
87 
88     /* individualClaim() can be called by any auction participant once the FairAuction is finalized, to claim the tokens they are owed from the auction */
89     function individualClaim() {
90         /* Only allow once auction has been finalized */
91         if (!finalized) throw;
92 
93         /* Grant tokens due */
94         tokenReward.transfer(msg.sender, (balanceOf[msg.sender] * tokenSupply / amountRaised));
95         /* Fire TokenAllocation event */
96         TokenAllocation(msg.sender, (balanceOf[msg.sender] * tokenSupply / amountRaised));
97         /* Prevent repeat-withdrawals */
98         balanceOf[msg.sender] = 0;
99     }
100 
101     /* beneficiarySend() can be called once the FairAuction is finalized, to send the crowdsale proceeds to their destination address */
102     function beneficiarySend() {
103         /* Only allow once auction has been finalized */
104         if (!finalized) throw;
105 
106         /* Send proceeds to beneficiary */
107         if (beneficiary.send(amountRaised)) {
108             /* Fire FundClaim event */
109             FundClaim(beneficiary, amountRaised);
110         }
111     }
112 
113     /* automaticWithdrawLoop() can be called once the FairAuction is finalized to automatically allocate a batch of auctioned tokens */
114     function automaticWithdrawLoop(uint startIndex, uint endIndex) {
115         /* Only allow once auction has been finalized */
116         if (!finalized) throw;
117         
118         /* Distribute auctioned tokens fairly among a batch of participants. */
119         for (uint i=startIndex; i<=endIndex && i<memberCount; i++) {
120             /* Should not occur */
121             if (accountIndex[i] == 0)
122                 continue;
123             /* Grant tokens due */
124             tokenReward.transfer(accountIndex[i], (balanceOf[accountIndex[i]] * tokenSupply / amountRaised));
125             /* Fire TokenAllocation event */
126             TokenAllocation(accountIndex[i], (balanceOf[accountIndex[i]] * tokenSupply / amountRaised));
127             /* Prevent repeat-withdrawals */
128             balanceOf[accountIndex[i]] = 0;
129         }
130     }
131 }