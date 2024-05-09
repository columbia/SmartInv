1 pragma solidity >=0.4.24;
2 
3 interface token {
4     function transfer(address receiver, uint amount) external;
5     function balanceOf(address tokenOwner) constant external returns (uint balance);
6 }
7 
8 contract deflatMarket {
9     string public  name = "DEFLAT Market";
10     string public symbol = "DEFT";
11     string public comment = 'DEFLAT Sale Contract';
12     token public tokenReward = token(0xe1E0DB951844E7fb727574D7dACa68d1C5D1525b);
13     address deflatOrg = address(0x4d717d48BB24Af867B5efC91b282264Aae83cFa6);
14     address deflatMkt = address(0xb29c0D260A70A9a5094f523E932f57Aa159E8157);
15     address deflatDev = address(0x4e0871dC93410305F83aEEB15741B2BDb54C3c5a);
16 
17     uint amountOrg;
18     uint amountDev;
19     uint amountMkt;
20 
21     mapping(address => uint256) balanceOf;
22 
23 	
24     event FundTransfer(address backer, uint amount, bool isContribution);
25 
26     function () payable external {        
27         uint amount = msg.value;
28         uint stockSupply = tokenReward.balanceOf(address(this));
29         uint oneEthBuy = stockSupply/(1*(10**23));    
30         balanceOf[msg.sender] += amount;
31         amountOrg += (amount*20)/100;
32         amountDev += (amount*20)/100; 
33         amountMkt += (amount*60)/100;     
34         tokenReward.transfer(msg.sender, amount*oneEthBuy);
35         emit FundTransfer(msg.sender, amount, true);
36         if (amountOrg > 5*(10**15)) {
37           if (deflatMkt.send(amountMkt)) {
38                amountMkt = 0;
39                emit FundTransfer(deflatMkt, amountMkt, false);
40           }
41           if (deflatDev.send(amountDev)) {
42                amountDev = 0;
43                emit FundTransfer(deflatDev, amountDev, false);
44           }
45           if (deflatOrg.send(amountOrg)) {
46                amountOrg = 0;
47                emit FundTransfer(deflatOrg, amountOrg, false);               
48           }
49         }			
50     }
51 }