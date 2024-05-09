1 pragma solidity ^0.4.8;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7   function safeMul(uint256 a, uint256 b)  internal pure returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
14     assert(b > 0);
15     uint256 c = a / b;
16     assert(a == b * c + a % b);
17     return c;
18   }
19 
20   function safeSub(uint256 a, uint256 b) internal pure  returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >=a);
28     return c;
29   }
30 
31  
32   
33 }
34 contract Ownable {
35   address public owner;
36   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37   /**
38    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39    * account.
40    */
41   function Ownable() public {
42     owner = msg.sender;
43   }
44   /**
45    * @dev Throws if called by any account other than the owner.
46    */
47   modifier onlyOwner() {
48     require(msg.sender == owner);
49     _;
50   }
51 
52   function kill() public {
53       if (msg.sender == owner)
54           selfdestruct(owner);
55   }
56   /**
57    * @dev Allows the current owner to transfer control of the contract to a newOwner.
58    * @param newOwner The address to transfer ownership to.
59    */
60   function transferOwnership(address newOwner) onlyOwner public {
61     require(newOwner != address(0));
62     emit OwnershipTransferred(owner, newOwner);
63     owner = newOwner;
64   }
65 }
66 /**
67  * @title Pausable
68  * @dev Base contract which allows children to implement an emergency stop mechanism.
69  */
70 contract Pausable is Ownable {
71   event Pause();
72   event Unpause();
73   bool public paused = false;
74   /**
75    * @dev Modifier to make a function callable only when the contract is not paused.
76    */
77   modifier whenNotPaused() {
78     require(!paused);
79     _;
80   }
81   /**
82    * @dev Modifier to make a function callable only when the contract is paused.
83    */
84   modifier whenPaused() {
85     require(paused);
86     _;
87   }
88   /**
89    * @dev called by the owner to pause, triggers stopped state
90    */
91   function pause() onlyOwner whenNotPaused public {
92     paused = true;
93     emit Pause();
94   }
95   /**
96    * @dev called by the owner to unpause, returns to normal state
97    */
98   function unpause() onlyOwner whenPaused public {
99     paused = false;
100     emit Unpause();
101   }
102 }
103 
104 contract richtestkk is SafeMath,Pausable{
105     string public name;
106     string public symbol;
107     uint8 public decimals;
108     uint256 public totalSupply;
109 	  address public owner;
110     uint256 public startTime;
111     uint256[9] public founderAmounts;
112     /* This creates an array with all balances */
113     mapping (address => uint256) public balanceOf;
114 	  mapping (address => uint256) public freezeOf;
115     mapping (address => mapping (address => uint256)) public allowance;
116 
117     /* This generates a public event on the blockchain that will notify clients */
118     event Transfer(address indexed from, address indexed to, uint256 value);
119 
120 	/* This notifies clients about the amount frozen */
121     event Freeze(address indexed from, uint256 value);
122 
123 	/* This notifies clients about the amount unfrozen */
124     event Unfreeze(address indexed from, uint256 value);
125 
126     event Approval(address indexed owner, address indexed spender, uint256 value);
127 
128     /* Initializes contract with initial supply tokens to the creator of the contract */
129     function richtestkk(
130         uint256 initialSupply,
131         string tokenName,
132         uint8 decimalUnits,
133         string tokenSymbol
134         ) public {
135         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
136         totalSupply = initialSupply;                        // Update total supply
137         name = tokenName;                                   // Set the name for display purposes
138         symbol = tokenSymbol;                               // Set the symbol for display purposes
139         decimals = decimalUnits;                            // Amount of decimals for display purposes
140 		    owner = msg.sender;
141         startTime=now;
142         founderAmounts = [427*10** uint256(25), 304*10** uint256(25), 217*10** uint256(25), 154*10** uint256(25), 11*10** uint256(25), 78*10** uint256(25), 56*10** uint256(25), 34*10** uint256(25), 2*10** uint256(26)];
143     }
144 
145     /* Send coins */
146     function transfer(address _to, uint256 _value) public whenNotPaused {
147         if (_to == 0x0) revert();                               // Prevent transfer to 0x0 address. Use burn() instead
148         if (balanceOf[msg.sender] < _value) revert();           // Check if the sender has enough
149         if (balanceOf[_to] + _value < balanceOf[_to]) revert(); // Check for overflows
150         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                     // Subtract from the sender
151         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                            // Add the same to the recipient
152         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
153     }
154 
155     function minutestotal() public onlyOwner 
156     {
157        if (now > startTime + 3 days&& founderAmounts[0]>0)
158        {
159         totalSupply=  SafeMath.safeAdd(totalSupply, founderAmounts[0]);
160         balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], founderAmounts[0]);
161         founderAmounts[0]=0;
162         emit  Transfer(0, msg.sender, founderAmounts[0]);
163 
164        }
165        if (now > startTime + 6 days&& founderAmounts[1]>0)
166        {
167         totalSupply=  SafeMath.safeAdd(totalSupply, founderAmounts[1]);
168         balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], founderAmounts[1]);
169         founderAmounts[1]=0;
170         emit Transfer(0, msg.sender, founderAmounts[1]);
171 
172        }
173         if (now > startTime + 9 days&& founderAmounts[2]>0)
174        {
175         totalSupply=  SafeMath.safeAdd(totalSupply, founderAmounts[2]);
176         balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], founderAmounts[2]);
177         founderAmounts[2]=0;
178         emit Transfer(0, msg.sender, founderAmounts[2]);
179        }
180 
181         if (now > startTime + 12 days&& founderAmounts[3]>0)
182        {
183         totalSupply=  SafeMath.safeAdd(totalSupply, founderAmounts[3]);
184         balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], founderAmounts[3]);
185         founderAmounts[3]=0;
186         emit  Transfer(0, msg.sender, founderAmounts[3]);
187        }
188         if (now > startTime + 15 days&& founderAmounts[4]>0)
189        {
190         totalSupply=  SafeMath.safeAdd(totalSupply, founderAmounts[4]);
191         balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], founderAmounts[4]);
192         founderAmounts[4]=0;
193         emit Transfer(0, msg.sender, founderAmounts[4]);
194        }
195         if (now > startTime + 18 days&& founderAmounts[5]>0)
196        {
197         totalSupply=  SafeMath.safeAdd(totalSupply, founderAmounts[5]);
198         balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], founderAmounts[5]);
199         founderAmounts[5]=0;
200         emit  Transfer(0, msg.sender, founderAmounts[5]);
201        }
202         if (now > startTime + 21 days&& founderAmounts[6]>0)
203        {
204         totalSupply=  SafeMath.safeAdd(totalSupply, founderAmounts[6]);
205         balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], founderAmounts[6]);
206         founderAmounts[6]=0;
207         emit  Transfer(0, msg.sender, founderAmounts[6]);
208        }
209          if (now > startTime + 24 days&& founderAmounts[7]>0)
210        {
211         totalSupply=  SafeMath.safeAdd(totalSupply, founderAmounts[7]);
212         balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], founderAmounts[7]);
213         founderAmounts[7]=0;
214         emit  Transfer(0, msg.sender, founderAmounts[7]);
215        }
216         if (now > startTime + 27 days&& founderAmounts[8]>0)
217        {
218         totalSupply=  SafeMath.safeAdd(totalSupply, founderAmounts[8]);
219         balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], founderAmounts[8]);
220         founderAmounts[8]=0;
221         emit  Transfer(0, msg.sender, founderAmounts[8]);
222        }
223     }
224     /* Allow another contract to spend some tokens in your behalf */
225     function approve(address _spender, uint256 _value) public whenNotPaused  returns (bool success) {
226         allowance[msg.sender][_spender] = _value;
227         emit  Approval(msg.sender, _spender, _value);
228         return true;
229     }
230 
231 
232     /* A contract attempts to get the coins */
233     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool success) {
234         if (_to == 0x0) revert();                                // Prevent transfer to 0x0 address. 
235         if (balanceOf[_from] < _value) revert();                 // Check if the sender has enough
236         if (balanceOf[_to] + _value < balanceOf[_to]) revert();  // Check for overflows
237         if (_value > allowance[_from][msg.sender]) revert();     // Check allowance
238         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);                           // Subtract from the sender
239         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);                             // Add the same to the recipient
240         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
241         emit Transfer(_from, _to, _value);
242         return true;
243     }
244 
245 
246 	function freeze(uint256 _value) public whenNotPaused returns (bool success) {
247         if (balanceOf[msg.sender] < _value) revert();            // Check if the sender has enough
248         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);                      // Subtract from the sender
249         freezeOf[msg.sender] = SafeMath.safeAdd(freezeOf[msg.sender], _value);                                // Updates totalSupply
250         emit  Freeze(msg.sender, _value);
251         return true;
252     }
253 
254 	function unfreeze(uint256 _value) public whenNotPaused returns (bool success) {
255         if (freezeOf[msg.sender] < _value) revert();            // Check if the sender has enough
256         freezeOf[msg.sender] = SafeMath.safeSub(freezeOf[msg.sender], _value);                      // Subtract from the sender
257 		    balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender], _value);
258         emit Unfreeze(msg.sender, _value);
259         return true;
260     }
261 
262 
263 }