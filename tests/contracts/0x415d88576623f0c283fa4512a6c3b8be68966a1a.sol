pragma solidity 0.6.9;

/**
 * @title Ownable
 *
 * @notice Ownership related functions
 */
contract Ownable {
    address public _OWNER_;
    address public _NEW_OWNER_;

    // ============ Events ============

    event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // ============ Modifiers ============

    modifier onlyOwner() {
        require(msg.sender == _OWNER_, "NOT_OWNER");
        _;
    }

    // ============ Functions ============

    constructor() internal {
        _OWNER_ = msg.sender;
        emit OwnershipTransferred(address(0), _OWNER_);
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "INVALID_OWNER");
        emit OwnershipTransferPrepared(_OWNER_, newOwner);
        _NEW_OWNER_ = newOwner;
    }

    function claimOwnership() external {
        require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");
        emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);
        _OWNER_ = _NEW_OWNER_;
        _NEW_OWNER_ = address(0);
    }
}

/**
 * @title SafeMath
 *
 * @notice Math operations with safety checks that revert on error
 */
library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "MUL_ERROR");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "DIVIDING_ERROR");
        return a / b;
    }

    function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 quotient = div(a, b);
        uint256 remainder = a - quotient * b;
        if (remainder > 0) {
            return quotient + 1;
        } else {
            return quotient;
        }
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SUB_ERROR");
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "ADD_ERROR");
        return c;
    }

    function sqrt(uint256 x) internal pure returns (uint256 y) {
        uint256 z = x / 2 + 1;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }
}

interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    function decimals() external view returns (uint8);

    function name() external view returns (string memory);

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
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
}

/**
* code by tt
* evm version must after baizhanting
*/
contract InvitePool is Ownable {

    using SafeMath for uint256;

    //user 用户、superior 上级
    event Bind(address indexed user, address indexed superior);

    uint256  public BASE = 10000;
    uint256 public firstPercent = 500;
    uint256 public secondPercent = 500;

    constructor() public {
        _OWNER_ = msg.sender;
        god[0x2Be4dF32CB716Cc3BFb066e26B6590A014a02875] = true;
        emit OwnershipTransferred(address(0), _OWNER_);
    }

    struct User {
        address superUser; //上级
        address[] levelOne; //直推下级
    }

    mapping(address => User) public userInfo;
    mapping(address => bool) god;

    /**
    *关系绑定由用户直接调用直接调用
    */
    //绑定关系
    function bind(address _superUser) public {
        require(msg.sender != address(0) || _superUser != address(0), "0x0 not allowed");

        //为了可以给测试事件抛出方便，允许重复绑定
        require(userInfo[msg.sender].superUser == address(0), "already bind");
        require(msg.sender != _superUser, "do not bind yourself");

        //上级邀请人必须已绑定上级（创世地址除外）
        if (!god[_superUser]) {
            require(userInfo[_superUser].superUser != address(0), "invalid inviter");
        }

        userInfo[msg.sender].superUser = _superUser;
        if (_superUser != address(this)) {
            userInfo[_superUser].levelOne.push(msg.sender);
        }

        emit Bind(msg.sender, _superUser);
    }

    //获取用户信息
    function getUserInfo(address userAddr) public view returns (address superOne, uint256 first){
        return (userInfo[userAddr].superUser, userInfo[userAddr].levelOne.length);
    }

    //获取直推和间推关系
    function getInvited(address _user) public view returns (address[] memory){
        address[] memory one = userInfo[_user].levelOne;
        return one;
    }

    function compareStr(string memory _str, string memory str) public pure returns (bool) {
        if (keccak256(abi.encodePacked(_str)) == keccak256(abi.encodePacked(str))) {
            return true;
        }
        return false;
    }

    //设置创世地址
    function setGOD(address addr, bool on) public onlyOwner {
        god[addr] = on;
    }
}