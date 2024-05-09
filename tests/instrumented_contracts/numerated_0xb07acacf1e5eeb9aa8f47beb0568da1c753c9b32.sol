1 pragma solidity ^0.4.8;
2 
3 interface token
4 {
5     function transfer(address receiver, uint256 amount) returns (bool success);
6     function transferFrom(address from, address to, uint256 amount) returns (bool success);
7     function balanceOf(address owner) constant returns (uint256 balance);
8     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
9 }
10 
11 contract Crowdsale
12 {
13     address public owner;
14     address public seller;
15     address public ContractAddress;
16     uint public amountRaised;
17     uint public price;
18     uint public ethereumPrice;
19     token public tokenReward;
20     address public walletOut1;
21     address public walletOut2;
22 
23     event FundTransfer(address backer, uint amount, bool isContribution);
24 
25     function Crowdsale()
26     {
27         // Avatar
28         walletOut1 = 0x594ae2a6aeab6f5e74bba0958cec21ec4dcd7f1e;
29         // A
30         walletOut2 = 0x7776eab79aeff7a1c09d8c49a7f3caf252c26451;
31 
32         // адрес продавца
33         seller = 0x7776eab79aeff7a1c09d8c49a7f3caf252c26451;
34 
35         owner = msg.sender;
36 
37         price = 15;
38         tokenReward = token(0xcd389f4873e8fbce7925b1d57804842043a3bf36);
39         ethereumPrice = 447;
40     }
41 
42     function changeOwner(address newOwner) onlyowner
43     {
44         owner = newOwner;
45     }
46 
47     modifier onlyowner()
48     {
49         if (msg.sender == owner) _;
50     }
51 
52     /* модификатор проверяющий "вызывает продавец или вызывает владелец контракта?" */
53     modifier isSetPrice()
54     {
55         if (msg.sender == seller || msg.sender == owner) _;
56     }
57 
58     function () payable
59     {
60         uint256 amount = msg.value;
61         amountRaised += amount;
62         uint256 amountOut1 = amount / 2;
63         uint256 amountOut2 = amount - amountOut1;
64 
65         uint256 amountWei = amount;
66         uint priceUsdCentEth = ethereumPrice * 100;
67         uint priceUsdCentAvr = price;
68         uint256 amountAvrAtom = ((amountWei * priceUsdCentEth) / priceUsdCentAvr) / 10000000000;
69 
70         if (tokenReward.balanceOf(ContractAddress) < amountAvrAtom) {
71             throw;
72         }
73         tokenReward.transfer(msg.sender, amountAvrAtom);
74 
75         walletOut1.transfer(amountOut1);
76         walletOut2.transfer(amountOut2);
77 
78         FundTransfer(msg.sender, amount, true);
79     }
80 
81     function setWalletOut1(address wallet) onlyowner
82     {
83         walletOut1 = wallet;
84     }
85 
86     function setWalletOut2(address wallet) onlyowner
87     {
88         walletOut2 = wallet;
89     }
90 
91     function sendAVR(address wallet, uint256 amountAvrAtom) onlyowner
92     {
93         tokenReward.transfer(wallet, amountAvrAtom);
94     }
95 
96     function setContractAddress(address wallet) onlyowner
97     {
98         ContractAddress = wallet;
99     }
100 
101     // uint usdCentCostOfEachToken - цена в центах
102     function setPrice(uint usdCentCostOfEachToken) onlyowner
103     {
104         price = usdCentCostOfEachToken;
105     }
106 
107     // uint usd - цена в долларах
108     function setEthPrice(uint usd) isSetPrice
109     {
110         ethereumPrice = usd;
111     }
112 }