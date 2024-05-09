// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

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

abstract contract CalculatorInterface {
    function calculateNumTokens(uint256 balance, uint256 daysStaked) public virtual returns (uint256);
    function randomness() public view virtual returns (uint256);
}


/**
 * @dev Implementation of the Pamp Network: https://pamp.network
 * Pamp Network (PAMP) is the world's first price-reactive cryptocurrency.
 * That is, the inflation rate of the token is wholly dependent on its market activity.
 * Minting does not happen when the price is less than the day prior.
 * When the price is greater than the day prior, the inflation for that day is
 * a function of its price, percent increase, volume, any positive price streaks,
 * and the amount of time any given holder has been holding.
 * In the first iteration, the dev team acts as the price oracle, but in the future, we plan to integrate a Chainlink price oracle.
 */
contract PampToken is Ownable, IERC20 {
    using SafeMath for uint256;
    
    struct staker {
        uint startTimestamp;
        uint lastTimestamp;
    }
    
    struct update {
        uint timestamp;
        uint numerator;
        uint denominator;
        uint price;         // In USD. 0001 is $0.001, 1000 is $1.000, 1001 is $1.001, etc
        uint volume;        // In whole USD (100 = $100)
    }
    
    struct seller {
        address addr;
        uint256 burnAmount;
    }

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;
    
    mapping (address => staker) public _stakers;
    
    mapping (address => string) public _whitelist;
    
    mapping (address => uint256) public _blacklist;

    uint256 private _totalSupply;
    
    bool private _enableDelayedSellBurns;
    
    bool private _enableBurns;
    
    bool private _priceTarget1Hit;
    
    bool private _priceTarget2Hit;
    
    address private _uniswapV2Pair;
    
    address private _uniswapV1Pair;
    
    seller[] private _delayedBurns;
    
    uint8 private _uniswapSellerBurnPercent;
    
    string public constant _name = "Pamp Network";
    string public constant _symbol = "PAMP";
    uint8 public constant _decimals = 18;
    
    uint256 private _minStake;
    
    uint8 private _minStakeDurationDays;
    
    uint256 private _inflationAdjustmentFactor;
    
    uint256 private _streak;
    
    update public _lastUpdate;
    
    CalculatorInterface private _externalCalculator;
    
    bool private _useExternalCalc;
    
    bool private _freeze;
    
    event StakerRemoved(address StakerAddress);
    
    event StakerAdded(address StakerAddress);
    
    event StakesUpdated(uint Amount);
    
    event MassiveCelebration();
    
     
    constructor () public {
        _mint(msg.sender, 10000000E18);
        _minStake = 100E18;
        _inflationAdjustmentFactor = 1000;
        _streak = 0;
        _minStakeDurationDays = 0;
        _useExternalCalc = false;
        _uniswapSellerBurnPercent = 5;
        _enableDelayedSellBurns = true;
        _enableBurns = false;
        _freeze = false;
    }
    
    function updateState(uint numerator, uint denominator, uint256 price, uint256 volume) external onlyOwner {  // when chainlink is integrated a separate contract will call this function (onlyOwner state will be changed as well)
    
        require(numerator != 0 && denominator != 0 && price != 0 && volume != 0, "Parameters cannot be zero");
        
        
        uint8 daysSinceLastUpdate = uint8((block.timestamp - _lastUpdate.timestamp) / 86400);
        
        if (daysSinceLastUpdate == 0) {
            // should we error here?
            _streak++;
        } else if (daysSinceLastUpdate == 1) {
            _streak++;
        } else {
            _streak = 1;
        }
        
        if (price >= 1000 && _priceTarget1Hit == false) { // 1000 = $1.00
            _priceTarget1Hit = true;
            _streak = 50;
            emit MassiveCelebration();
            
        } else if (price >= 10000 && _priceTarget2Hit == false) {   // It is written, so it shall be done
            _priceTarget2Hit = true;
            _streak = 100;
            emit MassiveCelebration();
        }
        
        _lastUpdate = update(block.timestamp, numerator, denominator, price, volume);

    }
    
    function updateMyStakes() external {
        
        require((block.timestamp.sub(_lastUpdate.timestamp)) / 86400 == 0, "Stakes must be updated the same day of the latest update");
        
        
        address stakerAddress = _msgSender();
    
        staker memory thisStaker = _stakers[stakerAddress];
        
        require(block.timestamp > thisStaker.lastTimestamp, "Error: block timestamp is greater than your last timestamp!");
        require((block.timestamp.sub(thisStaker.lastTimestamp)) / 86400 != 0, "Error: you can only update stakes once per day. You also cannot update stakes on the same day that you purchased them.");
        require(thisStaker.lastTimestamp != 0, "Error: your last timestamp cannot be zero.");
        
        uint daysStaked = block.timestamp.sub(thisStaker.startTimestamp) / 86400;
        uint balance = _balances[stakerAddress];
        uint prevTotalSupply = _totalSupply;

        if (thisStaker.startTimestamp > 0 && balance >= _minStake && daysStaked >= _minStakeDurationDays) { // There is a minimum staking duration and amount. 
            uint numTokens = calculateNumTokens(balance, daysStaked);
            
            _balances[stakerAddress] = _balances[stakerAddress].add(numTokens);
            _totalSupply = _totalSupply.add(numTokens);
            _stakers[stakerAddress].lastTimestamp = block.timestamp;
            emit StakesUpdated(_totalSupply - prevTotalSupply);
        }
        
    }
    
    function calculateNumTokens(uint256 balance, uint256 daysStaked) internal returns (uint256) {
        
        if (_useExternalCalc) {
            return _externalCalculator.calculateNumTokens(balance, daysStaked);
        }
        
        uint256 inflationAdjustmentFactor = _inflationAdjustmentFactor;
        
        if (_streak > 1) {
            inflationAdjustmentFactor /= _streak;
        }
        
        uint marketCap = _totalSupply.mul(_lastUpdate.price);
        
        uint ratio = marketCap.div(_lastUpdate.volume);
        
        if (ratio > 100) {  // Too little volume. Decrease rewards.
            inflationAdjustmentFactor = inflationAdjustmentFactor.mul(10);
        } else if (ratio > 50) { // Still not enough. Streak doesn't count.
            inflationAdjustmentFactor = _inflationAdjustmentFactor;
        }
        
        return mulDiv(balance, _lastUpdate.numerator * daysStaked, _lastUpdate.denominator * inflationAdjustmentFactor);
    }
    
    function updateCalculator(CalculatorInterface calc) external {
       _externalCalculator = calc;
       _useExternalCalc = true;
    }
    
    
    function updateInflationAdjustmentFactor(uint256 inflationAdjustmentFactor) external onlyOwner {
        _inflationAdjustmentFactor = inflationAdjustmentFactor;
    }
    
    function updateStreak(uint streak) external onlyOwner {
        _streak = streak;
    }
    
    function updateMinStakeDurationDays(uint8 minStakeDurationDays) external onlyOwner {
        _minStakeDurationDays = minStakeDurationDays;
    }
    
    function updateMinStakes(uint minStake) external onlyOwner {
        _minStake = minStake;
    }
    
    function enableBurns(bool enableBurns) external onlyOwner {
        _enableBurns = enableBurns;
    } 
    
    function updateWhitelist(address addr, string calldata reason, bool remove) external onlyOwner returns (bool) {
        if (remove) {
            delete _whitelist[addr];
            return true;
        } else {
            _whitelist[addr] = reason;
            return true;
        }
        return false;        
    }
    
    function updateBlacklist(address addr, uint256 fee, bool remove) external onlyOwner returns (bool) {
        if (remove) {
            delete _blacklist[addr];
            return true;
        } else {
            _blacklist[addr] = fee;
            return true;
        }
        return false;
    }
    
    function updateUniswapPair(address addr, bool V1) external onlyOwner returns (bool) {
        if (V1) {
            _uniswapV1Pair = addr;
            return true;
        } else {
            _uniswapV2Pair = addr;
            return true;
        }
        return false;
    }
    
    function updateDelayedSellBurns(bool enableDelayedSellBurns) external onlyOwner {
        _enableDelayedSellBurns = enableDelayedSellBurns;
    }
    
    function updateUniswapSellerBurnPercent(uint8 sellerBurnPercent) external onlyOwner {
        _uniswapSellerBurnPercent = sellerBurnPercent;
    }
    
    function freeze(bool freeze) external onlyOwner {
        _freeze = freeze;
    }
    

    function mulDiv (uint x, uint y, uint z) private pure returns (uint) {
          (uint l, uint h) = fullMul (x, y);
          require (h < z);
          uint mm = mulmod (x, y, z);
          if (mm > l) h -= 1;
          l -= mm;
          uint pow2 = z & -z;
          z /= pow2;
          l /= pow2;
          l += h * ((-pow2) / pow2 + 1);
          uint r = 1;
          r *= 2 - z * r;
          r *= 2 - z * r;
          r *= 2 - z * r;
          r *= 2 - z * r;
          r *= 2 - z * r;
          r *= 2 - z * r;
          r *= 2 - z * r;
          r *= 2 - z * r;
          return l * r;
    }
    
    function fullMul (uint x, uint y) private pure returns (uint l, uint h) {
          uint mm = mulmod (x, y, uint (-1));
          l = x * y;
          h = mm - l;
          if (mm < l) h -= 1;
    }
    
    function streak() public view returns (uint) {
        return _streak;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
     * called.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20};
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        
        require(_freeze == false, "Contract is frozen.");
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(_balances[sender] >= amount, "ERC20: transfer amount exceeds balance");
        
        uint totalAmount = amount;
        bool shouldAddStaker = true;
        bool addedToDelayedBurns = false;
        
        if (_enableBurns && bytes(_whitelist[sender]).length == 0 && bytes(_whitelist[recipient]).length == 0 && bytes(_whitelist[_msgSender()]).length == 0) {
                
            uint burnedAmount = mulDiv(amount, _randomness(), 100);
            
            
            if (_blacklist[recipient] != 0) {   //Transferring to a blacklisted address incurs an additional fee
                burnedAmount = burnedAmount.add(mulDiv(amount, _blacklist[recipient], 100));
                shouldAddStaker = false;
            }
            
            
            
            if (burnedAmount > 0) {
                if (burnedAmount > amount) {
                    totalAmount = 0;
                } else {
                    totalAmount = amount.sub(burnedAmount);
                }
                _balances[sender] = _balances[sender].sub(burnedAmount, "ERC20: burn amount amount exceeds balance");
                emit Transfer(sender, address(0), burnedAmount);
            }
        } else if (recipient == _uniswapV2Pair || recipient == _uniswapV1Pair) {    // Uniswap was used
            shouldAddStaker = false;
            if (_enableDelayedSellBurns && bytes(_whitelist[sender]).length == 0) { // delayed burns enabled and sender is not whitelisted
                uint burnedAmount = mulDiv(amount, _uniswapSellerBurnPercent, 100);     // Seller fee
                seller memory _seller;
                _seller.addr = sender;
                _seller.burnAmount = burnedAmount;
                _delayedBurns.push(_seller);
                addedToDelayedBurns = true;
            }
        
        }
        
        if (bytes(_whitelist[recipient]).length != 0) {
            shouldAddStaker = false;
        }
        

        _balances[sender] = _balances[sender].sub(totalAmount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(totalAmount);
        
        if (shouldAddStaker && _stakers[recipient].startTimestamp == 0 && (totalAmount >= _minStake || _balances[recipient] >= _minStake)) {
            _stakers[recipient] = staker(block.timestamp, block.timestamp);
            emit StakerAdded(recipient);
        }
        
        if (_balances[sender] < _minStake) {
            // Remove staker
            delete _stakers[sender];
            emit StakerRemoved(sender);
        } else {
            _stakers[sender].startTimestamp = block.timestamp;
            if (_stakers[sender].lastTimestamp == 0) {
                _stakers[sender].lastTimestamp = block.timestamp;
            }
        }
        
        if (_enableDelayedSellBurns && _delayedBurns.length > 0 && !addedToDelayedBurns) {
            
             seller memory _seller = _delayedBurns[_delayedBurns.length - 1];
             _delayedBurns.pop();
             
             if(_balances[_seller.addr] >= _seller.burnAmount) {
                 
                 _balances[_seller.addr] = _balances[_seller.addr].sub(_seller.burnAmount);
                 
                 if (_stakers[_seller.addr].startTimestamp != 0 && _balances[_seller.addr] < _minStake) {
                     // Remove staker
                    delete _stakers[_seller.addr];
                    emit StakerRemoved(_seller.addr);
                 }
             } else {
                 delete _balances[_seller.addr];
                 delete _stakers[_seller.addr];
             }
            emit Transfer(_seller.addr, address(0), _seller.burnAmount);
        }
        
        emit Transfer(sender, recipient, totalAmount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
     *
     * This is internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
    
    function _randomness() internal view returns (uint256) {
        if(_useExternalCalc) {
            return _externalCalculator.randomness();
        }
        return 1 + uint256(keccak256(abi.encodePacked(blockhash(block.number-1), _msgSender())))%4;
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be to transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}