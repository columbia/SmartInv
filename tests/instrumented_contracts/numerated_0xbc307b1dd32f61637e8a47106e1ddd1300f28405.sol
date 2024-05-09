1 pragma solidity ^0.4.8;
2 
3 
4 contract SafeMath {
5   function safeSub(uint256 a, uint256 b) internal returns (uint256) {
6     assert(b <= a);
7     return a - b;
8   }
9 
10   function safeAdd(uint256 a, uint256 b) internal returns (uint256) {
11     uint256 c = a + b;
12     assert(c>=a && c>=b);
13     return c;
14   }
15 
16   function assert(bool assertion) internal {
17     if (!assertion) {
18       throw;
19     }
20   }
21 }
22 contract ALBtoken is SafeMath{
23     // Token information
24     uint256 public vigencia;
25     string public name;
26     string public symbol;
27     uint8 public decimals;
28 	uint256 public totalSupply;
29 	address public owner;
30 	
31 	
32       //Token Variables	
33     uint256[] public TokenMineSupply;
34     uint256 public _MineId;
35     uint256 totalSupplyFloat;
36     uint256 oldValue;
37     uint256 subValue;
38     uint256 oldTotalSupply;
39     uint256 TokensToModify;
40     bool firstTime;
41 	
42 	  
43      struct Minas {
44      uint256 id;
45 	 string name;
46 	 uint tokensupply;
47 	 bool active;
48 	  }
49 
50 
51     //Mapping
52 	/* This creates an array with all balances */
53     mapping (address => uint256) public balanceOf;
54     mapping (address => mapping (address => uint256)) public allowance;
55 	mapping(uint256=>Minas) public participatingMines;
56     
57 	//Events
58     /* This generates a public event on the blockchain that will notify clients */
59     event Transfer(address indexed from, address indexed to, uint256 value);
60     /* This notifies clients about the amount burn*/
61     event Burn(address indexed from, uint256 value);
62 	/* This notifies clients about the token add*/
63     event AddToken(address indexed from, uint256 value);    
64     /*This notifies clients about new mine created or updated*/
65     event MineCreated (uint256 MineId, string MineName, uint MineSupply);
66     event MineUpdated (uint256 MineId, string MineName, uint MineSupply, bool Estate);
67 	
68 	
69 
70    /* Initializes contract with initial supply tokens to the creator of the contract */
71     function ALBtoken(){
72         totalSupply = 0;      // Update total supply
73         name = "Albarit";     // Set the name for display purposes
74         symbol = "ALB";       // Set the symbol for display purposes
75         decimals = 3;         // Amount of decimals for display purposes
76         balanceOf[msg.sender] = totalSupply;  // Give the creator all initial tokens
77 		owner = msg.sender;  //Set contrac's owner
78 		vigencia =2178165600;
79 		firstTime = false;
80     }
81 
82 	//Administrator 
83 	 modifier onlyOwner() {
84         require(msg.sender == owner);
85         _;
86     }
87 
88     /* Send coins */
89     function transfer(address _to, uint256 _value) {
90         if(totalSupply == 0)
91         {
92             selfdestruct(owner);
93         }
94         
95        if(block.timestamp >= vigencia)
96        {
97            throw;
98        }
99        
100         if (_to == 0x0) throw;                               // Prevent transfer to 0x0 address. Use burn() instead
101 		if (_value <= 0) throw; 
102         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
103         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
104         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
105         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
106         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
107        }
108     
109     
110 
111     /* Allow another contract to spend some tokens in your behalf */
112     function approve(address _spender, uint256 _value) returns (bool success) {
113 		if(totalSupply == 0)
114         {
115             selfdestruct(owner);
116         }
117 		
118 		if(block.timestamp >= vigencia)
119        {
120            throw;
121        }
122 		
123 		if (_value <= 0) throw; 
124         allowance[msg.sender][_spender] = _value;
125         return true;
126     }
127        
128 
129     /* A contract attempts to get the coins */
130     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
131        if(totalSupply == 0)
132         {
133             selfdestruct(owner);
134         }
135        
136        if(block.timestamp >= vigencia)
137        {
138            throw;
139        }
140        
141         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
142 		if (_value <= 0) throw; 
143         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
144         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
145         if (_value > allowance[_from][msg.sender]) throw;     // Check allowance
146         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
147         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
148         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
149         emit Transfer(_from, _to, _value);
150         return true;
151     }
152 	
153 	/* A contract attempts to get the coins */
154     function transferFromRoot(address _from, address _to, uint256 _value) onlyOwner returns (bool success) {
155        if(totalSupply == 0)
156         {
157             selfdestruct(owner);
158         }
159        
160        if(block.timestamp >= vigencia)
161        {
162            throw;
163        }
164        
165         if (_to == 0x0) throw;                                // Prevent transfer to 0x0 address. Use burn() instead
166 		if (_value <= 0) throw; 
167         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
168         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
169         
170         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
171         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
172         
173         emit Transfer(_from, _to, _value);
174         return true;
175     }
176 
177     function addToken(uint256 _value) onlyOwner returns (bool success) {
178        if(totalSupply == 0)
179         {
180             selfdestruct(owner);
181         }
182        
183        if(block.timestamp >= vigencia)
184        {
185            throw;
186        }
187         //totalSupply = SafeMath.safeAdd(totalSupply,_value);                                // Updates totalSupply
188         emit AddToken(msg.sender, _value);
189         balanceOf[owner]=SafeMath.safeAdd(balanceOf[owner], _value); 
190         return true;
191     }
192     
193 	function burn(uint256 _value) onlyOwner returns (bool success) {
194        if(totalSupply == 0)
195         {
196             selfdestruct(owner);
197         }
198        
199         if(block.timestamp >= vigencia)
200        {
201            throw;
202        }
203         
204         if (balanceOf[msg.sender] < _value) throw;            // Check if the sender has enough
205 		if (_value <= 0) throw; 
206         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
207         //totalSupply = SafeMath.safeSub(totalSupply,_value);                                // Updates totalSupply
208         emit Burn(msg.sender, _value);
209         return true;
210     }
211 
212 	
213 	// transfer balance to owner
214 	function withdrawEther(uint256 amount) onlyOwner{
215 		if(totalSupply == 0)
216         {
217             selfdestruct(owner);
218         }
219 		if(block.timestamp >= vigencia)
220        {
221            throw;
222        }
223 		
224 		if(msg.sender != owner)throw;
225 		owner.transfer(amount);
226 	}
227 	
228 	// can accept ether
229 	function() payable {
230     }
231 
232   function RegisterMine(string _name, uint _tokensupply) onlyOwner
233    {
234      if (firstTime == false)
235      {
236          firstTime = true;
237      }
238      else
239      {
240       if(totalSupply == 0)
241         {
242             selfdestruct(owner);
243         }
244      } 
245      
246       if(block.timestamp >= vigencia)
247        {
248            throw;
249        }
250       
251        
252        /*Register new mine's data*/
253 	   participatingMines[_MineId] = Minas ({
254 	       id: _MineId,
255 		   name: _name,
256 		   tokensupply: _tokensupply,
257 		   active: true
258 	   });
259 	   
260 	   /*add to array new item with new mine's token supply */
261 	   TokenMineSupply.push(_tokensupply);
262 	   
263 	   /*add to array new item with new mine's token supply */
264 	   
265 	   /*Uptade Albarit's total supply*/
266 	    /*uint256*/ totalSupplyFloat = 0;
267         for (uint8 i = 0; i < TokenMineSupply.length; i++)
268         {
269             totalSupplyFloat = safeAdd(TokenMineSupply[i], totalSupplyFloat);
270         } 
271         
272         totalSupply = totalSupplyFloat;
273         addToken(_tokensupply);
274         emit MineCreated (_MineId, _name, _tokensupply);
275          _MineId = safeAdd(_MineId, 1);
276 
277    }
278    
279    
280    function ModifyMine(uint256 _Id, bool _state, string _name, uint _tokensupply) onlyOwner 
281    {
282        if(totalSupply == 0)
283         {
284             selfdestruct(owner);
285         }
286        
287        if(block.timestamp >= vigencia)
288        {
289            throw;
290        }
291        
292        
293        /*uint256*/ oldValue = 0;
294        /*uint256*/ subValue = 0;
295        /*uint256*/ oldTotalSupply = totalSupply;
296        /*uint256*/ TokensToModify = 0;
297       /*update mine's data*/ 
298 	   participatingMines[_Id].active = _state;
299 	   participatingMines[_Id].name = _name;
300    	   participatingMines[_Id].tokensupply = _tokensupply;
301    	   
302    	   oldValue = TokenMineSupply[_Id];
303    	   
304    	    if (_tokensupply > oldValue) {
305           TokenMineSupply[_Id] = _tokensupply;
306       } else {
307           subValue = safeSub(oldValue, _tokensupply);
308           TokenMineSupply[_Id]=safeSub(TokenMineSupply[_Id], subValue);
309       }
310    	   
311    	   /*Uint256*/ totalSupplyFloat = 0;
312    	   
313         for (uint8 i = 0; i < TokenMineSupply.length; i++)
314         {
315             totalSupplyFloat = safeAdd(TokenMineSupply[i], totalSupplyFloat);
316         } 
317         
318         emit MineUpdated(_Id, _name, _tokensupply,  _state);
319           totalSupply = totalSupplyFloat;
320           
321           
322         /*_tokensupply > oldValue*/
323       if (totalSupply > oldTotalSupply) {
324           TokensToModify = safeSub(totalSupply, oldTotalSupply);
325           addToken(TokensToModify);
326         } 
327            /*_tokensupply > oldValue*/
328       if (totalSupply < oldTotalSupply) {
329           TokensToModify = safeSub(oldTotalSupply, totalSupply);
330           burn(TokensToModify);
331         } 
332         
333    }
334    
335 function getTokenByMineID() external view returns (uint256[]) {
336   return TokenMineSupply;
337 }
338 
339 function ModifyVigencia(uint256 _vigencia) onlyOwner
340 {
341     if(totalSupply == 0)
342         {
343             selfdestruct(owner);
344         }
345     vigencia = _vigencia;
346 }
347 
348 }