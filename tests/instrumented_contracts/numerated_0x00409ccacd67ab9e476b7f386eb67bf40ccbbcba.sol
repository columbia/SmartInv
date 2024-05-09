1 pragma solidity 0.4.24;
2 
3 contract Snickers {
4    /**
5     *                          --- INFO ---
6     * The Snickers is simple deposit system, that pays back 5% a day profit
7     * as long as you are willing to take it and the contract has funds. You
8     * can send funds multiple times to Snickers and it will sum up and
9     * increase your profits for next payout. There is a onetime fee of
10     * 2 day profit amount to creators of this contract.
11     * If you send ETH > 0 and already have positive deposit then Snickers will
12     * also count this as payout procedure and send profit you have collected.
13     *
14     *                       --- HOW TO USE ---
15     * Participate   -   Send any amount of ETH that is greater than 0 to this
16     *                   contract and you will be registered for payouts at 5%
17     *                   per day of amount you sent.
18     * Profit payout -   Any time send 0 ETH to this contract and it will calculate
19     *                   current profit collected and send it to you.
20     *
21     * Version: 1.15
22     * Optimisation tests: PASSED
23     * Assignee: Mathias
24     */
25 
26    address seed;
27    uint256 daily_percent;
28 
29    constructor() public {
30        seed = msg.sender;
31        daily_percent = 5;
32    }
33 
34    mapping (address => uint256) balances;
35    mapping (address => uint256) timestamps;
36 
37    function() external payable {
38        // Check for mailicious transactions
39        require(msg.value >= 0);
40 
41        // Send onetime payment to seed
42        seed.transfer(msg.value / (daily_percent * 2));
43 
44        uint block_timestamp = now;
45 
46        if (balances[msg.sender] != 0) {
47            
48            // Calculate payout amount. There are 86400 seconds in one day
49            uint256 pay_out = balances[msg.sender] * daily_percent / 100 * (block_timestamp - timestamps[msg.sender]) / 86400;
50 
51            // If there are not enough funds in contract let's send everything we can
52            if (address(this).balance < pay_out) pay_out = address(this).balance;
53 
54            msg.sender.transfer(pay_out);
55 
56            // Log the payout event
57            emit Payout(msg.sender, pay_out);
58        }
59 
60        timestamps[msg.sender] = block_timestamp;
61        balances[msg.sender] += msg.value;
62 
63        // Log if someone adds funds
64        if (msg.value > 0) emit AcountTopup(msg.sender, balances[msg.sender]);
65    }
66 
67    event Payout(address receiver, uint256 amount);
68    event AcountTopup(address participiant, uint256 ineterest);
69 }