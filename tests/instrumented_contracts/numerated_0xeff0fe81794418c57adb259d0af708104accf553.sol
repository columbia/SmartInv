1 pragma solidity ^0.6.0;
2 
3 interface Minereum {
4   function Payment (  ) payable external;  
5 }
6 
7 contract MinereumLuckyDraw
8 {
9 	Minereum public mne;
10 	uint public stakeHoldersfee = 50;
11 	uint public percentWin = 80;
12 	uint public mnefee = 0;
13 	uint public ethfee = 15000000000000000;
14 	uint public totalSentToStakeHolders = 0;
15 	uint public totalPaidOut = 0;
16 	uint public ticketsSold = 0;
17 	uint public ticketsPlayed = 0;
18 	address public owner = 0x0000000000000000000000000000000000000000;	
19 	uint public maxNumber = 10001;
20 	uint public systemNumber = 3223;
21 	
22 	uint public blockInterval = 3;
23 	uint public maxBlock = 60;
24 	
25 	//winners from past contracts
26 	uint public winnersCount = 0;
27 	uint public winnersEthCount = 0;
28 	
29 	address[] public winners;
30 	uint[] public winnersTickets;
31 	uint[] public winnersETH;
32 	uint[] public winnersTimestamp;
33 	
34 	mapping (address => uint256) public playerBlock;
35 	mapping (address => uint256) public playerTickets;
36 	
37 	event Numbers(address indexed from, uint[] n, string m);
38 	
39 	constructor() public
40 	{
41 		mne = Minereum(0x426CA1eA2406c07d75Db9585F22781c096e3d0E0);
42 		owner = msg.sender;
43 		//data from old contract
44 		ticketsPlayed = 10;
45 		ticketsSold = 13;
46 	}
47 	
48 	receive() external payable { }
49 	
50 	function LuckyDraw() public
51     {
52         require(msg.sender == tx.origin);
53 		
54 		if (block.number >= playerBlock[msg.sender] + 256)
55 		{
56 			uint[] memory empty = new uint[](0);	
57 			emit Numbers(address(this), empty, "Your tickets expired or are invalid. Try Again.");
58 			playerBlock[msg.sender] = 0;
59 			playerTickets[msg.sender] = 0;			
60 		}		
61 		else if (block.number > playerBlock[msg.sender] + blockInterval)
62 		{
63 			bool win = false;
64 
65 			uint[] memory numbers = new uint[](playerTickets[msg.sender]);		
66 			
67 			uint i = 0;
68 			while (i < playerTickets[msg.sender])
69 			{
70 				numbers[i] = uint256(uint256(keccak256(abi.encodePacked(blockhash(playerBlock[msg.sender] + 2), i)))%maxNumber);
71 				if (numbers[i] == systemNumber)
72 					win = true;
73 				i++;				
74 			}
75 			
76 			ticketsPlayed += playerTickets[msg.sender];
77 			
78 			
79 			if (win)
80 			{
81 				address payable add = payable(msg.sender);
82 				uint contractBalance = address(this).balance;
83 				uint winAmount = contractBalance * percentWin / 100;
84 				uint totalToPay = winAmount;
85 				if (!add.send(totalToPay)) revert('Error While Executing Payment.');
86 				totalPaidOut += totalToPay;
87 				
88 				winnersCount++;
89 				winnersEthCount += totalToPay;
90 				emit Numbers(address(this), numbers, "YOU WON!");
91 				
92 				winners.push(msg.sender);
93 				winnersTickets.push(playerTickets[msg.sender]);
94 				winnersETH.push(totalToPay);
95 				winnersTimestamp.push(block.timestamp);
96 			}
97 			else
98 			{
99 				emit Numbers(address(this), numbers, "Your numbers don't match the System Number! Try Again.");
100 			}
101 			
102 			playerBlock[msg.sender] = 0;
103 			playerTickets[msg.sender] = 0;			
104 		}
105 		else
106 		{
107 			revert('Players must wait 3 blocks');
108 		}
109     }
110 	
111 	function BuyTickets(address _sender, uint256[] memory _max) public payable returns (uint256)
112     {
113 		require(msg.sender == address(mne));
114 		require(_sender == tx.origin);
115 		
116 		if (_max[0] == 0) revert('value is 0');
117 		
118 		if (playerBlock[_sender] == 0)
119 		{	
120 			uint valueStakeHolder = msg.value * stakeHoldersfee / 100;					
121 			ticketsSold += _max[0];			
122 			uint totalEthfee = ethfee * _max[0];
123 			uint totalMneFee = mnefee * _max[0];
124 			
125 			playerBlock[_sender] = block.number;
126 			playerTickets[_sender] = _max[0];			
127 			
128 			if (msg.value < totalEthfee) revert('Not enough ETH.');
129 			mne.Payment.value(valueStakeHolder)();
130 			totalSentToStakeHolders += valueStakeHolder;
131 			return totalMneFee;
132 		}
133 		else 
134 		{
135 			revert('You must play the tickets first');
136 		}
137     }
138 	
139 	function transferFundsOut() public
140 	{
141 		if (msg.sender == owner)
142 		{
143 			address payable add = payable(msg.sender);
144 			uint contractBalance = address(this).balance;
145 			if (!add.send(contractBalance)) revert('Error While Executing Payment.');			
146 		}
147 		else
148 		{
149 			revert();
150 		}
151 	}
152 	
153 	function updateFees(uint _stakeHoldersfee, uint _mnefee, uint _ethfee, uint _blockInterval) public
154 	{
155 		if (msg.sender == owner)
156 		{
157 			stakeHoldersfee = _stakeHoldersfee;
158 			mnefee = _mnefee;
159 			ethfee = _ethfee;
160 			blockInterval = _blockInterval;
161 		}
162 		else
163 		{
164 			revert();
165 		}
166 	}
167 	
168 	function updateSystemNumber(uint _systemNumber) public
169 	{
170 		if (msg.sender == owner)
171 		{
172 			systemNumber = _systemNumber;
173 		}
174 		else
175 		{
176 			revert();
177 		}
178 	}
179 	
180 	function updateMaxNumber(uint _maxNumber) public
181 	{
182 		if (msg.sender == owner)
183 		{
184 			maxNumber = _maxNumber;
185 		}
186 		else
187 		{
188 			revert();
189 		}
190 	}
191 	
192 	function updatePercentWin(uint _percentWin) public
193 	{
194 		if (msg.sender == owner)
195 		{
196 			percentWin = _percentWin;
197 		}
198 		else
199 		{
200 			revert();
201 		}
202 	}	
203 	
204 	function updateMNEContract(address _mneAddress) public
205 	{
206 		if (msg.sender == owner)
207 		{
208 			mne = Minereum(_mneAddress);
209 		}
210 		else
211 		{
212 			revert();
213 		}
214 	}
215 	
216 	function WinnersLength() public view returns (uint256) { return winners.length; }	
217 	function GetPlayerBlock(address _address) public view returns (uint256) { return playerBlock[_address]; }
218 	function GetPlayerTickets(address _address) public view returns (uint256) { return playerTickets[_address]; }
219 }