1 /* 
2  * 
3  *                                                                           
4  *                      ;'+:                                                                         
5  *                       ''''''`                                                                     
6  *                        ''''''';                                                                   
7  *                         ''''''''+.                                                                
8  *                          +''''''''',                                                              
9  *                           '''''''''+'.                                                            
10  *                            ''''''''''''                                                           
11  *                             '''''''''''''                                                         
12  *                             ,'''''''''''''.                                                       
13  *                              '''''''''''''''                                                      
14  *                               '''''''''''''''                                                     
15  *                               :'''''''''''''''.                                                   
16  *                                '''''''''''''''';                                                  
17  *                                .'''''''''''''''''                                                 
18  *                                 ''''''''''''''''''                                                
19  *                                 ;''''''''''''''''''                                               
20  *                                  '''''''''''''''''+'                                              
21  *                                  ''''''''''''''''''''                                             
22  *                                  '''''''''''''''''''',                                            
23  *                                  ,''''''''''''''''''''                                            
24  *                                   '''''''''''''''''''''                                           
25  *                                   ''''''''''''''''''''':                                          
26  *                                   ''''''''''''''''''''+'                                          
27  *                                   `''''''''''''''''''''':                                         
28  *                                    ''''''''''''''''''''''                                         
29  *                                    .''''''''''''''''''''';                                        
30  *                                    ''''''''''''''''''''''`                                       
31  *                                     ''''''''''''''''''''''                                       
32  *                                       ''''''''''''''''''''''                                      
33  *                  :                     ''''''''''''''''''''''                                     
34  *                  ,:                     ''''''''''''''''''''''                                    
35  *                  :::.                    ''+''''''''''''''''''':                                  
36  *                  ,:,,:`        .:::::::,. :''''''''''''''''''''''.                                
37  *                   ,,,::::,.,::::::::,:::,::,''''''''''''''''''''''';                              
38  *                   :::::::,::,::::::::,,,''''''''''''''''''''''''''''''`                           
39  *                    :::::::::,::::::::;'''''''''''''''''''''''''''''''''+`                         
40  *                    ,:,::::::::::::,;''''''''''''''''''''''''''''''''''''';                        
41  *                     :,,:::::::::::'''''''''''''''''''''''''''''''''''''''''                       
42  *                      ::::::::::,''''''''''''''''''''''''''''''''''''''''''''                      
43  *                       :,,:,:,:''''''''''''''''''''''''''''''''''''''''''''''`                     
44  *                        .;::;'''''''''''''''''''''''''''''''''''''''''''''''''                     
45  *                            :'+'''''''''''''''''''''''''''''''''''''''''''''''                     
46  *                                  ``.::;'''''''''''''';;:::,..`````,'''''''''',                    
47  *                                                                       ''''''';                    
48  *                                                                         ''''''                    
49  *                           .''''''';       '''''''''''''       ''''''''   '''''                    
50  *                          '''''''''''`     '''''''''''''     ;'''''''''';  ''';                    
51  *                         '''       '''`    ''               ''',      ,'''  '':                    
52  *                        '''         :      ''              `''          ''` :'`                    
53  *                        ''                 ''              '':          :''  '                     
54  *                        ''                 ''''''''''      ''            ''  '                     
55  *                       `''     '''''''''   ''''''''''      ''            ''                        
56  *                        ''     '''''''':   ''              ''            ''                        
57  *                        ''           ''    ''              '''          '''                        
58  *                        '''         '''    ''               '''        '''                         
59  *                         '''.     .'''     ''                '''.    .'''                         
60  *                          `''''''''''      '''''''''''''`    `''''''''''                          
61  *                            '''''''        '''''''''''''`      .''''''.                            
62  *                                                                                                    
63 */
64 
65 pragma solidity ^0.4.25;
66 
67 // ----------------------------------------------------------------------------
68 // 'GEO Utility Tokens' ERC20 Token
69 //
70 // Deployed to : 0xe23282ca40be00905ef9f000c79b0ae861abf57b
71 // Symbol      : GEO
72 // Name        : GEO Utility Tokens
73 // Total supply: 7,000,000,000
74 // Decimals    : 7
75 //
76 // Enjoy.
77 //
78 // (c)by A. Valamontes with doecoins / Geopay.me Inc 2018. The MIT Licence.
79 // ----------------------------------------------------------------------------
80 
81 
82 // ----------------------------------------------------------------------------
83 // Safe maths
84 // ----------------------------------------------------------------------------
85 contract SafeMath {
86     function safeAdd(uint a, uint b) public pure returns (uint c) {
87         c = a + b;
88         require(c >= a);
89     }
90     function safeSub(uint a, uint b) public pure returns (uint c) {
91         require(b <= a);
92         c = a - b;
93     }
94     function safeMul(uint a, uint b) public pure returns (uint c) {
95         c = a * b;
96         require(a == 0 || c / a == b);
97     }
98     function safeDiv(uint a, uint b) public pure returns (uint c) {
99         require(b > 0);
100         c = a / b;
101     }
102 }
103 
104 
105 // ----------------------------------------------------------------------------
106 // ERC Token Standard #20 Interface
107 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
108 // ----------------------------------------------------------------------------
109 contract ERC20Interface {
110     function totalSupply() public constant returns (uint);
111     function balanceOf(address tokenOwner) public constant returns (uint balance);
112     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
113     function transfer(address to, uint tokens) public returns (bool success);
114     function approve(address spender, uint tokens) public returns (bool success);
115     function transferFrom(address from, address to, uint tokens) public returns (bool success);
116 
117     event Transfer(address indexed from, address indexed to, uint tokens);
118     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
119 }
120 
121 
122 // ----------------------------------------------------------------------------
123 // Contract function to receive approval and execute function in one call
124 //
125 // Borrowed from MiniMeToken
126 // ----------------------------------------------------------------------------
127 contract ApproveAndCallFallBack {
128     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
129 }
130 
131 
132 // ----------------------------------------------------------------------------
133 // Owned contract
134 // ----------------------------------------------------------------------------
135 contract Ownedby {
136     address public owner;
137     address public newOwner;
138 
139     event OwnershipTransferred(address indexed _from, address indexed _to);
140 
141     function Owned() public {
142         owner = msg.sender;
143     }
144 
145     modifier onlyOwner {
146         require(msg.sender == owner);
147         _;
148     }
149 
150     function transferOwnership(address _newOwner) public onlyOwner {
151         newOwner = _newOwner;
152     }
153     function acceptOwnership() public {
154         require(msg.sender == newOwner);
155         emit OwnershipTransferred(owner, newOwner);
156         owner = newOwner;
157         newOwner = address(0);
158     }
159        address public currentVersion;
160 
161     function Relay(address initAddr) public {
162         currentVersion = initAddr;
163         owner = msg.sender;
164     }
165 
166     function update(address newAddress) public {
167         if(msg.sender != owner) revert();
168         currentVersion = newAddress;
169     }
170 
171     function() public {
172         if(!currentVersion.delegatecall(msg.data)) revert();
173     }
174 }
175 
176 
177 
178 // ----------------------------------------------------------------------------
179 // ERC20 Token, with the addition of symbol, name and decimals and assisted
180 // token transfers
181 // ----------------------------------------------------------------------------
182 contract GEOPAY is ERC20Interface, Ownedby, SafeMath {
183     string public symbol;
184     string public  name;
185     uint8 public decimals;
186     uint public _totalSupply;
187 
188     mapping(address => uint) balances;
189     mapping(address => mapping(address => uint)) allowed;
190 
191 
192     // ------------------------------------------------------------------------
193     // Constructor
194     // ------------------------------------------------------------------------
195     constructor() public {
196         symbol = "GEO";
197         name = "GEO Utility Token";
198         decimals = 7;
199         _totalSupply = 70000000000000000;
200         balances[0xe23282ca40be00905ef9f000c79b0ae861abf57b] = _totalSupply;
201         emit Transfer(address(0), 0xe23282ca40be00905ef9f000c79b0ae861abf57b, _totalSupply);
202     }
203     
204     // ------------------------------------------------------------------------
205     // Total supply
206     // ------------------------------------------------------------------------
207     function totalSupply() public constant returns (uint) {
208         return _totalSupply  - balances[address(0)];
209     }
210 
211 
212     // ------------------------------------------------------------------------
213     // Get the token balance for account tokenOwner
214     // ------------------------------------------------------------------------
215     function balanceOf(address tokenOwner) public constant returns (uint balance) {
216         return balances[tokenOwner];
217     }
218 
219 
220     // ------------------------------------------------------------------------
221     // Transfer the balance from token owner's account to to account
222     // - Owner's account must have sufficient balance to transfer
223     // - 0 value transfers are allowed
224     // ------------------------------------------------------------------------
225     function transfer(address to, uint tokens) public returns (bool success) {
226         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
227         balances[to] = safeAdd(balances[to], tokens);
228         emit Transfer(msg.sender, to, tokens);
229         return true;
230     }
231 
232 
233     // ------------------------------------------------------------------------
234     // Token owner can approve for spender to transferFrom(...) tokens
235     // from the token owner's account
236     //
237     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
238     // recommends that there are no checks for the approval double-spend attack
239     // as this should be implemented in user interfaces 
240     // ------------------------------------------------------------------------
241     function approve(address spender, uint tokens) public returns (bool success) {
242         allowed[msg.sender][spender] = tokens;
243         emit Approval(msg.sender, spender, tokens);
244         return true;
245     }
246 
247 
248     // ------------------------------------------------------------------------
249     // Transfer tokens from the from account to account
250     // 
251     // The calling account must already have sufficient tokens approve(...)-d
252     // for spending from the from account and
253     // - From account must have sufficient balance to transfer
254     // - Spender must have sufficient allowance to transfer
255     // - 0 value transfers are allowed
256     // ------------------------------------------------------------------------
257     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
258         balances[from] = safeSub(balances[from], tokens);
259         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
260         balances[to] = safeAdd(balances[to], tokens);
261         emit Transfer(from, to, tokens);
262         return true;
263     }
264 
265 
266     // ------------------------------------------------------------------------
267     // Returns the amount of tokens approved by the owner that can be
268     // transferred to the spender's account
269     // ------------------------------------------------------------------------
270     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
271         return allowed[tokenOwner][spender];
272     }
273 
274 
275     // ------------------------------------------------------------------------
276     // Token owner can approve for spender to transferFrom(...) tokens
277     // from the token owner's account. The spender contract function
278     // receiveApproval(...) is then executed
279     // ------------------------------------------------------------------------
280     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
281         allowed[msg.sender][spender] = tokens;
282         emit Approval(msg.sender, spender, tokens);
283         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
284         return true;
285     }
286 
287 
288     // ------------------------------------------------------------------------
289     // Don't accept ETH
290     // ------------------------------------------------------------------------
291     function () public {
292         revert();
293     }
294 
295 
296     // ------------------------------------------------------------------------
297     // Owner can transfer out any accidentally sent ERC20 tokens
298     // ------------------------------------------------------------------------
299     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
300         return ERC20Interface(tokenAddress).transfer(owner, tokens);
301     }
302     function transferEther(uint256 amount) onlyOwner public{
303         msg.sender.transfer(amount);
304         emit Transfer(msg.sender, this, amount);
305     }
306     
307     
308 }