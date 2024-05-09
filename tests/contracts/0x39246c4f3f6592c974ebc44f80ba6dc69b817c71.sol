// File: @openzeppelin/contracts/GSN/Context.sol

pragma solidity ^0.5.0;

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

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

pragma solidity ^0.5.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see {ERC20Detailed}.
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

// File: @openzeppelin/contracts/math/SafeMath.sol

pragma solidity ^0.5.0;

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

// File: @openzeppelin/contracts/token/ERC20/ERC20.sol

pragma solidity ^0.5.0;




/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20Mintable}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view returns (uint256) {
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
    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public returns (bool) {
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
     * - the caller must have allowance for `sender`'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
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
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
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
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
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
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
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
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

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
    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: burn from the zero address");

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
    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
     * from the caller's allowance.
     *
     * See {_burn} and {_approve}.
     */
    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
    }
}

// File: contracts/lib/CompoundOracleInterface.sol

pragma solidity ^0.5.0;
// AT MAINNET ADDRESS: 0x02557a5E05DeFeFFD4cAe6D83eA3d173B272c904

contract CompoundOracleInterface {
    // returns asset:eth -- to get USDC:eth, have to do 10**24/result,


    constructor() public {
    }

    /**
  * @notice retrieves price of an asset
  * @dev function to get price for an asset
  * @param asset Asset for which to get the price
  * @return uint mantissa of asset price (scaled by 1e18) or zero if unset or contract paused
  */
    function getPrice(address asset) public view returns (uint);
    function getUnderlyingPrice(ERC20 cToken) public view returns (uint);
    // function getPrice(address asset) public view returns (uint) {
    //     return 527557000000000;
    // }

}

// File: contracts/lib/UniswapExchangeInterface.sol

pragma solidity 0.5.10;


// Solidity Interface
contract UniswapExchangeInterface {
    // Address of ERC20 token sold on this exchange
    function tokenAddress() external view returns (address token);
    // Address of Uniswap Factory
    function factoryAddress() external view returns (address factory);
    // Provide Liquidity
    function addLiquidity(uint256 min_liquidity, uint256 max_tokens, uint256 deadline) external payable returns (uint256);
    function removeLiquidity(uint256 amount, uint256 min_eth, uint256 min_tokens, uint256 deadline) external returns (uint256, uint256);
    // Get Prices
    function getEthToTokenInputPrice(uint256 eth_sold) external view returns (uint256 tokens_bought);
    function getEthToTokenOutputPrice(uint256 tokens_bought) external view returns (uint256 eth_sold);
    function getTokenToEthInputPrice(uint256 tokens_sold) external view returns (uint256 eth_bought);
    function getTokenToEthOutputPrice(uint256 eth_bought) external view returns (uint256 tokens_sold);
    // Trade ETH to ERC20
    function ethToTokenSwapInput(uint256 min_tokens, uint256 deadline) external payable returns (uint256  tokens_bought);
    function ethToTokenTransferInput(uint256 min_tokens, uint256 deadline, address recipient) external payable returns (uint256  tokens_bought);
    function ethToTokenSwapOutput(uint256 tokens_bought, uint256 deadline) external payable returns (uint256  eth_sold);
    function ethToTokenTransferOutput(uint256 tokens_bought, uint256 deadline, address recipient) external payable returns (uint256  eth_sold);
    // Trade ERC20 to ETH
    function tokenToEthSwapInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline) external returns (uint256  eth_bought);
    function tokenToEthTransferInput(uint256 tokens_sold, uint256 min_eth, uint256 deadline, address recipient) external returns (uint256  eth_bought);
    function tokenToEthSwapOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline) external returns (uint256  tokens_sold);
    function tokenToEthTransferOutput(uint256 eth_bought, uint256 max_tokens, uint256 deadline, address recipient) external returns (uint256  tokens_sold);
    // Trade ERC20 to ERC20
    function tokenToTokenSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address token_addr) external returns (uint256  tokens_bought);
    function tokenToTokenTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_bought);
    function tokenToTokenSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address token_addr) external returns (uint256  tokens_sold);
    function tokenToTokenTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address token_addr) external returns (uint256  tokens_sold);
    // Trade ERC20 to Custom Pool
    function tokenToExchangeSwapInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address exchange_addr) external returns (uint256  tokens_bought);
    function tokenToExchangeTransferInput(uint256 tokens_sold, uint256 min_tokens_bought, uint256 min_eth_bought, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_bought);
    function tokenToExchangeSwapOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address exchange_addr) external returns (uint256  tokens_sold);
    function tokenToExchangeTransferOutput(uint256 tokens_bought, uint256 max_tokens_sold, uint256 max_eth_sold, uint256 deadline, address recipient, address exchange_addr) external returns (uint256  tokens_sold);
    // ERC20 comaptibility for liquidity tokens
    bytes32 public name;
    bytes32 public symbol;
    uint256 public decimals;
    function transfer(address _to, uint256 _value) external returns (bool);
    function transferFrom(address _from, address _to, uint256 value) external returns (bool);
    function approve(address _spender, uint256 _value) external returns (bool);
    function allowance(address _owner, address _spender) external view returns (uint256);
    function balanceOf(address _owner) external view returns (uint256);
    function totalSupply() external view returns (uint256);
    // Never use
    function setup(address token_addr) external;
}

// File: contracts/lib/UniswapFactoryInterface.sol

pragma solidity 0.5.10;


// Solidity Interface
contract UniswapFactoryInterface {
    // Public Variables
    address public exchangeTemplate;
    uint256 public tokenCount;
    // // Create Exchange
    function createExchange(address token) external returns (address exchange);
    // Get Exchange and Token Info
    function getExchange(address token) external view returns (address exchange);
    function getToken(address exchange) external view returns (address token);
    function getTokenWithId(uint256 tokenId) external view returns (address token);
    // Never use
    function initializeFactory(address template) external;
    // function createExchange(address token) external returns (address exchange) {
    //     return 0x06D014475F84Bb45b9cdeD1Cf3A1b8FE3FbAf128;
    // }
    // // Get Exchange and Token Info
    // function getExchange(address token) external view returns (address exchange){
    //     return 0x06D014475F84Bb45b9cdeD1Cf3A1b8FE3FbAf128;
    // }
    // function getToken(address exchange) external view returns (address token) {
    //     return 0x06D014475F84Bb45b9cdeD1Cf3A1b8FE3FbAf128;
    // }
    // function getTokenWithId(uint256 tokenId) external view returns (address token) {
    //     return 0x06D014475F84Bb45b9cdeD1Cf3A1b8FE3FbAf128;
    // }
}

// File: contracts/OptionsUtils.sol

pragma solidity 0.5.10;





contract OptionsUtils {
    // defauls are for mainnet
    UniswapFactoryInterface public UNISWAP_FACTORY;

    CompoundOracleInterface public COMPOUND_ORACLE;

    constructor(address _uniswapFactory, address _compoundOracle) public {
        UNISWAP_FACTORY = UniswapFactoryInterface(_uniswapFactory);
        COMPOUND_ORACLE = CompoundOracleInterface(_compoundOracle);
    }

    // TODO: for now gets Uniswap, later update to get other exchanges
    function getExchange(address _token)
        public
        view
        returns (UniswapExchangeInterface)
    {
        if (address(UNISWAP_FACTORY.getExchange(_token)) == address(0)) {
            revert("No payout exchange");
        }

        UniswapExchangeInterface exchange = UniswapExchangeInterface(
            UNISWAP_FACTORY.getExchange(_token)
        );

        return exchange;
    }

    function isETH(IERC20 _ierc20) public pure returns (bool) {
        return _ierc20 == IERC20(0);
    }
}

// File: contracts/OptionsExchange.sol

pragma solidity 0.5.10;






contract OptionsExchange {
    uint256 constant LARGE_BLOCK_SIZE = 1651753129000;
    uint256 constant LARGE_APPROVAL_NUMBER = 10**30;

    UniswapFactoryInterface public UNISWAP_FACTORY;

    constructor(address _uniswapFactory) public {
        UNISWAP_FACTORY = UniswapFactoryInterface(_uniswapFactory);
    }

    /*** Events ***/
    event SellOTokens(
        address seller,
        address payable receiver,
        address oTokenAddress,
        address payoutTokenAddress,
        uint256 oTokensToSell,
        uint256 payoutTokensReceived
    );
    event BuyOTokens(
        address buyer,
        address payable receiver,
        address oTokenAddress,
        address paymentTokenAddress,
        uint256 oTokensToBuy,
        uint256 premiumPaid
    );

    /**
    * @notice This function sells oTokens on Uniswap and sends back payoutTokens to the receiver
    * @param receiver The address to send the payout tokens back to
    * @param oTokenAddress The address of the oToken to sell
    * @param payoutTokenAddress The address of the token to receive the premiums in
    * @param oTokensToSell The number of oTokens to sell
    */
    function sellOTokens(
        address payable receiver,
        address oTokenAddress,
        address payoutTokenAddress,
        uint256 oTokensToSell
    ) public {
        // @note: first need to bootstrap the uniswap exchange to get the address.
        IERC20 oToken = IERC20(oTokenAddress);
        IERC20 payoutToken = IERC20(payoutTokenAddress);
        oToken.transferFrom(msg.sender, address(this), oTokensToSell);
        uint256 payoutTokensReceived = uniswapSellOToken(
            oToken,
            payoutToken,
            oTokensToSell,
            receiver
        );

        emit SellOTokens(
            msg.sender,
            receiver,
            oTokenAddress,
            payoutTokenAddress,
            oTokensToSell,
            payoutTokensReceived
        );
    }

    /**
    * @notice This function buys oTokens on Uniswap and using paymentTokens from the receiver
    * @param receiver The address to send the oTokens back to
    * @param oTokenAddress The address of the oToken to buy
    * @param paymentTokenAddress The address of the token to pay the premiums in
    * @param oTokensToBuy The number of oTokens to buy
    */
    function buyOTokens(
        address payable receiver,
        address oTokenAddress,
        address paymentTokenAddress,
        uint256 oTokensToBuy
    ) public payable {
        IERC20 oToken = IERC20(oTokenAddress);
        IERC20 paymentToken = IERC20(paymentTokenAddress);
        uniswapBuyOToken(paymentToken, oToken, oTokensToBuy, receiver);
    }

    /**
    * @notice This function calculates the amount of premiums that the seller
    * will receive if they sold oTokens on Uniswap
    * @param oTokenAddress The address of the oToken to sell
    * @param payoutTokenAddress The address of the token to receive the premiums in
    * @param oTokensToSell The number of oTokens to sell
    */
    function premiumReceived(
        address oTokenAddress,
        address payoutTokenAddress,
        uint256 oTokensToSell
    ) public view returns (uint256) {
        // get the amount of ETH that will be paid out if oTokensToSell is sold.
        UniswapExchangeInterface oTokenExchange = getExchange(oTokenAddress);
        uint256 ethReceived = oTokenExchange.getTokenToEthInputPrice(
            oTokensToSell
        );

        if (!isETH(IERC20(payoutTokenAddress))) {
            // get the amount of payout tokens that will be received if the ethRecieved is sold.
            UniswapExchangeInterface payoutExchange = getExchange(
                payoutTokenAddress
            );
            return payoutExchange.getEthToTokenInputPrice(ethReceived);
        }
        return ethReceived;

    }

    /**
    * @notice This function calculates the premiums to be paid if a buyer wants to
    * buy oTokens on Uniswap
    * @param oTokenAddress The address of the oToken to buy
    * @param paymentTokenAddress The address of the token to pay the premiums in
    * @param oTokensToBuy The number of oTokens to buy
    */
    function premiumToPay(
        address oTokenAddress,
        address paymentTokenAddress,
        uint256 oTokensToBuy
    ) public view returns (uint256) {
        // get the amount of ETH that needs to be paid for oTokensToBuy.
        UniswapExchangeInterface oTokenExchange = getExchange(oTokenAddress);
        uint256 ethToPay = oTokenExchange.getEthToTokenOutputPrice(
            oTokensToBuy
        );

        if (!isETH(IERC20(paymentTokenAddress))) {
            // get the amount of paymentTokens that needs to be paid to get the desired ethToPay.
            UniswapExchangeInterface paymentTokenExchange = getExchange(
                paymentTokenAddress
            );
            return paymentTokenExchange.getTokenToEthOutputPrice(ethToPay);
        }

        return ethToPay;
    }

    function uniswapSellOToken(
        IERC20 oToken,
        IERC20 payoutToken,
        uint256 _amt,
        address payable _transferTo
    ) internal returns (uint256) {
        require(!isETH(oToken), "Can only sell oTokens");
        UniswapExchangeInterface exchange = getExchange(address(oToken));

        if (isETH(payoutToken)) {
            //Token to ETH
            oToken.approve(address(exchange), _amt);
            return
                exchange.tokenToEthTransferInput(
                    _amt,
                    1,
                    LARGE_BLOCK_SIZE,
                    _transferTo
                );
        } else {
            //Token to Token
            oToken.approve(address(exchange), _amt);
            return
                exchange.tokenToTokenTransferInput(
                    _amt,
                    1,
                    1,
                    LARGE_BLOCK_SIZE,
                    _transferTo,
                    address(payoutToken)
                );
        }
    }

    function uniswapBuyOToken(
        IERC20 paymentToken,
        IERC20 oToken,
        uint256 _amt,
        address payable _transferTo
    ) public returns (uint256) {
        require(!isETH(oToken), "Can only buy oTokens");

        if (!isETH(paymentToken)) {
            UniswapExchangeInterface exchange = getExchange(
                address(paymentToken)
            );

            uint256 paymentTokensToTransfer = premiumToPay(
                address(oToken),
                address(paymentToken),
                _amt
            );
            paymentToken.transferFrom(
                msg.sender,
                address(this),
                paymentTokensToTransfer
            );

            // Token to Token
            paymentToken.approve(address(exchange), LARGE_APPROVAL_NUMBER);

            emit BuyOTokens(
                msg.sender,
                _transferTo,
                address(oToken),
                address(paymentToken),
                _amt,
                paymentTokensToTransfer
            );

            return
                exchange.tokenToTokenTransferInput(
                    paymentTokensToTransfer,
                    1,
                    1,
                    LARGE_BLOCK_SIZE,
                    _transferTo,
                    address(oToken)
                );
        } else {
            // ETH to Token
            UniswapExchangeInterface exchange = UniswapExchangeInterface(
                UNISWAP_FACTORY.getExchange(address(oToken))
            );

            uint256 ethToTransfer = exchange.getEthToTokenOutputPrice(_amt);

            emit BuyOTokens(
                msg.sender,
                _transferTo,
                address(oToken),
                address(paymentToken),
                _amt,
                ethToTransfer
            );

            return
                exchange.ethToTokenTransferOutput.value(ethToTransfer)(
                    _amt,
                    LARGE_BLOCK_SIZE,
                    _transferTo
                );
        }
    }

    function getExchange(address _token)
        internal
        view
        returns (UniswapExchangeInterface)
    {
        UniswapExchangeInterface exchange = UniswapExchangeInterface(
            UNISWAP_FACTORY.getExchange(_token)
        );

        if (address(exchange) == address(0)) {
            revert("No payout exchange");
        }

        return exchange;
    }

    function isETH(IERC20 _ierc20) internal pure returns (bool) {
        return _ierc20 == IERC20(0);
    }

    function() external payable {
        // to get ether from uniswap exchanges
    }

}