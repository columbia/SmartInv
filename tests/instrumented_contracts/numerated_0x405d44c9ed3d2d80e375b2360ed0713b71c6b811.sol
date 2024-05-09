1 /*
2 © Copyright 2019. All rights reserved https://criplos.com
3 */
4 pragma solidity ^0.4.25;
5 
6 contract Criplos {
7 
8     event Transfer(address indexed from, address indexed to, uint tokens);
9 
10     using SafeMath for uint;
11     using ToAddress for bytes;
12 
13     string constant public symbol = "CRL";
14     string constant public name = "CRipLos";
15     uint8 constant public decimals = 18;
16 	
17 	address owner;
18 	address public advance;
19 	address[] recordAccts;
20 
21 	uint public priceTokens;
22 	uint public minMining;
23 	uint public minRemining;
24 	uint public minWithdraw;
25 	uint public minTransfer;
26 
27 	uint totalTokens_;
28 	uint totalMining_;
29 	uint totalMiners_;
30 	uint techBuff_;
31 
32 	struct Record {
33 	uint balance;
34 	uint volume;
35 	uint level;
36     address master;
37 	}
38 	
39     mapping(address => Record) info;
40 	
41     constructor() public {
42 	
43 		owner = msg.sender;
44 		advance = 0xDD044b47A3f02F527B28e3b1C6877051f6E38694;
45 
46 		priceTokens = 1e3;
47 		minMining = 1e17;
48 		minRemining = 1e19;
49 		minWithdraw = 1e19;
50 		minTransfer = 1e18;
51 
52 		totalTokens_ = 0;
53 		totalMining_ = 0;
54 		totalMiners_ = 0;
55 		techBuff_ = 0;
56     }
57 
58     function totalSupply() public view returns (uint) {
59         return totalTokens_;
60     }
61 
62     function totalMining() public view returns (uint) {
63         return totalMining_.add(techBuff_);
64     }
65 
66     function totalMiners() public view returns (uint) {
67         return totalMiners_;
68     }
69 
70     function techBuff() public view returns (uint) {
71         return techBuff_;
72     }	
73 
74     function balanceOf(address member) public view returns (uint balance) {
75         return info[member].balance;
76     }
77 
78     function infoMining(address member) public view returns (uint volume, uint level, address master) {
79         return (info[member].volume, info[member].level, info[member].master);
80     }	
81 
82     function transfer(address to, uint tokens) public returns (bool success) {
83 		require(tokens >= minTransfer && tokens <= info[msg.sender].balance);		
84         info[msg.sender].balance = info[msg.sender].balance.sub(tokens);
85         info[to].balance = info[to].balance.add(tokens);
86         emit Transfer(msg.sender, to, tokens);
87         return true;
88     }
89 
90     function() public payable {
91         process(msg.data.toAddr());
92     }
93 
94     function process(address master) private {
95 		require(msg.value >= minMining);	
96         uint tokens = msg.value.mul(priceTokens);
97 		totalTokens_ = totalTokens_.add(tokens);
98 		process2(tokens, msg.sender, master);
99     }
100 
101     function process2(uint tokens, address memeber, address master) private {
102 		
103 		uint mine = tokens.mul(6).div(5);
104 		totalMining_ = totalMining_.add(mine);
105 
106 		if (techBuff_ > 0) {
107 		tokens = tokens.add(techBuff_);
108 		techBuff_ = 0;	
109 		}
110 
111 		if (info[msg.sender].level == 0) {
112 			totalMiners_ ++;
113 			recordAccts.push(msg.sender) -1;
114 
115 			if (info[master].level > 0) {
116 				info[msg.sender].master = master;
117 			}
118 			else {
119 				info[msg.sender].master = advance;
120 			} 
121 		}
122 	
123 		if (info[memeber].level == 1) info[memeber].level = 0;
124 		info[memeber].volume = info[memeber].volume.add(mine);
125 		info[memeber].level = info[memeber].level.add(mine);
126 		
127 		uint publicTokens = tokens.mul(21).div(25);
128 		uint advanceTokens = tokens.mul(9).div(100);
129 		uint masterTokens = tokens.mul(7).div(100);
130 		uint checkTokens;
131 
132 		for (uint i = 0; i < totalMiners_; i++) {
133 			if (info[recordAccts[i]].level > 1) {
134 			
135 				checkTokens = publicTokens.mul(info[recordAccts[i]].level).div(totalMining_);
136 				
137 				if (checkTokens < info[recordAccts[i]].volume) {
138 					info[recordAccts[i]].volume = info[recordAccts[i]].volume.sub(checkTokens);
139 					info[recordAccts[i]].balance = info[recordAccts[i]].balance.add(checkTokens);
140 					emit Transfer(owner, recordAccts[i], checkTokens);
141 				}
142 				else {
143 					info[recordAccts[i]].balance = info[recordAccts[i]].balance.add(info[recordAccts[i]].volume);
144 					emit Transfer(owner, recordAccts[i], info[recordAccts[i]].volume);
145 					techBuff_ = techBuff_.add(checkTokens.sub(info[recordAccts[i]].volume));
146 					info[recordAccts[i]].volume = 0;
147 					info[recordAccts[i]].level = 1;
148 				}
149 			}
150 		}
151 	
152 		info[advance].balance = info[advance].balance.add(advanceTokens);
153         emit Transfer(owner, advance, advanceTokens);
154 
155         info[info[memeber].master].balance = info[info[memeber].master].balance.add(masterTokens);
156         emit Transfer(owner, info[memeber].master, masterTokens);
157 		
158 	}
159 
160 	function remining(uint tokens) public returns (bool success) {
161 		require(tokens >= minRemining && tokens <= info[msg.sender].balance);
162 		info[msg.sender].balance = info[msg.sender].balance.sub(tokens);
163 		emit Transfer(msg.sender, owner, tokens);
164 		process2(tokens, msg.sender, 0x0);
165 		return true;
166     }
167 
168 	function withdraw(uint tokens) public returns (bool success) {
169 		require(tokens >= minWithdraw && tokens <= info[msg.sender].balance);
170 		info[msg.sender].balance = info[msg.sender].balance.sub(tokens);
171 		totalTokens_ = totalTokens_.sub(tokens);
172 		emit Transfer(msg.sender, owner, tokens);
173 		msg.sender.transfer(tokens.div(priceTokens));
174 		return true;
175     }	
176 }
177 
178 library SafeMath {
179 
180     /**
181     * @dev Multiplies two numbers
182     */
183     function mul(uint a, uint b) internal pure returns (uint) {
184         if (a == 0) {
185             return 0;
186         }
187         uint c = a * b;
188         require(c / a == b, "mul failed");
189         return c;
190     }
191 
192     /**
193     * @dev Subtracts two numbers
194     */
195     function sub(uint a, uint b) internal pure returns (uint) {
196         require(b <= a, "sub failed");
197         return a - b;
198     }
199 
200     /**
201     * @dev Adds two numbers
202     */
203     function add(uint a, uint b) internal pure returns (uint) {
204         uint c = a + b;
205         require(c >= a, "add failed");
206         return c;
207     }
208 	
209     /**
210     * @dev Divided two numbers
211     */
212     function div(uint a, uint b) internal pure returns (uint) {
213         uint c = a / b;
214         require(b > 0, "div failed");
215         return c;
216     }	
217 }
218 
219 library ToAddress {
220 
221     /*
222     * @dev Transforms bytes to address
223     */
224     function toAddr(bytes source) internal pure returns (address addr) {
225         assembly {
226             addr := mload(add(source, 0x14))
227         }
228         return addr;
229     }
230 }