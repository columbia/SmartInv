1 // SPDX-License-Identifier: UNLICENSED
2 //   _    _ _   _                __ _                            
3 //  | |  (_) | | |              / _(_)                           
4 //  | | ___| |_| |_ ___ _ __   | |_ _ _ __   __ _ _ __   ___ ___ 
5 //  | |/ / | __| __/ _ \ '_ \  |  _| | '_ \ / _` | '_ \ / __/ _ \
6 //  |   <| | |_| ||  __/ | | |_| | | | | | | (_| | | | | (_|  __/
7 //  |_|\_\_|\__|\__\___|_| |_(_)_| |_|_| |_|\__,_|_| |_|\___\___|
8 //
9 //  Kitten.Finance Lending
10 //
11 //  https://Kitten.Finance
12 //  https://kittenswap.org
13 //
14 pragma solidity ^0.6.12;
15 
16 library SafeMath {
17     function add(uint256 a, uint256 b) internal pure returns (uint256) {
18         uint256 c = a + b;
19         require (c >= a, "!!add");
20         return c;
21     }
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         require (b <= a, "!!sub");
24         uint256 c = a - b;
25         return c;
26     }
27     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
28         require (b <= a, errorMessage);
29         uint c = a - b;
30         return c;
31     }    
32     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33         if (a == 0) {
34             return 0;
35         }
36         uint256 c = a * b;
37         require (c / a == b, "!!mul");
38         return c;
39     }
40     function div(uint256 a, uint256 b) internal pure returns (uint256) {
41         require (b > 0, "!!div");
42         uint256 c = a / b;
43         return c;
44     }
45 }
46 
47 ////////////////////////////////////////////////////////////////////////////////
48 
49 interface ERC20
50 {
51     function balanceOf ( address account ) external view returns ( uint256 );
52     function transfer ( address recipient, uint256 amount ) external returns ( bool );
53     function transferFrom ( address sender, address recipient, uint256 amount ) external returns ( bool );
54 }
55 
56 ////////////////////////////////////////////////////////////////////////////////
57 
58 contract KittenLending
59 {
60     using SafeMath for uint;
61 
62     ////////////////////////////////////////////////////////////////////////////////
63     
64     address public govAddr;
65     address public treasuryAddr;
66     uint public treasuryAmtTotal = 0;
67         
68     constructor () public {
69         govAddr = msg.sender;
70         treasuryAddr = msg.sender;
71     }
72     
73     modifier govOnly() {
74     	require (msg.sender == govAddr, "!gov");
75     	_;
76     }
77     
78     function govTransferAddr(address newAddr) external govOnly {
79     	require (newAddr != address(0), "!addr");
80     	govAddr = newAddr;
81     }
82     
83     function govSetTreasury(address newAddr) external govOnly
84     {
85     	require(newAddr != address(0), "!addr");
86     	treasuryAddr = newAddr;
87     }    
88     
89     uint8 public DEFAULT_devFeeBP = 0;
90     
91     function govSet_DEFAULT_devFeeBP(uint8 $DEFAULT_devFeeBP) external govOnly {
92     	DEFAULT_devFeeBP = $DEFAULT_devFeeBP;
93     }
94     
95     function govSet_devFeeBP(uint vaultId, uint8 $devFeeBP) external govOnly {
96     	VAULT[vaultId].devFeeBP = $devFeeBP;
97     }
98     
99     mapping (address => uint) public tokenStatus; // 0 = normal, if >= TOKEN_STATUS_BANNED then banned
100     uint constant TOKEN_STATUS_BANNED = 1e60;
101     uint8 constant VAULT_STATUS_BANNED = 200;
102     
103     function govSet_tokenStatus(address token, uint $tokenStatus) external govOnly {
104     	tokenStatus[token] = $tokenStatus;
105     }
106     
107     function govSet_vaultStatus(uint vaultId, uint8 $vaultStatus) external govOnly {
108     	VAULT[vaultId].vaultStatus = $vaultStatus;
109     }
110     
111     ////////////////////////////////////////////////////////////////////////////////
112 
113     struct VAULT_INFO 
114     {
115         address token;              // underlying token
116 
117         uint32 tEnd;                // timestamp
118         uint128 priceEndScaled;     // scaled by PRICE_SCALE
119         uint24 apyBP;               // APY%% in Basis Points
120         uint8 devFeeBP;             // devFee%% in Basis Points
121         
122         uint8 vaultStatus;          // 0 = new, if >= VAULT_STATUS_BANNED then banned
123         
124         mapping (address => uint) share; // deposit ETH for vaultShare
125         uint shareTotal;
126         
127         mapping (address => uint) tllll; // token locked
128         uint tllllTotal;
129         
130         uint ethTotal;
131     }
132 
133     uint constant PRICE_SCALE = 10 ** 18;
134 
135     VAULT_INFO[] public VAULT;
136     
137     event CREATE_VAULT(address indexed token, uint indexed vaultId, address indexed user, uint32 tEnd, uint128 priceEndScaled, uint24 apyBP);
138 
139     function createVault(address token, uint32 tEnd, uint128 priceEndScaled, uint24 apyBP) external 
140     {
141         VAULT_INFO memory m;
142         require (token != address(0), "!token");
143         require (tokenStatus[token] < TOKEN_STATUS_BANNED, '!tokenBanned');
144         require (tEnd > block.timestamp, "!tEnd");
145         require (priceEndScaled > 0, "!priceEndScaled");
146         require (apyBP > 0, "!apyBP");
147     
148         m.token = token;
149     	m.tEnd = tEnd;
150     	m.priceEndScaled = priceEndScaled;
151         m.apyBP = apyBP;
152 
153     	m.devFeeBP = DEFAULT_devFeeBP;
154     	
155     	if (msg.sender == govAddr) {
156     	    m.vaultStatus = 100;
157     	}
158     	
159     	VAULT.push(m);
160     	
161     	emit CREATE_VAULT(token, VAULT.length - 1, msg.sender, tEnd, priceEndScaled, apyBP);
162     }
163     
164     ////////////////////////////////////////////////////////////////////////////////
165     
166     function vaultCount() external view returns (uint)
167     {
168         return VAULT.length;
169     }
170     
171     function getVaultStatForUser(uint vaultId, address user) external view returns (uint share, uint tllll)
172     {
173         share = VAULT[vaultId].share[user];
174         tllll = VAULT[vaultId].tllll[user];
175     }
176     
177     ////////////////////////////////////////////////////////////////////////////////
178     
179     function getVaultValueInEth(uint vaultId) public view returns (uint)
180     {
181         VAULT_INFO memory m = VAULT[vaultId];
182         
183         uint priceNowScaled;
184         if (block.timestamp >= m.tEnd)
185             priceNowScaled = m.priceEndScaled;
186         else {
187             uint FACTOR = 10**18;
188             priceNowScaled = uint(m.priceEndScaled) * FACTOR / (FACTOR + FACTOR * uint(m.apyBP) * (m.tEnd - block.timestamp) / (365 days) / 10000);
189         }
190         
191         uint ethValue = m.ethTotal;
192         uint tokenValue = (m.tllllTotal).mul(priceNowScaled) / (PRICE_SCALE);
193         
194         return ethValue.add(tokenValue);
195     }
196     
197     function getVaultPriceScaled(uint vaultId) public view returns (uint)
198     {
199         VAULT_INFO memory m = VAULT[vaultId];
200         
201         uint priceNowScaled;
202         if (block.timestamp >= m.tEnd)
203             priceNowScaled = m.priceEndScaled;
204         else {
205             uint FACTOR = 10**18;
206             priceNowScaled = uint(m.priceEndScaled) * FACTOR / (FACTOR + FACTOR * uint(m.apyBP) * (m.tEnd - block.timestamp) / (365 days) / 10000);
207         }
208         
209         return priceNowScaled;
210     }
211     
212     ////////////////////////////////////////////////////////////////////////////////
213     
214     event LOCK_ETH(uint indexed vaultId, address indexed user, uint ethAmt, uint shareAmt);
215     event UNLOCK_ETH(uint indexed vaultId, address indexed user, uint ethAmt, uint shareAmt);
216     
217     function _mintShare(VAULT_INFO storage m, address user, uint mintAmt) internal {
218         m.share[user] = (m.share[user]).add(mintAmt);
219         m.shareTotal = (m.shareTotal).add(mintAmt);        
220     }
221     function _burnShare(VAULT_INFO storage m, address user, uint burnAmt) internal {
222         m.share[user] = (m.share[user]).sub(burnAmt, '!notEnoughShare');
223         m.shareTotal = (m.shareTotal).sub(burnAmt, '!notEnoughShare');        
224     }
225     
226     function _mintTllll(VAULT_INFO storage m, address user, uint mintAmt) internal {
227         m.tllll[user] = (m.tllll[user]).add(mintAmt);
228         m.tllllTotal = (m.tllllTotal).add(mintAmt);        
229     }
230     function _burnTllll(VAULT_INFO storage m, address user, uint burnAmt) internal {
231         m.tllll[user] = (m.tllll[user]).sub(burnAmt, '!notEnoughTokenLocked');
232         m.tllllTotal = (m.tllllTotal).sub(burnAmt, '!notEnoughTokenLocked');        
233     }
234     
235     function _sendEth(VAULT_INFO storage m, address payable user, uint outAmt) internal {
236         m.ethTotal = (m.ethTotal).sub(outAmt, '!notEnoughEthInVault');
237         user.transfer(outAmt);
238     }
239 
240     function lockEth(uint vaultId) external payable // lock ETH for lending, and mint vaultShare
241     {
242         VAULT_INFO storage m = VAULT[vaultId];
243     	require (block.timestamp < m.tEnd, '!vaultEnded');
244 
245         //-------- receive ETH from user --------
246         address user = msg.sender;
247         uint ethInAmt = msg.value;
248         require (ethInAmt > 0, '!ethInAmt');
249         
250         //-------- compute vaultShare mint amt --------
251         uint shareMintAmt = 0;
252         if (m.shareTotal == 0) { 
253             shareMintAmt = ethInAmt; // initial price: 1 share = 1 ETH
254         }
255         else {                
256             shareMintAmt = ethInAmt.mul(m.shareTotal).div(getVaultValueInEth(vaultId));
257         }
258 
259         m.ethTotal = (m.ethTotal).add(ethInAmt); // add ETH after computing shareMintAmt
260         
261         //-------- mint vaultShare to user --------
262         _mintShare(m, user, shareMintAmt);
263         
264         emit LOCK_ETH(vaultId, user, ethInAmt, shareMintAmt);
265     }
266     
267     function unlockEth(uint vaultId, uint shareBurnAmt) external // unlock ETH, and burn vaultShare
268     {
269         VAULT_INFO storage m = VAULT[vaultId];
270     	require (block.timestamp < m.tEnd, '!vaultEnded');        
271 
272         require (shareBurnAmt > 0, '!shareBurnAmt');
273         address payable user = msg.sender;
274         
275         //-------- compute ETH out amt --------
276         uint ethOutAmt = shareBurnAmt.mul(getVaultValueInEth(vaultId)).div(m.shareTotal);
277 
278         //-------- burn vaultShare from user --------
279         _burnShare(m, user, shareBurnAmt);
280 
281         //-------- send ETH to user --------
282         _sendEth(m, user, ethOutAmt);
283         emit UNLOCK_ETH(vaultId, user, ethOutAmt, shareBurnAmt);
284     }
285     
286     ////////////////////////////////////////////////////////////////////////////////
287     
288     event LOCK_TOKEN(uint indexed vaultId, address indexed user, uint tokenAmt, uint ethAmt);
289     event UNLOCK_TOKEN(uint indexed vaultId, address indexed user, uint tokenAmt, uint ethAmt); 
290     
291     function lockToken(uint vaultId, uint tokenInAmt) external // lock TOKEN to borrow ETH
292     {
293         VAULT_INFO storage m = VAULT[vaultId];
294     	require (block.timestamp < m.tEnd, '!vaultEnded');        
295 
296     	require (m.vaultStatus < VAULT_STATUS_BANNED, '!vaultBanned');
297     	require (tokenStatus[m.token] < TOKEN_STATUS_BANNED, '!tokenBanned');
298 
299         require (tokenInAmt > 0, '!tokenInAmt');
300         address payable user = msg.sender;
301         
302         //-------- compute ETH out amt --------
303         uint ethOutAmt = tokenInAmt.mul(getVaultPriceScaled(vaultId)) / (PRICE_SCALE);
304         
305         if (m.devFeeBP > 0) 
306         {
307             uint treasuryAmt = ethOutAmt.mul(uint(m.devFeeBP)) / (10000);
308             treasuryAmtTotal = treasuryAmtTotal.add(treasuryAmt);
309             
310             ethOutAmt = ethOutAmt.sub(treasuryAmt);
311             m.ethTotal = (m.ethTotal).sub(treasuryAmt, '!ethInVault'); // remove treasuryAmt
312         }
313 
314         //--------  send TOKEN to contract --------
315         ERC20(m.token).transferFrom(user, address(this), tokenInAmt);
316         _mintTllll(m, user, tokenInAmt);
317 
318         //-------- send ETH to user --------
319         _sendEth(m, user, ethOutAmt);
320         emit LOCK_TOKEN(vaultId, user, tokenInAmt, ethOutAmt);
321     }
322     
323     function unlockToken(uint vaultId) external payable // payback ETH to unlock TOKEN
324     {
325         VAULT_INFO storage m = VAULT[vaultId];
326     	require (block.timestamp < m.tEnd, '!vaultEnded');         
327 
328         //-------- receive ETH from user --------
329         uint ethInAmt = msg.value;
330         require (ethInAmt > 0, '!ethInAmt');
331         
332         uint ethReturnAmt = 0;
333         address payable user = msg.sender;
334         
335         //-------- compute LIQUID out amt --------
336         uint priceScaled = getVaultPriceScaled(vaultId);
337 
338         uint tokenOutAmt = ethInAmt.mul(PRICE_SCALE).div(priceScaled);
339         if (tokenOutAmt > m.tllll[user])
340         {
341             tokenOutAmt = m.tllll[user];
342             ethReturnAmt = ethInAmt.sub(
343                     tokenOutAmt.mul(priceScaled) / (PRICE_SCALE)
344                 );
345         }
346         
347         //-------- send TOKEN to user --------
348         _burnTllll(m, user, tokenOutAmt);
349         ERC20(m.token).transfer(user, tokenOutAmt);
350         
351         //-------- return extra ETH to user --------
352         m.ethTotal = (m.ethTotal).add(ethInAmt); // add input ETH first
353         if (ethReturnAmt > 0)
354             _sendEth(m, user, ethReturnAmt);
355         emit UNLOCK_TOKEN(vaultId, user, tokenOutAmt, ethInAmt.sub(ethReturnAmt));
356     }
357     
358     ////////////////////////////////////////////////////////////////////////////////
359     
360     event EXIT_SHARE(uint indexed vaultId, address indexed user, uint shareAmt);
361     
362     function exitShare(uint vaultId, address payable user) external // exit vaultShare after vault is closed
363     {
364         VAULT_INFO storage m = VAULT[vaultId];
365     	require (block.timestamp > m.tEnd, '!vaultStillOpen');
366 
367     	//-------- compute ETH & TOKEN out amt --------
368     	uint userShareAmt = m.share[user];
369     	require (userShareAmt > 0, '!userShareAmt');
370 
371     	uint ethOutAmt = (m.ethTotal).mul(userShareAmt).div(m.shareTotal);
372     	uint tokenOutAmt = (m.tllllTotal).mul(userShareAmt).div(m.shareTotal);
373 
374         //-------- burn vaultShare from user --------
375         _burnShare(m, user, userShareAmt);
376 
377         //-------- send ETH & TOKEN to user --------
378         if (tokenOutAmt > 0) {
379             m.tllllTotal = (m.tllllTotal).sub(tokenOutAmt); // remove tllll
380             ERC20(m.token).transfer(user, tokenOutAmt);
381         }
382         if (ethOutAmt > 0)
383             _sendEth(m, user, ethOutAmt);
384         
385         emit EXIT_SHARE(vaultId, user, userShareAmt);
386     }
387     
388     ////////////////////////////////////////////////////////////////////////////////
389 
390     function treasurySend(uint amt) external
391     {
392         treasuryAmtTotal = treasuryAmtTotal.sub(amt);
393         
394         address payable _treasuryAddr = address(uint160(treasuryAddr));
395         _treasuryAddr.transfer(amt);
396     }    
397 }