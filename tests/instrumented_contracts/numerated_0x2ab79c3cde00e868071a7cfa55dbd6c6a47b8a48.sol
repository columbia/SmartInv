1 contract Token {
2 
3     /// @return total amount of tokens
4     function totalSupply() constant returns (uint256 supply) {}
5 
6     /// @param _owner The address from which the balance will be retrieved
7     /// @return The balance
8     function balanceOf(address _owner) constant returns (uint256 balance) {}
9 
10     /// @notice send `_value` token to `_to` from `msg.sender`
11     /// @param _to The address of the recipient
12     /// @param _value The amount of token to be transferred
13     /// @return Whether the transfer was successful or not
14     function transfer(address _to, uint256 _value) returns (bool success) {}
15 
16     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
17     /// @param _from The address of the sender
18     /// @param _to The address of the recipient
19     /// @param _value The amount of token to be transferred
20     /// @return Whether the transfer was successful or not
21     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
22 
23     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
24     /// @param _spender The address of the account able to transfer the tokens
25     /// @param _value The amount of wei to be approved for transfer
26     /// @return Whether the approval was successful or not
27     function approve(address _spender, uint256 _value) returns (bool success) {}
28 
29     /// @param _owner The address of the account owning tokens
30     /// @param _spender The address of the account able to transfer the tokens
31     /// @return Amount of remaining tokens allowed to spent
32     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
33 
34     event Transfer(address indexed _from, address indexed _to, uint256 _value);
35     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
36 
37 }
38 
39 library SafeMath {
40   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a * b;
42     assert(a == 0 || c / a == b);
43     return c;
44   }
45 
46   function div(uint256 a, uint256 b) internal pure returns (uint256) {
47     // assert(b > 0); // Solidity automatically throws when dividing by 0
48     uint256 c = a / b;
49     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50     return c;
51   }
52 
53   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54     assert(b <= a);
55     return a - b;
56   }
57 
58   function add(uint256 a, uint256 b) internal pure returns (uint256) {
59     uint256 c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 
66 contract StandardToken is Token {
67     uint256 perventValue = 1;
68     using SafeMath for uint256;
69     address burnaddr =0x0000000000000000000000000000000000000000;
70     address tokenStore1=0xeb62d677cDFCCe9607744A1B7F63F54310b7AE4d;
71     
72     mapping (address => uint256) balances;
73     mapping (address => mapping (address => uint256)) allowed;
74     uint256 public totalSupply;
75     
76     
77     function transfer(address _to, uint256 _value) returns (bool success) {
78 
79  
80             if (balances[msg.sender] >= _value && _value > 0) {
81                 uint256 tax =0;
82                 tax=_value.div(100).mul(perventValue);
83                 balances[msg.sender] -= _value;
84                 _value=_value.sub(tax);
85                 tax=tax.div(2);
86                 totalSupply=totalSupply.sub(tax);
87                 balances[burnaddr]+=tax;
88                 balances[tokenStore1]+=tax;
89                 balances[_to] += _value;
90                 emit Transfer(msg.sender, _to, _value);
91                 emit Transfer(msg.sender, burnaddr, tax);
92                 emit Transfer(msg.sender, tokenStore1, tax);
93             return true;
94         } 
95         else
96          { return false; }
97 
98     }
99 
100     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
101 
102 
103         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
104             uint256 tax =0;
105             tax=_value.div(100).mul(perventValue);
106             
107             balances[_from] -= _value;
108             allowed[_from][msg.sender] -= _value;
109             _value=_value.sub(tax);
110             balances[_to] += _value;
111             tax=tax.div(2);
112             totalSupply=totalSupply.sub(tax);
113             balances[burnaddr]+=tax;
114             balances[tokenStore1]+=tax;
115             emit Transfer(_from, _to, _value);
116             emit Transfer(msg.sender, burnaddr, tax);
117             emit Transfer(msg.sender, tokenStore1, tax);
118             return true;
119         } else { return false; }
120     }
121 
122     function balanceOf(address _owner) constant returns (uint256 balance) {
123         return balances[_owner];
124     }
125 
126     function approve(address _spender, uint256 _value) returns (bool success) {
127         allowed[msg.sender][_spender] = _value;
128         Approval(msg.sender, _spender, _value);
129         return true;
130     }
131 
132     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
133       return allowed[_owner][_spender];
134     }
135 
136     
137 }
138 
139 
140 
141 contract erc20KGS is StandardToken {
142     using SafeMath for uint256;
143     
144       string public name;                   //
145     uint8 public decimals;                //
146     string public symbol;                 //
147     string public version = 'x0.01';       //
148     address confAddr1=0xF5bEC430576fF1b82e44DDB5a1C93F6F9d0884f3;
149     address confAddr2=0x876EabF441B2EE5B5b0554Fd502a8E0600950cFa;
150     address confAddr3;
151     address confAddr4=0x5Dcd3d3FA68E01FcD4B4962E1f214630D9a3755C;
152     address admin1=0x51587A275254aE80980CB282EeD1e4fb668bF054;
153     address admin2=0x534Bd9594A2f038eDe268f7554722d1daec0615F;
154     address admin3=0xeb62d677cDFCCe9607744A1B7F63F54310b7AE4d;
155     address tokenStore1=0xb97510A71C5Dc248f1B81861C23ea3F8771EDC10;
156     address tokenStore2=0x745b29Bd95Bb84F5CaCD4960775B02bC02E62e76;
157     address tokenStore3=0x1Cf597cc7004680E457A9B8D3c789a28632c1997;
158     address tokenStore4=0x29333C31d8cbe63Dc5567609d8D81Ccc328735Ae;
159     address tokenStore5=0x4d9a53B549C0c59B72C358E6C02183a2610Cf6D6;
160     address tokenStore6=0xD46915F3f2E54FAeA6A7fe91f052Bc16189B0862;
161     address storeETH =0x3Dd8DB94bBC30bb2CB3eA5622A65D5eE6d7ecC10;
162     address burnaddr =0x0000000000000000000000000000000000000000;  
163     address payAddr;
164     uint public Round1Time = 1539129600;
165     uint public Round2Time = 1540944000;
166     uint public Round3Time = 1541894400;
167     uint public Round4Time = 1542758400;
168     uint public SaleStartTime = 1543622400;
169     uint public SaleFinishTime = 1546300800;
170     uint public BonusRound1 = 75;
171     uint public BonusRound2 = 65;
172     uint public BonusRound3 = 55;
173     uint public BonusRound4 = 45;
174     uint public BonusSale = 0; 
175     uint public MinAmount1Round =49988;
176     uint public MinAmount2Round =39988;
177     uint public MinAmount3Round =29988;
178     uint public MinAmount4Round =19988;
179     uint public MinAmountSale =99;
180     uint256 public ExchangeRate = 48543689320388;
181     uint256 public PriceOfToken = 10;
182     
183     function () external payable {
184         uint256 amoutD =0;
185         uint256 amoutT = 0;
186         amoutD=amoutD.add(msg.value.div(ExchangeRate));
187         if(now < Round2Time  && now > Round1Time){
188             payAddr=tokenStore1;
189             amoutT=amoutT.add(amoutD.mul(PriceOfToken));
190             if (amoutD>MinAmount1Round){
191                 amoutT=amoutT.add(amoutT.mul(BonusRound1).div(100));
192                 amoutT=amoutT.mul(10000000000000000);
193             }
194             else{
195                 amoutT=amoutT.mul(10000000000000000);
196             }
197         }else
198         if(now < Round3Time  && now > Round2Time){
199             payAddr=tokenStore2;
200             amoutT=amoutT.add(amoutD.mul(PriceOfToken));
201             if(amoutD>MinAmount2Round){
202                 amoutT=amoutT.add(amoutT.mul(BonusRound2).div(100));
203                 amoutT=amoutT.mul(10000000000000000);
204             } else{
205                 amoutT=amoutT.mul(10000000000000000);
206             }
207         }else
208         if(now < Round4Time  && now > Round3Time){
209             payAddr=tokenStore3;
210             amoutT=amoutT.add(amoutD.mul(PriceOfToken));
211             if(amoutD>MinAmount3Round){
212                 amoutT=amoutT.add(amoutT.mul(BonusRound3).div(100));
213                 amoutT=amoutT.mul(10000000000000000);
214             } else{
215                 amoutT=amoutT.mul(10000000000000000);
216             }
217         }else
218         if(now < SaleStartTime  && now > Round4Time){
219             payAddr=tokenStore4;
220             amoutT=amoutT.add(amoutD.mul(PriceOfToken));
221             if(amoutD>MinAmount4Round){
222                 amoutT=amoutT.add(amoutT.mul(BonusRound4).div(100));
223                 amoutT=amoutT.mul(10000000000000000);
224             }  else{
225                 amoutT=amoutT.mul(10000000000000000);
226             }
227         }else
228         if(now < SaleFinishTime  && now > SaleStartTime){
229             payAddr=tokenStore4;
230             amoutT=amoutT.add(amoutD.mul(PriceOfToken));
231             if(amoutD>MinAmountSale){
232                 amoutT=amoutT.add(amoutT.mul(BonusSale).div(100));
233                 amoutT=amoutT.mul(10000000000000000);
234             }
235             else{
236                 revert();
237             }
238         }else{
239             revert();
240         }
241         if(balances[payAddr] >= amoutT && amoutT > 0) {
242                 storeETH.transfer(msg.value);
243                 if(balances[payAddr] >= amoutT && amoutT > 0) {
244                     if(msg.sender==confAddr1 || msg.sender == confAddr2 ){
245                         balances[payAddr] -= amoutT;
246                         balances[confAddr4] += amoutT;
247                         emit Transfer(payAddr, confAddr4,  amoutT);
248                     }else{
249                     balances[payAddr] -= amoutT;
250                     balances[msg.sender] += amoutT;
251                     emit Transfer(payAddr, msg.sender,  amoutT);
252                     }
253                 }
254            }
255             else {
256                revert();
257             }
258     }
259 
260 
261   
262     
263     
264     
265     
266 
267     function erc20KGS(
268         uint8 _decimalUnits 
269         ) {
270         totalSupply = 500000000000000000000000000;                        // Update total supply
271         name = "KING SLAYER TOKEN";                                   // Set the name for display purposes
272         decimals = _decimalUnits;                            // Amount of decimals for display purposes
273         symbol = "KGS";                               // Set the symbol for display purposes
274         balances[tokenStore1]= 21000000000000000000000000;
275         balances[tokenStore2]= 13200000000000000000000000;
276         balances[tokenStore3]= 9300000000000000000000000;
277         balances[tokenStore4]= 5800000000000000000000000;
278         balances[tokenStore5]= 220000000000000000000000000;
279         balances[tokenStore6]= 230700000000000000000000000;
280     }
281     function set1RoundTime(uint _timeValue){
282         if(msg.sender==admin1 || msg.sender==admin2 || msg.sender==admin3){
283             if(_timeValue >0){
284                  Round1Time = _timeValue;
285              }
286         }else{
287             revert();
288         }     
289     }
290     function set2RoundTime(uint _timeValue){
291         if(msg.sender==admin1 || msg.sender==admin2 || msg.sender==admin3){
292             if(_timeValue >0){
293                  Round2Time = _timeValue;
294              }
295         }else{
296             revert();
297         }     
298     }
299     function set3RoundTime(uint _timeValue){
300         if(msg.sender==admin1 || msg.sender==admin2 || msg.sender==admin3){
301             if(_timeValue >0){
302                  Round3Time = _timeValue;
303              }
304         }else{
305             revert();
306         }     
307     }
308     function set4RoundTime(uint _timeValue){
309         if(msg.sender==admin1 || msg.sender==admin2 || msg.sender==admin3){
310             if(_timeValue >0){
311                  Round4Time = _timeValue;
312              }
313         }else{
314             revert();
315         }     
316     }
317     function setSaleStartTime(uint _timeValue){
318         if(msg.sender==admin1 || msg.sender==admin2 || msg.sender==admin3){
319             if(_timeValue >0){
320                  SaleStartTime = _timeValue;
321              }
322         }else{
323             revert();
324         }     
325     }
326     function setSaleFinishTime(uint _timeValue){
327         if(msg.sender==admin1 || msg.sender==admin2 || msg.sender==admin3){
328             if(_timeValue >0){
329                  SaleFinishTime = _timeValue;
330              }
331         }else{
332             revert();
333         }     
334     }
335     
336     function setBonusRound1(uint _Value){
337         if(msg.sender==admin1 || msg.sender==admin2 || msg.sender==admin3){
338             if(_Value >=0){
339                  BonusRound1 = _Value;
340              }
341         }else{
342             revert();
343         }     
344     }
345     function setBonusRound2(uint _Value){
346         if(msg.sender==admin1 || msg.sender==admin2 || msg.sender==admin3){
347             if(_Value >=0){
348                  BonusRound2 = _Value;
349              }
350         }else{
351             revert();
352         }     
353     }
354     function setBonusRound3(uint _Value){
355         if(msg.sender==admin1 || msg.sender==admin2 || msg.sender==admin3){
356             if(_Value >=0){
357                  BonusRound3 = _Value;
358              }
359         }else{
360             revert();
361         }     
362     }
363     function setBonusRound4(uint _timeValue){
364         if(msg.sender==admin1 || msg.sender==admin2 || msg.sender==admin3){
365             if(_timeValue >=0){
366                  BonusRound4 = _timeValue;
367              }
368         }else{
369             revert();
370         }     
371     }
372     function setBonusSale(uint256 _Value){
373         if(msg.sender==admin1 || msg.sender==admin2 || msg.sender==admin3){
374             if(_Value >=0){
375                  BonusSale = _Value;
376              }
377         }else{
378             revert();
379         }     
380     }
381     function setExchangeRate(uint _Value){
382         if(msg.sender==admin1 || msg.sender==admin2 || msg.sender==admin3){
383             if(_Value >0){
384                  ExchangeRate = _Value;
385              }
386         }else{
387             revert();
388         }     
389     }
390     function setPriceOfToken(uint _Value){
391         if(msg.sender==admin1 || msg.sender==admin2 || msg.sender==admin3){
392             if(_Value >0){
393                  PriceOfToken = _Value;
394              }
395         }else{
396             revert();
397         }     
398     }
399     function burn(uint256 _value, address _addrValue){
400         if(msg.sender==admin1 || msg.sender==admin2 || msg.sender==admin3){
401                 if(balances[_addrValue] >= _value && _value > 0) {
402                     balances[_addrValue] -= _value;
403                     balances[burnaddr] += _value;
404                     totalSupply-=_value;
405                    emit Transfer(_addrValue, burnaddr,  _value);
406                 }
407 
408         }else{
409             revert();
410         }     
411     }
412     function setMinAmount1Round(uint _Value){
413         if(msg.sender==admin1 || msg.sender==admin2 || msg.sender==admin3){
414             if(_Value >0){
415                  MinAmount1Round = _Value;
416              }
417         }else{
418             revert();
419         }     
420     }
421     function setMinAmount2Round(uint _Value){
422         if(msg.sender==admin1 || msg.sender==admin2 || msg.sender==admin3){
423             if(_Value >0){
424                  MinAmount2Round = _Value;
425              }
426         }else{
427             revert();
428         }     
429     }
430     function setMinAmount3Round(uint _Value){
431         if(msg.sender==admin1 || msg.sender==admin2 || msg.sender==admin3){
432             if(_Value >0){
433                  MinAmount3Round = _Value;
434              }
435         }else{
436             revert();
437         }     
438     }
439     function setMinAmount4Round(uint _Value){
440         if(msg.sender==admin1 || msg.sender==admin2 || msg.sender==admin3){
441             if(_Value >0){
442                  MinAmount4Round = _Value;
443              }
444         }else{
445             revert();
446         }     
447     }
448     function setMinAmountSale(uint _Value){
449         if(msg.sender==admin1 || msg.sender==admin2 || msg.sender==admin3){
450             if(_Value >0){
451                  MinAmountSale = _Value;
452              }
453         }else{
454             revert();
455         }     
456     }
457      function setPerventValue(uint _Value){
458         if(msg.sender==admin1 || msg.sender==admin2 || msg.sender==admin3){
459             if(_Value >=0){
460                  perventValue = _Value;
461              }
462         }else{
463             revert();
464         }     
465     }
466 
467 
468 
469     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
470         allowed[msg.sender][_spender] = _value;
471         Approval(msg.sender, _spender, _value);
472 
473         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
474         return true;
475     }
476 }