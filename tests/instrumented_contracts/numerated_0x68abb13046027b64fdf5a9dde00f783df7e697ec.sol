1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/179
54  */
55 contract ERC20Basic {
56     function totalSupply() public view returns (uint256);
57     function balanceOf(address who) public view returns (uint256);
58     function transfer(address to, uint256 value) public returns (bool);
59     event Transfer(address indexed from, address indexed to, uint256 value);
60 }
61 
62 /**
63  * @title ERC20 interface
64  * @dev see https://github.com/ethereum/EIPs/issues/20
65  */
66 contract ERC20 is ERC20Basic {
67     function allowance(address owner, address spender) public view returns (uint256);
68     function transferFrom(address from, address to, uint256 value) public returns (bool);
69     function approve(address spender, uint256 value) public returns (bool);
70     event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 contract NervesStakeTestingPremium{
74 
75     using SafeMath for uint;
76     ERC20 public token;
77 
78     struct Contribution{
79         uint amount;
80         uint time;
81     }
82 
83     struct User{
84         address user;
85         uint amountAvailableToWithdraw;
86         bool exists;
87         uint totalAmount;
88         uint totalBonusReceived;
89         uint withdrawCount;
90         Contribution[] contributions;       
91     }
92 
93     mapping(address => User) public users;
94     
95     address[] usersList;
96     address owner;
97 
98     uint public totalTokensDeposited;
99 
100     uint public indexOfPayee;
101     uint public EthBonus;
102     uint public stakeContractBalance;
103     uint public bonusRate;
104 
105     uint public indexOfEthSent;
106 
107     bool public depositStatus;
108 
109 
110 
111     modifier onlyOwner(){
112         require(msg.sender == owner);
113         _;
114     }
115 
116     constructor(address _token, uint _bonusRate) public {
117         token = ERC20(_token);
118         owner = msg.sender;
119         bonusRate = _bonusRate;
120     }
121 
122     event OwnerChanged(address newOwner);
123 
124     function ChangeOwner(address _newOwner) public onlyOwner {
125         require(_newOwner != 0x0);
126         require(_newOwner != owner);
127         owner = _newOwner;
128 
129         emit OwnerChanged(_newOwner);
130     }
131 
132     event BonusChanged(uint newBonus);
133 
134     function ChangeBonus(uint _newBonus) public onlyOwner {
135         require(_newBonus > 0);
136         bonusRate = _newBonus;
137 
138         emit BonusChanged(_newBonus);
139     }
140 
141     event Deposited(address from, uint amount);
142 
143     function Deposit(uint _value) public returns(bool) {
144         require(depositStatus);
145         require(_value >= 100000 * (10 ** 18));
146         require(token.allowance(msg.sender, address(this)) >= _value);
147 
148         User storage user = users[msg.sender];
149 
150         if(!user.exists){
151             usersList.push(msg.sender);
152             user.user = msg.sender;
153             user.exists = true;
154         }
155         user.totalAmount = user.totalAmount.add(_value);
156         totalTokensDeposited = totalTokensDeposited.add(_value);
157         user.contributions.push(Contribution(_value, now));
158         token.transferFrom(msg.sender, address(this), _value);
159 
160         stakeContractBalance = token.balanceOf(address(this));
161 
162         emit Deposited(msg.sender, _value);
163 
164         return true;
165 
166     }
167 
168     function ChangeDepositeStatus(bool _status) public onlyOwner{
169         depositStatus = _status;
170     }
171 
172     function MultiSendToken() public onlyOwner {
173         uint i = indexOfPayee;
174         
175         while(i<usersList.length && msg.gas > 90000){
176             User storage currentUser = users[usersList[i]];
177             
178             uint amount = 0;
179             for(uint q = 0; q < currentUser.contributions.length; q++){
180                 if(now > currentUser.contributions[q].time + 24 hours){
181                     amount = amount.add(currentUser.contributions[q].amount);
182                 }
183             }
184             
185             if(amount >= 100000 * (10 ** 18)){  //TODO
186                 uint bonus = amount.mul(bonusRate).div(10000);
187 
188                 require(token.balanceOf(address(this)) >= bonus);
189                 currentUser.totalBonusReceived = currentUser.totalBonusReceived.add(bonus);
190                
191                 require(token.transfer(currentUser.user, bonus));
192             }
193             i++;
194         }
195 
196         indexOfPayee = i;
197         if( i == usersList.length){
198             indexOfPayee = 0;
199         }
200         stakeContractBalance = token.balanceOf(address(this));
201     }
202 
203 
204     event EthBonusSet(uint bonus);
205     function SetEthBonus(uint _EthBonus) public onlyOwner {
206         require(_EthBonus > 0);
207         EthBonus = _EthBonus;
208         stakeContractBalance = token.balanceOf(address(this));
209         indexOfEthSent = 0;
210 
211         emit EthBonusSet(_EthBonus);
212     } 
213 
214     function MultiSendEth() public onlyOwner {
215         require(EthBonus > 0);
216         require(stakeContractBalance > 0);
217         uint p = indexOfEthSent;
218 
219         while(p<usersList.length && msg.gas > 90000){
220             User memory currentUser = users[usersList[p]];
221             
222             uint amount = 0;
223             for(uint q = 0; q < currentUser.contributions.length; q++){
224                 if(now > currentUser.contributions[q].time + 3 days){
225                     amount = amount.add(currentUser.contributions[q].amount);
226                 }
227             }            
228             if(amount >= 100000 * (10 ** 18)){  //TODO
229                 uint EthToSend = EthBonus.mul(amount).div(totalTokensDeposited);
230                 
231                 require(address(this).balance >= EthToSend);
232                 currentUser.user.transfer(EthToSend);
233             }
234             p++;
235         }
236 
237         indexOfEthSent = p;
238 
239     }
240 
241     event MultiSendComplete(bool status);
242     function MultiSendTokenComplete() public onlyOwner {
243         indexOfPayee = 0;
244         emit MultiSendComplete(true);
245     }
246 
247     event Withdrawn(address withdrawnTo, uint amount);
248     function WithdrawTokens(uint _value) public {
249         require(_value > 0);
250 
251         User storage user = users[msg.sender];
252 
253         for(uint q = 0; q < user.contributions.length; q++){
254             if(now > user.contributions[q].time + 1 weeks){
255                 user.amountAvailableToWithdraw = user.amountAvailableToWithdraw.add(user.contributions[q].amount);
256             }
257         }
258 
259         require(_value <= user.amountAvailableToWithdraw);
260         require(token.balanceOf(address(this)) >= _value);
261 
262         user.amountAvailableToWithdraw = user.amountAvailableToWithdraw.sub(_value);
263         user.totalAmount = user.totalAmount.sub(_value);
264 
265         user.withdrawCount = user.withdrawCount.add(1);
266 
267         totalTokensDeposited = totalTokensDeposited.sub(_value);
268         token.transfer(msg.sender, _value);
269 
270         stakeContractBalance = token.balanceOf(address(this));
271         emit Withdrawn(msg.sender, _value);
272 
273 
274     }
275 
276 
277     function() public payable{
278 
279     }
280 
281     function WithdrawETH(uint amount) public onlyOwner{
282         require(amount > 0);
283         require(address(this).balance >= amount * 1 ether);
284 
285         msg.sender.transfer(amount * 1 ether);
286     }
287 
288     function CheckAllowance() public view returns(uint){
289         uint allowance = token.allowance(msg.sender, address(this));
290         return allowance;
291     }
292 
293     function GetBonusReceived() public view returns(uint){
294         User memory user = users[msg.sender];
295         return user.totalBonusReceived;
296     }
297     
298     function GetContributionsCount() public view returns(uint){
299         User memory user = users[msg.sender];
300         return user.contributions.length;
301     }
302 
303     function GetWithdrawCount() public view returns(uint){
304         User memory user = users[msg.sender];
305         return user.withdrawCount;
306     }
307 
308     function GetLockedTokens() public view returns(uint){
309         User memory user = users[msg.sender];
310 
311         uint i;
312         uint lockedTokens = 0;
313         for(i = 0; i < user.contributions.length; i++){
314             if(now < user.contributions[i].time + 1 weeks){
315                 lockedTokens = lockedTokens.add(user.contributions[i].amount);
316             }
317         }
318 
319         return lockedTokens;
320 
321     }
322 
323     function ReturnTokens(address destination, address account, uint amount) public onlyOwner{
324         ERC20(destination).transfer(account,amount);
325     }
326    
327 }