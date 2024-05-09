/*
* Copyright (c) 2020 DeFiat.net
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
*/

// File: @openzeppelin/contracts/math/Math.sol
//

// File: @openzeppelin/contracts/math/SafeMath.sol
pragma solidity ^0.6.0;
/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath{
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
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
     * - Subtraction cannot overflow.
     *
     * _Available since v2.4.0._
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
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
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
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
    
        /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow, so we distribute
        return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
    }
}

// File: @openzeppelin/contracts/GSN/Context.sol
/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: @openzeppelin/contracts/ownership/Ownable.sol
/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        _owner = _msgSender();
        emit OwnershipTransferred(address(0), _owner);
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
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }


    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
} //adding ALLOWED method

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol
/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see {ERC20Detailed}.
 */
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: @openzeppelin/contracts/utils/Address.sol
/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * This test is non-exhaustive, and there may be false-negatives: during the
     * execution of a contract's constructor, its address will be reported as
     * not containing a contract.
     *
     * IMPORTANT: It is unsafe to assume that an address for which this
     * function returns false is an externally-owned account (EOA) and not a
     * contract.
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }

    /**
     * @dev Converts an `address` into `address payable`. Note that this is
     * simply a type cast: the actual underlying value is not changed.
     *
     * _Available since v2.4.0._
     */
    function toPayable(address account) internal pure returns (address payable) {
        return address(uint160(account));
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
     *
     * _Available since v2.4.0._
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-call-value
        (bool success, ) = recipient.call.value(amount)("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}


//========


contract DeFiat_Farming_v15 {
    using SafeMath for uint256;

    //Structs
    struct PoolMetrics {
        address stakedToken;
        uint256 staked;             // sum of tokens staked in the contract
        uint256 stakingFee;         // entry fee
        
        uint256 stakingPoints;

        address rewardToken;
        uint256 rewards;        // current rewards in the pool

        uint256 startTime;      // when the pool opens
        uint256 closingTime;    // when the pool closes. 
        uint256 duration;       // duration of the staking
        uint256 lastEvent;   // last time metrics were updated.
        
        uint256  ratePerToken;      // CALCULATED pool reward Rate per Token (calculated based on total stake and time)
    }
    PoolMetrics public poolMetrics;

    struct UserMetrics {
            uint256 stake;          // native token stake (balanceOf)
            uint256 stakingPoints;  // staking points at lastEvent
            uint256 poolPoints;     // pool point at lastEvent
            uint256 lastEvent;

            uint256 rewardAccrued;  // accrued rewards over time based on staking points
            uint256 rewardsPaid;    // for information only

            uint256 lastTxBlock;    // latest transaction from the user (antiSpam)
    }
    mapping(address => UserMetrics) public userMetrics;

//== constructor 
    constructor(address _stakedToken, address _rewardToken, uint256 _feeBase1000, uint256 _durationHours, uint256 _delayStartHours) public {
    poolOperator = msg.sender;
    
    poolMetrics.stakedToken = address(_stakedToken);
    poolMetrics.rewardToken = address(_rewardToken);
    poolMetrics.stakingFee = _feeBase1000; //10 = 1%
    
    poolMetrics.duration = _durationHours.mul(3600); //
    poolMetrics.startTime = block.timestamp + _delayStartHours.mul(3600);
    poolMetrics.closingTime = poolMetrics.startTime + poolMetrics.duration; //corrected following report
    
    poolMetrics.stakingPoints = 1; //avoids div by 0 at start
    FullRewards = true;
    }

//==Events
    event PoolInitalized(uint256 amountAdded, string  _desc);
    event RewardTaken(address indexed user, uint256 reward, string  _desc);

    event userStaking(address indexed user, uint256 amount, string  _desc);
    event userWithdrawal(address indexed user, uint256 amount, string  _desc);

    modifier poolLive() {
        require(block.timestamp >= poolMetrics.startTime,"Pool not started Yet"); //good for delayed starts.
        require(block.timestamp <= poolMetrics.closingTime,"Pool closed"); //good for delayed starts.
        _;
    }
    modifier poolStarted() {
        require(block.timestamp >= poolMetrics.startTime,"Pool not started Yet"); //good for delayed starts.
        _;
    }
    modifier poolEnded() {
        require(block.timestamp > poolMetrics.closingTime,"Pool not ended Yet"); //good for delayed starts.
        _;
    }
    modifier antiSpam(uint256 _blocks) {
        require(block.number > userMetrics[msg.sender].lastTxBlock.add(_blocks), "Wait X BLOCKS between Transactions");
        userMetrics[msg.sender].lastTxBlock = block.number; //update
        _;
    } 
    
//==Basics 
    function currentTime() public view returns (uint256) {
        return SafeMath.min(block.timestamp, poolMetrics.closingTime); //allows expiration
    } // SafeMath.min(now, endTime)
    
//==Points locking    
    function viewPoolPoints() public view returns(uint256) {
            uint256 _previousPoints = poolMetrics.stakingPoints;    // previous points shapshot 
            uint256 _previousStake = poolMetrics.staked;             // previous stake snapshot
            
            uint256 _timeHeld = currentTime().sub(
                        SafeMath.max(poolMetrics.lastEvent, poolMetrics.startTime)
                                                 );                 // time held with _previous Event
                                                 
            return  _previousPoints.add(_previousStake.mul(_timeHeld));    //generated points since event
    }
    function lockPoolPoints() internal returns (uint256) { //ON STAKE/UNSTAKE EVENT
            poolMetrics.stakingPoints = viewPoolPoints();
            poolMetrics.lastEvent = currentTime();   // update lastStakingEvent
            return poolMetrics.stakingPoints;
        } 
    
    function viewPointsOf(address _address) public view returns(uint256) {
            uint256 _previousPoints = userMetrics[_address].stakingPoints;    // snapshot
            uint256 _previousStake = userMetrics[_address].stake;             // stake before event
        
            uint256 _timeHeld = currentTime().sub(
                        SafeMath.max(userMetrics[_address].lastEvent, poolMetrics.startTime)
                                                 );                          // time held since lastEvent (take RWD, STK, unSTK)
            
            uint256 _result = _previousPoints.add(_previousStake.mul(_timeHeld));   
            
            if(_result > poolMetrics.stakingPoints){_result = poolMetrics.stakingPoints;}
            return _result;
    }
    function lockPointsOf(address _address) internal returns (uint256) {
            userMetrics[_address].poolPoints = viewPoolPoints();  // snapshot of pool points at lockEvent
            userMetrics[_address].stakingPoints = viewPointsOf(_address); 
            userMetrics[_address].lastEvent = currentTime(); 

            return userMetrics[_address].stakingPoints;
    }
    function pointsSnapshot(address _address) public returns (bool) {
        lockPointsOf(_address);lockPoolPoints();
        return true;
    }
    
//==Rewards
    function viewTrancheReward(uint256 _period) internal view returns(uint256) {
        //uint256 _poolRewards = poolMetrics.rewards; //tokens in the pool. Note: This can be setup to a fixed amount (totalRewards)
        uint256 _poolRewards = totalRewards; 
        
        if(FullRewards == false){ _poolRewards = SafeMath.min(poolMetrics.staked, _poolRewards);} 
        // baseline is the min( staked, rewards); avoids ultra_farming > staking pool - EXPERIMENTAL
        
        uint256 _timeRate = _period.mul(1e18).div(poolMetrics.duration);
        return _poolRewards.mul(_timeRate).div(1e18); //tranche of rewards on period
    }
    
    function userRateOnPeriod(address _address) public view returns (uint256){
        //calculates the delta of pool points and user points since last Event
        uint256 _deltaUser = viewPointsOf(_address).sub(userMetrics[_address].stakingPoints); // points generated since lastEvent
        uint256 _deltaPool = viewPoolPoints().sub(userMetrics[_address].poolPoints);          // pool points generated since lastEvent
        uint256 _rate = 0;
        if(_deltaUser == 0 || _deltaPool == 0 ){_rate = 0;} //rounding
        else {_rate = _deltaUser.mul(1e18).div(_deltaPool);}
        return _rate;
        
    }
    
    function viewAdditionalRewardOf(address _address) public view returns(uint256) { // rewards generated since last Event
        require(poolMetrics.rewards > 0, "No Rewards in the Pool");
        
  
        // user weighted average share of Pool since lastEvent
        uint256 _userRateOnPeriod = userRateOnPeriod(_address); //can drop if pool size increases within period -> slows rewards generation
        
        // Pool Yield Rate 
        uint256 _period = currentTime().sub(
                            SafeMath.max(userMetrics[_address].lastEvent, poolMetrics.startTime)  
                            );        // time elapsed since last reward or pool started (if never taken rewards)

        // Calculate reward
        uint256 _reward = viewTrancheReward(_period).mul(_userRateOnPeriod).div(1e18);  //user rate on pool rewards' tranche

        return _reward;
    }
    
    function lockRewardOf(address _address) public returns(uint256) {
        uint256 _additional = viewAdditionalRewardOf(_address); //stakeShare(sinceLastEvent) * poolRewards(sinceLastEvent)
        userMetrics[_address].rewardAccrued = userMetrics[_address].rewardAccrued.add(_additional); //snapshot rewards.
        
        pointsSnapshot(_address); //updates lastEvent and points
        return userMetrics[_address].rewardAccrued;
    }  
    
    function takeRewards() public poolStarted antiSpam(1) { //1 blocks between rewards
        require(poolMetrics.rewards > 0, "No Rewards in the Pool");
        
        uint256 _reward = lockRewardOf(msg.sender); //returns already accrued + additional (also resets time counters)

        userMetrics[msg.sender].rewardsPaid = _reward;   // update user paid rewards
        
        userMetrics[msg.sender].rewardAccrued = 0; //flush previously accrued rewards.
        
        poolMetrics.rewards = poolMetrics.rewards.sub(_reward);           // update pool rewards
            
        IERC20(poolMetrics.rewardToken).transfer(msg.sender, _reward);  // transfer
            
        pointsSnapshot(msg.sender); //updates lastEvent
        //lockRewardOf(msg.sender);
            
        emit RewardTaken(msg.sender, _reward, "Rewards Sent");          
    }
    
//==staking & unstaking

    modifier antiWhale(address _address) {
        require(myStakeShare(_address) < 20000, "User stake% share too high. Leave some for the smaller guys ;-)"); //max 20%
        _;
    } 
    // avoids stakes being deposited once a user reached 20%. 
    // Simplistic implementation as if we calculate "futureStake" value very 1st stakers will not be able to deposit.
    
    function stake(uint256 _amount) public poolLive antiSpam(1) antiWhale(msg.sender){
        require(_amount > 0, "Cannot stake 0");
        
        //initialize
        userMetrics[msg.sender].rewardAccrued = lockRewardOf(msg.sender); //Locks previous eligible rewards based on lastRewardEvent and lastStakingEvent
        pointsSnapshot(msg.sender);

        //receive staked
        uint256 _balanceNow = IERC20(address(poolMetrics.stakedToken)).balanceOf(address(this));
        IERC20(poolMetrics.stakedToken).transferFrom(msg.sender, address(this), _amount); //will require allowance
        uint256 amount = IERC20(address(poolMetrics.stakedToken)).balanceOf(address(this)).sub(_balanceNow); //actually received
        
        //update pool and user based on stake and fee
        uint256 _fee = amount.mul(poolMetrics.stakingFee).div(1000);
        amount = amount.sub(_fee);
        
        if(poolMetrics.stakedToken == poolMetrics.rewardToken){poolMetrics.rewards = poolMetrics.rewards.add(_fee);}
        poolMetrics.staked = poolMetrics.staked.add(amount);
        userMetrics[msg.sender].stake = userMetrics[msg.sender].stake.add(amount);

        //finalize
        pointsSnapshot(msg.sender); //updates lastEvent
        emit userStaking(msg.sender, amount, "Staking... ... ");
        
    } 
    
    function unStake(uint256 _amount) public poolStarted antiSpam(1) { 
        require(_amount > 0, "Cannot withdraw 0");
        require(_amount <= userMetrics[msg.sender].stake, "Cannot withdraw more than stake");

        //initialize
        userMetrics[msg.sender].rewardAccrued = lockRewardOf(msg.sender); //snapshot of  previous eligible rewards based on lastStakingEvent
        pointsSnapshot(msg.sender);

        // update metrics
        userMetrics[msg.sender].stake = userMetrics[msg.sender].stake.sub(_amount);
        poolMetrics.staked = poolMetrics.staked.sub(_amount);

        // transfer _amount. Put at the end of the function to avoid reentrancy.
        IERC20(poolMetrics.stakedToken).transfer(msg.sender, _amount);
        
        //finalize
        emit userWithdrawal(msg.sender, _amount, "Widhtdrawal");
    }

    function myStake(address _address) public view returns(uint256) {
        return userMetrics[_address].stake;
    }
    function myStakeShare(address _address) public view returns(uint256) {
        if(poolMetrics.staked == 0){return 0;}
        else {
        return (userMetrics[_address].stake).mul(100000).div(poolMetrics.staked);}
    } //base 100,000
    function myPointsShare(address _address) public view returns(uint256) {  //weighted average of your stake over time vs the pool
        return viewPointsOf(_address).mul(100000).div(viewPoolPoints());
    } //base 100,000. Drops when taking rewards.=> Refills after (favors strong hands)
    function myRewards(address _address) public view returns(uint256) {
        //delayed start obfuscation (avoids disturbances in the force...)
        if(block.timestamp <= poolMetrics.startTime || poolMetrics.rewards == 0){return 0;}
        else { return userMetrics[_address].rewardAccrued.add(viewAdditionalRewardOf(_address));} //previousLock + time based extra
    }

//== OPERATOR FUNCTIONS ==

    address public poolOperator;
    
    function setPoolOperator(address _address) public onlyPoolOperator {
        poolOperator = _address;
    }
    modifier onlyPoolOperator() {
        require(msg.sender == poolOperator, "msg.sender is not allowed to operate Pool");
        _;
    }
    
    bool public FullRewards;
    uint256 totalRewards;
    
    function setFullRewards(bool _bool) public onlyPoolOperator {
        FullRewards = _bool;
    }
    function loadRewards(uint256 _amount, uint256 _preStake) public onlyPoolOperator { //load tokens in the rewards pool.
        
        uint256 _balanceNow = IERC20(address(poolMetrics.rewardToken)).balanceOf(address(this));
        IERC20(address(poolMetrics.rewardToken)).transferFrom( msg.sender,  address(this),  _amount);
        uint256 amount = IERC20(address(poolMetrics.rewardToken)).balanceOf(address(this)).sub(_balanceNow); //actually received
        

        if(poolMetrics.rewards == 0){                                   // initialization
        poolMetrics.staked = SafeMath.add(poolMetrics.staked,_preStake);}  // creates baseline for pool. Avoids massive movements on rewards
        
        poolMetrics.rewards = SafeMath.add(poolMetrics.rewards,amount);
        totalRewards = totalRewards.add(_amount);
    }    
    function setFee(uint256 _fee) public onlyPoolOperator {
        poolMetrics.stakingFee = _fee;
    }
    
    function flushPool(address _recipient, address _ERC20address) external onlyPoolOperator poolEnded { // poolEnded { // poolEnded returns(bool) {
            uint256 _amount = IERC20(_ERC20address).balanceOf(address(this));
            IERC20(_ERC20address).transfer(_recipient, _amount); //use of the _ERC20 traditional transfer
            //return true;
        } //get tokens sent by error to contract
    function killPool() public onlyPoolOperator poolEnded returns(bool) {
            selfdestruct(msg.sender);
        } //frees space on the ETH chain

}