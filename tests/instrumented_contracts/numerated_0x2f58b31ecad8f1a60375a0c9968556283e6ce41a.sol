1 pragma solidity ^0.4.21;
2 
3 contract Owned {
4 
5   address owner;
6   uint last_blocknumber;
7 
8   
9   function Owned() public {
10     owner = msg.sender;
11   }
12   
13   modifier onlyOwner {
14     require(msg.sender == owner);
15     _;
16   }
17 
18   function getBalance() public view returns (uint) {
19     return address(this).balance;
20 
21   }
22 
23   function close() public onlyOwner {
24     selfdestruct(msg.sender);
25   }
26 }
27 
28 contract Gamble is Owned {
29   uint constant magic = 5;
30   
31   function getMaxBet() public view returns (uint) {
32     return getBalance()/magic;
33   }
34   
35   function Play() public payable protect protect_mining {
36     require(msg.value <= getMaxBet());
37     if (now % magic != 0) {
38       msg.sender.transfer(msg.value + msg.value/magic);
39     }
40     last_blocknumber = block.number;
41   }
42 
43   modifier protect {
44     require(tx.origin == msg.sender);
45     _;
46   }
47 
48   modifier protect_mining {
49     //very simple protection against miners
50     require (block.number != last_blocknumber);
51     _;
52   }
53 
54   function () public payable {
55     Play();
56   }
57 }