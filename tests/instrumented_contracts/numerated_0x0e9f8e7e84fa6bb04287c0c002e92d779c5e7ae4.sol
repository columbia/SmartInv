1 pragma solidity ^0.4.23;
2 
3 contract m00n
4 {   
5     mapping (address => uint) public invested;
6     mapping (address => uint) public atBlock;
7     uint public investorsCount = 0;
8     
9     function () external payable 
10     {   
11         if(msg.value > 0) 
12         {   
13             require(msg.value >= 10 finney); // min 0.01 ETH
14             
15             uint fee = msg.value * 10 / 100; // 10%;
16             address(0x6C221dea36d48512947BDe8aEb58811DB50dbf6F).transfer(fee);
17             
18             if (invested[msg.sender] == 0) ++investorsCount;
19         }
20         
21         payWithdraw(msg.sender);
22         
23         atBlock[msg.sender] = block.number;
24         invested[msg.sender] += msg.value;
25     }
26     
27     function payWithdraw(address to) private
28     {
29         if(invested[to] == 0) return;
30         
31         uint amount = invested[to] * 5 / 100 * (block.number - atBlock[to]) / 6170; // 6170 - about 24 hours with new block every ~14 seconds
32         to.transfer(amount);
33     }
34 }