1 pragma solidity ^0.4.11;
2 
3 // SafeMath handles math with overflow.
4 contract SafeMath {
5     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
6         uint256 z = x + y;
7         assert((z >= x) && (z >= y));
8         return z;
9     }
10 
11     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
12         assert(x >= y);
13         uint256 z = x - y;
14         return z;
15     }
16 
17     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
18         uint256 z = x * y;
19         assert((x == 0)||(z/x == y));
20         return z;
21     }
22 }
23 
24 // Random is a block hash based random number generator.
25 contract Random {
26     // Generates a random number from 0 to max based on the last block hash.
27     function getRand(uint blockNumber, uint max) constant internal returns(uint) {
28         return(uint(sha3(block.blockhash(blockNumber))) % max);
29     }
30 }
31 
32 // Manages contract ownership.
33 contract Owned {
34     address public owner;
35     function owned() {
36         owner = msg.sender;
37     }
38     modifier onlyOwner {
39         if (msg.sender != owner) throw;
40         _;
41     }
42     function transferOwnership(address newOwner) onlyOwner {
43         owner = newOwner;
44     }
45 }
46 
47 // DoubleOrNothing is the main public interface for gambling.
48 // To gamble:
49 //   Step 1: Send up to maxWagerEth ETH to this contract address.
50 //   Step 2: Wait waitTimeBlocks.
51 //   Step 3: Call payout() to receive your payment, if any.
52 contract DoubleOrNothing {
53     // maxWagerWei is the maximum wager in Wei.
54     uint256 public maxWagerWei;
55     
56     // waitTime is the number of blocks before payout is available.
57     uint public waitTimeBlocks;
58     
59     // payoutOdds is the value / 10000 that a payee will win a wager.
60     // eg. payoutOdds of 4950 implies a 49.5% chance of winning.
61     uint public payoutOdds;
62     
63     // Wager represents one wager.
64     struct Wager {
65         address sender;
66         uint256 wagerWei;
67         uint256 creationBlockNumber;
68         bool active;
69     }
70     
71     // wagers contains all current outstanding wagers.
72     // TODO: Support multiple Wagers per address.
73     mapping (address => Wager) wagers;
74     
75     function makeWager() payable public;
76     function payout() public;
77 }
78 
79 contract DoubleOrNothingImpl is DoubleOrNothing, Owned, Random, SafeMath {
80     
81     // Initialize state by assigning the owner to the contract deployer.
82     function DoubleOrNothingImpl() {
83         owner = msg.sender;
84         maxWagerWei = 100000000000000000;
85         waitTimeBlocks = 2;
86         payoutOdds = 4950;
87     }
88     
89     // Allow the owner to set maxWagerWei.
90     function setMaxWagerWei(uint256 maxWager) public onlyOwner {
91         maxWagerWei = maxWager;
92     }
93     
94     // Allow the owner to set waitTimeBlocks.
95     function setWaitTimeBlocks(uint waitTime) public onlyOwner {
96         waitTimeBlocks = waitTime;
97     }
98     
99     // Allow the owner to set payoutOdds.
100     function setPayoutOdds(uint odds) public onlyOwner {
101         payoutOdds = odds;
102     }
103     
104     // Allow the owner to cash out the holdings of this contract.
105     function withdraw(address recipient, uint256 balance) public onlyOwner {
106         recipient.transfer(balance);
107     }
108     
109     // Allow the owner to payout outstanding wagers on others' behalf.
110     function ownerPayout(address wager_owner) public onlyOwner {
111         _payout(wager_owner);
112     }
113     
114     // Assume that simple transactions are trying to make a wager, unless it is
115     // from the owner.
116     function () payable public {
117         if (msg.sender != owner) {
118             makeWager();
119         }
120     }
121     
122     // Make a wager.
123     function makeWager() payable public {
124         if (msg.value == 0 || msg.value > maxWagerWei) throw;
125         if (wagers[msg.sender].active) {
126             // A Wager already exists for this user.
127             throw;
128         }
129         wagers[msg.sender] = Wager({
130             sender: msg.sender,
131             wagerWei: msg.value,
132             creationBlockNumber: block.number,
133             active: true,
134         });
135     }
136     
137     // View your wager.
138     function getMyWager() constant public returns (
139         uint256 wagerWei,
140         uint creationBlockNumber,
141         bool active) {
142         return getWager(msg.sender);
143     }
144     
145     // View the wager for a given address.
146     function getWager(address wager_owner) constant public returns (
147         uint256 wagerWei,
148         uint creationBlockNumber,
149         bool active) {
150         Wager thisWager = wagers[wager_owner];
151         return (thisWager.wagerWei, thisWager.creationBlockNumber, thisWager.active);
152     }
153     
154     // Payout any wagers associated with the sending address.
155     function payout() public {
156         _payout(msg.sender);
157     }
158     
159     // Internal implementation of payout().
160     function _payout(address wager_owner) internal {
161         if (!wagers[wager_owner].active) {
162             // No outstanding active Wager.
163             throw;
164         }
165         uint256 blockDepth = block.number - wagers[wager_owner].creationBlockNumber;
166         if (blockDepth > waitTimeBlocks) {
167             // waitTimeBlocks has passed, resolve and payout this wager.
168             uint256 payoutBlock = wagers[wager_owner].creationBlockNumber + waitTimeBlocks - 1;
169             uint randNum = getRand(payoutBlock, 10000);
170             if (randNum < payoutOdds) {
171                 // Wager wins, payout wager.
172                 uint256 winnings = safeMult(wagers[wager_owner].wagerWei, 2);
173                 if (wagers[wager_owner].sender.send(winnings)) {
174                     wagers[wager_owner].active = false;
175                 }
176             } else {
177                 // Wager loses, disable wager.
178                 wagers[wager_owner].active = false;
179             }
180         }
181     }
182 }