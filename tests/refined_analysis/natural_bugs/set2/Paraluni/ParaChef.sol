// SPDX-License-Identifier: MIT
pragma experimental ABIEncoderV2;
pragma solidity 0.6.12;

import "./ParaToken.sol";
import "./interfaces/IERC20.sol";
import "./libraries/SafeERC20.sol";
import "./libraries/EnumerableSet.sol";
import "./libraries/SafeMath_para.sol";
import "./interfaces/IWETH.sol";
import './interfaces/IParaRouter02.sol';
import './interfaces/IParaPair.sol';
import './libraries/TransferHelper.sol';
import './interfaces/IFeeDistributor.sol';
import './ParaProxy.sol';

interface IParaTicket {
    function level() external pure returns (uint256);
    function tokensOfOwner(address owner) external view returns (uint256[] memory);
    function setApprovalForAll(address to, bool approved) external;
    function safeTransferFrom(address from, address to, uint256 tokenId) external;
    function setUsed(uint256 tokenId) external;
    function _used(uint256 tokenId) external view returns(bool);
}

interface IMigratorChef {
    // Perform LP token migration from legacy UniswapV2 to paraSwap.
    // Take the current LP token address and return the new LP token address.
    // Migrator should have full access to the caller's LP token.
    // Return the new LP token address.
    //
    // XXX Migrator must have allowance access to UniswapV2 LP tokens.
    // paraSwap must mint EXACTLY the same amount of paraSwap LP tokens or
    // else something bad will happen. Traditional UniswapV2 does not
    // do that so be careful!
    function migrate(IERC20 token) external returns (IERC20);
}

// MasterChef is the master of ParaSwap. He can make T42 and he is a fair guy.
//
// Note that it's ownable and the owner wields tremendous power. The ownership
// will be transferred to a governance smart contract once T42 is sufficiently
// distributed and the community can show to govern itself.
//
// Have fun reading it. Hopefully it's bug-free. God bless.
contract MasterChef is ParaProxyAdminStorage {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    // Info of each user.
    struct UserInfo {
        uint256 amount; // How many LP tokens the user has provided.
        uint256 rewardDebt; // Reward debt. See explanation below.
        //
        // We do some fancy math here. Basically, any point in time, the amount of T42s
        // entitled to a user but is pending to be distributed is:
        //
        //   pending reward = (user.amount * pool.accT42PerShare) - user.rewardDebt
        //
        // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
        //   1. The pool's `accT42PerShare` (and `lastRewardBlock`) gets updated.
        //   2. User receives the pending reward sent to his/her address.
        //   3. User's `amount` gets updated.
        //   4. User's `rewardDebt` gets updated.
    }
    // Info of each pool.
    struct PoolInfo {
        IERC20 lpToken; // Address of LP token contract.
        uint256 allocPoint; // How many allocation points assigned to this pool. T42s to distribute per block.
        uint256 lastRewardBlock; // Last block number that T42s distribution occurs.
        uint256 accT42PerShare; // Accumulated T42s per share, times 1e12. See below.
        IParaTicket ticket; // if VIP pool, NFT ticket contract, else 0
        uint256 pooltype;
    }
    // every farm's percent of T42 issue
    uint8[10] public farmPercent;
    // The T42 TOKEN!
    ParaToken public t42;
    // Dev address.
    address public devaddr;
    // Treasury address
    address public treasury;
    // Fee Distritution contract address
    address public feeDistributor;
    // Mining income commission rate, default 5%
    uint256 public claimFeeRate;
    // Mining pool withdrawal fee rate, the default is 1.3%
    uint256 public withdrawFeeRate;
    // Block number when bonus T42 period ends.
    uint256 public bonusEndBlock;
    // Bonus muliplier for early t42 makers.
    uint256 public constant BONUS_MULTIPLIER = 1;
    // The migrator contract. It has a lot of power. Can only be set through governance (owner).
    IMigratorChef public migrator;
    // Info of each pool.
    PoolInfo[] public poolInfo;
    // Info of each user that stakes LP tokens.
    mapping(uint256 => mapping(address => UserInfo)) public userInfo;
    // Total allocation poitns. Must be the sum of all allocation points in all pools.
    uint256 public totalAllocPoint;
    // The block number when T42 mining starts.
    uint256 public startBlock;
    
    // the address of WETH
    address public WETH;
    // the address of Router
    IParaRouter02 public paraRouter;
    // Change returned after adding liquidity
    mapping(address => mapping(address => uint)) public userChange;
    // record who staked which NFT ticket into this contract
    mapping(address => mapping(address => uint[])) public ticket_stakes;
    // record total claimed T42 for per user & per PoolType
    mapping(address => mapping(uint256 => uint256)) public _totalClaimed;
    mapping(address => address) public _whitelist;
    // TOTAL Deposit pid => uint
    mapping(uint => uint) public poolsTotalDeposit;

    event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
    event EmergencyWithdraw(
        address indexed user,
        uint256 indexed pid,
        uint256 amount
    );
    event WithdrawChange(
        address indexed user,
        address indexed token,
        uint256 change);
    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(admin == msg.sender, "Ownable: caller is not the owner");
        _;
    }
    constructor() public {
        admin = msg.sender;
    }
    
    function initialize(
        ParaToken _t42,
        address _treasury,
        address _feeDistributor,
        address _devaddr,
        uint256 _bonusEndBlock,
        address _WETH,
        IParaRouter02 _paraRouter
    ) external onlyOwner {
        t42 = _t42;
        treasury = _treasury;
        feeDistributor = _feeDistributor;
        devaddr = _devaddr;
        bonusEndBlock = _bonusEndBlock;
        startBlock = _t42.startBlock();
        WETH = _WETH;
        paraRouter = _paraRouter;
        claimFeeRate = 500;
        withdrawFeeRate = 130;
    }

    function _become(ParaProxy proxy) public {
        require(msg.sender == proxy.admin(), "only proxy admin can change brains");
        require(proxy._acceptImplementation() == 0, "change not authorized");
    }
    
    function setWhitelist(address _whtie, address accpeter) public onlyOwner {
        _whitelist[_whtie] = accpeter;
    }

    function setT42(ParaToken _t42) public onlyOwner {
        require(address(_t42) != address(0), "Should not set _t42 to 0x0");
        t42 = _t42;
    }
    
    function setTreasury(address _treasury) public onlyOwner {
        require(_treasury != address(0), "Should not set treasury to 0x0");
        require(_treasury != treasury, "Need a different treasury address");
        treasury = _treasury;
    }
    
    function setRouter(address _router) public onlyOwner {
        require(_router != address(0), "Should not set _router to 0x0");
        require(_router != address(paraRouter), "Need a different treasury address");
        paraRouter = IParaRouter02(_router);
    }
    
    function setFeeDistributor(address _newAddress) public onlyOwner {
        require(_newAddress != address(0), "Should not set fee distributor to 0x0");
        require(_newAddress != feeDistributor, "Need a different fee distributor address");
        feeDistributor = _newAddress;
    }

    function setFarmPercents(uint8[] memory percents) public onlyOwner {
        uint8 sum = 0;
        uint8 i = 0;
        for (i = 0; i < percents.length; i++) {
            sum += percents[i];
        }
        require(sum == 100, "Total percent should be 100%");
        for (i = 0; i < percents.length; i++) {
            farmPercent[i] = percents[i];
        }
    }

    function t42PerBlock(uint8 index) public view returns (uint) {
        return t42.issuePerBlock().mul(farmPercent[index]).div(100);
    }

    function setClaimFeeRate(uint256 newRate) public onlyOwner {
        require(newRate <= 2000, "Claim fee rate should not be greater than 20%");
        require(newRate != claimFeeRate, "Need a different value");
        claimFeeRate = newRate;
    }

    function setWithdrawFeeRate(uint256 newRate) public onlyOwner {
        require(newRate <= 500, "Withdraw fee rate should not be greater than 5%");
        require(newRate != withdrawFeeRate, "Need a different value");
        withdrawFeeRate = newRate;
    }

    function poolLength() external view returns (uint256) {
        return poolInfo.length;
    }

	function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public returns (bytes4) {
        return this.onERC721Received.selector;
    }

    // Add a new lp to the pool. Can only be called by the owner.
    // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
    function add(
        uint256 _allocPoint,
        IERC20 _lpToken,
        uint256 _pooltype,
        IParaTicket _ticket,
        bool _withUpdate
    ) public onlyOwner {
        if (_withUpdate) {
            massUpdatePools();
        }
        uint256 lastRewardBlock =
            block.number > startBlock ? block.number : startBlock;
        totalAllocPoint = totalAllocPoint.add(_allocPoint);
        poolInfo.push(
            PoolInfo({
                lpToken: _lpToken,
                allocPoint: _allocPoint,
                lastRewardBlock: lastRewardBlock,
                accT42PerShare: 0,
                pooltype: _pooltype,
                ticket: _ticket
            })
        );
    }

    // Update the given pool's T42 allocation point. Can only be called by the owner.
    function set(
        uint256 _pid,
        uint256 _allocPoint,
        bool _withUpdate
    ) public onlyOwner {
        if (_withUpdate) {
            massUpdatePools();
        }
        totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
            _allocPoint
        );
        poolInfo[_pid].allocPoint = _allocPoint;
    }

    // Set the migrator contract. Can only be called by the owner.
    function setMigrator(IMigratorChef _migrator) public onlyOwner {
        migrator = _migrator;
    }

    // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
    function migrate(uint256 _pid) public {
        require(address(migrator) != address(0), "migrate: no migrator");
        PoolInfo storage pool = poolInfo[_pid];
        IERC20 lpToken = pool.lpToken;
        //TODO use poolsTotalDeposit insteadOf balanceOf(address(this)); ??
        uint256 bal = poolsTotalDeposit[_pid];
        lpToken.safeApprove(address(migrator), bal);
        //uint newLpAmountOld = newLpToken.balanceOf(address(this));
        IERC20 newLpToken = migrator.migrate(lpToken);
        uint newLpAmountNew = newLpToken.balanceOf(address(this));
        require(bal <= newLpAmountNew, "migrate: bad");
        pool.lpToken = newLpToken;
    }

    // Return reward multiplier over the given _from to _to block.
    function getMultiplier(uint256 _from, uint256 _to)
        public
        view
        returns (uint256)
    {
        if (_to <= bonusEndBlock) {
            return _to.sub(_from).mul(BONUS_MULTIPLIER);
        } else if (_from >= bonusEndBlock) {
            return _to.sub(_from);
        } else {
            return
                bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
                    _to.sub(bonusEndBlock)
                );
        }
    }

    // View function to see pending T42s on frontend.
    function pendingT42(uint256 _pid, address _user)
        external
        view
        returns (uint256 pending, uint256 fee)
    {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][_user];
        uint256 accT42PerShare = pool.accT42PerShare;
        //use poolsTotalDeposit[_pid] insteadOf balanceOf(address(this))
        uint256 lpSupply = poolsTotalDeposit[_pid];
        if (block.number > pool.lastRewardBlock && lpSupply != 0) {
            uint256 multiplier =
                getMultiplier(pool.lastRewardBlock, block.number);
            uint256 t42Reward =
                multiplier.mul(t42PerBlock(1)).mul(pool.allocPoint).div(
                    totalAllocPoint
                );
            accT42PerShare = accT42PerShare.add(
                t42Reward.mul(1e12).div(lpSupply)
            );
        }
        pending = user.amount.mul(accT42PerShare).div(1e12).sub(user.rewardDebt);
        fee = pending.mul(claimFeeRate).div(10000);
    }

    // Update reward vairables for all pools. Be careful of gas spending!
    function massUpdatePools() public {
        uint256 length = poolInfo.length;
        for (uint256 pid = 0; pid < length; ++pid) {
            updatePool(pid);
        }
    }

    // Update reward variables of the given pool to be up-to-date.
    function updatePool(uint256 _pid) public {
        PoolInfo storage pool = poolInfo[_pid];
        if (block.number <= pool.lastRewardBlock) {
            return;
        }
        //use poolsTotalDeposit[_pid] insteadOf balanceOf(address(this))
        uint256 lpSupply = poolsTotalDeposit[_pid];
        if (lpSupply == 0) {
            pool.lastRewardBlock = block.number;
            return;
        }
        uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
        uint256 t42Reward =
            multiplier.mul(t42PerBlock(1)).mul(pool.allocPoint).div(
                totalAllocPoint
            );
        t42.mint(treasury, t42Reward.div(9));
        t42.mint(address(this), t42Reward);
        pool.accT42PerShare = pool.accT42PerShare.add(
            t42Reward.mul(1e12).div(lpSupply)
        );
        pool.lastRewardBlock = block.number;
    }

    //uint256 _minPoolTokens,
    function depositSingle(uint256 _pid, address _token, uint256 _amount, address[][2] memory paths, uint _minTokens) payable external{
        depositSingleInternal(msg.sender, msg.sender, _pid, _token, _amount, paths, _minTokens);
    }

    //uint256 _minPoolTokens,
    function depositSingleTo(address _user, uint256 _pid, address _token, uint256 _amount, address[][2] memory paths, uint _minTokens) payable external{
        //Msg.sender is on the white list
        require(_whitelist[msg.sender] != address(0), "only white");
        
        IFeeDistributor(feeDistributor).setReferalByChef(_user, _whitelist[msg.sender]);
        depositSingleInternal(msg.sender, _user, _pid, _token, _amount, paths, _minTokens);
    }

    struct DepositVars{
        uint oldBalance;
        uint newBalance;
        uint amountA;
        uint amountB;
        uint liquidity;
    }
    function depositSingleInternal(address payer, address _user, uint256 _pid, address _token, uint256 _amount, address[][2] memory paths, uint _minTokens) internal {
        require(paths.length == 2,"deposit: PE");
        //Stack too deep, try removing local variables
        DepositVars memory vars;
        (_token, _amount) = _doTransferIn(payer, _token, _amount);
        require(_amount > 0, "deposit: zero");
        //swap by path
        (address[2] memory tokens, uint[2] memory amounts) = depositSwapForTokens(_token, _amount, paths);
        //Go approve
        approveIfNeeded(tokens[0], address(paraRouter), amounts[0]);
        approveIfNeeded(tokens[1], address(paraRouter), amounts[1]);
        PoolInfo memory pool = poolInfo[_pid];
        //Non-VIP pool
        require(address(pool.ticket) == address(0), "T:E");
        //lp balance check
        vars.oldBalance = pool.lpToken.balanceOf(address(this));
        (vars.amountA, vars.amountB, vars.liquidity) = paraRouter.addLiquidity(tokens[0], tokens[1], amounts[0], amounts[1], 1, 1, address(this), block.timestamp + 600);
        vars.newBalance = pool.lpToken.balanceOf(address(this));
        //----------------- TODO 
        require(vars.newBalance > vars.oldBalance, "B:E");
        vars.liquidity = vars.newBalance.sub(vars.oldBalance);
        require(vars.liquidity >= _minTokens, "H:S");
        addChange(_user, tokens[0], amounts[0].sub(vars.amountA));
        addChange(_user, tokens[1], amounts[1].sub(vars.amountB));
        //_deposit
        _deposit(_pid, vars.liquidity, _user);
    }

    function depositSwapForTokens(address _token, uint256 _amount, address[][2] memory paths) internal returns(address[2] memory tokens, uint[2] memory amounts){
        for (uint256 i = 0; i < 2; i++) {
            if(paths[i].length == 0){
                tokens[i] = _token;
                amounts[i] = _amount.div(2);
            }else{
                require(paths[i][0] == _token,"invalid path");
                //Go approve
                approveIfNeeded(_token, address(paraRouter), _amount);
                (tokens[i], amounts[i]) = swapTokensIn(_amount.div(2), paths[i]);
            }
        }
    }

    function addChange(address user, address _token, uint change) internal returns(uint){
        if(change > 0){
            uint changeOld = userChange[user][_token];
            //set storage
            userChange[user][_token] = changeOld.add(change);
        }
    }

    function swapTokensIn(uint amountIn, address[] memory path) internal returns(address tokenOut, uint amountOut){
        uint[] memory amounts = paraRouter.swapExactTokensForTokens(amountIn, 0, path, address(this), block.timestamp + 600);
        tokenOut = path[path.length - 1];
        amountOut = amounts[amounts.length - 1];
    }

    function _claim(uint256 pooltype, uint pending) internal {
        uint256 fee = pending.mul(claimFeeRate).div(10000);
        safeT42Transfer(msg.sender, pending.sub(fee));
        _totalClaimed[msg.sender][pooltype] += pending.sub(fee);
        t42.approve(feeDistributor, fee);
        IFeeDistributor(feeDistributor).incomeClaimFee(msg.sender, address(t42), fee);
    }

    function totalClaimed(address _user, uint256 pooltype, uint index) public view returns (uint256) {
        if (pooltype > 0)
            return _totalClaimed[_user][pooltype];
            uint sum = 0;
            for(uint i = 0; i <= index; i++){
                sum += _totalClaimed[_user][i];
            }
        return sum;
    }

    function deposit_all_tickets(IParaTicket ticket) public {
        uint256[] memory idlist = ticket.tokensOfOwner(msg.sender);
        if (idlist.length > 0) {
            for (uint i = 0; i < idlist.length; i++) {
                uint tokenId = idlist[i];   
                ticket.safeTransferFrom(msg.sender, address(this), tokenId);
                if(!ticket._used(tokenId)){
                    ticket.setUsed(tokenId);
                }
                ticket_stakes[msg.sender][address(ticket)].push(tokenId);
            }
        }
    }

    function ticket_staked_count(address who, address ticket) public view returns (uint) {
        return ticket_stakes[who][ticket].length;
    }

    function ticket_staked_array(address who, address ticket) public view returns (uint[] memory) {
        return ticket_stakes[who][ticket];
    }

    function check_vip_limit(uint ticket_level, uint ticket_count, uint256 amount) public view returns (uint allowed, uint overflow){
        uint256 limit;
        if (ticket_level == 0) limit = 1000 * 1e18;
        else if (ticket_level == 1) limit = 5000 * 1e18;
        else if (ticket_level == 2) limit = 10000 * 1e18;
        else if (ticket_level == 3) limit = 25000 * 1e18;
        else if (ticket_level == 4) limit = 100000 * 1e18;
        //TODO 
        uint limitAll = ticket_count.mul(limit);
        if(amount <= limitAll){
            allowed = limitAll.sub(amount);
        }else{
            overflow = amount.sub(limitAll);
        }
    }
    
    function deposit(uint256 _pid, uint256 _amount) external {
        depositInternal(_pid, _amount, msg.sender, msg.sender);
    }

    function depositTo(uint256 _pid, uint256 _amount, address _user) external {
        //Msg.sender is on the white list
        require(_whitelist[msg.sender] != address(0), "only white");
        
        IFeeDistributor(feeDistributor).setReferalByChef(_user, _whitelist[msg.sender]);
        depositInternal(_pid, _amount, _user, msg.sender);
    }

    // Deposit LP tokens to MasterChef for T42 allocation.
    function depositInternal(uint256 _pid, uint256 _amount, address _user, address payer) internal {
        PoolInfo storage pool = poolInfo[_pid];
        pool.lpToken.safeTransferFrom(
            address(payer),
            address(this),
            _amount
        );
        if (address(pool.ticket) != address(0)) {
            UserInfo storage user = userInfo[_pid][_user];
            uint256 new_amount = user.amount.add(_amount);
            uint256 user_ticket_count = pool.ticket.tokensOfOwner(_user).length;
            uint256 staked_ticket_count = ticket_staked_count(_user, address(pool.ticket));
            uint256 ticket_level = pool.ticket.level();
            (, uint overflow) = check_vip_limit(ticket_level, user_ticket_count + staked_ticket_count, new_amount);
            require(overflow == 0, "Exceeding the ticket limit");
            deposit_all_tickets(pool.ticket);
        }
        _deposit(_pid, _amount, _user);
    }

    // Deposit LP tokens to MasterChef for para allocation.
    function _deposit(uint256 _pid, uint256 _amount, address _user) internal {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][_user];
        //add total of pool before updatePool
        poolsTotalDeposit[_pid] = poolsTotalDeposit[_pid].add(_amount);
        updatePool(_pid);
        if (user.amount > 0) {
            uint256 pending =
                user.amount.mul(pool.accT42PerShare).div(1e12).sub(
                    user.rewardDebt
                );
            //TODO
            _claim(pool.pooltype, pending);
        }
        user.amount = user.amount.add(_amount);
        user.rewardDebt = user.amount.mul(pool.accT42PerShare).div(1e12);
        emit Deposit(_user, _pid, _amount);
    }

    function withdraw_tickets(uint256 _pid, uint256 tokenId) public {
        //use memory for reduce gas
        PoolInfo memory pool = poolInfo[_pid];
        UserInfo memory user = userInfo[_pid][msg.sender];
        //use storage because of updating value
        uint256[] storage idlist = ticket_stakes[msg.sender][address(pool.ticket)];
        for (uint i; i< idlist.length; i++) {
            if (idlist[i] == tokenId) {
                (, uint overflow) = check_vip_limit(pool.ticket.level(), idlist.length - 1, user.amount);
                require(overflow == 0, "Please withdraw usdt in advance");
                pool.ticket.safeTransferFrom(address(this), msg.sender, tokenId);
                idlist[i] = idlist[idlist.length - 1];
                idlist.pop();
                return;
            }
        }
        require(false, "You never staked this ticket before");
    }

    // Withdraw LP tokens from MasterChef.
    function withdraw(uint256 _pid, uint256 _amount) public {
        _withdrawInternal(_pid, _amount, msg.sender);
        emit Withdraw(msg.sender, _pid, _amount);
    }

    function _withdrawInternal(uint256 _pid, uint256 _amount, address _operator) internal{
        (address lpToken,uint actual_amount) = _withdrawWithoutTransfer(_pid, _amount, _operator);
        IERC20(lpToken).safeTransfer(_operator, actual_amount);
    }

    function _withdrawWithoutTransfer(uint256 _pid, uint256 _amount, address _operator) internal returns (address lpToken, uint actual_amount){
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][_operator];
        require(user.amount >= _amount, "withdraw: not good");
        updatePool(_pid);
        uint256 pending =
            user.amount.mul(pool.accT42PerShare).div(1e12).sub(
                user.rewardDebt
            );
        _claim(pool.pooltype, pending);
        user.amount = user.amount.sub(_amount);
        user.rewardDebt = user.amount.mul(pool.accT42PerShare).div(1e12);
        //sub total of pool
        poolsTotalDeposit[_pid] = poolsTotalDeposit[_pid].sub(_amount);
        lpToken = address(pool.lpToken);
        uint fee = _amount.mul(withdrawFeeRate).div(10000);
        IERC20(lpToken).approve(feeDistributor, fee);
        IFeeDistributor(feeDistributor).incomeWithdrawFee(_operator, lpToken, fee, _amount);
        actual_amount = _amount.sub(fee);
    }

    function withdrawSingle(address tokenOut, uint256 _pid, uint256 _amount, address[][2] memory paths) external{
        require(paths[0].length >= 2 && paths[1].length >= 2, "PE:2");
        require(paths[0][paths[0].length - 1] == tokenOut,"invalid path_");
        require(paths[1][paths[1].length - 1] == tokenOut,"invalid path_");
        //doWithraw Lp
        (address lpToken, uint actual_amount) = _withdrawWithoutTransfer(_pid, _amount, msg.sender);
        //remove liquidity
        address[2] memory tokens;
        uint[2] memory amounts;
        tokens[0] = IParaPair(lpToken).token0();
        tokens[1] = IParaPair(lpToken).token1();
        //Go approve
        approveIfNeeded(lpToken, address(paraRouter), actual_amount);
        (amounts[0], amounts[1]) = paraRouter.removeLiquidity(
            tokens[0], tokens[1], actual_amount, 0, 0, address(this), block.timestamp.add(600));
        //swap to tokenOut
        for (uint i = 0; i < 2; i++){
            address[] memory path = paths[i];
            require(path[0] == tokens[0] || path[0] == tokens[1], "invalid path_0");
            //Consider the same currency situation
            if(path[0] == tokens[0]){
                swapTokensOut(amounts[0], tokenOut, path);
            }else{
                swapTokensOut(amounts[1], tokenOut, path);    
            }
        }
        emit Withdraw(msg.sender, _pid, _amount);
    }

    function approveIfNeeded(address _token, address spender, uint _amount) private{
        if (IERC20(_token).allowance(address(this), spender) < _amount) {
             IERC20(_token).approve(spender, _amount);
        }
    }

    //swapOut
    function swapTokensOut(uint amountIn, address tokenOut, address[] memory path) internal {
        //Consider the same currency situation
        if(path[0] == path[1]){
            _doTransferOut(tokenOut, amountIn);
            return;
        }
        approveIfNeeded(path[0], address(paraRouter), amountIn);
        if(tokenOut == address(0)){
            //swapForETH to msg.sender
            paraRouter.swapExactTokensForETH(amountIn, 0, path, msg.sender, block.timestamp + 600);
        }else{
            paraRouter.swapExactTokensForTokens(amountIn, 0, path, msg.sender, block.timestamp + 600);
        }
    }

    //Weth -> ETH / transfer erc20
    function _doTransferOut(address _token, uint amount) private{
        if(_token == address(0)){
            IWETH(WETH).withdraw(amount);
            TransferHelper.safeTransferETH(msg.sender, amount);
        }else{
            IERC20(_token).safeTransfer(msg.sender, amount);
        }
    }

    function _doTransferIn(address payer, address _token, uint _amount) private returns(address, uint){
        if(_token == address(0)){
            _amount = msg.value;
            //Convert to WETH
            IWETH(WETH).deposit{value: _amount}();
            _token = WETH;
        }else{
            IERC20(_token).safeTransferFrom(address(payer), address(this), _amount);
        }
        return (_token, _amount);
    }

    // Withdraw without caring about rewards. EMERGENCY ONLY.
    function emergencyWithdraw(uint256 _pid) public {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        //To get the value in user.amount = 0; calculate
        uint saved_amount = user.amount;
        user.amount = 0;
        user.rewardDebt = 0;   
        uint fee = saved_amount.mul(withdrawFeeRate).div(10000);
        pool.lpToken.safeTransfer(address(msg.sender), saved_amount.sub(fee));
        pool.lpToken.approve(feeDistributor, fee);
        IFeeDistributor(feeDistributor).incomeWithdrawFee(msg.sender, address(pool.lpToken), fee, saved_amount);
        emit EmergencyWithdraw(msg.sender, _pid, saved_amount);
    }

    function withdrawChange(address[] memory tokens) external{
        for(uint256 i = 0; i < tokens.length; i++){
            uint change = userChange[msg.sender][tokens[i]];
            //set storage
            userChange[msg.sender][tokens[i]] = 0;
            IERC20(tokens[i]).safeTransfer(address(msg.sender), change);
            emit WithdrawChange(msg.sender, tokens[i], change);
        }
    }

    // Safe t42 transfer function, just in case if rounding error causes pool to not have enough T42s.
    function safeT42Transfer(address _to, uint256 _amount) internal {
        uint256 t42Bal = t42.balanceOf(address(this));
        if (_amount > t42Bal) {
            t42.transfer(_to, t42Bal);
        } else {
            t42.transfer(_to, _amount);
        }
    }

    // Update dev address by the previous dev.
    function dev(address _devaddr) public {
        require(msg.sender == devaddr, "dev: wut?");
        devaddr = _devaddr;
    }
}