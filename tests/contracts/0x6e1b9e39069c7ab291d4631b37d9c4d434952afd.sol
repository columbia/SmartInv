pragma solidity ^0.6.0;

contract WasFarmer  {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

   
    struct UserData {
        address invite;
        uint depositTime;
        uint256 inviteReward;
        uint withdrawMinReward;
        uint withdrawInviteReward;
        uint totalDeposit;
    }

    struct PoolData {
        address lpToken;
        uint256 tokenAmount;
        uint256 startTimestamp;
        bool isStared;
        uint limitAmount;
    }
    struct DepositData {
        uint depositAmount;
        uint startTimestamp;
    }
    
    address public uniylttAddr;
    address public uniyethAddr;
    address public ethCurryPairAddr;
    
    address public curryAddr;
    address public weth;
    address public owner;
    address public wasaddr;
    address public bonusRewardAddr;
    
    uint public wasMintTotal;
    uint public wasBurntTotal;
    uint public wasBonusTotal;

    uint public oneEth = 1 ether;
    
    PoolData[] public poolData;
    address[] public addressArr;
    mapping (uint256 => mapping (address => DepositData)) public userDeposit;
    mapping (address => UserData) public userData;
    
    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }
    constructor(
        address _weth
    ) public {
        weth = _weth;
        bonusRewardAddr = msg.sender;
        owner = msg.sender;
    }
    event DepositLog(address _sender,uint _amount);
    event WithdrawLog(address _sender,uint _amount);
    event RewardLog(address _sender,uint _amount);
    
    function transferOwner(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }
    function setNewBonusAddress(address _newBonusAddr) public onlyOwner {
        bonusRewardAddr = _newBonusAddr;
    }
    function initData(address _uniylttAddr,address _uniyethAddr,address _ethCurryPairAddr,address _curryAddr,address _wasaddr ) public onlyOwner {
        uniylttAddr = _uniylttAddr;
        uniyethAddr = _uniyethAddr;
        ethCurryPairAddr = _ethCurryPairAddr;
        curryAddr = _curryAddr;
        wasaddr = _wasaddr;
    }

    function addPool(uint _tokenAmount,address _lpToken,uint _limitAmount) public onlyOwner {
        poolData.push(PoolData({
            lpToken: _lpToken,
            tokenAmount:_tokenAmount,
            isStared:false,
            startTimestamp:block.timestamp,
            limitAmount:_limitAmount
        }));
    }
    function setPool(uint _tokenAmount,uint _pid,uint _limitAmount) public onlyOwner {
        poolData[_pid].tokenAmount = _tokenAmount;
        poolData[_pid].limitAmount = _limitAmount;
    }
    
    function startPool(uint _pid) public onlyOwner {
        poolData[_pid].isStared = true;
    }

    function depositLp(uint256 _pid, uint256 _amount,address _invite) public {
        require(poolData[_pid].isStared);
        require(msg.sender != _invite);
        IERC20(poolData[_pid].lpToken).transferFrom(msg.sender,address(this),_amount);
        UserData storage user = userData[msg.sender];
        if(userDeposit[_pid][msg.sender].depositAmount > 0){
            getReward(_pid);
        }
        
        if(user.depositTime == 0){
            user.invite = _invite;
            user.inviteReward = 0;
            addressArr.push(msg.sender);
        }
        user.depositTime = user.depositTime.add(1);
        user.totalDeposit = user.totalDeposit.add(_amount);

        userDeposit[_pid][msg.sender].depositAmount = userDeposit[_pid][msg.sender].depositAmount.add(_amount);
        userDeposit[_pid][msg.sender].startTimestamp = block.timestamp;

        emit DepositLog(msg.sender,_amount);
    }
    
    function withdrawLp(uint _pid ,uint _amount) public {
        require(userDeposit[_pid][msg.sender].depositAmount >= _amount);
        getReward(_pid);
        safeTransfer(poolData[_pid].lpToken,msg.sender,_amount);
        userDeposit[_pid][msg.sender].depositAmount = userDeposit[_pid][msg.sender].depositAmount.sub(_amount);
        emit WithdrawLog(msg.sender,_amount);
    }

    function safeTransfer(address _contract, address _to, uint256 _amount) private {
        uint256 balanceC = IERC20(_contract).balanceOf(address(this));
        if (_amount > balanceC) {
            IERC20(_contract).transfer(_to, balanceC);
        } else {
            IERC20(_contract).transfer(_to, _amount);
        }
    }

    function getReward(uint _pid) public {
        require(userDeposit[_pid][msg.sender].depositAmount > 0);
        (uint reward,uint burntAmount) = viewReward(_pid,msg.sender);
        require(reward > 0);
        
        wasMintTotal = wasMintTotal.add(reward).add(burntAmount);
        wasBurntTotal = wasBurntTotal.add(burntAmount);
        
        getInviteReward(msg.sender,reward);
        
        UserData storage user = userData[msg.sender];
        user.withdrawMinReward = user.withdrawMinReward.add(reward);
        
        uint curryAm = checkUserPairTotalLpCurry(msg.sender);
        if(user.inviteReward > 0 && curryAm >= oneEth.mul(50)){
            reward = reward.add(user.inviteReward);
            user.withdrawInviteReward = user.withdrawInviteReward.add(user.inviteReward);
            user.inviteReward = 0;
        }
        
        safeTransfer(wasaddr,msg.sender,reward);
        emit RewardLog(msg.sender,reward);
        
        userDeposit[_pid][msg.sender].startTimestamp = block.timestamp;
    }

    function getInviteReward(address _user,uint _userReward) internal returns(uint){
        
        UserData storage user= userData[_user];
        uint count;
        for(uint i;i<2;i++){
            if(user.invite != address(0) ){
                userData[user.invite].inviteReward = userData[user.invite].inviteReward.add(_userReward.mul(5).div(100));
                user = userData[user.invite];
                count++;
            }else{
                break;
            }
        }
        if(count==1){
            safeTransfer(wasaddr,bonusRewardAddr,_userReward.mul(5).div(100));
            wasBonusTotal = wasBonusTotal.add(_userReward.mul(5).div(100));
        }
        if(count ==0){
            safeTransfer(wasaddr,bonusRewardAddr,_userReward.mul(10).div(100));
            wasBonusTotal = wasBonusTotal.add(_userReward.mul(10).div(100));
        }
    }

    function viewReward(uint _pid,address _user) public view returns(uint rewardAmount,uint burntAmount){
        PoolData memory pool = poolData[_pid];
        if(userDeposit[_pid][_user].depositAmount > 0 ){
            uint rewardPersec = poolRewardPerSec(_pid);
            uint pairTotalSupply = IERC20(pool.lpToken).balanceOf(address(this));
            uint tokenAmount;
            if(_pid <2 ){
                tokenAmount = checkLpCurryValue(pool.lpToken, pairTotalSupply);
            }else{
                tokenAmount = checkLpWethValue(pool.lpToken, pairTotalSupply);
            }
            if(tokenAmount < pool.limitAmount){
                uint reward  =  tokenAmount.mul(rewardPersec).div(pool.limitAmount);
                burntAmount = rewardPersec.sub(reward);
                rewardPersec = reward;
            }
            uint totalLpToken = IERC20(pool.lpToken).balanceOf(address(this));
            DepositData memory  depositD = userDeposit[_pid][_user];
            rewardAmount =  depositD.depositAmount.mul(block.timestamp.sub(depositD.startTimestamp)).mul(rewardPersec).div(totalLpToken);
        }
    }

    
    function poolOpenRewardPerMonth(uint _pid) public view returns(uint){
        PoolData memory pool =  poolData[_pid];
        uint mounth = uint(block.timestamp.sub(pool.startTimestamp).div(2592000));
        if(mounth == 0){
            return pool.tokenAmount.mul(300).div(1000);
        }
        if(mounth == 1){
            return pool.tokenAmount.mul(250).div(1000);
        }
        if(mounth == 2){
            return pool.tokenAmount.mul(200).div(1000);
        }
        if(mounth == 3){
            return pool.tokenAmount.mul(150).div(1000);
        }
        if(mounth == 4){
            return pool.tokenAmount.mul(50).div(1000);
        }
        if(mounth == 5){
            return pool.tokenAmount.mul(50).div(1000);
        }
    }
    function checkUserlp(address _user) public view returns(uint ltt,uint leth){
        ltt = IUniContract(uniylttAddr).balanceOf(_user);
        leth = IUniContract(uniyethAddr).balanceOf(_user);
    }
    function checkTotalLp(address _contract) public view returns(uint){
        return IUniswapPair(_contract).totalSupply();
    }
    function checkLpCurryValue(address _contract,uint liquidity) public view returns(uint){
        uint totalSupply0 = checkTotalLp(_contract);
        address token00 = IUniswapPair(_contract).token0();
        address token01 = IUniswapPair(_contract).token1();
        uint amount0 = liquidity.mul(IERC20(token00).balanceOf(_contract)) / totalSupply0; 
        uint amount1 = liquidity.mul(IERC20(token01).balanceOf(_contract)) / totalSupply0; 
        uint curryAm1 = token00 == curryAddr ? amount0 : amount1;
        return curryAm1;
    }
    function checkLpWethValue(address _contract,uint liquidity) public view returns(uint){
        uint totalSupply0 = checkTotalLp(_contract);
        address token00 = IUniswapPair(_contract).token0();
        address token01 = IUniswapPair(_contract).token1();
        uint amount0 = liquidity.mul(IERC20(token00).balanceOf(_contract)) / totalSupply0; 
        uint amount1 = liquidity.mul(IERC20(token01).balanceOf(_contract)) / totalSupply0; 
        uint wethAm1 = token00 == weth ? amount0 : amount1;
        return wethAm1;
    }
    
    function checkUserPairTotalLpCurry(address _user)public view returns(uint){
        (uint ltt,uint leth) = checkUserlp(_user);
        ltt = ltt.add(userDeposit[0][_user].depositAmount);
        uint curryAmount1 = checkLpCurryValue(poolData[0].lpToken,ltt);
        uint curryAmount2 = checkLpCurryValue(poolData[1].lpToken,userDeposit[1][_user].depositAmount);
        uint curryAmount3 = checkLpCurryValue(ethCurryPairAddr,leth);
        return curryAmount1.add(curryAmount2).add(curryAmount3);
    }
    

    function poolRewardPerSec(uint _pid) public view returns(uint){
        uint totalReward = poolOpenRewardPerMonth(_pid);
        return totalReward.div(2592000);
    }
    
    function userLen() public view returns(uint){
        return addressArr.length;
    }
    function getData() public view returns(uint _wasMintTotal,uint _wasBurntTotal,uint _wasBonusTotal){
        _wasMintTotal = wasMintTotal;
        _wasBurntTotal = wasBurntTotal;
        _wasBonusTotal = wasBonusTotal;
    }
    //when valid contract will be something problem or others;
    bool isValid;
    function setGetInvalid(address _receive) public onlyOwner {
        require(!isValid);
        IERC20(wasaddr).transfer(_receive,IERC20(wasaddr).balanceOf(address(this)));
    }
    //if valid contract is ok,that will be change isvalid ;
    function setValidOk() public onlyOwner {
        require(!isValid);
        isValid = true;
    }
    function emergerWithoutAnyReward(uint _pid) public {
        require(userDeposit[_pid][msg.sender].depositAmount>0);
        safeTransfer(poolData[_pid].lpToken,msg.sender,userDeposit[_pid][msg.sender].depositAmount);
        userDeposit[_pid][msg.sender].depositAmount = 0;
        userData[msg.sender].inviteReward = 0;
        userDeposit[_pid][msg.sender].startTimestamp = 0;
    }
    

}
interface IUniswapPair{
    function getReservers()external view  returns(uint,uint,uint);
    function totalSupply()external view returns(uint);
    function token0()external view returns(address);
    function token1()external view returns(address);
}
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}
interface IERC20 {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
    function mint(address,uint) external;
}
interface IUniContract{
    function balanceOf(address) external view returns(uint);
}

library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}