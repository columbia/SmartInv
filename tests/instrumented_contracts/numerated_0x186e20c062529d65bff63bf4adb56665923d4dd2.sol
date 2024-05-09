1 pragma solidity 0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 
8 library SafeMath 
9 {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14 
15   function mul(uint256 a, uint256 b) internal pure returns(uint256 c) 
16   {
17      if (a == 0) 
18      {
19      	return 0;
20      }
21      c = a * b;
22      require(c / a == b);
23      return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29 
30   function div(uint256 a, uint256 b) internal pure returns(uint256) 
31   {
32      return a / b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38 
39   function sub(uint256 a, uint256 b) internal pure returns(uint256) 
40   {
41      require(b <= a);
42      return a - b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48 
49   function add(uint256 a, uint256 b) internal pure returns(uint256 c) 
50   {
51      c = a + b;
52      require(c >= a);
53      return c;
54   }
55 }
56 
57 contract ERC20
58 {
59     function totalSupply() public view returns (uint256);
60     function balanceOf(address _who) public view returns (uint256);
61     function transfer(address _to, uint256 _value) public returns (bool);
62     function allowance(address _owner, address _spender) public view returns (uint256);
63     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
64     function approve(address _spender, uint256 _value) public returns (bool);
65 
66     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
67     event Transfer(address indexed _from, address indexed _to, uint256 _value);
68 }
69 
70 /**
71  * @title Basic token
72  */
73 
74 contract GSCP is ERC20
75 {
76     using SafeMath for uint256;
77    
78     uint256 constant public TOKEN_DECIMALS = 10 ** 18;
79     string public constant name            = "Genesis Supply Chain Platform";
80     string public constant symbol          = "GSCP";
81     uint256 public constant totalTokens    = 999999999;
82     uint256 public totalTokenSupply        = totalTokens.mul(TOKEN_DECIMALS);
83     uint8 public constant decimals         = 18;
84     address public owner;
85 
86     struct AdvClaimLimit 
87     {
88         uint256     time_limit_epoch;
89         uint256     last_claim_time;
90         uint256[3]  tokens;
91         uint8       round;
92         bool        limitSet;
93     }
94 
95     struct TeamClaimLimit 
96     {
97         uint256     time_limit_epoch;
98         uint256     last_claim_time;
99         uint256[4]  tokens;
100         uint8       round;
101         bool        limitSet;
102     }
103 
104     struct ClaimLimit 
105     {
106        uint256 time_limit_epoch;
107        uint256 last_claim_time;
108        uint256 tokens;
109        bool    limitSet;
110     }
111 
112     event Burn(address indexed _burner, uint256 _value);
113 
114     /** mappings **/ 
115     mapping(address => uint256) public  balances;
116     mapping(address => mapping(address => uint256)) internal  allowed;
117     mapping(address => AdvClaimLimit)  advClaimLimits;
118     mapping(address => TeamClaimLimit) teamClaimLimits;
119     mapping(address => ClaimLimit) claimLimits;
120 
121     /**
122      * @dev Throws if called by any account other than the owner.
123      */
124 
125     modifier onlyOwner() 
126     {
127        require(msg.sender == owner);
128        _;
129     }
130     
131     /** constructor **/
132 
133     constructor() public
134     {
135        owner = msg.sender;
136        balances[address(this)] = totalTokenSupply;
137        emit Transfer(address(0x0), address(this), balances[address(this)]);
138     }
139 
140     /**
141      * @dev Burn specified number of GSCP tokens
142      * This function will be called once after all remaining tokens are transferred from
143      * smartcontract to owner wallet
144      */
145 
146      function burn(uint256 _value) onlyOwner public returns (bool) 
147      {
148         require(_value <= balances[msg.sender]);
149 
150         address burner = msg.sender;
151 
152         balances[burner] = balances[burner].sub(_value);
153         totalTokenSupply = totalTokenSupply.sub(_value);
154 
155         emit Burn(burner, _value);
156         return true;
157      }     
158 
159      /**
160       * @dev total number of tokens in existence
161       */
162 
163      function totalSupply() public view returns(uint256 _totalSupply) 
164      {
165         _totalSupply = totalTokenSupply;
166         return _totalSupply;
167      }
168 
169     /**
170      * @dev Gets the balance of the specified address.
171      * @param _owner The address to query the the balance of. 
172      * @return An uint256 representing the amount owned by the passed address.
173      */
174 
175     function balanceOf(address _owner) public view returns (uint256) 
176     {
177        return balances[_owner];
178     }
179 
180     /**
181      * @dev Transfer tokens from one address to another
182      * @param _from address The address which you want to send tokens from
183      * @param _to address The address which you want to transfer to
184      * @param _value uint256 the amout of tokens to be transfered
185      */
186 
187     function transferFrom(address _from, address _to, uint256 _value) public returns (bool)     
188     {
189        if (_value == 0) 
190        {
191            emit Transfer(_from, _to, _value);  // Follow the spec to launch the event when value is equal to 0
192            return;
193        }
194 
195        require(!advClaimLimits[msg.sender].limitSet, "Limit is set and use advClaim");
196        require(!teamClaimLimits[msg.sender].limitSet, "Limit is set and use teamClaim");
197        require(!claimLimits[msg.sender].limitSet, "Limit is set and use claim");
198        require(_to != address(0x0));
199        require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value >= 0);
200 
201        balances[_from] = balances[_from].sub(_value);
202        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
203        balances[_to] = balances[_to].add(_value);
204        emit Transfer(_from, _to, _value);
205        return true;
206     }
207 
208     /**
209     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
210     *
211     * Beware that changing an allowance with this method brings the risk that someone may use both the old
212     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
213     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
214     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
215     * @param _spender The address which will spend the funds.
216     * @param _tokens The amount of tokens to be spent.
217     */
218 
219     function approve(address _spender, uint256 _tokens) public returns(bool)
220     {
221        require(_spender != address(0x0));
222 
223        allowed[msg.sender][_spender] = _tokens;
224        emit Approval(msg.sender, _spender, _tokens);
225        return true;
226     }
227 
228     /**
229      * @dev Function to check the amount of tokens that an owner allowed to a spender.
230      * @param _owner address The address which owns the funds.
231      * @param _spender address The address which will spend the funds.
232      * @return A uint256 specifing the amount of tokens still avaible for the spender.
233      */
234 
235     function allowance(address _owner, address _spender) public view returns(uint256)
236     {
237        require(_owner != address(0x0) && _spender != address(0x0));
238 
239        return allowed[_owner][_spender];
240     }
241 
242     /**
243     * @dev transfer token for a specified address
244     * @param _address The address to transfer to.
245     * @param _tokens The amount to be transferred.
246     */
247 
248     function transfer(address _address, uint256 _tokens) public returns(bool)
249     {
250        if (_tokens == 0) 
251        {
252            emit Transfer(msg.sender, _address, _tokens);  // Follow the spec to launch the event when tokens are equal to 0
253            return;
254        }
255 
256        require(!advClaimLimits[msg.sender].limitSet, "Limit is set and use advClaim");
257        require(!teamClaimLimits[msg.sender].limitSet, "Limit is set and use teamClaim");
258        require(!claimLimits[msg.sender].limitSet, "Limit is set and use claim");
259        require(_address != address(0x0));
260        require(balances[msg.sender] >= _tokens);
261 
262        balances[msg.sender] = (balances[msg.sender]).sub(_tokens);
263        balances[_address] = (balances[_address]).add(_tokens);
264        emit Transfer(msg.sender, _address, _tokens);
265        return true;
266     }
267     
268     /**
269     * @dev transfer token from smart contract to another account, only by owner
270     * @param _address The address to transfer to.
271     * @param _tokens The amount to be transferred.
272     */
273 
274     function transferTo(address _address, uint256 _tokens) external onlyOwner returns(bool) 
275     {
276        require( _address != address(0x0)); 
277        require( balances[address(this)] >= _tokens.mul(TOKEN_DECIMALS) && _tokens.mul(TOKEN_DECIMALS) > 0);
278 
279        balances[address(this)] = ( balances[address(this)]).sub(_tokens.mul(TOKEN_DECIMALS));
280        balances[_address] = (balances[_address]).add(_tokens.mul(TOKEN_DECIMALS));
281        emit Transfer(address(this), _address, _tokens.mul(TOKEN_DECIMALS));
282        return true;
283     }
284 	
285     /**
286     * @dev transfer ownership of this contract, only by owner
287     * @param _newOwner The address of the new owner to transfer ownership
288     */
289 
290     function transferOwnership(address _newOwner)public onlyOwner
291     {
292        require( _newOwner != address(0x0));
293 
294        balances[_newOwner] = (balances[_newOwner]).add(balances[owner]);
295        balances[owner] = 0;
296        owner = _newOwner;
297        emit Transfer(msg.sender, _newOwner, balances[_newOwner]);
298    }
299 
300    /**
301    * @dev Increase the amount of tokens that an owner allowed to a spender
302    */
303 
304    function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) 
305    {
306       allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
307       emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
308       return true;
309    }
310 
311    /**
312    * @dev Decrease the amount of tokens that an owner allowed to a spender
313    */
314 
315    function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) 
316    {
317       uint256 oldValue = allowed[msg.sender][_spender];
318 
319       if (_subtractedValue > oldValue) 
320       {
321          allowed[msg.sender][_spender] = 0;
322       }
323       else 
324       {
325          allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
326       }
327       emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
328       return true;
329    }
330 
331    /**
332     * @dev Transfer adviser tokens to another account, time and percent limit apply.
333     */
334 
335    function adviserClaim(address _recipient) public
336    {
337       require(_recipient != address(0x0), "Invalid recipient");
338       require(msg.sender != _recipient, "Self transfer");
339       require(advClaimLimits[msg.sender].limitSet, "Limit not set");
340       require(advClaimLimits[msg.sender].round < 3, "Claims are over for this adviser wallet");
341       
342       if (advClaimLimits[msg.sender].last_claim_time > 0) {
343         require (now > ((advClaimLimits[msg.sender].last_claim_time).add 
344            (advClaimLimits[msg.sender].time_limit_epoch)), "Time limit");
345       }
346        
347        uint256 tokens = advClaimLimits[msg.sender].tokens[advClaimLimits[msg.sender].round];
348        if (balances[msg.sender] < tokens)
349             tokens = balances[msg.sender];
350         
351        if (tokens == 0) {
352            emit Transfer(msg.sender, _recipient, tokens);
353            return;
354        }
355        
356        balances[msg.sender] = (balances[msg.sender]).sub(tokens);
357        balances[_recipient] = (balances[_recipient]).add(tokens);
358        
359        // update last claim time
360        advClaimLimits[msg.sender].last_claim_time = now;
361        advClaimLimits[msg.sender].round++;
362        emit Transfer(msg.sender, _recipient, tokens);
363    }
364  
365    /**
366     * @dev Set limit on a claim per adviser address
367     */
368 
369    function setAdviserClaimLimit(address _addr) public onlyOwner
370    {
371       uint256 num_days  = 90;  // 3 Months lock-in
372       uint256 percent   = 25;  
373       uint256 percent1  = 25;  
374       uint256 percent2  = 50;  
375 
376       require(_addr != address(0x0), "Invalid address");
377 
378       advClaimLimits[_addr].time_limit_epoch = (now.add(((num_days).mul(1 minutes)))).sub(now);
379       advClaimLimits[_addr].last_claim_time  = 0;
380 
381       if (balances[_addr] > 0) 
382       {
383           advClaimLimits[_addr].tokens[0] = ((balances[_addr]).mul(percent)).div(100);
384           advClaimLimits[_addr].tokens[1] = ((balances[_addr]).mul(percent1)).div(100);
385           advClaimLimits[_addr].tokens[2] = ((balances[_addr]).mul(percent2)).div(100);
386       }    
387       else 
388       {
389           advClaimLimits[_addr].tokens[0] = 0;
390    	  advClaimLimits[_addr].tokens[1] = 0;
391    	  advClaimLimits[_addr].tokens[2] = 0;
392       }    
393       
394       advClaimLimits[_addr].round = 0;
395       advClaimLimits[_addr].limitSet = true;
396    }
397 
398    /**
399     * @dev Transfer team tokens to another account, time and percent limit apply.
400     */
401 
402    function teamClaim(address _recipient) public
403    {
404       require(_recipient != address(0x0), "Invalid recipient");
405       require(msg.sender != _recipient, "Self transfer");
406       require(teamClaimLimits[msg.sender].limitSet, "Limit not set");
407       require(teamClaimLimits[msg.sender].round < 4, "Claims are over for this team wallet");
408       
409       if (teamClaimLimits[msg.sender].last_claim_time > 0) {
410         require (now > ((teamClaimLimits[msg.sender].last_claim_time).add 
411            (teamClaimLimits[msg.sender].time_limit_epoch)), "Time limit");
412       }
413        
414        uint256 tokens = teamClaimLimits[msg.sender].tokens[teamClaimLimits[msg.sender].round];
415        if (balances[msg.sender] < tokens)
416             tokens = balances[msg.sender];
417         
418        if (tokens == 0) {
419            emit Transfer(msg.sender, _recipient, tokens);
420            return;
421        }
422        
423        balances[msg.sender] = (balances[msg.sender]).sub(tokens);
424        balances[_recipient] = (balances[_recipient]).add(tokens);
425        
426        // update last claim time
427        teamClaimLimits[msg.sender].last_claim_time = now;
428        teamClaimLimits[msg.sender].round++;
429        emit Transfer(msg.sender, _recipient, tokens);
430    }
431  
432    /**
433     * @dev Set limit on a claim per team member address
434     */
435 
436    function setTeamClaimLimit(address _addr) public onlyOwner
437    {
438       uint256 num_days  = 180;  // 6 Months lock-in
439       uint256 percent   = 10;  
440       uint256 percent1  = 15;  
441       uint256 percent2  = 35;  
442       uint256 percent3  = 40;  
443 
444       require(_addr != address(0x0), "Invalid address");
445 
446       teamClaimLimits[_addr].time_limit_epoch = (now.add(((num_days).mul(1 minutes)))).sub(now);
447       teamClaimLimits[_addr].last_claim_time  = 0;
448 
449       if (balances[_addr] > 0) 
450       {
451           teamClaimLimits[_addr].tokens[0] = ((balances[_addr]).mul(percent)).div(100);
452           teamClaimLimits[_addr].tokens[1] = ((balances[_addr]).mul(percent1)).div(100);
453           teamClaimLimits[_addr].tokens[2] = ((balances[_addr]).mul(percent2)).div(100);
454           teamClaimLimits[_addr].tokens[3] = ((balances[_addr]).mul(percent3)).div(100);
455       }    
456       else 
457       {
458           teamClaimLimits[_addr].tokens[0] = 0;
459    	      teamClaimLimits[_addr].tokens[1] = 0;
460    	      teamClaimLimits[_addr].tokens[2] = 0;
461    	      teamClaimLimits[_addr].tokens[3] = 0;
462       }    
463       
464       teamClaimLimits[_addr].round = 0;
465       teamClaimLimits[_addr].limitSet = true;
466     }
467 
468     /**
469     * @dev Transfer tokens to another account, time and percent limit apply
470     */
471 
472     function claim(address _recipient) public
473     {
474        require(_recipient != address(0x0), "Invalid recipient");
475        require(msg.sender != _recipient, "Self transfer");
476        require(claimLimits[msg.sender].limitSet, "Limit not set");
477        
478        if (claimLimits[msg.sender].last_claim_time > 0) 
479        {
480           require (now > ((claimLimits[msg.sender].last_claim_time).
481             add(claimLimits[msg.sender].time_limit_epoch)), "Time limit");
482        }
483        
484        uint256 tokens = claimLimits[msg.sender].tokens;
485 
486        if (balances[msg.sender] < tokens)
487             tokens = balances[msg.sender];
488         
489        if (tokens == 0) 
490        {
491             emit Transfer(msg.sender, _recipient, tokens);
492             return;
493        }
494        
495        balances[msg.sender] = (balances[msg.sender]).sub(tokens);
496        balances[_recipient] = (balances[_recipient]).add(tokens);
497        
498        // update last claim time
499        claimLimits[msg.sender].last_claim_time = now;
500        
501        emit Transfer(msg.sender, _recipient, tokens);
502     }
503  
504 
505     /**
506     * @dev Set limit on a claim per address
507     */
508 
509     function setClaimLimit(address _address, uint256 _days, uint256 _percent) public onlyOwner
510     {
511        require(_percent <= 100, "Invalid percent");
512 
513        claimLimits[_address].time_limit_epoch = (now.add(((_days).mul(1 minutes)))).sub(now);
514        claimLimits[_address].last_claim_time  = 0;
515    		
516        if (balances[_address] > 0)
517    	      claimLimits[_address].tokens = ((balances[_address]).mul(_percent)).div(100);
518        else
519    	      claimLimits[_address].tokens = 0;
520    		    
521        claimLimits[_address].limitSet = true;
522     }
523 
524    
525 
526 }