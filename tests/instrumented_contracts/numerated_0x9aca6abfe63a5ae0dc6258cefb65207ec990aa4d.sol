1 pragma solidity ^0.4.4;
2 
3 contract DigiPulse {
4 
5 	// Token data for ERC20
6   string public constant name = "DigiPulse";
7   string public constant symbol = "DGT";
8   uint8 public constant decimals = 8;
9   mapping (address => uint256) public balanceOf;
10 
11   // Max available supply is 16581633 * 1e8 (incl. 100000 presale and 2% bounties)
12   uint constant tokenSupply = 16125000 * 1e8;
13   uint8 constant dgtRatioToEth = 250;
14   uint constant raisedInPresale = 961735343125;
15   mapping (address => uint256) ethBalanceOf;
16   address owner;
17 
18   // For LIVE
19   uint constant startOfIco = 1501833600; // 08/04/2017 @ 8:00am (UTC)
20   uint constant endOfIco = 1504223999; // 08/31/2017 @ 23:59pm (UTC)
21 
22   uint allocatedSupply = 0;
23   bool icoFailed = false;
24   bool icoFulfilled = false;
25 
26   // Generate public event that will notify clients
27 	event Transfer(address indexed from, address indexed to, uint256 value);
28   event Refund(address indexed _from, uint256 _value);
29 
30   // No special actions are required upon creation, so initialiser is left empty
31   function DigiPulse() {
32     owner = msg.sender;
33   }
34 
35   // For future transfers of DGT
36   function transfer(address _to, uint256 _value) {
37     require (balanceOf[msg.sender] >= _value);          // Check if the sender has enough
38     require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
39 
40     balanceOf[msg.sender] -= _value;                    // Subtract from the sender
41     balanceOf[_to] += _value;                           // Add the same to the recipient
42 
43     Transfer(msg.sender, _to, _value);
44   }
45 
46   // logic which converts eth to dgt and stores in allocatedSupply
47   function() payable external {
48     // Abort if crowdfunding has reached an end
49     require (now > startOfIco);
50     require (now < endOfIco);
51     require (!icoFulfilled);
52 
53     // Do not allow creating 0 tokens
54     require (msg.value != 0);
55 
56     // Must adjust number of decimals, so the ratio will work as expected
57     // From ETH 16 decimals to DGT 8 decimals
58     uint256 dgtAmount = msg.value / 1e10 * dgtRatioToEth;
59     require (dgtAmount < (tokenSupply - allocatedSupply));
60 
61     // Tier bonus calculations
62     uint256 dgtWithBonus;
63     uint256 applicable_for_tier;
64 
65     for (uint8 i = 0; i < 4; i++) {
66       // Each tier has same amount of DGT
67       uint256 tier_amount = 3750000 * 1e8;
68       // Every next tier has 5% less bonus pool
69       uint8 tier_bonus = 115 - (i * 5);
70       applicable_for_tier += tier_amount;
71 
72       // Skipping over this tier, since it is filled already
73       if (allocatedSupply >= applicable_for_tier) continue;
74 
75       // Reached this tier with 0 amount, so abort
76       if (dgtAmount == 0) break;
77 
78       // Cases when part of the contribution is covering two tiers
79       int256 diff = int(allocatedSupply) + int(dgtAmount - applicable_for_tier);
80 
81       if (diff > 0) {
82         // add bonus for current tier and strip the difference for
83         // calculation in the next tier
84         dgtWithBonus += (uint(int(dgtAmount) - diff) * tier_bonus / 100);
85         dgtAmount = uint(diff);
86       } else {
87         dgtWithBonus += (dgtAmount * tier_bonus / 100);
88         dgtAmount = 0;
89       }
90     }
91 
92     // Increase supply
93     allocatedSupply += dgtWithBonus;
94 
95     // Assign new tokens to the sender and log token creation event
96     ethBalanceOf[msg.sender] += msg.value;
97     balanceOf[msg.sender] += dgtWithBonus;
98     Transfer(0, msg.sender, dgtWithBonus);
99   }
100 
101   // Decide the state of the project
102   function finalise() external {
103     require (!icoFailed);
104     require (!icoFulfilled);
105     require (now > endOfIco || allocatedSupply >= tokenSupply);
106 
107     // Min cap is 8000 ETH
108     if (this.balance < 8000 ether) {
109       icoFailed = true;
110     } else {
111       setPreSaleAmounts();
112       allocateBountyTokens();
113       icoFulfilled = true;
114     }
115   }
116 
117   // If the goal is not reached till the end of the ICO
118   // allow refunds
119   function refundEther() external {
120   	require (icoFailed);
121 
122     var ethValue = ethBalanceOf[msg.sender];
123     require (ethValue != 0);
124     ethBalanceOf[msg.sender] = 0;
125 
126     // Refund original Ether amount
127     msg.sender.transfer(ethValue);
128     Refund(msg.sender, ethValue);
129   }
130 
131   // Returns balance raised in ETH from specific address
132 	function getBalanceInEth(address addr) returns(uint){
133 		return ethBalanceOf[addr];
134 	}
135 
136   // Returns balance raised in DGT from specific address
137   function balanceOf(address _owner) constant returns (uint256 balance) {
138     return balanceOf[_owner];
139   }
140 
141 	// Get remaining supply of DGT
142 	function getRemainingSupply() returns(uint) {
143 		return tokenSupply - allocatedSupply;
144 	}
145 
146   // Get raised amount during ICO
147   function totalSupply() returns (uint totalSupply) {
148     return allocatedSupply;
149   }
150 
151   // Upon successfull ICO
152   // Allow owner to withdraw funds
153   function withdrawFundsToOwner(uint256 _amount) {
154     require (icoFulfilled);
155     require (this.balance >= _amount);
156 
157     owner.transfer(_amount);
158   }
159 
160   // Raised during Pre-sale
161   // Since some of the wallets in pre-sale were on exchanges, we transfer tokens
162   // to account which will send tokens manually out
163 	function setPreSaleAmounts() private {
164     balanceOf[0x8776A6fA922e65efcEa2371692FEFE4aB7c933AB] += raisedInPresale;
165     allocatedSupply += raisedInPresale;
166     Transfer(0, 0x8776A6fA922e65efcEa2371692FEFE4aB7c933AB, raisedInPresale);
167 	}
168 
169 	// Bounty pool makes up 2% from all tokens bought
170 	function allocateBountyTokens() private {
171     uint256 bountyAmount = allocatedSupply * 100 / 98 * 2 / 100;
172 		balanceOf[0x663F98e9c37B9bbA460d4d80ca48ef039eAE4052] += bountyAmount;
173     allocatedSupply += bountyAmount;
174     Transfer(0, 0x663F98e9c37B9bbA460d4d80ca48ef039eAE4052, bountyAmount);
175 	}
176 }