1 pragma solidity ^0.4.2;
2 
3 /* 
4 `* is owned
5 */
6 contract owned {
7 
8     address public owner;
9 
10     function owned() {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner {
15         if (msg.sender != owner) throw;
16         _;
17     }
18 
19     function ownerTransferOwnership(address newOwner)
20         onlyOwner
21     {
22         owner = newOwner;
23     }
24 
25 }
26 
27 /* 
28 * safe math
29 */
30 contract DSSafeAddSub {
31 
32     function safeToAdd(uint a, uint b) internal returns (bool) {
33         return (a + b >= a);
34     }
35     
36     function safeAdd(uint a, uint b) internal returns (uint) {
37         if (!safeToAdd(a, b)) throw;
38         return a + b;
39     }
40 
41     function safeToSubtract(uint a, uint b) internal returns (bool) {
42         return (b <= a);
43     }
44 
45     function safeSub(uint a, uint b) internal returns (uint) {
46         if (!safeToSubtract(a, b)) throw;
47         return a - b;
48     } 
49 
50 }
51 
52 
53 /**
54  *
55  * @title  EtherollToken
56  * 
57  * The official token powering etheroll.
58  * EtherollToken is a ERC.20 standard token with some custom functionality
59  *
60  */ 
61 
62 
63 contract EtherollToken is owned, DSSafeAddSub {
64 
65     /* check address */
66     modifier onlyBy(address _account) {
67         if (msg.sender != _account) throw;
68         _;
69     }    
70 
71     /* vars */
72     string public standard = 'Token 1.0';
73     string public name = "DICE";
74     string public symbol = "ROL";
75     uint8 public decimals = 16;
76     uint public totalSupply = 250000000000000000000000; 
77 
78     address public priviledgedAddress;  
79     bool public tokensFrozen;
80     uint public crowdfundDeadline = now + 2 * 1 weeks;       
81     uint public nextFreeze = now + 12 * 1 weeks;
82     uint public nextThaw = now + 13 * 1 weeks;
83    
84 
85     /* map balances */
86     mapping (address => uint) public balanceOf;
87     mapping (address => mapping (address => uint)) public allowance;  
88 
89     /* events */
90     event Transfer(address indexed _from, address indexed _to, uint256 _value);
91     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
92     event LogTokensFrozen(bool indexed Frozen);    
93 
94     /*
95     *  @notice sends all tokens to msg.sender on init    
96     */  
97     function EtherollToken(){
98         /* send creator all initial tokens 25,000,000 */
99         balanceOf[msg.sender] = 250000000000000000000000;
100         /* tokens are not frozen */  
101         tokensFrozen = false;                                      
102 
103     }  
104 
105     /*
106     *  @notice public function    
107     *  @param _to address to send tokens to   
108     *  @param _value number of tokens to transfer 
109     *  @returns boolean success         
110     */     
111     function transfer(address _to, uint _value) public
112         returns (bool success)    
113     {
114         if(tokensFrozen && msg.sender != priviledgedAddress) return false;  /* transfer only by priviledgedAddress during crowdfund or reward phases */
115         if (balanceOf[msg.sender] < _value) return false;                   /* check if the sender has enough */
116         if (balanceOf[_to] + _value < balanceOf[_to]) return false;         /* check for overflows */              
117         balanceOf[msg.sender] -=  _value;                                   /* subtract from the sender */
118         balanceOf[_to] += _value;                                           /* add the same to the recipient */
119         Transfer(msg.sender, _to, _value);                                  /* notify anyone listening that this transfer took place */
120         return true;
121     }      
122 
123     /*
124     *  @notice public function    
125     *  @param _from address to send tokens from 
126     *  @param _to address to send tokens to   
127     *  @param _value number of tokens to transfer     
128     *  @returns boolean success      
129     *  another contract attempts to spend tokens on your behalf
130     */       
131     function transferFrom(address _from, address _to, uint _value) public
132         returns (bool success) 
133     {                
134         if(tokensFrozen && msg.sender != priviledgedAddress) return false;  /* transfer only by priviledgedAddress during crowdfund or reward phases */
135         if (balanceOf[_from] < _value) return false;                        /* check if the sender has enough */
136         if (balanceOf[_to] + _value < balanceOf[_to]) return false;         /* check for overflows */                
137         if (_value > allowance[_from][msg.sender]) return false;            /* check allowance */
138         balanceOf[_from] -= _value;                                         /* subtract from the sender */
139         balanceOf[_to] += _value;                                           /* add the same to the recipient */
140         allowance[_from][msg.sender] -= _value;                             /* reduce allowance */
141         Transfer(_from, _to, _value);                                       /* notify anyone listening that this transfer took place */
142         return true;
143     }        
144  
145     /*
146     *  @notice public function    
147     *  @param _spender address being granted approval to spend on behalf of msg.sender
148     *  @param _value number of tokens granted approval for _spender to spend on behalf of msg.sender    
149     *  @returns boolean success      
150     *  approves another contract to spend some tokens on your behalf
151     */      
152     function approve(address _spender, uint _value) public
153         returns (bool success)
154     {
155         /* set allowance for _spender on behalf of msg.sender */
156         allowance[msg.sender][_spender] = _value;
157 
158         /* log event about transaction */
159         Approval(msg.sender, _spender, _value);        
160         return true;
161     } 
162   
163     /*
164     *  @notice address restricted function 
165     *  crowdfund contract calls this to burn its unsold coins 
166     */     
167     function priviledgedAddressBurnUnsoldCoins() public
168         /* only crowdfund contract can call this */
169         onlyBy(priviledgedAddress)
170     {
171         /* totalSupply should equal total tokens in circulation */
172         totalSupply = safeSub(totalSupply, balanceOf[priviledgedAddress]); 
173         /* burns unsold tokens from crowdfund address */
174         balanceOf[priviledgedAddress] = 0;
175     }
176 
177     /*
178     *  @notice public function 
179     *  locks/unlocks tokens on a recurring cycle
180     */         
181     function updateTokenStatus() public
182     {
183         
184         /* locks tokens during initial crowdfund period */
185         if(now < crowdfundDeadline){                       
186             tokensFrozen = true;         
187             LogTokensFrozen(tokensFrozen);  
188         }  
189 
190         /* locks tokens */
191         if(now >= nextFreeze){          
192             tokensFrozen = true;
193             LogTokensFrozen(tokensFrozen);  
194         }
195 
196         /* unlocks tokens */
197         if(now >= nextThaw){         
198             tokensFrozen = false;
199             nextFreeze = now + 12 * 1 weeks;
200             nextThaw = now + 13 * 1 weeks;              
201             LogTokensFrozen(tokensFrozen);  
202         }        
203       
204     }                              
205 
206     /*
207     *  @notice owner restricted function
208     *  @param _newPriviledgedAddress the address
209     *  only this address can burn unsold tokens
210     *  transfer tokens only by priviledgedAddress during crowdfund or reward phases
211     */      
212     function ownerSetPriviledgedAddress(address _newPriviledgedAddress) public 
213         onlyOwner
214     {
215         priviledgedAddress = _newPriviledgedAddress;
216     }   
217                     
218     
219 }