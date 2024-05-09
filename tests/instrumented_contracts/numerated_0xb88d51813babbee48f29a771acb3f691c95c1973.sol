1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4 
5     function add(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         assert(c >= a);
8         return c;
9     }
10 
11     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12         assert(b <= a);
13         return a - b;
14     }
15  
16     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17         if (a == 0) {
18             return 0;
19         }
20         uint256 c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24  
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a / b;
27         return c;
28     }
29 
30 }
31 
32 contract Ownable {
33 
34     address public zbtceo;
35     address public zbtcfo;
36     address public zbtadmin;
37        
38     event CEOshipTransferred(address indexed previousOwner, address indexed newOwner);
39     event CFOshipTransferred(address indexed previousCFO, address indexed newCFO);
40     event ZBTAdminshipTransferred(address indexed previousZBTAdmin, address indexed newZBTAdmin);
41 
42     constructor () public {
43         zbtceo = msg.sender;
44         zbtcfo = msg.sender;
45         zbtadmin = msg.sender;
46     }
47 
48     modifier onlyCEO() {
49         require(msg.sender == zbtceo);
50         _;
51     }
52   
53     modifier onlyCFO() {
54         require(msg.sender == zbtcfo);
55         _;
56     }
57 
58     modifier onlyZBTAdmin() {
59         require(msg.sender == zbtadmin);
60         _;
61     }
62 
63     modifier onlyCLevel() {
64         require(
65             msg.sender == zbtceo ||
66             msg.sender == zbtcfo ||
67             msg.sender == zbtadmin
68         );
69         _;
70     }    
71 
72     function transferCEOship(address _newCEO) public onlyCEO {
73       
74         require(_newCEO != address(0));        
75         emit CEOshipTransferred(zbtceo, _newCEO);       
76         zbtceo = _newCEO;               
77     }
78 
79     function transferCFOship(address _newcfo) public onlyCEO {
80         require(_newcfo != address(0));
81         
82         emit CFOshipTransferred(zbtcfo, _newcfo);        
83         zbtcfo = _newcfo;             
84     }
85    
86     function transferZBTAdminship(address _newzbtadmin) public onlyCEO {
87         require(_newzbtadmin != address(0));        
88         emit ZBTAdminshipTransferred(zbtadmin, _newzbtadmin);        
89         zbtadmin = _newzbtadmin;              
90     }     
91 }
92 
93  
94 contract Pausable is Ownable {
95 
96     event EventPause();
97     event EventUnpause();
98 
99     bool public paused = false;
100 
101     modifier whenNotPaused() {
102         require(!paused);
103         _;
104     }
105 
106     modifier whenPaused() {
107         require(paused);
108         _;
109     }
110 
111     function setPause() onlyCEO whenNotPaused public {
112         paused = true;
113         emit EventPause();
114     }
115 
116     function setUnpause() onlyCEO whenPaused public {
117         paused = false;
118         emit EventUnpause();
119     }
120 }
121 
122 
123 contract ERC20Basic {
124 
125     uint256 public totalSupply;
126     
127   
128     function balanceOf(address who) public view returns (uint256);
129     
130 
131     function transfer(address to, uint256 value) public returns (bool);
132     
133 
134     event Transfer(address indexed from, address indexed to, uint256 value);
135 }
136 
137 contract ERC20 is ERC20Basic {
138 
139     function allowance(address owner, address spender) public view returns (uint256);
140     
141     function transferFrom(address from, address to, uint256 value) public returns (bool);
142     
143 
144     function approve(address spender, uint256 value) public returns (bool);
145     
146 
147     event Approval(address indexed owner, address indexed spender, uint256 value);
148 }
149 
150 contract BasicToken is ERC20Basic {
151 
152     using SafeMath for uint256;
153 
154     mapping(address => uint256) public balances;
155 
156 
157     function balanceOf(address _owner) public view returns (uint256 balance) {
158         return balances[_owner];
159     }
160 
161 }
162 
163 //datacontrolcontract
164 contract StandardToken is ERC20, BasicToken,Ownable {
165     
166 
167     mapping (address => bool) public frozenAccount;
168     mapping (address => mapping (address =>uint256)) internal allowed;
169 
170 
171     /* This notifies clients about the amount burnt */
172     event BurnTokens(address indexed from, uint256 value);
173 	
174    /* This generates a public event on the blockchain that will notify clients */
175     event FrozenFunds(address target, bool frozen);
176     
177 
178     function transfer(address _to, uint256 _value) public returns (bool) {
179     
180         require(_to != address(0));
181         require(!frozenAccount[msg.sender]);           // Check if sender is frozen
182         require(!frozenAccount[_to]);              // Check if recipient is frozen
183         require(_value <= balances[msg.sender]);
184 
185 
186         balances[msg.sender] = balances[msg.sender].sub(_value);
187         balances[_to] = balances[_to].add(_value);
188         
189         emit Transfer(msg.sender, _to, _value);
190         return true;
191     	  }
192 
193 
194   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
195         // Prevent transfer to 0x0 address. Use burn() instead
196         require(_to != address(0));
197         
198         require(!frozenAccount[_from]);           // Check if sender is frozen
199         require(!frozenAccount[_to]);              // Check if recipient is frozen
200         require(_value <= balances[_from]);
201                       
202      if( allowed[msg.sender][_from]>0) { 
203      require(allowed[msg.sender][_from] >= _value);
204      
205         allowed[msg.sender][_from] = allowed[msg.sender][_from].sub(_value);
206         balances[_from] = balances[_from].sub(_value);
207         balances[_to] = balances[_to].add(_value);
208 
209         emit Transfer(_from, _to, _value);
210         
211         return true;
212      }
213      else {            
214          allowed[msg.sender][_from] = 0;
215         balances[_from] = balances[_from].sub(_value);
216         balances[_to] = balances[_to].add(_value);
217 
218         emit Transfer(_from, _to, _value);
219         
220         return true;
221      }
222 
223     }
224 
225 
226 	function batchTransfer(address[] _receivers, uint256 _value) public  returns (bool) {
227 		
228 		    uint256 cnt = _receivers.length;
229 		    
230 		    uint256 amount = _value.mul(cnt); 
231 		    
232 		    require(cnt > 0 && cnt <= 20);
233 		    
234 		    require(_value > 0 && balances[msg.sender] >= amount);
235 
236 		    balances[msg.sender] = balances[msg.sender].sub(amount);
237 		    
238 		    for (uint256 i = 0; i < cnt; i++) {
239 		        balances[_receivers[i]] = balances[_receivers[i]].add(_value);
240 		        emit Transfer(msg.sender, _receivers[i], _value);
241 		    }
242 		    
243 		    return true;
244 		  }
245  
246 
247     function approve(address _spender, uint256 _value) public returns (bool) {
248     
249         allowed[msg.sender][_spender] = _value;
250         
251         emit Approval(msg.sender, _spender, _value);
252         return true;
253     }
254 
255     function allowance(address _owner, address _spender) public view returns (uint256) {
256         return allowed[_owner][_spender];
257     }
258 
259     function getAccountFreezedInfo(address _owner) public view returns (bool) {
260         return frozenAccount[_owner];
261     }
262 
263     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
264         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
265         
266         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
267         return true;
268     }
269 
270     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
271         uint256 oldValue = allowed[msg.sender][_spender];
272         
273         if (_subtractedValue > oldValue) {
274             allowed[msg.sender][_spender] = 0;
275         } else {
276             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
277         }
278         
279         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
280         return true;
281     }
282 
283   function burnTokens(uint256 _burnValue)  public onlyCEO returns (bool success) {
284        // Check if the sender has enough
285 	    require(balances[msg.sender] >= _burnValue);
286         // Subtract from the sender
287         balances[msg.sender] = balances[msg.sender].sub(_burnValue);              
288         // Updates totalSupply
289         totalSupply = totalSupply.sub(_burnValue);                              
290         
291         emit BurnTokens(msg.sender, _burnValue);
292         return true;
293     }
294 
295     function burnTokensFrom(address _from, uint256 _value) public onlyCLevel returns (bool success) {
296         
297         require(balances[_from] >= _value);                // Check if the targeted balance is enough
298        
299         require(_from != msg.sender);   
300                 
301         balances[_from] = balances[_from].sub(_value);     // Subtract from the targeted balance
302        
303         totalSupply =totalSupply.sub(_value) ;             // Update totalSupply
304         
305         emit BurnTokens(_from, _value);
306         return true;
307         }
308   
309     function freezeAccount(address _target, bool _freeze) public onlyCLevel returns (bool success) {
310         
311         require(_target != msg.sender);
312         
313         frozenAccount[_target] = _freeze;
314         emit FrozenFunds(_target, _freeze);
315         return _freeze;
316         }
317 }
318 
319 contract PausableToken is StandardToken, Pausable {
320 
321     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
322         return super.transfer(_to, _value);
323     }
324 
325     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
326         return super.transferFrom(_from, _to, _value);
327     }
328 
329     function  batchTransfer(address[] _receivers, uint256 _value) public whenNotPaused returns (bool) {
330         return super.batchTransfer(_receivers, _value);
331     }
332 
333 
334     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
335         return super.approve(_spender, _value);
336     }
337 
338     function increaseApproval(address _spender, uint256 _addedValue) public whenNotPaused returns (bool success) {
339         return super.increaseApproval(_spender, _addedValue);
340     }
341 
342     function decreaseApproval(address _spender, uint256 _subtractedValue) public whenNotPaused returns (bool success) {
343         return super.decreaseApproval(_spender, _subtractedValue);
344     }
345     
346     
347   function burnTokens( uint256 _burnValue) public whenNotPaused returns (bool success) {
348         return super.burnTokens(_burnValue);
349     }
350     
351   function burnTokensFrom(address _from, uint256 _burnValue) public whenNotPaused returns (bool success) {
352         return super.burnTokensFrom( _from,_burnValue);
353     }    
354     
355   function freezeAccount(address _target, bool _freeze)  public whenNotPaused returns (bool success) {
356         return super.freezeAccount(_target,_freeze);
357     }
358     
359        
360 }
361 
362 contract CustomToken is PausableToken {
363 
364     string public name;
365     string public symbol;
366     uint8 public decimals ;
367     uint256 public totalSupply;
368     
369     // Constants
370     string  public constant tokenName = "ZBT.COM Token";
371     string  public constant tokenSymbol = "ZBT";
372     uint8   public constant tokenDecimals = 6;
373     
374     uint256 public constant initTokenSUPPLY      = 5000000000 * (10 ** uint256(tokenDecimals));
375              
376                                         
377     constructor () public {
378 
379         name = tokenName;
380 
381         symbol = tokenSymbol;
382 
383         decimals = tokenDecimals;
384 
385         totalSupply = initTokenSUPPLY;    
386                 
387         balances[msg.sender] = totalSupply;   
388 
389     }    
390 
391 }