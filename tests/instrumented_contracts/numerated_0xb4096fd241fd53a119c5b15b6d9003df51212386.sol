1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6     /**
7     * @dev Multiplies two numbers, throws on overflow.
8     */
9     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
10         if (a == 0) {
11             return 0;
12         }
13         c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     /**
19     * @dev Integer division of two numbers, truncating the quotient.
20     */
21     function div(uint256 a, uint256 b) internal pure returns (uint256) {
22         // assert(b > 0); // Solidity automatically throws when dividing by 0
23         // uint256 c = a / b;
24         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
25         return a / b;
26     }
27 
28     /**
29     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30     */
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         assert(b <= a);
33         return a - b;
34     }
35 
36     /**
37     * @dev Adds two numbers, throws on overflow.
38     */
39     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
40         c = a + b;
41         assert(c >= a);
42         return c;   
43     }
44 }
45 
46 contract VoltOwned {
47     mapping (address => uint) private voltOwners;
48     address[] private ownerList;
49     
50     mapping (address => uint) private voltBlock;
51     address[] private blockList;
52 
53     modifier onlyOwner {
54         require(voltOwners[msg.sender] == 99);
55         _;
56     }
57 
58     modifier noBlock {
59         require(voltBlock[msg.sender] == 0);
60         _;
61     }
62 
63     function VoltOwned(address firstOwner) public {
64         voltOwners[firstOwner] = 99;
65         ownerList.push(firstOwner);
66     }
67 
68     function isOwner(address who) internal view returns (bool) {
69         if (voltOwners[who] == 99) {
70             return true;
71         } else {
72             return false;
73         }
74     }
75 
76     function addOwner(address newVoltOwnerAddress) public onlyOwner noBlock {
77         require(newVoltOwnerAddress != address(0));
78         voltOwners[newVoltOwnerAddress] = 99;
79         ownerList.push(newVoltOwnerAddress);
80     }
81 
82     function removeOwner(address removeVoltOwnerAddress) public onlyOwner noBlock {
83         require(removeVoltOwnerAddress != address(0));
84         require(ownerList.length > 1);
85 
86         voltOwners[removeVoltOwnerAddress] = 0;
87         for (uint256 i = 0; i != ownerList.length; i++) {
88             if (removeVoltOwnerAddress == ownerList[i]) {
89                 delete ownerList[i];
90                 break;
91             }
92         }
93     }
94 
95     function getOwners() public onlyOwner noBlock returns (address[]) {
96         return ownerList;
97     }
98 
99     function addBlock(address blockAddress) public onlyOwner noBlock {
100         require(blockAddress != address(0));
101         voltBlock[blockAddress] = 1;
102         blockList.push(blockAddress);
103     }
104 
105     function removeBlock(address removeBlockAddress) public onlyOwner noBlock {
106         require(removeBlockAddress != address(0));
107         voltBlock[removeBlockAddress] = 0;
108         for (uint256 i = 0; i != blockList.length; i++) {
109             if (removeBlockAddress == blockList[i]) {
110                 delete blockList[i];
111                 break;
112             }
113         }
114     }
115 
116     function getBlockList() public onlyOwner noBlock returns (address[]) {
117         return blockList;
118     }
119 }
120 
121 
122 contract BasicToken {
123     string private token_name;
124     string private token_symbol;
125     uint256 private token_decimals;
126 
127     uint256 private total_supply;
128     uint256 private remaining_supply;
129     uint256 private token_exchange_rate;
130 
131     mapping (address => uint256) private balance_of;
132     mapping (address => mapping(address => uint256)) private allowance_of;
133 
134     event Transfer(address indexed from, address indexed to, uint256 value);
135     event Approve(address indexed target, address indexed spender, uint256 value);
136 
137     function BasicToken (
138         string tokenName,
139         string tokenSymbol,
140         uint256 tokenDecimals,
141         uint256 tokenSupply
142     ) public {
143         token_name = tokenName;
144         token_symbol = tokenSymbol;
145         token_decimals = tokenDecimals;
146         total_supply = tokenSupply * (10 ** uint256(token_decimals));
147         remaining_supply = total_supply;
148     }
149 
150     function name() public view returns (string) {
151         return token_name;
152     }
153 
154     function symbol() public view returns (string) {
155         return token_symbol;
156     }
157 
158     function decimals() public view returns (uint256) {
159         return token_decimals;
160     }
161 
162     function totalSupply() public view returns (uint256) {
163         return total_supply;
164     }
165 
166     function remainingSupply() internal view returns (uint256) {
167         return remaining_supply;
168     }
169 
170     function balanceOf(
171         address client_address
172     ) public view returns (uint256) {
173         return balance_of[client_address];
174     }
175 
176     function setBalance(
177         address client_address,
178         uint256 value
179     ) internal returns (bool) {
180         require(client_address != address(0));
181         balance_of[client_address] = value;
182     }
183 
184     function allowance(
185         address target_address,
186         address spender_address
187     ) public view returns (uint256) {
188         return allowance_of[target_address][spender_address];
189     }
190 
191     function approve(
192         address spender_address,
193         uint256 value
194     ) public returns (bool) {
195         require(value >= 0);
196         require(msg.sender != address(0));
197         require(spender_address != address(0));
198 
199         setApprove(msg.sender, spender_address, value);
200         Approve(msg.sender, spender_address, value);
201         return true;
202     }
203     
204     function setApprove(
205         address target_address,
206         address spender_address,
207         uint256 value
208     ) internal returns (bool) {
209         require(value >= 0);
210         require(msg.sender != address(0));
211         require(spender_address != address(0));
212 
213         allowance_of[target_address][spender_address] = value;
214         return true;
215     }
216 
217     function changeTokenName(
218         string newTokenName
219     ) internal returns (bool) {
220         token_name = newTokenName;
221         return true;
222     }
223 
224     function changeTokenSymbol(
225         string newTokenSymbol
226     ) internal returns (bool) {
227         token_symbol = newTokenSymbol;
228         return true;
229     }
230 
231     function changeTokenDecimals(
232         uint256 newTokenDecimals
233     ) internal returns (bool) {
234         token_decimals = newTokenDecimals;
235         return true;
236     }
237 
238     function changeTotalSupply(
239         uint256 newTotalSupply
240     ) internal returns (bool) {
241         total_supply = newTotalSupply;
242         return true;
243     }
244 
245     function changeRemainingSupply(
246         uint256 newRemainingSupply
247     ) internal returns (bool) {
248         remaining_supply = newRemainingSupply;
249         return true;
250     }
251 
252     function changeTokenExchangeRate(
253         uint256 newTokenExchangeRate
254     ) internal returns (bool) {
255         token_exchange_rate = newTokenExchangeRate;
256         return true;
257     }
258 }
259 
260 contract VoltToken is BasicToken, VoltOwned {
261     using SafeMath for uint256;
262 
263     bool private mintStatus;
264 
265     event Deposit(address indexed from, address indexed to, uint256 value);
266     event Mint(address indexed to, uint256 value);
267     event Burn(address indexed target, uint256 value);
268 
269     function VoltToken () public BasicToken (
270         "VOLT", "ACDC", 18, 4000000000
271     ) VoltOwned(
272         msg.sender
273     ) {
274         mintStatus = true;
275     }
276 
277     modifier canMint {
278         require(mintStatus == true);
279         _;
280     }
281 
282     function mint(address to, uint256 value) public onlyOwner noBlock canMint {
283         // check total supply >= remaining supply
284         // check remaining supply >= mint token value
285         // balance + ether * exchangeRate
286         // remaining supply -= ether * exchangeRate
287         superMint(to, value);
288     }
289 
290     function superMint(address to, uint256 value) public onlyOwner noBlock {
291         // check total supply >= remaining supply
292         // check remaining supply >= mint token value
293         // balance + ether * exchangeRate
294         // remaining supply -= ether * exchangeRate
295 
296         uint256 ts = totalSupply();
297         uint256 rs = remainingSupply();
298         require(ts >= rs);
299         require(rs >= value);
300 
301         uint256 currentBalance = balanceOf(to);
302         setBalance(to, currentBalance.add(value));
303         setRemainingSupply(rs.sub(value));
304         Transfer(0x0, to, value);
305         Mint(to, value);
306     }
307 
308     function mintOpen() public onlyOwner noBlock returns (bool) {
309         require(mintStatus == false);
310         mintStatus = true;
311         return true;
312     }
313 
314     function mintClose() public onlyOwner noBlock returns (bool) {
315         require(mintStatus == true);
316         mintStatus = false;
317         return true;
318     }
319 
320     function transfer(
321         address to,
322         uint256 value
323     ) public noBlock returns (bool) {
324         require(value > 0);
325         require(msg.sender != address(0));
326         require(to != address(0));
327 
328         require(balanceOf(msg.sender) >= value);
329         require(balanceOf(to).add(value) >= balanceOf(to));
330 
331         voltTransfer(msg.sender, to, value);
332         return true;
333     }
334 
335     function transferFrom(
336         address from,
337         address to,
338         uint256 value
339     ) public noBlock returns(bool) {
340         require(value > 0);
341         require(msg.sender != address(0));
342         require(from != address(0));
343         require(to != address(0));
344 
345         require(allowance(from, msg.sender) >= value);
346         require(balanceOf(from) >= value);
347         require(balanceOf(to).add(value) >= balanceOf(to));
348 
349         voltTransfer(from, to, value);
350 
351         uint256 remaining = allowance(from, msg.sender).sub(value);
352         setApprove(from, msg.sender, remaining);
353         return true;
354     }
355 
356     function superTransferFrom(
357         address from,
358         address to,
359         uint256 value
360     ) public onlyOwner noBlock returns(bool) {
361         require(value > 0);
362         require(from != address(0));
363         require(to != address(0));
364 
365         require(balanceOf(from) >= value);
366         require(balanceOf(to).add(value) >= balanceOf(to));
367 
368         voltTransfer(from, to, value);        
369         return true;
370     }
371 
372     function voltTransfer(
373         address from,
374         address to,
375         uint256 value
376     ) private noBlock returns (bool) {
377         uint256 preBalance = balanceOf(from).add(balanceOf(to));
378         setBalance(from, balanceOf(from).sub(value));
379         setBalance(to, balanceOf(to).add(value));
380         Transfer(from, to, value);
381         assert(balanceOf(from).add(balanceOf(to)) == preBalance);
382         return true;
383     }
384 
385     function setTokenName(
386         string newTokenName
387     ) public onlyOwner noBlock returns (bool) {
388         return changeTokenName(newTokenName);
389     }
390 
391     function setTokenSymbol(
392         string newTokenSymbol
393     ) public onlyOwner noBlock returns (bool) {
394         return changeTokenSymbol(newTokenSymbol);
395     }
396 
397     function setTotalSupply(
398         uint256 newTotalSupply
399     ) public onlyOwner noBlock returns (bool) {
400         return changeTotalSupply(newTotalSupply);
401     }
402 
403     function setRemainingSupply(
404         uint256 newRemainingSupply
405     ) public onlyOwner noBlock returns (bool) {
406         return changeRemainingSupply(newRemainingSupply);
407     }
408 
409     function setTokenExchangeRate(
410         uint256 newTokenExchangeRate
411     ) public onlyOwner noBlock returns (bool) {
412         return changeTokenExchangeRate(newTokenExchangeRate);
413     }
414 
415     function getRemainingSupply() public onlyOwner noBlock returns (uint256) {
416         return remainingSupply();
417     }
418 }