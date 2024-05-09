1 pragma solidity ^0.4.21;
2 
3 
4 contract ERC20Basic {
5   function totalSupply() public view returns (uint256);
6   function balanceOf(address who) public view returns (uint256);
7   function transfer(address to, uint256 value) public returns (bool);
8   event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 
12 library SafeMath {
13 
14   
15   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16     if (a == 0) {
17       return 0;
18     }
19     c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26    
27    
28    
29     return a / b;
30   }
31 
32   
33   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   
39   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
40     c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 
47 contract BasicToken is ERC20Basic {
48   using SafeMath for uint256;
49 
50   mapping(address => uint256) balances;
51 
52   uint256 totalSupply_;
53 
54   
55   function totalSupply() public view returns (uint256) {
56     return totalSupply_;
57   }
58 
59   
60   function transfer(address _to, uint256 _value) public returns (bool) {
61     require(_to != address(0));
62     require(_value <= balances[msg.sender]);
63 
64     balances[msg.sender] = balances[msg.sender].sub(_value);
65     balances[_to] = balances[_to].add(_value);
66     emit Transfer(msg.sender, _to, _value);
67     return true;
68   }
69 
70   
71   function balanceOf(address _owner) public view returns (uint256) {
72     return balances[_owner];
73   }
74 
75 }
76 
77 
78 contract ERC20 is ERC20Basic {
79   function allowance(address owner, address spender) public view returns (uint256);
80   function transferFrom(address from, address to, uint256 value) public returns (bool);
81   function approve(address spender, uint256 value) public returns (bool);
82   event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 
86 contract StandardToken is ERC20, BasicToken {
87 
88   mapping (address => mapping (address => uint256)) internal allowed;
89 
90 
91   
92   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
93     require(_to != address(0));
94     require(_value <= balances[_from]);
95     require(_value <= allowed[_from][msg.sender]);
96 
97     balances[_from] = balances[_from].sub(_value);
98     balances[_to] = balances[_to].add(_value);
99     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
100     emit Transfer(_from, _to, _value);
101     return true;
102   }
103 
104   
105   function approve(address _spender, uint256 _value) public returns (bool) {
106     allowed[msg.sender][_spender] = _value;
107     emit Approval(msg.sender, _spender, _value);
108     return true;
109   }
110 
111   
112   function allowance(address _owner, address _spender) public view returns (uint256) {
113     return allowed[_owner][_spender];
114   }
115 
116   
117   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
118     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
119     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
120     return true;
121   }
122 
123   
124   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
125     uint oldValue = allowed[msg.sender][_spender];
126     if (_subtractedValue > oldValue) {
127       allowed[msg.sender][_spender] = 0;
128     } else {
129       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
130     }
131     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
132     return true;
133   }
134 
135 }
136 
137 
138 contract Ownable {
139   address public owner;
140 
141 
142   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
143 
144 
145   
146   function Ownable() public {
147     owner = msg.sender;
148   }
149 
150   
151   modifier onlyOwner() {
152     require(msg.sender == owner);
153     _;
154   }
155 
156   
157   function transferOwnership(address newOwner) public onlyOwner {
158     require(newOwner != address(0));
159     emit OwnershipTransferred(owner, newOwner);
160     owner = newOwner;
161   }
162 
163 }
164 
165 
166 contract BurnableToken is BasicToken {
167 
168   event Burn(address indexed burner, uint256 value);
169 
170   
171   function burn(uint256 _value) public {
172     _burn(msg.sender, _value);
173   }
174 
175   function _burn(address _who, uint256 _value) internal {
176     require(_value <= balances[_who]);
177    
178    
179 
180     balances[_who] = balances[_who].sub(_value);
181     totalSupply_ = totalSupply_.sub(_value);
182     emit Burn(_who, _value);
183     emit Transfer(_who, address(0), _value);
184   }
185 }
186 
187 
188 contract TokenOffering is StandardToken, Ownable, BurnableToken {
189   
190     bool public offeringEnabled;
191 
192    
193     uint256 public currentTotalTokenOffering;
194 
195    
196     uint256 public currentTokenOfferingRaised;
197 
198    
199     uint256 public bonusRateOneEth;
200 
201    
202     uint256 public startTime;
203     uint256 public endTime;
204 
205     bool public isBurnInClose = false;
206 
207     bool public isOfferingStarted = false;
208 
209     event OfferingOpens(uint256 startTime, uint256 endTime, uint256 totalTokenOffering, uint256 bonusRateOneEth);
210     event OfferingCloses(uint256 endTime, uint256 tokenOfferingRaised);
211 
212     
213     function setBonusRate(uint256 _bonusRateOneEth) public onlyOwner {
214         bonusRateOneEth = _bonusRateOneEth;
215     }
216 
217     
218    
219    
220    
221    
222 
223     
224     function preValidatePurchase(uint256 _amount) internal {
225         require(_amount > 0);
226         require(isOfferingStarted);
227         require(offeringEnabled);
228         require(currentTokenOfferingRaised.add(_amount) <= currentTotalTokenOffering);
229         require(block.timestamp >= startTime && block.timestamp <= endTime);
230     }
231     
232     
233     function stopOffering() public onlyOwner {
234         offeringEnabled = false;
235     }
236     
237     
238     function resumeOffering() public onlyOwner {
239         offeringEnabled = true;
240     }
241 
242     
243     function startOffering(
244         uint256 _tokenOffering, 
245         uint256 _bonusRateOneEth, 
246         uint256 _startTime, 
247         uint256 _endTime,
248         bool _isBurnInClose
249     ) public onlyOwner returns (bool) {
250         require(_tokenOffering <= balances[owner]);
251         require(_startTime <= _endTime);
252         require(_startTime >= block.timestamp);
253 
254        
255         require(!isOfferingStarted);
256 
257         isOfferingStarted = true;
258 
259        
260         startTime = _startTime;
261         endTime = _endTime;
262 
263        
264         isBurnInClose = _isBurnInClose;
265 
266        
267         currentTokenOfferingRaised = 0;
268         currentTotalTokenOffering = _tokenOffering;
269         offeringEnabled = true;
270         setBonusRate(_bonusRateOneEth);
271 
272         emit OfferingOpens(startTime, endTime, currentTotalTokenOffering, bonusRateOneEth);
273         return true;
274     }
275 
276     
277     function updateStartTime(uint256 _startTime) public onlyOwner {
278         require(isOfferingStarted);
279         require(_startTime <= endTime);
280         require(_startTime >= block.timestamp);
281         startTime = _startTime;
282     }
283 
284     
285     function updateEndTime(uint256 _endTime) public onlyOwner {
286         require(isOfferingStarted);
287         require(_endTime >= startTime);
288         endTime = _endTime;
289     }
290 
291     
292     function updateBurnableStatus(bool _isBurnInClose) public onlyOwner {
293         require(isOfferingStarted);
294         isBurnInClose = _isBurnInClose;
295     }
296 
297     
298     function endOffering() public onlyOwner {
299         if (isBurnInClose) {
300             burnRemainTokenOffering();
301         }
302         emit OfferingCloses(endTime, currentTokenOfferingRaised);
303         resetOfferingStatus();
304     }
305 
306     
307     function burnRemainTokenOffering() internal {
308         if (currentTokenOfferingRaised < currentTotalTokenOffering) {
309             uint256 remainTokenOffering = currentTotalTokenOffering.sub(currentTokenOfferingRaised);
310             _burn(owner, remainTokenOffering);
311         }
312     }
313 
314     
315     function resetOfferingStatus() internal {
316         isOfferingStarted = false;        
317         startTime = 0;
318         endTime = 0;
319         currentTotalTokenOffering = 0;
320         currentTokenOfferingRaised = 0;
321         bonusRateOneEth = 0;
322         offeringEnabled = false;
323         isBurnInClose = false;
324     }
325 }
326 
327 
328 
329 
330 
331 contract WithdrawTrack is StandardToken, Ownable {
332 
333 	struct TrackInfo {
334 		address to;
335 		uint256 amountToken;
336 		string withdrawId;
337 	}
338 
339 	mapping(string => TrackInfo) withdrawTracks;
340 
341 	function withdrawToken(address _to, uint256 _amountToken, string _withdrawId) public onlyOwner returns (bool) {
342 		bool result = transfer(_to, _amountToken);
343 		if (result) {
344 			withdrawTracks[_withdrawId] = TrackInfo(_to, _amountToken, _withdrawId);
345 		}
346 		return result;
347 	}
348 
349 	function withdrawTrackOf(string _withdrawId) public view returns (address to, uint256 amountToken) {
350 		TrackInfo track = withdrawTracks[_withdrawId];
351 		return (track.to, track.amountToken);
352 	}
353 
354 }
355 
356 
357 contract ContractSpendToken is StandardToken, Ownable {
358   mapping (address => address) private contractToReceiver;
359 
360   function addContract(address _contractAdd, address _to) external onlyOwner returns (bool) {
361     require(_contractAdd != address(0x0));
362     require(_to != address(0x0));
363 
364     contractToReceiver[_contractAdd] = _to;
365     return true;
366   }
367 
368   function removeContract(address _contractAdd) external onlyOwner returns (bool) {
369     contractToReceiver[_contractAdd] = address(0x0);
370     return true;
371   }
372 
373   function contractSpend(address _from, uint256 _value) public returns (bool) {
374     address _to = contractToReceiver[msg.sender];
375     require(_to != address(0x0));
376     require(_value <= balances[_from]);
377 
378     balances[_from] = balances[_from].sub(_value);
379     balances[_to] = balances[_to].add(_value);
380     emit Transfer(_from, _to, _value);
381     return true;
382   }
383 
384   function getContractReceiver(address _contractAdd) public view onlyOwner returns (address) {
385     return contractToReceiver[_contractAdd];
386   }
387 }
388 
389 contract ContractiumToken is TokenOffering, WithdrawTrack, ContractSpendToken {
390 
391     string public constant name = "Contractium";
392     string public constant symbol = "CTU";
393     uint8 public constant decimals = 18;
394   
395     uint256 public constant INITIAL_SUPPLY = 3000000000 * (10 ** uint256(decimals));
396   
397     uint256 public unitsOneEthCanBuy = 15000;
398 
399    
400     uint256 internal totalWeiRaised;
401 
402     event BuyToken(address from, uint256 weiAmount, uint256 tokenAmount);
403 
404     function ContractiumToken() public {
405         totalSupply_ = INITIAL_SUPPLY;
406         balances[msg.sender] = INITIAL_SUPPLY;
407         
408         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
409     }
410 
411     function() public payable {
412 
413         require(msg.sender != owner);
414 
415        
416         uint256 amount = msg.value.mul(unitsOneEthCanBuy);
417 
418        
419         uint256 amountBonus = msg.value.mul(bonusRateOneEth);
420         
421        
422         amount = amount.add(amountBonus);
423 
424        
425         preValidatePurchase(amount);
426         require(balances[owner] >= amount);
427         
428         totalWeiRaised = totalWeiRaised.add(msg.value);
429     
430        
431         currentTokenOfferingRaised = currentTokenOfferingRaised.add(amount); 
432         
433         balances[owner] = balances[owner].sub(amount);
434         balances[msg.sender] = balances[msg.sender].add(amount);
435 
436         emit Transfer(owner, msg.sender, amount);
437         emit BuyToken(msg.sender, msg.value, amount);
438        
439         owner.transfer(msg.value);  
440                               
441     }
442 
443     function batchTransfer(address[] _receivers, uint256[] _amounts) public returns(bool) {
444         uint256 cnt = _receivers.length;
445         require(cnt > 0 && cnt <= 20);
446         require(cnt == _amounts.length);
447 
448         cnt = (uint8)(cnt);
449 
450         uint256 totalAmount = 0;
451         for (uint8 i = 0; i < cnt; i++) {
452             totalAmount = totalAmount.add(_amounts[i]);
453         }
454 
455         require(totalAmount <= balances[msg.sender]);
456 
457         balances[msg.sender] = balances[msg.sender].sub(totalAmount);
458         for (i = 0; i < cnt; i++) {
459             balances[_receivers[i]] = balances[_receivers[i]].add(_amounts[i]);            
460             emit Transfer(msg.sender, _receivers[i], _amounts[i]);
461         }
462 
463         return true;
464     }
465 
466 
467 }