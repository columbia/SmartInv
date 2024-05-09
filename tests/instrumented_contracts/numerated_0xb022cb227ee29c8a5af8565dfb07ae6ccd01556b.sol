1 pragma solidity ^0.5.7;
2 
3 contract Ownable {
4     address private _owner;
5 
6     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8     constructor () internal {
9         _owner = msg.sender;
10         emit OwnershipTransferred(address(0), _owner);
11     }
12 
13     function owner() public view returns (address) {
14         return _owner;
15     }
16 
17     modifier onlyOwner() {
18         require(isOwner());
19         _;
20     }
21 
22     function isOwner() public view returns (bool) {
23         return msg.sender == _owner;
24     }
25 
26     function renounceOwnership() public onlyOwner {
27         emit OwnershipTransferred(_owner, address(0));
28         _owner = address(0);
29     }
30 
31     function transferOwnership(address newOwner) public onlyOwner {
32         _transferOwnership(newOwner);
33     }
34 
35     function _transferOwnership(address newOwner) internal {
36         require(newOwner != address(0));
37         emit OwnershipTransferred(_owner, newOwner);
38         _owner = newOwner;
39     }
40 }
41 
42 contract SafeMath {
43 
44     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45         if (a == 0) {
46             return 0;
47         }
48 
49         uint256 c = a * b;
50         require(c / a == b);
51 
52         return c;
53     }
54 
55     function div(uint256 a, uint256 b) internal pure returns (uint256) {
56         require(b > 0);
57         uint256 c = a / b;
58         return c;
59     }
60 
61     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b <= a);
63         uint256 c = a - b;
64 
65         return c;
66     }
67 
68     function add(uint256 a, uint256 b) internal pure returns (uint256) {
69         uint256 c = a + b;
70         require(c >= a);
71 
72         return c;
73     }
74 
75     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
76         require(b != 0);
77         return a % b;
78     }
79 }
80 
81 interface IERC20 {
82     function transfer(address to, uint256 value) external returns (bool);
83 
84     function approve(address spender, uint256 value) external returns (bool);
85 
86     function transferFrom(address from, address to, uint256 value) external returns (bool);
87 
88     function totalSupply() external view returns (uint256);
89 
90     function balanceOf(address who) external view returns (uint256);
91 
92     function allowance(address owner, address spender) external view returns (uint256);
93 
94     event Transfer(address indexed from, address indexed to, uint256 value);
95 
96     event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 contract ERC20 is IERC20, SafeMath ,Ownable {
100     
101     string public name;
102     string public symbol;
103     uint8 public decimals;
104     uint public startTime;
105 
106     mapping (address => uint256) private _balances;
107 
108     mapping (address => mapping (address => uint256)) private _allowed;
109 
110     uint256 private _totalSupply;
111     
112     event UserAdedd(uint vestedAmount,uint vestingDuration,uint vestingPercentage,uint releasedAmount,string vesterType,uint tokenUsed,uint startTime,uint month);
113     
114     constructor() public {
115          
116          name = "Hartanah Dcom Token";
117          symbol = "HADT";
118          decimals = 10;
119          startTime = now;
120          _totalSupply = 10000000000000000000;
121          _balances[msg.sender] = _totalSupply;
122          
123      }
124     
125     struct User {
126         uint vestedAmount;
127         uint vestingDuration;
128         uint vestingPercentage;
129         uint releasedAmount;
130         string vesterType;
131         uint tokenUsed;
132         uint startTime;
133         uint vestingMonth;
134     }
135     
136     mapping(address => User) vestInfo;
137     mapping(string => address) addressMap;
138     
139     modifier checkReleasable(uint value) {
140         address sender = msg.sender;
141         
142         if(vestInfo[sender].vestedAmount == 0 || sender == owner()) {
143             _;
144         }
145         else{
146             if(keccak256(abi.encodePacked(vestInfo[sender].vesterType)) == keccak256(abi.encodePacked("Public Sales"))) {
147                 uint current = ((now - vestInfo[sender].startTime)/31536000)+1;
148                 if(vestInfo[sender].vestingMonth < current && current <= vestInfo[sender].vestingDuration) {
149                         vestInfo[sender].releasedAmount = (vestInfo[sender].vestedAmount);
150                         vestInfo[sender].vestingMonth++;
151                 }
152             }
153             else{
154                 uint current = ((now - vestInfo[sender].startTime)/2592000)+1;
155                     if(vestInfo[sender].vestingMonth < current && current <= vestInfo[sender].vestingDuration) {
156                         vestInfo[sender].releasedAmount = (vestInfo[sender].vestedAmount/vestInfo[sender].vestingDuration) * current;
157                         vestInfo[sender].vestingMonth++;
158                     }
159             }
160             require((vestInfo[sender].releasedAmount - vestInfo[sender].tokenUsed) >= value);
161             _;
162         }
163         
164     } 
165     
166     function addUser(address _account,uint _vestingDuration,uint _vestingPercentage,string memory _vesterType) public onlyOwner {
167       uint vestedAmount;
168       uint releasedAmount;
169       if(keccak256(abi.encodePacked(_vesterType)) == keccak256(abi.encodePacked("Public Sales"))) {
170          vestedAmount = (_totalSupply * _vestingPercentage)/100;
171          releasedAmount = vestedAmount/3;
172       }else{
173          vestedAmount = (_totalSupply * _vestingPercentage)/100;
174          releasedAmount = vestedAmount/_vestingDuration;
175       }
176       addressMap[_vesterType] = _account;
177       vestInfo[_account] = User(vestedAmount,_vestingDuration,_vestingPercentage,releasedAmount,_vesterType,0,now,1);
178       _transfer(owner(),_account,vestedAmount);
179       emit UserAdedd(vestedAmount,_vestingDuration,_vestingPercentage,releasedAmount,_vesterType,0,now,1);
180     }
181   
182     function getReleasedAmount(address _account) public view returns(uint){
183         
184       uint release = vestInfo[_account].releasedAmount;
185       if(keccak256(abi.encodePacked(vestInfo[_account].vesterType)) == keccak256(abi.encodePacked("Public Sales"))) {
186           uint current = ((now - vestInfo[_account].startTime)/31536000)+1;
187                 if(vestInfo[_account].vestingMonth < current && current <= vestInfo[_account].vestingDuration) {
188                         release = (vestInfo[_account].vestedAmount);
189                 }
190       }else {
191           uint time = ((now - vestInfo[_account].startTime)/2592000)+1;
192                 if((vestInfo[_account].vestingMonth < time) && (time <= vestInfo[_account].vestingDuration)) {
193                        release = (vestInfo[_account].vestedAmount/vestInfo[_account].vestingDuration) * time;
194                 }
195        }
196         return(release);
197     }
198   
199     function FoundersVestedAmount() public view returns(uint){
200       address account = addressMap["Founders"];
201       return vestInfo[account].vestedAmount;
202     } 
203     
204     function ManagementVestedAmount() public view returns(uint){
205       address account = addressMap["Management"];
206       return vestInfo[account].vestedAmount;
207     }
208     
209     function TechnologistVestedAmount() public view returns(uint){
210       address account = addressMap["Technologist"];
211       return vestInfo[account].vestedAmount;
212     }
213     
214     function LegalAndFinanceVestedAmount() public view returns(uint){
215       address account = addressMap["Legal & Finance"];
216       return vestInfo[account].vestedAmount;
217     }
218     
219     function MarketingVestedAmount() public view returns(uint){
220       address account = addressMap["Marketing"];
221       return vestInfo[account].vestedAmount;
222     }
223     
224     function PublicSalesVestedAmount() public view returns(uint){
225       address account = addressMap["Public Sales"];
226       return vestInfo[account].vestedAmount;
227     }
228     
229     function AirdropVestedAmount() public view returns(uint){
230       address account = addressMap["Airdrop"];
231       return vestInfo[account].vestedAmount;
232     }
233     
234     function PromotionVestedAmount() public view returns(uint){
235       address account = addressMap["Promotion"];
236       return vestInfo[account].vestedAmount;
237     }
238     
239     function RewardsVestedAmount() public view returns(uint){
240       address account = addressMap["Rewards"];
241       return vestInfo[account].vestedAmount;
242     }
243 
244     function FoundersReleasedAmount() public view returns(uint){
245       address account = addressMap["Founders"];
246       return getReleasedAmount(account);
247     } 
248     
249     function ManagementReleasedAmount() public view returns(uint){
250       address account = addressMap["Management"];
251       return getReleasedAmount(account);
252     }
253     
254     function TechnologistReleasedAmount() public view returns(uint){
255       address account = addressMap["Technologist"];
256       return getReleasedAmount(account);
257     }
258     
259     function LegalAndFinanceReleasedAmount() public view returns(uint){
260       address account = addressMap["Legal & Finance"];
261       return getReleasedAmount(account);
262     }
263     
264     function MarketingReleasedAmount() public view returns(uint){
265       address account = addressMap["Marketing"];
266       return getReleasedAmount(account);
267     }
268     
269     function PublicSalesReleasedAmount() public view returns(uint){
270       address account = addressMap["Public Sales"];
271       return getReleasedAmount(account);
272     }
273     
274     function AirdropReleasedAmount() public view returns(uint){
275       address account = addressMap["Airdrop"];
276       return getReleasedAmount(account);
277     }
278     
279     function PromotionReleasedAmount() public view returns(uint){
280       address account = addressMap["Promotion"];
281       return getReleasedAmount(account);
282     }
283     
284     function RewardsReleasedAmount() public view returns(uint){
285       address account = addressMap["Rewards"];
286       return getReleasedAmount(account);
287     }
288     
289     function totalSupply() public view returns (uint256) {
290         return _totalSupply;
291     }
292 
293     function balanceOf(address owner) public view returns (uint256) {
294         return _balances[owner];
295     }
296 
297     function allowance(address owner, address spender) public view returns (uint256) {
298         return _allowed[owner][spender];
299     }
300 
301     function transfer(address to, uint256 value) public checkReleasable(value) returns (bool) {
302         _transfer(msg.sender, to, value);
303         return true;
304     }
305 
306     function approve(address spender, uint256 value) public returns (bool) {
307         _approve(msg.sender, spender, value);
308         return true;
309     }
310 
311     function transferFrom(address from, address to, uint256 value) public returns (bool) {
312         _transfer(from, to, value);
313         _approve(from, msg.sender, sub(_allowed[from][msg.sender],value));
314         return true;
315     }
316      
317     function _transfer(address from, address to, uint256 value) internal  {
318         require(to != address(0));
319 
320         _balances[from] = sub(_balances[from],value);
321         _balances[to] = add(_balances[to],value);
322         vestInfo[from].tokenUsed = vestInfo[from].tokenUsed + value;
323         emit Transfer(from, to, value);
324     }
325 
326     function _approve(address owner, address spender, uint256 value) internal {
327         require(spender != address(0));
328         require(owner != address(0));
329 
330         _allowed[owner][spender] = value;
331         emit Approval(owner, spender, value);
332     }
333 
334 }