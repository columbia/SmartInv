pragma solidity ^0.5.5;


// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol

/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
    function totalSupply() public view returns (uint256);
    function balanceOf(address who) public view returns (uint256);
    function transfer(address to, uint256 value) public returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
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
}

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol

/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
    function allowance(address owner, address spender) public view returns (uint256);
    function transferFrom(address from, address to, uint256 value) public returns (bool);
    function approve(address spender, uint256 value) public returns (bool);
    function name() public view returns (string memory);
    function symbol() public view returns (string memory);
    function decimals() public view returns (uint8);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: openzeppelin-solidity/contracts/ownership/Ownable.sol

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
    address public owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


    /**
    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
    * account.
    */
    constructor() public {
        owner = msg.sender;
    }

    /**
    * @dev Throws if called by any account other than the owner.
    */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    /**
    * @dev Allows the current owner to transfer control of the contract to a newOwner.
    * @param newOwner The address to transfer ownership to.
    */
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}

// File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol

/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable is Ownable {
    event Pause();
    event Unpause();

    bool public paused = false;


    /**
    * @dev Modifier to make a function callable only when the contract is not paused.
    */
    modifier whenNotPaused() {
        require(!paused);
        _;
    }

    /**
    * @dev Modifier to make a function callable only when the contract is paused.
    */
    modifier whenPaused() {
        require(paused);
        _;
    }

    /**
    * @dev called by the owner to pause, triggers stopped state
    */
    function pause() onlyOwner whenNotPaused public {
        paused = true;
        emit Pause();
    }

    /**
    * @dev called by the owner to unpause, returns to normal state
    */
    function unpause() onlyOwner whenPaused public {
        paused = false;
        emit Unpause();
    }
}

contract FilescoinPresale is Pausable {

    using SafeMath for uint256;

    enum PreSaleStage { One, Two, Three, Finished }

    ERC20 public token;
    uint256 public unit = 0;

    uint256 public PreSaleMinEther = 0.1 ether;
    uint256 public PreSaleMaxEther = 20 ether;
    uint256 public PreSaleStartTime = 1604750400; // 2020-11-07 12:00:00 UTC

    PreSaleStage public stage = PreSaleStage.One;

    uint256 public constant StageOneLimit = 1000 ether;
    uint256 public constant StageOneRatio = 3000;
    uint256 public StageOneCurrentSale = 0;

    uint256 public constant StageTwoLimit = 1000 ether;
    uint256 public constant StageTwoRatio = 2000;
    uint256 public StageTwoCurrentSale = 0;


    uint256 public constant StageThreeLimit = 1000 ether;
    uint256 public constant StageThreeRatio = 1000;
    uint256 public StageThreeCurrentSale = 0;


    constructor() public {
        address tokenAddress = 0xdf7795bF05e17c5c38E666d48b5fAC014DdFFF82;
        token = ERC20(tokenAddress);
        uint256 decimals = token.decimals();
        unit = 1 ether / (10 ** decimals );
    }

    function() payable external{
        require(block.timestamp >= PreSaleStartTime,"Pre-sale has not started yet");
        require(msg.value >= PreSaleMinEther,"Pre-sale value must be not less than 0.1 ether ");
        require(msg.value <= PreSaleMaxEther,"Pre-sale value must be no more than 20 ether ");
        preSale();
    }

    function preSale() internal whenNotPaused {
        require(stage != PreSaleStage.Finished,"Pre-sale is over");
        if(stage == PreSaleStage.One) {
            preSaleStageOne(msg.value);
        }else if(stage == PreSaleStage.Two){
            preSaleStageTwo(msg.value);
        }else {
            preSaleStageThree(msg.value);
        }

    }

    function preSaleStageOne(uint256 value) internal {
        uint256 stageOneLeft = StageOneLimit.sub(StageOneCurrentSale);
        uint256 preSaleValue = stageOneLeft < value ? stageOneLeft : value;
        StageOneCurrentSale += preSaleValue;
        if(StageOneCurrentSale == StageOneLimit) {
            stage = PreSaleStage.Two;
        }
        uint256 sendToken = preSaleValue.div(unit).mul(StageOneRatio);
        require(token.transfer(msg.sender,sendToken));
        if(value > preSaleValue) {
            preSaleStageTwo(value.sub(preSaleValue));
        }
    }

    function preSaleStageTwo(uint256 value) internal {
        uint256 stageTwoLeft = StageTwoLimit.sub(StageTwoCurrentSale);
        uint256 preSaleValue = stageTwoLeft < value ? stageTwoLeft : value;
        StageTwoCurrentSale += preSaleValue;
        if(StageTwoCurrentSale == StageTwoLimit) {
            stage = PreSaleStage.Three;
        }
        uint256 sendToken = preSaleValue.div(unit).mul(StageTwoRatio);
        require(token.transfer(msg.sender,sendToken));
        if(value > preSaleValue) {
            preSaleStageThree(value.sub(preSaleValue));
        }
    }

    function preSaleStageThree(uint256 value) internal {
        uint256 stageThreeLeft = StageThreeLimit.sub(StageThreeCurrentSale);
        uint256 preSaleValue = stageThreeLeft < value ? stageThreeLeft : value;
        StageThreeCurrentSale += preSaleValue;
        if(StageThreeCurrentSale == StageThreeLimit) {
            stage = PreSaleStage.Finished;
        }
        uint256 sendToken = preSaleValue.div(unit).mul(StageThreeRatio);
        require(token.transfer(msg.sender,sendToken));
        if(value > preSaleValue) {
            msg.sender.transfer(value.sub(preSaleValue));
        }
    }

    function withdrawToken(address to,uint value) onlyOwner whenNotPaused external {
        uint256 balance = token.balanceOf(address(this));
        require(balance >= value,"Token Balance is not enough");
        require(token.transfer(to,value));
    }

    function withdrawEther(address payable to,uint value) onlyOwner whenNotPaused external returns(bool) {
        require(to != address(0), "Receiver address must not be zero");
        to.transfer(value);
        return true;
    }

}