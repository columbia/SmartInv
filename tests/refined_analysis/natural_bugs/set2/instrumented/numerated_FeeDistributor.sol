1 pragma solidity 0.6.12;
2 
3 import "./libraries/SafeMath_para.sol";
4 import './interfaces/IFeeDistributor.sol';
5 import "./interfaces/IERC20.sol";
6 import "./libraries/SafeERC20.sol";
7 import './libraries/TransferHelper.sol';
8 import './interfaces/IParaRouter02.sol';
9 import './ParaProxy.sol';
10 
11 contract FeeDistributor is ParaProxyAdminStorage, IFeeDistributor {
12     using SafeMath for uint256;
13     using SafeERC20 for IERC20;
14     address public distributer;
15     uint constant scale = 1e18;
16     uint constant public TYPE_CLAIMFEE = 1;
17     uint constant public TYPE_SWAPFEE = 2;
18     uint constant public TYPE_WITHDRAW = 3;
19     address public poolT42bonus;
20     address public poolBuyback;
21     address public poolFomo;
22     address public poolTeam;
23 
24     IParaRouter02 public paraRouter;
25     address public masterChef;
26     mapping(address => address) public referrals;
27     mapping(address => bool) public _whitelist;
28 
29     mapping(uint =>mapping(address => uint)) poolBalances;
30 
31     mapping(address => TokenInfo) public tokensInfo;
32 
33     mapping(address => UserInfo) public usersInfo;
34 
35     struct TokenInfo{
36         uint price;
37         address[] path;
38     }
39 
40     struct UserInfo{
41         uint commission;
42         uint follower;
43         uint swapProfit;
44         uint claimProfit;
45         uint followerWithdrawProfit;
46         uint followerWithdraw;
47     }
48 
49     event ReferalCommission(address indexed referral, address indexed user, uint256 indexed category, address token, uint256 commission);
50 
51     /**
52      * @dev Throws if called by any account other than the owner.
53      */
54     modifier onlyOwner() {
55         require(admin == msg.sender, "Ownable: caller is not the owner");
56         _;
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the distributer.
61      */
62     modifier onlyDistributer() {
63         require(distributer == msg.sender, "Ownable: caller is not the distributer");
64         _;
65     }
66 
67     constructor () public {
68         admin = msg.sender;
69     }
70     
71     function initialize(address bonus, address buyback, address fomo, address team, address _paraRouter, address _distributer, address _masterChef) external onlyOwner{
72         setPools(bonus, buyback, fomo, team, _distributer, _masterChef);
73         paraRouter = IParaRouter02(_paraRouter);
74     }
75 
76     function _become(ParaProxy proxy) public {
77         require(msg.sender == proxy.admin(), "only proxy admin can change brains");
78         require(proxy._acceptImplementation() == 0, "change not authorized");
79     }
80 
81     function setPools(address bonus, address buyback, address fomo, address team, address _distributer, address _masterChef) public onlyOwner {
82         poolT42bonus = bonus;
83         poolBuyback = buyback;
84         poolFomo = fomo;
85         poolTeam = team;
86         distributer = _distributer;
87         masterChef = _masterChef;
88     }
89 
90     function setParaRouter(address _paraRouter) public onlyOwner {
91         paraRouter = IParaRouter02(_paraRouter);
92     }
93 
94     // TODO
95     function _setTokenInfo(address token, uint price, address[] memory path) external onlyOwner {
96         TokenInfo storage info = tokensInfo[token];
97         info.price = price;
98         info.path  = path;
99     }
100 
101     function setWhitelist(address _referral, bool _flag) public onlyOwner {
102         _whitelist[_referral] = _flag;
103         if(referrals[_referral] == address(0)){
104             referrals[_referral] = _referral;
105         }
106     }
107     
108     function inWhiteList(address user) public view returns (bool) {
109         return _whitelist[user];
110     }
111 
112     function _setUserReferal(address user, address referal) private {
113         if (_whitelist[referal] && referrals[user] == address(0))
114             referrals[user] = referal;
115     }
116 
117     function setReferalByChef(address user, address referal) public override {
118         require(msg.sender == masterChef, "auth");
119         _setUserReferal(user, referal);
120     }
121 
122     function setReferal(address referal) public {
123         _setUserReferal(msg.sender, referal);
124     }
125 
126     function _setReferals(address[] memory users, address[] memory referals) external onlyOwner {
127         require(users.length == referals.length,"Ev");
128         for(uint i = 0; i < users.length; i++){
129             _setUserReferal(users[i], referals[i]);
130         }
131     }
132 
133     function incomeClaimFee(address user, address token, uint256 fee) override external {
134         if(fee == 0)return;
135         doTransferIn(token, msg.sender, fee, 0);
136         uint256 commission = fee.div(10); 
137         uint left = fee.sub(commission);                 
138         address referral = referrals[user];
139         if (referral != address(0)) {
140             //Cumulative reward
141             UserInfo memory userInfo = usersInfo[referral];
142             //Calculate the reward
143             uint profit = getUsdtFromToken(token, commission);
144             userInfo.claimProfit = userInfo.claimProfit.add(profit);
145             IERC20(token).safeTransfer(referral, commission);
146             emit ReferalCommission(referral, user, TYPE_CLAIMFEE, token, commission);
147         }else{
148             IERC20(token).safeTransfer(poolTeam, commission);
149             emit ReferalCommission(poolTeam, user, TYPE_CLAIMFEE, token, commission);
150         }
151         //Store the rest
152         mapping(address => uint) storage asserts = poolBalances[TYPE_CLAIMFEE];
153         asserts[token] = asserts[token].add(left);
154     }
155 
156     // call after MasterChef send fee in
157     function distributeClaimFee(address[] memory tokens) external onlyDistributer{
158         for(uint i = 0; i < tokens.length; i++){
159             address token = tokens[i];
160             uint amount = poolBalances[TYPE_CLAIMFEE][token];
161             uint poolT42bonusAmount = amount.div(9);
162             uint poolBuybackAmount = amount.div(9);
163             uint poolFomoAmount = amount.mul(2).div(9);
164             uint poolTeamAmount = amount.sub(poolT42bonusAmount).sub(poolBuybackAmount).sub(poolFomoAmount);
165             if(token != address(0)){
166                 IERC20(token).safeTransfer(poolT42bonus, poolT42bonusAmount);
167                 IERC20(token).safeTransfer(poolBuyback, poolBuybackAmount);
168                 IERC20(token).safeTransfer(poolFomo, poolFomoAmount);
169                
170                 IERC20(token).safeTransfer(poolTeam, poolTeamAmount);
171             }else{
172                 TransferHelper.safeTransferETH(poolT42bonus, poolT42bonusAmount);
173                 TransferHelper.safeTransferETH(poolBuyback, poolBuybackAmount);
174                 TransferHelper.safeTransferETH(poolFomo, poolFomoAmount);
175                 
176                 TransferHelper.safeTransferETH(poolTeam, poolTeamAmount);
177             }
178             //set storage
179             poolBalances[TYPE_CLAIMFEE][token] = 0;
180         }
181         
182     }
183 
184     // call after MasterChef send fee in
185     function incomeSwapFee(address user, address token, uint256 fee) payable override external  {
186         if(fee == 0)return;
187          //doTransferIn
188         doTransferIn(token, msg.sender, fee, msg.value);
189         uint256 commission = fee.mul(10).div(55); 
190         uint left = fee.sub(commission);                 
191         address referral = referrals[user];
192         if (referral != address(0)) {
193             UserInfo storage userInfo = usersInfo[referral];
194             //Calculate the reward
195             uint profit = getUsdtFromToken(token, commission);
196             userInfo.swapProfit = userInfo.swapProfit.add(profit);
197             //doTransferOut
198             doTransferOut(token, referral, commission);
199             emit ReferalCommission(referral, user, TYPE_SWAPFEE, token, commission);
200         }else{
201             //doTransferOut
202             doTransferOut(token, poolTeam, commission);
203             emit ReferalCommission(poolTeam, user, TYPE_SWAPFEE, token, commission);
204         }
205         //Store the rest
206         mapping(address => uint) storage asserts = poolBalances[TYPE_SWAPFEE];
207         asserts[token] = asserts[token].add(left);
208     }
209 
210     // call after MasterChef send fee in
211     function distributeSwapFee(address[] memory tokens) external onlyDistributer{
212         for(uint i = 0; i < tokens.length; i++){
213             address token = tokens[i];
214             uint amount = poolBalances[TYPE_SWAPFEE][token];
215             uint poolT42bonusAmount = amount.mul(10).div(45);
216             uint poolBuybackAmount = amount.mul(10).div(45);
217             uint poolFomoAmount = amount.mul(5).div(45);
218             uint poolTeamAmount = amount.sub(poolT42bonusAmount).sub(poolBuybackAmount).sub(poolFomoAmount);
219             if(token != address(0)){
220                 IERC20(token).safeTransfer(poolT42bonus, poolT42bonusAmount);
221                 IERC20(token).safeTransfer(poolBuyback, poolBuybackAmount);
222                 IERC20(token).safeTransfer(poolFomo, poolFomoAmount);
223                 
224                 IERC20(token).safeTransfer(poolTeam, poolTeamAmount);
225             }else{
226                 //BNB
227                 TransferHelper.safeTransferETH(poolT42bonus, poolT42bonusAmount);
228                 TransferHelper.safeTransferETH(poolBuyback, poolBuybackAmount);
229                 TransferHelper.safeTransferETH(poolFomo, poolFomoAmount);
230                 
231                 TransferHelper.safeTransferETH(poolTeam, poolTeamAmount);
232             }
233             //set storage
234             poolBalances[TYPE_SWAPFEE][token] = 0;
235         }
236     }
237 
238     function incomeWithdrawFee(address user, address token, uint256 fee, uint256 amount) override external {
239         if(fee == 0 && amount == 0)return;
240         doTransferIn(token, msg.sender, fee, 0);
241         address referral = referrals[user];
242         uint left = fee; 
243         if (referral != address(0)) {
244             UserInfo storage userInfo = usersInfo[referral];
245             uint rate = getRate(userInfo.followerWithdraw);
246             uint256 commission = fee.mul(rate).div(130);
247             //doTransferOut
248             doTransferOut(token, referral, commission);
249             
250             uint profit = getUsdtFromToken(token, commission);
251             userInfo.followerWithdrawProfit = userInfo.followerWithdrawProfit.add(profit);
252             emit ReferalCommission(referral, user, TYPE_WITHDRAW, token, commission);
253             left = fee.sub(commission);
254             
255             uint amountToUsdt = getUsdtFromToken(token, amount);
256             userInfo.followerWithdraw = userInfo.followerWithdraw.add(amountToUsdt);
257         }
258         doTransferOut(token, poolTeam, left);
259         emit ReferalCommission(poolTeam, user, TYPE_WITHDRAW, token, left);
260     }
261 
262     function getUsdtFromToken(address token, uint amount) internal view returns (uint usdtAmount){
263         TokenInfo memory tokenInfo = tokensInfo[token];
264         uint price = tokenInfo.price;
265         if(price == 0 && tokenInfo.path.length > 0){
266             //Check from router according to path
267             uint[] memory amounts = paraRouter.getAmountsOut(getOneOfToken(token), tokenInfo.path);
268             price = amounts[amounts.length - 1];
269         }
270         //TODO Price and quantity Decimal progress pay attention to control
271         usdtAmount = amountFilled(token, amount).mul(price).div(scale);
272     }
273 
274     function amountFilled(address token, uint amount) internal view returns(uint){
275         uint decimal = IERC20(token).decimals();
276         return amount.mul(10**(uint(18).sub(decimal)));
277     }
278 
279     function getOneOfToken(address token) internal view returns(uint){
280         uint decimal = IERC20(token).decimals();
281         return 10**decimal;
282     }
283 
284     function getRate(uint usdtAmount) internal view returns (uint rate){
285         if(usdtAmount < uint(16000).mul(scale)){
286             rate = 50;
287         }
288         if(usdtAmount >= uint(16000).mul(scale) && usdtAmount < uint(79000).mul(scale)){
289             rate = 63;
290         }
291         if(usdtAmount >= uint(79000).mul(scale) && usdtAmount < uint(320000).mul(scale)){
292             rate = 70;
293         }
294         if(usdtAmount >= uint(320000).mul(scale) && usdtAmount < uint(790000).mul(scale)){
295             rate = 73;
296         }
297         if(usdtAmount >= uint(1600000).mul(scale) && usdtAmount < uint(7900000).mul(scale)){
298             rate = 100;
299         }
300         if(usdtAmount >= uint(16000000).mul(scale)){
301             rate = 130;
302         }
303     }
304 
305     function doTransferIn(address token, address payer, uint amount, uint msgValue) private returns(uint){
306         if(token != address(0)){
307             IERC20(token).safeTransferFrom(
308             payer,
309             address(this),
310             amount
311             );
312         }else{
313             require(amount == msgValue,"invalid value");
314         }
315     }
316 
317     function doTransferOut(address token, address _to, uint amount) private{
318         if(amount > 0){
319             if(token != address(0)){
320                 IERC20(token).safeTransfer(_to, amount);
321             }else{
322                  TransferHelper.safeTransferETH(_to, amount);
323             }
324         }
325     }
326 }