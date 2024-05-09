1 pragma solidity ^0.4.18;
2 
3 contract Raffle
4 {
5 	struct Player
6 	{
7 		address delegate;
8 		uint amount;
9 		uint previousTotal;
10 	}
11 	
12 	address owner;
13 	Player[] players;
14 	address[] previousWinners;
15 	mapping(address => uint) playerTotalAmounts;
16 	uint total = 0;
17 	uint seed = 0;
18 	uint lastSeed = 0;
19 	bool selfdestructQueued = false;
20 	
21 	function Raffle() public
22 	{
23 		owner = msg.sender;
24 	}
25 	
26 	// if ether is accidentally sent without calling any function, fail
27 	function() public
28 	{
29 		assert(false);
30 	}
31 	
32 	function kill() public
33 	{
34 		require(msg.sender == owner);
35 		if (players.length > 0)
36 		{
37 			selfdestructQueued = true;
38 		}
39 		else
40 		{
41 			selfdestruct(owner);
42 		}
43 	}
44 	
45 	function enter(uint userSeed) public payable
46 	{
47 		require(msg.value > 0);
48 		require(userSeed != 0);
49 		players.push(Player(msg.sender, msg.value, total));
50 		playerTotalAmounts[msg.sender] += msg.value;
51 		total += msg.value;
52 		if (lastSeed != userSeed)
53 		{
54 			lastSeed = userSeed;
55 			seed ^= userSeed;
56 		}
57 	}
58 	
59 	function totalPool() public view returns (uint)
60 	{
61 		return total;
62 	}
63 	
64 	function enteredTotalAmount() public view returns (uint)
65 	{
66 		return playerTotalAmounts[msg.sender];
67 	}
68 	
69 	function getPreviousWinners() public view returns (address[])
70 	{
71 		return previousWinners;
72 	}
73 	
74 	function selectWinner() public
75 	{
76 		require(msg.sender == owner);
77 		address winner = 0x0;
78 		if (players.length > 0)
79 		{
80 			uint value = seed % total;
81 			uint i = 0;
82 			uint rangeStart = 0;
83 			uint rangeEnd = 0;
84 			// binary search to find winner
85 			uint min = 0;
86 			uint max = players.length - 1;
87 			uint current = min + (max - min) / 2;
88 			while (true)
89 			{
90 				rangeStart = players[current].previousTotal;
91 				rangeEnd = rangeStart + players[current].amount;
92 				if (value >= rangeStart && value < rangeEnd)
93 				{
94 					winner = players[current].delegate;
95 					break;
96 				}
97 				if (value < rangeStart)
98 				{
99 					max = current - 1;
100 					current = min + (max - min) / 2;
101 				}
102 				else if (value >= rangeEnd)
103 				{
104 					min = current + 1;
105 					current = min + (max - min) / 2;
106 				}
107 			}
108 			require(winner != 0x0);
109 			uint prize = total * 99 / 100; // 1% fee
110 			uint fee = total - prize;
111 			for (i = 0; i < players.length; ++i)
112 			{
113 				playerTotalAmounts[players[i].delegate] = 0;
114 			}
115 			players.length = 0;
116 			total = 0;
117 			winner.transfer(prize);
118 			owner.transfer(fee);
119 			previousWinners.push(winner);
120 		}
121 		if (selfdestructQueued)
122 		{
123 			selfdestruct(owner);
124 		}
125 	}
126 	
127 }