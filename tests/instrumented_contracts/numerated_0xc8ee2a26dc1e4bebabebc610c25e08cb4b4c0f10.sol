1 pragma solidity >=0.4.0 <0.6.0;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error.
6  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
7  */
8 library SafeMath {
9     
10     function add(uint256 a, uint256 b) internal pure returns (uint256) {
11         uint256 c = a + b;
12         require(c >= a);
13         return c;
14     }
15 }
16 
17 /**
18  * @title Ownable
19  * @dev The Ownable contract has an owner address, and provides basic authorization control
20  * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
21  */
22 contract Ownable {
23      address public _owner;
24 
25     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27     constructor () internal {
28         _owner = msg.sender;
29         emit OwnershipTransferred(address(0), _owner);
30     }
31 
32     modifier onlyOwner() {
33         require(isOwner());
34         _;
35     }
36 
37     function isOwner() public view returns (bool) {
38         return msg.sender == _owner;
39     }
40 
41     function transferOwnership(address newOwner) public onlyOwner {
42         _transferOwnership(newOwner);
43     }
44 
45     function _transferOwnership(address newOwner) internal {
46         require(newOwner != address(0));
47         emit OwnershipTransferred(_owner, newOwner);
48         _owner = newOwner;
49     }
50 }
51 
52 /**
53  * @title Token
54  * @dev API interface for interacting with the WILD Token contract 
55  */
56 interface Token {
57 
58   function allowance(address _owner, address _spender) external returns (uint256 remaining);
59 
60   function transfer(address _to, uint256 _value) external;
61 
62   function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
63 
64   function balanceOf(address _owner) external returns (uint256 balance);
65 }
66 
67 
68 /**
69 * @title Iot Chain Node Contract
70 * 节点投票合约，主要功能包括参与超级节点，节点投票，Token锁仓
71 */
72 contract NodeBallot is Ownable{
73     
74     using SafeMath for uint256;
75 
76     struct Node {
77         // original
78         uint256 originalAmount;
79         // total
80         uint256 totalBallotAmount;
81         // date 成为超级节点时间
82         uint date;
83         //  judge node is valid
84         bool valid;
85     }
86     
87     struct BallotInfo {
88         //节点地址
89         address nodeAddress;
90         //投票数量 
91         uint256 amount;
92         //投票日期
93         uint date;
94     }
95 
96     //锁仓期90天
97     uint256 public constant lockLimitTime = 3 * 30 ; 
98     
99     //绑定token
100     Token public token;
101     
102     // 18 decimals is the strongly suggested default, avoid changing it
103     uint256 public decimals = 10**18;
104     
105     //节点信息 
106     mapping (address => Node) public nodes;
107     //用户投票信息 
108     mapping (address => BallotInfo) public userBallotInfoMap;
109     //活动是否开启
110     bool public activityEnable = true;
111     //是否开放提现
112     bool public withdrawEnable = false;
113     //总参与的锁仓数量
114     uint256 public totalLockToken = 0; 
115     //已提现的Token数量
116     uint256 public totalWithdrawToken = 0; 
117     //活动开始日期
118     uint public startDate = 0;
119     
120     constructor(address tokenAddr) public{
121         
122         token = Token(tokenAddr);
123         
124         startDate = now;
125     }
126     
127     
128     /**
129     * @dev 投票事件记录 
130     * _ballotAddress 投票地址
131     * _nodeAddress 节点地址
132     * _ballotAmount 投票数量 
133     * _date 投票时间戳
134     */
135     event Ballot(address indexed _ballotAddress,address indexed _nodeAddress, uint256 _ballotAmount, uint _date);
136     
137      /**
138     * @dev 超级节点记录 
139     * _nodeAddress 超级节点地址
140     * _oringinalAmount 超级节点持仓数量 
141     * _date 成为超级节点的时间戳
142     */
143     event GeneralNode(address indexed _nodeAddress,uint256 _oringinalAmount, uint _date);
144     
145     /**
146     * @dev 提现记录 
147     * _ballotAddress 提现地址
148     * amount 提现数量
149     */
150     event Withdraw(address indexed _ballotAddress,uint256 _amount);
151 
152     /**
153     * @dev 修改活动进行状态 
154     * enable 活动是否结束
155     */
156     function motifyActivityEnable(bool enable) public onlyOwner{
157         activityEnable = enable;
158     }
159     
160     /**
161     * @dev 更改开放提现状态，由管理员进行状态修改
162     * enable 开启/关闭
163     */
164     function openWithdraw(bool enable) public onlyOwner {
165         
166         if(enable){
167             require(activityEnable == false,"please make sure the activity is closed.");
168         }
169         else{
170             require(activityEnable == true,"please make sure the activity is on.");
171         }
172         withdrawEnable = enable;
173     }
174    
175    
176    
177     /**
178     * @dev 成为超级节点信息，
179     * nodeAddress 节点地址
180     * originalAmount 节点资产
181     */
182     function generalSuperNode(uint256 originalAmount) public {
183 
184         //判断活动是否结束
185         require(activityEnable == true ,'The activity have been closed. Code<202>');
186         
187         //检查超级节点质押数量
188         require(originalAmount >= 100000 * decimals,'The amount of node token is too low. Code<201>');
189         
190         //检查用户是否授权了足够量的余额  
191         uint256 allowance = token.allowance(msg.sender,address(this));
192         require(allowance>=originalAmount,'Insufficient authorization balance available in the contract. Code<204>');
193 
194         //检查该超级节点是否存在
195         Node memory addOne = nodes[msg.sender];
196         require(addOne.valid == false,'Node did exist. Code<208>');
197         
198         //数据存储
199         nodes[msg.sender] = Node(originalAmount,0,now,true);
200         
201         totalLockToken = SafeMath.add(totalLockToken,originalAmount);
202         
203         //将投票人的token转移到合约中
204         token.transferFrom(msg.sender,address(this),originalAmount);
205         
206         emit GeneralNode(msg.sender,originalAmount,now);
207     }
208     
209     /**
210     * @dev 投票，由用户调用该方法进行投票
211     * nodeAddressArr 节点地址
212     * ballotAmount   投票数量
213     */
214     function ballot(address nodeAddress , uint256 ballotAmount) public returns (bool result){
215         
216         //判断活动是否结束
217         require(activityEnable == true ,'The activity have been closed. Code<202>');
218         
219         //判断用户是否已投票
220         BallotInfo memory ballotInfo = userBallotInfoMap[msg.sender];
221         require(ballotInfo.amount == 0,'The address has been voted. Code<200>');
222         
223         //检查节点是否存在
224         Node memory node = nodes[nodeAddress];
225         require(node.valid == true,'Node does not exist. Code<203>');
226             
227         //检查用户是否授权了足够量的余额  
228         uint256 allowance = token.allowance(msg.sender,address(this));
229         require(allowance>=ballotAmount,'Insufficient authorization balance available in the contract. Code<204>');
230 
231         //统计节点投票信息 
232         nodes[nodeAddress].totalBallotAmount = SafeMath.add(node.totalBallotAmount,ballotAmount);
233         
234          //存储用户投票信息 
235         BallotInfo memory info = BallotInfo(nodeAddress,ballotAmount,now);
236         userBallotInfoMap[msg.sender]=info;
237         
238         //统计锁仓数量 
239         totalLockToken = SafeMath.add(totalLockToken,ballotAmount);
240         
241         //将投票人的itc转移到合约中转移到合约中
242         token.transferFrom(msg.sender,address(this),ballotAmount);
243         
244         emit Ballot(msg.sender,nodeAddress,ballotAmount,now);
245         
246         result = true;
247     }
248     
249     /**
250     * @dev 提现，由用户调用该方法进行提现 
251     */
252     function withdrawToken() public returns(bool res){
253         
254         return _withdrawToken(msg.sender);
255     }
256  
257     /**
258     * @dev 提现，由管理员调用该方法对指定地址进行提现 
259     * ballotAddress 用户地址 
260     */
261     function withdrawTokenToAddress(address ballotAddress) public onlyOwner returns(bool res){
262         
263         return _withdrawToken(ballotAddress);
264     }
265     
266     /**
267     * @dev 提现，内部调用
268     * destinationAddress 提现地址
269     */
270     function _withdrawToken(address destinationAddress) internal returns(bool){
271         
272         require(destinationAddress != address(0),'Invalid withdraw address. Code<205>');
273         require(withdrawEnable,'Token withdrawal is not open. Code<207>');
274         
275         BallotInfo memory info = userBallotInfoMap[destinationAddress];
276         Node memory node = nodes[destinationAddress];
277         
278         require(info.amount != 0 || node.originalAmount != 0,'This address is invalid. Code<209>');
279 
280         uint256 amount = 0;
281 
282         if(info.amount != 0){
283             require(now >= info.date + lockLimitTime * 1 days,'The token is still in the lock period. Code<212>');
284             amount = info.amount;
285 
286             userBallotInfoMap[destinationAddress]=BallotInfo(info.nodeAddress,0,info.date);
287         }
288         
289         if(node.originalAmount != 0){
290             
291             require(now >= node.date + lockLimitTime * 1 days,'The token is still in the lock period. Code<212>');
292             amount = SafeMath.add(amount,node.originalAmount);
293             
294             nodes[destinationAddress] = Node(node.originalAmount,node.totalBallotAmount,node.date,false);
295         }
296         
297         totalWithdrawToken = SafeMath.add(totalWithdrawToken,amount);
298         
299         //发放代币
300         token.transfer(destinationAddress,amount);
301         
302         emit Withdraw(destinationAddress,amount);
303         
304         return true;
305     }
306     
307     
308     /**
309     * @dev 转移Token，管理员调用
310     */
311     function transferToken() public onlyOwner {
312         
313         require(now >= startDate + 365 * 1 days,"transfer time limit.");
314         token.transfer(_owner, token.balanceOf(address(this)));
315     }
316 
317     
318     /**
319     * @dev 销毁合约
320     */
321     function destruct() payable public onlyOwner {
322         
323         //检查活动是否结束  
324         require(activityEnable == false,'Activities are not up to the deadline. Code<212>');
325         //检查是否还有余额
326         require(token.balanceOf(address(this)) == 0 , 'please execute transferToken first. Code<213>');
327         
328         selfdestruct(msg.sender); // 销毁合约
329     }
330 }