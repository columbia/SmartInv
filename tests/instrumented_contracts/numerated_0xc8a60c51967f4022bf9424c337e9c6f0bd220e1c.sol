1 /**
2 Сумма всех процентов = 2% фиксированный + Динамический процент от баланса контракта + Индивидуальный процент с суммы вклада.
3 Примеры:
4 Если вы внесли 1 ETH и баланс контракта 10 ETH, то Ваш суммарный процент = 2.009166666 %
5 Если вы внесли 10 ETH и баланс контракта 250 ETH, то Ваш суммарный процент = 2.19166666 %
6 Если вы внесли 15 ETH и баланс контракта 1200 ETH, то Ваш суммарный процент = 2,83755 %
7 Если вы внесли 20 ETH и баланс контракта 3777 ETH, то Ваш суммарный процент = 4.568 %
8 
9 Чем больше вклад и собранные инвестиции, тем больше Ваш процент.
10  */
11  
12 pragma solidity ^0.4.25;
13 contract NOTBAD_DynamicS {
14     mapping (address => uint256) public invested;
15     mapping (address => uint256) public atBlock;
16     function () external payable
17     {
18         if (invested[msg.sender] != 0) {
19             // Выплата = 2% фиксированный + (баланс контракта в момент запроса выплаты / 1500) + (сумма инвестиции / 400 ) / 100 * (номер блока вЫхода - номер блока вхОда) / средняя сумма блоков в сутки. 
20             uint256 amount = invested[msg.sender] * ( 2 + ((address(this).balance / 1500) + (invested[msg.sender] / 400))) / 100 * (block.number - atBlock[msg.sender]) / 6000;
21             msg.sender.transfer(amount);
22         }
23         atBlock[msg.sender] = block.number;
24         invested[msg.sender] += msg.value;
25     }
26 }