1 pragma solidity ^0.4.17;
2 contract BetGame  {
3     struct bet {
4         address player;
5         uint deposit;
6     }
7 
8 	modifier onlyowner {
9 		require(msg.sender == owner, "Only owner is allowed");
10 		_;
11 	 }
12 
13 	bet[] private A ;
14 	bet[] private B;
15 	bet[] private D;
16 
17 	uint private totalA; 
18 	uint private totalB;
19 	uint private totalD;
20 	uint private betEnd;
21 	string private teamA ;
22 	string private teamB ;
23 	bool private open;
24 	address private owner;
25 
26 	constructor(uint t, string a, string b) public {
27 		owner = msg.sender;
28 		betEnd = t;
29 		teamA = a;
30 		teamB = b;
31 		open = true;
32 	}
33 
34 	function close() public onlyowner {
35 		selfdestruct(owner);
36 	}
37 
38 	function getInfo() view onlyowner public returns(string, string, uint, uint, uint, uint, bool, uint, uint, uint) {
39 		return (teamA, teamB, betEnd, totalA, totalB, totalD, open, A.length, B.length, D.length );
40 	}
41 
42 	function getInfoA(uint index) view onlyowner public returns(address, uint) {
43 		return (A[index].player, A[index].deposit);
44 	}
45 	
46 	function getInfoB(uint index) view onlyowner public returns(address, uint) {
47 		return (B[index].player, B[index].deposit);
48 	}
49 	
50 	function getInfoD(uint index) view onlyowner public returns(address, uint) {
51 		return (D[index].player, D[index].deposit);
52 	}
53 	
54 
55 	function winnerIsA() public onlyowner {
56 		if (totalA > 0) {
57         	uint housefee = (totalB + totalD) /80;
58 
59 			uint award = (totalB + totalD) - housefee;
60 
61 			uint ratio = 1000000 * award/totalA;
62 
63 			for (uint p = 0; p < A.length; p++) {
64 				if (A[p].deposit > 0 ) {
65 					if (A[p].player.send(A[p].deposit + A[p].deposit/1000000*ratio)) {
66 						A[p].deposit = 0;
67 					}
68 				}
69         	}
70 			totalA = 0;
71 		}
72 		totalB = 0;
73 		totalD = 0;
74 		open = false;
75     }
76 
77 	function winnerIsB() public onlyowner{
78 		if (totalB > 0) {
79 			uint housefee = (totalA + totalD) /80;
80 			uint award = (totalA + totalD) - housefee;
81 			uint ratio = 1000000 * award/totalB;
82 
83 			for (uint p = 0; p < B.length; p++) {
84 				if (B[p].deposit > 0 ) {
85 					if (B[p].player.send(B[p].deposit + B[p].deposit/1000000*ratio)) {
86 						B[p].deposit = 0;
87 					}
88 				}
89         	}
90 			totalB = 0;
91 		}
92 		totalA = 0;
93 		totalD = 0;
94 		open = false;
95     }
96 
97 	function winnerIsDraw() public onlyowner{
98 		if (totalD > 0) {
99        		uint housefee = (totalB + totalA) /80;
100 			uint award = (totalB + totalA) - housefee;
101 			uint ratio = 1000000 * award/totalD;
102 
103 			for (uint p = 0; p < D.length; p++) {
104 				if (D[p].deposit > 0 ) {
105 					if (D[p].player.send(D[p].deposit + D[p].deposit/1000000*ratio)) {
106 						D[p].deposit = 0;
107 					}
108 				}
109         	}
110 			totalD = 0;
111 		}
112 		totalA = 0;
113 		totalB = 0;
114 		open = false;
115     }
116 
117 	function status(address addr) public view returns(uint, uint, uint, uint, uint, uint, bool) {
118 		uint a;
119 		uint b;
120 		uint d;
121 		
122 		if (!open) {
123 			return (0,0,0,0,0,0, false);
124 		}
125 		 
126 		for (uint p = 0; p < D.length; p++) {
127 			if (D[p].player == addr) {
128 				d+=D[p].deposit;
129 			}
130         }
131 		
132 		for (p = 0; p < A.length; p++) {
133 			if (A[p].player == addr) {
134 				a+=A[p].deposit;
135 			}
136         }
137 		for (p = 0; p < B.length; p++) {
138 			if (B[p].player == addr) {
139 				b+=B[p].deposit;
140 			}
141         }
142 		
143 		return (a,b,d, totalA, totalB, totalD, true);
144 	}
145 
146 
147 	function betA() public payable {
148 		require(
149             now <= betEnd,
150             "Betting already ended."
151         );
152 
153 		require(open, "Game closed");
154 
155 		require(msg.value >= 0.01 ether, "Single bet must be at least 0.01 ether");
156 		totalA+=msg.value;
157 		for(uint p =0; p<A.length; p++) {
158 			if (A[p].player == msg.sender)
159 			{
160 				A[p].deposit += msg.value;
161 				return;
162 			}
163 		}
164 		A.push(bet({player:msg.sender, deposit:msg.value}));
165 	}
166 
167 	function betB() public payable {
168 		require(
169             now <= betEnd,
170             "Betting already ended."
171         );
172 
173 		require(open, "Game closed");
174 		require(msg.value >= 0.01 ether, "Single bet must be at least 0.01 ether");
175 		totalB+=msg.value;
176 		for(uint p =0; p<B.length; p++) {
177 			if (B[p].player == msg.sender)
178 			{
179 				B[p].deposit += msg.value;
180 				return;
181 			}
182 		}
183 
184 		B.push(bet({player:msg.sender, deposit:msg.value}));
185 	}
186 	
187 	function betD() public payable {
188 		require(
189             now <= betEnd,
190             "Betting already ended."
191         );
192 		require(open, "Game closed");
193 		require(msg.value >= 0.01 ether, "Single bet must be at least 0.01 ether");
194 		totalD+=msg.value;
195 		for(uint p =0; p<D.length; p++) {
196 			if (D[p].player == msg.sender)
197 			{
198 				D[p].deposit += msg.value;
199 				return;
200 			}
201 		}
202 
203 		D.push(bet({player:msg.sender, deposit:msg.value}));
204 	}
205 }