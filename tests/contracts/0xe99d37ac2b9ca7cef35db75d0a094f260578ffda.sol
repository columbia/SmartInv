// SPDX-License-Identifier: MIT
//
// ###    ###   ######          ####      ##########   ##########
//  ###  ###    ###  ###       ######     ##########   ##########
//   ######     ###   ###     ###  ###    ###          ###      
//    ####      ###    ###   ###    ###   ###  #####   ##########
//    ####      ###    ###   ###    ###   ###  #####   ##########
//   ######     ###   ###     ###  ###    ###    ###   ###      
//  ###  ###    ###  ###       ######     ##########   ##########
// ###    ###   ######          ####      ##########   ##########
//
// https://twitter.com/XDogeeth
// https://t.me/XDogePortalChannel

pragma solidity ^0.8.16;

library SafeMath {
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b; if (c < a) return (false, 0); return (true, c); 
        } 
    }

    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a)
                return (false, 0);
            return (true, a - b); 
        }
    }

    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (a == 0)
                return (true, 0);
            uint256 c = a * b;
            if (c / a != b)
                return (false, 0);
            return (true, c); 
        }
    }

    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0)
                return (false, 0);
            return (true, a / b);
        }
    }

    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0)
                return (false, 0);
            return (true, a % b);
        }
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

interface IUniswapFactoryV2 {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IUniswapRouterV2 {
    function factory() external view returns (address);

    function WETH() external view returns (address);

    function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline) external;

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline) external;

    function swapExactTokensForETH(uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline) external;
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) { return msg.sender; }
    function _msgData() internal view virtual returns (bytes calldata) { return msg.data; }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() { _transferOwnership(_msgSender()); }

    modifier onlyOwner() { _checkOwner(); _; }

    function owner() public view virtual returns (address) { return _owner; }

    function _checkOwner() internal view virtual { require(owner() == _msgSender(), "Ownable: caller is not the owner"); }

    function renounceOwnership() public virtual onlyOwner { _transferOwnership(address(0)); }

    function transferOwnership(address newOwner) public virtual onlyOwner { require(newOwner != address(0), "Ownable: new owner is the zero address"); _transferOwnership(newOwner); }

    function _transferOwnership(address newOwner) internal virtual { address oldOwner = _owner; _owner = newOwner; emit OwnershipTransferred(oldOwner, newOwner); }
}

abstract contract ERC20 is Context, IERC20 {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    uint256 private _totalSupply;
    uint8 private _decimals;
    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_, uint8 decimals_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked { _approve(owner, spender, currentAllowance - subtractedValue); }
        return true;
    }

    function _transfer(address from, address to, uint256 amount) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        _beforeTokenTransfer(from, to, amount);
        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked { _balances[from] = fromBalance - amount; _balances[to] += amount; }
        emit Transfer(from, to, amount);
        _afterTokenTransfer(from, to, amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");
        _beforeTokenTransfer(address(0), account, amount);
        _totalSupply += amount;
        unchecked { _balances[account] += amount; }
        emit Transfer(address(0), account, amount);
        _afterTokenTransfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");
        _beforeTokenTransfer(account, address(0), amount);
        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked { _balances[account] = accountBalance - amount; _totalSupply -= amount; }
        emit Transfer(account, address(0), amount);
        _afterTokenTransfer(account, address(0), amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked { _approve(owner, spender, currentAllowance - amount); }
        }
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
    function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
}

contract TOKEN is ERC20, Ownable {
    using SafeMath for uint256;

    IUniswapRouterV2 private router;

    address public weth;
    address public mainpair;
    address public routerAddr = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address public marketingAddr = 0x4613F6c068388466b655547aF9A38FB60058713A;

    uint256 public lb = 0;
    uint256 public buyfee = 5;
    uint256 public sellfee = 20;

    bool    private _swapping;
    uint256 private _swapAmount;
    uint256 private constant _totalSupply = 42 * 10000 * 10000 * (10**18);

    mapping(address => bool) private _isExcludedFromFees;

    event Launched(uint256 blockNumber);
    event FeesUpdated(uint256 buyfee, uint256 sellfee);

    constructor() ERC20("XDoge", "XDoge", 18) {
        router = IUniswapRouterV2(routerAddr);
        weth = router.WETH();
        mainpair = IUniswapFactoryV2(router.factory()).createPair(weth, address(this));

        _swapAmount = _totalSupply.div(1000);

        _isExcludedFromFees[address(this)] = true;
        _isExcludedFromFees[marketingAddr] = true;
        _isExcludedFromFees[msg.sender] = true;

        _mint(msg.sender, _totalSupply);

        _approve(address(this), routerAddr, ~uint256(0));
    }

    receive() external payable {}

    function excludeFromFees(address[] memory account, bool excluded) public onlyOwner {
        for (uint256 i = 0; i < account.length; i++) {
            _isExcludedFromFees[account[i]] = excluded;
        }
    }

    function launch() external onlyOwner {
        require(lb == 0, "TOKEN: Already launched");
        lb = block.number;
        emit Launched(lb);
    }

    // fees: (5%, 20%) -> (2%, 2%)
    function setFees(uint256 _buyfee, uint256 _sellfee) external onlyOwner {
        require(_buyfee <= buyfee && _sellfee <= sellfee, "TOKEN: Fee too high"); // can't increase fees
        buyfee = _buyfee;
        sellfee = _sellfee;
        emit FeesUpdated(_buyfee, _sellfee);
    }

    function getFee(address from, address to) internal view returns (uint256) {
        if (lb + 3 >= block.number) return 89;
        if (from == mainpair) return buyfee; // buy or remove liquidity
        if (to == mainpair) return sellfee; // sell or add liquidity
        return 0; // transfer
    }

    function _transfer(address from, address to, uint256 amount) internal override {
        require(from != address(0));
        require(to != address(0));
        require(amount != 0);
        require(lb != 0 || from == owner(), "TOKEN: Not launched");

        if (!_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
            if (to == mainpair && !_swapping && balanceOf(address(this)) >= _swapAmount) {
                _swap();
            }

            if (!_swapping) {
                uint256 feeAmount = amount.mul(getFee(from, to)).div(100);
                if (feeAmount > 0) { amount = amount.sub(feeAmount); super._transfer(from, address(this), feeAmount); }
                if (amount > 1) amount = amount.sub(1);
            }
        }

        super._transfer(from, to, amount);
    }

    modifier lockTheSwap {
        _swapping = true;
        _;
        _swapping = false;
    }

    function _swap() internal lockTheSwap {
        uint256 amount = balanceOf(address(this));
        if (amount == 0) return;
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = weth;
        router.swapExactTokensForETHSupportingFeeOnTransferTokens(amount, 0, path, marketingAddr, block.timestamp);
    }
}