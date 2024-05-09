//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.12;


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



abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}


library TransferHelper {
    function safeApprove(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
    }

    function safeTransfer(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
    }

    function safeTransferFrom(address token, address from, address to, uint value) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
    }

    function safeTransferETH(address to, uint value) internal {
        (bool success,) = to.call{value:value}(new bytes(0));
        require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
    }
}



contract Distribute is Context {
    using SafeMath for uint;

    mapping(address => bool) public isParticipate;

    mapping(address => uint256) public giverBalance; 

    struct UserInfo {
        uint256 value;

        uint256 flagBlock;

        uint256 preBlockReward;

        uint256 withdraw;
    }

    mapping(address => UserInfo) userDepositInfo;

    //time params
    uint256 public  getSonEndTime;

    uint256 public  giveSonEndTime;

    uint256 public  depositEndBlock;

    //balance params
    uint256 public getBalance;

    uint256 public stakeBalance;

    uint256 public giveEthBalance;
   
    uint256 public giveVitalikEtherValue;

    //balance to giver
    uint256 private constant PER_GET_REWARD = 2 ether;

    uint256 private constant PER_DEPOSIT_REWARD = 50 ether;  

    uint256 private constant PER_GIVER_REWARD =  150 ether;
    
    //limited value
    uint256 private constant MAX_GIVER_VALUE = 3 ether;

    uint256 private constant MAX_DEPOSIT_VALUE = 5 ether;

    //STAKE_BLOCK must > depositEndBlock
    uint256 private constant STAKE_BLOCK = 288000;

    uint256 public constant GIVE_VITALIK_BLOCK_TIME = 1612022400;

    //address
    address public constant VITALIK_ADDRESS = address(0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B);
    
    address public dev;

    //flag
    bool private isInnit;
 
    uint private unlocked = 1;
 
    IERC20  son;

    event GetSon(address getAddress);
    event DepositeGetSon(address getAddress, uint256 value);
    event WithdrawDepositReward(address user, uint256 value);
    event WithdrawDepositEther(address user, uint256 value);
    event Unlock(address user, address value);
    event GiverGetSon(address getAddress, uint256 giverEtherValue);
    event GiverToVitalik(address _vitalikAddress, uint256 value);
    event TransferDev(address oldDev, address newDev);

    constructor()public {
        dev = msg.sender;
    }

    receive() external payable {

    }

    modifier lock() {
        require(unlocked == 1, 'Son Distribute: LOCKED');
        unlocked = 0;
        _;
        unlocked = 1;
    }
    
    //init son Address;
    function initSon(address sonAddress) public {
        require(!isInnit,"Son Distribute: is already init");

        require(msg.sender == dev);

        son = IERC20(sonAddress);

        getSonEndTime = block.timestamp + 15 days;

        giveSonEndTime = block.timestamp + 15 days;

        depositEndBlock = block.number + 86400;

        require(STAKE_BLOCK.sub(depositEndBlock.sub(block.number)) > 0, "Son Distribute: stake period must > deposit period!");

        uint256 toThisAddress = son.totalSupply().mul(95).div(100);

        require(son.balanceOf(address(this)) == toThisAddress);

        getBalance = toThisAddress.mul(20).div(100);
        stakeBalance = toThisAddress.mul(50).div(100);
        giveEthBalance = toThisAddress.sub(getBalance).sub(stakeBalance);

        isInnit = true;
    }
    

    //airdrop
    function getSon() public lock {

        require(block.timestamp <= getSonEndTime,"Son Distribute: free get Son is End!");
        
        require(getBalance >= PER_GET_REWARD,"Son Distribute: have no enough son to giver!");

        require(!isParticipate[msg.sender],"Son Distribute: Have already taken part in!");
        
        getBalance = getBalance.sub(PER_GET_REWARD);

        isParticipate[msg.sender] = true;

        TransferHelper.safeTransfer(address(son),msg.sender,PER_GET_REWARD);

        emit GetSon(msg.sender);
    }


    function depositGetSon() public payable lock{
        require(msg.value > 100 gwei,"Son Distribute: too small value");

        require(msg.value <= MAX_DEPOSIT_VALUE,"Son Distribute: over max deposit");

        require(block.number < depositEndBlock,"Son Distribute: deposit time is end!");

        require(userDepositInfo[msg.sender].value == 0,"Son Distribute: already deposit");

        uint256 getSonBalance = msg.value.mul(PER_DEPOSIT_REWARD).div(10 ** 18);

        require(stakeBalance >= getSonBalance,"Son Distribute: not enough son to give!");

        stakeBalance = stakeBalance.sub(getSonBalance);

        uint256 preReward = getSonBalance.div(depositEndBlock.sub(block.number));

        userDepositInfo[msg.sender] = UserInfo({value:msg.value,flagBlock: block.number,preBlockReward:preReward,withdraw:0});

        emit DepositeGetSon(_msgSender(),msg.value);
    }

    function checkDepositInfo(address user) public view returns(uint256,uint256,uint256,uint256) {

        return (userDepositInfo[user].value, userDepositInfo[user].flagBlock, userDepositInfo[user].preBlockReward, userDepositInfo[user].withdraw);

    }



    function pendingDepositReward(address user) public view returns(uint256 amount){

        if(block.number >= depositEndBlock){
            
            amount = userDepositInfo[user].value.mul(PER_DEPOSIT_REWARD).div(10 ** 18).sub(userDepositInfo[user].withdraw);
 
        }else{

             amount = block.number.sub(userDepositInfo[user].flagBlock).mul(userDepositInfo[user].preBlockReward).sub(userDepositInfo[user].withdraw);
    
        }
    
    }

    function withdrawDepositReward() public lock{

        require(userDepositInfo[msg.sender].value > 0,"Son Distribute: have no deposit");

        uint256 newWithdraw = pendingDepositReward(msg.sender);

        require(newWithdraw > 0, "Son Distribute: no reward to give");

        userDepositInfo[msg.sender].withdraw = userDepositInfo[msg.sender].withdraw.add(newWithdraw);

        TransferHelper.safeTransfer(address(son),msg.sender,newWithdraw);

        emit WithdrawDepositReward(msg.sender,newWithdraw);
    }


    function withdrawDepositEther() public payable lock {
        
        require(userDepositInfo[msg.sender].value > 0,"Son Distribute: have no deposit");
        
        //check stake finish
        require(block.number.sub(userDepositInfo[msg.sender].flagBlock) >= STAKE_BLOCK,"Son Distribute: still in staking");
        
        //check if already withdraw
        require(userDepositInfo[msg.sender].flagBlock < depositEndBlock,"Son Distribute: already withdraw");

        uint256 sendAmount = userDepositInfo[msg.sender].value;

        userDepositInfo[msg.sender].flagBlock = block.number;

        TransferHelper.safeTransferETH(_msgSender(),sendAmount);

        emit WithdrawDepositEther(msg.sender,sendAmount);
    }


    function giverGetSon() public payable lock {
        require(msg.value > 0,"Son Distribute: no ether!");

        require(block.timestamp <= giveSonEndTime,"Son Distribute: not in the period");
        
        require(giverBalance[msg.sender].add(msg.value) <= MAX_GIVER_VALUE,"Son Distribute: is over MAX_GIVER_VALUE");

        giverBalance[msg.sender] = giverBalance[msg.sender].add(msg.value);

        uint256 getSonBalance = msg.value.mul(PER_GIVER_REWARD).div(10 ** 18);

        require(giveEthBalance >= getSonBalance,"Son Distribute: not enough son to give!");

        giveEthBalance = giveEthBalance.sub(getSonBalance);

        TransferHelper.safeTransfer(address(son),_msgSender(),getSonBalance);

        giveVitalikEtherValue = giveVitalikEtherValue.add(msg.value);

        emit GiverGetSon(_msgSender(),msg.value);
    }


    function giverToVitalik() public lock{

        require(block.timestamp >= GIVE_VITALIK_BLOCK_TIME,"Son Distribute: block timestamp limited!");

        require(giveVitalikEtherValue > 0,"Son Distribute: no ether to give!");

        uint256 toValue = giveVitalikEtherValue;

        giveVitalikEtherValue = 0;

        TransferHelper.safeTransferETH(VITALIK_ADDRESS,toValue);

        emit GiverToVitalik(VITALIK_ADDRESS,toValue);
    }


    function getRemianSon() public  {

        uint256 toValue;

        if (getBalance > 0 && block.timestamp > getSonEndTime) {
            toValue = toValue.add(getBalance);
            getBalance = 0;
            
        }

        if (stakeBalance > 0 && block.number > depositEndBlock) {
            toValue = toValue.add(stakeBalance);
            stakeBalance = 0;  
        }

        if(giveEthBalance > 0 && block.timestamp > giveSonEndTime) {
            toValue = toValue.add(giveEthBalance);
            giveEthBalance = 0;
        }

        require(toValue > 0,"Son Distribute: no value to give back!");

        TransferHelper.safeTransfer(address(son),dev,toValue);
    }


    function transferDev(address _dev) public {
        require(msg.sender == dev,"Son Distribute: not dev!");
        dev = _dev;
        emit TransferDev(msg.sender, dev);
    }

}