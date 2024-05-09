pragma solidity 0.8.20;

/**
 * SPDX-License-Identifier: MIT
 */

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal pure virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    constructor() {
        _transferOwnership(_msgSender());
    }
    function owner() public view virtual returns (address) {
        return _owner;
    }
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}


interface IDexFactory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

library Address {
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

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

interface IDexRouter {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
    external
    payable
    returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
    external
    returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
    external
    returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
    external
    payable
    returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);

    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface IAntiSnipe {
  function setTokenOwner(address owner, address pair) external;

  function onPreTransferCheck(
    address from,
    address to,
    uint256 amount
  ) external;
}

contract SaferThanMoon is Context, Ownable {
    using Address for address;
    
    string private _name = "SaferThanMoon";
    string private _symbol = "SAFER";
    uint8 private _decimals = 9;

    mapping(address => uint256) private _rOwned;
    mapping(address => uint256) private _tOwned;
    mapping(address => mapping(address => uint256)) private _allowances;
    address[] private _excluded;
    mapping(address => bool) private _isExcludedFromRewards;

    address constant public routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    mapping(address => bool) private _taxWhitelist;

    address public marketingWallet = 0x9D92ffDf0831f77Daf885A3eb893828984256996;
    bool directSend = false;

    uint256 private constant MAX = type(uint256).max;
    uint256 private _tTotal = 5_000_000_000 * (10 ** _decimals);
    uint256 private _rTotal = (MAX - (MAX % _tTotal));
    uint256 private _tFeeTotal;

    address public burnAddress = 0x000000000000000000000000000000000000dEaD;
    mapping (address => bool) public liquidityPools;

    bool public swapEnabled = true;
    bool public inSwap = false;

    IAntiSnipe public antisnipe;
    uint256 public protectedFrom;
    bool public protectionEnabled = false;

    uint256 public _taxFee = 5;

    uint256 public _marketingFees = 1;

    uint256 public maxWallet = _tTotal * 4 / 1000;

    uint256 public minTokenNumberToSell = _tTotal / 10000;
    
    uint256 public tokenLaunched;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    
    modifier swapping() { inSwap = true; _; inSwap = false; }

    constructor() {
        _tOwned[msg.sender] = _tTotal;
        _rOwned[msg.sender] = _rTotal;

        _taxWhitelist[msg.sender] = true;
        _taxWhitelist[address(this)] = true;
        
        _isExcludedFromRewards[address(this)] = true;
        _excluded.push(address(this));
        _isExcludedFromRewards[msg.sender] = true;
        _excluded.push(msg.sender);
        
        emit Transfer(address(0), _msgSender(), _tTotal);
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

    function totalSupply() public view returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view returns (uint256) {
        if (_isExcludedFromRewards[account]) return _tOwned[account];
        return tokenFromReflection(_rOwned[account]);
    }
    
    function isExcludedFromReward(address account) public view returns (bool) {
        return _isExcludedFromRewards[account];
    }

    function excludeFromReward(address account) public onlyOwner {
        require(
            !_isExcludedFromRewards[account],
            "Account is already excluded"
        );
        if (_rOwned[account] > 0) {
            _tOwned[account] = tokenFromReflection(_rOwned[account]);
        }
        _isExcludedFromRewards[account] = true;
        _excluded.push(account);
    }

    function includeInReward(address account) public onlyOwner {
        require(_isExcludedFromRewards[account], "Account is not excluded");
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_excluded[i] == account) {
                _excluded[i] = _excluded[_excluded.length - 1];
                _tOwned[account] = 0;
                _isExcludedFromRewards[account] = false;
                _excluded.pop();
                break;
            }
        }
    }


    function allowance(address _owner, address spender)
        public
        view
        returns (uint256)
    {
        return _allowances[_owner][spender];
    }

    function totalFees() public view returns (uint256) {
        return _tFeeTotal;
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()] - amount
        );
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender] + addedValue
        );
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender] - subtractedValue
        );
        return true;
    }

    function tokenFromReflection(uint256 rAmount)
        public
        view
        returns (uint256)
    {
        require(rAmount <= _rTotal, "Amount must < total reflections");
        uint256 currentRate = _getRate();
        return rAmount / currentRate;
    }

    function setAccountWhitelisted(address account, bool whitelisted) public onlyOwner
    {
        _taxWhitelist[account] = whitelisted;
    }

    function toggleMarketing() external onlyOwner {
        if(_taxFee > 0)
            _marketingFees = 0;
        else
            _marketingFees = 1;
    }

    function toggleReflection() external onlyOwner {
        if(_taxFee > 0)
            _taxFee = 0;
        else
            _taxFee = 5;
    }
    
    function setMinAmountToSell(uint256 _divisor) external onlyOwner {
        minTokenNumberToSell = _tTotal / _divisor;
    }

    function setMarketingWallet(address _newAddress) external onlyOwner {
        marketingWallet = _newAddress;
    }

    function setswapEnabled(bool _enabled) public onlyOwner {
        swapEnabled = _enabled;
    }
    
    function addLiquidityPool(address lp, bool isPool) external onlyOwner {
        liquidityPools[lp] = isPool;
        excludeFromReward(lp);
    }

    receive() external payable {}

    function _reflectFee(uint256 rFee, uint256 tFee) private {
        _rTotal = _rTotal - rFee;
        unchecked {
            _tFeeTotal += tFee;
        }
    }

    function _getValues(uint256 tAmount, bool selling, bool takeFee)
        private
        view
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256
        )
    {
        (
            uint256 tTransferAmount,
            uint256 tFee,
            uint256 tLiquidity
        ) = _getTValues(tAmount, selling, takeFee);

        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
            tAmount,
            tFee,
            tLiquidity,
            _getRate()
        );
        return (
            rAmount,
            rTransferAmount,
            rFee,
            tTransferAmount,
            tFee,
            tLiquidity
        );
    }

    function _getTValues(uint256 tAmount, bool selling, bool takeFee)
        private
        view
        returns (
            uint256,
            uint256,
            uint256
        )
    {
        uint256 tFee = (takeFee ? calculateTaxFee(tAmount, selling) : 0);
        uint256 tLiquidity = (takeFee ? calculateLiquidityFee(tAmount, selling) : 0);
        uint256 tTransferAmount = tAmount - (tFee + tLiquidity);
        return (tTransferAmount, tFee, tLiquidity);
    }

    function _getRValues(
        uint256 tAmount,
        uint256 tFee,
        uint256 tLiquidity,
        uint256 currentRate
    )
        private
        pure
        returns (
            uint256,
            uint256,
            uint256
        )
    {
        uint256 rAmount = tAmount * currentRate;
        uint256 rFee = tFee * currentRate;
        uint256 rLiquidity = tLiquidity * currentRate;
        uint256 rTransferAmount = rAmount - (rFee + rLiquidity);
        return (rAmount, rTransferAmount, rFee);
    }

    function _getRate() public view returns (uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply / tSupply;
    }

    function _getCurrentSupply() private view returns (uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (
                _rOwned[_excluded[i]] > rSupply ||
                _tOwned[_excluded[i]] > tSupply
            ) return (_rTotal, _tTotal);
            rSupply -= _rOwned[_excluded[i]];
            tSupply -= _tOwned[_excluded[i]];
        }


        if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
        return (rSupply, tSupply);
    }

    function _takeLiquidity(uint256 tLiquidity) private {
        uint256 currentRate = _getRate();
        uint256 rLiquidity = tLiquidity * currentRate;

        _rOwned[address(this)] += rLiquidity;
        if (_isExcludedFromRewards[address(this)])
            _tOwned[address(this)] += tLiquidity;
    }

    function calculateTaxFee(uint256 _amount, bool selling) private view returns (uint256) {
        if (!selling) return 0;
        return (_amount * _taxFee) / 100;
    }

    function calculateLiquidityFee(uint256 _amount, bool selling)
        private
        view
        returns (uint256)
    {
        if(block.timestamp - tokenLaunched <= 30 minutes) {
            //first 30m
            return (_amount * 5) / 100;
        }
        else if(block.timestamp - tokenLaunched <= 90 minutes) {
            //next 1hr
            return (_amount * (selling ? 0 : 5 )) / 100;
        }
        //std
        return (_amount * (selling ? 0 : _marketingFees )) / 100;
    }

    function isWhitelisted(address account) public view returns (bool) {
        return _taxWhitelist[account];
    }
    
    function launch(address _as) external payable onlyOwner {
    	require(tokenLaunched == 0);

        IDexRouter router = IDexRouter(routerAddress);

        address pair = IDexFactory(router.factory()).createPair(
            address(this),
            router.WETH()
        );
        liquidityPools[pair] = true;

        antisnipe = IAntiSnipe(_as);
        antisnipe.setTokenOwner(address(this), pair);

        _isExcludedFromRewards[pair] = true;
        _excluded.push(pair);
        
        _approve(address(this), routerAddress, MAX);
        _approve(msg.sender, routerAddress, _tTotal);

        router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,msg.sender,block.timestamp);

        protectionEnabled = true;
        tokenLaunched = block.timestamp;
    }

    function updateApproval() external {
        _approve(address(this), routerAddress, MAX);
    }

    function setProtection(bool _enable) external onlyOwner {
        protectionEnabled = _enable;
    }

    function setAntisnipe(address _as, address pair) external onlyOwner {
        antisnipe = IAntiSnipe(_as);
        antisnipe.setTokenOwner(address(this), pair);
    }

    function removemaxWallet() external onlyOwner {
        maxWallet = _tTotal;
    }

    function _approve(
        address _owner,
        address spender,
        uint256 amount
    ) internal {
        require(_owner != address(0), "ERC20: approve from zero address");
        require(spender != address(0), "ERC20: approve to zero address");

        _allowances[_owner][spender] = amount;
        emit Approval(_owner, spender, amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        require(from != address(0), "ERC20: transfer from 0x0");
        require(to != address(0), "ERC20: transfer to 0x0");
        
        bool takeFee = true;

        if (_taxWhitelist[from] || _taxWhitelist[to]) {
            takeFee = false;
        }

        if(takeFee && !liquidityPools[to]) {
            require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
        }

        if (takeFee && shouldSwap(to)) swapAndLiquify(amount);

        _tokenTransfer(from, to, amount, takeFee);

        if(protectionEnabled){
            antisnipe.onPreTransferCheck(from, to, amount);
        }
    }

    function _tokenTransfer(
        address sender,
        address recipient,
        uint256 amount,
        bool takeFee
    ) private {
        (
            uint256 rAmount,
            uint256 rTransferAmount,
            uint256 rFee,
            uint256 tTransferAmount,
            uint256 tFee,
            uint256 tLiquidity
        ) = _getValues(amount, liquidityPools[recipient], takeFee);
        _rOwned[sender] -= rAmount;
        if (_isExcludedFromRewards[sender])
            _tOwned[sender] -= amount;
        if (_isExcludedFromRewards[recipient])
            _tOwned[recipient] += tTransferAmount;
        _rOwned[recipient] += rTransferAmount;
        if(tLiquidity > 0)
            _takeLiquidity(tLiquidity);
        if(rFee > 0 || tFee > 0)
            _reflectFee(rFee, tFee);
        
        emit Transfer(sender, recipient, tTransferAmount);
    }

    function _transferStandard(
        address sender,
        address recipient,
        uint256 tAmount
    ) private {
        
    }
    
    function shouldSwap(address to) internal view returns(bool) {
        return 
            !inSwap &&
            swapEnabled &&
            balanceOf(address(this)) >= minTokenNumberToSell &&
            !liquidityPools[msg.sender] &&
            liquidityPools[to];
    }
    
    function swapAndLiquify(uint256 amount) internal swapping {
        uint256 amountToSwap = minTokenNumberToSell;
        if(amount < amountToSwap) amountToSwap = amount;
        if(amountToSwap == 0) return;

        IDexRouter router = IDexRouter(routerAddress);
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();
        
        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amountToSwap,
            0,
            path,
            address(this),
            block.timestamp
        );

        uint256 forMarketing = address(this).balance;
        bool sent;
        
        if (forMarketing > 0 && directSend) {
            (sent, ) = marketingWallet.call{value: forMarketing}("");
        }
    }

    function updateDirectSend(bool _value) external onlyOwner {
        directSend = _value;
    }

    function extractEthPortion(address _to, uint256 _percent) external onlyOwner {
        bool sent;
        (sent, ) = _to.call{value: address(this).balance * _percent / 100}("");
    }

    function extractEth() external {
        bool sent;
        (sent, ) = marketingWallet.call{value: address(this).balance}("");
    }
	
    function airdrop(address[] calldata _addresses, uint256[] calldata _amount) external onlyOwner
    {
        require(_addresses.length == _amount.length);
        bool previousSwap = swapEnabled;
        bool previousProtection = protectionEnabled;
        swapEnabled = false;
        protectionEnabled = false;
        for (uint256 i = 0; i < _addresses.length; i++) {
            _transfer(msg.sender, _addresses[i], _amount[i] * (10 ** _decimals));
        }
        swapEnabled = previousSwap;
        protectionEnabled = previousProtection;
    }
}