// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

//        |-----------------------------------------------------------------------------------------------------------|
//        |                                                                        %################.                 |
//        |                                                                       #####################@              |
//        |                                                         |           ######    @#####    &####             |
//        |                                                         |           ###%        ,         ###%            |
//        |                                                         |          &###,  /&@@     @(@@   ####            |
//        |                                                         |           ###@       &..%      *####            |
//        |  $$$$$$$\  $$$$$$$$\ $$\   $$\  $$$$$$\ $$\     $$\     |           @####     .,,,,@    #####             |
//        |  $$  __$$\ $$  _____|$$$\  $$ |$$  __$$\\$$\   $$  |    |            %##(       ,*      @##(@             |
//        |  $$ |  $$ |$$ |      $$$$\ $$ |$$ /  \__|\$$\ $$  /     |        /#&##@                    ##&#&          |
//        |  $$$$$$$  |$$$$$\    $$ $$\$$ |$$ |$$$$\  \$$$$  /      |       ######                        #(###       |
//        |  $$  ____/ $$  __|   $$ \$$$$ |$$ |\_$$ |  \$$  /       |    #######                          ######.     |
//        |  $$ |      $$ |      $$ |\$$$ |$$ |  $$ |   $$ |        |  &#######@                          ##(#####    |
//        |  $$ |      $$$$$$$$\ $$ | \$$ |\$$$$$$  |   $$ |        |        ###                           &##        |
//        |  \__|      \________|\__|  \__| \______/    \__|        |        &##%                          ###        |
//        |                                                         |         %###                        @##@        |
//        |                                                         |           %###@                  &###&          |
//        |                                                                    &,,,,,&################@,,,,,%         |
//        |                                                                  ,.,,,.*%@               /(.,,,,/@        |
//        |-----------------------------------------------------------------------------------------------------------|
//                                -----> Ken and the community makes penguins fly! 🚀  <-----     */

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function decimals() external view returns (uint8);

    function symbol() external view returns (string memory);

    function name() external view returns (string memory);

    function balanceOf(address account) external view returns (uint256);

    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

    function allowance(
        address _owner,
        address spender
    ) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

interface IDEXRouter {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

interface IDEXFactory {
    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);
}

contract Pengy is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private constant _decimals = 18;
    uint256 private _totalSupply;

    mapping(address => bool) public isExcludedFromFees;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    address public owner;
    address public constant feeWallet = 0xe7bE0E9c3a5650dB004E306FC9D9cCE97eEe7166; 
    address public immutable pair;
    address public immutable router;
    address public constant DEAD = 0x000000000000000000000000000000000000dEaD;
    address public immutable WETH;

    modifier onlyDeployer() {
        require(msg.sender == owner, "Only the owner can do that");
        _;
    }

    constructor() {
        owner = msg.sender;
        _name = "PENGY";
        _symbol = "PENGY";
        _totalSupply = 3_000_000_000 * (10 ** _decimals);
        router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // Uniswap V2 router

        WETH = IDEXRouter(router).WETH();

        pair = IDEXFactory(IDEXRouter(router).factory()).createPair(
            address(this),
            WETH
        );

        isExcludedFromFees[owner] = true;
        

        _balances[owner] = _totalSupply;
        emit Transfer(address(0), owner, _totalSupply);
    }

    receive() external payable {}

    function name() public view override returns (string memory) {
        return _name;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply - _balances[DEAD];
    }

    function decimals() public pure override returns (uint8) {
        return _decimals;
    }

    function symbol() public view override returns (string memory) {
        return _symbol;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function rescueEth(uint256 amount) external onlyDeployer {
        (bool success, ) = address(owner).call{value: amount}("");
        success = true;
    }

    function rescueToken(address token, uint256 amount) external onlyDeployer {
        IERC20(token).transfer(owner, amount);
    }

    function allowance(
        address holder,
        address spender
    ) public view override returns (uint256) {
        return _allowances[holder][spender];
    }

    function transfer(
        address recipient,
        uint256 amount
    ) external override returns (bool) {
        return _transferFrom(msg.sender, recipient, amount);
    }

    function approveMax(address spender) external returns (bool) {
        return approve(spender, type(uint256).max);
    }

    function approve(
        address spender,
        uint256 amount
    ) public override returns (bool) {
        require(spender != address(0), "Can't use zero address here");
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function increaseAllowance(
        address spender,
        uint256 addedValue
    ) public returns (bool) {
        require(spender != address(0), "Can't use zero address here");
        _allowances[msg.sender][spender] =
            allowance(msg.sender, spender) +
            addedValue;
        emit Approval(msg.sender, spender, _allowances[msg.sender][spender]);
        return true;
    }

    function decreaseAllowance(
        address spender,
        uint256 subtractedValue
    ) public returns (bool) {
        require(spender != address(0), "Can't use zero address here");
        require(
            allowance(msg.sender, spender) >= subtractedValue,
            "Can't subtract more than current allowance"
        );
        _allowances[msg.sender][spender] =
            allowance(msg.sender, spender) -
            subtractedValue;
        emit Approval(msg.sender, spender, _allowances[msg.sender][spender]);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external override returns (bool) {
        if (_allowances[sender][msg.sender] != type(uint256).max) {
            require(
                _allowances[sender][msg.sender] >= amount,
                "Insufficient Allowance"
            );
            _allowances[sender][msg.sender] -= amount;
            emit Approval(sender, msg.sender, _allowances[sender][msg.sender]);
        }
        return _transferFrom(sender, recipient, amount);
    }

    function _transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) internal returns (bool) {
        if (!checkTaxFree(sender, recipient)) {
            _lowGasTransfer(sender, feeWallet, amount / 100);
            amount = (amount * 99) / 100;
        }
        return _lowGasTransfer(sender, recipient, amount);
    }

    function checkTaxFree(
        address sender,
        address recipient
    ) internal view returns (bool) {
        if (isExcludedFromFees[sender] || isExcludedFromFees[recipient])
            return true;
        if (sender == pair || recipient == pair) return false;
        return true;
    }

    function _lowGasTransfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal returns (bool) {
        require(sender != address(0), "Can't use zero addresses here");
        require(
            amount <= _balances[sender],
            "Can't transfer more than you own"
        );
        if (amount == 0) return true;
        _balances[sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function excludeFromFees(
        address excludedWallet,
        bool status
    ) external onlyDeployer {
        isExcludedFromFees[excludedWallet] = status;
    }

    function renounceOwnership() external onlyDeployer {
        owner = address(0);
    }
}

/*

The topics and opinions discussed by Ken the Crypto and the PENGY community are intended to convey general information only. All opinions expressed by Ken or the community should be treated as such.

This contract does not provide legal, investment, financial, tax, or any other type of similar advice.

As with all alternative currencies, Do Your Own Research (DYOR) before purchasing. Ken and the rest of the PENGY community are working to increase coin adoption, but no individual or community shall be held responsible for any financial losses or gains that may be incurred as a result of trading PENGY.

If you’re with us — Hop In, We’re Going Places 🚀

*/