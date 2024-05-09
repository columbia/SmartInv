pragma solidity 0.6.12;

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


interface StakingContract {
    function getStaker(address _staker) external view virtual returns (uint256, uint256, bool);
}

interface Calculator {
    function calculateTokensOwed(address account) external view virtual returns (uint256);
}
interface Administrator {
    function resetStakeTimeDebug(address account, uint lastTimestamp, uint startTimestamp, bool migrated) external virtual;
    function swapExactETHForTokensAddLiquidity(address[] calldata path, uint liquidityETH, uint swapETH)
      external
      payable
      returns (uint liquidity);
}

interface UniswapV2Router{
    function addLiquidityETH(
      address token,
      uint amountTokenDesired,
      uint amountTokenMin,
      uint amountETHMin,
      address to,
      uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
      external
      payable
      returns (uint[] memory amounts);
      
     function WETH() external pure returns (address);

}

// PAMP Time is a derivative token of time staked in the Pamp Network staking ecosystem
// It can be redeemed for 1 day staked per token, and also has non-inflationary staking/farming mechanics
contract PAMPTime is IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;
    uint256 public maxSupply;
    uint public stakedTotalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;
    
    uint public numLeftSale;
    
    uint public rate;
    
    bool public saleEnabled;
    
    uint public maxSecondsPerAddress;
    
    uint public minStakeDurationDays;
    
    address payable public owner;
    
    bool public freeze;
    
    bool public enableBurns;
    
    bool public claimsEnabled;
    
    bool public redemptionsEnabled;
    
    uint public burnPercent;       // 1 decimal place; 20 = 2.0
    
    uint public cycleDaysStaked;
    
    bool public stakingEnabled;
    
    uint public rewardsPool;
    
    IERC20 public pampToken;
    
    IERC20 public uniswapPair;
    
    StakingContract public stakingContract;
    
    Administrator public admin;
    
    UniswapV2Router public router;
    
    Calculator public calculator;
    
    bool public useCalc;
    
    mapping (address => bool) public uniswapPairs;
    
    mapping (address => string) public whitelist;
    
    mapping (address => Claim) public claims;
    
    mapping (address => uint) public secondsRedeemed;
    
    mapping (address => Staker) public stakers;
    
    address[] path;
    
    struct Staker {
        uint poolTokenBalance;
        uint startTimestamp;
    }
    
    struct Claim {
        bool claimed50;
        bool claimed100;
        bool claimed200;
    }
    
    modifier onlyOwner() {
        assert(msg.sender == owner);
        _;
    }

    /**
     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
     * a default value of 18.
     *
     * To select a different value for {decimals}, use {_setupDecimals}.
     *
     * All three of these values are immutable: they can only be set once during
     * construction.
     */
    constructor () public {
        owner = msg.sender;
        _name = "Pamp Time";
        _symbol = "PTIME";
        _decimals = 18;
        maxSupply = 10000E18;
        burnPercent = 20;
        rate = 75000000000000000;
        numLeftSale = 4000E18;
        minStakeDurationDays = 2;
        freeze = true;
        enableBurns = true;
        claimsEnabled = false;
        redemptionsEnabled = false;
        stakingEnabled = false;
        maxSecondsPerAddress = 4320000; // 50 days
        _mint(msg.sender, 1000E18);
        whitelist[owner] = "Owner";

        router = UniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        pampToken = IERC20(0xF0FAC7104aAC544e4a7CE1A55ADF2B5a25c65bD1);
        stakingContract = StakingContract(0x738d3CEC4E685A2546Ab6C3B055fd6B8C1198093);
        admin = Administrator(0x0Ee85192B3ba619ADa35462e7fa9f511a44C3736);
        path.push(router.WETH());
        path.push(address(this));
        whitelist[address(router)] = "UniswapV2Router";
        whitelist[address(this)] = "Token contract";
        whitelist[address(admin)] = "Administrator";
        cycleDaysStaked = 30;
    }
    
    function claimPTIME() external { // Claim TIME tokens based on days staked on PAMP
        (uint tokens, uint daysStaked) = calculateClaimableTokens(msg.sender);  // Calculate how many you can claim
        require(tokens > 0, "You have no tokens to claim");
        require(_totalSupply.add(tokens) <= maxSupply, "Max supply reached");       // There is a maximum supply
        require(claimsEnabled);
        if(daysStaked > 50 && daysStaked < 100) {
            claims[msg.sender].claimed50 = true;            // We only allow 3 claims for the life of an account so we store the claims in claims[] array
        } else if(daysStaked >= 100 && daysStaked < 200) {
            claims[msg.sender].claimed100 = true;
        } else if(daysStaked >= 200) {
            claims[msg.sender].claimed200 = true;
        }
        
        _mint(msg.sender, tokens); 
    }
    
    function calculateClaimableTokens(address pampStaker) public view returns (uint256, uint256) {
        (uint startTimestamp, uint lastTimestamp, bool hasMigrated) = stakingContract.getStaker(pampStaker); // Get staker information from staking contract
        if(!hasMigrated || startTimestamp == 0) {
            return (0,0);
        }
        uint daysStaked = block.timestamp.sub(startTimestamp) / 86400;  // Calculate time staked in days
        uint balance = pampToken.balanceOf(pampStaker);
        Claim memory claim = claims[pampStaker];
        
        if(daysStaked > 50 && daysStaked < 100 && balance >= 1000E18 && !claim.claimed50) {     //Self-explanatory; we're just checking days staked and balance and returning the amount to be claimed
            if(balance < 5000E18) {
                return (1E18, daysStaked);
            } else if (balance >= 5000E18 && balance < 10000E18) {
                return (3E18, daysStaked);
            } else if (balance >= 10000E18) {
                return (5E18, daysStaked);
            }
        } else if(daysStaked >= 100 && daysStaked < 200 && balance >= 1000E18 && !claim.claimed100) {
            if(balance < 5000E18) {
                return (2E18, daysStaked);
            } else if (balance >= 5000E18 && balance < 10000E18) {
                return (6E18, daysStaked);
            } else if (balance >= 10000E18) {
                return (10E18, daysStaked);
            }
        } else if(daysStaked >= 200 && balance >= 1000E18 && !claim.claimed200) {
            if(balance < 5000E18) {
                return (2E18, daysStaked);
            } else if (balance >= 5000E18 && balance < 10000E18) {
                return (6E18, daysStaked);
            } else if (balance >= 10000E18) {
                return (10E18, daysStaked);
            }
        }
        return (0, 0);      // else, no tokens can be claimed
    }
    
    function redeemPTIME(uint tokens) external {    // Redeem (burn) TIME tokens for extra days staked in PAMP staking
        require(tokens > 0);
        require(redemptionsEnabled);
        _burn(msg.sender, tokens);
        (uint startTimestamp, uint lastTimestamp, bool hasMigrated) = stakingContract.getStaker(msg.sender);        // get staker info
        require(startTimestamp != 0 && hasMigrated);
        uint secondsAdded = mulDiv(86400, tokens, 1E18);                                        // We calculate the seconds to be subtracted from the staker's timestamp
        secondsRedeemed[msg.sender] = secondsRedeemed[msg.sender].add(secondsAdded);            // There is a max number of seconds that can be redeemd for the lifetime of an address (50 days)
        require(secondsRedeemed[msg.sender] <= maxSecondsPerAddress, "You have used more than the max of 50 days");
        admin.resetStakeTimeDebug(msg.sender, lastTimestamp, startTimestamp.sub(secondsAdded), hasMigrated);        // Proxy contract calls this function on the staking contract
    }
    
    
    
    function stakeLiquidityTokens(uint256 numPoolTokensToStake) external {
        require(numPoolTokensToStake > 0);
        require(stakingEnabled, "Staking is currently disabled.");
        
        uniswapPair.transferFrom(msg.sender, address(this), numPoolTokensToStake);      // Transfer liquidity tokens from the sender to this contract
        
        Staker storage thisStaker = stakers[msg.sender];                                // Get the sender's information
        
        if(thisStaker.startTimestamp == 0 || thisStaker.poolTokenBalance == 0) {
            thisStaker.startTimestamp = block.timestamp;
        } else {                                                                        // If the sender is currently staking, adding to his balance results in a holding time penalty
            uint percent = mulDiv(1000000, numPoolTokensToStake, thisStaker.poolTokenBalance);      // This is not really 'percent' it is just a number that represents the number of pool tokens to stake as a fraction of the token balance
            if(percent.add(thisStaker.startTimestamp) > block.timestamp) {         // We represent the 'percent' or 'penalty' as seconds and add to the recipient's unix time
               thisStaker.startTimestamp = block.timestamp; // Receiving too many tokens resets your holding time
            } else {
                thisStaker.startTimestamp = thisStaker.startTimestamp.add(percent);               
            }
        }
        
        thisStaker.poolTokenBalance = thisStaker.poolTokenBalance.add(numPoolTokensToStake);
        
    }
    
    function withdrawLiquidityTokens(uint256 numPoolTokensToWithdraw) external {
        
        require(numPoolTokensToWithdraw > 0);
        
        Staker storage thisStaker = stakers[msg.sender];
        
        require(thisStaker.poolTokenBalance >= numPoolTokensToWithdraw, "Pool token balance too low");
        
        uint daysStaked = block.timestamp.sub(thisStaker.startTimestamp) / 86400;  // Calculate time staked in days
        
        require(daysStaked >= minStakeDurationDays);
        
        uint tokensOwed = calculateTokensOwed(msg.sender);      // We give all of the rewards owed to the sender on a withdrawal, regardless of the amount withdrawn
        
        thisStaker.poolTokenBalance = thisStaker.poolTokenBalance.sub(numPoolTokensToWithdraw);
        
        thisStaker.startTimestamp = block.timestamp; // Reset staking timer on withdrawal
        
        _balances[msg.sender] = _balances[msg.sender].add(tokensOwed);      // Could also do this with _transfer, but the balance of address(this) is zero
        rewardsPool = rewardsPool.sub(tokensOwed);                          // We keep track of the rewards pool and remove tokens sent (instead of using _balances[address(this)])
        emit Transfer(address(this), msg.sender, tokensOwed);               // However removing tokens from the pool decreases everyone else's rewards, which might create a misaligned incentive (TBD)
        
        uniswapPair.transfer(msg.sender, numPoolTokensToWithdraw);          // Give staker back their UNI-V2
    }
    
    function withdrawRewards() external {   // Same as above, but we don't remove their poolTokenBalance (UNI-V2)
        
        Staker storage thisStaker = stakers[msg.sender];
        
        uint daysStaked = block.timestamp.sub(thisStaker.startTimestamp) / 86400;  // Calculate time staked in days
        
        require(daysStaked >= minStakeDurationDays);
        
        uint tokensOwed = calculateTokensOwed(msg.sender);
        
        thisStaker.startTimestamp = block.timestamp; // Reset staking timer on withdrawal
        _balances[msg.sender] = _balances[msg.sender].add(tokensOwed);
        rewardsPool = rewardsPool.sub(tokensOwed);
        emit Transfer(address(this), msg.sender, tokensOwed);
    }
    
    // If you call this function you forfeit your rewards
    function emergencyWithdrawLiquidityTokens() external {
        Staker storage thisStaker = stakers[msg.sender];
        uint poolTokenBalance = thisStaker.poolTokenBalance;
        thisStaker.poolTokenBalance = 0;
        thisStaker.startTimestamp = block.timestamp;
        uniswapPair.transfer(msg.sender, poolTokenBalance);
    }
    
    
   
    function addToRewardsPool(address sender, uint tokens) internal {   // This is like a burn but goes to the staker rewards pool instead
        _balances[sender] = _balances[sender].sub(tokens);
        rewardsPool = rewardsPool.add(tokens);
        emit Transfer(sender, address(this), tokens);
    }
    
    function AddToRewardsPool(uint tokens) external { // This will likely not be used unless we (or somebody) want to donate to staking
        addToRewardsPool(msg.sender, tokens);
    }
    
        
    function buyPTIME(address beneficiary) public payable {     // Used for presale
        require(saleEnabled, "Sale is disabled");
        require(msg.value <= 50E18 && msg.value >= rate);       // Max contribution is 50 ETH (but obviousy somebody can call this function multiple times or from multiple addresses; sybil resistance is not really important)
        uint tokens = mulDiv(1E18, msg.value, rate);            // Basically just divide the contribution by the rate and you get your tokens
        numLeftSale = numLeftSale.sub(tokens);
        _mint(beneficiary, tokens);
    }
    
    function endSale() external onlyOwner {         // When the sale is over we add half the ETH and sold tokens to Uniswap
        require(saleEnabled);
        saleEnabled = false;
        //freeze = false;
        uint liquidityPTIME = (4000E18 - numLeftSale) / 2;      // However many were sold, divide it by 2, mint them and and add them to Uniswap
        uint devShare = address(this).balance / 2;
        uint liquidityETH = address(this).balance.sub(devShare);        // Half the ETH goes to Uniswap
        owner.transfer(devShare);                                       // Half goes to us for development and marketing
        _approve(address(this), address(router), 100000000000E18);      // Approve the router to spend our tokens
        _mint(address(this), liquidityPTIME);
        (uint amountToken, uint amountETH, uint liquidity) = router.addLiquidityETH{value: liquidityETH}(address(this), liquidityPTIME, 0, 0, address(this), block.timestamp.add(86400));
        stakers[address(this)].poolTokenBalance = liquidity;            // Our liquidity is staking
        stakers[address(this)].startTimestamp = block.timestamp;
    }
    
    function AddEthLiquidity() external payable { // This function allows you to add liquidity and begin staking without needing any tokens (just ETH)
        require(stakingEnabled, "Staking is disabled"); 
        require(msg.value > 0);
        uint swapETH = msg.value / 2; // ETH used for swap (buying tokens)
        uint liquidityETH = msg.value.sub(swapETH); // ETH used for liquidity addition (along with bought tokens)
        _approve(address(admin), address(router), 100000000000E18);
        uint liquidity = admin.swapExactETHForTokensAddLiquidity{value: msg.value}(path, liquidityETH, swapETH);        // We use another contract for the swap and add because Uniswap won't let us use the token contract address in the 'to' field of the swap function
        
        Staker storage thisStaker = stakers[msg.sender];
         if(thisStaker.startTimestamp == 0 || thisStaker.poolTokenBalance == 0) {       // Staker begins staking immediately
            thisStaker.startTimestamp = block.timestamp;
        } else {                                                                        // If the sender is currently staking, adding to his balance results in a holding time penalty
            uint percent = mulDiv(1000000, liquidity, thisStaker.poolTokenBalance);      // This is not really 'percent' it is just a number that represents the totalAmount as a fraction of the recipientBalance
            if(percent.add(thisStaker.startTimestamp) > block.timestamp) {         // We represent the 'percent' or 'penalty' as seconds and add to the recipient's unix time
               thisStaker.startTimestamp = block.timestamp; // Receiving too many tokens resets your holding time
            } else {
                thisStaker.startTimestamp = thisStaker.startTimestamp.add(percent);               
            }
        }
        
        thisStaker.poolTokenBalance = thisStaker.poolTokenBalance.add(liquidity);   
    }
    
    function claimContractRewards(address beneficiary) external onlyOwner {         // Claim rewards on behalf of the contract and have them sent to a beneficiary (team wallet)
        Staker storage thisStaker = stakers[address(this)];
        
        uint daysStaked = block.timestamp.sub(thisStaker.startTimestamp) / 86400;  // Calculate time staked in days
        
        uint tokensOwed = calculateTokensOwed(address(this));
        
        thisStaker.startTimestamp = block.timestamp; // Reset staking timer on withdrawal
        _balances[beneficiary] = _balances[beneficiary].add(tokensOwed);
        rewardsPool = rewardsPool.sub(tokensOwed);
        emit Transfer(address(this), beneficiary, tokensOwed);
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
    
    function getStaker(address _staker) external view returns (uint, uint, uint, uint) {
        return (stakers[_staker].startTimestamp, 0, stakers[_staker].poolTokenBalance, 0); // We use 0 to comply with the interface of the other liquidity staking contracts
    }
    
    function calculateTokensOwed(address account) public view returns (uint256) {
        if(useCalc) {
            return calculator.calculateTokensOwed(account);
        }
        Staker memory staker = stakers[msg.sender];
        uint daysStaked = block.timestamp.sub(staker.startTimestamp) / 86400;
        if(staker.startTimestamp == 0 || daysStaked == 0) {
            return 0;
        }
        uint factor = mulDiv(daysStaked*1E18, rewardsPool, cycleDaysStaked*1E18);        // If 100% of the staking pool is staked for the full cycle and claims, we get 100% of the rewards pool returned.
        return mulDiv(factor, staker.poolTokenBalance, uniswapPair.totalSupply());  // The formula takes into account your percent share of the Uniswap pool and your days staked. You will get the same amount per day, in theory (but in practice the size of the pool is constantly changing)
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
        _transfer(msg.sender, recipient, amount);
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
        _approve(msg.sender, spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * Requirements:
     *
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
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
        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
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
        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
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
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(sender == owner || sender == address(this) || !freeze, "Contract is frozen");
        
        uint totalAmount = amount;
        
        
        if (enableBurns && bytes(whitelist[sender]).length == 0 && bytes(whitelist[recipient]).length == 0) {
            // Sender and recipient are not in the whitelist
            uint burnedAmount = mulDiv(amount, burnPercent/2, 1000); // Amount to be burned. Divide by 2 because half is burned and the other half goes to staking rewards pool
            
            if (burnedAmount > 0) {
                if (burnedAmount > amount) {
                    totalAmount = 0;
                } else {
                    totalAmount = amount.sub(burnedAmount);
                }
                _burn(sender, burnedAmount);  // Remove the burned amount from the sender's balance
                addToRewardsPool(sender, burnedAmount);
            }
        } else if (enableBurns && uniswapPairs[recipient] == true && sender != address(admin)) {    // Uniswap was used. This is a special case. Uniswap is burn on receive but whitelist on send, so sellers pay fee and buyers do not.
                uint burnedAmount = mulDiv(amount, burnPercent/2, 1000);     // Seller fee
                if (burnedAmount > 0) {
                    if (burnedAmount > amount) {
                        totalAmount = 0;
                    } else {
                        totalAmount = amount.sub(burnedAmount);
                    }
                    _burn(sender, burnedAmount);
                    addToRewardsPool(sender, burnedAmount);
                }
        }
        

        _balances[sender] = _balances[sender].sub(totalAmount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(totalAmount);
        emit Transfer(sender, recipient, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }
    
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
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
    
    function updateWhitelist(address addr, string calldata reason, bool remove) external onlyOwner {
        if (remove) {
            delete whitelist[addr];
        } else {
            whitelist[addr] = reason;
        }
    }
    
    function updateStakingContract(address _newContract) external onlyOwner {
        stakingContract = StakingContract(_newContract);
    }
    
    function updateAdministrator(address _admin) external onlyOwner {
        admin = Administrator(_admin);
        whitelist[_admin] = "Administrator";
    }
    
    function updateToken(address _newToken) external onlyOwner {
        pampToken = IERC20(_newToken);
    }
    
    function transferOwnership(address payable _newOwner) external onlyOwner {
        owner = _newOwner;
    }
    
    function updateFreeze(bool _freeze) external onlyOwner {
        freeze = _freeze;
    }
    
    function updateRate(uint _rate) external onlyOwner {
        rate = _rate;
    }
    
    function updateSaleEnabled(bool _saleEnabled) external onlyOwner {
        saleEnabled = _saleEnabled;
    }
    
    function updateMaxSecondsPerAddress(uint max) external onlyOwner {
        maxSecondsPerAddress = max;
    }
    
    function updateStakingEnabled(bool _stakingEnabled) external onlyOwner {
        stakingEnabled = _stakingEnabled;
    }
    
    function updateEnableBurns(bool _burnsEnabled) external onlyOwner {
        enableBurns = _burnsEnabled;
    }
    
    function updateUniswapPair(address _pair) external onlyOwner {
        uniswapPair = IERC20(_pair);
        uniswapPairs[_pair] = true;
        whitelist[_pair] = "UniswapPair";
    }
    
    function updateUniswapPairs(address addr, bool remove) external onlyOwner {
        if (remove) {
            delete uniswapPairs[addr];
        } else {
            uniswapPairs[addr] = true;
        }
    }
    
    function updateClaimsEnabled(bool _enabled) external onlyOwner {
        claimsEnabled = _enabled;
    }
    
    function updateRedemptionsEnabled(bool _enabled) external onlyOwner {
        redemptionsEnabled = _enabled;
    }
    
    function updateCurrentCycleDays(uint _days) external onlyOwner {
        cycleDaysStaked = _days;
    }
    
    function updateRouter(address _router) external onlyOwner {
        router = UniswapV2Router(_router);
    }
    
    function updateCalculator(address calc) external onlyOwner {
        if(calc == address(0)) {
            useCalc = false;
        } else {
            calculator = Calculator(calc);
            useCalc = true;
        }
    }
    
    
     // This function was not written by us. It was taken from here: https://medium.com/coinmonks/math-in-solidity-part-3-percents-and-proportions-4db014e080b1
    // Takes in three numbers and calculates x * (y/z)
    // This is very useful for this contract as percentages are used constantly

    function mulDiv (uint x, uint y, uint z) public pure returns (uint) {
          (uint l, uint h) = fullMul (x, y);
          assert (h < z);
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
    
    receive() external payable {
        buyPTIME(msg.sender);
    }
    
    fallback() external payable {
        buyPTIME(msg.sender);
    }
    
    function emergencyWithdrawETH() external onlyOwner {
        owner.transfer(address(this).balance);
    }
    
    
}