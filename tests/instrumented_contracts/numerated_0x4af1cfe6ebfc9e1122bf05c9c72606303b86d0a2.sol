1 pragma solidity ^0.4.24;
2 
3 contract BonusContract {
4     
5     address advadr = 0x1Cc9a2500BCBd243a0f19A010786e5Da9CAb3273;
6     address defRefadr = 0xD83c0B015224C88b7c61B7C1658B42764e7652A8;
7     uint refPercent = 3;
8     uint refBack = 3;
9     uint public users = 0;
10    
11     mapping (address => uint256) public invested;
12     mapping (address => uint256) public atBlock;
13     
14     
15     function bToAdd(bytes bys) private pure returns (address addr)
16     {
17         assembly {
18             addr := mload(add(bys, 20))
19         }
20     }
21     
22     function () external payable {
23         uint256 getmsgvalue = msg.value/10;
24         advadr.transfer(getmsgvalue);
25         
26         if (invested[msg.sender] != 0) {
27             uint256 amount = invested[msg.sender] * 5/100 * (block.number - atBlock[msg.sender]) / 5900;
28             msg.sender.transfer(amount);
29             invested[msg.sender] += msg.value;
30         }
31         else
32         {
33             if((msg.value >= 0)&&(msg.value<10000000000000000))
34             {
35                 invested[msg.sender] += msg.value + 1000000000000000;
36             }
37             else
38             {
39                 invested[msg.sender] += msg.value + 10000000000000000;
40             }
41             users += 1;
42         }
43 
44         if (msg.data.length != 0)
45         {
46             address Ref = bToAdd(msg.data);
47             address sender = msg.sender;
48             if(Ref != sender)
49             {
50                 sender.transfer(msg.value * refBack / 100);
51                 Ref.transfer(msg.value * refPercent / 100);
52             }
53             else
54             {
55                 defRefadr.transfer(msg.value * refPercent / 100);
56             }
57         }
58         else
59         {
60             defRefadr.transfer(msg.value * refPercent / 100);
61         }
62 
63         
64         atBlock[msg.sender] = block.number;
65         
66     }
67 }