pragma solidity 0.6.12;

import "./libraries/SafeMath_para.sol";
import './interfaces/IFeeDistributor.sol';
import "./interfaces/IERC20.sol";
import "./libraries/SafeERC20.sol";
import './libraries/TransferHelper.sol';
import './interfaces/IParaRouter02.sol';
import './ParaProxy.sol';

contract FeeDistributor is ParaProxyAdminStorage, IFeeDistributor {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    address public distributer;
    uint constant scale = 1e18;
    uint constant public TYPE_CLAIMFEE = 1;
    uint constant public TYPE_SWAPFEE = 2;
    uint constant public TYPE_WITHDRAW = 3;
    address public poolT42bonus;
    address public poolBuyback;
    address public poolFomo;
    address public poolTeam;

    IParaRouter02 public paraRouter;
    address public masterChef;
    mapping(address => address) public referrals;
    mapping(address => bool) public _whitelist;

    mapping(uint =>mapping(address => uint)) poolBalances;

    mapping(address => TokenInfo) public tokensInfo;

    mapping(address => UserInfo) public usersInfo;

    struct TokenInfo{
        uint price;
        address[] path;
    }

    struct UserInfo{
        uint commission;
        uint follower;
        uint swapProfit;
        uint claimProfit;
        uint followerWithdrawProfit;
        uint followerWithdraw;
    }

    event ReferalCommission(address indexed referral, address indexed user, uint256 indexed category, address token, uint256 commission);

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(admin == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Throws if called by any account other than the distributer.
     */
    modifier onlyDistributer() {
        require(distributer == msg.sender, "Ownable: caller is not the distributer");
        _;
    }

    constructor () public {
        admin = msg.sender;
    }
    
    function initialize(address bonus, address buyback, address fomo, address team, address _paraRouter, address _distributer, address _masterChef) external onlyOwner{
        setPools(bonus, buyback, fomo, team, _distributer, _masterChef);
        paraRouter = IParaRouter02(_paraRouter);
    }

    function _become(ParaProxy proxy) public {
        require(msg.sender == proxy.admin(), "only proxy admin can change brains");
        require(proxy._acceptImplementation() == 0, "change not authorized");
    }

    function setPools(address bonus, address buyback, address fomo, address team, address _distributer, address _masterChef) public onlyOwner {
        poolT42bonus = bonus;
        poolBuyback = buyback;
        poolFomo = fomo;
        poolTeam = team;
        distributer = _distributer;
        masterChef = _masterChef;
    }

    function setParaRouter(address _paraRouter) public onlyOwner {
        paraRouter = IParaRouter02(_paraRouter);
    }

    // TODO
    function _setTokenInfo(address token, uint price, address[] memory path) external onlyOwner {
        TokenInfo storage info = tokensInfo[token];
        info.price = price;
        info.path  = path;
    }

    function setWhitelist(address _referral, bool _flag) public onlyOwner {
        _whitelist[_referral] = _flag;
        if(referrals[_referral] == address(0)){
            referrals[_referral] = _referral;
        }
    }
    
    function inWhiteList(address user) public view returns (bool) {
        return _whitelist[user];
    }

    function _setUserReferal(address user, address referal) private {
        if (_whitelist[referal] && referrals[user] == address(0))
            referrals[user] = referal;
    }

    function setReferalByChef(address user, address referal) public override {
        require(msg.sender == masterChef, "auth");
        _setUserReferal(user, referal);
    }

    function setReferal(address referal) public {
        _setUserReferal(msg.sender, referal);
    }

    function _setReferals(address[] memory users, address[] memory referals) external onlyOwner {
        require(users.length == referals.length,"Ev");
        for(uint i = 0; i < users.length; i++){
            _setUserReferal(users[i], referals[i]);
        }
    }

    function incomeClaimFee(address user, address token, uint256 fee) override external {
        if(fee == 0)return;
        doTransferIn(token, msg.sender, fee, 0);
        uint256 commission = fee.div(10); 
        uint left = fee.sub(commission);                 
        address referral = referrals[user];
        if (referral != address(0)) {
            //Cumulative reward
            UserInfo memory userInfo = usersInfo[referral];
            //Calculate the reward
            uint profit = getUsdtFromToken(token, commission);
            userInfo.claimProfit = userInfo.claimProfit.add(profit);
            IERC20(token).safeTransfer(referral, commission);
            emit ReferalCommission(referral, user, TYPE_CLAIMFEE, token, commission);
        }else{
            IERC20(token).safeTransfer(poolTeam, commission);
            emit ReferalCommission(poolTeam, user, TYPE_CLAIMFEE, token, commission);
        }
        //Store the rest
        mapping(address => uint) storage asserts = poolBalances[TYPE_CLAIMFEE];
        asserts[token] = asserts[token].add(left);
    }

    // call after MasterChef send fee in
    function distributeClaimFee(address[] memory tokens) external onlyDistributer{
        for(uint i = 0; i < tokens.length; i++){
            address token = tokens[i];
            uint amount = poolBalances[TYPE_CLAIMFEE][token];
            uint poolT42bonusAmount = amount.div(9);
            uint poolBuybackAmount = amount.div(9);
            uint poolFomoAmount = amount.mul(2).div(9);
            uint poolTeamAmount = amount.sub(poolT42bonusAmount).sub(poolBuybackAmount).sub(poolFomoAmount);
            if(token != address(0)){
                IERC20(token).safeTransfer(poolT42bonus, poolT42bonusAmount);
                IERC20(token).safeTransfer(poolBuyback, poolBuybackAmount);
                IERC20(token).safeTransfer(poolFomo, poolFomoAmount);
               
                IERC20(token).safeTransfer(poolTeam, poolTeamAmount);
            }else{
                TransferHelper.safeTransferETH(poolT42bonus, poolT42bonusAmount);
                TransferHelper.safeTransferETH(poolBuyback, poolBuybackAmount);
                TransferHelper.safeTransferETH(poolFomo, poolFomoAmount);
                
                TransferHelper.safeTransferETH(poolTeam, poolTeamAmount);
            }
            //set storage
            poolBalances[TYPE_CLAIMFEE][token] = 0;
        }
        
    }

    // call after MasterChef send fee in
    function incomeSwapFee(address user, address token, uint256 fee) payable override external  {
        if(fee == 0)return;
         //doTransferIn
        doTransferIn(token, msg.sender, fee, msg.value);
        uint256 commission = fee.mul(10).div(55); 
        uint left = fee.sub(commission);                 
        address referral = referrals[user];
        if (referral != address(0)) {
            UserInfo storage userInfo = usersInfo[referral];
            //Calculate the reward
            uint profit = getUsdtFromToken(token, commission);
            userInfo.swapProfit = userInfo.swapProfit.add(profit);
            //doTransferOut
            doTransferOut(token, referral, commission);
            emit ReferalCommission(referral, user, TYPE_SWAPFEE, token, commission);
        }else{
            //doTransferOut
            doTransferOut(token, poolTeam, commission);
            emit ReferalCommission(poolTeam, user, TYPE_SWAPFEE, token, commission);
        }
        //Store the rest
        mapping(address => uint) storage asserts = poolBalances[TYPE_SWAPFEE];
        asserts[token] = asserts[token].add(left);
    }

    // call after MasterChef send fee in
    function distributeSwapFee(address[] memory tokens) external onlyDistributer{
        for(uint i = 0; i < tokens.length; i++){
            address token = tokens[i];
            uint amount = poolBalances[TYPE_SWAPFEE][token];
            uint poolT42bonusAmount = amount.mul(10).div(45);
            uint poolBuybackAmount = amount.mul(10).div(45);
            uint poolFomoAmount = amount.mul(5).div(45);
            uint poolTeamAmount = amount.sub(poolT42bonusAmount).sub(poolBuybackAmount).sub(poolFomoAmount);
            if(token != address(0)){
                IERC20(token).safeTransfer(poolT42bonus, poolT42bonusAmount);
                IERC20(token).safeTransfer(poolBuyback, poolBuybackAmount);
                IERC20(token).safeTransfer(poolFomo, poolFomoAmount);
                
                IERC20(token).safeTransfer(poolTeam, poolTeamAmount);
            }else{
                //BNB
                TransferHelper.safeTransferETH(poolT42bonus, poolT42bonusAmount);
                TransferHelper.safeTransferETH(poolBuyback, poolBuybackAmount);
                TransferHelper.safeTransferETH(poolFomo, poolFomoAmount);
                
                TransferHelper.safeTransferETH(poolTeam, poolTeamAmount);
            }
            //set storage
            poolBalances[TYPE_SWAPFEE][token] = 0;
        }
    }

    function incomeWithdrawFee(address user, address token, uint256 fee, uint256 amount) override external {
        if(fee == 0 && amount == 0)return;
        doTransferIn(token, msg.sender, fee, 0);
        address referral = referrals[user];
        uint left = fee; 
        if (referral != address(0)) {
            UserInfo storage userInfo = usersInfo[referral];
            uint rate = getRate(userInfo.followerWithdraw);
            uint256 commission = fee.mul(rate).div(130);
            //doTransferOut
            doTransferOut(token, referral, commission);
            
            uint profit = getUsdtFromToken(token, commission);
            userInfo.followerWithdrawProfit = userInfo.followerWithdrawProfit.add(profit);
            emit ReferalCommission(referral, user, TYPE_WITHDRAW, token, commission);
            left = fee.sub(commission);
            
            uint amountToUsdt = getUsdtFromToken(token, amount);
            userInfo.followerWithdraw = userInfo.followerWithdraw.add(amountToUsdt);
        }
        doTransferOut(token, poolTeam, left);
        emit ReferalCommission(poolTeam, user, TYPE_WITHDRAW, token, left);
    }

    function getUsdtFromToken(address token, uint amount) internal view returns (uint usdtAmount){
        TokenInfo memory tokenInfo = tokensInfo[token];
        uint price = tokenInfo.price;
        if(price == 0 && tokenInfo.path.length > 0){
            //Check from router according to path
            uint[] memory amounts = paraRouter.getAmountsOut(getOneOfToken(token), tokenInfo.path);
            price = amounts[amounts.length - 1];
        }
        //TODO Price and quantity Decimal progress pay attention to control
        usdtAmount = amountFilled(token, amount).mul(price).div(scale);
    }

    function amountFilled(address token, uint amount) internal view returns(uint){
        uint decimal = IERC20(token).decimals();
        return amount.mul(10**(uint(18).sub(decimal)));
    }

    function getOneOfToken(address token) internal view returns(uint){
        uint decimal = IERC20(token).decimals();
        return 10**decimal;
    }

    function getRate(uint usdtAmount) internal view returns (uint rate){
        if(usdtAmount < uint(16000).mul(scale)){
            rate = 50;
        }
        if(usdtAmount >= uint(16000).mul(scale) && usdtAmount < uint(79000).mul(scale)){
            rate = 63;
        }
        if(usdtAmount >= uint(79000).mul(scale) && usdtAmount < uint(320000).mul(scale)){
            rate = 70;
        }
        if(usdtAmount >= uint(320000).mul(scale) && usdtAmount < uint(790000).mul(scale)){
            rate = 73;
        }
        if(usdtAmount >= uint(1600000).mul(scale) && usdtAmount < uint(7900000).mul(scale)){
            rate = 100;
        }
        if(usdtAmount >= uint(16000000).mul(scale)){
            rate = 130;
        }
    }

    function doTransferIn(address token, address payer, uint amount, uint msgValue) private returns(uint){
        if(token != address(0)){
            IERC20(token).safeTransferFrom(
            payer,
            address(this),
            amount
            );
        }else{
            require(amount == msgValue,"invalid value");
        }
    }

    function doTransferOut(address token, address _to, uint amount) private{
        if(amount > 0){
            if(token != address(0)){
                IERC20(token).safeTransfer(_to, amount);
            }else{
                 TransferHelper.safeTransferETH(_to, amount);
            }
        }
    }
}