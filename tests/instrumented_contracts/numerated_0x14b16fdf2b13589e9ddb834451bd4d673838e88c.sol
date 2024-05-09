1 pragma solidity ^0.4.2;
2 
3 contract MyInterface{
4 	function zGetGameBalance() public view returns (uint);
5 	function zReceiveFunds() payable public;
6 	function zSynchGameID(uint nIndex, uint nExpiration) public;
7 }
8 
9 contract FantasySports {
10 	address gadrOwner;
11 	uint gnGameID = 0;
12 	address gadrOtherContract;
13 	MyInterface gobjOtherContract;
14 	uint constant gcnWinMultipler = 195;
15 	uint constant gcnTransferFee = .0001 ether;
16 
17 	mapping(uint => address[]) gmapGame_addresses;
18 	mapping(uint => uint[]) gmapGame_wagers;
19 	mapping(uint => uint[]) gmapGame_runningbalances;
20 	mapping(uint => uint) gmapGame_balance;
21 	mapping(uint => uint) gmapGame_expiration;
22 
23 	modifier onlyOwner() {
24 		require(gadrOwner == msg.sender);
25 		_;
26 
27 	}
28 
29 	modifier onlyOtherContract() {
30 		require(gadrOtherContract == msg.sender);
31 		_;
32 	}
33 
34 	function FantasySports () public {
35 		gadrOwner = msg.sender;
36 	}
37 
38 	function zReceiveFunds() payable public {
39 	}
40 
41 	function() payable public {
42 		require(msg.value >= .001 ether && block.timestamp < gmapGame_expiration[gnGameID]);
43 		gmapGame_addresses[gnGameID].push(msg.sender);
44 		gmapGame_wagers[gnGameID].push(msg.value);
45 		gmapGame_balance[gnGameID] +=msg.value;
46 		gmapGame_runningbalances[gnGameID].push(gmapGame_balance[gnGameID]);
47 	}
48 
49 	function zSynchGameID(uint nIndex, uint nExpiration) onlyOtherContract() public {
50 		gnGameID = nIndex;
51 		gmapGame_expiration[gnGameID] = nExpiration;
52 	}
53 
54 	function zSetGameID(uint nIndex, uint nExpiration) onlyOwner() public {
55 		gnGameID = nIndex;
56 		gmapGame_expiration[gnGameID] = nExpiration;
57 		gobjOtherContract.zSynchGameID(gnGameID, nExpiration);
58 	}
59 
60 	function zIncrementGameID(uint nExpiration) onlyOwner() public {
61 		gnGameID++;
62 		gmapGame_expiration[gnGameID] = nExpiration;
63 		gobjOtherContract.zSynchGameID(gnGameID, nExpiration);
64 	}
65 
66 	function zGetGameID() onlyOwner() public view returns (uint) {
67 		return gnGameID;
68 	}
69 
70 	function setOwner (address _owner) onlyOwner() public {
71 		gadrOwner = _owner;
72 	}
73 
74 	function setOtherContract (address _othercontract) onlyOwner() public {
75 		gadrOtherContract = _othercontract;
76 		gobjOtherContract = MyInterface(gadrOtherContract);
77 	}
78 
79 	function zgetOwner() onlyOwner() public view returns (address) {
80 		return gadrOwner;
81 	}
82 
83 	function zgetOtherContract() onlyOwner() public view returns (address) {
84 		return gadrOtherContract;
85 	}
86 
87 	function zgetPlayers(uint nIDOfGame) onlyOwner() public view returns (uint, uint, address[],uint[], uint[]) {
88 		return (gmapGame_balance[nIDOfGame], gmapGame_expiration[nIDOfGame], gmapGame_addresses[nIDOfGame], gmapGame_wagers[nIDOfGame],gmapGame_runningbalances[nIDOfGame]);
89 	}
90 
91 	function zGetGameBalance() onlyOtherContract() public view returns (uint) {
92 		return (gmapGame_balance[gnGameID]);
93 	}
94 
95 	function zRefundAllPlayers() onlyOwner() public {
96 		for (uint i = 0; i < gmapGame_addresses[gnGameID].length; i++) {
97 			gmapGame_addresses[gnGameID][i].transfer(gmapGame_wagers[gnGameID][i] - gcnTransferFee);
98 		}
99 	}
100 
101 	function zGetBothContractBalances() public view onlyOwner() returns (uint, uint) {
102 		uint nOtherBalance = gobjOtherContract.zGetGameBalance();
103 		return (gmapGame_balance[gnGameID], nOtherBalance);
104 	}
105 
106 	function zTransferFundsToOtherContract(uint nAmount) onlyOwner() public {
107 		gobjOtherContract.zReceiveFunds.value(nAmount)();
108 	}
109 
110 	function zTransferFundsToOwner(uint nAmount) onlyOwner() public {
111 		gadrOwner.transfer(nAmount);
112 	}
113 
114 	function zTransferLosingBets() onlyOwner() public {
115 		if (gmapGame_balance[gnGameID] != 0) {
116 			uint nOtherBalance = gobjOtherContract.zGetGameBalance();
117 			if (gmapGame_balance[gnGameID] <= nOtherBalance) {
118 				gobjOtherContract.zReceiveFunds.value(gmapGame_balance[gnGameID])();
119 			} else {
120 				if (nOtherBalance != 0) {
121 					gobjOtherContract.zReceiveFunds.value(nOtherBalance)();
122 				}
123 				for (uint i = 0; i < gmapGame_addresses[gnGameID].length; i++) {
124 					if (gmapGame_runningbalances[gnGameID][i] > nOtherBalance) {
125 						if (gmapGame_runningbalances[gnGameID][i] - nOtherBalance < gmapGame_wagers[gnGameID][i]) {
126 							gmapGame_addresses[gnGameID][i].transfer( (gmapGame_runningbalances[gnGameID][i] - nOtherBalance) - gcnTransferFee);
127 						} else {
128 							gmapGame_addresses[gnGameID][i].transfer(gmapGame_wagers[gnGameID][i] - gcnTransferFee);
129 						}
130 					}
131 				}
132 			}
133 		}
134 	}
135 
136 	function zTransferWinningBets() onlyOwner() public {
137 		if (gmapGame_balance[gnGameID] != 0) {
138 			uint nPreviousRunningBalance = 0;
139 			uint nOtherBalance = gobjOtherContract.zGetGameBalance();
140 			for (uint i = 0; i < gmapGame_addresses[gnGameID].length; i++) {
141 				if (gmapGame_runningbalances[gnGameID][i] <= nOtherBalance) {
142 					gmapGame_addresses[gnGameID][i].transfer((gmapGame_wagers[gnGameID][i] * gcnWinMultipler / 100) - gcnTransferFee);
143 				} else {
144 					if (nPreviousRunningBalance < nOtherBalance) {
145 						gmapGame_addresses[gnGameID][i].transfer(((nOtherBalance - nPreviousRunningBalance) * gcnWinMultipler / 100) + (gmapGame_wagers[gnGameID][i] - (nOtherBalance - nPreviousRunningBalance)) - gcnTransferFee);
146 					} else {
147 						gmapGame_addresses[gnGameID][i].transfer(gmapGame_wagers[gnGameID][i] - gcnTransferFee);
148 					}
149 				}
150 				nPreviousRunningBalance = gmapGame_runningbalances[gnGameID][i];
151 			}
152 		}
153 	}
154 	
155 	function zKill() onlyOwner() public {
156 		selfdestruct(gadrOwner);
157 	}
158 }