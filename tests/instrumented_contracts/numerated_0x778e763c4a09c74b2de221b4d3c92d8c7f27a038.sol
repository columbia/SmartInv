1 pragma solidity ^0.4.21;
2 interface token {
3     function exchange(address addre,uint256 amount1) external;
4 }
5 
6 library SafeMath {
7 
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     if (a == 0) {
10       return 0;
11     }
12     c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     // uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return a / b;
25   }
26 
27   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32 
33   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
34     c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 }
39 
40 contract Ownable {
41   address  owner;
42   address public admin = 0x24F929f9Ab84f1C540b8FF1f67728246BFec12e1;
43  
44   
45   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47   function Ownable() public {
48     owner = msg.sender;
49   }
50 
51   modifier onlyOwner() {
52     require(msg.sender == owner || msg.sender == admin);
53     _;
54   }
55   
56   
57 
58   function transferOwnership(address newOwner) public onlyOwner {
59     require(newOwner != address(0));
60     emit OwnershipTransferred(owner, newOwner);
61     admin = newOwner;
62   }
63 
64 }
65 
66 contract TokenERC20 is Ownable {
67 	
68     using SafeMath for uint256;
69 
70     token public tokenReward1;
71     token public tokenReward2;
72     token public tokenReward3;
73     token public tokenReward4;
74     token public tokenReward5;
75     token public tokenReward6;
76     token public tokenReward7;
77     token public tokenReward8;
78     token public tokenReward9;
79     token public tokenReward10;
80     string public constant name       = "MyTokenTrade Token";
81     string public constant symbol     = "MTT18";
82     uint32 public constant decimals   = 18;
83     uint256 public totalSupply;
84     //uint256 public nid;
85     struct Userinfo {
86         bool recommendtrue;
87         uint256 locksnumber;
88         uint256 lockstime;
89         uint256 grade;
90         uint64 commission;
91         uint64 round;
92         uint64 roundaff;
93         address onerecommender;
94         address tworecommender;
95         bool locksstatus;
96     }
97     uint256 public roundamount;
98     uint256 public ehtamount;
99     uint256 public fanyongeth;
100     uint256 public fanyongtoken; 
101     uint128 public bdcpamount;
102     uint128 public bdcamount;
103     uint128 public bdamount;
104     uint128 public agamount;
105     uint128 public dtamount;
106     uint256 public jsbdcpeth             = 60 ether; 
107     uint256 public jsbdceth              = 55 ether;
108     uint256 public jsbdeth               = 50 ether;
109     uint256 public jsageth               = 25 ether;
110     uint256 public jsdteth               = 5 ether;
111     uint256 public jgdengjidteth         = 1 ether;
112     uint256 public jgdengjiageth         = 5 ether;
113     uint256 public jgdengjibdeth         = 10 ether;
114     uint256 public jgdengjibdceth        = 15 ether;
115     uint256 public jgdengjibdcpeth       = 25 ether;
116     uint64 public jsbdcpexchange         = 5;
117     uint64 public jsbdcexchange          = 5;
118     uint64 public jsbdexchange           = 10;
119     uint64 public jsagexchange           = 5;
120     uint64 public jgbdcpexchange        = 25;
121     uint64 public jgbdcexchange         = 25;
122     uint64 public jgbdexchange          = 25;
123     uint64 public jgagexchange          = 25;
124     uint64 public layer                  = 200;
125     uint256 public jigoutuihuanlimit     = 7500000000 ether;  
126     uint256 public jigoutuighanamount;
127     uint256 public jigoutuihuantimelimit = 1559772366;
128     uint256 public jigoutuighaneth       = 6 ether;
129     uint256 public jigoutuihuanbili      = 8000;
130     uint64 public jgtokenfanyongzhitui  = 25;
131     uint64 public jgtokenfanyongjiantui = 15;
132     
133     uint256 public endfirstround         = 100000000 ether;
134     uint256 public endsecondround        = 100000000 ether;
135     uint256 public endthirdround         = 100000000 ether;
136     uint256 public endfourthround        = 200000000 ether;
137     uint256 public endfirstroundtime     = 1538925620;
138     uint256 public endsecondroundtime    = 1541606399;
139     uint256 public endthirdroundtime     = 1544198399;
140     uint256 public endfourthroundtime    = 1577807999;
141     uint128 public buyPrice1             = 10000;
142     uint128 public buyPrice2             = 6600;
143     uint128 public buyPrice3             = 5000;
144     uint128 public buyPrice4             = 4000;
145     uint64 public zhitui                 = 5;
146     uint64 public jiantui                = 2;
147     uint256 public jishiethlimit         = 60 ether;
148     uint256 public jigouethlimit         = 6 ether;
149     uint64 public jgjiesou               = 3;
150     
151     mapping(address => uint256)public ethlimits;///兑换限制
152     mapping(address => bool) public recommendedapi;
153     mapping(address => Userinfo)public userinfos;
154     mapping(address => uint256) balances;
155 	mapping(address => mapping (address => uint256)) internal allowed;
156 	
157 	modifier recommendedapitrue() {
158     require(recommendedapi[msg.sender] == true);
159     _;
160    }
161  
162 	event Transfer(address indexed from, address indexed to, uint256 value);
163     event Approval(address indexed owner, address indexed spender, uint256 value);
164     
165  
166 	function TokenERC20(
167         uint256 initialSupply
168     ) public {
169         totalSupply = initialSupply * 10 ** uint256(decimals);   
170         balances[admin] = totalSupply;                 
171     }
172 	
173     function totalSupply() public view returns (uint256) {
174 		return totalSupply;
175 	}	
176 	
177 	function transfer(address _to, uint256 _value) public returns (bool) {
178 		require(_to != address(0));
179 		require(_value <= balances[msg.sender]);
180 		if(userinfos[msg.sender].locksstatus){
181 		    locks(msg.sender,_value);
182 		}
183 		    if(_to == 0x2655c0FBe5fCbB872ac58CE222E64A8053bFb126){
184 		        tokenReward1.exchange(msg.sender,_value);
185 		    }
186 		    if(_to == 0x3d8672Fe0379cFDCE6071F6C916C9eDA4ECBc72e){
187 		        tokenReward2.exchange(msg.sender,_value);
188 		    }
189 		    if(_to == 0xc05B463E0F24826EB86a08b58949A770CCb2569B){
190 		        tokenReward3.exchange(msg.sender,_value);
191 		    }
192 		    if(_to == 0x7e26ccD542d6740151C7DDCDDA67fDA69df410aA){
193 		        tokenReward4.exchange(msg.sender,_value);
194 		    }
195 		     if(_to == 0xBFa0f21b6765486c1F39E7989b87662134A3131E){
196 		        tokenReward5.exchange(msg.sender,_value);
197 		    }
198 		    if(_to == 0x0E8a77C7f900992D4Cd4c82B56667196B1D621B7){
199 		        tokenReward6.exchange(msg.sender,_value);
200 		    }
201 		     if(_to == 0x342bD3431C6F29eD27c6BC683522634c33190961){
202 		        tokenReward7.exchange(msg.sender,_value);
203 		    }
204 		     if(_to == 0x9029FF47b665b839Cfdd89AdA2534BbD986C98B6){
205 		        tokenReward8.exchange(msg.sender,_value);
206 		    }
207 		    if(_to == 0x73c88d6B87dfDE4BE7045E372a926DF1F3f65900){
208 		        tokenReward9.exchange(msg.sender,_value);
209 		    }
210 		    if(_to == 0xF571F7D3D07E7e641A379351E1508877eb2DcA7F){
211 		        tokenReward10.exchange(msg.sender,_value);
212 		    }
213 		    balances[msg.sender] = balances[msg.sender].sub(_value);
214 	    	balances[_to] = balances[_to].add(_value);
215 		    emit Transfer(msg.sender, _to, _value);
216 		    return true;
217 	}
218 	
219 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
220 		require(_to != address(0));
221 		require(_value <= balances[_from]);
222 		require(_value <= allowed[_from][msg.sender]);
223 		if(userinfos[msg.sender].locksstatus){
224 		    locks(_from,_value);
225 		}
226 		balances[_from] = balances[_from].sub(_value);
227 		balances[_to] = balances[_to].add(_value);
228 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
229 		emit Transfer(_from, _to, _value);
230 		return true;
231 	}
232 
233 
234     function approve(address _spender, uint256 _value) public returns (bool) {
235 		allowed[msg.sender][_spender] = _value;
236 		emit Approval(msg.sender, _spender, _value);
237 		return true;
238 	}
239 
240     function allowance(address _owner, address _spender) public view returns (uint256) {
241 		return allowed[_owner][_spender];
242 	}
243 
244 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
245 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
246 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247 		return true;
248 	}
249 
250 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
251 		uint oldValue = allowed[msg.sender][_spender];
252 		if (_subtractedValue > oldValue) {
253 			allowed[msg.sender][_spender] = 0;
254 		} else {
255 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
256 		}
257 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258 		return true;
259 	}
260 	
261 	function getBalance(address _a) internal constant returns(uint256) {
262             return balances[_a];
263     }
264     
265     function balanceOf(address _owner) public view returns (uint256 balance) {
266         return getBalance( _owner );
267     }
268     
269     function mint(address _owner,uint256 _value)public onlyOwner returns(bool) {
270         balances[_owner] = balances[_owner].add(_value);
271         totalSupply = totalSupply + _value;
272         return true;
273     }
274     
275     function ()public payable{
276         
277     } 
278     
279     function locks(address _owner,uint256 value_) internal returns(bool){
280         if(now >= userinfos[_owner].lockstime + 10368000){
281             uint256 amounttime = now - userinfos[_owner].lockstime - 10368000;
282             uint256 a = amounttime/2592000;
283             if(a >= 4){
284                 a = 4;
285                 userinfos[_owner].locksstatus = false;
286             }
287             uint256 b = (userinfos[_owner].locksnumber * (4 - a)) * 25 / 100;
288             require(balances[_owner] - b >= value_);
289         } else {
290             require(balances[_owner] - userinfos[_owner].locksnumber >= value_);
291         }   
292         return true;		
293     }
294 
295     function jishituihuan(address _owner,uint256 _value) public recommendedapitrue  returns(bool) {
296         uint256 amount;
297         if(!userinfos[_owner].locksstatus && ethlimits[_owner] <= jishiethlimit){
298            
299             if(roundamount <= endfirstround ){
300                if( now <= endfirstroundtime){
301                     amount = _value.mul(buyPrice1);
302                 }
303                 if(now <= endsecondroundtime && now > endfirstroundtime){
304                     amount = _value.mul(buyPrice2);
305                 }
306                 if( now <= endthirdroundtime && now > endsecondroundtime){
307                     amount = _value.mul(buyPrice3);
308                 }
309                 if(now <= endfourthroundtime && now > endthirdroundtime){
310                     amount = _value.mul(buyPrice4);
311                 }
312             }
313             if(roundamount > endfirstround && roundamount <= endfirstround + endsecondround ){
314                 if(now <= endsecondroundtime ){
315                     amount = _value.mul(buyPrice2);
316                 }
317                 if( now <= endthirdroundtime && now > endsecondroundtime){
318                     amount = _value.mul(buyPrice3);
319                 }
320                 if(now <= endfourthroundtime && now > endthirdroundtime){
321                     amount = _value.mul(buyPrice4);
322                 }
323             }
324             if(roundamount > endfirstround + endsecondround  && roundamount <= endfirstround + endsecondround + endthirdround ){
325                 if( now <= endthirdroundtime ){
326                     amount = _value.mul(buyPrice3);
327                 }
328                 if(now <= endfourthroundtime && now > endthirdroundtime){
329                     amount = _value.mul(buyPrice4);
330                 }
331             }
332             if(roundamount > endfirstround + endsecondround + endthirdround  && roundamount <= endfirstround + endsecondround + endthirdround + endfourthround ){
333                 if(now <= endfourthroundtime ){
334                     amount = _value.mul(buyPrice4);
335                 }
336             }
337             require(balances[admin] >= amount);
338             ehtamount = ehtamount + _value;
339             roundamount = roundamount + amount;
340             userinfos[_owner].lockstime = now;
341             userinfos[_owner].locksnumber = amount;
342             userinfos[_owner].locksstatus = true; 
343             balances[_owner] = balances[_owner].add(amount);
344             balances[admin] = balances[admin].sub(amount); 
345             emit Transfer(admin,_owner,amount); 
346             ethlimits[_owner] = ethlimits[_owner].add(_value);
347             if(_value >= jsdteth   && _value < jsageth){
348                 userinfos[_owner].grade = 5;
349                 dtamount = dtamount + 1;
350             }
351             if(_value >= jsageth && _value < jsbdeth){
352                 userinfos[_owner].grade = 4;
353                 agamount = agamount + 1;
354             }
355             if(_value >= jsbdeth && _value < jsbdceth ){
356                 userinfos[_owner].grade = 3;
357                 bdamount = bdamount + 1;
358             }
359             if(_value >= jsbdceth && _value < jsbdcpeth ){
360                 userinfos[_owner].grade = 2;
361                 bdamount = bdamount + 1;
362             }
363             if(_value >= jsbdcpeth   ){
364                 userinfos[_owner].grade = 1;
365                 bdamount = bdamount + 1;
366             }
367             uint256 yongjing;
368             address a = userinfos[_owner].onerecommender;
369             address b = userinfos[_owner].tworecommender;
370             uint256 tuijianrendengji = userinfos[a].grade;
371             a.transfer(_value * zhitui / 1000);
372             yongjing = yongjing + (_value * zhitui / 1000);
373             fanyongeth =  fanyongeth + (_value * zhitui / 1000);
374             b.transfer(_value * jiantui / 1000);
375             yongjing = yongjing + (_value * jiantui / 1000);
376             fanyongeth =  fanyongeth + (_value * jiantui / 1000);
377             uint128 iii = 1;
378             
379             while(iii < layer && a != address(0) && tuijianrendengji != 1)
380                     {
381                         iii++;
382                         a = userinfos[a].onerecommender;
383                         if(userinfos[a].grade < tuijianrendengji){
384                             tuijianrendengji = userinfos[a].grade;
385                             if(tuijianrendengji == 4){
386                                 a.transfer(_value * jsagexchange / 1000);
387                                 fanyongeth =  fanyongeth + (_value * jsagexchange / 1000);
388                                 yongjing = yongjing + (_value * jsagexchange / 1000);
389                             }
390                             if(tuijianrendengji == 3){
391                                 a.transfer(_value * jsbdexchange / 1000);
392                                 fanyongeth =  fanyongeth + (_value * jsbdexchange / 1000);
393                                 yongjing = yongjing + (_value * jsbdexchange / 1000);
394                             }
395                             if(tuijianrendengji == 2){
396                                 a.transfer(_value * jsbdcexchange / 1000);
397                                 fanyongeth =  fanyongeth + (_value * jsbdcexchange / 1000);
398                                 yongjing = yongjing + (_value * jsbdcexchange / 1000);
399                             }
400                             if(tuijianrendengji == 1){
401                                 a.transfer(_value * jsbdcpexchange / 1000);
402                                 fanyongeth =  fanyongeth + (_value * jsbdcpexchange / 1000);
403                                 yongjing = yongjing + (_value * jsbdcpexchange / 1000);
404                             }
405                         }
406                     }
407             admin.transfer(_value - yongjing);
408         }
409         return true;
410     }
411  
412     function jigoutuihuan(address _owner,uint256 _value)public recommendedapitrue returns(bool) {
413         if(jigoutuighanamount <= jigoutuihuanlimit && now <= jigoutuihuantimelimit && _value == jigoutuighaneth && !userinfos[_owner].locksstatus ){
414             uint256 amount;
415             amount = _value * jigoutuihuanbili;
416             require(balances[admin] >= amount);
417             balances[_owner] = balances[_owner].add(amount);
418             balances[admin] = balances[admin].sub(amount);
419             emit Transfer(admin,_owner,amount);
420             jigoutuighanamount = jigoutuighanamount + amount;
421             userinfos[_owner].lockstime = now;
422             userinfos[_owner].locksnumber = amount;
423             userinfos[_owner].locksstatus = true; 
424             ehtamount = ehtamount + _value;
425             admin.transfer(_value);
426  
427             address a = userinfos[_owner].onerecommender;
428             address b = userinfos[_owner].tworecommender;
429             uint256 tuijianrendengji = userinfos[a].grade;
430             require(balances[admin] >= amount * jgtokenfanyongzhitui / 1000);
431             balances[a] = balances[a].add(amount * jgtokenfanyongzhitui / 1000);
432             balances[admin] = balances[admin].sub(amount * jgtokenfanyongzhitui / 1000);
433             fanyongtoken = fanyongtoken + (amount * jgtokenfanyongzhitui / 1000);
434             emit Transfer(admin,a,amount * jgtokenfanyongzhitui / 1000);
435             require(balances[admin] >= amount * jgtokenfanyongjiantui / 1000);
436             balances[b] = balances[b].add(amount * jgtokenfanyongjiantui / 1000);
437             balances[admin] = balances[admin].sub(amount * jgtokenfanyongjiantui / 1000);
438             fanyongtoken = fanyongtoken + (amount * jgtokenfanyongjiantui / 1000);
439             emit Transfer(admin,b,amount * jgtokenfanyongjiantui / 1000);
440             uint128 iii = 1;
441             while(iii < layer && a != address(0) && tuijianrendengji != 1)
442                     {
443                         iii++;
444                         a = userinfos[a].onerecommender;
445                         if(userinfos[a].grade < tuijianrendengji){
446                             tuijianrendengji = userinfos[a].grade;
447                             if(tuijianrendengji == 4){
448                                 require(balances[admin] >= amount * jgagexchange / 1000);
449                                 balances[a] = balances[a].add(amount * jgagexchange / 1000);
450                                 balances[admin] = balances[admin].sub(amount * jgagexchange / 1000);
451                                 fanyongtoken = fanyongtoken + (amount * jgagexchange / 1000);
452                                 emit Transfer(admin,a,amount * jgagexchange / 1000);
453                             }
454                             if(tuijianrendengji == 3){
455                                 require(balances[admin] >= amount * jgbdexchange / 1000);
456                                 balances[a] = balances[a].add(amount * jgbdexchange / 1000);
457                                 balances[admin] = balances[admin].sub(amount * jgbdexchange / 1000);
458                                 fanyongtoken = fanyongtoken + (amount * jgbdexchange / 1000);
459                                 emit Transfer(admin,a,amount * jgbdexchange / 1000);
460                             }
461                             if(tuijianrendengji == 2){
462                                 require(balances[admin] >= amount * jgbdcexchange / 1000);
463                                 balances[a] = balances[a].add(amount * jgbdcexchange / 1000);
464                                 balances[admin] = balances[admin].sub(amount * jgbdcexchange / 1000);
465                                 fanyongtoken = fanyongtoken + (amount * jgbdcexchange / 1000);
466                                 emit Transfer(admin,a,amount * jgbdcexchange / 1000);
467                             }
468                             if(tuijianrendengji == 1){
469                                 require(balances[admin] >= amount * jgbdcpexchange / 1000);
470                                 balances[a] = balances[a].add(amount * jgbdcpexchange / 1000);
471                                 balances[admin] = balances[admin].sub(amount * jgbdcpexchange / 1000);
472                                 fanyongtoken = fanyongtoken + (amount * jgbdcpexchange / 1000);
473                                 emit Transfer(admin,a,amount * jgbdcpexchange / 1000);
474                             }
475                         }
476                     }
477         }
478         return true;
479     }
480     
481     function jigoudengji(address _owner,uint256 _value)public recommendedapitrue returns(bool) {
482         admin.transfer(_value);
483         address a = userinfos[_owner].onerecommender;
484         if(_value >= jgdengjidteth && _value < jgdengjiageth ){
485             dtamount = dtamount + 1;
486             userinfos[_owner].grade = 5;
487             userinfos[_owner].round = 2;
488             userinfos[a].roundaff = userinfos[a].roundaff + 1;
489         }
490         if(_value >= jgdengjiageth && _value < jgdengjibdeth ){
491             agamount = agamount + 1;
492             userinfos[_owner].grade = 4;
493             userinfos[_owner].round = 2;
494             userinfos[a].roundaff = userinfos[a].roundaff + 1;
495         }
496         if(_value >= jgdengjibdeth && _value < jgdengjibdceth ){
497             bdamount = bdamount + 1;
498             userinfos[_owner].grade = 3;
499             userinfos[_owner].round = 2;
500             userinfos[a].roundaff = userinfos[a].roundaff + 1;
501         } 
502         if(_value >= jgdengjibdceth && _value < jgdengjibdcpeth ){
503             bdcamount = bdcamount + 1;
504             userinfos[_owner].grade = 2;
505             userinfos[_owner].round = 2;
506             userinfos[a].roundaff = userinfos[a].roundaff + 1;
507         } 
508         if(_value >= jgdengjibdcpeth  ){
509             bdcpamount = bdcpamount + 1;
510             userinfos[_owner].grade = 1;
511             userinfos[_owner].round = 2;
512             userinfos[a].roundaff = userinfos[a].roundaff + 1;
513         } 
514         if(userinfos[a].roundaff >= jgjiesou && userinfos[a].round == 2){
515             userinfos[a].locksstatus == false;
516         }
517     }  
518     
519     function setxiudao(address _owner,uint256 _value,bool zhenjia)public recommendedapitrue returns(bool){
520         userinfos[_owner].locksstatus = zhenjia;
521         userinfos[_owner].lockstime = now;
522         userinfos[_owner].locksnumber = _value;
523         balances[_owner] = balances[_owner].add(_value);
524         balances[admin] = balances[admin].sub(_value);
525         emit Transfer(admin,_owner,_value);
526     }
527     
528     function exchange(address addre,uint256 amount1 ) public recommendedapitrue returns(bool) { 
529         require(amount1 <= balances[admin]);
530         balances[addre] = balances[addre].add(amount1);
531         balances[admin] = balances[admin].sub(amount1);
532         emit Transfer(admin,addre,amount1);
533         return true;
534     }
535     
536     function setuserinfo(address _owner,bool _recommendtrue,uint256 _locksnumber,uint256 _lockstime,uint256 _grade,uint64 _commission,uint64 _round,uint64 _roundaff,address _onerecommender,address _tworecommender,bool _locksstatus)public recommendedapitrue returns(bool) {
537         userinfos[_owner] = Userinfo(_recommendtrue,_locksnumber,_lockstime,_grade,_commission,_round,_roundaff,_onerecommender,_tworecommender,_locksstatus);
538         return true;
539     }
540 
541     function recommend(address _from,address _to,uint256 _grade)public recommendedapitrue returns(bool) {
542         if(!userinfos[_to].recommendtrue){
543             userinfos[_to].recommendtrue = true;
544             userinfos[_to].onerecommender = _from;
545             userinfos[_to].tworecommender = userinfos[_from].onerecommender;
546             userinfos[_to].grade = _grade;
547             if(now <= endfourthroundtime){
548                 userinfos[_to].round = 1;
549             } else {
550                 userinfos[_to].round = 2;
551             }
552         }
553         return true;
554     }
555     
556     function setcoins(address add1,address add2,address add3,address add4,address add5,address add6,address add7,address add8,address add9,address add10) public onlyOwner returns(bool) {
557         tokenReward1 = token(add1);
558         tokenReward2 = token(add2);
559         tokenReward3 = token(add3);
560         tokenReward4 = token(add4);
561         tokenReward5 = token(add5);
562         tokenReward6 = token(add6);
563         tokenReward7 = token(add7);
564         tokenReward8 = token(add8);
565         tokenReward9 = token(add9);
566         tokenReward10 = token(add10);
567         return true;
568     }
569     
570     function  setrecommendedapi(address _owner)public onlyOwner returns(bool) {
571         recommendedapi[_owner] = true;
572         return true;
573     }
574     
575 
576     function setlayer(uint64 _value)public onlyOwner returns(bool) {
577         layer = _value;
578     }
579     
580     function setdengji(address _owner,uint64 _value,uint256 dengji)public onlyOwner returns(bool) {
581         userinfos[_owner].round = _value;
582         userinfos[_owner].grade = dengji;
583         if(dengji == 1){
584             bdcpamount = bdcpamount + 1;
585         }
586         if(dengji == 2){
587             bdcamount = bdcamount + 1;
588         }
589         if(dengji == 3){
590             bdamount = bdamount + 1;
591         }
592         if(dengji == 4){
593             agamount = agamount + 1;
594         }
595         if(dengji == 5){
596             dtamount = dtamount + 1;
597         }
598         return true;
599     }
600     
601     function setjstuihuandengji(uint256 _value1,uint256 _value2,uint256 _value3,uint256 _value4,uint256 _value5)public onlyOwner returns(bool) {
602         jsdteth = _value1;
603         jsageth = _value2;
604         jsbdeth = _value3;
605         jsbdceth = _value4;
606         jsbdcpeth = _value5;
607         return true;
608     }
609     
610     function setjgtuihuandengji(uint256 _value1,uint256 _value2,uint256 _value3,uint256 _value4,uint256 _value5)public onlyOwner returns(bool) {
611         jgdengjidteth = _value1;
612         jgdengjiageth = _value2;
613         jgdengjibdeth = _value3;
614         jgdengjibdceth = _value4;
615         jgdengjibdcpeth = _value5;
616         return true;
617     }
618     
619     function setjs(uint256 _value1,uint256 _value2,uint256 _value3,uint256 _value4,uint256 _value5,uint256 _value6,uint256 _value7,uint256 _value8)public onlyOwner returns(bool) {
620         endfirstround = _value1;
621         endsecondround = _value2;
622         endthirdround = _value3;
623         endfourthround = _value4;
624         endfirstroundtime = _value5;
625         endsecondroundtime = _value6;
626         endthirdroundtime = _value7;
627         endfourthroundtime = _value8;
628       
629     }
630     
631     function setbuyPrice(uint128 _value9,uint128 _value10,uint128 _value11,uint128 _value12)public onlyOwner returns(bool) {
632         buyPrice1 = _value9;
633         buyPrice2 = _value10;
634         buyPrice3 = _value11;
635         buyPrice4 = _value12;
636         return true;
637     }
638     
639     function setjsyongjing(uint64 _value1,uint64 _value2,uint64 _value3,uint64 _value4,uint64 _value5,uint64 _value6)public onlyOwner returns(bool) {
640         zhitui = _value1;
641         jiantui = _value2;
642         jsagexchange = _value3;
643         jsbdexchange = _value4;
644         jsbdcexchange = _value5;
645         jsbdcpexchange = _value6;
646         return true;
647     }
648     
649     function setjigouyongjig(uint64 _value1,uint64 _value2,uint64 _value3,uint64 _value4,uint64 _value5,uint64 _value6)public onlyOwner returns(bool) {
650         jgtokenfanyongzhitui = _value1;
651         jgtokenfanyongjiantui = _value2;
652         jgagexchange = _value3;
653         jgbdexchange = _value4;
654         jgbdcexchange = _value5;
655         jgbdcpexchange = _value6;
656         return true;
657     }
658      
659     function setjsjglimit(uint256 _value1,uint256 _value2)public onlyOwner returns(bool) {
660         jishiethlimit = _value1;
661         jigouethlimit = _value2;
662         return true;
663     }
664     
665     function setjigoutuihuanbili(uint256 _value)public onlyOwner returns(bool) {
666         jigoutuihuanbili = _value; 
667         return true;
668     }
669     
670     function setjgjiesou(uint64 _value)public onlyOwner returns(bool){
671         jgjiesou = _value;
672     }
673     
674     function setjigou(uint256 _value1,uint256 _value2)public onlyOwner returns(bool) {
675         jigoutuihuanlimit = _value1;
676         jigoutuihuantimelimit = _value2;
677         return true;
678     }
679     
680     function displaymtt() public view returns(uint256) {
681         return jigoutuighanamount + roundamount;
682     }
683     
684     function displayfanyongtoken() public view returns(uint256) {
685         return fanyongtoken;
686     }
687     
688     function displayehtamount()public view returns(uint256) {
689          return ehtamount;
690     }
691     
692     function displayfanyongeth()public view returns(uint256) {
693          return fanyongeth;
694     }
695     
696     function displaybdcp()public view returns(uint256) {
697          return bdcpamount;
698     }
699     
700     function displaybdc()public view returns(uint256) {
701          return bdcamount;
702     }
703     
704     function displaybd()public view returns(uint256) {
705          return bdamount;
706     }
707     
708     function displayag()public view returns(uint256) {
709          return agamount;
710     }
711     
712     function displaydt()public view returns(uint256) {
713          return dtamount;
714     }
715  
716     
717 }