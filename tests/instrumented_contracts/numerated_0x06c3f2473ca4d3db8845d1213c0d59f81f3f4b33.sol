1 // SPDX-License-Identifier: MIT
2 // # Runes.sol
3 // This is a ERC-20 token that is ONLY meant to be used as a extension for the Mysterious World NFT Project
4 // The only use case for this token is to be used to interact with The Mysterious World.
5 // This token has no monetary value associated to it.
6 // Read more at https://www.themysterious.world/utility
7 
8 pragma solidity ^0.8.0;
9 
10 interface IERC20 {
11     function totalSupply() external view returns (uint256);
12     function balanceOf(address account) external view returns (uint256);
13     function transfer(address recipient, uint256 amount) external returns (bool);
14     function allowance(address owner, address spender) external view returns (uint256);
15     function approve(address spender, uint256 amount) external returns (bool);
16     function transferFrom(
17         address sender,
18         address recipient,
19         uint256 amount
20     ) external returns (bool);
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 interface IERC20Metadata is IERC20 {
26     function name() external view returns (string memory);
27     function symbol() external view returns (string memory);
28     function decimals() external view returns (uint8);
29 }
30 
31 abstract contract Context {
32     function _msgSender() internal view virtual returns (address) {
33         return msg.sender;
34     }
35 
36     function _msgData() internal view virtual returns (bytes calldata) {
37         return msg.data;
38     }
39 }
40 
41 contract ERC20 is Context, IERC20, IERC20Metadata {
42     mapping(address => uint256) private _balances;
43 
44     mapping(address => mapping(address => uint256)) private _allowances;
45 
46     uint256 private _totalSupply;
47 
48     string private _name;
49     string private _symbol;
50 
51     constructor(string memory name_, string memory symbol_) {
52         _name = name_;
53         _symbol = symbol_;
54     }
55 
56     function name() public view virtual override returns (string memory) {
57         return _name;
58     }
59 
60     function symbol() public view virtual override returns (string memory) {
61         return _symbol;
62     }
63 
64     function decimals() public view virtual override returns (uint8) {
65         return 18;
66     }
67 
68     function totalSupply() public view virtual override returns (uint256) {
69         return _totalSupply;
70     }
71 
72     function balanceOf(address account) public view virtual override returns (uint256) {
73         return _balances[account];
74     }
75 
76     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
77         _transfer(_msgSender(), recipient, amount);
78         return true;
79     }
80 
81     function allowance(address owner, address spender) public view virtual override returns (uint256) {
82         return _allowances[owner][spender];
83     }
84 
85     function approve(address spender, uint256 amount) public virtual override returns (bool) {
86         _approve(_msgSender(), spender, amount);
87         return true;
88     }
89 
90     function transferFrom(
91         address sender,
92         address recipient,
93         uint256 amount
94     ) public virtual override returns (bool) {
95         _transfer(sender, recipient, amount);
96 
97         uint256 currentAllowance = _allowances[sender][_msgSender()];
98         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
99         unchecked {
100             _approve(sender, _msgSender(), currentAllowance - amount);
101         }
102 
103         return true;
104     }
105 
106     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
107         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
108         return true;
109     }
110 
111     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
112         uint256 currentAllowance = _allowances[_msgSender()][spender];
113         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
114         unchecked {
115             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
116         }
117 
118         return true;
119     }
120 
121     function _transfer(
122         address sender,
123         address recipient,
124         uint256 amount
125     ) internal virtual {
126         require(sender != address(0), "ERC20: transfer from the zero address");
127         require(recipient != address(0), "ERC20: transfer to the zero address");
128 
129         _beforeTokenTransfer(sender, recipient, amount);
130 
131         uint256 senderBalance = _balances[sender];
132         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
133         unchecked {
134             _balances[sender] = senderBalance - amount;
135         }
136         _balances[recipient] += amount;
137 
138         emit Transfer(sender, recipient, amount);
139 
140         _afterTokenTransfer(sender, recipient, amount);
141     }
142 
143     function _mint(address account, uint256 amount) internal virtual {
144         require(account != address(0), "ERC20: mint to the zero address");
145 
146         _beforeTokenTransfer(address(0), account, amount);
147 
148         _totalSupply += amount;
149         _balances[account] += amount;
150         emit Transfer(address(0), account, amount);
151 
152         _afterTokenTransfer(address(0), account, amount);
153     }
154 
155     function _burn(address account, uint256 amount) internal virtual {
156         require(account != address(0), "ERC20: burn from the zero address");
157 
158         _beforeTokenTransfer(account, address(0), amount);
159 
160         uint256 accountBalance = _balances[account];
161         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
162         unchecked {
163             _balances[account] = accountBalance - amount;
164         }
165         _totalSupply -= amount;
166 
167         emit Transfer(account, address(0), amount);
168 
169         _afterTokenTransfer(account, address(0), amount);
170     }
171 
172     function _approve(
173         address owner,
174         address spender,
175         uint256 amount
176     ) internal virtual {
177         require(owner != address(0), "ERC20: approve from the zero address");
178         require(spender != address(0), "ERC20: approve to the zero address");
179 
180         _allowances[owner][spender] = amount;
181         emit Approval(owner, spender, amount);
182     }
183 
184     function _beforeTokenTransfer(
185         address from,
186         address to,
187         uint256 amount
188     ) internal virtual {}
189 
190     function _afterTokenTransfer(
191         address from,
192         address to,
193         uint256 amount
194     ) internal virtual {}
195 }
196 
197 abstract contract Ownable is Context {
198     address private _owner;
199 
200     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
201 
202     constructor() {
203         _setOwner(_msgSender());
204     }
205 
206     function owner() public view virtual returns (address) {
207         return _owner;
208     }
209 
210     modifier onlyOwner() {
211         require(owner() == _msgSender(), "Ownable: caller is not the owner");
212         _;
213     }
214 
215     function renounceOwnership() public virtual onlyOwner {
216         _setOwner(address(0));
217     }
218 
219     function transferOwnership(address newOwner) public virtual onlyOwner {
220         require(newOwner != address(0), "Ownable: new owner is the zero address");
221         _setOwner(newOwner);
222     }
223 
224     function _setOwner(address newOwner) private {
225         address oldOwner = _owner;
226         _owner = newOwner;
227         emit OwnershipTransferred(oldOwner, newOwner);
228     }
229 }
230 
231 // The interface is used so we can get the balance of each holder
232 interface TheMysteriousWorld {
233     function balanceOf(address inhabitant) external view returns(uint256);
234     function ritualWallet() external view returns(address);
235 }
236 
237 /*
238  * 888d888888  88888888b.  .d88b. .d8888b  
239  * 888P"  888  888888 "88bd8P  Y8b88K      
240  * 888    888  888888  88888888888"Y8888b. 
241  * 888    Y88b 888888  888Y8b.         X88 
242  * 888     "Y88888888  888 "Y8888  88888P' 
243  */
244 contract Runes is ERC20, Ownable {
245     TheMysteriousWorld public mysteriousworld;
246 
247     uint256 public deployedStamp       = 0; // this is used to calculate the amount of $RUNES a user has from the current block.timestamp
248     uint256 public runesPerDay         = 10 ether; // this ends up being 25 $RUNES per day. this might change in the future depending on how the collection grows overtime.
249     bool    public allowRuneCollecting = false; // this lets you claim your $RUNES from the contract to the wallet
250 
251     mapping(address => uint256) public runesObtained; // this tracks how much $RUNES each address earned
252     mapping(address => uint256) public lastTimeCollectedRunes; // this sets the block.timestamp to the address so it subtracts the timestamp from the pending rewards
253     mapping(address => bool)    public contractWallets; // these are used to interact with the burning mechanisms of the contract - these will only be set to contracts related to The Mysterious World
254 
255     constructor() ERC20("Runes", "Runes") {
256         deployedStamp = block.timestamp;
257     }
258 
259     /*
260      * # onlyContractWallets
261      * blocks anyone from accessing it but contract wallets
262      */
263     modifier onlyContractWallets() {
264         require(contractWallets[msg.sender], "You angered the gods!");
265         _;
266     }
267 
268     /*
269      * # onlyWhenCollectingIsEnabled
270      * blocks anyone from accessing functions that require allowRuneCollecting
271      */
272     modifier onlyWhenCollectingIsEnabled() {
273         require(allowRuneCollecting, "You angered the gods!");
274         _;
275     }
276 
277     /*
278      * # setRuneCollecting
279      * enables or disables users to withdraw their runes - should only be called once unless the gods intended otherwise
280      */
281     function setRuneCollecting(bool newState) public payable onlyOwner {
282         allowRuneCollecting = newState;
283     }
284 
285     /*
286      * # setDeployedStamp
287      * sets the timestamp for when the $RUNES should start being generated
288      */
289     function setDeployedStamp(bool forced, uint256 stamp) public payable onlyOwner {
290         if (forced) {
291             deployedStamp = stamp;
292         } else {
293             deployedStamp = block.timestamp;
294         }
295     }
296 
297     /*
298      * # setRunesPerDay
299      * incase we want to change the amount gained per day, the gods can set it here
300      */
301     function setRunesPerDay(uint256 newRunesPerDay) public payable onlyOwner {
302         runesPerDay = newRunesPerDay;
303     }
304 
305     /*
306      * # setMysteriousWorldContract
307      * sets the address to the deployed Mysterious World contract
308      */
309     function setMysteriousWorldContract(address contractAddress) public payable onlyOwner {
310         mysteriousworld = TheMysteriousWorld(contractAddress);
311     }
312 
313     /*
314      * # setContractWallets
315      * enables or disables a contract wallet from interacting with the burn mechanics of the contract
316      */
317     function setContractWallets(address contractAddress, bool newState) public payable onlyOwner {
318         contractWallets[contractAddress] = newState;
319     }
320 
321     /*
322      * # getPendingRunes
323      * calculates the runes a inhabitant has from the last time they claimed and the deployedStamp time
324      */
325     function getPendingRunes(address inhabitant) internal view returns(uint256) {
326         uint256 sumOfRunes = mysteriousworld.balanceOf(inhabitant) * runesPerDay;
327 
328         if (lastTimeCollectedRunes[inhabitant] >= deployedStamp) {
329             return sumOfRunes * ((block.timestamp - lastTimeCollectedRunes[inhabitant])) / 86400;
330         } else {
331             return sumOfRunes * ((block.timestamp - deployedStamp)) / 86400;
332         }
333     }
334 
335     /*
336      * # getUnclaimedRunes
337      * returns the total amount of unclaimed runes a wallet has
338      */
339     function getUnclaimedRunes(address inhabitant) external view returns(uint256) {
340         return getPendingRunes(inhabitant);
341     }
342 
343     /*
344      * # getTotalRunes
345      * returns the runesObtained and getPendingRunes for the inhabitant passed
346      */
347     function getTotalRunes(address inhabitant) external view returns(uint256) {
348         return runesObtained[inhabitant] + getPendingRunes(inhabitant);
349     }
350 
351     /*
352      * # burn
353      * removes the withdrawn $RUNES from the wallet provided for the amount provided
354      */
355     function burn(address inhabitant, uint256 cost) external payable onlyContractWallets {
356         _burn(inhabitant, cost);
357     }
358 
359     /*
360      * # claimRunes
361      * takes the pending $RUNES and puts it into your wallet... you earned these, the gods aren't angry
362      */
363     function claimRunes() external payable onlyWhenCollectingIsEnabled {
364         _mint(msg.sender, runesObtained[msg.sender] + getPendingRunes(msg.sender));
365 
366         runesObtained[msg.sender] = 0;
367         lastTimeCollectedRunes[msg.sender] = block.timestamp;
368     }
369 
370     /*
371      * # updateRunes
372      * updates the pending balance for both of the wallets associated to the transfer so they don't lose the $RUNES generated
373      */
374     function updateRunes(address from, address to) external onlyContractWallets {
375         if (from != address(0) && from != mysteriousworld.ritualWallet()) {
376             runesObtained[from]          += getPendingRunes(from);
377             lastTimeCollectedRunes[from] = block.timestamp;
378         }
379 
380         if (to != address(0) && to != mysteriousworld.ritualWallet()) {
381             runesObtained[to]          += getPendingRunes(to);
382             lastTimeCollectedRunes[to] = block.timestamp;
383         }
384     }
385 }