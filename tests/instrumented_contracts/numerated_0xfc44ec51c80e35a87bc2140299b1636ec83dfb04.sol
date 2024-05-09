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
46 contract BasicToken {
47     string private token_name;
48     string private token_symbol;
49     uint256 private token_decimals;
50 
51     uint256 private total_supply;
52     uint256 private remaining_supply;
53 
54     mapping (address => uint256) private balance_of;
55     mapping (address => mapping(address => uint256)) private allowance_of;
56 
57     event Transfer(address indexed from, address indexed to, uint256 value);
58     event Approve(address indexed target, address indexed spender, uint256 value);
59 
60     function BasicToken (
61         string tokenName,
62         string tokenSymbol,
63         uint256 tokenDecimals,
64         uint256 tokenSupply
65     ) public {
66         token_name = tokenName;
67         token_symbol = tokenSymbol;
68         token_decimals = tokenDecimals;
69         total_supply = tokenSupply * (10 ** uint256(token_decimals));
70         remaining_supply = total_supply;
71     }
72 
73     function name() public view returns (string) {
74         return token_name;
75     }
76 
77     function symbol() public view returns (string) {
78         return token_symbol;
79     }
80 
81     function decimals() public view returns (uint256) {
82         return token_decimals;
83     }
84 
85     function totalSupply() public view returns (uint256) {
86         return total_supply;
87     }
88 
89     function remainingSupply() internal view returns (uint256) {
90         return remaining_supply;
91     }
92 
93     function balanceOf(
94         address client_address
95     ) public view returns (uint256) {
96         return balance_of[client_address];
97     }
98 
99     function setBalance(
100         address client_address,
101         uint256 value
102     ) internal returns (bool) {
103         require(client_address != address(0));
104         balance_of[client_address] = value;
105     }
106 
107     function allowance(
108         address target_address,
109         address spender_address
110     ) public view returns (uint256) {
111         return allowance_of[target_address][spender_address];
112     }
113 
114     function approve(
115         address spender_address,
116         uint256 value
117     ) public returns (bool) {
118         require(value >= 0);
119         require(msg.sender != address(0));
120         require(spender_address != address(0));
121 
122         setApprove(msg.sender, spender_address, value);
123         Approve(msg.sender, spender_address, value);
124         return true;
125     }
126     
127     function setApprove(
128         address target_address,
129         address spender_address,
130         uint256 value
131     ) internal returns (bool) {
132         require(value >= 0);
133         require(msg.sender != address(0));
134         require(spender_address != address(0));
135 
136         allowance_of[target_address][spender_address] = value;
137         return true;
138     }
139 
140     function changeTokenName(
141         string newTokenName
142     ) internal returns (bool) {
143         token_name = newTokenName;
144         return true;
145     }
146 
147     function changeTokenSymbol(
148         string newTokenSymbol
149     ) internal returns (bool) {
150         token_symbol = newTokenSymbol;
151         return true;
152     }
153 
154     function changeTokenDecimals(
155         uint256 newTokenDecimals
156     ) internal returns (bool) {
157         token_decimals = newTokenDecimals;
158         return true;
159     }
160 
161     function changeTotalSupply(
162         uint256 newTotalSupply
163     ) internal returns (bool) {
164         total_supply = newTotalSupply;
165         return true;
166     }
167 
168     function changeRemainingSupply(
169         uint256 newRemainingSupply
170     ) internal returns (bool) {
171         remaining_supply = newRemainingSupply;
172         return true;
173     }
174 }
175 
176 
177 contract VoltOwned {
178     mapping (address => uint) private voltOwners;
179     address[] private ownerList;
180 
181     mapping (address => uint256) private voltFreeze;
182 
183     modifier onlyOwner {
184         require(voltOwners[msg.sender] == 99);
185         _;
186     }
187 
188     modifier noFreeze {
189         require(now >= voltFreeze[msg.sender]);
190         _;
191     }
192 
193     function VoltOwned(address firstOwner) public {
194         voltOwners[firstOwner] = 99;
195         ownerList.push(firstOwner);
196     }
197 
198     function isOwner(address who) internal view returns (bool) {
199         if (voltOwners[who] == 99) {
200             return true;
201         } else {
202             return false;
203         }
204     }
205 
206     function addOwner(address newVoltOwnerAddress) public onlyOwner noFreeze {
207         require(newVoltOwnerAddress != address(0));
208         voltOwners[newVoltOwnerAddress] = 99;
209         ownerList.push(newVoltOwnerAddress);
210     }
211 
212     function removeOwner(address removeVoltOwnerAddress) public onlyOwner noFreeze {
213         require(removeVoltOwnerAddress != address(0));
214         require(ownerList.length > 1);
215 
216         voltOwners[removeVoltOwnerAddress] = 0;
217         for (uint256 i = 0; i != ownerList.length; i++) {
218             if (removeVoltOwnerAddress == ownerList[i]) {
219                 delete ownerList[i];
220                 break;
221             }
222         }
223     }
224 
225     function getOwners() public onlyOwner noFreeze returns (address[]) {
226         return ownerList;
227     }
228 
229     function isFreeze(address who) internal view returns (bool) {
230         if (now >= voltFreeze[who]) {
231             return false;
232         } else {
233             return true;
234         }
235     }
236 
237     function setFreeze(
238         address freezeAddress,
239         uint256 timestamp
240     ) public onlyOwner noFreeze returns (bool) {
241         require(freezeAddress != address(0));
242         voltFreeze[freezeAddress] = timestamp;
243     }
244 
245     function getFreezeTimestamp(
246         address who
247     ) public onlyOwner noFreeze returns (uint256) {
248         return voltFreeze[who];
249     }
250 }
251 
252 contract VoltToken is BasicToken, VoltOwned {
253     using SafeMath for uint256;
254 
255     bool private mintStatus;
256 
257     event Deposit(address indexed from, address indexed to, uint256 value);
258     event Mint(address indexed to, uint256 value);
259     event Burn(address indexed target, uint256 value);
260 
261     function VoltToken () public BasicToken (
262         "VOLT", "ACDC", 18, 4000000000
263     ) VoltOwned(
264         msg.sender
265     ) {
266         mintStatus = true;
267     }
268 
269     modifier canMint {
270         require(mintStatus == true);
271         _;
272     }
273 
274     function mint(
275         address to,
276         uint256 value,
277         uint256 freezeTimestamp
278     ) public onlyOwner noFreeze canMint {
279         uint256 ts = totalSupply();
280         uint256 rs = remainingSupply();
281         require(ts >= rs);
282 
283         superMint(to, value);
284         setFreeze(to, freezeTimestamp);
285     }
286 
287     function superMint(address to, uint256 value) public onlyOwner noFreeze {
288         uint256 rs = remainingSupply();
289         require(rs >= value);
290 
291         uint256 currentBalance = balanceOf(to);
292         setBalance(to, currentBalance.add(value));
293         setRemainingSupply(rs.sub(value));
294         Transfer(0x0, to, value);
295         Mint(to, value);
296     }
297 
298     function mintOpen() public onlyOwner noFreeze returns (bool) {
299         require(mintStatus == false);
300         mintStatus = true;
301         return true;
302     }
303 
304     function mintClose() public onlyOwner noFreeze returns (bool) {
305         require(mintStatus == true);
306         mintStatus = false;
307         return true;
308     }
309 
310     function transfer(
311         address to,
312         uint256 value
313     ) public noFreeze returns (bool) {
314         require(value > 0);
315         require(msg.sender != address(0));
316         require(to != address(0));
317 
318         require(balanceOf(msg.sender) >= value);
319         require(balanceOf(to).add(value) >= balanceOf(to));
320 
321         voltTransfer(msg.sender, to, value);
322         return true;
323     }
324 
325     function transferFrom(
326         address from,
327         address to,
328         uint256 value
329     ) public noFreeze returns(bool) {
330         require(value > 0);
331         require(msg.sender != address(0));
332         require(from != address(0));
333         require(to != address(0));
334 
335         require(isFreeze(from) == false);
336         require(allowance(from, msg.sender) >= value);
337         require(balanceOf(from) >= value);
338         require(balanceOf(to).add(value) >= balanceOf(to));
339 
340         voltTransfer(from, to, value);
341 
342         uint256 remaining = allowance(from, msg.sender).sub(value);
343         setApprove(from, msg.sender, remaining);
344         return true;
345     }
346 
347     function voltTransfer(
348         address from,
349         address to,
350         uint256 value
351     ) private noFreeze returns (bool) {
352         uint256 preBalance = balanceOf(from);
353         setBalance(from, balanceOf(from).sub(value));
354         setBalance(to, balanceOf(to).add(value));
355         Transfer(from, to, value);
356         assert(balanceOf(from).add(value) == preBalance);
357         return true;
358     }
359 
360     function setTokenName(
361         string newTokenName
362     ) public onlyOwner noFreeze returns (bool) {
363         return changeTokenName(newTokenName);
364     }
365 
366     function setTokenSymbol(
367         string newTokenSymbol
368     ) public onlyOwner noFreeze returns (bool) {
369         return changeTokenSymbol(newTokenSymbol);
370     }
371 
372     function setTotalSupply(
373         uint256 newTotalSupply
374     ) public onlyOwner noFreeze returns (bool) {
375         return changeTotalSupply(newTotalSupply);
376     }
377 
378     function setRemainingSupply(
379         uint256 newRemainingSupply
380     ) public onlyOwner noFreeze returns (bool) {
381         return changeRemainingSupply(newRemainingSupply);
382     }
383 
384     function getRemainingSupply() public onlyOwner noFreeze returns (uint256) {
385         return remainingSupply();
386     }
387 }