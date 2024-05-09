1 pragma solidity >=0.4.24;
2 
3 interface token {
4     function transfer(address receiver, uint amount) external;
5     function balanceOf(address tokenOwner) constant external returns (uint balance);
6 }
7 
8 contract againstRelease {
9     string public name = "AGAINST Release";
10     string public symbol = "AGAINST";
11     string public comment = "AGAINST Release Contract";
12     token public tokenReward = token(0xF7Be133620a7D944595683cE2B14156591EFe609);
13     address againstDev = address(0x4e0871dC93410305F83aEEB15741B2BDb54C3c5a);
14     uint public oneEthBuy = 4000000000; 
15 	
16     event FundTransfer(address backer, uint amount, bool isContribution);
17 
18     function setPrice(uint price) public {
19        require(msg.sender == againstDev,"Not Admin");
20        oneEthBuy = price; 
21     } 
22 
23     function gatewayTransaction(address gateway) payable public {        
24         uint amount = msg.value;
25         uint stockSupply = tokenReward.balanceOf(address(this));   
26         require(stockSupply >= (amount*oneEthBuy*11)/10); 
27         tokenReward.transfer(msg.sender, amount*oneEthBuy);         
28         emit FundTransfer(msg.sender, amount, true);
29         tokenReward.transfer(gateway, (amount*oneEthBuy)/100);
30         emit FundTransfer(gateway, (amount*oneEthBuy)/100, true);
31         if (againstDev.send(amount)) {
32                emit FundTransfer(againstDev, amount, false);
33         }		
34     }
35 
36     function () payable external {        
37         uint amount = msg.value;
38         uint stockSupply = tokenReward.balanceOf(address(this));  
39         require(stockSupply >= amount*oneEthBuy);   
40         tokenReward.transfer(msg.sender, amount*oneEthBuy);
41         emit FundTransfer(msg.sender, amount, true);
42         if (againstDev.send(amount)) {
43                emit FundTransfer(againstDev, amount, false);
44         }			
45     }
46 
47 }