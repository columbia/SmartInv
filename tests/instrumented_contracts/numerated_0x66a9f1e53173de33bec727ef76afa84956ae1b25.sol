1 pragma solidity ^0.4.25;
2 
3 /**
4  * 
5  * World War Goo - Competitive Idle Game
6  * 
7  * https://ethergoo.io
8  * 
9  */
10 
11 contract Bankroll {
12     
13     uint256 public gooPurchaseAllocation; // Wei destined to pay to burn players' goo
14     uint256 public tokenPurchaseAllocation; // Wei destined to purchase tokens for clans
15     address public owner;
16     
17     GooBurnAlgo public gooBurner = GooBurnAlgo(0x0);
18     Clans clans = Clans(0x0);
19     address constant gooToken = address(0xdf0960778c6e6597f197ed9a25f12f5d971da86c);
20     event TokenPurchase(address tokenAddress, uint256 tokensBought, uint256 reimbursementWei);
21     
22     constructor() public {
23         owner = msg.sender;
24     }
25     
26     function() payable external {
27         // Accepts donations
28     }
29     
30     function setClans(address clansContract) external {
31         require(msg.sender == owner);
32         clans = Clans(clansContract);
33     }
34     
35     function depositEth(uint256 gooAllocation, uint256 tokenAllocation) payable external {
36         require(gooAllocation <= 100);
37         require(tokenAllocation <= 100);
38         require(gooAllocation + tokenAllocation <= 100);
39         
40         gooPurchaseAllocation += (msg.value * gooAllocation) / 100;
41         tokenPurchaseAllocation += (msg.value * tokenAllocation) / 100;
42     }
43     
44     function updateGooBurnAlgo(address config) external {
45         require(msg.sender == owner);
46         gooBurner = GooBurnAlgo(config);
47     }
48     
49     // Not entirely trustless but seems only way
50     function refundTokenPurchase(uint256 clanId, uint256 tokensAmount, uint256 reimbursement) external {
51         require(msg.sender == owner);
52         require(tokensAmount > 0);
53         require(clans.exists(clanId));
54         
55         // Transfer tokens
56         address tokenAddress = clans.clanToken(clanId);
57         require(ERC20(tokenAddress).transferFrom(owner, address(clans), tokensAmount));
58         
59         // Reimburse purchaser
60         require(reimbursement >= tokenPurchaseAllocation);
61         tokenPurchaseAllocation -= reimbursement;
62         owner.transfer(reimbursement);
63         
64         // Auditable log
65         emit TokenPurchase(tokenAddress, tokensAmount, reimbursement);
66     }
67     
68     function increaseGooPurchaseAllocation(uint256 newAllocation) external {
69         require(msg.sender == owner);
70         require(newAllocation < (address(this).balance - tokenPurchaseAllocation));
71         gooPurchaseAllocation = newAllocation;
72     }
73     
74     function increaseTokenPurchaseAllocation(uint256 newAllocation) external {
75         require(msg.sender == owner);
76         require(newAllocation < (address(this).balance - gooPurchaseAllocation));
77         tokenPurchaseAllocation = newAllocation;
78     }
79     
80     function receiveApproval(address player, uint256 amount, address, bytes) external {
81         require(msg.sender == gooToken);
82         
83         // Calculate payment
84         uint256 payment = gooBurner.priceOf(amount);
85         require(payment <= gooPurchaseAllocation);
86         
87         // Burn Goo
88         ERC20(msg.sender).transferFrom(player, address(0), amount);
89         
90         // Send Eth
91         gooPurchaseAllocation -= payment;
92         player.transfer(payment);
93     }
94     
95 }
96 
97 contract GooBurnAlgo {
98     
99     Bankroll constant bankroll = Bankroll(0x66a9f1e53173de33bec727ef76afa84956ae1b25);
100     GooToken constant goo = GooToken(0xdf0960778c6e6597f197ed9a25f12f5d971da86c);
101 
102     address public owner; // Minor Management
103 
104     constructor() public {
105         owner = msg.sender;
106     }
107     
108     // Initial naive algorithm, splitting (half) eth between totalSupply
109     function priceOf(uint256 amount) external view returns(uint256 payment) {
110         payment = (bankroll.gooPurchaseAllocation() * amount) / (goo.totalSupply() * 2);
111     }
112     
113     function price() external view returns(uint256 gooPrice) {
114         gooPrice = bankroll.gooPurchaseAllocation() / (goo.totalSupply() * 2);
115     }
116     
117 }
118 
119 contract Clans {
120     function exists(uint256 clanId) public view returns (bool);
121     mapping(uint256 => address) public clanToken; // i.e. BNB
122 }
123 
124 contract GooToken {
125     function totalSupply() external view returns(uint256);
126 }
127 
128 contract ERC20 {
129     function transferFrom(address from, address to, uint tokens) external returns (bool success);
130 }