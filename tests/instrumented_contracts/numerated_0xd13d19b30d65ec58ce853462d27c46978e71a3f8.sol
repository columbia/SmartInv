1 pragma solidity ^0.4.24;
2 
3 
4 contract BrickAccessControl {
5 
6     constructor() public {
7         admin = msg.sender;
8         nodeToId[admin] = 1;
9     }
10 
11     address public admin;
12     address[] public nodes;
13     mapping (address => uint) nodeToId;
14 
15     modifier onlyAdmin() {
16         require(msg.sender == admin, "Not authorized admin");
17         _;
18     }
19 
20     modifier onlyNode() {
21         require(nodeToId[msg.sender] != 0, "Not authorized node");
22         _;
23     }
24 
25     function setAdmin(address _newAdmin) public onlyAdmin {
26         require(_newAdmin != address(0));
27 
28         admin = _newAdmin;
29     }
30 
31     function getNodes() public view returns (address[]) {
32         return nodes;
33     }
34 
35     function addNode(address _newNode) public onlyAdmin {
36         require(_newNode != address(0), "Cannot set to empty address");
37 
38         nodeToId[_newNode] = nodes.push(_newNode);
39     }
40 
41     function removeNode(address _node) public onlyAdmin {
42         require(_node != address(0), "Cannot set to empty address");
43 
44         uint index = nodeToId[_node] - 1;
45         delete nodes[index];
46         delete nodeToId[_node];
47     }
48 
49 }
50 
51 contract BrickBase is BrickAccessControl {
52 
53     /**************
54        Events
55     ***************/
56 
57     // S201. 대출 계약 생성
58     event ContractCreated(bytes32 loanId);
59 
60     // S201. 대출중
61     event ContractStarted(bytes32 loanId);
62 
63     // S301. 상환 완료
64     event RedeemCompleted(bytes32 loanId);
65 
66     // S302. 청산 완료
67     event LiquidationCompleted(bytes32 loanId);
68 
69 
70     /**************
71        Data Types
72     ***************/
73 
74     struct Contract {
75         bytes32 loanId;         // 계약 번호
76         uint16 productId;       // 상품 번호
77         bytes8 coinName;        // 담보 코인 종류
78         uint256 coinAmount;     // 담보 코인양
79         uint32 coinUnitPrice;   // 1 코인당 금액
80         string collateralAddress;  // 담보 입금 암호화폐 주소
81         uint32 loanAmount;      // 대출원금
82         uint64 createAt;        // 계약일
83         uint64 openAt;          // 원화지급일(개시일)
84         uint64 expireAt;        // 만기일
85         bytes8 feeRate;         // 이자율
86         bytes8 overdueRate;     // 연체이자율
87         bytes8 liquidationRate; // 청산 조건(담보 청산비율)
88         uint32 prepaymentFee;   // 중도상환수수료
89         bytes32 extra;          // 기타 정보
90     }
91 
92     struct ClosedContract {
93         bytes32 loanId;         // 계약 번호
94         bytes8 status;          // 종료 타입(S301, S302)
95         uint256 returnAmount;   // 반환코인량(유저에게 돌려준 코인)
96         uint32 returnCash;      // 반환 현금(유저에게 돌려준 원화)
97         string returnAddress;   // 담보 반환 암호화폐 주소
98         uint32 feeAmount;       // 총이자(이자 + 연체이자 + 운영수수료 + 조기상환수수료)
99         uint32 evalUnitPrice;   // 청산시점 평가금액(1 코인당 금액)
100         uint64 evalAt;          // 청산시점 평가일
101         uint64 closeAt;         // 종료일자
102         bytes32 extra;          // 기타 정보
103     }
104 
105 
106     /**************
107         Storage
108     ***************/
109 
110     // 계약 번호 => 대출 계약서
111     mapping (bytes32 => Contract) loanIdToContract;
112     // 계약 번호 => 종료된 대출 계약서
113     mapping (bytes32 => ClosedContract) loanIdToClosedContract;
114 
115     bytes32[] contracts;
116     bytes32[] closedContracts;
117 
118 }
119 
120 contract BrickInterface is BrickBase {
121 
122     function createContract(
123         bytes32 _loanId, uint16 _productId, bytes8 _coinName, uint256 _coinAmount, uint32 _coinUnitPrice,
124         string _collateralAddress, uint32 _loanAmount, uint64[] _times, bytes8[] _rates, uint32 _prepaymentFee, bytes32 _extra)
125         public;
126 
127     function closeContract(
128         bytes32 _loanId, bytes8 _status, uint256 _returnAmount, uint32 _returnCash, string _returnAddress,
129         uint32 _feeAmount, uint32 _evalUnitPrice, uint64 _evalAt, uint64 _closeAt, bytes32 _extra)
130         public;
131 
132     function getContract(bytes32 _loanId)
133         public
134         view
135         returns (
136         bytes32 loanId,
137         uint16 productId,
138         bytes8 coinName,
139         uint256 coinAmount,
140         uint32 coinUnitPrice,
141         string collateralAddress,
142         uint32 loanAmount,
143         uint32 prepaymentFee,
144         bytes32 extra);
145 
146     function getContractTimestamps(bytes32 _loanId)
147         public
148         view
149         returns (
150         bytes32 loanId,
151         uint64 createAt,
152         uint64 openAt,
153         uint64 expireAt);
154 
155     function getContractRates(bytes32 _loanId)
156         public
157         view
158         returns (
159         bytes32 loanId,
160         bytes8 feeRate,
161         bytes8 overdueRate,
162         bytes8 liquidationRate);
163 
164     function getClosedContract(bytes32 _loanId)
165         public
166         view
167         returns (
168         bytes32 loanId,
169         bytes8 status,
170         uint256 returnAmount,
171         uint32 returnCash,
172         string returnAddress,
173         uint32 feeAmount,
174         uint32 evalUnitPrice,
175         uint64 evalAt,
176         uint64 closeAt,
177         bytes32 extra);
178 
179     function totalContracts() public view returns (uint);
180 
181     function totalClosedContracts() public view returns (uint);
182 
183 }
184 
185 
186 
187 contract Brick is BrickInterface {
188 
189     /// @dev 대출 계약서 생성하기
190     /// @param _loanId 계약 번호
191     /// @param _productId 상품 번호
192     /// @param _coinName 담보 코인 종류
193     /// @param _coinAmount 담보 코인양
194     /// @param _coinUnitPrice 1 코인당 금액
195     /// @param _collateralAddress 담보 입금 암호화폐 주소
196     /// @param _loanAmount 대출원금
197     /// @param _times 계약 시간 정보[createAt, openAt, expireAt]
198     /// @param _rates 이자율[feeRate, overdueRate, liquidationRate]
199     /// @param _prepaymentFee 중도상환수수료
200     /// @param _extra 기타 정보
201     function createContract(
202         bytes32 _loanId, uint16 _productId, bytes8 _coinName, uint256 _coinAmount, uint32 _coinUnitPrice,
203         string _collateralAddress, uint32 _loanAmount, uint64[] _times, bytes8[] _rates, uint32 _prepaymentFee, bytes32 _extra)
204         public
205         onlyNode
206     {
207         require(loanIdToContract[_loanId].loanId == 0, "Already exists in Contract.");
208         require(loanIdToClosedContract[_loanId].loanId == 0, "Already exists in ClosedContract.");
209 
210         Contract memory _contract = Contract({
211             loanId: _loanId,
212             productId: _productId,
213             coinName: _coinName,
214             coinAmount: _coinAmount,
215             coinUnitPrice: _coinUnitPrice,
216             collateralAddress: _collateralAddress,
217             loanAmount: _loanAmount,
218             createAt: _times[0],
219             openAt: _times[1],
220             expireAt: _times[2],
221             feeRate: _rates[0],
222             overdueRate: _rates[1],
223             liquidationRate: _rates[2],
224             prepaymentFee: _prepaymentFee,
225             extra: _extra
226         });
227         loanIdToContract[_loanId] = _contract;
228         contracts.push(_loanId);
229 
230         emit ContractCreated(_loanId);
231     }
232 
233     /// @dev 대출 계약 종료하기
234     /// @param _loanId 계약 번호
235     /// @param _status 종료 타입(S301, S302)
236     /// @param _returnAmount 반환코인량(유저에게 돌려준 코인)
237     /// @param _returnCash 반환 현금(유저에게 돌려준 원화)
238     /// @param _returnAddress 담보 반환 암호화폐 주소
239     /// @param _feeAmount 총이자(이자 + 연체이자 + 운영수수료 + 조기상환수수료)
240     /// @param _evalUnitPrice 청산시점 평가금액(1 코인당 금액)
241     /// @param _evalAt 청산시점 평가일
242     /// @param _closeAt 종료일자
243     /// @param _extra 기타 정보
244     function closeContract(
245         bytes32 _loanId, bytes8 _status, uint256 _returnAmount, uint32 _returnCash, string _returnAddress,
246         uint32 _feeAmount, uint32 _evalUnitPrice, uint64 _evalAt, uint64 _closeAt, bytes32 _extra)
247         public
248         onlyNode
249     {
250         require(loanIdToContract[_loanId].loanId != 0, "Not exists in Contract.");
251         require(loanIdToClosedContract[_loanId].loanId == 0, "Already exists in ClosedContract.");
252 
253         ClosedContract memory closedContract = ClosedContract({
254             loanId: _loanId,
255             status: _status,
256             returnAmount: _returnAmount,
257             returnCash: _returnCash,
258             returnAddress: _returnAddress,
259             feeAmount: _feeAmount,
260             evalUnitPrice: _evalUnitPrice,
261             evalAt: _evalAt,
262             closeAt: _closeAt,
263             extra: _extra
264         });
265         loanIdToClosedContract[_loanId] = closedContract;
266         closedContracts.push(_loanId);
267 
268         if (_status == bytes16("S301")) {
269             emit RedeemCompleted(_loanId);
270         } else if (_status == bytes16("S302")) {
271             emit LiquidationCompleted(_loanId);
272         }
273     }
274 
275     /// @dev 진행중인 대출 계약서 조회하기
276     /// @param _loanId 계약 번호
277     /// @return The contract of given loanId
278     function getContract(bytes32 _loanId)
279         public
280         view
281         returns (
282         bytes32 loanId,
283         uint16 productId,
284         bytes8 coinName,
285         uint256 coinAmount,
286         uint32 coinUnitPrice,
287         string collateralAddress,
288         uint32 loanAmount,
289         uint32 prepaymentFee,
290         bytes32 extra)
291     {
292         require(loanIdToContract[_loanId].loanId != 0, "Not exists in Contract.");
293 
294         Contract storage c = loanIdToContract[_loanId];
295         loanId = c.loanId;
296         productId = uint16(c.productId);
297         coinName = c.coinName;
298         coinAmount = uint256(c.coinAmount);
299         coinUnitPrice = uint32(c.coinUnitPrice);
300         collateralAddress = c.collateralAddress;
301         loanAmount = uint32(c.loanAmount);
302         prepaymentFee = uint32(c.prepaymentFee);
303         extra = c.extra;
304     }
305 
306     function getContractTimestamps(bytes32 _loanId)
307         public
308         view
309         returns (
310         bytes32 loanId,
311         uint64 createAt,
312         uint64 openAt,
313         uint64 expireAt)
314     {
315         require(loanIdToContract[_loanId].loanId != 0, "Not exists in Contract.");
316 
317         Contract storage c = loanIdToContract[_loanId];
318         loanId = c.loanId;
319         createAt = uint64(c.createAt);
320         openAt = uint64(c.openAt);
321         expireAt = uint64(c.expireAt);
322     }
323 
324     function getContractRates(bytes32 _loanId)
325         public
326         view
327         returns (
328         bytes32 loanId,
329         bytes8 feeRate,
330         bytes8 overdueRate,
331         bytes8 liquidationRate)
332     {
333         require(loanIdToContract[_loanId].loanId != 0, "Not exists in Contract.");
334 
335         Contract storage c = loanIdToContract[_loanId];
336         loanId = c.loanId;
337         feeRate = c.feeRate;
338         overdueRate = c.overdueRate;
339         liquidationRate = c.liquidationRate;
340     }
341 
342     /// @dev 종료된 대출 계약서 조회하기
343     /// @param _loanId 계약 번호
344     /// @return The closed contract of given loanId
345     function getClosedContract(bytes32 _loanId)
346         public
347         view
348         returns (
349         bytes32 loanId,
350         bytes8 status,
351         uint256 returnAmount,
352         uint32 returnCash,
353         string returnAddress,
354         uint32 feeAmount,
355         uint32 evalUnitPrice,
356         uint64 evalAt,
357         uint64 closeAt,
358         bytes32 extra)
359     {
360         require(loanIdToClosedContract[_loanId].loanId != 0, "Not exists in ClosedContract.");
361 
362         ClosedContract storage c = loanIdToClosedContract[_loanId];
363 
364         loanId = c.loanId;
365         status = c.status;
366         returnAmount = uint256(c.returnAmount);
367         returnCash = uint32(c.returnCash);
368         returnAddress = c.returnAddress;
369         feeAmount = uint32(c.feeAmount);
370         evalUnitPrice = uint32(c.evalUnitPrice);
371         evalAt = uint64(c.evalAt);
372         closeAt = uint64(c.closeAt);
373         extra = c.extra;
374     }
375 
376     function totalContracts() public view returns (uint) {
377         return contracts.length;
378     }
379 
380     function totalClosedContracts() public view returns (uint) {
381         return closedContracts.length;
382     }
383 
384 }