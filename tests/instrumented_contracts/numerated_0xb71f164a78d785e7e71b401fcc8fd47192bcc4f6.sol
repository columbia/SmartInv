1 pragma solidity ^0.4.24;
2 
3 /*--------------------------------------------------
4  ____                           ____              _ 
5 / ___| _   _ _ __   ___ _ __   / ___|__ _ _ __ __| |
6 \___ \| | | | '_ \ / _ \ '__| | |   / _` | '__/ _` |
7  ___) | |_| | |_) |  __/ |    | |__| (_| | | | (_| |
8 |____/ \__,_| .__/ \___|_|     \____\__,_|_|  \__,_|
9             |_|                                   
10 
11                                     2018-08-31 V1.0
12 ---------------------------------------------------*/
13 
14 contract SuperCard {
15 	event onRecieveEth
16     (
17         address user,
18 		uint256 ethIn,
19         uint256 timeStamp
20     );
21 	
22     event onSendEth
23     (
24         address user,
25 		uint256 ethOut,
26         uint256 timeStamp
27     );
28 
29 	event onPotAddup
30     (
31         address operator,
32 		uint256 amount
33     );
34 
35 	using SafeMath for *;
36 
37     string constant public name   = "SuperCard";
38     string constant public symbol = "SPC";
39 
40 	struct Player 
41 	{
42         uint256 ethIn;  // total input
43         uint256 ethOut; // total output
44 	}
45 
46 	struct txRecord 
47 	{
48         address user; // player address
49 		bool used;    // replay
50 		bool todo;    // 
51 	}
52 
53 	mapping( address => Player) public plyr_;    // (address => data) player data
54 	mapping( bytes32 => txRecord) public txRec_; // (hashCode => data) hashCode data
55 
56     address _admin;
57 	address _cfo;
58 
59 	bool public activated_ = false;
60 
61     //uint256 public plan_active_time = now + 7200 seconds;
62 	uint256 public plan_active_time = 1535709600;
63 
64 	// total received
65 	uint256 totalETHin = 0;
66 
67 	// total sendout
68 	uint256 totalETHout = 0;
69 
70 	uint256 _pot = 0;
71 
72 //==============================================================================
73 //     _ _  _  __|_ _    __|_ _  _  .
74 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
75 //==============================================================================
76 	constructor()
77 		public
78 	{
79 		_admin = msg.sender;
80 		_cfo = 0x39db0822a5eb167f2f92607d5c77566e23a88aa7;
81 	}
82 
83 	modifier onlyCFOAndAdmin()
84 	{
85 		require(((msg.sender == _cfo) || (msg.sender == _admin)), "sorry, not cfo/admin");
86 		_;
87 	}
88 
89 	modifier onlyCFO()
90 	{
91 		require(msg.sender == _cfo, "sorry, not cfo");
92 		_;
93 	}
94 
95 	modifier isHuman() 
96 	{
97         address _addr = msg.sender;
98         uint256 _codeLength;
99 
100         assembly {_codeLength := extcodesize(_addr)}
101         require(_codeLength == 0, "sorry, humans only");
102         _;
103     }
104 
105 	modifier isActivated()
106 	{
107         if ( activated_ == false )
108 		{
109           if (now >= plan_active_time)
110 		  {
111 			  activated_ = true;
112           }
113         }
114         require(activated_ == true, "sorry, its not start yet.");
115         _;
116     }
117 
118     function setPlanActiveTime(uint256 _time)
119 		onlyCFOAndAdmin()
120 		public
121     {
122         plan_active_time = _time;
123     }
124 
125 	function getPlanActiveTime()
126 		public
127 		view
128 		returns(uint256, uint256)
129     {
130         return(plan_active_time, now);
131     }
132 
133 	function newCFO(string addr)
134 		onlyCFOAndAdmin()
135 		public 
136 		returns (bool)
137 	{
138 		address newCFOaddress;
139 
140 		newCFOaddress = parseAddr(addr);
141 
142 		if (newCFOaddress != _cfo)
143 		{
144 			_cfo = newCFOaddress;
145 			return true;
146 		}
147 		else
148 		{
149 			return false;
150 		}
151 	}
152 
153 	function distribute(address addr, uint256 ethPay)
154 		public
155 		onlyCFOAndAdmin()
156 		isActivated()
157 	{
158 		require((ethPay <= address(this).balance), "sorry, demand more than balance");
159 		require((ethPay > 0), "sorry, pay zero");
160 
161 		addr.transfer(ethPay);
162 
163 		emit onSendEth
164 		(
165 			addr,
166 			ethPay,
167 			now
168 		);
169 	}
170 
171 	function potAddup()
172         external
173 		onlyCFOAndAdmin()
174         payable
175     {
176         _pot = _pot.add(msg.value);
177 
178 		emit onPotAddup
179 		(
180 			msg.sender,
181 			msg.value
182 		);
183     }
184 
185 	function buy()
186         public
187 		isHuman()
188         payable
189     {
190 		uint256 _now = now;
191 
192 		if (activated_ == false)
193 		{
194 			require((_now >= plan_active_time), "sorry, buy before start");
195 			activated_ = true;
196 		}
197 
198 		require((msg.value > 0), "sorry, buy zero eth");
199 		address buyer = msg.sender;
200 
201 		plyr_[buyer].ethIn = (plyr_[buyer].ethIn).add(msg.value);
202 		totalETHin = totalETHin.add(msg.value);
203 		emit onRecieveEth
204 		(
205 			buyer,
206 			msg.value,
207 			_now
208 		);
209     }
210 	
211     function()
212         public
213 		isHuman()
214 		isActivated()
215         payable
216     {
217 		uint256 _now = now;
218 		address buyer = msg.sender;
219 
220 		require((_now >= plan_active_time), "sorry, buy before start");
221 		require((msg.value > 0), "sorry, buy zero eth");
222 
223 		plyr_[buyer].ethIn = (plyr_[buyer].ethIn).add(msg.value);
224 		totalETHin = totalETHin.add(msg.value);
225 		emit onRecieveEth
226 		(
227 			buyer,
228 			msg.value,
229 			_now
230 		);
231     }
232 
233 	function queryhashcodeused(bytes32 hashCode)
234 		public
235 		view
236 		isActivated()
237 		isHuman()
238 		returns(bool)
239 	{
240 		if((txRec_[hashCode].user != 0) || (txRec_[hashCode].used == true))
241 		{
242 			return true;
243 		}
244 		else
245 		{
246 			return false;
247 		}
248 	}
249 	
250 	function query2noactive(bytes32 hashCode)
251 		public
252 		view
253 		isHuman()
254 		returns(bool)
255 	{
256 		if((txRec_[hashCode].user != 0) || (txRec_[hashCode].used == true))
257 		{
258 			return true;
259 		}
260 		else
261 		{
262 			return false;
263 		}
264 	}
265 
266 	function withdraw(bytes32 hashCode)
267         public
268 		isActivated()
269 		isHuman()
270     {
271 		require((plyr_[msg.sender].ethIn > 0), "sorry, not user");
272 		require((txRec_[hashCode].used != true), "sorry, user replay withdraw");
273 
274 		txRec_[hashCode].user = msg.sender;
275 		txRec_[hashCode].todo = true;
276 		txRec_[hashCode].used = true;
277 	}
278 
279 	// uint256 amount, wei format
280 	function approve(string orderid, string addr, string amt, string txtime, uint256 amount)
281 		public
282         onlyCFO()
283 		isActivated()
284 	{
285 		address user;
286 		bytes32 hashCode;
287 		uint256 ethOut;
288 
289 		user = parseAddr(addr);
290 
291 		hashCode = sha256(orderid, addr, amt, txtime);
292 
293 		require((txRec_[hashCode].user == user), "sorry, hashcode error");
294 		require((txRec_[hashCode].todo == true), "sorry, hashcode replay");
295 
296 		txRec_[hashCode].todo = false;
297 
298 		ethOut = amount; // wei format
299 		require(((ethOut > 0) && (ethOut <= address(this).balance)), "sorry, approve amount error");
300 
301 		totalETHout = totalETHout.add(ethOut);
302 		plyr_[user].ethOut = (plyr_[user].ethOut).add(ethOut);
303 		user.transfer(ethOut);
304 
305 		emit onSendEth
306 		(
307 	        user,
308 			ethOut,
309 			now
310 		);
311 	}
312 
313 	function getUserInfo(string useraddress)
314 		public
315 		view
316 		onlyCFOAndAdmin()
317 		returns(address, uint256, uint256)
318 	{
319 		address user;
320 
321 		user = parseAddr(useraddress);
322 
323 		return
324 		(
325 			user,   // player address
326 			plyr_[user].ethIn,  // total input
327 			plyr_[user].ethOut  // total output
328 		);
329 	}
330 
331 	function parseAddr(string _a)
332 	    internal
333 	    returns (address)
334 	{
335         bytes memory tmp = bytes(_a);
336         uint160 iaddr = 0;
337         uint160 b1;
338         uint160 b2;
339         for (uint i=2; i<2+2*20; i+=2){
340             iaddr *= 256;
341             b1 = uint160(tmp[i]);
342             b2 = uint160(tmp[i+1]);
343             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
344             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
345             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
346             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
347             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
348             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
349             iaddr += (b1*16+b2);
350         }
351         return address(iaddr);
352     }
353 }
354 
355 /**
356  * @title SafeMath v0.1.9
357  * @dev Math operations with safety checks that throw on error
358  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
359  * - added sqrt
360  * - added sq
361  * - added pwr
362  * - changed asserts to requires with error log outputs
363  * - removed div, its useless
364  */
365 library SafeMath {
366 
367     /**
368     * @dev Multiplies two numbers, throws on overflow.
369     */
370     function mul(uint256 a, uint256 b)
371         internal
372         pure
373         returns (uint256 c)
374     {
375         if (a == 0) {
376             return 0;
377         }
378         c = a * b;
379         require(c / a == b, "SafeMath mul failed");
380         return c;
381     }
382 
383     /**
384     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
385     */
386     function sub(uint256 a, uint256 b)
387         internal
388         pure
389         returns (uint256)
390     {
391         require(b <= a, "SafeMath sub failed");
392         return a - b;
393     }
394 
395     /**
396     * @dev Adds two numbers, throws on overflow.
397     */
398     function add(uint256 a, uint256 b)
399         internal
400         pure
401         returns (uint256 c)
402     {
403         c = a + b;
404         require(c >= a, "SafeMath add failed");
405         return c;
406     }
407 }