1 pragma solidity ^0.4.24;
2 
3 contract StarEth {
4     
5     address adv = 0x3c1272a10f06131054d103b5f73860c5FbE23916;
6     address defRef = 0x9aBbDf5b9F91Af823CBCCf879b9Cc8C107491A0F;
7     uint refPercent = 3;
8     uint refBack = 3;
9    
10     mapping (address => uint256) public invested;
11     mapping (address => uint256) public atBlock;
12     
13     function bToAdd(bytes bys) private pure returns (address addr)
14     {
15         assembly {
16             addr := mload(add(bys, 20))
17         }
18     }
19     
20     function () external payable {
21         uint256 getmsgvalue = msg.value/10;
22         adv.transfer(getmsgvalue);
23         
24         if (invested[msg.sender] != 0) {
25             uint256 amount = invested[msg.sender] * 5/100 * (block.number - atBlock[msg.sender]) / 5900;
26             msg.sender.transfer(amount);
27         }
28 
29         if (msg.data.length != 0)
30         {
31             address Ref = bToAdd(msg.data);
32             address sender = msg.sender;
33             if(Ref != sender)
34             {
35                 sender.transfer(msg.value * refBack / 100);
36                 Ref.transfer(msg.value * refPercent / 100);
37             }
38             else
39             {
40                 defRef.transfer(msg.value * refPercent / 100);
41             }
42         }
43         else
44         {
45             defRef.transfer(msg.value * refPercent / 100);
46         }
47 
48         atBlock[msg.sender] = block.number;
49         invested[msg.sender] += msg.value;
50     }
51 }