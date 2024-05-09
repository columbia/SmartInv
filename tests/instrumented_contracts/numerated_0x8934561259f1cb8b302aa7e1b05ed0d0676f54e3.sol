1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 	function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
5 		if (a == 0) {
6       		return 0;
7     	}
8 
9     	c = a * b;
10     	assert(c / a == b);
11     	return c;
12   	}
13 
14 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     	return a / b;
16 	}
17 
18 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     	assert(b <= a);
20     	return a - b;
21 	}
22 
23 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
24     	c = a + b;
25     	assert(c >= a);
26     	return c;
27 	}
28 	
29 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
30         require(b != 0);
31         return a % b;
32     }
33 }
34 
35 contract Ownable {
36     address internal _owner;
37     
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39     
40     constructor() public {
41         _owner = msg.sender;
42         emit OwnershipTransferred(address(0), _owner);
43     }
44     
45     function owner() public view returns (address) {
46         return _owner;
47     }
48 
49     modifier onlyOwner() {
50         require(isOwner(), "you are not the owner!");
51         _;
52     }
53 
54     function isOwner() public view returns (bool) {
55         return msg.sender == _owner;
56     }
57     
58     function transferOwnership(address newOwner) public onlyOwner {
59         _transferOwnership(newOwner);
60     }
61     
62     function _transferOwnership(address newOwner) internal {
63         require(newOwner != address(0), "cannot transfer ownership to ZERO address");
64         emit OwnershipTransferred(_owner, newOwner);
65         _owner = newOwner;
66     }
67 }
68 
69 interface ITokenStore {
70     function totalSupply() external view returns (uint256);
71     function balanceOf(address account) external view returns (uint256);
72     function allowance(address owner, address spender) external view returns(uint256);
73     function transfer(address src, address dest, uint256 amount) external;
74     function approve(address owner, address spender, uint256 amount) external;
75     function mint(address dest, uint256 amount) external;
76     function burn(address dest, uint256 amount) external;
77 }
78 
79 /*
80     TokenLogic
81 */
82 interface ITokenLogic {
83     function totalSupply() external view returns (uint256);
84     function balanceOf(address account) external view returns (uint256);
85     function allowance(address owner, address spender) external view returns (uint256);
86     function transfer(address from, address to, uint256 value) external returns (bool);
87     function approve(address spender, uint256 value, address owner) external returns (bool);
88     function transferFrom(address from, address to, uint256 value, address spender) external returns (bool);
89     function increaseAllowance(address spender, uint256 addedValue, address owner) external returns (bool);
90     function decreaseAllowance(address spender, uint256 subtractedValue, address owner) external returns (bool);
91 }
92 
93 contract TokenLogic is Ownable, ITokenLogic {
94     using SafeMath for uint256;
95     
96     ITokenStore private _tokenStore;
97     address private _tokenFront;
98     
99     constructor(ITokenStore tokenStore, address tokenFront) public {
100         _tokenStore = tokenStore;
101         _tokenFront = tokenFront;
102         _whiteList[msg.sender] = true;
103     }
104     
105     // getters and setters for tokenStore and tokenFront
106     function tokenStore() public view returns (address) {
107         return _tokenStore;
108     }
109     
110     function setTokenStore(ITokenStore newTokenStore) public onlyOwner {
111         _tokenStore = newTokenStore;
112     }
113     
114     function tokenFront() public view returns (address) {
115         return _tokenFront;
116     }
117     
118     function setTokenFront(address newTokenFront) public onlyOwner {
119         _tokenFront = newTokenFront;
120     }
121     
122     modifier onlyFront() {
123         require(msg.sender == _tokenFront, "this method MUST be called by tokenFront");
124         _;
125     }
126     
127     modifier onlyFrontOrOwner() {
128         require((msg.sender == _tokenFront) || isOwner(), "this method MUST be called by tokenFront or owner");
129         _;
130     }
131     
132     mapping(address => bool) private _whiteList;
133     mapping(address => bool) private _quitLock;
134     mapping(bytes32 => bool) private _batchRecord;
135     uint256[] private _tradingOpenTime;
136 
137     // transfer ownership and balance
138     function transferOwnership(address newOwner) public onlyOwner {
139         _whiteList[newOwner] = true;
140         _tokenStore.transfer(msg.sender, newOwner, _tokenStore.balanceOf(msg.sender));
141         _whiteList[msg.sender] = false;
142         super.transferOwnership(newOwner);
143     }
144     
145     // whitelist
146     function inWhiteList(address account) public view returns (bool) {
147         return _whiteList[account];
148     }
149     
150     function setWhiteList(address[] addressArr, bool[] statusArr) public onlyOwner {
151         require(addressArr.length == statusArr.length, "The length of address array is not equal to the length of status array!");
152         
153         for(uint256 idx = 0; idx < addressArr.length; idx++) {
154             _whiteList[addressArr[idx]] = statusArr[idx];
155         }
156     }
157     
158     // trading time
159     function inTradingTime() public view returns (bool) {
160         for(uint256 idx = 0; idx < _tradingOpenTime.length; idx = idx+2) {
161             if(now > _tradingOpenTime[idx] && now < _tradingOpenTime[idx+1]) {
162                 return true;
163             }
164         }
165         return false;
166     }
167     
168     function getTradingTime() public view returns (uint256[]) {
169         return _tradingOpenTime;
170     }
171     
172     function setTradingTime(uint256[] timeArr) public onlyOwner {
173         require(timeArr.length.mod(2) == 0, "the length of time arr must be even number");
174         
175         for(uint256 idx = 0; idx < timeArr.length; idx = idx+2) {
176             require(timeArr[idx] < timeArr[idx+1], "end time must be greater than start time");
177         }
178         _tradingOpenTime = timeArr;
179     }
180     
181     // quit
182     function inQuitLock(address account) public view returns (bool) {
183         return _quitLock[account];
184     }
185     
186     function setQuitLock(address account) public onlyOwner {
187         require(inWhiteList(account), "account is not in whiteList");
188         _quitLock[account] = true;
189     }
190     
191     function removeQuitAccount(address account) public onlyOwner {
192         require(inQuitLock(account), "the account is not in quit lock status");
193         
194         _tokenStore.transfer(account, msg.sender, _tokenStore.balanceOf(account));
195         _whiteList[account] = false;
196         _quitLock[account] = false;
197     }
198     
199     // implement for ITokenLogic
200     function totalSupply() external view returns (uint256) {
201         return _tokenStore.totalSupply();
202     }
203     
204     function balanceOf(address account) external view returns (uint256) {
205         return _tokenStore.balanceOf(account);
206     }
207     
208     function allowance(address owner, address spender) external view returns (uint256) {
209         return _tokenStore.allowance(owner, spender);
210     }
211     
212     function transfer(address from, address to, uint256 value) external onlyFront returns (bool) {
213         require(inWhiteList(from), "sender is not in whiteList");
214         require(inWhiteList(to), "receiver is not in whiteList");
215         
216         if(!inQuitLock(from) && from != owner()) {
217             require(inTradingTime(), "now is not trading time");
218         }
219         
220         _tokenStore.transfer(from, to, value);
221         return true;
222     }
223     
224     function forceTransferBalance(address from, address to, uint256 value) external onlyOwner returns (bool) {
225         require(inWhiteList(to), "receiver is not in whiteList");
226         _tokenStore.transfer(from, to, value);
227         return true;
228     }
229     
230     function approve(address spender, uint256 value, address owner) external onlyFront returns (bool) {
231         _tokenStore.approve(owner, spender, value);
232         return true;
233     }
234     
235     function transferFrom(address from, address to, uint256 value, address spender) external onlyFront returns (bool) {
236         require(inWhiteList(from), "sender is not in whiteList");
237         require(inWhiteList(to), "receiver is not in whiteList");
238         
239         if(!inQuitLock(from)) {
240             require(inTradingTime(), "now is not trading time");
241         }
242         
243         uint256 newAllowance = _tokenStore.allowance(from, spender).sub(value);
244         _tokenStore.approve(from, spender, newAllowance);
245         _tokenStore.transfer(from, to, value);
246         return true;
247     }
248     
249     function increaseAllowance(address spender, uint256 addedValue, address owner) external onlyFront returns (bool) {
250         uint256 newAllowance = _tokenStore.allowance(owner, spender).add(addedValue);
251         _tokenStore.approve(owner, spender, newAllowance);
252         
253         return true;
254     }
255     
256     function decreaseAllowance(address spender, uint256 subtractedValue, address owner) external onlyFront returns (bool) {
257         uint256 newAllowance = _tokenStore.allowance(owner, spender).sub(subtractedValue);
258         _tokenStore.approve(owner, spender, newAllowance);
259         
260         return true;
261     }
262     
263     // batch transfer
264     function batchTransfer(bytes32 batch, address[] addressArr, uint256[] valueArr) public onlyOwner {
265         require(addressArr.length == valueArr.length, "The length of address array is not equal to the length of value array!");
266         require(_batchRecord[batch] == false, "This batch number has already been used!");
267         
268         for(uint256 idx = 0; idx < addressArr.length; idx++) {
269             require(inWhiteList(addressArr[idx]), "receiver is not in whiteList");
270             
271             _tokenStore.transfer(msg.sender, addressArr[idx], valueArr[idx]);
272         }
273         
274         _batchRecord[batch] = true;
275     }
276     
277     // replace account
278     function replaceAccount(address oldAccount, address newAccount) public onlyOwner {
279         require(inWhiteList(oldAccount), "old account is not in whiteList");
280         _whiteList[newAccount] = true;
281         _tokenStore.transfer(oldAccount, newAccount, _tokenStore.balanceOf(oldAccount));
282         _whiteList[oldAccount] = false;
283     }
284 }
285 
286 /*
287     TokenFront
288 */
289 interface IERC20 {
290     function totalSupply() external view returns (uint256);
291     function balanceOf(address who) external view returns (uint256);
292     function allowance(address owner, address spender) external view returns (uint256);
293     function transfer(address to, uint256 value) external returns (bool);
294     function approve(address spender, uint256 value) external returns (bool);
295     function transferFrom(address from, address to, uint256 value) external returns (bool);
296     
297     event Transfer(address indexed from, address indexed to, uint256 value);
298     event Approval(address indexed owner, address indexed spender, uint256 value);
299 }