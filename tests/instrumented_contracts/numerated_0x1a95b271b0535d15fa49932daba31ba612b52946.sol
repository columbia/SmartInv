1 contract minereum { 
2 
3 string public name; 
4 string public symbol; 
5 uint8 public decimals; 
6 uint256 public initialSupplyPerAddress;
7 uint256 public initialBlockCount;
8 uint256 public rewardPerBlockPerAddress;
9 uint256 public totalGenesisAddresses;
10 address public genesisCallerAddress;
11 uint256 private availableAmount;
12 uint256 private availableBalance;
13 uint256 private minedBlocks;
14 uint256 private totalMaxAvailableAmount;
15 uint256 private balanceOfAddress;
16 
17 mapping (address => uint256) public balanceOf; 
18 mapping (address => bool) public genesisAddress; 
19 
20 event Transfer(address indexed from, address indexed to, uint256 value); 
21 
22 function minereum() { 
23 
24 name = "minereum"; 
25 symbol = "MNE"; 
26 decimals = 8; 
27 initialSupplyPerAddress = 3200000000000;
28 initialBlockCount = 3516521;
29 rewardPerBlockPerAddress = 32000;
30 totalGenesisAddresses = 4268;
31 
32 genesisCallerAddress = 0x0000000000000000000000000000000000000000;
33 }
34 
35 function currentEthBlock() constant returns (uint256 blockNumber)
36 {
37 	return block.number;
38 }
39 
40 function currentBlock() constant returns (uint256 blockNumber)
41 {
42 	return block.number - initialBlockCount;
43 }
44 
45 function setGenesisAddressArray(address[] _address) public returns (bool success)
46 {
47 	if (block.number <= 3597381)
48 	{
49 		if (msg.sender == genesisCallerAddress)
50 		{
51 			for (uint i = 0; i < _address.length; i++)
52 			{
53 				balanceOf[_address[i]] = initialSupplyPerAddress;
54 				genesisAddress[_address[i]] = true;
55 			}
56 			return true;
57 		}
58 	}
59 	return false;
60 }
61 
62 
63 function availableBalanceOf(address _address) constant returns (uint256 Balance)
64 {
65 	if (genesisAddress[_address])
66 	{
67 		minedBlocks = block.number - initialBlockCount;
68 		
69 		if (minedBlocks >= 100000000) return balanceOf[_address];
70 		
71 		availableAmount = rewardPerBlockPerAddress*minedBlocks;
72 		
73 		totalMaxAvailableAmount = initialSupplyPerAddress - availableAmount;
74 		
75 		availableBalance = balanceOf[_address] - totalMaxAvailableAmount;
76 		
77 		return availableBalance;
78 	}
79 	else
80 		return balanceOf[_address];
81 }
82 
83 function totalSupply() constant returns (uint256 totalSupply)
84 {	
85 	minedBlocks = block.number - initialBlockCount;
86 	availableAmount = rewardPerBlockPerAddress*minedBlocks;
87 	return availableAmount*totalGenesisAddresses;
88 }
89 
90 function maxTotalSupply() constant returns (uint256 maxSupply)
91 {	
92 	return initialSupplyPerAddress*totalGenesisAddresses;
93 }
94 
95 function transfer(address _to, uint256 _value) { 
96 
97 if (genesisAddress[_to]) throw;
98 
99 if (balanceOf[msg.sender] < _value) throw; 
100 
101 if (balanceOf[_to] + _value < balanceOf[_to]) throw; 
102 
103 if (genesisAddress[msg.sender])
104 {
105 	minedBlocks = block.number - initialBlockCount;
106 	if (minedBlocks < 100000000)
107 	{
108 		availableAmount = rewardPerBlockPerAddress*minedBlocks;
109 			
110 		totalMaxAvailableAmount = initialSupplyPerAddress - availableAmount;
111 		
112 		availableBalance = balanceOf[msg.sender] - totalMaxAvailableAmount;
113 			
114 		if (_value > availableBalance) throw;
115 	}
116 }
117 
118 balanceOf[msg.sender] -= _value; 
119 balanceOf[_to] += _value; 
120 Transfer(msg.sender, _to, _value); 
121 } 
122 
123 function setGenesisCallerAddress(address _caller) public returns (bool success)
124 {
125 	if (genesisCallerAddress != 0x0000000000000000000000000000000000000000) return false;
126 	
127 	genesisCallerAddress = _caller;
128 	
129 	return true;
130 }
131 }