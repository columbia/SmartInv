/*
███████╗██╗░░░██╗███╗░░░██╗░██████╗░░░░██████╗░░██████╗░██╗░░░░██╗███████╗██████╗░███████╗██████╗░
██╔════╝╚██╗░██╔╝████╗░░██║██╔════╝░░░░██╔══██╗██╔═══██╗██║░░░░██║██╔════╝██╔══██╗██╔════╝██╔══██╗
███████╗░╚████╔╝░██╔██╗░██║██║░░░░░░░░░██████╔╝██║░░░██║██║░█╗░██║█████╗░░██████╔╝█████╗░░██║░░██║
╚════██║░░╚██╔╝░░██║╚██╗██║██║░░░░░░░░░██╔═══╝░██║░░░██║██║███╗██║██╔══╝░░██╔══██╗██╔══╝░░██║░░██║
███████║░░░██║░░░██║░╚████║╚██████╗░░░░██║░░░░░╚██████╔╝╚███╔███╔╝███████╗██║░░██║███████╗██████╔╝
╚══════╝░░░╚═╝░░░╚═╝░░╚═══╝░╚═════╝░░░░╚═╝░░░░░░╚═════╝░░╚══╝╚══╝░╚══════╝╚═╝░░╚═╝╚══════╝╚═════╝░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
░██████╗██████╗░██╗░░░██╗██████╗░████████╗░██████╗░██████╗░░██████╗░███╗░░░██╗██████╗░███████╗░░░░
██╔════╝██╔══██╗╚██╗░██╔╝██╔══██╗╚══██╔══╝██╔═══██╗██╔══██╗██╔═══██╗████╗░░██║██╔══██╗██╔════╝░░░░
██║░░░░░██████╔╝░╚████╔╝░██████╔╝░░░██║░░░██║░░░██║██████╔╝██║░░░██║██╔██╗░██║██║░░██║███████╗░░░░
██║░░░░░██╔══██╗░░╚██╔╝░░██╔═══╝░░░░██║░░░██║░░░██║██╔══██╗██║░░░██║██║╚██╗██║██║░░██║╚════██║░░░░
╚██████╗██║░░██║░░░██║░░░██║░░░░░░░░██║░░░╚██████╔╝██████╔╝╚██████╔╝██║░╚████║██████╔╝███████║░░░░
░╚═════╝╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░░░░░░░╚═╝░░░░╚═════╝░╚═════╝░░╚═════╝░╚═╝░░╚═══╝╚═════╝░╚══════╝░░░░
*/

pragma solidity ^0.6.0;


interface ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes calldata data) external;
}








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
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
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




/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
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













contract Sync is IERC20, Ownable {
  using SafeMath for uint256;

  mapping (address => uint256) private balances;
  mapping (address => mapping (address => uint256)) private allowed;
  string public constant name  = "SYNC";
  string public constant symbol = "SYNC";
  uint8 public constant decimals = 18;
  uint256 _totalSupply = 16000000 * (10 ** 18); // 16 million supply

  mapping (address => bool) public mintContracts;

  modifier isMintContract() {
    require(mintContracts[msg.sender],"calling address is not allowed to mint");
    _;
  }

  constructor() public Ownable(){
    balances[msg.sender] = _totalSupply;
    emit Transfer(address(0), msg.sender, _totalSupply);
  }

  function setMintAccess(address account, bool canMint) public onlyOwner {
    mintContracts[account]=canMint;
  }

  function _mint(address account, uint256 amount) public isMintContract {
    require(account != address(0), "ERC20: mint to the zero address");
    _totalSupply = _totalSupply.add(amount);
    balances[account] = balances[account].add(amount);
    emit Transfer(address(0), account, amount);
  }

  function totalSupply() public view override returns (uint256) {
    return _totalSupply;
  }

  function balanceOf(address user) public view override returns (uint256) {
    return balances[user];
  }

  function allowance(address user, address spender) public view override returns (uint256) {
    return allowed[user][spender];
  }

  function transfer(address to, uint256 value) public override returns (bool) {
    require(value <= balances[msg.sender],"insufficient balance");
    require(to != address(0),"cannot send to zero address");

    balances[msg.sender] = balances[msg.sender].sub(value);
    balances[to] = balances[to].add(value);

    emit Transfer(msg.sender, to, value);
    return true;
  }

  function approve(address spender, uint256 value) public override returns (bool) {
    require(spender != address(0),"cannot approve the zero address");
    allowed[msg.sender][spender] = value;
    emit Approval(msg.sender, spender, value);
    return true;
  }

  function approveAndCall(address spender, uint256 tokens, bytes calldata data) external returns (bool) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
        return true;
    }

  function transferFrom(address from, address to, uint256 value) public override returns (bool) {
    require(value <= balances[from],"insufficient balance");
    require(value <= allowed[from][msg.sender],"insufficient allowance");
    require(to != address(0),"cannot send to the zero address");

    balances[from] = balances[from].sub(value);
    balances[to] = balances[to].add(value);

    allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);

    emit Transfer(from, to, value);
    return true;
  }

  function burn(uint256 amount) external {
    require(amount != 0,"must burn more than zero");
    require(amount <= balances[msg.sender],"insufficient balance");
    _totalSupply = _totalSupply.sub(amount);
    balances[msg.sender] = balances[msg.sender].sub(amount);
    emit Transfer(msg.sender, address(0), amount);
  }

}



contract FRS is Ownable {
  using SafeMath for uint256;

  //Constant and pseudo constant values
  uint256 constant public INITIAL_DAILY_REWARD = 5000000 * (10**18); //Base daily reward amount. A reduction is applied to this which increases over time to compute the actual daily reward.
  uint256 constant public TIME_INCREMENT=1 days;//Amount of time between each Sync release.

  //Variables related to the day index
  mapping(uint256 => mapping(address => uint256)) public amountEntered; //Amount of Eth entered by day index, by user.
  mapping(uint256 => uint256) public totalDailyContribution; //Total amount of Eth entered for the given day index.
  mapping(uint256 => uint256) public totalDailyRewards; //Total amount of tokens to be distributed for the given day index.
  mapping(uint256 => mapping(address => uint256)) public totalDailyPayouts; //Amount paid out to given user address for each given day index.
  uint256 public currentDayIndex=0;//Current day index. Represents the number of Sync releases which have occurred. Will also represent the number of days which have passed since the contract started, minus the number of days which have been skipped due to inactivity.

  //Other mappings
  mapping(uint256 => address payable) public maintainers;//A list of maintainer addresses, which are given a portion of Sync rewards.

  //Timing variables
  uint256 public nextDayAt=0;//The timestamp at which the current release is finalized and the next one begins.
  uint256 public firstEntryTime=0;//The time of the very first interaction with the contract, is the starting point for the first day.

  //External contracts
  Sync public syncToken;//The Sync token contract. The FRS contract mints these tokens to reward to users daily.

  constructor(address token) public Ownable(){//(address tokenAddr,address fundAddr) public{
    syncToken=Sync(token);
    totalDailyRewards[currentDayIndex]=INITIAL_DAILY_REWARD;
    maintainers[0]=0x464376466Ea0494Ff0bC90260c46f98c56c8c746;
    maintainers[1]=0x2fFD215E32bF25366172a5470FCEA3182C6c718F;
    maintainers[2]=0xaF35f3685C92b83E8e64880441FA39FE2B6Fcf48;
    maintainers[3]=0x5ed7D8e2089B2B0e15439735B937CeC5F0ae811B;
    maintainers[4]=0x73b8c96A1131C19B6A0Dc972099eE5E2B328f66B;
    maintainers[5]=0x8AB0b38B5331ADAe0EDfB713c714521964C5bCCC;
  }

  /*
    Transfers the appropriate amount of Eth and Sync to the maintainers; to be called at the conclusion of each release.
  */
  function distributeToMaintainers(uint256 syncAmount) private{
    if(syncAmount>0){
      uint256 syncAmt1=syncAmount.mul(5).div(100);
      uint256 syncAmt2=syncAmount.mul(283).div(1000);//28.3%, half of the remainder after 5*3%
      syncToken._mint(maintainers[0],syncAmt1);
      syncToken._mint(maintainers[1],syncAmt1);
      syncToken._mint(maintainers[2],syncAmt1);

      syncToken._mint(maintainers[3],syncAmt2);
      syncToken._mint(maintainers[4],syncAmt2);
      syncToken._mint(maintainers[5],syncAmt2);
    }
    uint256 ethAmount=address(this).balance;
    if(ethAmount>0){
      uint256 ethAmt1=ethAmount.mul(5).div(100);//5%
      uint256 ethAmt2=ethAmount.mul(283).div(1000);//28.3%

      //send used rather than transfer to remove possibility of denial of service by refusing transfer
      maintainers[0].send(ethAmt1);
      maintainers[1].send(ethAmt1);
      maintainers[2].send(ethAmt1);

      maintainers[3].send(ethAmt2);
      maintainers[4].send(ethAmt2);
      maintainers[5].send(ethAmt2);
    }
  }

  /*
    Function for entering Eth into the release for the current day.
  */
  function enter() external payable{
    require(msg.value>0,"payment required");
    //Concludes the previous contest if needed
    updateDay();
    //Record user contribution
    amountEntered[currentDayIndex][msg.sender]+=msg.value;
    totalDailyContribution[currentDayIndex]+=msg.value;
  }

  /*
    If the current release has concluded, perform all operations necessary to progress to the next release.
  */
  function updateDay() private{
    //starts timer if first transaction
    if(nextDayAt==0){
      //The first transaction to this contract determines which time each day the release will conclude.
      nextDayAt=block.timestamp.add(TIME_INCREMENT);
      firstEntryTime=block.timestamp;
    }
    if(block.timestamp>=nextDayAt){
      distributeToMaintainers(totalDailyRewards[currentDayIndex]);
      //Determine the minimum number of days to add so that the next release ends at a future date. This is done so that every release will end at the same time of day.
      uint256 daysToAdd=1+(block.timestamp-nextDayAt)/TIME_INCREMENT;
      nextDayAt+=TIME_INCREMENT*daysToAdd;
      currentDayIndex+=1;
      //for every month until the 13th, rewards are cut in half.
      uint256 numMonths=block.timestamp.sub(firstEntryTime).div(30 days);
      if(numMonths>12){
        totalDailyRewards[currentDayIndex]=0;
      }
      else{
        totalDailyRewards[currentDayIndex]=INITIAL_DAILY_REWARD.div(2**numMonths);
      }
    }
  }

  /*
    Function for users to withdraw rewards for multiple days.
  */
  function withdrawForMultipleDays(uint256[] calldata dayList) external{
    //Concludes the previous contest if needed
    updateDay();
    uint256 cumulativeAmountWon=0;
    uint256 amountWon=0;
    for(uint256 i=0;i<dayList.length;i++){
      amountWon=_withdrawForDay(dayList[i],currentDayIndex,msg.sender);
      cumulativeAmountWon+=amountWon;
      totalDailyPayouts[dayList[i]][msg.sender]+=amountWon;//record how much was paid
    }
    syncToken._mint(msg.sender,cumulativeAmountWon);
  }

  /*
    Function for users to withdraw rewards for a single day.
  */
  function withdrawForDay(uint256 day) external{
    //Concludes the previous contest if needed
    updateDay();
    uint256 amountWon=_withdrawForDay(day,currentDayIndex,msg.sender);
    totalDailyPayouts[day][msg.sender]+=amountWon;//record how much was paid
    syncToken._mint(msg.sender,amountWon);
  }

  /*
    Returns amount that should be withdrawn for the given day.
  */
  function _withdrawForDay(uint256 day,uint256 dayCursor,address user) public view returns(uint256){
    if(day>=dayCursor){//you can only withdraw funds for previous days
      return 0;
    }
    //Amount owed is proportional to the amount entered by the user vs the total amount of Eth entered.
    uint256 amountWon=totalDailyRewards[day].mul(amountEntered[day][user]).div(totalDailyContribution[day]);
    uint256 amountPaid=totalDailyPayouts[day][user];
    return amountWon.sub(amountPaid);
  }

  /*
    The following functions are only used externally, intended to assist with frontend calculations, not meant to be called onchain.
  */

  /*
    Returns the current day index as it will be after updateDay is called.
  */
  function currentDayIndexActual() external view returns(uint256){
    if(block.timestamp>=nextDayAt){
      return currentDayIndex+1;
    }
    else{
      return currentDayIndex;
    }
  }

  /*
    Returns the amount of Sync the user will get if withdrawing for the provided day indices.
  */
  function getPayoutForMultipleDays(uint256[] calldata dayList,uint256 dayCursor,address addr) external view returns(uint256){
    uint256 cumulativeAmountWon=0;
    for(uint256 i=0;i<dayList.length;i++){
      cumulativeAmountWon+=_withdrawForDay(dayList[i],dayCursor,addr);
    }
    return cumulativeAmountWon;
  }

  /*
    Returns a list of day indexes for which the given user has available rewards.
  */
  function getDaysWithFunds(uint256 start,uint256 end,address user) external view returns(uint256[] memory){
    uint256 numDays=0;
    for(uint256 i=start;i<min(currentDayIndex+1,end);i++){
      if(amountEntered[i][user]>0){
        numDays+=1;
      }
    }
    uint256[] memory dwf=new uint256[](numDays);
    uint256 cursor=0;
    for(uint256 i=start;i<min(currentDayIndex+1,end);i++){
      if(amountEntered[i][user]>0){
        dwf[cursor]=i;
        cursor+=1;
      }
    }
    return dwf;
  }

  /*
    Utility function, returns the smaller number.
  */
  function min(uint256 n1,uint256 n2) internal pure returns(uint256){
    if(n1<n2){
      return n1;
    }
    else{
      return n2;
    }
  }
}