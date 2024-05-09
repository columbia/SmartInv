1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract ERC20Basic {
30   uint256 public totalSupply;
31   function balanceOf(address who) public constant returns (uint256);
32   function transfer(address to, uint256 value) public returns (bool);
33   event Transfer(address indexed from, address indexed to, uint256 value);
34 }
35 
36 contract ERC20 is ERC20Basic {
37   function allowance(address owner, address spender) public constant returns (uint256);
38   function transferFrom(address from, address to, uint256 value) public returns (bool);
39   function approve(address spender, uint256 value) public returns (bool);
40   event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 contract BasicToken is ERC20Basic {
44   using SafeMath for uint256;
45 
46   mapping(address => uint256) balances;
47 
48   /**
49   * @dev transfer token for a specified address
50   * @param _to The address to transfer to.
51   * @param _value The amount to be transferred.
52   */
53   function transfer(address _to, uint256 _value) public returns (bool) {
54     require(_to != address(0));
55     require(_value <= balances[msg.sender]);
56 
57     // SafeMath.sub will throw if there is not enough balance.
58     balances[msg.sender] = balances[msg.sender].sub(_value);
59     balances[_to] = balances[_to].add(_value);
60     Transfer(msg.sender, _to, _value);
61     return true;
62   }
63   
64     function balanceOf(address _owner) public constant returns (uint256 balance) {
65     return balances[_owner];
66   }
67   
68 }
69 
70 contract StandardToken is ERC20, BasicToken {
71 
72   mapping (address => mapping (address => uint256)) internal allowed;
73 
74 
75   /**
76    * @dev Transfer tokens from one address to another
77    * @param _from address The address which you want to send tokens from
78    * @param _to address The address which you want to transfer to
79    * @param _value uint256 the amount of tokens to be transferred
80    */
81   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
82     require(_to != address(0));
83     require(_value <= balances[_from]);
84     require(_value <= allowed[_from][msg.sender]);
85 
86     balances[_from] = balances[_from].sub(_value);
87     balances[_to] = balances[_to].add(_value);
88     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
89     Transfer(_from, _to, _value);
90     return true;
91   }
92 
93   /**
94    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
95    *
96    * Beware that changing an allowance with this method brings the risk that someone may use both the old
97    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
98    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
99    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
100    * @param _spender The address which will spend the funds.
101    * @param _value The amount of tokens to be spent.
102    */
103   function approve(address _spender, uint256 _value) public returns (bool) {
104     allowed[msg.sender][_spender] = _value;
105     Approval(msg.sender, _spender, _value);
106     return true;
107   }
108 
109   /**
110    * @dev Function to check the amount of tokens that an owner allowed to a spender.
111    * @param _owner address The address which owns the funds.
112    * @param _spender address The address which will spend the funds.
113    * @return A uint256 specifying the amount of tokens still available for the spender.
114    */
115   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
116     return allowed[_owner][_spender];
117   }
118 
119   /**
120    * approve should be called when allowed[_spender] == 0. To increment
121    * allowed value is better to use this function to avoid 2 calls (and wait until
122    * the first transaction is mined)
123    * From MonolithDAO Token.sol
124    */
125   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
126     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
127     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
128     return true;
129   }
130 
131   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
132     uint oldValue = allowed[msg.sender][_spender];
133     if (_subtractedValue > oldValue) {
134       allowed[msg.sender][_spender] = 0;
135     } else {
136       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
137     }
138     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
139     return true;
140   }
141 
142 }
143 
144 contract CompletelyDecentralizedWorld is StandardToken {
145     string public constant name = "CompletelyDecentralizedWorld";
146     string public constant symbol = "CDW";
147     uint public constant decimals = 18;
148     
149     uint teamPartToken = 50000000 * (10 ** uint256(decimals));
150     
151     uint communityBuildingToken = 30000000 * (10 ** uint256(decimals));
152     
153     uint16[4] public bonusPercentages = [30,20,10,0];
154     
155     uint public constant NUM_OF_PHASE = 4;
156     
157     uint public constant BLOCK_PER_PHASE = 150000;
158     
159     address public constant target = 0xEAD3346C806803e1500d96B9a2D7065d0526Caf6;
160   
161     // Team Keep token
162     address public constant addr_teamPartToken = 0x898f9ca9cf198E059396337A7bbbBBed59856089;
163     
164     bool teamPartTokenIssued = false;
165     
166     // Community Building
167     address public constant addr_communityBuildingToken = 0x8E5A7df3fDbbB467a1D6feed337EC2e1938AAb3f;
168     
169     bool communityBuildingTokenIssued = false;
170     
171     uint public firstblock = 0;
172     
173     uint public constant HARD_CAP = 20000 ether;
174     
175    
176     uint public constant BASE_RATE = 25000;
177     
178     uint public totalEthReceived = 0;
179     
180     uint public issueIndex = 0;
181     
182     /** Events */
183     
184     event SaleStarted();
185     
186     event SaleEnded();
187     
188     event InvalidCaller(address caller);
189     
190     event InvalidState(bytes msg);
191     
192     event Issue(uint issueIndex, address addr, uint ethAmount, uint tokenAmount);
193     
194     event SaleSucceeded();
195     
196     event SaleFailed();
197     
198     /**MODIFIERS*/
199     
200     modifier onlyOwner {
201         if (target == msg.sender) {
202             _;
203         } else {
204             InvalidCaller(msg.sender);
205             revert();
206         }
207     }
208     
209     modifier beforeStart {
210         if (!saleStarted()) {
211             _;
212         } else {
213             InvalidState("Sale has not started yet");
214             revert();
215         }
216     }
217     
218     modifier inProgress {
219         if (saleStarted() && !saleEnded()) {
220             _;
221         } else {
222             InvalidState("Sale is not in Progress");
223             revert();
224         }
225     }
226     
227     modifier afterEnd {
228         if (saleEnded()) {
229             _;
230         } else {
231             InvalidState("Sale is not ended yet");
232             revert();
233         }
234     }    
235 
236 /** PUBLIC FUNCTIONS*/
237 function start(uint _firstblock) public onlyOwner beforeStart {
238     if (_firstblock <= block.number) {
239         revert();
240     }
241     
242     firstblock = _firstblock;
243     SaleStarted();
244     issueTeamPartToken();
245     issueCommunityBuildingToken();
246 }
247 
248 function close() public onlyOwner afterEnd {
249    
250     issueTeamPartToken();
251     issueCommunityBuildingToken();
252     SaleSucceeded();
253         
254 }
255 
256 function price() public constant returns (uint tokens) {
257     return computeTokenAmount(1 ether);
258 }
259 
260 function () public payable{
261     issueToken(msg.sender);
262 }
263 
264 function issueToken(address recipient) public payable inProgress{
265     assert(msg.value >= 0.01 ether);
266     
267     uint tokens = computeTokenAmount(msg.value);
268     totalEthReceived = totalEthReceived.add(msg.value);
269     totalSupply = totalSupply.add(tokens);
270     balances[recipient] = balances[recipient].add(tokens);
271     
272     Issue(issueIndex++, recipient, msg.value, tokens);
273     
274     if (!target.send(msg.value)){
275         revert();
276     }
277 }
278 
279 /**INTERNAL FUNCTIONS*/
280 
281 function computeTokenAmount(uint ethAmount) internal constant returns (uint tokens) {
282     uint phase = (block.number - firstblock).div(BLOCK_PER_PHASE);
283     if (phase >= bonusPercentages.length) {
284         phase = bonusPercentages.length - 1;
285     }
286     
287     uint tokenBase = ethAmount.mul(BASE_RATE);
288     uint tokenBonus = tokenBase.mul(bonusPercentages[phase]).div(100);
289     tokens = tokenBase.add(tokenBonus);
290 }
291 
292 
293 function issueTeamPartToken() internal {
294     if(teamPartTokenIssued){
295         InvalidState("teamPartToken has been issued already");
296     } else {
297         totalSupply = totalSupply.add(teamPartToken);
298         balances[addr_teamPartToken] = balances[addr_teamPartToken].add(teamPartToken);
299         Issue(issueIndex++, addr_teamPartToken, 0, teamPartToken);
300         teamPartTokenIssued = true;
301     }
302 }
303 
304 function issueCommunityBuildingToken() internal {
305     if(communityBuildingTokenIssued){
306         InvalidState("communityBuildingToken has been issued already");
307     } else {
308         totalSupply = totalSupply.add(communityBuildingToken);
309         balances[addr_communityBuildingToken] = balances[addr_communityBuildingToken].add(communityBuildingToken);
310         Issue(issueIndex++, addr_communityBuildingToken, 0, communityBuildingToken);
311         communityBuildingTokenIssued = true;
312     }
313 }
314 
315 function saleStarted() public constant returns (bool) {
316     return (firstblock > 0 && block.number >= firstblock);
317     }
318 
319 function saleEnded() public constant returns (bool) {
320     return firstblock > 0 && (saleDue() || hardCapReached());
321     }
322  
323 function saleDue() public constant returns (bool) {
324     return block.number >= firstblock + BLOCK_PER_PHASE*NUM_OF_PHASE;
325     }
326 
327 function hardCapReached() public constant returns (bool) {
328     return totalEthReceived >= HARD_CAP;
329     }
330 }