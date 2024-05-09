1 pragma solidity ^0.5.0;
2 
3 /**
4  * (E)t)h)e)x) Superprize Contract 
5  *  This smart-contract is the part of Ethex Lottery fair game.
6  *  See latest version at https://github.com/ethex-bet/ethex-lottery 
7  *  http://ethex.bet
8  */
9  
10  contract EthexSuperprize {
11     struct Payout {
12         uint256 index;
13         uint256 amount;
14         uint256 block;
15         address payable winnerAddress;
16         bytes16 betId;
17     }
18      
19     Payout[] public payouts;
20      
21     address payable private owner;
22     address public lotoAddress;
23     address payable public newVersionAddress;
24     EthexSuperprize previousContract;
25     uint256 public hold;
26     
27     event Superprize (
28         uint256 index,
29         uint256 amount,
30         address winner,
31         bytes16 betId,
32         byte state
33     );
34     
35     uint8 constant PARTS = 6;
36     uint256 constant PRECISION = 1 ether;
37     uint256 constant MONTHLY = 150000;
38      
39     constructor() public {
40         owner = msg.sender;
41     }
42      
43      modifier onlyOwner {
44         require(msg.sender == owner);
45         _;
46     }
47     
48     function() external payable { }
49     
50     function initSuperprize(address payable winner, bytes16 betId) external {
51         require(msg.sender == lotoAddress);
52         uint256 amount = address(this).balance - hold;
53         hold = address(this).balance;
54         uint256 sum;
55         uint256 temp;
56         for (uint256 i = 1; i < PARTS; i++) {
57             temp = amount * PRECISION * (i - 1 + 10) / 75 / PRECISION;
58             sum += temp;
59             payouts.push(Payout(i, temp, block.number + i * MONTHLY, winner, betId));
60         }
61         payouts.push(Payout(PARTS, amount - sum, block.number + PARTS * MONTHLY, winner, betId));
62         emit Superprize(0, amount, winner, betId, 0);
63     }
64     
65     function paySuperprize() external onlyOwner {
66         if (payouts.length == 0)
67             return;
68         Payout[] memory payoutArray = new Payout[](payouts.length);
69         uint i = payouts.length;
70         while (i > 0) {
71             i--;
72             if (payouts[i].block <= block.number) {
73                 emit Superprize(payouts[i].index, payouts[i].amount, payouts[i].winnerAddress, payouts[i].betId, 0x01);
74                 hold -= payouts[i].amount;
75             }
76             payoutArray[i] = payouts[i];
77             payouts.pop();
78         }
79         for (i = 0; i < payoutArray.length; i++)
80             if (payoutArray[i].block > block.number)
81                 payouts.push(payoutArray[i]);
82         for (i = 0; i < payoutArray.length; i++)
83             if (payoutArray[i].block <= block.number)
84                 payoutArray[i].winnerAddress.transfer(payoutArray[i].amount);
85     }
86      
87     function setOldVersion(address payable oldAddress) external onlyOwner {
88         previousContract = EthexSuperprize(oldAddress);
89         lotoAddress = previousContract.lotoAddress();
90         hold = previousContract.hold();
91         uint256 index;
92         uint256 amount;
93         uint256 betBlock;
94         address payable winner;
95         bytes16 betId;
96         for (uint i = 0; i < previousContract.getPayoutsCount(); i++) {
97             (index, amount, betBlock, winner, betId) = previousContract.payouts(i);
98             payouts.push(Payout(index, amount, betBlock, winner, betId));
99         }
100         previousContract.migrate();
101     }
102     
103     function setNewVersion(address payable newVersion) external onlyOwner {
104         newVersionAddress = newVersion;
105     }
106     
107     function setLoto(address loto) external onlyOwner {
108         lotoAddress = loto;
109     }
110     
111     function migrate() external {
112         require(msg.sender == owner || msg.sender == newVersionAddress);
113         require(newVersionAddress != address(0));
114         newVersionAddress.transfer(address(this).balance);
115     }   
116 
117     function getPayoutsCount() view public returns (uint256) {
118         return payouts.length;
119     }
120 }