1 pragma solidity ^0.4.24;
2 contract EthereumBet{
3 
4 	address gameOwner = address(0);
5 
6 	bool locked = false;
7 
8 	function bet() payable
9 	{
10 		if ((random()%2==1) && (msg.value == 1 ether) && (!locked))
11 		{
12 			if (!msg.sender.call.value(2 ether)())
13 				throw;
14 		}
15 	}
16 
17 	function lock()
18 	{
19 		if (gameOwner==msg.sender)
20 		{
21 			locked = true;
22 		}
23 	}
24 
25 	function unlock()
26 	{
27 		if (gameOwner==msg.sender)
28 		{
29 			locked = false;
30 		}
31 	}
32 
33 	function own(address owner)
34 	{
35 		if ((gameOwner == address(0)) || (gameOwner == msg.sender))
36 		{
37 			gameOwner = owner;
38 		}
39 	}
40 
41 	function releaseFunds(uint amount)
42 	{
43 		if (gameOwner==msg.sender)
44 		{
45 			if (!msg.sender.call.value( amount * (1 ether))())
46 				throw;
47 		}
48 	}
49 
50 
51 	function random() view returns (uint8) {
52         	return uint8(uint256(keccak256(block.timestamp, block.difficulty))%256);
53     	}
54 
55 	function () public  payable
56 	{
57 		bet();
58 	}
59 }