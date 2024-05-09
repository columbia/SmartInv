1 pragma solidity ^0.4.25;
2 contract owned {
3     address public owner;
4 
5     constructor() public {
6         owner = msg.sender;
7     }
8 
9     modifier onlyOwner {
10         require (msg.sender == owner);
11         _;
12     }
13 
14     function transferOwnership(address newOwner) public onlyOwner {
15         owner = newOwner;
16     }
17 }
18 
19 
20 contract PowerBall is owned {
21  using Strings for string;
22     struct Ticket {
23         address player;
24         uint id;
25         uint drawDate;
26 		uint price;
27 		string balls;
28         uint16[] whiteBalls;
29         uint16 redBall;
30     }
31     
32     struct Player {
33         address id;
34 		uint ticketCount;
35         uint[] arrayIdTickets;
36 		string ticketId;
37     }
38     
39 	struct Draws {
40         uint drawId;
41 		uint ticketCount;
42 		uint revenue;
43         uint[] arrayIdTickets;
44 		string ticketId;
45 		uint8 Special; //match 4 balls + power ball
46         uint8 First; //match 3 balls + power ball
47 		uint8 Second; //match 2 balls + power ball
48 		uint8 Third; //match 1 balls + power ball
49         string Result;
50     }
51 	
52 	struct TicketInfo{
53 		uint priceTicket;
54 		uint8 specialPrize;
55 		uint8 firstPrize;
56 		uint8 secondPrize;
57 		uint8 thirdPrize;
58 	}
59 	
60 	struct PrizeInfo{
61 		uint specialPrize;
62 		uint firstPrize;
63 		uint secondPrize;
64 		uint thirdPrize;
65 	}
66 	
67     bool acceptTicket = false;
68     TicketInfo public ticketInfo;
69     uint idTicket = 0;
70     uint16 numBall = 5;
71 	uint16 maxRedBall = 26;
72 	uint16 maxNumBall = 70;
73 	PrizeInfo public prizes;
74     mapping (uint => Ticket) public tickets;
75 	mapping (address => Player) public players;
76 	mapping (uint => Draws) public draws;
77 	
78     
79 	modifier isAcceptTicket(uint16[] balls) {
80 		require(balls.length >= numBall );
81 		require(balls.length % numBall == 0);
82 		_;
83 	}
84     
85     
86     event logBuyTicketSumary(
87         address user,
88         uint[] ticketId,
89 		uint drawDate
90     );
91     
92 	constructor() public{
93 		ticketInfo.priceTicket  = 10000; 		// 10 GM
94 		ticketInfo.specialPrize = 30; 			//30 percent
95 		ticketInfo.firstPrize = 2; 				//2 percent
96 		ticketInfo.secondPrize = 5; 			//5 percent
97 		ticketInfo.thirdPrize = 8; 				//8 percent
98 	}
99 	
100 	function setTicketInfo(uint price, uint8 specialPrize, uint8 firstPrize, uint8 secondPrize, uint8 thirdPrize)
101 	public
102 	onlyOwner
103 	{
104 		ticketInfo.priceTicket  = price; 		
105 		ticketInfo.specialPrize = specialPrize; 
106 		ticketInfo.firstPrize = firstPrize; 	
107 		ticketInfo.secondPrize = secondPrize; 	
108 		ticketInfo.thirdPrize = thirdPrize; 	
109 	}
110 	
111 	function DrawResult(uint16[] result, uint drawDate, uint8 special, uint8 first,uint8 second, uint8 third)
112 	public
113 	onlyOwner
114 	{
115 		
116 		require(draws[drawDate].revenue != 0);
117 		require(result.length == numBall);
118 		bytes memory emptyResult = bytes(draws[drawDate].Result);
119 		if(emptyResult.length == 0){
120 			uint spe = 0;
121 			uint fst = 0;
122 			uint snd = 0;
123 			uint thr = 0;
124 			if(special == 0)
125 				spe = prizes.specialPrize + (draws[drawDate].revenue *  ticketInfo.specialPrize);
126 			if(first == 0)
127 				fst = prizes.firstPrize + (draws[drawDate].revenue *  ticketInfo.firstPrize);
128 			if(second == 0)
129 				snd = prizes.secondPrize + (draws[drawDate].revenue *  ticketInfo.secondPrize);
130 			if(third == 0)
131 				thr = prizes.thirdPrize + (draws[drawDate].revenue *  ticketInfo.thirdPrize);
132 			Prizes(spe,fst,snd,thr);
133 		}
134 		string memory rs = "";
135 		for(uint8 i=0; i<result.length; i++){
136 			rs = rs.append(uint2str(result[i]));
137 		}
138 		draws[drawDate].Result = rs;
139 		draws[drawDate].Special = special;
140 		draws[drawDate].First = first;
141 		draws[drawDate].Second = second;
142 		draws[drawDate].Third = third;
143 	}
144 	
145 	
146 	
147     function giveTicket(address user, uint16[] balls, uint drawDate) 
148 	    public 
149 		onlyOwner
150 	    isAcceptTicket(balls)
151 	{
152 	   
153 		address id = user;
154 		uint[] memory totalId = new uint[](balls.length / numBall);
155 		for(uint16 i =0; i<balls.length; i += numBall){
156 			idTicket++;
157 			uint16[] memory wb = new uint16[](numBall -1);
158 			string memory _balls = "";
159 			for(uint16 j = 0; j< numBall -1; j++){
160 				uint16 ball = i  + j;
161 				wb[j] = balls[ball];
162 				_balls = _balls.append(uint2str(balls[ball]));
163 			}
164 			 bool bMatch = true;
165 			if(wb.length == numBall-1){
166 				bMatch = checkBalls(wb);
167 			}
168 			require (!bMatch);		
169 			uint16 rb = balls[i + numBall -1];
170 			require(checkRedBall(rb));
171 			// create ticket
172 			Ticket memory ticket = Ticket({
173 				player: id,
174 				id: idTicket,
175 				drawDate: drawDate,
176 				price: ticketInfo.priceTicket,
177 				balls:_balls,
178 				whiteBalls:wb,
179 				redBall:rb
180 			});
181 			players[id].arrayIdTickets.push(idTicket);
182 			players[id].id = id;
183 			players[id].ticketCount = players[id].arrayIdTickets.length;
184 			players[id].ticketId = players[id].ticketId.append(uint2str(uint(idTicket)));
185 			
186 			draws[drawDate].arrayIdTickets.push(idTicket);
187 			draws[drawDate].drawId = drawDate;
188 			draws[drawDate].ticketCount = draws[drawDate].arrayIdTickets.length;
189 			draws[drawDate].ticketId = draws[drawDate].ticketId.append(uint2str(uint(idTicket)));
190 			draws[drawDate].revenue += ticket.price;
191 			
192 			tickets[idTicket] = ticket;
193 			totalId[i/numBall] = idTicket;
194 		}
195 		emit logBuyTicketSumary(id,totalId,drawDate);
196 	}
197 	
198     function buyTicket(uint16[] balls, uint drawDate) 
199 	    public 
200 	    isAcceptTicket(balls)
201 	{
202 	   
203 		address id = msg.sender;
204 		uint[] memory totalId = new uint[](balls.length / numBall);
205 		for(uint16 i =0; i<balls.length; i += numBall){
206 			idTicket++;
207 			uint16[] memory wb = new uint16[](numBall -1);
208 			string memory _balls = "";
209 			for(uint16 j = 0; j< numBall -1; j++){
210 				uint16 ball = i  + j;
211 				wb[j] = balls[ball];
212 				_balls = _balls.append(uint2str(balls[ball]));
213 			}
214 			 bool bMatch = true;
215 			if(wb.length == numBall-1){
216 				bMatch = checkBalls(wb);
217 			}
218 			require (!bMatch);		
219 			uint16 rb = balls[i + numBall -1];
220 			require(checkRedBall(rb));
221 			// create ticket
222 			Ticket memory ticket = Ticket({
223 				player: id,
224 				id: idTicket,
225 				drawDate: drawDate,
226 				price: ticketInfo.priceTicket,
227 				balls:_balls,
228 				whiteBalls:wb,
229 				redBall:rb
230 			});
231 			players[id].arrayIdTickets.push(idTicket);
232 			players[id].id = id;
233 			players[id].ticketCount = players[id].arrayIdTickets.length;
234 			players[id].ticketId = players[id].ticketId.append(uint2str(uint(idTicket)));
235 			
236 			draws[drawDate].arrayIdTickets.push(idTicket);
237 			draws[drawDate].drawId = drawDate;
238 			draws[drawDate].ticketCount = draws[drawDate].arrayIdTickets.length;
239 			draws[drawDate].ticketId = draws[drawDate].ticketId.append(uint2str(uint(idTicket)));
240 			draws[drawDate].revenue += ticket.price;
241 			
242 			tickets[idTicket] = ticket;
243 			totalId[i/numBall] = idTicket;
244 		}
245 		emit logBuyTicketSumary(id,totalId,drawDate);
246 	}
247 	
248 	function getTicket(uint id) internal view returns(uint drawDate,string ballNum){
249 		uint16[] storage  balls = tickets[id].whiteBalls;
250 		for(uint8 i=0; i < balls.length; i++){
251 			ballNum = ballNum.concat(uint2str(balls[i]));
252 			ballNum = ballNum.concat("-");
253 		}
254 		uint16 redb = tickets[id].redBall;
255 		ballNum = ballNum.concat(uint2str(redb));
256 		drawDate = tickets[id].drawDate;
257 	}
258 	
259 	function viewTicket(uint id) internal view returns(uint drawDate, string ballNum){
260 		uint16[] storage  balls = tickets[id].whiteBalls;
261 		for(uint8 i=0; i < balls.length; i++){
262 			ballNum = ballNum.append(uint2str(balls[i]));
263 		}
264 		uint16 redb = tickets[id].redBall;
265 		ballNum = ballNum.append(uint2str(redb));
266 		drawDate = tickets[id].drawDate;
267 	}
268 	function checkRedBall(uint16 ball) private view returns (bool){
269 		return(ball <= maxRedBall);
270 	}
271 	
272 	function checkBalls(uint16[] ar) private view returns (bool){
273         bool bMatch = false;
274         uint8 i = uint8(numBall-1);
275         uint8 j = uint8(numBall-1);
276         
277         while (i > 0) {
278             i--;
279             j = uint8(numBall-1);
280             uint16 num1 = ar[i];
281 			require(num1 <= maxNumBall);
282             while (j > 0) {
283                 j--;
284                 uint16 num2 = ar[j];
285 				require(num2 <= maxNumBall);
286                 if(num1 == num2 && i != j){
287                     bMatch = true;
288                     break;
289                 }
290             }
291             if(bMatch){
292                 break;
293             }
294         }
295         
296        return bMatch;
297     }
298 	function checkRevenue(uint drawDate)
299 	public 
300 	onlyOwner
301 	{
302 		require(draws[drawDate].revenue > 0);
303 		uint[] memory ids = draws[drawDate].arrayIdTickets;
304 		draws[drawDate].revenue = 0;
305 		for(uint16 i = 0; i< ids.length; i++){
306 			draws[drawDate].revenue += tickets[ids[i]].price;
307 		}
308 	}
309 	
310 	function Prizes(uint spe, uint fst, uint snd, uint thr)
311 	public 
312 	onlyOwner
313 	{
314 		prizes.specialPrize = spe;
315 		prizes.firstPrize = fst;
316 		prizes.secondPrize = snd;
317 		prizes.thirdPrize = thr;
318 	}
319 	
320 	function uint2str(uint i) internal pure returns (string){
321 		if (i == 0) return "0";
322 		uint j = i;
323 		uint length;
324 		while (j != 0){
325 			length++;
326 			j /= 10;
327 		}
328 		bytes memory bstr = new bytes(length);
329 		uint k = length - 1;
330 		while (i != 0){
331 			bstr[k--] = byte(48 + i % 10);
332 			i /= 10;
333 		}
334 		return string(bstr);
335 	}
336 	
337 	
338 }
339 
340 library Strings {
341 	function append(string _base, string _value)  internal pure returns (string) {
342 		return string(abi.encodePacked(_base,"[",_value,"]"," "));
343 	}
344 
345     function concat(string _base, string _value) internal pure returns (string) {
346         bytes memory _baseBytes = bytes(_base);
347         bytes memory _valueBytes = bytes(_value);
348 
349         string memory _tmpValue = new string(_baseBytes.length + _valueBytes.length);
350         bytes memory _newValue = bytes(_tmpValue);
351 
352         uint i;
353         uint j;
354 
355         for(i=0; i<_baseBytes.length; i++) {
356             _newValue[j++] = _baseBytes[i];
357         }
358 
359         for(i=0; i<_valueBytes.length; i++) {
360             _newValue[j++] = _valueBytes[i];
361         }
362 
363         return string(_newValue);
364     }
365 
366 }