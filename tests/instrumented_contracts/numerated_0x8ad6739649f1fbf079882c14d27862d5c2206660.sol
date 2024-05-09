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
33 contract    ERC20 
34 {
35     using SafeMath  for uint256;
36     
37     //----- VARIABLES
38 
39     address public              owner;          // Owner of this contract
40     address public              admin;          // The one who is allowed to do changes 
41 
42     mapping(address => uint256)                         balances;       // Maintain balance in a mapping
43     mapping(address => mapping (address => uint256))    allowances;     // Allowances index-1 = Owner account   index-2 = spender account
44 
45     //------ TOKEN SPECIFICATION
46 
47     string  public  constant    name       = "IOU Loyalty Exchange Token";
48     string  public  constant    symbol     = "IOUX";
49     uint256 public  constant    decimals   = 18;      // Handle the coin as FIAT (2 decimals). ETH Handles 18 decimal places
50     uint256 public  constant    initSupply       = 800000000 * 10**decimals;        // 10**18 max
51     uint256 public  constant    supplyReserveVal = 600000000 * 10**decimals;          // if quantity => the ##MACRO## addrs "* 10**decimals" 
52 
53     //-----
54 
55     uint256 public              totalSupply;
56     uint256 public              icoSalesSupply   = 0;                   // Needed when burning tokens
57     uint256 public              icoReserveSupply = 0;
58     uint256 public              softCap = 10000000  * 10**decimals;
59     uint256 public              hardCap = 500000000 * 10**decimals;
60 
61     //---------------------------------------------------- smartcontract control
62 
63     uint256 public              icoDeadLine = 1545177600;     // 2018-12-19 00:00 (GMT+0)
64 
65     bool    public              isIcoPaused            = false; 
66     bool    public              isStoppingIcoOnHardCap = false;
67 
68     //--------------------------------------------------------------------------
69 
70     modifier duringIcoOnlyTheOwner()  // if not during the ico : everyone is allowed at anytime
71     { 
72         require( now>icoDeadLine || msg.sender==owner );
73         _;
74     }
75 
76     modifier icoFinished()          { require(now > icoDeadLine);           _; }
77     modifier icoNotFinished()       { require(now <= icoDeadLine);          _; }
78     modifier icoNotPaused()         { require(isIcoPaused==false);          _; }
79     modifier icoPaused()            { require(isIcoPaused==true);           _; }
80     modifier onlyOwner()            { require(msg.sender==owner);           _; }
81     modifier onlyAdmin()            { require(msg.sender==admin);           _; }
82 
83     //----- EVENTS
84 
85     event Transfer(address indexed fromAddr, address indexed toAddr,   uint256 amount);
86     event Approval(address indexed _owner,   address indexed _spender, uint256 amount);
87 
88             //---- extra EVENTS
89 
90     event EventOn_AdminUserChanged(   address oldAdmin,       address newAdmin);
91     event EventOn_OwnershipTransfered(address oldOwner,       address newOwner);
92     event EventOn_AdminUserChange(    address oldAdmin,       address newAdmin);
93     event EventOn_IcoDeadlineChanged( uint256 oldIcoDeadLine, uint256 newIcoDeadline);
94     event EventOn_HardcapChanged(     uint256 hardCap,        uint256 newHardCap);
95     event EventOn_IcoIsNowPaused(       uint8 newPauseStatus);
96     event EventOn_IcoHasRestarted(      uint8 newPauseStatus);
97 
98     //--------------------------------------------------------------------------
99     //--------------------------------------------------------------------------
100     constructor()   public 
101     {
102         owner       = msg.sender;
103         admin       = owner;
104 
105         isIcoPaused = false;
106         //-----
107 
108         balances[owner] = initSupply;   // send the tokens to the owner
109         totalSupply     = initSupply;
110         icoSalesSupply  = totalSupply;   
111 
112         //----- Handling if there is a special maximum amount of tokens to spend during the ICO or not
113 
114         icoSalesSupply   = totalSupply.sub(supplyReserveVal);
115         icoReserveSupply = totalSupply.sub(icoSalesSupply);
116     }
117     //--------------------------------------------------------------------------
118     //--------------------------------------------------------------------------
119     //----- ERC20 FUNCTIONS
120     //--------------------------------------------------------------------------
121     //--------------------------------------------------------------------------
122     function balanceOf(address walletAddress) public constant returns (uint256 balance) 
123     {
124         return balances[walletAddress];
125     }
126     //--------------------------------------------------------------------------
127     function transfer(address toAddr, uint256 amountInWei)  public   duringIcoOnlyTheOwner   returns (bool)     // don't icoNotPaused here. It's a logic issue. 
128     {
129         require(toAddr!=0x0 && toAddr!=msg.sender && amountInWei>0);     // Prevent transfer to 0x0 address and to self, amount must be >0
130 
131         uint256 availableTokens = balances[msg.sender];
132 
133         //----- Checking Token reserve first : if during ICO    
134 
135         if (msg.sender==owner && now <= icoDeadLine)                    // ICO Reserve Supply checking: Don't touch the RESERVE of tokens when owner is selling
136         {
137             assert(amountInWei<=availableTokens);
138 
139             uint256 balanceAfterTransfer = availableTokens.sub(amountInWei);      
140 
141             assert(balanceAfterTransfer >= icoReserveSupply);           // We try to sell more than allowed during an ICO
142         }
143 
144         //-----
145 
146         balances[msg.sender] = balances[msg.sender].sub(amountInWei);
147         balances[toAddr]     = balances[toAddr].add(amountInWei);
148 
149         emit Transfer(msg.sender, toAddr, amountInWei);
150 
151         return true;
152     }
153     //--------------------------------------------------------------------------
154     function allowance(address walletAddress, address spender) public constant returns (uint remaining)
155     {
156         return allowances[walletAddress][spender];
157     }
158     //--------------------------------------------------------------------------
159     function transferFrom(address fromAddr, address toAddr, uint256 amountInWei)  public  returns (bool) 
160     {
161         if (amountInWei <= 0)                                   return false;
162         if (allowances[fromAddr][msg.sender] < amountInWei)     return false;
163         if (balances[fromAddr] < amountInWei)                   return false;
164 
165         balances[fromAddr]               = balances[fromAddr].sub(amountInWei);
166         balances[toAddr]                 = balances[toAddr].add(amountInWei);
167         allowances[fromAddr][msg.sender] = allowances[fromAddr][msg.sender].sub(amountInWei);
168 
169         emit Transfer(fromAddr, toAddr, amountInWei);
170         return true;
171     }
172     //--------------------------------------------------------------------------
173     function approve(address spender, uint256 amountInWei) public returns (bool) 
174     {
175         require((amountInWei == 0) || (allowances[msg.sender][spender] == 0));
176         allowances[msg.sender][spender] = amountInWei;
177         emit Approval(msg.sender, spender, amountInWei);
178 
179         return true;
180     }
181     //--------------------------------------------------------------------------
182     function() public                       
183     {
184         assert(true == false);      // If Ether is sent to this address, don't handle it -> send it back.
185     }
186     //--------------------------------------------------------------------------
187     //--------------------------------------------------------------------------
188     //--------------------------------------------------------------------------
189     function transferOwnership(address newOwner) public onlyOwner               // @param newOwner The address to transfer ownership to.
190     {
191         require(newOwner != address(0));
192 
193         emit EventOn_OwnershipTransfered(owner, newOwner);
194         owner = newOwner;
195     }
196     //--------------------------------------------------------------------------
197     //--------------------------------------------------------------------------
198     //--------------------------------------------------------------------------
199     //--------------------------------------------------------------------------
200     function    changeAdminUser(address newAdminAddress) public onlyOwner
201     {
202         require(newAdminAddress!=0x0);
203 
204         emit EventOn_AdminUserChange(admin, newAdminAddress);
205         admin = newAdminAddress;
206     }
207     //--------------------------------------------------------------------------
208     //--------------------------------------------------------------------------
209     function    changeIcoDeadLine(uint256 newIcoDeadline) public onlyAdmin
210     {
211         require(newIcoDeadline!=0);
212 
213         emit EventOn_IcoDeadlineChanged(icoDeadLine, newIcoDeadline);
214         icoDeadLine = newIcoDeadline;
215     }
216     //--------------------------------------------------------------------------
217     //--------------------------------------------------------------------------
218     //--------------------------------------------------------------------------
219     function    changeHardCap(uint256 newHardCap) public onlyAdmin
220     {
221         require(newHardCap!=0);
222 
223         emit EventOn_HardcapChanged(hardCap, newHardCap);
224         hardCap = newHardCap;
225     }
226     //--------------------------------------------------------------------------
227     function    isHardcapReached()  public view returns(bool)
228     {
229         return (isStoppingIcoOnHardCap && initSupply-balances[owner] > hardCap);
230     }
231     //--------------------------------------------------------------------------
232     //--------------------------------------------------------------------------
233     //--------------------------------------------------------------------------
234     function    pauseICO()  public onlyAdmin
235     {
236         isIcoPaused = true;
237         emit EventOn_IcoIsNowPaused(1);
238     }
239     //--------------------------------------------------------------------------
240     function    unpauseICO()  public onlyAdmin
241     {
242         isIcoPaused = false;
243         emit EventOn_IcoHasRestarted(0);
244     }
245     //--------------------------------------------------------------------------
246     function    isPausedICO() public view     returns(bool)
247     {
248         return (isIcoPaused) ? true : false;
249     }
250     /*--------------------------------------------------------------------------
251     //
252     // When ICO is closed, send the remaining (unsold) tokens to address 0x0
253     // So no one will be able to use it anymore... 
254     // Anyone can check address 0x0, so to proove unsold tokens belong to no one anymore
255     //
256     //--------------------------------------------------------------------------*/
257     function destroyRemainingTokens() public onlyAdmin icoFinished icoNotPaused  returns(uint)
258     {
259         require(msg.sender==owner && now>icoDeadLine);
260 
261         address   toAddr = 0x0000000000000000000000000000000000000000;
262 
263         uint256   amountToBurn = balances[owner];
264 
265         if (amountToBurn > icoReserveSupply)
266         {
267             amountToBurn = amountToBurn.sub(icoReserveSupply);
268         }
269 
270         balances[owner]  = balances[owner].sub(amountToBurn);
271         balances[toAddr] = balances[toAddr].add(amountToBurn);
272 
273         emit Transfer(msg.sender, toAddr, amountToBurn);
274         //Transfer(msg.sender, toAddr, amountToBurn);
275 
276         return 1;
277     }        
278 
279     //--------------------------------------------------------------------------
280     //--------------------------------------------------------------------------
281 
282 }
283 ////////////////////////////////////////////////////////////////////////////////
284 contract    Token  is  ERC20
285 {
286     using SafeMath  for uint256;
287 
288     //-------------------------------------------------------------------------- Constructor
289     constructor()   public 
290     {
291     }
292     //--------------------------------------------------------------------------
293     //--------------------------------------------------------------------------
294     //--------------------------------------------------------------------------
295 }