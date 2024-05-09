1 pragma solidity ^0.4.24;  
2 ////////////////////////////////////////////////////////////////////////////////
3 library     SafeMath
4 {
5     //--------------------------------------------------------------------------
6     function mul(uint256 a, uint256 b) internal pure returns (uint256) 
7     {
8         if (a == 0)     return 0;
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13     //--------------------------------------------------------------------------
14     function div(uint256 a, uint256 b) internal pure returns (uint256) 
15     {
16         return a/b;
17     }
18     //--------------------------------------------------------------------------
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
20     {
21         assert(b <= a);
22         return a - b;
23     }
24     //--------------------------------------------------------------------------
25     function add(uint256 a, uint256 b) internal pure returns (uint256) 
26     {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 ////////////////////////////////////////////////////////////////////////////////
33 library     StringLib       // (minimal version)
34 {
35     function same(string strA, string strB) internal pure returns(bool)
36     {
37         return keccak256(abi.encodePacked(strA))==keccak256(abi.encodePacked(strB));        // using abi.encodePacked since solidity v0.4.23
38     }
39 }
40 ////////////////////////////////////////////////////////////////////////////////
41 contract    ERC20 
42 {
43     using SafeMath  for uint256;
44     using StringLib for string;
45 
46     //----- VARIABLES
47 
48     address public              owner;          // Owner of this contract
49     address public              admin;          // The one who is allowed to do changes 
50 
51     mapping(address => uint256)                         balances;       // Maintain balance in a mapping
52     mapping(address => mapping (address => uint256))    allowances;     // Allowances index-1 = Owner account   index-2 = spender account
53 
54     //------ TOKEN SPECIFICATION
55 
56     string  public  constant    name       = "BqtX Token";
57     string  public  constant    symbol     = "BQTX";
58     uint256 public  constant    decimals   = 18;      // Handle the coin as FIAT (2 decimals). ETH Handles 18 decimal places
59     uint256 public  constant    initSupply = 800000000 * 10**decimals;        // 10**18 max
60     uint256 public  constant    supplyReserveVal = 600000000 * 10**decimals;          // if quantity => the ##MACRO## addrs "* 10**decimals" 
61 
62     //-----
63 
64     uint256 public              totalSupply;
65     uint256 public              icoSalesSupply   = 0;                   // Needed when burning tokens
66     uint256 public              icoReserveSupply = 0;
67     uint256 public              softCap = 10000000   * 10**decimals;
68     uint256 public              hardCap = 500000000   * 10**decimals;
69 
70     //---------------------------------------------------- smartcontract control
71 
72     uint256 public              icoDeadLine = 1544313600;     // 2018-12-09 00:00 (GMT+0)
73 
74     bool    public              isIcoPaused            = false; 
75     bool    public              isStoppingIcoOnHardCap = false;
76 
77     //--------------------------------------------------------------------------
78 
79     modifier duringIcoOnlyTheOwner()  // if not during the ico : everyone is allowed at anytime
80     { 
81         require( now>icoDeadLine || msg.sender==owner );
82         _;
83     }
84 
85     modifier icoFinished()          { require(now > icoDeadLine);           _; }
86     modifier icoNotFinished()       { require(now <= icoDeadLine);          _; }
87     modifier icoNotPaused()         { require(isIcoPaused==false);          _; }
88     modifier icoPaused()            { require(isIcoPaused==true);           _; }
89     modifier onlyOwner()            { require(msg.sender==owner);           _; }
90     modifier onlyAdmin()            { require(msg.sender==admin);           _; }
91 
92     //----- EVENTS
93 
94     event Transfer(address indexed fromAddr, address indexed toAddr,   uint256 amount);
95     event Approval(address indexed _owner,   address indexed _spender, uint256 amount);
96 
97             //---- extra EVENTS
98 
99     event onAdminUserChanged(   address oldAdmin,       address newAdmin);
100     event onOwnershipTransfered(address oldOwner,       address newOwner);
101     event onAdminUserChange(    address oldAdmin,       address newAdmin);
102     event onIcoDeadlineChanged( uint256 oldIcoDeadLine, uint256 newIcoDeadline);
103     event onHardcapChanged(     uint256 hardCap,        uint256 newHardCap);
104     event icoIsNowPaused(       uint8 newPauseStatus);
105     event icoHasRestarted(      uint8 newPauseStatus);
106 
107     //--------------------------------------------------------------------------
108     //--------------------------------------------------------------------------
109     constructor()   public 
110     {
111         owner       = msg.sender;
112         admin       = owner;
113 
114         isIcoPaused = false;
115         //-----
116 
117         balances[owner] = initSupply;   // send the tokens to the owner
118         totalSupply     = initSupply;
119         icoSalesSupply  = totalSupply;   
120 
121         //----- Handling if there is a special maximum amount of tokens to spend during the ICO or not
122 
123         icoSalesSupply   = totalSupply.sub(supplyReserveVal);
124         icoReserveSupply = totalSupply.sub(icoSalesSupply);
125     }
126     //--------------------------------------------------------------------------
127     //--------------------------------------------------------------------------
128     //----- ERC20 FUNCTIONS
129     //--------------------------------------------------------------------------
130     //--------------------------------------------------------------------------
131     function balanceOf(address walletAddress) public constant returns (uint256 balance) 
132     {
133         return balances[walletAddress];
134     }
135     //--------------------------------------------------------------------------
136     function transfer(address toAddr, uint256 amountInWei)  public   duringIcoOnlyTheOwner   returns (bool)     // don't icoNotPaused here. It's a logic issue. 
137     {
138         require(toAddr!=0x0 && toAddr!=msg.sender && amountInWei>0);     // Prevent transfer to 0x0 address and to self, amount must be >0
139 
140         uint256 availableTokens = balances[msg.sender];
141 
142         //----- Checking Token reserve first : if during ICO    
143 
144         if (msg.sender==owner && now <= icoDeadLine)                    // ICO Reserve Supply checking: Don't touch the RESERVE of tokens when owner is selling
145         {
146             assert(amountInWei<=availableTokens);
147 
148             uint256 balanceAfterTransfer = availableTokens.sub(amountInWei);      
149 
150             assert(balanceAfterTransfer >= icoReserveSupply);           // We try to sell more than allowed during an ICO
151         }
152 
153         //-----
154 
155         balances[msg.sender] = balances[msg.sender].sub(amountInWei);
156         balances[toAddr]     = balances[toAddr].add(amountInWei);
157 
158         emit Transfer(msg.sender, toAddr, amountInWei);
159 
160         return true;
161     }
162     //--------------------------------------------------------------------------
163     function allowance(address walletAddress, address spender) public constant returns (uint remaining)
164     {
165         return allowances[walletAddress][spender];
166     }
167     //--------------------------------------------------------------------------
168     function transferFrom(address fromAddr, address toAddr, uint256 amountInWei)  public  returns (bool) 
169     {
170         if (amountInWei <= 0)                                   return false;
171         if (allowances[fromAddr][msg.sender] < amountInWei)     return false;
172         if (balances[fromAddr] < amountInWei)                   return false;
173 
174         balances[fromAddr]               = balances[fromAddr].sub(amountInWei);
175         balances[toAddr]                 = balances[toAddr].add(amountInWei);
176         allowances[fromAddr][msg.sender] = allowances[fromAddr][msg.sender].sub(amountInWei);
177 
178         emit Transfer(fromAddr, toAddr, amountInWei);
179         return true;
180     }
181     //--------------------------------------------------------------------------
182     function approve(address spender, uint256 amountInWei) public returns (bool) 
183     {
184         require((amountInWei == 0) || (allowances[msg.sender][spender] == 0));
185         allowances[msg.sender][spender] = amountInWei;
186         emit Approval(msg.sender, spender, amountInWei);
187 
188         return true;
189     }
190     //--------------------------------------------------------------------------
191     function() public                       
192     {
193         assert(true == false);      // If Ether is sent to this address, don't handle it -> send it back.
194     }
195     //--------------------------------------------------------------------------
196     //--------------------------------------------------------------------------
197     //--------------------------------------------------------------------------
198     function transferOwnership(address newOwner) public onlyOwner               // @param newOwner The address to transfer ownership to.
199     {
200         require(newOwner != address(0));
201 
202         emit onOwnershipTransfered(owner, newOwner);
203         owner = newOwner;
204     }
205     //--------------------------------------------------------------------------
206     //--------------------------------------------------------------------------
207     //--------------------------------------------------------------------------
208     //--------------------------------------------------------------------------
209     function    changeAdminUser(address newAdminAddress) public onlyOwner
210     {
211         require(newAdminAddress!=0x0);
212 
213         emit onAdminUserChange(admin, newAdminAddress);
214         admin = newAdminAddress;
215     }
216     //--------------------------------------------------------------------------
217     //--------------------------------------------------------------------------
218     function    changeIcoDeadLine(uint256 newIcoDeadline) public onlyAdmin
219     {
220         require(newIcoDeadline!=0);
221 
222         emit onIcoDeadlineChanged(icoDeadLine, newIcoDeadline);
223         icoDeadLine = newIcoDeadline;
224     }
225     //--------------------------------------------------------------------------
226     //--------------------------------------------------------------------------
227     //--------------------------------------------------------------------------
228     function    changeHardCap(uint256 newHardCap) public onlyAdmin
229     {
230         require(newHardCap!=0);
231 
232         emit onHardcapChanged(hardCap, newHardCap);
233         hardCap = newHardCap;
234     }
235     //--------------------------------------------------------------------------
236     function    isHardcapReached()  public view returns(bool)
237     {
238         return (isStoppingIcoOnHardCap && initSupply-balances[owner] > hardCap);
239     }
240     //--------------------------------------------------------------------------
241     //--------------------------------------------------------------------------
242     //--------------------------------------------------------------------------
243     function    pauseICO()  public onlyAdmin
244     {
245         isIcoPaused = true;
246         emit icoIsNowPaused(1);
247     }
248     //--------------------------------------------------------------------------
249     function    unpauseICO()  public onlyAdmin
250     {
251         isIcoPaused = false;
252         emit icoHasRestarted(0);
253     }
254     //--------------------------------------------------------------------------
255     function    isPausedICO() public view     returns(bool)
256     {
257         return (isIcoPaused) ? true : false;
258     }
259     /*--------------------------------------------------------------------------
260     //
261     // When ICO is closed, send the remaining (unsold) tokens to address 0x0
262     // So no one will be able to use it anymore... 
263     // Anyone can check address 0x0, so to proove unsold tokens belong to no one anymore
264     //
265     //--------------------------------------------------------------------------*/
266     function destroyRemainingTokens() public onlyAdmin icoFinished icoNotPaused  returns(uint)
267     {
268         require(msg.sender==owner && now>icoDeadLine);
269 
270         address   toAddr = 0x0000000000000000000000000000000000000000;
271 
272         uint256   amountToBurn = balances[owner];
273 
274         if (amountToBurn > icoReserveSupply)
275         {
276             amountToBurn = amountToBurn.sub(icoReserveSupply);
277         }
278 
279         balances[owner]  = balances[owner].sub(amountToBurn);
280         balances[toAddr] = balances[toAddr].add(amountToBurn);
281 
282         emit Transfer(msg.sender, toAddr, amountToBurn);
283         //Transfer(msg.sender, toAddr, amountToBurn);
284 
285         return 1;
286     }        
287 
288     //--------------------------------------------------------------------------
289     //--------------------------------------------------------------------------
290 
291 }
292 ////////////////////////////////////////////////////////////////////////////////
293 contract    Token  is  ERC20
294 {
295     using SafeMath  for uint256;
296     using StringLib for string;
297 
298     //-------------------------------------------------------------------------- Constructor
299     constructor()   public 
300     {
301     }
302     //--------------------------------------------------------------------------
303     //--------------------------------------------------------------------------
304     //--------------------------------------------------------------------------
305 }