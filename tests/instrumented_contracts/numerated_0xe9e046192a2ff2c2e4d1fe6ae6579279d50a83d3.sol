1 pragma solidity ^0.4.24;
2 
3 interface ERC20 {
4 	
5 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
6 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
7 	
8 	function name() external view returns (string);
9 	function symbol() external view returns (string);
10 	function decimals() external view returns (uint8);
11 	
12 	function totalSupply() external view returns (uint256);
13 	function balanceOf(address _owner) external view returns (uint256 balance);
14 	function transfer(address _to, uint256 _value) external payable returns (bool success);
15 	function transferFrom(address _from, address _to, uint256 _value) external payable returns (bool success);
16 	function approve(address _spender, uint256 _value) external payable returns (bool success);
17 	function allowance(address _owner, address _spender) external view returns (uint256 remaining);
18 }
19 
20 // 숫자 계산 시 오버플로우 문제를 방지하기 위한 라이브러리
21 library SafeMath {
22 	
23 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
24 		c = a + b;
25 		assert(c >= a);
26 		return c;
27 	}
28 	
29 	function sub(uint256 a, uint256 b) pure internal returns (uint256 c) {
30 		assert(b <= a);
31 		return a - b;
32 	}
33 	
34 	function mul(uint256 a, uint256 b) pure internal returns (uint256 c) {
35 		if (a == 0) {
36 			return 0;
37 		}
38 		c = a * b;
39 		assert(c / a == b);
40 		return c;
41 	}
42 	
43 	function div(uint256 a, uint256 b) pure internal returns (uint256 c) {
44 		return a / b;
45 	}
46 }
47 
48 // ERC20 토큰을 이더로 거래합니다.
49 contract ERC20Sale {
50 	using SafeMath for uint256;
51 	
52 	// 이벤트들
53 	event Bid(uint256 bidId);
54 	event ChangeBidId(uint256 indexed originBidId, uint256 newBidId);
55 	event RemoveBid(uint256 indexed bidId);
56 	event CancelBid(uint256 indexed bidId);
57 	event Sell(uint256 indexed bidId, uint256 amount);
58 	
59 	event Offer(uint256 offerId);
60 	event ChangeOfferId(uint256 indexed originOfferId, uint256 newOfferId);
61 	event RemoveOffer(uint256 indexed offerId);
62 	event CancelOffer(uint256 indexed offerId);
63 	event Buy(uint256 indexed offerId, uint256 amount);
64 	
65 	// 구매 정보
66 	struct BidInfo {
67 		address bidder;
68 		address token;
69 		uint256 amount;
70 		uint256 price;
71 	}
72 	
73 	// 판매 정보
74 	struct OfferInfo {
75 		address offeror;
76 		address token;
77 		uint256 amount;
78 		uint256 price;
79 	}
80 	
81 	// 정보 저장소
82 	BidInfo[] public bidInfos;
83 	OfferInfo[] public offerInfos;
84 	
85 	function getBidCount() view public returns (uint256) {
86 		return bidInfos.length;
87 	}
88 	
89 	function getOfferCount() view public returns (uint256) {
90 		return offerInfos.length;
91 	}
92 	
93 	// 토큰 구매 정보를 거래소에 등록합니다.
94 	function bid(address token, uint256 amount) payable public {
95 		
96 		// 구매 정보 생성
97 		uint256 bidId = bidInfos.push(BidInfo({
98 			bidder : msg.sender,
99 			token : token,
100 			amount : amount,
101 			price : msg.value
102 		})).sub(1);
103 		
104 		emit Bid(bidId);
105 	}
106 	
107 	// 토큰 구매 정보를 삭제합니다.
108 	function removeBid(uint256 bidId) internal {
109 		
110 		for (uint256 i = bidId; i < bidInfos.length - 1; i += 1) {
111 			bidInfos[i] = bidInfos[i + 1];
112 			
113 			emit ChangeBidId(i + 1, i);
114 		}
115 		
116 		delete bidInfos[bidInfos.length - 1];
117 		bidInfos.length -= 1;
118 		
119 		emit RemoveBid(bidId);
120 	}
121 	
122 	// 토큰 구매를 취소합니다.
123 	function cancelBid(uint256 bidId) public {
124 		
125 		BidInfo memory bidInfo = bidInfos[bidId];
126 		
127 		// 구매자인지 확인합니다.
128 		require(bidInfo.bidder == msg.sender);
129 		
130 		// 구매 정보 삭제
131 		removeBid(bidId);
132 		
133 		// 이더를 환불합니다.
134 		bidInfo.bidder.transfer(bidInfo.price);
135 		
136 		emit CancelBid(bidId);
137 	}
138 	
139 	// 구매 등록된 토큰을 판매합니다.
140 	function sell(uint256 bidId, uint256 amount) public {
141 		
142 		BidInfo storage bidInfo = bidInfos[bidId];
143 		ERC20 erc20 = ERC20(bidInfo.token);
144 		
145 		// 판매자가 가진 토큰의 양이 판매할 양보다 많아야 합니다.
146 		require(erc20.balanceOf(msg.sender) >= amount);
147 		
148 		// 거래소에 인출을 허락한 토큰의 양이 판매할 양보다 많아야 합니다.
149 		require(erc20.allowance(msg.sender, this) >= amount);
150 		
151 		// 구매하는 토큰의 양이 판매할 양보다 많아야 합니다.
152 		require(bidInfo.amount >= amount);
153 		
154 		uint256 realPrice = amount.mul(bidInfo.price).div(bidInfo.amount);
155 		
156 		// 가격 계산에 문제가 없어야 합니다.
157 		require(realPrice.mul(bidInfo.amount) == amount.mul(bidInfo.price));
158 		
159 		// 토큰 구매자에게 토큰을 지급합니다.
160 		erc20.transferFrom(msg.sender, bidInfo.bidder, amount);
161 		
162 		// 가격을 내립니다.
163 		bidInfo.price = bidInfo.price.sub(realPrice);
164 		
165 		// 구매할 토큰의 양을 줄입니다.
166 		bidInfo.amount = bidInfo.amount.sub(amount);
167 		
168 		// 토큰을 모두 구매하였으면 구매 정보 삭제
169 		if (bidInfo.amount == 0) {
170 			removeBid(bidId);
171 		}
172 		
173 		// 판매자에게 이더를 지급합니다.
174 		msg.sender.transfer(realPrice);
175 		
176 		emit Sell(bidId, amount);
177 	}
178 	
179 	// 주어진 토큰에 해당하는 구매 정보 개수를 반환합니다.
180 	function getBidCountByToken(address token) view public returns (uint256) {
181 		
182 		uint256 bidCount = 0;
183 		
184 		for (uint256 i = 0; i < bidInfos.length; i += 1) {
185 			if (bidInfos[i].token == token) {
186 				bidCount += 1;
187 			}
188 		}
189 		
190 		return bidCount;
191 	}
192 	
193 	// 주어진 토큰에 해당하는 구매 정보 ID 목록을 반환합니다.
194 	function getBidIdsByToken(address token) view public returns (uint256[]) {
195 		
196 		uint256[] memory bidIds = new uint256[](getBidCountByToken(token));
197 		
198 		for (uint256 i = 0; i < bidInfos.length; i += 1) {
199 			if (bidInfos[i].token == token) {
200 				bidIds[bidIds.length - 1] = i;
201 			}
202 		}
203 		
204 		return bidIds;
205 	}
206 
207 	// 토큰 판매 정보를 거래소에 등록합니다.
208 	function offer(address token, uint256 amount, uint256 price) public {
209 		ERC20 erc20 = ERC20(token);
210 		
211 		// 판매자가 가진 토큰의 양이 판매할 양보다 많아야 합니다.
212 		require(erc20.balanceOf(msg.sender) >= amount);
213 		
214 		// 거래소에 인출을 허락한 토큰의 양이 판매할 양보다 많아야 합니다.
215 		require(erc20.allowance(msg.sender, this) >= amount);
216 		
217 		// 판매 정보 생성
218 		uint256 offerId = offerInfos.push(OfferInfo({
219 			offeror : msg.sender,
220 			token : token,
221 			amount : amount,
222 			price : price
223 		})).sub(1);
224 		
225 		emit Offer(offerId);
226 	}
227 	
228 	// 토큰 판매 정보를 삭제합니다.
229 	function removeOffer(uint256 offerId) internal {
230 		
231 		for (uint256 i = offerId; i < offerInfos.length - 1; i += 1) {
232 			offerInfos[i] = offerInfos[i + 1];
233 			
234 			emit ChangeOfferId(i + 1, i);
235 		}
236 		
237 		delete offerInfos[offerInfos.length - 1];
238 		offerInfos.length -= 1;
239 		
240 		emit RemoveOffer(offerId);
241 	}
242 	
243 	// 토큰 판매를 취소합니다.
244 	function cancelOffer(uint256 offerId) public {
245 		
246 		// 판매자인지 확인합니다.
247 		require(offerInfos[offerId].offeror == msg.sender);
248 		
249 		// 판매 정보 삭제
250 		removeOffer(offerId);
251 		
252 		emit CancelOffer(offerId);
253 	}
254 	
255 	// 판매 등록된 토큰을 구매합니다.
256 	function buy(uint256 offerId, uint256 amount) payable public {
257 		
258 		OfferInfo storage offerInfo = offerInfos[offerId];
259 		ERC20 erc20 = ERC20(offerInfo.token);
260 		
261 		// 판매자가 가진 토큰의 양이 판매할 양보다 많아야 합니다.
262 		require(erc20.balanceOf(offerInfo.offeror) >= amount);
263 		
264 		// 거래소에 인출을 허락한 토큰의 양이 판매할 양보다 많아야 합니다.
265 		require(erc20.allowance(offerInfo.offeror, this) >= amount);
266 		
267 		// 판매하는 토큰의 양이 구매할 양보다 많아야 합니다.
268 		require(offerInfo.amount >= amount);
269 		
270 		// 토큰 가격이 제시한 가격과 동일해야합니다.
271 		require(offerInfo.price.mul(amount) == msg.value.mul(offerInfo.amount));
272 		
273 		// 토큰 구매자에게 토큰을 지급합니다.
274 		erc20.transferFrom(offerInfo.offeror, msg.sender, amount);
275 		
276 		// 가격을 내립니다.
277 		offerInfo.price = offerInfo.price.sub(msg.value);
278 		
279 		// 판매 토큰의 양을 줄입니다.
280 		offerInfo.amount = offerInfo.amount.sub(amount);
281 		
282 		// 토큰이 모두 팔렸으면 판매 정보 삭제
283 		if (offerInfo.amount == 0) {
284 			removeOffer(offerId);
285 		}
286 		
287 		// 판매자에게 이더를 지급합니다.
288 		offerInfo.offeror.transfer(msg.value);
289 		
290 		emit Buy(offerId, amount);
291 	}
292 	
293 	// 주어진 토큰에 해당하는 판매 정보 개수를 반환합니다.
294 	function getOfferCountByToken(address token) view public returns (uint256) {
295 		
296 		uint256 offerCount = 0;
297 		
298 		for (uint256 i = 0; i < offerInfos.length; i += 1) {
299 			if (offerInfos[i].token == token) {
300 				offerCount += 1;
301 			}
302 		}
303 		
304 		return offerCount;
305 	}
306 	
307 	// 주어진 토큰에 해당하는 판매 정보 ID 목록을 반환합니다.
308 	function getOfferIdsByToken(address token) view public returns (uint256[]) {
309 		
310 		uint256[] memory offerIds = new uint256[](getOfferCountByToken(token));
311 		
312 		for (uint256 i = 0; i < offerInfos.length; i += 1) {
313 			if (offerInfos[i].token == token) {
314 				offerIds[offerIds.length - 1] = i;
315 			}
316 		}
317 		
318 		return offerIds;
319 	}
320 }