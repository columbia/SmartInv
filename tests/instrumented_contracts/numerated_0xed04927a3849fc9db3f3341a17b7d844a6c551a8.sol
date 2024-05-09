1 pragma solidity ^0.4.4;
2 // "10000000000000000", "60000000000", "4000000000000000"
3 // , 0.004 ETH
4 contract CrowdInvestment {
5     uint private restAmountToInvest;
6     uint private maxGasPrice;
7     address private creator;
8     mapping(address => uint) private perUserInvestments;
9     mapping(address => uint) private additionalCaps;
10     uint private limitPerInvestor;
11 
12     function CrowdInvestment(uint totalCap, uint maxGasPriceParam, uint capForEverybody) public {
13         restAmountToInvest = totalCap;
14         creator = msg.sender;
15         maxGasPrice = maxGasPriceParam;
16         limitPerInvestor = capForEverybody;
17     }
18 
19     function () public payable {
20         require(restAmountToInvest >= msg.value); // общий лимит инвестиций
21         require(tx.gasprice <= maxGasPrice); // лимит на gas price
22         require(getCap(msg.sender) >= msg.value); // лимит на инвестора
23         restAmountToInvest -= msg.value; // уменьшим общий лимит инвестиций
24         perUserInvestments[msg.sender] += msg.value; // запишем инвестицию пользователя
25     }
26 
27     function getCap (address investor) public view returns (uint) {
28         return limitPerInvestor - perUserInvestments[investor] + additionalCaps[investor];
29     }
30 
31     function getTotalCap () public view returns (uint) {
32         return restAmountToInvest;
33     }
34 
35     function addPersonalCap (address investor, uint additionalCap) public {
36         require(msg.sender == creator);
37         additionalCaps[investor] += additionalCap;
38     }
39 
40     function addPersonalCaps (address[] memory investors, uint additionalCap) public {
41         require(msg.sender == creator);
42         for (uint16 i = 0; i < investors.length; i++) {
43             additionalCaps[investors[i]] += additionalCap;
44         }
45     }
46 
47     function withdraw () public {
48         require(msg.sender == creator); // только создатель может писать
49         creator.transfer(this.balance); // передадим все деньги создателю и только ему
50     }
51 }