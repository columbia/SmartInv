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
185         balances[msg.sender] = balances[msg.sender].sub(_value);
186         balances[_to] = balances[_to].add(_value);
187         
188         emit Transfer(msg.sender, _to, _value);
189         return true;
190     	  }
191 
192 
193   function transferFrom(address _from, address _to, uint256 _value) public onlyCLevel returns (bool) {
194   
195         // Prevent transfer to 0x0 address. Use burn() instead
196         require(_to != address(0));
197         
198         require(!frozenAccount[_from]);           // Check if sender is frozen
199         require(!frozenAccount[_to]);              // Check if recipient is frozen
200         require(_value <= balances[_from]);                     
201      
202         require(_value <= allowed[_from][msg.sender]);
203 
204         balances[_from] = balances[_from].sub(_value);
205         balances[_to] = balances[_to].add(_value);
206         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
207         
208         emit Transfer(_from, _to, _value);
209         return true;
210     
211     }
212 
213 
214 	function batchTransfer(address[] _receivers, uint256 _value) public  returns (bool) {
215 		
216 		    uint256 cnt = _receivers.length;
217 		    
218 		    uint256 amount = _value.mul(cnt); 
219 		    
220 		    require(cnt > 0 && cnt <= 20);
221 		    
222 		    require(_value > 0 && balances[msg.sender] >= amount);
223 
224 		    balances[msg.sender] = balances[msg.sender].sub(amount);
225 		    
226 		    for (uint256 i = 0; i < cnt; i++) {
227 		        balances[_receivers[i]] = balances[_receivers[i]].add(_value);
228 		        emit Transfer(msg.sender, _receivers[i], _value);
229 		    }
230 		    
231 		    return true;
232 		  }
233  
234 
235     function approve(address _spender, uint256 _value) public returns (bool) {
236     
237         allowed[msg.sender][_spender] = _value;
238         
239         emit Approval(msg.sender, _spender, _value);
240         return true;
241     }
242 
243     function allowance(address _owner, address _spender) public view returns (uint256) {
244         return allowed[_owner][_spender];
245     }
246 
247     function getAccountFreezedInfo(address _owner) public view returns (bool) {
248         return frozenAccount[_owner];
249     }
250 
251     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
252         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
253         
254         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
255         return true;
256     }
257 
258     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
259         uint256 oldValue = allowed[msg.sender][_spender];
260         
261         if (_subtractedValue > oldValue) {
262             allowed[msg.sender][_spender] = 0;
263         } else {
264             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
265         }
266         
267         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
268         return true;
269     }
270 
271   function burnTokens(uint256 _burnValue)  public onlyCEO returns (bool success) {
272        // Check if the sender has enough
273 	     require(balances[msg.sender] >= _burnValue);    
274 
275 	     
276        // Subtract from the sender
277         balances[msg.sender] = balances[msg.sender].sub(_burnValue);              
278        // Updates totalSupply
279         totalSupply = totalSupply.sub(_burnValue);                              
280         
281         emit BurnTokens(msg.sender, _burnValue);
282         return true;
283     }
284 
285     function burnTokensFrom(address _from, uint256 _value) public onlyCLevel returns (bool success) {
286         
287         require(balances[_from] >= _value);                // Check if the targeted balance is enough
288        
289         require(_from != msg.sender);   
290         
291         require(allowed[_from][msg.sender] >=_value);  
292         
293         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);      
294          
295         balances[_from] = balances[_from].sub(_value);     // Subtract from the targeted balance
296        
297         totalSupply =totalSupply.sub(_value) ;             // Update totalSupply
298         
299         emit BurnTokens(_from, _value);
300         return true;
301         }
302   
303     function freezeAccount(address _target, bool _freeze) public onlyCLevel returns (bool success) {
304         
305         require(_target != msg.sender);
306         
307         frozenAccount[_target] = _freeze;
308         emit FrozenFunds(_target, _freeze);
309         return _freeze;
310         }
311 }
312 
313 contract PausableToken is StandardToken, Pausable {
314 
315     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
316         return super.transfer(_to, _value);
317     }
318 
319     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
320         return super.transferFrom(_from, _to, _value);
321     }
322 
323     function  batchTransfer(address[] _receivers, uint256 _value) public whenNotPaused returns (bool) {
324         return super.batchTransfer(_receivers, _value);
325     }
326 
327 
328     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
329         return super.approve(_spender, _value);
330     }
331 
332     function increaseApproval(address _spender, uint256 _addedValue) public whenNotPaused returns (bool success) {
333         return super.increaseApproval(_spender, _addedValue);
334     }
335 
336     function decreaseApproval(address _spender, uint256 _subtractedValue) public whenNotPaused returns (bool success) {
337         return super.decreaseApproval(_spender, _subtractedValue);
338     }
339     
340     
341   function burnTokens( uint256 _burnValue) public whenNotPaused returns (bool success) {
342         return super.burnTokens(_burnValue);
343     }
344     
345   function burnTokensFrom(address _from, uint256 _burnValue) public whenNotPaused returns (bool success) {
346         return super.burnTokensFrom( _from,_burnValue);
347     }    
348     
349   function freezeAccount(address _target, bool _freeze)  public whenNotPaused returns (bool success) {
350         return super.freezeAccount(_target,_freeze);
351     }   
352        
353 }
354 
355 contract CustomToken is PausableToken {
356 
357     string public name;
358     string public symbol;
359     uint8 public decimals ;
360    
361     
362     // Constants
363     string  public constant tokenName = "ZBT.COM Token";
364     string  public constant tokenSymbol = "ZBT";
365     uint8   public constant tokenDecimals = 6;
366     
367     uint256 public constant initTokenSUPPLY      = 5000000000 * (10 ** uint256(tokenDecimals));
368              
369                                         
370     constructor () public {
371 
372         name = tokenName;
373 
374         symbol = tokenSymbol;
375 
376         decimals = tokenDecimals;
377 
378         totalSupply = initTokenSUPPLY;    
379                 
380         balances[msg.sender] = totalSupply;   
381 
382     }    
383 
384 }