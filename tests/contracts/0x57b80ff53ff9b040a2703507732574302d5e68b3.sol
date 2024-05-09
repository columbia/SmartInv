/**
 *Submitted for verification at Etherscan.io on 2020-10-04
*/

/**
 *Submitted for verification at Etherscan.io on 2020-10-04
*/

/**
 *Submitted for verification at Etherscan.io on 2020-10-01
*/

pragma solidity 0.6.3;



abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
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




contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
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
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
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
        return functionCallWithValue(target, data, 0, errorMessage);
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
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.3._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.3._
     */
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
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


/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
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




// MasterChef is the master of Lef. He can make Lef and he is a fair guy.
//
// Note that it's ownable and the owner wields tremendous power. The ownership
// will be transferred to a governance smart contract once Lef is sufficiently
// distributed and the community can show to govern itself.
//
// Have fun reading it. Hopefully it's bug-free. God bless.
contract MasterChef is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    // Info of each user.
    struct UserInfo {
		uint256 pid;
        uint256 amount;     // How many LP tokens the user has provided.
		uint256 reward;
        uint256 rewardPaid; 
		uint256 updateTime;
		uint256 userRewardPerTokenPaid;
    }
	// Info of each user that stakes LP tokens.
    mapping (uint256 => mapping (address => UserInfo)) public userInfo;
	

	
    // Info of each pool.
    struct PoolInfo {
        IERC20 lpToken;           // Address of LP token contract.
        uint256 allocPoint;       // How many allocation points assigned to this pool. Lefs to distribute per block.
        uint256 lastRewardTime;  // Last block number that Lefs distribution occurs.
        uint256 accLefPerShare; // Accumulated Lefs per share, times 1e18. See below.
		uint256 totalPool;
    }
    // Info of each pool.
    PoolInfo[] public poolInfo;
	

	struct VipPoolInfo {
        uint256 allocPoint;       // How many allocation points assigned to this pool. Lefs to distribute per block.
        uint256 lastTime;  // Last block number that Lefs distribution occurs.
        uint256 rewardPerTokenStored; // Accumulated Lefs per share, times 1e18. See below.
		uint256 vipNumber;
    }

	mapping(uint256 => VipPoolInfo) public vipPoolInfo;
    
	struct User {
        uint id; 
        address referrer; 

		uint256[] referAmount;

		uint256 referReward;

        uint256 totalReward;
	
		uint256 referRewardPerTokenPaid;

        uint256 vip;
    }	
	mapping(address => User) public users;
	

	uint public lastUserId = 2;
	mapping(uint256 => address) public regisUser;

	uint256[] DURATIONS =[3 days, 10 days, 22 days]; 
	
	
	

	bool initialized = false;

    //uint256 public initreward = 1250*1e18;

    uint256 public starttime = 1599829200;//秒

    uint256 public periodFinish = 0;

    uint256 public rewardRate = 0;

    uint256 public totalMinted = 0;

	uint256 public drawPending_threshold = 2000 * 1e18;

	uint256 public indirectRefer_threshold = 58094760000000000;

	

	mapping(uint => uint256) public vipLevel;	
	uint32 vipLevalLength = 0;


	//The Lef TOKEN!
	//  IERC20 public lef = IERC20(0x54CF703014A82B4FF7E9a95DD45e453e1Ba13eb1);
    IERC20 public lef ;



	address public defaultReferAddr = address(0xCfCe2a772ae87c5Fae474b2dE0324ee19C2c145f);
	

    // Total allocation poitns. Must be the sum of all allocation points in all pools.总权重
    uint256 public totalAllocPoint = 0;
    // Bonus muliplier for early lef makers.早期挖矿的额外奖励
    uint256 public constant BONUS_MULTIPLIER = 3;




    event RewardPaid(address indexed user, uint256 reward);
    event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
    event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
    event Registration(address indexed user, address indexed referrer, uint indexed userId, uint referrerId);

 
    function initContract (IERC20 _lef,uint256 _rewardRate,uint256 _starttime,uint256 _periodFinish,address _defaultReferAddr) public onlyOwner{	
		require(initialized == false,"has initialized");
        lef = _lef;
		rewardRate = _rewardRate;
		starttime = _starttime;
		periodFinish = _periodFinish;
		defaultReferAddr =  _defaultReferAddr;
	
		User memory user = User({
            id: 1,
            referrer: address(0),
            referAmount:new uint256[](2),
			referReward:0,
			totalReward:0,
			referRewardPerTokenPaid:0,
			vip:0
        });		
		users[defaultReferAddr] = user;	
		
		regisUser[1] = 	defaultReferAddr;
		initialized = true;	
    }


	
	function setVipLevel(uint level,uint256 amount) public onlyOwner {

		if(vipLevalLength < 3){
		
			vipLevalLength++;
		
    	//	uint256 vip1 = 0;
	    //   uint256 vip2 = 0;
		//	uint256 vip3 = 0;
		//  
		//	for(uint i = 1;i < vipLevalLength;i++){
		//		address regAddr = regisUser[i];
		//		uint256 vip = getVipLeval(regAddr);
		//		if(vip == 1){
		//		    vip1 ++;
		//		}else if(vip == 2){
		//		    vip2 ++;
		//		}else if(vip == 3){
		//		    vip3 ++;
		//		}
		//		
		//	}
		//	vipPoolInfo[1].vipNumber = vip1;
		//	vipPoolInfo[2].vipNumber = vip2;
		//	vipPoolInfo[3].vipNumber = vip3;
		//	for(uint i = 1;i < vipLevalLength;i++){
		//		updateVipPool(regisUser[i]);
		//	}
		}
		vipLevel[level] = amount;
		
	}

    function poolLength() external view returns (uint256) {
        return poolInfo.length;
    }
	

    function isUserExists(address user) public view returns (bool) {
		return (users[user].id != 0);
    }
	

	
	function registrationExt(address referrerAddress) external {
        registration(msg.sender, referrerAddress);
    }

    function registration(address userAddress, address referrerAddress) private {
       //require(msg.value == 0.05 ether, "registration cost 0.05");
        require(!isUserExists(userAddress), "user exists");
        require(isUserExists(referrerAddress), "referrer not exists");
        
        uint32 size;
        assembly {
            size := extcodesize(userAddress)
        }
		require(size == 0, "cannot be a contract");

        
 
        User memory user = User({
            id: lastUserId,
            referrer: referrerAddress,
			referAmount:new uint256[](2),
			totalReward:0,
			referReward:0,
			referRewardPerTokenPaid:0,
			vip:0
        });
		
		regisUser[lastUserId] = userAddress;
        
        users[userAddress] = user;
		
        lastUserId++;
        
        emit  Registration(userAddress, referrerAddress, users[userAddress].id, users[referrerAddress].id);
    }
	
	function setDrawReferThreshold(uint256 _threshold) public onlyOwner{
		drawPending_threshold = _threshold;
	}

	function drawReferPending() public{
		require(isUserExists(msg.sender), "user exists");
		

		require(getAllDeposit(msg.sender) > drawPending_threshold,"must mt 2000 * 1e18");


		uint256 pengdingReward = 0;

		uint256 vip = getVipLevel(msg.sender);

		if(vip >0){		
			VipPoolInfo storage vipPool = vipPoolInfo[vip];
			User storage user = users[msg.sender];
			uint256 rewardPerTokenStored = vipPool.rewardPerTokenStored;
			uint256 lpSupply = vipPool.vipNumber;
			if (block.timestamp > vipPool.lastTime && lpSupply != 0) {
				uint256 multiplier = getMultiplier(vipPool.lastTime, block.timestamp);
				uint256 lefReward = multiplier.mul(rewardRate).mul(vipPool.allocPoint).div(totalAllocPoint);				
				rewardPerTokenStored = rewardPerTokenStored.add(lefReward.div(lpSupply));
			}				
			 pengdingReward = rewardPerTokenStored.sub(user.referRewardPerTokenPaid).add(users[msg.sender].referReward);
			 safeLefTransfer(msg.sender, pengdingReward);
			 users[msg.sender].referReward = 0;
			 users[msg.sender].totalReward += pengdingReward;
			 user.referRewardPerTokenPaid = rewardPerTokenStored;
		}
	}


	//
	function getReferReward(address _referrer) public view returns(uint256){
	//	require(isUserExists(_referrer), "user exists");
		uint256 pengdingReward = 0;
		if(!isUserExists(_referrer)){
		  return pengdingReward;
		}
		uint256 vip = getVipLevel(_referrer);
		pengdingReward = users[_referrer].referReward;
		if(vip >0){		

			VipPoolInfo storage vipPool = vipPoolInfo[vip];
			User storage user = users[_referrer];
			uint256 rewardPerTokenStored = vipPool.rewardPerTokenStored;
			uint256 lpSupply = vipPool.vipNumber;
			if (block.timestamp > vipPool.lastTime && lpSupply != 0) {
				uint256 multiplier = getMultiplier(vipPool.lastTime, block.timestamp);
				uint256 lefReward = multiplier.mul(rewardRate).mul(vipPool.allocPoint).div(totalAllocPoint);				
				rewardPerTokenStored = rewardPerTokenStored.add(lefReward.div(lpSupply));
			}				
			return rewardPerTokenStored.sub(user.referRewardPerTokenPaid).add(pengdingReward);
		}
		return pengdingReward;
	}
	

    // Add a new lp to the pool. Can only be called by the owner.
    // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
    function addLp(uint256 _allocPoint, IERC20 _lpToken) public onlyOwner {   
        uint256 lastRewardTime = block.timestamp > starttime ? block.timestamp : starttime;
        //totalAllocPoint = totalAllocPoint.add(_allocPoint);
        poolInfo.push(PoolInfo({
            lpToken: _lpToken,
            allocPoint: _allocPoint,
            lastRewardTime: lastRewardTime,
            accLefPerShare: 0,
			totalPool:0
        }));		
    }
	
	
	function addVipPoolPoint(uint256 _vipIndex,uint256 _allocPoint) public onlyOwner {
        uint256 lastTime = block.timestamp > starttime ? block.timestamp : starttime;
		vipPoolInfo[_vipIndex].allocPoint = _allocPoint;
		if(vipPoolInfo[_vipIndex].lastTime == 0){
			vipPoolInfo[_vipIndex].lastTime = lastTime;
		}
       // vipPoolInfo[_vipIndex] =VipPoolInfo({
      //      allocPoint: _allocPoint,
        //    lastTime:lastTime,
         //   rewardPerTokenStored:0,
         //   vipNumber:0
      //  }); 
    }

    // Update the given pool's Lef allocation point. Can only be called by the owner.
    function set(uint256 _pid, uint256 _allocPoint) public onlyOwner {

        totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
        poolInfo[_pid].allocPoint = _allocPoint;
    }
	
	function setTotalAllocPoint(uint256 _totalAllocPoint) public onlyOwner{
		totalAllocPoint = _totalAllocPoint;
	}
	
	function setRewardRate(uint256 _rewardRate) public onlyOwner {
		rewardRate = _rewardRate;	
	} 

	
  

    // Return reward multiplier over the given _from to _to block.
    function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
        if (_to <= periodFinish) {
            return _to.sub(_from).mul(BONUS_MULTIPLIER);
        } else if (_from >= periodFinish) {
            return _to.sub(_from);
        } else {
            return periodFinish.sub(_from).mul(BONUS_MULTIPLIER).add(
                _to.sub(periodFinish)
            );
        }
    }


    function pendingLef(uint256 _pid, address _user) public view returns (uint256) {
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][_user];
        uint256 accLefPerShare = pool.accLefPerShare;
        uint256 lpSupply = pool.totalPool;
		uint256 result = user.reward;
        if (block.timestamp > pool.lastRewardTime && lpSupply != 0) {
            uint256 multiplier =  getMultiplier(pool.lastRewardTime, block.timestamp);
            uint256 lefReward = multiplier.mul(rewardRate).mul(pool.allocPoint).div(totalAllocPoint);
            accLefPerShare = pool.accLefPerShare.add(lefReward.mul(1e18).div(lpSupply));
        }

		result += user.amount.mul((accLefPerShare).sub(user.userRewardPerTokenPaid)).div(1e18);
	
        
		return result;
    }
	

	function pendingAllLef(address _user) public view returns (uint256) {
		uint256  result = 0;
		for(uint256 i = 0;i< poolInfo.length;i++ ){
			result = result.add(pendingLef(i,_user));
		}
        return result;
    }
	

	function allLefAmount(address _user) public view returns (uint256) {
		uint256 result = 0;
		for(uint256 i = 0;i< poolInfo.length;i++ ){
			UserInfo storage user = userInfo[i][_user];
			result = result.add(pendingLef(i,_user).add(user.rewardPaid));
		}
        return result;
    }
	

	function getAllDeposit(address _user) public view returns (uint256) {
		uint256 result = 0;
		for(uint256 i = 0;i< poolInfo.length;i++ ){
			UserInfo storage user = userInfo[i][_user];		
			result = result.add(user.amount);
		}
        return result;
    }


	function updateVipPool(address _user) internal {
		address _referrer = users[_user].referrer;
		for(uint i = 1;i < 3;i++){
			if(isUserExists(_referrer) && _referrer != address(0)){
				uint256 vip = getVipLevel(_referrer);
				uint256 _vip = users[_referrer].vip;
				uint256 skip_num ;
				if(vip > _vip){
					skip_num =  vip.sub(_vip);
				}else if(vip < _vip){
					skip_num =  _vip.sub(vip);
				}
				
				if(skip_num != 0){ 
					bool gloryBonus = false; 
					if(i == 2 && users[_user].vip >= 2 && vip >= 2){
						gloryBonus == true;
					}
					if(_vip != 0){
						VipPoolInfo storage _vpInfo =  vipPoolInfo[_vip];
						if(vipPoolInfo[_vip].vipNumber != 0){
							uint256 _multiplier = getMultiplier(_vpInfo.lastTime, block.timestamp);
							uint256 _lefReward;
							if(gloryBonus){
								_lefReward = _multiplier.mul(rewardRate).mul((_vpInfo.allocPoint).add(totalAllocPoint.mul(3).div(100))).div(totalAllocPoint);
							}else{
								_lefReward = _multiplier.mul(rewardRate).mul(_vpInfo.allocPoint).div(totalAllocPoint);
							}
							
							totalMinted = totalMinted.add(_lefReward);
							//lef.mint(address(this), _lefReward);
							_vpInfo.rewardPerTokenStored = _vpInfo.rewardPerTokenStored.add(_lefReward.div(_vpInfo.vipNumber));
							users[_referrer].referReward = ((_vpInfo.rewardPerTokenStored).sub(users[_referrer].referRewardPerTokenPaid)).add(users[_referrer].referReward);
							
							_vpInfo.vipNumber -= 1;	
							users[_referrer].referRewardPerTokenPaid = _vpInfo.rewardPerTokenStored;
							_vpInfo.lastTime = block.timestamp;							
						}			
					}
					if(vip != 0){
					
						VipPoolInfo storage vpInfo =  vipPoolInfo[vip];
						if(vpInfo.vipNumber != 0){
							
					
						
							uint256 multiplier = getMultiplier(vpInfo.lastTime, block.timestamp);
												
							uint256 lefReward;
							if(gloryBonus){
								lefReward = multiplier.mul(rewardRate).mul((vpInfo.allocPoint).add(totalAllocPoint.mul(3).div(100))).div(totalAllocPoint);
							}else{
								lefReward = multiplier.mul(rewardRate).mul(vpInfo.allocPoint).div(totalAllocPoint);
							}
						
						
							totalMinted = totalMinted.add(lefReward);
						//lef.mint(address(this), lefReward);
							vpInfo.rewardPerTokenStored = vpInfo.rewardPerTokenStored.add(lefReward.div(vpInfo.vipNumber));
						
						}
						
						//if(vpInfo.rewardPerTokenStored != 0){
						//	users[_referrer].referReward = ((vpInfo.rewardPerTokenStored).sub(users[_referrer].referRewardPerTokenPaid)).add(users[_referrer].referReward);
						//}
						vpInfo.vipNumber += 1;

						users[_referrer].referRewardPerTokenPaid = vpInfo.rewardPerTokenStored;
						vpInfo.lastTime = block.timestamp;	
					}	
									
				}	
				users[_referrer].vip= vip;	
				_referrer = users[_referrer].referrer;
			}

			
		}		
	}

	function setIndirectThreshold(uint256 _indirectThreshold) public onlyOwner{
	
		indirectRefer_threshold = _indirectThreshold;
	
	}
	
	function getVipLevel(address _user) public view returns(uint256){
		uint256 vip = 0;
		
		if(isUserExists(_user)){
			uint256 directReferAmount = users[_user].referAmount[0];
            uint256 indirectReferAmount = users[_user].referAmount[1];
			for(uint256 i = 1;i<=3;i++){
				if(directReferAmount < vipLevel[i]){
					break;
				} else{
					vip  = i;
				}	
			
			}
			if(vip == 3){
    			if(directReferAmount > vipLevel[3] && indirectReferAmount >=indirectRefer_threshold){
    				vip = 3;
    			}else if(directReferAmount > vipLevel[3] && indirectReferAmount <= indirectRefer_threshold){
    				vip = 2;
				}
			}
		}

		return vip;
	}

	function getReferAmount(address _user,uint256 _index) public view returns(uint256){
		if(isUserExists(_user)){
			return	users[_user].referAmount[_index];
		}
		return 0;
	}
	
    // Update reward variables of the given pool to be up-to-date.
    function updatePool(uint256 _pid,address _user) internal {
        PoolInfo storage pool = poolInfo[_pid];
        if (block.timestamp <= pool.lastRewardTime) {
            return;
        }
        uint256 lpSupply = pool.totalPool;
        if (lpSupply == 0) {
            pool.lastRewardTime = block.timestamp;
            return;
        }
		UserInfo storage user = userInfo[_pid][_user];
		
        uint256 multiplier = getMultiplier(pool.lastRewardTime, block.timestamp);
        uint256 lefReward = multiplier.mul(rewardRate).mul(pool.allocPoint).div(totalAllocPoint);
        totalMinted = totalMinted.add(lefReward);


		//lef.mint(address(this), lefReward);
        pool.accLefPerShare = pool.accLefPerShare.add(lefReward.mul(1e18).div(lpSupply));
		
		user.reward = user.amount.mul((pool.accLefPerShare).sub(user.userRewardPerTokenPaid)).div(1e18).add(user.reward);
		
		
		user.userRewardPerTokenPaid = pool.accLefPerShare;
        pool.lastRewardTime = block.timestamp;
    }


    // Deposit LP tokens to MasterChef for lef allocation.
    function deposit(uint256 _pid, uint256 _amount) public checkStart checkhalve{

		require(isUserExists(msg.sender), "user don't exists");		
        PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        updatePool(_pid,msg.sender);	
		
        if(_amount > 0) {
           pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
            user.amount = user.amount.add(_amount);
			user.updateTime = block.timestamp;
			user.pid = _pid;
			pool.totalPool = pool.totalPool.add(_amount);   		
	
			address _referrer = users[msg.sender].referrer;
			for(uint256 i = 0;i<2;i++){				
				if(_referrer!= address(0) && isUserExists(_referrer)){
					users[_referrer].referAmount[i] += _amount;					
					_referrer = users[_referrer].referrer;
				}
			}				
        }
		//
		updateVipPool(msg.sender);
        emit Deposit(msg.sender, _pid, _amount);
    }
	

    function getReward(uint256 _pid) public  {

		PoolInfo storage pool = poolInfo[_pid];
        UserInfo storage user = userInfo[_pid][msg.sender];
        uint256 accLefPerShare = pool.accLefPerShare;
        uint256 lpSupply = pool.totalPool;
        if (block.timestamp > pool.lastRewardTime && lpSupply != 0) {
            uint256 multiplier =  getMultiplier(pool.lastRewardTime, block.timestamp);
            uint256 lefReward = multiplier.mul(rewardRate).mul(pool.allocPoint).div(totalAllocPoint);
            accLefPerShare = pool.accLefPerShare.add(lefReward.mul(1e18).div(lpSupply));
        }
        uint256 reward = user.amount.mul((accLefPerShare).sub(user.userRewardPerTokenPaid)).div(1e18).add(user.reward);
	
        if (reward > 0) {
			safeLefTransfer(msg.sender, reward);
			user.rewardPaid = user.rewardPaid.add(reward);
			user.reward = 0;
            emit RewardPaid(msg.sender, reward);
        }		
		user.userRewardPerTokenPaid = accLefPerShare;
    }
	


    // Withdraw LP tokens from MasterChef.
    function withdraw(uint256 _pid, uint256 _amount) public checkhalve{
		
		
		UserInfo storage user = userInfo[_pid][msg.sender];
		
		require(block.timestamp > DURATIONS[_pid].add(user.updateTime),"");	
				
        PoolInfo storage pool = poolInfo[_pid];
        
        require(user.amount >= _amount, "withdraw: not good");
        updatePool(_pid,msg.sender);
               

		safeLefTransfer(msg.sender, user.reward);
		user.reward = 0;
		user.rewardPaid = user.rewardPaid.add(user.reward);
		emit RewardPaid(msg.sender, user.rewardPaid);
        if(_amount > 0) {
            user.amount = user.amount.sub(_amount);

            pool.lpToken.safeTransfer(address(msg.sender), _amount);
						
			pool.totalPool -= _amount;   
			
			address _referrer = users[msg.sender].referrer;
			for(uint256 i = 0;i<2;i++){
				if(_referrer!= address(0) && isUserExists(_referrer)){
					users[_referrer].referAmount[i] -= _amount;					
					_referrer = users[_referrer].referrer;
				}
			}	
        }
		updateVipPool(msg.sender);
        emit Withdraw(msg.sender, _pid, _amount);
    }

    // Withdraw without caring about rewards. EMERGENCY ONLY.
   // function emergencyWithdraw(uint256 _pid) public {
   //     PoolInfo storage pool = poolInfo[_pid];
    //    UserInfo storage user = userInfo[_pid][msg.sender];
   //     pool.lpToken.safeTransfer(address(msg.sender), user.amount);
   //     emit EmergencyWithdraw(msg.sender, _pid, user.amount);
  //      user.amount = 0;
   // }

    // Safe lef transfer function, just in case if rounding error causes pool to not have enough lefs.
    function safeLefTransfer(address _to, uint256 _amount) internal {
        uint256 lefBal = lef.balanceOf(address(this));
        if (_amount > lefBal) {
            lef.transfer(_to, lefBal);
        } else {
            lef.transfer(_to, _amount);
        }
    }   
	modifier checkhalve(){
        if (totalMinted >= 500000 *1e18) {
			
	//		initreward = initreward.mul(50).div(100);
           rewardRate = rewardRate.mul(90).div(100);
		   totalMinted = 0;
    //        periodFinish = periodFinish.add(DURATION);
           
        }
       _;
   }
	
	modifier checkStart(){
       require(block.timestamp  > starttime,"not start");
       _;
    }

    // Update dev address by the previous dev.

}