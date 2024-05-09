1 /**
2 Author: BlockRocket.tech.
3 
4 */
5 
6 pragma solidity ^0.5.5;
7 
8 
9 interface IERC20 {
10     
11     function totalSupply() external view returns (uint256);
12 
13     
14     function balanceOf(address account) external view returns (uint256);
15 
16     
17     function transfer(address recipient, uint256 amount) external returns (bool);
18 
19     
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     
23     function approve(address spender, uint256 amount) external returns (bool);
24 
25     
26     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
27 
28     
29     event Transfer(address indexed from, address indexed to, uint256 value);
30 
31     
32     event Approval(address indexed owner, address indexed spender, uint256 value);
33 }
34 
35 library SafeMath {
36     
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         require(c >= a, "SafeMath: addition overflow");
40 
41         return c;
42     }
43 
44     
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         return sub(a, b, "SafeMath: subtraction overflow");
47     }
48 
49     
50     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         require(b <= a, errorMessage);
52         uint256 c = a - b;
53 
54         return c;
55     }
56 
57     
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         
60         
61         
62         if (a == 0) {
63             return 0;
64         }
65 
66         uint256 c = a * b;
67         require(c / a == b, "SafeMath: multiplication overflow");
68 
69         return c;
70     }
71 
72     
73     function div(uint256 a, uint256 b) internal pure returns (uint256) {
74         return div(a, b, "SafeMath: division by zero");
75     }
76 
77     
78     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
79         
80         require(b > 0, errorMessage);
81         uint256 c = a / b;
82         
83 
84         return c;
85     }
86 
87     
88     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
89         return mod(a, b, "SafeMath: modulo by zero");
90     }
91 
92     
93     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
94         require(b != 0, errorMessage);
95         return a % b;
96     }
97 }
98 
99 contract Context {
100     
101     
102     constructor () internal { }
103     
104 
105     function _msgSender() internal view returns (address payable) {
106         return msg.sender;
107     }
108 
109     function _msgData() internal view returns (bytes memory) {
110         this; 
111         return msg.data;
112     }
113 }
114 
115 library Roles {
116     struct Role {
117         mapping (address => bool) bearer;
118     }
119 
120     
121     function add(Role storage role, address account) internal {
122         require(!has(role, account), "Roles: account already has role");
123         role.bearer[account] = true;
124     }
125 
126     
127     function remove(Role storage role, address account) internal {
128         require(has(role, account), "Roles: account does not have role");
129         role.bearer[account] = false;
130     }
131 
132     
133     function has(Role storage role, address account) internal view returns (bool) {
134         require(account != address(0), "Roles: account is the zero address");
135         return role.bearer[account];
136     }
137 }
138 
139 contract WhitelistAdminRole is Context {
140     using Roles for Roles.Role;
141 
142     event WhitelistAdminAdded(address indexed account);
143     event WhitelistAdminRemoved(address indexed account);
144 
145     Roles.Role private _whitelistAdmins;
146 
147     constructor () internal {
148         _addWhitelistAdmin(_msgSender());
149     }
150 
151     modifier onlyWhitelistAdmin() {
152         require(isWhitelistAdmin(_msgSender()), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
153         _;
154     }
155 
156     function isWhitelistAdmin(address account) public view returns (bool) {
157         return _whitelistAdmins.has(account);
158     }
159 
160     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
161         _addWhitelistAdmin(account);
162     }
163 
164     function renounceWhitelistAdmin() public {
165         _removeWhitelistAdmin(_msgSender());
166     }
167 
168     function _addWhitelistAdmin(address account) internal {
169         _whitelistAdmins.add(account);
170         emit WhitelistAdminAdded(account);
171     }
172 
173     function _removeWhitelistAdmin(address account) internal {
174         _whitelistAdmins.remove(account);
175         emit WhitelistAdminRemoved(account);
176     }
177 }
178 
179 contract WhitelistedRole is Context, WhitelistAdminRole {
180     using Roles for Roles.Role;
181 
182     event WhitelistedAdded(address indexed account);
183     event WhitelistedRemoved(address indexed account);
184 
185     Roles.Role private _whitelisteds;
186 
187     modifier onlyWhitelisted() {
188         require(isWhitelisted(_msgSender()), "WhitelistedRole: caller does not have the Whitelisted role");
189         _;
190     }
191 
192     function isWhitelisted(address account) public view returns (bool) {
193         return _whitelisteds.has(account);
194     }
195 
196     function addWhitelisted(address account) public onlyWhitelistAdmin {
197         _addWhitelisted(account);
198     }
199 
200     function removeWhitelisted(address account) public onlyWhitelistAdmin {
201         _removeWhitelisted(account);
202     }
203 
204     function renounceWhitelisted() public {
205         _removeWhitelisted(_msgSender());
206     }
207 
208     function _addWhitelisted(address account) internal {
209         _whitelisteds.add(account);
210         emit WhitelistedAdded(account);
211     }
212 
213     function _removeWhitelisted(address account) internal {
214         _whitelisteds.remove(account);
215         emit WhitelistedRemoved(account);
216     }
217 }
218 
219 contract AccessWhitelist is WhitelistedRole {
220     constructor() public {
221         super.addWhitelisted(msg.sender);
222     }
223 }
224 
225 contract AccessControls {
226     AccessWhitelist public accessWhitelist;
227 
228     constructor(AccessWhitelist _accessWhitelist) internal {
229         accessWhitelist = _accessWhitelist;
230     }
231 
232     modifier onlyWhitelisted() {
233         require(accessWhitelist.isWhitelisted(msg.sender), "Caller not whitelisted");
234         _;
235     }
236 
237     modifier onlyWhitelistAdmin() {
238         require(accessWhitelist.isWhitelistAdmin(msg.sender), "Caller not whitelist admin");
239         _;
240     }
241 
242     function updateAccessWhitelist(AccessWhitelist _accessWhitelist) external onlyWhitelistAdmin {
243         accessWhitelist = _accessWhitelist;
244     }
245 }
246 
247 contract ERC20Airdropper is AccessControls {
248     using SafeMath for uint256;
249 
250     event Transfer(
251         address indexed _token,
252         address indexed _caller,
253         uint256 _recipientCount,
254         uint256 _totalTokensSent
255     );
256 
257     event PricePerTxChanged(
258         address indexed _caller,
259         uint256 _oldPrice,
260         uint256 _newPrice
261     );
262 
263     event ReferralPerTxChanged(
264         address indexed _caller,
265         uint256 _oldPrice,
266         uint256 _newPrice
267     );
268 
269     event EtherMoved(
270         address indexed _caller,
271         address indexed _to,
272         uint256 _amount
273     );
274 
275     event TokensMoved(
276         address indexed _caller,
277         address indexed _to,
278         uint256 _amount
279     );
280 
281     event CreditsAdded(
282         address indexed _caller,
283         address indexed _to,
284         uint256 _amount
285     );
286 
287     event CreditsRemoved(
288         address indexed _caller,
289         address indexed _to,
290         uint256 _amount
291     );
292 
293     mapping(address => uint256) public credits;
294 
295     uint256 public pricePerTx = 0.035 ether;
296     uint256 public referralPerTx = 0.01 ether;
297 
298     address payable public feeSplitter;
299 
300     constructor(AccessWhitelist _accessWhitelist, address payable _feeSplitter)
301         AccessControls(_accessWhitelist) public {
302         feeSplitter = _feeSplitter;
303     }
304 
305     
306     function () external payable {}
307 
308     function transfer(address _token, address payable _referral, address[] calldata _addresses, uint256[] calldata _values) payable external returns (bool) {
309         require(_addresses.length == _values.length, "Address array and values array must be same length");
310 
311         require(credits[msg.sender] > 0 || msg.value >= pricePerTx, "Must have credit or min value");
312 
313         uint256 totalTokensSent;
314         for (uint i = 0; i < _addresses.length; i += 1) {
315             require(_addresses[i] != address(0), "Address invalid");
316             require(_values[i] > 0, "Value invalid");
317 
318             IERC20(_token).transferFrom(msg.sender, _addresses[i], _values[i]);
319             totalTokensSent = totalTokensSent.add(_values[i]);
320         }
321 
322         if (msg.value == 0 && credits[msg.sender] > 0) {
323             credits[msg.sender] = credits[msg.sender].sub(1);
324         } else {
325             uint256 fee = msg.value;
326             if (_referral != address(0)) {
327                 fee = fee.sub(referralPerTx);
328 
329                 (bool feeSplitterSuccess,) = _referral.call.value(referralPerTx)("");
330                 require(feeSplitterSuccess, "Failed to transfer the referral");
331             }
332 
333             (bool feeSplitterSuccess,) = address(feeSplitter).call.value(fee)("");
334             require(feeSplitterSuccess, "Failed to transfer to the fee splitter");
335         }
336 
337         emit Transfer(_token, msg.sender, _addresses.length, totalTokensSent);
338 
339         return true;
340     }
341 
342     function moveEther(address payable _account) onlyWhitelistAdmin external returns (bool)  {
343         uint256 contractBalance = address(this).balance;
344         _account.transfer(contractBalance);
345         emit EtherMoved(msg.sender, _account, contractBalance);
346         return true;
347     }
348 
349     function moveTokens(address _token, address _account) external onlyWhitelistAdmin returns (bool) {
350         uint256 contractTokenBalance = IERC20(_token).balanceOf(address(this));
351         IERC20(_token).transfer(_account, contractTokenBalance);
352         emit TokensMoved(msg.sender, _account, contractTokenBalance);
353         return true;
354     }
355 
356     function addCredit(address _to, uint256 _amount) external onlyWhitelisted returns (bool) {
357         credits[_to] = credits[_to].add(_amount);
358         emit CreditsAdded(msg.sender, _to, _amount);
359         return true;
360     }
361 
362     function reduceCredit(address _to, uint256 _amount) external onlyWhitelisted returns (bool) {
363         credits[_to] = credits[_to].sub(_amount);
364         emit CreditsRemoved(msg.sender, _to, _amount);
365         return true;
366     }
367 
368     function setPricePerTx(uint256 _pricePerTx) external onlyWhitelisted returns (bool) {
369         uint256 oldPrice = pricePerTx;
370         pricePerTx = _pricePerTx;
371         emit PricePerTxChanged(msg.sender, oldPrice, pricePerTx);
372         return true;
373     }
374 
375     function setReferralPerTx(uint256 _referralPerTx) external onlyWhitelisted returns (bool) {
376         uint256 oldPrice = referralPerTx;
377         referralPerTx = _referralPerTx;
378         emit ReferralPerTxChanged(msg.sender, oldPrice, referralPerTx);
379         return true;
380     }
381 
382     function creditsOfOwner(address _owner) external view returns (uint256) {
383         return credits[_owner];
384     }
385 
386     function updateFeeSplitter(address payable _feeSplitter) external onlyWhitelistAdmin {
387         feeSplitter = _feeSplitter;
388     }
389 }