1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title Ownable
5  * @dev 本可拥有合同业主地址，并提供基本的权限控制功能，简化了用户的权限执行”。
6  */
7 contract Ownable {
8   address public owner;
9 
10 
11   /**
12    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13    * account.
14    */
15   function Ownable() {
16     owner = msg.sender;
17   }
18 
19 
20   /**
21    * @dev Throws if called by any account other than the owner.
22    */
23   modifier onlyOwner() {
24     require(msg.sender == owner);
25     _;
26   }
27 
28 
29   /**
30    * @dev Allows the current owner to transfer control of the contract to a newOwner.
31    * @param newOwner The address to transfer ownership to.
32    */
33   function transferOwnership(address newOwner) onlyOwner {
34     if (newOwner != address(0)) {
35       owner = newOwner;
36     }
37   }
38 
39 }
40 
41 /**
42  * @title Destructible
43  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
44  */
45 contract Destructible is Ownable {
46 
47   function Destructible() payable { }
48 
49   /**
50    * @dev Transfers the current balance to the owner and terminates the contract.
51    */
52   function destroy() onlyOwner {
53     selfdestruct(owner);
54   }
55 
56   function destroyAndSend(address _recipient) onlyOwner {
57     selfdestruct(_recipient);
58   }
59 }
60 /**
61  * @title SafeMath
62  * @dev Math operations with safety checks that throw on error
63  */
64 library SafeMath {
65   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
66     uint256 c = a * b;
67     assert(a == 0 || c / a == b);
68     return c;
69   }
70 
71   function div(uint256 a, uint256 b) internal constant returns (uint256) {
72     // assert(b > 0); // Solidity automatically throws when dividing by 0
73     uint256 c = a / b;
74     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
75     return c;
76   }
77 
78   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   function add(uint256 a, uint256 b) internal constant returns (uint256) {
84     uint256 c = a + b;
85     assert(c >= a);
86     return c;
87   }
88 }
89 /**
90  * @title PullPayment
91  * @dev Base contract supporting async send for pull payments. Inherit from this
92  * contract and use asyncSend instead of send.
93  */
94 contract PullPayment {
95   using SafeMath for uint256;
96 
97   mapping(address => uint256) public payments;
98   uint256 public totalPayments;
99 
100   /**
101   * @dev Called by the payer to store the sent amount as credit to be pulled.
102   * @param dest The destination address of the funds.
103   * @param amount The amount to transfer.
104   */
105   function asyncSend(address dest, uint256 amount) internal {
106     payments[dest] = payments[dest].add(amount);
107     totalPayments = totalPayments.add(amount);
108   }
109 
110   /**
111   * @dev withdraw accumulated balance, called by payee.
112   */
113   function withdrawPayments() {
114     address payee = msg.sender;
115     uint256 payment = payments[payee];
116 
117     require(payment != 0);
118     require(this.balance >= payment);
119 
120     totalPayments = totalPayments.sub(payment);
121     payments[payee] = 0;
122 
123     assert(payee.send(payment));
124   }
125 }
126 
127 contract Generatable{
128     function generate(
129         address token,
130         address contractOwner,
131         uint256 cycle
132     ) public returns(address);
133 }
134 
135 /**
136  * @title ERC20 interface
137  * @dev see https://github.com/ethereum/EIPs/issues/20
138  */
139 contract ERC20 {
140   function decimals() public view returns (uint8);  //代币单位
141   function totalSupply() public view returns (uint256);
142 
143   function balanceOf(address _who) public view returns (uint256);
144 
145   function allowance(address _owner, address _spender)
146     public view returns (uint256);
147 
148   function transfer(address _to, uint256 _value) public returns (bool);
149 
150   function approve(address _spender, uint256 _value)
151     public returns (bool);
152 
153   function transferFrom(address _from, address _to, uint256 _value)
154     public returns (bool);
155 
156   event Transfer(
157     address indexed from,
158     address indexed to,
159     uint256 value
160   );
161 
162   event Approval(
163     address indexed owner,
164     address indexed spender,
165     uint256 value
166   );
167 }
168 /**
169  * @title SafeERC20
170  * @dev Wrappers around ERC20 operations that throw on failure.
171  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
172  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
173  */
174 library SafeERC20 {
175   function safeTransfer(
176     ERC20 _token,
177     address _to,
178     uint256 _value
179   )
180     internal
181   {
182     require(_token.transfer(_to, _value));
183   }
184 
185   function safeTransferFrom(
186     ERC20 _token,
187     address _from,
188     address _to,
189     uint256 _value
190   )
191     internal
192   {
193     require(_token.transferFrom(_from, _to, _value));
194   }
195 
196   function safeApprove(
197     ERC20 _token,
198     address _spender,
199     uint256 _value
200   )
201     internal
202   {
203     require(_token.approve(_spender, _value));
204   }
205 }
206 
207 
208 contract ContractFactory is Destructible,PullPayment{
209     using SafeERC20 for ERC20;
210     uint256 public diviRate;
211     uint256 public developerTemplateAmountLimit;
212     address public platformWithdrawAccount;
213 
214 
215 	struct userContract{
216 		uint256 templateId;
217 		uint256 orderid;
218 		address contractAddress;
219 		uint256 incomeDistribution;
220 		uint256 creattime;
221 		uint256 endtime;
222 	}
223 
224 	struct contractTemplate{
225 		string templateName;
226 		address contractGeneratorAddress;
227 		string abiStr;
228 		uint256 startTime;
229 		uint256 endTime;
230 		uint256 startUp;
231 		uint256 profit;
232 		uint256 quota;
233 		uint256 cycle;
234 		address token;
235 	}
236 
237     mapping(address => userContract[]) public userContractsMap;
238     mapping(uint256 => contractTemplate) public contractTemplateAddresses;
239     mapping(uint256 => uint256) public skipMap;
240 
241     event ContractCreated(address indexed creator,uint256 templateId,uint256 orderid,address contractAddress);
242     event ContractTemplatePublished(uint256 indexed templateId,address  creator,string templateName,address contractGeneratorAddress);
243     event Log(address data);
244     event yeLog(uint256 balanceof);
245     function ContractFactory(){
246         //0~10
247         diviRate=5;
248         platformWithdrawAccount=0xc645eadc9188cb0bad4e603f78ff171dabc1b18b;
249         developerTemplateAmountLimit=500000000000000000;
250     }
251 
252     function generateContract(uint256 templateId,uint256 orderid) public returns(address){
253 
254         //根据支付金额找到相应模板
255         contractTemplate storage ct = contractTemplateAddresses[templateId];
256         if(ct.contractGeneratorAddress!=0x0){
257             address contractTemplateAddress = ct.contractGeneratorAddress;
258             string templateName = ct.templateName;
259             require(block.timestamp >= ct.startTime);
260             require(block.timestamp <= ct.endTime);
261             //找到相应生成器并生产目标合约
262             Generatable generator = Generatable(contractTemplateAddress);
263             address target = generator.generate(ct.token,msg.sender,ct.cycle);
264             //记录用户合约
265             userContract[] storage userContracts = userContractsMap[msg.sender];
266             userContracts.push(userContract(templateId,orderid,target,1,now,now.add(uint256(1 days))));
267             ContractCreated(msg.sender,templateId,orderid,target);
268             return target;
269         }else{
270             revert();
271         }
272     }
273 
274     function returnOfIncome(address user,uint256 _index) public{
275         require(msg.sender == user);
276         userContract[] storage ucs = userContractsMap[user];
277         if(ucs[_index].contractAddress!=0x0 && ucs[_index].incomeDistribution == 1){
278             contractTemplate storage ct = contractTemplateAddresses[ucs[_index].templateId];
279             if(ct.contractGeneratorAddress!=0x0){
280                 //如果大于激活时间1天将不能分红
281                 if(now > ucs[_index].creattime.add(uint256(1 days))){
282                      revert();
283                 }
284 
285                 ERC20 token = ERC20(ct.token);
286                 uint256 balanceof = token.balanceOf(ucs[_index].contractAddress);
287 
288                uint8 decimals = token.decimals();
289                 //需要大于起投价
290                 if(balanceof < ct.startUp) revert();
291                 //大于限额的按限额上线计算收益
292                 uint256 investment = 0;
293                 if(balanceof > ct.quota.mul(10**decimals)){
294                     investment = ct.quota.mul(10**decimals);
295                 } else {
296                     investment = balanceof;
297                 }
298 
299                 //需要转给子合约的收益
300                 uint256 income = ct.profit.mul(ct.cycle).mul(investment).div(36000);
301 
302 
303                 if(!token.transfer(ucs[_index].contractAddress,income)){
304         			revert();
305         		} else {
306         		    ucs[_index].incomeDistribution = 2;
307         		}
308             }else{
309                 revert();
310             }
311         }else{
312             revert();
313         }
314     }
315 
316     /**
317     *生成器实现Generatable接口,并且合约实现了ownerable接口，都可以通过此函数上传（TODO：如何校验？）
318     * @param templateId   模版Id
319     * @param _templateName   模版名称
320     * @param _contractGeneratorAddress   模版名称模版名称莫
321     * @param _abiStr   abi接口
322     * @param _startTime  开始时间
323     * @param _endTime   结束时间
324     * @param _profit  收益
325     * @param _startUp 起投
326     * @param _quota   限额
327     * @param _cycle   周期
328     * @param _token   代币合约
329     */
330     function publishContractTemplate(
331         uint256 templateId,
332         string _templateName,
333         address _contractGeneratorAddress,
334         string _abiStr,
335         uint256 _startTime,
336         uint256 _endTime,
337         uint256 _profit,
338         uint256 _startUp,
339         uint256 _quota,
340         uint256 _cycle,
341         address _token
342     )
343         public
344     {
345          //非owner，不允许发布模板
346          if(msg.sender!=owner){
347             revert();
348          }
349 
350          contractTemplate storage ct = contractTemplateAddresses[templateId];
351          if(ct.contractGeneratorAddress!=0x0){
352             revert();
353          }else{
354 
355             ct.templateName = _templateName;
356             ct.contractGeneratorAddress = _contractGeneratorAddress;
357             ct.abiStr = _abiStr;
358             ct.startTime = _startTime;
359             ct.endTime = _endTime;
360             ct.startUp = _startUp;
361             ct.profit = _profit;
362             ct.quota = _quota;
363             ct.cycle = _cycle;
364             ct.token = _token;
365             ContractTemplatePublished(templateId,msg.sender,_templateName,_contractGeneratorAddress);
366          }
367     }
368 
369     function queryPublishedContractTemplate(
370         uint256 templateId
371     )
372         public
373         constant
374     returns(
375         string,
376         address,
377         string,
378         uint256,
379         uint256,
380         uint256,
381         uint256,
382         uint256,
383         uint256,
384         address
385     ) {
386         contractTemplate storage ct = contractTemplateAddresses[templateId];
387         if(ct.contractGeneratorAddress!=0x0){
388             return (
389                 ct.templateName,
390                 ct.contractGeneratorAddress,
391                 ct.abiStr,
392                 ct.startTime,
393                 ct.endTime,
394                 ct.profit,
395                 ct.startUp,
396                 ct.quota,
397                 ct.cycle,
398                 ct.token
399             );
400         }else{
401             return ('',0x0,'',0,0,0,0,0,0,0x0);
402         }
403     }
404 
405 
406     function queryUserContract(address user,uint256 _index) public constant returns(
407         uint256,
408         uint256,
409         address,
410         uint256,
411         uint256,
412         uint256
413     ){
414         require(msg.sender == user);
415         userContract[] storage ucs = userContractsMap[user];
416         contractTemplate storage ct = contractTemplateAddresses[ucs[_index].templateId];
417         ERC20 tokens = ERC20(ct.token);
418         uint256 balanceofs = tokens.balanceOf(ucs[_index].contractAddress);
419         return (
420             ucs[_index].templateId,
421             ucs[_index].orderid,
422             ucs[_index].contractAddress,
423             ucs[_index].incomeDistribution,
424             ucs[_index].endtime,
425             balanceofs
426         );
427     }
428 
429     function queryUserContractCount(address user) public constant returns (uint256){
430         require(msg.sender == user);
431         userContract[] storage ucs = userContractsMap[user];
432         return ucs.length;
433     }
434 
435     function changeDiviRate(uint256 _diviRate) external onlyOwner(){
436         diviRate=_diviRate;
437     }
438 
439     function changePlatformWithdrawAccount(address _platformWithdrawAccount) external onlyOwner(){
440         platformWithdrawAccount=_platformWithdrawAccount;
441     }
442 
443     function changeDeveloperTemplateAmountLimit(uint256 _developerTemplateAmountLimit) external onlyOwner(){
444         developerTemplateAmountLimit=_developerTemplateAmountLimit;
445     }
446     function addSkipPrice(uint256 price) external onlyOwner(){
447         skipMap[price]=1;
448     }
449 
450     function removeSkipPrice(uint256 price) external onlyOwner(){
451         skipMap[price]=0;
452     }
453 }