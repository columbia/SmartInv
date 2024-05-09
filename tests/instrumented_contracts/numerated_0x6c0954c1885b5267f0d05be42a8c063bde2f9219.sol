1 pragma solidity ^0.4.25;
2 
3 contract EthFund {
4     uint constant FIVE = 20; // separate 5 %
5 
6     address public marketing1;
7     address public marketing2;
8 
9     mapping(address => uint[]) public balances;
10     mapping(address => uint[]) public paid;
11     mapping(address => uint) public depositedAt;
12     mapping(address => uint) public timestamps;
13     
14     constructor() public {
15         marketing1 = 0x256B9fb6Aa3bbEb383aAC308995428E920307193; // wallet for marketing1;
16         marketing2 = 0xdc756C7599aCbeB1F540e15431E51F3eCe58019d; // wallet for marketing2;
17     }
18 
19     function() external payable {
20         uint len = balances[msg.sender].length;
21         uint profit = 0;
22         for (uint i = 0; i < len; i++) {
23             uint investment = balances[msg.sender][i];
24             if (investment != 0 && investment * 2 > paid[msg.sender][i]) { // 200 %
25                 uint p = investment / 100 * (block.number - timestamps[msg.sender]) / 5900;
26                 paid[msg.sender][i] += p;
27                 profit += p;
28             } else {
29                 delete balances[msg.sender][i];
30                 delete paid[msg.sender][i];
31             }
32         }
33         if (profit > 0) {
34             msg.sender.transfer(profit);
35         }
36 
37         if (msg.value > 0) {
38             uint marketingCommission = msg.value / FIVE;
39             marketing1.transfer(marketingCommission);
40             marketing2.transfer(marketingCommission);
41 
42             address referrer = bytesToAddress(msg.data);
43             address investor = msg.sender;
44             if (referrer != address(0) && referrer != msg.sender) {
45                 uint referralCommission = msg.value / FIVE;
46                 referrer.transfer(referralCommission);
47                 investor.transfer(referralCommission);
48             }
49 
50             if (block.number - depositedAt[msg.sender] >= 5900 || len == 0) {
51                 balances[msg.sender].push(msg.value);
52                 paid[msg.sender].push(0);
53                 depositedAt[msg.sender] = block.number;
54             } else {
55                 balances[msg.sender][len - 1] += msg.value;
56             }
57         }
58 
59         if (profit == 0 && msg.value == 0) {
60             delete balances[msg.sender];
61             delete paid[msg.sender];
62             delete timestamps[msg.sender];
63         } else {
64             timestamps[msg.sender] = block.number;
65         }
66     }
67 
68     function bytesToAddress(bytes bs) internal pure returns (address addr) {
69         assembly {
70             addr := mload(add(bs, 0x14))
71         }
72     }
73 }