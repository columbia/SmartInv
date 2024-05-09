// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.6.0;

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


interface IDSDS {
  function epoch() external view returns (uint256);
  function couponsExpiration(uint256 epoch) external view returns (uint256);
  function transferCoupons(address sender, address recipient, uint256 epoch, uint256 amount) external;
}

contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor () internal {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

contract PooledDSDCoupons is ReentrancyGuard {

  using SafeMath for uint;

  IDSDS public DSDS = IDSDS(0x6Bf977ED1A09214E6209F4EA5f525261f1A2690a);
  address public owner;

  uint public totalSupply;
  string public constant name = "DSD Coupon Pool";
  string public constant symbol = "DPOOL";
  uint8 public constant decimals = 18;
  uint public constant WRAP_FEE_BPS = 100;

  mapping (address => uint) public balanceOf;
  mapping (address => mapping (address => uint)) public allowance;

  event Transfer(address indexed from, address indexed to, uint value);
  event Approval(address indexed owner, address indexed spender, uint value);

  constructor() public {
    owner = msg.sender;
  }

  function wrap(uint _epoch, uint _amount) public nonReentrant {
    uint expiresIn = DSDS.couponsExpiration(_epoch).sub(DSDS.epoch());
    require(expiresIn >= 120, "PooledDSDCoupons: coupon expires in less than 120 epochs");

    uint fee = _amount.mul(WRAP_FEE_BPS).div(10000);
    _mint(owner, fee);
    _mint(msg.sender, _amount.sub(fee));
    DSDS.transferCoupons(msg.sender, address(this), _epoch, _amount);
  }

  function unwrap(uint _epoch, uint _amount) public nonReentrant {
    _burn(msg.sender, _amount);
    DSDS.transferCoupons(address(this), msg.sender, _epoch, _amount);
  }

  // ERC20 functions

  function approve(address _spender, uint _amount) public returns (bool) {
    _approve(msg.sender, _spender, _amount);
    return true;
  }

  function transfer(address _recipient, uint _amount) public returns (bool) {
    _transfer(msg.sender, _recipient, _amount);
    return true;
  }

  function transferFrom(address _sender, address _recipient, uint _amount) public returns (bool) {
    _transfer(_sender, _recipient, _amount);
    _approve(_sender, msg.sender, allowance[_sender][msg.sender].sub(_amount, "ERC20: transfer amount exceeds allowance"));
    return true;
  }

  function _transfer(
    address _sender,
    address _recipient,
    uint _amount
  ) internal {
    require(_sender != address(0), "ERC20: transfer from the zero address");
    require(_recipient != address(0), "ERC20: transfer to the zero address");

    balanceOf[_sender] = balanceOf[_sender].sub(_amount, "ERC20: transfer amount exceeds balance");
    balanceOf[_recipient] = balanceOf[_recipient].add(_amount);

    emit Transfer(_sender, _recipient, _amount);
  }

  function _mint(address _account, uint _amount) internal {
    require(_account != address(0), "ERC20: mint to the zero address");

    totalSupply = totalSupply.add(_amount);
    balanceOf[_account] = balanceOf[_account].add(_amount);
    emit Transfer(address(0), _account, _amount);
  }

  function _burn(address _account, uint _amount) internal {
    require(_account != address(0), "ERC20: burn to the zero address");

    totalSupply = totalSupply.sub(_amount);
    balanceOf[_account] = balanceOf[_account].sub(_amount);
    emit Transfer(_account, address(0), _amount);
  }

  function _approve(address _owner, address _spender, uint _amount) internal {
    require(_owner != address(0), "ERC20: approve from the zero address");
    require(_spender != address(0), "ERC20: approve to the zero address");

    allowance[_owner][_spender] = _amount;
    emit Approval(_owner, _spender, _amount);
  }
}