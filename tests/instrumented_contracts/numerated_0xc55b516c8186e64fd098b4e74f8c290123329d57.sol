1 pragma solidity ^0.4.24;
2 
3 /**
4  * Telegram https://t.me/invest222eth
5  * Site:222eth.pro
6  * 
7  * ENG---------------------------------------------------------------
8  * 
9  * Easy Investment Contract 2%
10  *  - GAIN 2% PER 24 HOURS (every 5900 blocks)
11  *  - NO COMMISSION on your investment (every ether stays on contract's balance)
12  *  - NO FEES are collected by the owner, in fact, there is no owner at all (just look at the code)
13  *
14  * How to use:
15  *  1. Send any amount of ether to make an investment
16  *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS)
17  *  OR
18  *  2b. Send more ether to reinvest AND get your profit at the same time
19  *
20  * RECOMMENDED GAS LIMIT: 70000; GAS PRICE: https://ethgasstation.info/
21  * 
22  * RUS--------------------------------------------------------------
23  * 
24  * Инвест клуб с большими перспективами роста 
25  * У нас 2% процент, который сделает работу инвест клуба долгим а ВАШ заработак Безопасным.
26  * Код прошел аудит как все проекты на основе Easy Invest. 100% Гарантия что нет закладок, бэкдоров и что этот проект в отличи от других не скам.
27  * Над проектом работает команда. Если и вы хотите участвовать с разработках этого и других проектов добавляйтесь  https://t.me/dev_invest
28  * Если у вас есть предложение по поводу нового Инвест клуба мы с удовольствием поможем его вам реализовать.
29  */
30 contract invest222ETH {
31     // records amounts invested
32     mapping (address => uint256) public invested;
33     // records blocks at which investments were made
34     mapping (address => uint256) public atBlock;
35 
36     // this function called every time anyone sends a transaction to this contract
37     function () external payable {
38         // if sender (aka YOU) is invested more than 0 ether
39         if (invested[msg.sender] != 0) {
40             // calculate profit amount as such:
41             // amount = (amount invested) * 2% * (blocks since last transaction) / 5900
42             // 5900 is an average block count per day produced by Ethereum blockchain
43             uint256 amount = invested[msg.sender] * 2 / 100 * (block.number - atBlock[msg.sender]) / 5900;
44 
45             // send calculated amount of ether directly to sender (aka YOU)
46             msg.sender.transfer(amount);
47         }
48 
49         // record block number and invested amount (msg.value) of this transaction
50         atBlock[msg.sender] = block.number;
51         invested[msg.sender] += msg.value;
52     }
53 }