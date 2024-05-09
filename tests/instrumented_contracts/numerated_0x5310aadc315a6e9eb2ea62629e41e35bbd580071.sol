1 pragma solidity ^0.4.0;
2 
3  /* 
4  This Consulteum token contract is based on the ERC20 token contract. Additional 
5  functionality has been integrated: 
6  * the contract Lockable, which is used as a parent of the Token contract 
7  * the function mintTokens(), which makes use of the currentSwapRate() and safeToAdd() helpers 
8  * the function disableTokenSwapLock() 
9  */ 
10  
11  
12  contract Lockable {  
13      uint public creationTime;
14      bool public tokenSwapLock; 
15      
16      address public dev;
17  
18      // This modifier should prevent tokens transfers while the tokenswap 
19      // is still ongoing 
20      modifier isTokenSwapOn { 
21          if (tokenSwapLock) throw; 
22         _;
23      }
24      
25   // This modifier should prevent ICO from being launched by an attacker
26      
27     modifier onlyDev{ 
28        if (msg.sender != dev) throw; 
29       _;
30    }
31 
32      function Lockable() { 
33        dev = msg.sender; 
34      } 
35  } 
36  
37 
38  
39 
40  contract ERC20 { 
41      function totalSupply() constant returns (uint); 
42      function balanceOf(address who) constant returns (uint); 
43      function allowance(address owner, address spender) constant returns (uint); 
44  
45 
46      function transfer(address to, uint value) returns (bool ok); 
47      function transferFrom(address from, address to, uint value) returns (bool ok); 
48      function approve(address spender, uint value) returns (bool ok); 
49  
50      event Transfer(address indexed from, address indexed to, uint value); 
51      event Approval(address indexed owner, address indexed spender, uint value); 
52  } 
53  
54  
55  contract Consulteth is ERC20, Lockable { 
56  
57 
58    mapping( address => uint ) _balances; 
59    mapping( address => mapping( address => uint ) ) _approvals; 
60    
61    uint public foundationAsset;
62    uint public CTX_Cap;
63    uint _supply; 
64    
65    address public wallet_Mini_Address;
66    address public wallet_Address;
67    
68    uint public factorial_ICO;
69    
70    event TokenMint(address newTokenHolder, uint amountOfTokens); 
71    event TokenSwapOver(); 
72  
73    modifier onlyFromMiniWallet { 
74        if (msg.sender != wallet_Mini_Address) throw;
75       _;
76    }
77    
78    modifier onlyFromWallet { 
79        if (msg.sender != wallet_Address) throw; 
80       _;
81    } 
82  
83   
84  
85    function Consulteth(uint preMine, uint cap_CTX) { 
86      _balances[msg.sender] = preMine; 
87      foundationAsset = preMine;
88      CTX_Cap = cap_CTX;
89      
90      _supply += preMine;  
91       
92    } 
93  
94  
95    function totalSupply() constant returns (uint supply) { 
96      return _supply; 
97    } 
98 
99 
100  
101    function balanceOf( address who ) constant returns (uint value) { 
102      return _balances[who]; 
103    } 
104  
105  
106    function allowance(address owner, address spender) constant returns (uint _allowance) { 
107      return _approvals[owner][spender]; 
108    } 
109  
110  
111    // A helper to notify if overflow occurs 
112    function safeToAdd(uint a, uint b) internal returns (bool) { 
113      return (a + b >= a && a + b >= b); 
114    } 
115  
116  
117    function transfer(address to, uint value) isTokenSwapOn returns (bool ok) { 
118  
119  
120      if( _balances[msg.sender] < value ) { 
121          throw; 
122      } 
123      if( !safeToAdd(_balances[to], value) ) { 
124          throw; 
125      } 
126  
127  
128      _balances[msg.sender] -= value; 
129      _balances[to] += value; 
130      Transfer( msg.sender, to, value ); 
131      return true; 
132    } 
133  
134  
135    function transferFrom(address from, address to, uint value) isTokenSwapOn returns (bool ok) { 
136      // if you don't have enough balance, throw 
137      if( _balances[from] < value ) { 
138          throw; 
139      } 
140      // if you don't have approval, throw 
141      if( _approvals[from][msg.sender] < value ) { 
142          throw; 
143      } 
144      if( !safeToAdd(_balances[to], value) ) { 
145          throw; 
146      } 
147      // transfer and return true 
148      _approvals[from][msg.sender] -= value; 
149      _balances[from] -= value; 
150      _balances[to] += value; 
151      Transfer( from, to, value ); 
152      return true; 
153    } 
154  
155    function approve(address spender, uint value) 
156      isTokenSwapOn 
157      returns (bool ok) { 
158      _approvals[msg.sender][spender] = value; 
159      Approval( msg.sender, spender, value ); 
160      return true; 
161    } 
162  
163  
164    function kickStartMiniICO(address ico_Mini_Wallet) onlyDev  { 
165     if (ico_Mini_Wallet == address(0x0)) throw; 
166          // Allow setting only once 
167     if (wallet_Mini_Address != address(0x0)) throw; 
168          wallet_Mini_Address = ico_Mini_Wallet;
169          
170          creationTime = now; 
171          tokenSwapLock = true;  
172    }
173  
174    // The function preICOSwapRate() returns the current exchange rate 
175    // between consulteum tokens and Ether during the pre-ICO token swap period 
176    
177    function preICOSwapRate() constant returns(uint) { 
178        if (creationTime + 1 weeks > now) { 
179            return 1000; 
180        } 
181        else if (creationTime + 3 weeks > now) { 
182            return 850; 
183        } 
184         
185        else { 
186            return 0; 
187        } 
188    } 
189    
190  
191    
192    // The function mintMiniICOTokens is only usable by the chosen wallet 
193    // contract to mint a number of tokens proportional to the 
194    // amount of ether sent to the wallet contract. The function 
195    // can only be called during the tokenswap period 
196    
197 function mintMiniICOTokens(address newTokenHolder, uint etherAmount) onlyFromMiniWallet
198     external { 
199  
200  
201          uint tokensAmount = preICOSwapRate() * etherAmount; 
202          
203          if(!safeToAdd(_balances[newTokenHolder],tokensAmount )) throw; 
204          if(!safeToAdd(_supply,tokensAmount)) throw; 
205  
206  
207          _balances[newTokenHolder] += tokensAmount; 
208          _supply += tokensAmount; 
209  
210  
211          TokenMint(newTokenHolder, tokensAmount); 
212    }
213    
214 // The function disableMiniSwapLock() is called by the wallet 
215    // contract once the token swap has reached its end conditions 
216 
217    function disableMiniSwapLock() onlyFromMiniWallet
218      external { 
219          tokenSwapLock = false; 
220          TokenSwapOver(); 
221    }    
222   
223 
224 
225 function kickStartICO(address ico_Wallet, uint mint_Factorial) onlyDev  { 
226     if (ico_Wallet == address(0x0)) throw; 
227          // Allow setting only once 
228     if (wallet_Address != address(0x0)) throw; 
229          
230          wallet_Address = ico_Wallet;
231          factorial_ICO = mint_Factorial;
232          
233          creationTime = now; 
234          tokenSwapLock = true;  
235    }
236  
237   
238    function ICOSwapRate() constant returns(uint) { 
239        if (creationTime + 1 weeks > now) { 
240            return factorial_ICO; 
241        } 
242        else if (creationTime + 2 weeks > now) { 
243            return (factorial_ICO - 30); 
244        } 
245        else if (creationTime + 4 weeks > now) { 
246            return (factorial_ICO - 70); 
247        } 
248        else { 
249            return 0; 
250        } 
251    } 
252  
253 
254  
255    // The function mintICOTokens is only usable by the chosen wallet 
256    // contract to mint a number of tokens proportional to the 
257    // amount of ether sent to the wallet contract. The function 
258    // can only be called during the tokenswap period 
259    function mintICOTokens(address newTokenHolder, uint etherAmount) onlyFromWallet
260     external { 
261  
262  
263          uint tokensAmount = ICOSwapRate() * etherAmount; 
264 
265          if((_supply + tokensAmount) > CTX_Cap) throw;
266          
267          if(!safeToAdd(_balances[newTokenHolder],tokensAmount )) throw; 
268          if(!safeToAdd(_supply,tokensAmount)) throw; 
269  
270  
271          _balances[newTokenHolder] += tokensAmount; 
272          _supply += tokensAmount; 
273  
274  
275          TokenMint(newTokenHolder, tokensAmount); 
276    } 
277  
278  
279    // The function disableICOSwapLock() is called by the wallet 
280    // contract once the token swap has reached its end conditions 
281    function disableICOSwapLock() onlyFromWallet
282      external { 
283          tokenSwapLock = false; 
284          TokenSwapOver(); 
285    } 
286  }