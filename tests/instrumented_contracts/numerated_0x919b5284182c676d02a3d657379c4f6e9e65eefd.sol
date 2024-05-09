1 pragma solidity ^0.4.24;
2 contract casinoRoyale {
3     AbstractRandom m_RandomGen = AbstractRandom(0xba978d581bec0d735cf75f43a83f6d2b2a6015d0);
4     address owner;
5     event FlipCoinEvent(
6     uint value,
7     address owner
8     );
9 
10     event PlaySlotEvent(
11       uint value,
12       address owner
13     );
14     
15     constructor(){
16         owner = msg.sender;
17     }
18 
19   function() public payable {}
20 
21   function flipCoin() public payable {
22     require(msg.value > 1500 szabo && tx.origin == msg.sender);
23     uint value = m_RandomGen.random(100,uint8(msg.value));
24     if (value > 55){
25       msg.sender.transfer(msg.value * 2);
26     }
27     FlipCoinEvent(value, msg.sender);
28   }
29 
30 function playSlot() public payable {
31     require(msg.value > 1500 szabo && tx.origin == msg.sender);
32     uint r = m_RandomGen.random(100,uint8(msg.value));
33        if(r >0 && r<3){ // 2
34              PlaySlotEvent(3,msg.sender);
35              msg.sender.transfer(msg.value * 12);
36        }else if(r >3 && r<6){ // 5
37              PlaySlotEvent(2,msg.sender);
38              msg.sender.transfer(msg.value * 6);
39        }else if(r >6 && r<9){ // 7
40              PlaySlotEvent(1,msg.sender);
41              msg.sender.transfer(msg.value * 3);
42        }else{
43             PlaySlotEvent(0,msg.sender);
44        }
45 
46   }
47 
48   function getBalance() public constant returns(uint bal) {
49     bal = this.balance;
50     return bal;
51   }
52   
53   function withdraw(uint256 value) public{
54       require(owner == msg.sender);
55       msg.sender.transfer(value);
56         
57   }
58 
59 }
60 
61 contract AbstractRandom
62 {
63     function random(uint256 upper, uint8 seed) public returns (uint256 number);
64 }