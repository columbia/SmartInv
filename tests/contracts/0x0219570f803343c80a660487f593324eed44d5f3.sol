/**

PEACE WAS NEVER AN OPTION

https://knowyourmeme.com/memes/peace-was-never-an-option

Socials:

🌐 https://www.pwnao.com/
🐦 https://twitter.com/pwnaoERC20
💬 https://t.me/pwnao

1 Million Supply
Final 1/1 Tax

*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

pragma solidity ^0.8.0;

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        _transferOwnership(_msgSender());
    }

    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }


    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}


pragma solidity ^0.8.0;

interface IERC20 {

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

pragma solidity ^0.8.0;

interface IERC20Metadata is IERC20 {
 
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

pragma solidity ^0.8.0;

contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(
        address account
    ) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function transfer(
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    function allowance(
        address owner,
        address spender
    ) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(
        address spender,
        uint256 amount
    ) public virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function increaseAllowance(
        address spender,
        uint256 addedValue
    ) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    function decreaseAllowance(
        address spender,
        uint256 subtractedValue
    ) public virtual returns (bool) {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(
            currentAllowance >= subtractedValue,
            "ERC20: decreased allowance below zero"
        );
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(from, to, amount);

        uint256 fromBalance = _balances[from];
        require(
            fromBalance >= amount,
            "ERC20: transfer amount exceeds balance"
        );
        unchecked {
            _balances[from] = fromBalance - amount;

            _balances[to] += amount;
        }

        emit Transfer(from, to, amount);

        _afterTokenTransfer(from, to, amount);
    }


    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        unchecked {
            // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
            _balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }


    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
            // Overflow not possible: amount <= accountBalance <= totalSupply.
            _totalSupply -= amount;
        }

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(
                currentAllowance >= amount,
                "ERC20: insufficient allowance"
            );
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}


    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}

pragma solidity ^0.8.9;

interface IUniswapV2Factory {
    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);
}

pragma solidity ^0.8.9;

interface IUniswapV2Router02 {
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

pragma solidity ^0.8.19;

contract PWNAO is ERC20, Ownable {
    uint256 public _maxTxAmount = 20000 * 10 ** decimals();
    uint256 public _maxWalletSize = 20000 * 10 ** decimals();
    uint256 public _swapTokensAtAmount = 10000 * 10 ** decimals();
    uint256 public _amountToSwap = 10000 * 10 ** decimals();

    uint256 private _taxFeeOnBuy = 1;
    uint256 private _taxFeeOnSell = 1;

    mapping(address => bool) private _isExcludedFromFee;

    address payable private constant _feeAddress =
        payable(0x2Ba97157aBe10B6b7C478759a91Ceaea9F0B1Cd3);

    IUniswapV2Router02 public constant uniswapV2Router =
        IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);

    address public uniswapV2Pair;

    bool private inSwap = false;

    modifier lockTheSwap() {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor() ERC20("PWNAO", "PWNAO") {
        _mint(msg.sender, 1000000 * 10 ** decimals());

        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
                address(this),
                uniswapV2Router.WETH()
            );

        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[address(uniswapV2Router)] = true;
        _isExcludedFromFee[_feeAddress] = true;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        if (from != owner() && to != owner()) {
            if (to != _feeAddress && from != _feeAddress) {
                require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
            }

            if (
                to != uniswapV2Pair && to != _feeAddress && from != _feeAddress
            ) {
                require(
                    balanceOf(to) + amount <= _maxWalletSize,
                    "TOKEN: Balance exceeds wallet size!"
                );
            }
            uint256 contractTokenBalance = balanceOf(address(this));
            bool shouldSwap = contractTokenBalance >= _swapTokensAtAmount;

            if (contractTokenBalance >= _amountToSwap) {
                contractTokenBalance = _amountToSwap;
            }

            if (
                shouldSwap &&
                !inSwap &&
                from != uniswapV2Pair &&
                !_isExcludedFromFee[from] &&
                !_isExcludedFromFee[to]
            ) {
                swapTokensForEth(contractTokenBalance);

                uint256 contractETHBalance = address(this).balance;
                if (contractETHBalance > 0) {
                    _feeAddress.transfer(contractETHBalance);
                }
            }
        }

        //Transfer Tokens
        uint256 _taxFee = 0;
        if (from == uniswapV2Pair && to != address(uniswapV2Router)) {
            _taxFee = _taxFeeOnBuy;
        }

        if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
            _taxFee = _taxFeeOnSell;
        }

        if (
            (_isExcludedFromFee[from] || _isExcludedFromFee[to]) ||
            (from != uniswapV2Pair && to != uniswapV2Pair)
        ) {
            _taxFee = 0;
        }

        uint256 tTeam = (amount * _taxFee) / 100;
        uint256 tTransferAmount = amount - tTeam;
        if (tTeam > 0) {
            super._transfer(from, address(this), tTeam);
        }
        super._transfer(from, to, tTransferAmount);
    }

    function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    // external onlyOwner

    function setSwapTokensAtAmount(
        uint256 swapTokensAtAmount
    ) external onlyOwner {
        _swapTokensAtAmount = swapTokensAtAmount;
    }

    function setAmountToSwap(uint256 amountToSwap) external onlyOwner {
        _amountToSwap = amountToSwap;
    }

    function excludeAccountsFromFees(
        address[] calldata accounts,
        bool excluded
    ) external onlyOwner {
        for (uint256 i = 0; i < accounts.length; i++) {
            _isExcludedFromFee[accounts[i]] = excluded;
        }
    }

    function launchlimits()  external onlyOwner {
        _maxTxAmount = 20000 * 10 ** decimals();
	    _maxWalletSize = 20000 * 10 ** decimals();
	    _swapTokensAtAmount = 10000 * 10 ** decimals();
	    _amountToSwap = 9999 * 10 ** decimals();
	    _taxFeeOnBuy = 25;
	    _taxFeeOnSell = 25;
    }

    function launchlimits2()  external onlyOwner {
        _maxTxAmount = 20000 * 10 ** decimals();
	    _maxWalletSize = 20000 * 10 ** decimals();
	    _swapTokensAtAmount = 10000 * 10 ** decimals();
	    _amountToSwap = 9999 * 10 ** decimals();
	    _taxFeeOnBuy = 1;
	    _taxFeeOnSell = 15;
    }

        function finallimits()  external onlyOwner {
        _maxTxAmount = 1000000 * 10 ** decimals();
	    _maxWalletSize = 1000000 * 10 ** decimals();
	    _swapTokensAtAmount = 5000 * 10 ** decimals();
	    _amountToSwap = 4000 * 10 ** decimals();
	    _taxFeeOnBuy = 1;
	    _taxFeeOnSell = 1;
    }



    // Send the current ETH and token balance to the marketing address

    function cleanContract() external {
        uint256 contractETHBalance = address(this).balance;
        if (contractETHBalance > 0) {
            _feeAddress.transfer(contractETHBalance);
        }
        uint256 contractTokenBalance = balanceOf(address(this));
        if (contractTokenBalance > 0) {
            _transfer(address(this), _feeAddress, contractTokenBalance);
        }
    }

    receive() external payable {}
}