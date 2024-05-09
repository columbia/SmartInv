1 pragma solidity ^0.4.23;
2 
3 contract ERC20Basic {
4     function totalSupply() public view returns (uint256);
5     function balanceOf(address who) public view returns (uint256);
6     function transfer(address to, uint256 value) public returns (bool);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11     function allowance(address owner, address spender)
12         public view returns (uint256);
13 
14     function transferFrom(address from, address to, uint256 value)
15         public returns (bool);
16 
17     function approve(address spender, uint256 value) public returns (bool);
18     event Approval(
19     address indexed owner,
20     address indexed spender,
21     uint256 value
22     );
23 }
24 
25 
26 
27 library SafeMath {
28 
29     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
30         if (a == 0) {
31             return 0;
32         }
33         c = a * b;
34         assert(c / a == b);
35         return c;
36     }
37 
38     function div(uint256 a, uint256 b) internal pure returns (uint256) {
39         return a / b;
40     }
41 
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         assert(b <= a);
44         return a - b;
45     }
46 
47     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48         c = a + b;
49         assert(c >= a);
50         return c;
51     }
52 }
53 
54 
55 
56 contract BasicToken is ERC20Basic {
57     using SafeMath for uint256;
58 
59     mapping(address => uint256) balances;
60 
61     uint256 totalSupply_;
62 
63     function totalSupply() public view returns (uint256) {
64         return totalSupply_;
65     }
66 
67     function transfer(address _to, uint256 _value) public returns (bool) {
68         require(_to != address(0));
69         require(_value <= balances[msg.sender]);
70 
71         balances[msg.sender] = balances[msg.sender].sub(_value);
72         balances[_to] = balances[_to].add(_value);
73         emit Transfer(msg.sender, _to, _value);
74         return true;
75     }
76   
77     function balanceOf(address _owner) public view returns (uint256) {
78         return balances[_owner];
79     }
80 
81 }
82 
83 
84 contract StandardToken is ERC20, BasicToken {
85 
86     mapping (address => mapping (address => uint256)) internal allowed;
87 
88     function transferFrom(
89         address _from,
90         address _to,
91         uint256 _value
92     )
93         public
94         returns (bool)
95     {
96         require(_to != address(0));
97         require(_value <= balances[_from]);
98         require(_value <= allowed[_from][msg.sender]);
99 
100         balances[_from] = balances[_from].sub(_value);
101         balances[_to] = balances[_to].add(_value);
102         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
103         emit Transfer(_from, _to, _value);
104         return true;
105     }
106 
107 
108     function approve(address _spender, uint256 _value) public returns (bool) {
109         allowed[msg.sender][_spender] = _value;
110         emit Approval(msg.sender, _spender, _value);
111         return true;
112     }
113 
114 
115     function allowance(
116         address _owner,
117         address _spender
118     )
119     public
120     view
121     returns (uint256)
122     {
123         return allowed[_owner][_spender];
124     }
125 
126 
127     function increaseApproval(
128         address _spender,
129         uint _addedValue
130     )
131     public
132     returns (bool)
133     {
134         allowed[msg.sender][_spender] = (
135         allowed[msg.sender][_spender].add(_addedValue));
136         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
137         return true;
138     }
139 
140 
141     function decreaseApproval(
142         address _spender,
143         uint _subtractedValue
144     )
145         public
146         returns (bool)
147     {
148         uint oldValue = allowed[msg.sender][_spender];
149         if (_subtractedValue > oldValue) {
150             allowed[msg.sender][_spender] = 0;
151         } else {
152             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
153         }
154         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
155         return true;
156     }
157 
158 }
159 
160 
161 contract IGTToken is StandardToken {
162     string public constant name = "IGT Token";
163     string public constant symbol = "IGTT";
164     uint32 public constant decimals = 18;
165     uint256 public INITIAL_SUPPLY = 21000000 * 1 ether;
166     address public CrowdsaleAddress;
167     uint256 public soldTokens;
168     bool public lockTransfers = true;
169 
170     function getSoldTokens() public view returns (uint256) {
171         return soldTokens;
172     }
173 
174 
175   
176   
177     constructor(address _CrowdsaleAddress) public {
178     
179         CrowdsaleAddress = _CrowdsaleAddress;
180         totalSupply_ = INITIAL_SUPPLY;
181         balances[msg.sender] = INITIAL_SUPPLY;      
182     }
183   
184     modifier onlyOwner() {
185         require(msg.sender == CrowdsaleAddress);
186         _;
187     }
188 
189     function setSoldTokens(uint256 _value) public onlyOwner {
190         soldTokens = _value;
191     }
192 
193     function acceptTokens(address _from, uint256 _value) public onlyOwner returns (bool){
194         require (balances[_from] >= _value);
195         balances[_from] = balances[_from].sub(_value);
196         balances[CrowdsaleAddress] = balances[CrowdsaleAddress].add(_value);
197         emit Transfer(_from, CrowdsaleAddress, _value);
198         return true;
199     }
200 
201 
202      // Override
203     function transfer(address _to, uint256 _value) public returns(bool){
204         if (msg.sender != CrowdsaleAddress){
205             require(!lockTransfers, "Transfers are prohibited");
206         }
207         return super.transfer(_to,_value);
208     }
209 
210      // Override
211     function transferFrom(address _from, address _to, uint256 _value) public returns(bool){
212         if (msg.sender != CrowdsaleAddress){
213             require(!lockTransfers, "Transfers are prohibited");
214         }
215         return super.transferFrom(_from,_to,_value);
216     }
217 
218     function lockTransfer(bool _lock) public onlyOwner {
219         lockTransfers = _lock;
220     }
221 
222     function() external payable {
223         // The token contract don`t receive ether
224         revert();
225     }  
226 }
227 
228 
229 contract Ownable {
230     address public owner;
231     address public manager;
232     address candidate;
233 
234     constructor() public {
235         owner = msg.sender;
236         manager = msg.sender;
237     }
238 
239     modifier onlyOwner() {
240         require(msg.sender == owner);
241         _;
242     }
243 
244     modifier restricted() {
245         require(msg.sender == owner || msg.sender == manager);
246         _;
247     }
248 
249     function transferOwnership(address _newOwner) public onlyOwner {
250         require(_newOwner != address(0));
251         candidate = _newOwner;
252     }
253 
254     function setManager(address _newManager) public onlyOwner {
255         manager = _newManager;
256     }
257 
258 
259     function confirmOwnership() public {
260         require(candidate == msg.sender);
261         owner = candidate;
262         delete candidate;
263     }
264 
265 }
266 
267 
268 contract TeamAddress {
269     function() external payable {
270         // The contract don`t receive ether
271         revert();
272     } 
273 }
274 
275 contract Crowdsale is Ownable {
276     using SafeMath for uint; 
277     address myAddress = this;
278     uint256 public startICODate;
279     IGTToken public token = new IGTToken(myAddress);
280     uint public additionalBonus = 0;
281     uint public endTimeAddBonus = 0;
282     event LogStateSwitch(State newState);
283     event ChangeToCoin(address indexed from, uint256 value);
284 
285     enum State { 
286         PreTune, 
287         CrowdSale, 
288         Migrate 
289     }
290     State public currentState = State.PreTune;
291 
292     TeamAddress public teamAddress = new TeamAddress();
293 
294     constructor() public {
295         startICODate = uint256(now);
296         //uint sendTokens = 5250000;
297         giveTokens(address(teamAddress), 5250000);
298         // Stage CrowdSale is enable
299         nextState();    
300     }
301 
302     function nextState() internal {
303         currentState = State(uint(currentState) + 1);
304     }
305 
306     function returnTokensFromTeamAddress(uint256 _value) public onlyOwner {
307         // the function take tokens from teamAddress to contract
308         // the sum is entered in whole tokens (1 = 1 token)
309         uint256 value = _value;
310         require (value >= 1);
311         value = value.mul(1 ether);
312         token.acceptTokens(address(teamAddress), value);    
313     } 
314     
315     function lockExternalTransfer() public onlyOwner {
316         token.lockTransfer(true);
317     }
318 
319     function unlockExternalTransfer() public onlyOwner {
320         token.lockTransfer(false);
321     }
322 
323     function setMigrateStage() public onlyOwner {
324         require(currentState == State.CrowdSale);
325         require(token.balanceOf(address(teamAddress)) == 0);
326         nextState();
327     }
328 
329     function changeToCoin(address _address, uint256 _value) public restricted {
330         require(currentState == State.Migrate);
331         token.acceptTokens(_address, _value);
332         emit ChangeToCoin(_address, _value);
333     }
334 
335     function setAddBonus (uint _value, uint _endTimeBonus) public onlyOwner {
336         additionalBonus = _value;
337         endTimeAddBonus = _endTimeBonus;
338     }
339 
340     function calcBonus () public view returns(uint256) {
341         // 2m - 12%
342         // 4m - 8%
343         // 6m - 6%
344         // 8m - 4%
345         // 10m - 2%
346         // 12.6m - 0%
347         uint256 amountToken = token.getSoldTokens();
348         uint256 actualBonus = 0;
349         
350         if (amountToken < 2240000 * (1 ether)){ 
351             actualBonus = 12;    
352         }
353         if (amountToken >= 2240000 * (1 ether) && amountToken < 4400000 * (1 ether)){
354             actualBonus = 8;
355         }
356         if (amountToken >= 4400000 * (1 ether) && amountToken < 6520000 * (1 ether)){
357             actualBonus = 6;
358         }
359         if (amountToken >= 6520000 * (1 ether) && amountToken < 8600000 * (1 ether)){
360             actualBonus = 4;
361         }
362         if (amountToken >= 8600000 * (1 ether) && amountToken < 10640000 * (1 ether)){
363             actualBonus = 2;
364         }
365         if (now < endTimeAddBonus){
366             actualBonus = actualBonus.add(additionalBonus);
367         }
368         return actualBonus;
369     }
370 
371     function giveTokens(address _newInvestor, uint256 _value) public restricted {
372         // the function give tokens to new investors
373         // the sum is entered in whole tokens (1 = 1 token)
374         require(currentState != State.Migrate);
375         require (_newInvestor != address(0));
376         require (_value >= 1);
377 
378         uint256 mySoldTokens = token.getSoldTokens();
379         uint256 value = _value;
380         value = value.mul(1 ether);
381 
382         if (currentState != State.PreTune){
383             uint256 myBonus = calcBonus();
384             // Add Bonus
385             if (myBonus > 0){
386                 value = value + value.mul(myBonus).div(100);            
387             }
388             mySoldTokens = mySoldTokens.add(value);
389             token.setSoldTokens(mySoldTokens);
390         }
391         token.transfer(_newInvestor, value);
392         
393     }  
394     
395 
396 
397     function() external payable {
398         // The contract don`t receive ether
399         revert();
400     }    
401  
402 }