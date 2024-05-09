/*
ABN = AutoBurn token
Deflationary. Low gas. Made simple.

This token has decreasing supply and increasing price achieved by 3% burn and 3% added 
to liquidity on each transaction except wallet to wallet transactions (non-contract).
This is done by direct balance adjustments which are much cheaper than calling external 
methods for sell, add liquidity and mint LP tokens functions on each trade. The pool 
is verified to stay in sync despite no additional LP tokens are minted or burned, 
proportionally rewarding any additional liquidity providers.

Price is driven up every day by burning 3% of ABN from liquidity pool while keeping WETH there
intact. Wallet and other pool balances are not daily burn, only WETH-ABN pool is affected.

Net size of a single transaction is limited to 1% of available supply, no limit on balances
and no limit for wallet to wallet transactions (non-contract).

If you get "error:undefined" on swap or "confirm" button is dead:
Check slippage, increase to 7%.
Set exact amount for ABN, not for the counterparty.
Check token available supply, 1% bought at once may be later sold in 2 or more transactions if
some supply was burn in meantime.

Tip to remove liquidity: Save one transaction fee by removing liquidity to WETH instead of ETH.

Disclaimer: This is an experimental project. DYOR and read contract code thoroughly before trading.
Check liquidity distribution and lock duration.
Deployer has no liability, direct or indirectly implied, of any loss or damage caused by bugs in
code or EVM, Solidity vulnerabilities, bot activity or malicious behavior of token holders.

*/


//SPDX-License-Identifier: UNLICENSED
// License: Parts different from open-zeppelin implementations are copyrighted. Any clones should send a 0.3% of tx value to deployer of this contract provided the tx is not considered feeless here.
pragma solidity =0.7.6;

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
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
    function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    function burn(uint256 amount) external returns (bool);
    function burnFrom(address account, uint256 amount) external returns (bool);
}

interface UNIV2Sync {
    function sync() external;
}

interface IWETH {
    function deposit() external payable;
    function balanceOf(address _owner) external returns (uint256);
    function transfer(address _to, uint256 _value) external returns (bool);
    function withdraw(uint256 _amount) external;
}



library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;
        return c;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}


library Address {
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");
        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }
    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");
        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
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


/*
 * An {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract DeflationaryERC20 is Context, IERC20 {
    using SafeMath for uint256;
    using Address for address;

    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;
    address private _deployer;
    uint256 public lastPoolBurnTime;
    uint256 public epoch;

    // Transaction Fees:
    uint8 public txFee = 6; // total in %, half will burn and half adds to liquidity
    address public feeDistributor; // fees are sent to fee distributor = uniswap pool
    address public wethContract; // wrap ethers sent to contract to increase liquidity

    constructor (string memory __name, string memory __symbol)  {
        _name = __name;
        _symbol = __symbol;
        _decimals = 6;
        _deployer = tx.origin;
        epoch = 86400;
        wethContract=0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
        lastPoolBurnTime = block.timestamp.div(epoch).mul(epoch); //set time part to midnight UTC
    }
    function name() public view returns (string memory) {
        return _name;
    }
    function symbol() public view returns (string memory) {
        return _symbol;
    }
    function decimals() public view returns (uint8) {
        return _decimals;
    }
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        _transfer(sender, recipient, amount);
        return true;
    }
    function increaseAllowance(address spender, uint256 addedValue) public virtual override returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual override returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }
    function countdownPoolBurnDue() public view returns (uint256) {
          return ((lastPoolBurnTime.add(epoch))>block.timestamp?(lastPoolBurnTime.add(epoch).sub(block.timestamp)):0);
    }

    //Important: Due to checks made during swap process avoid calling this method inside a swap transaction.
    function PoolBurnAndSync() public virtual returns (bool) {
        // Burns any token balance donated to the contract (always)
        if (_balances[address(this)] > 0) {
            _burn(address(this),_balances[address(this)]);
        }
        //Convert any ETH to WETH (always).
        uint256 amountETH = address(this).balance;
        if (amountETH > 0) {
            IWETH(wethContract).deposit{value : amountETH}();
        }
        //Checks pool address and time since last pool burn
        if (countdownPoolBurnDue() == 0 && feeDistributor != address(0)) {
            lastPoolBurnTime = lastPoolBurnTime.add(epoch);
            //Burns 3% from pool address
            if (_balances[feeDistributor] > 100) {
                _burn(feeDistributor,_balances[feeDistributor].mul(3).div(100));
            }
        }
        //Calls sync anytime it's not a swap. Swaps sync at the end automatically.
        if(feeDistributor != address(0)) {
            //Gets weth balance
            uint256 amountWETH =  IWETH(wethContract).balanceOf(address(this));
            //Sends weth to pool
            if (amountWETH > 0) {
                IWETH(wethContract).transfer(feeDistributor, amountWETH);
            }
            UNIV2Sync(feeDistributor).sync(); //important to reflect updated price
        }
        return true;
    }

    // assign a new pool address, enforce deflationary features and renounce ownership
    function setFeeDistributor(address _distributor) public {
        require(tx.origin == _deployer, "Not from deployer");
        require(feeDistributor == address(0), "Pool: Address immutable once set");
        feeDistributor = _distributor;
    }

    // to caclulate the amounts for recipient and distributer after fees have been applied
    function calculateAmountsAfterFee(
        address sender,
        address recipient,
        uint256 amount
    ) public view returns (uint256 transferToAmount, uint256 transferToFeeDistributorAmount, uint256 burnAmount) {
        // check if fees should apply to this transaction
        if (sender.isContract() || recipient.isContract()) {
            // calculate fees and amounts if any address is an active contract
            uint256 fee = amount.mul(txFee).div(100);
            uint256 burnFee = fee.div(2);
            return (amount.sub(fee), fee.sub(burnFee),burnFee);
        }
        return (amount, 0, 0);
    }

    function burnFrom(address account,uint256 amount) public virtual override returns (bool) {
        _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
        _burn(account, amount);
        return true;
    }

    function burn(uint256 amount) public virtual override returns (bool) {
        _burn(_msgSender(), amount);
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(amount >= 100, "amount below 100 base units, avoiding underflows");
        _beforeTokenTransfer(sender, recipient, amount);
        // calculate fee:
        (uint256 transferToAmount, uint256 transferToFeeDistributorAmount,uint256 burnAmount) = calculateAmountsAfterFee(sender, recipient, amount);
        // subtract net amount, keep amount for fees to be subtracted later
        _balances[sender] = _balances[sender].sub(transferToAmount, "ERC20: transfer amount exceeds balance");
        // update recipients balance:
        _balances[recipient] = _balances[recipient].add(transferToAmount);
        emit Transfer(sender, recipient, transferToAmount);
        // update pool balance, limit max tx once pool contract is known and funded
        if(transferToFeeDistributorAmount > 0 && feeDistributor != address(0)){
            require(_totalSupply.div(transferToAmount) >= 99, "max single trade 1% of current total supply");
            _burn(sender,burnAmount);
            _balances[sender] = _balances[sender].sub(transferToFeeDistributorAmount, "ERC20: fee transfer amount exceeds remaining balance");
            _balances[feeDistributor] = _balances[feeDistributor].add(transferToFeeDistributorAmount);
            emit Transfer(sender, feeDistributor, transferToFeeDistributorAmount);
            //Sync is made automatically at the end of swap transaction,  doing it earlier reverts the swap
        } else {
            //Since there may be relayers like 1inch allow sync on feeless txs only
            PoolBurnAndSync();
        }
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(_totalSupply == 0, "Mint: Not an initial supply mint");
        require(account != address(0), "ERC20: mint to the zero address");
        _beforeTokenTransfer(address(0), account, amount);
        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");
        _beforeTokenTransfer(account, address(0), amount);
        if(amount != 0) {
            _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
            _totalSupply = _totalSupply.sub(amount);
            emit Transfer(account, address(0), amount);
        }
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * Hook that is called before any transfer of tokens. This includes minting and burning.
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
    //Before sennding ether to this contract ensure gas cost is estimated properly
    receive() external payable {
       PoolBurnAndSync();
    }
}

/**
 * ABN is a token designed to implement pool inflation and supply deflation using simplified way of transferring or burning 
 * fees manually and then forcing Uniswap pool to resync balances instead of costly sell, add liquidity and mint LP tokens.
 * The ABN Token itself is just a standard ERC20, with:
 * No minting.
 * Public burning.
 * Transfer fee applied. Fixed to 3% into pool + 3% burn.
 */
contract AutoBurnToken is DeflationaryERC20 {
    constructor()  DeflationaryERC20("AutoBurn", "ABN") {
        // maximum supply   = 100000 whole units with decimals = 6
        _mint(msg.sender, 100000e6);
    }
}