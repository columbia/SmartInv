//SPDX-License-Identifier: UNLICENSED
/*                              
                    CHAINTOOLS 2023. DEFI REIMAGINED

                                                               2023

⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀            2021           ⣰⣾⣿⣶⡄⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀2019⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀     ⠹⣿V4⡄⡷⠀⠀⠀⠀⠀   
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⢀⠀⠀⠀⠀⠀⠀⠀⠀ ⣤⣾⣿⣷⣦⡀⠀⠀⠀⠀   ⣿⣿⡏⠁⠀⠀⠀⠀⠀   
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⢀⣴⣿⣿⣿⣷⡀⠀⠀⠀⠀ ⢀⣿⣿⣿⣿⣿⠄⠀⠀⠀  ⣰⣿⣿⣧⠀⠀⠀⠀⠀⠀   
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⢀⣴⣾⣿⣿⣿⣿⣿⣿⡄⠀⠀ ⢀⣴⣿⣿⣿⠟⠛⠋⠀⠀⠀ ⢸⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀   
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⢀⣴⣿⣿⣿⣿⣿⠟⠉⠉⠉⠁⢀⣴⣿⣿V3⣿⣿⠀⠀⠀⠀⠀  ⣾⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀   
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⣾⣿⣿⣿⣿⣿⠛⠀⠀⠀⠀⠀ ⣾⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀ ⣿⣿⣿⣿⣿⣿⣿⣧⡀⠀⠀⠀⠀   
⠀⠀⠀        2017⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿V2⣿⣿⡿⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿⣿⣄⠀⠀⠀⠀⠀⠀ ⢹⣿ ⣿⣿⣿⣿⠙⢿⣆⠀⠀⠀   
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣴⣦⣤⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠈⢻⣿⣿⣿⣿⠛⠿⠿⠶⠶⣶⠀  ⣿ ⢸⣿⣿⣿⣿⣆⠹⠇⠀⠀   
⠀⠀⠀⠀⠀⠀⢀⣠⣴⣿⣿⣿⣿⣷⡆⠀⠀⠀⠀⠸⣿⣿⣿⣿⣿⣿⡇⠉⠛⢿⣷⡄⠀⠀⠀⢸⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀  ⠹⠇⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀   
⠀⠀⠀⠀⣠⣴⣿⣿V1⣿⣿⣿⡏⠛⠃⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣇⠀⠀⠘⠋⠁⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀  ⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀   
⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀ ⠸⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀  ⠀⣿⣿⡟⢿⣿⣿⠀⠀⠀⠀   
⠀⢸⣿⣿⣿⣿⣿⠛⠉⠙⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀ ⢈⣿⣿⡟⢹⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⡿⠈⣿⣿⡟⠀⠀⠀⠀⠀  ⢸⣿⣿⠀⢸⣿⣿⠀⠀⠀⠀   
⠀⠀⠹⣿⣿⣿⣿⣷⡀⠀⠻⣿⣿⣿⣿⣶⣄⠀⠀⠀⢰⣿⣿⡟⠁⣾⣿⣿⠀⠀⠀⠀⠀⠀⢀⣶⣿⠟⠋⠀⢼⣿⣿⠃⠀⠀⠀⠀⠀  ⣿⣿⠁⠀⢹⣿⣿⠀⠀⠀⠀   
⠀⢀⣴⣿⡿⠋⢹⣿⡇⠀⠀⠈⠙⣿⣇⠙⣿⣷⠀⠀⢸⣿⡟⠀⠀⢻⣿⡏⠀⠀⠀⠀⠀⢀⣼⡿⠁⠀⠀⠀⠘⣿⣿⠀⠀⠀⠀⠀   ⢨⣿⡇⠀⠀⠀⣿⣿⠀⠀⠀⠀   
⣴⣿⡟⠉⠀⠀⣾⣿⡇⠀⠀⠀⠀⢈⣿⡄⠀⠉⠀⠀⣼⣿⡆⠀⠀⢸⣿⣷⠀⠀⠀⠀⢴⣿⣿⠀⠀⠀⠀⠀⠀⣿⣯⡀⠀⠀⠀⠀    ⢸⣿⣇⠀⠀⠀⢺⣿⡄⠀⠀⠀   
⠈⠻⠷⠄⠀⠀⣿⣿⣷⣤⣠⠀⠀⠈⠽⠷⠀⠀⠀⠸⠟⠛⠛⠒⠶⠸⣿⣿⣷⣦⣤⣄⠈⠻⠷⠄⠀⠀⠀⠾⠿⠿⣿⣶⣤⠀    ⠘⠛⠛⠛⠒⠀⠸⠿⠿⠦ 


Telegram: https://t.me/ChaintoolsOfficial
Website: https://www.chaintools.ai/
Whitepaper: https://chaintools-whitepaper.gitbook.io/
Twitter: https://twitter.com/ChaintoolsTech
dApp: https://www.chaintools.wtf/
*/

pragma solidity ^0.8.19;

// import "forge-std/console.sol";

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

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

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface IUniswapV2Router02 {
    function getAmountsOut(uint256 amountIn, address[] memory path)
        external
        view
        returns (uint256[] memory amounts);

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );
}

interface IV2Pair {
    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function token0() external view returns (address);

    function burn(address to)
        external
        returns (uint256 amount0, uint256 amount1);
}

interface IV3Pool {
    function liquidity() external view returns (uint128 Liq);

    struct Info {
        uint128 liquidity;
        uint256 feeGrowthInside0LastX128;
        uint256 feeGrowthInside1LastX128;
        uint128 tokensOwed0;
        uint128 tokensOwed1;
    }

    function initialize(uint160 sqrtPriceX96) external;

    function positions(bytes32 key)
        external
        view
        returns (IV3Pool.Info memory liqInfo);

    function swap(
        address recipient,
        bool zeroForOne,
        int256 amountSpecified,
        uint160 sqrtPriceLimitX96,
        bytes memory data
    ) external returns (int256 amount0, int256 amount1);

    function burn(
        int24 tickLower,
        int24 tickUpper,
        uint128 amount
    ) external returns (uint256 amount0, uint256 amount1);

    function collect(
        address recipient,
        int24 tickLower,
        int24 tickUpper,
        uint128 amount0Requested,
        uint128 amount1Requested
    ) external returns (uint128 amount0, uint128 amount1);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function slot0()
        external
        view
        returns (
            uint160,
            int24,
            uint16,
            uint16,
            uint16,
            uint8,
            bool
        );

    function flash(
        address recipient,
        uint256 amount0,
        uint256 amount1,
        bytes calldata data
    ) external;

    function uniswapV3FlashCallback(
        uint256 fee0,
        uint256 fee1,
        bytes memory data
    ) external;

    function mint(
        address recipient,
        int24 tickLower,
        int24 tickUpper,
        uint128 amount,
        bytes calldata data
    ) external returns (uint256 amount0, uint256 amount1);
}

interface IWETH {
    function withdraw(uint256 wad) external;

    function approve(address who, uint256 wad) external returns (bool);

    function deposit() external payable;

    function transfer(address dst, uint256 wad) external returns (bool);

    function balanceOf(address _owner) external view returns (uint256);
}

interface IQuoterV2 {
    function quoteExactInputSingle(
        address tokenIn,
        address tokenOut,
        uint24 fee,
        uint256 amountIn,
        uint160 sqrtPriceLimitX96
    ) external returns (uint256 amountOut);
}

interface IV3Factory {
    function getPool(
        address token0,
        address token1,
        uint24 poolFee
    ) external view returns (address);

    function createPool(
        address tokenA,
        address tokenB,
        uint24 fee
    ) external returns (address);
}

interface INonfungiblePositionManager {
    function ownerOf(uint256 tokenId) external view returns (address owner);

    function setApprovalForAll(address operator, bool approved) external;

    struct IncreaseLiquidityParams {
        uint256 tokenId;
        uint256 amount0Desired;
        uint256 amount1Desired;
        uint256 amount0Min;
        uint256 amount1Min;
        uint256 deadline;
    }

    function increaseLiquidity(
        INonfungiblePositionManager.IncreaseLiquidityParams calldata params
    )
        external
        returns (
            uint128 liquidity,
            uint256 amount0,
            uint256 amount1
        );

    function tokenOfOwnerByIndex(address owner, uint256 index)
        external
        view
        returns (uint256 tokenId);

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) external;

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    function factory() external view returns (address);

    struct MintParams {
        address token0;
        address token1;
        uint24 fee;
        int24 tickLower;
        int24 tickUpper;
        uint256 amount0Desired;
        uint256 amount1Desired;
        uint256 amount0Min;
        uint256 amount1Min;
        address recipient;
        uint256 deadline;
    }

    function mint(MintParams calldata mp)
        external
        payable
        returns (
            uint256 tokenId,
            uint128 liquidity,
            uint256 amount0,
            uint256 amount1
        );

    function collect(CollectParams calldata params)
        external
        payable
        returns (uint256 amount0, uint256 amount1);

    struct CollectParams {
        uint256 tokenId;
        address recipient;
        uint128 amount0Max;
        uint128 amount1Max;
    }

    struct DecreaseLiquidityParams {
        uint256 tokenId;
        uint128 liquidity;
        uint256 amount0Min;
        uint256 amount1Min;
        uint256 deadline;
    }

    function decreaseLiquidity(DecreaseLiquidityParams calldata dl)
        external
        returns (uint256 amount0, uint256 amount1);

    function positions(uint256 tokenId)
        external
        view
        returns (
            uint96 nonce,
            address operator,
            address token0,
            address token1,
            uint24 fee,
            int24 tickLower,
            int24 tickUpper,
            uint128 liquidity,
            uint256 feeGrowthInside0LastX128,
            uint256 feeGrowthInside1LastX128,
            uint128 tokensOwed0,
            uint128 tokensOwed1
        );
}

interface IRouterV3 {
    function factory() external view returns (address);

    function WETH9() external view returns (address);

    struct ExactInputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
        uint160 sqrtPriceLimitX96;
    }
    struct ExactOutputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 deadline;
        uint256 amountOut;
        uint256 amountInMaximum;
        uint160 sqrtPriceLimitX96;
    }

    function exactOutputSingle(ExactOutputSingleParams calldata params)
        external
        returns (uint256 amountIn);

    function exactInputSingle(ExactInputSingleParams calldata params)
        external
        payable
        returns (uint256 amountOut);
}

interface YieldVault {
    function getDeviation(uint256 amountIn, uint256 startTickDeviation)
        external
        view
        returns (uint256 adjusted);

    function getCurrentTick() external view returns (int24 cTick);

    function getStartTickDeviation(int24 currentTick)
        external
        view
        returns (uint256 perc);

    function findPoolFee(address token0, address token1)
        external
        view
        returns (uint24 poolFee);

    function getPosition(uint256 tokenId)
        external
        view
        returns (
            address token0,
            address token1,
            uint128 liquidity
        );

    function getTickDistance(uint256 flag)
        external
        view
        returns (int24 tickDistance);

    function findApprovalToken(address pool)
        external
        view
        returns (address token);

    function findApprovalToken(address token0, address token1)
        external
        view
        returns (address token);

    function buyback(
        uint256 flag,
        uint128 internalWETHAmt,
        uint128 internalCTLSAmt,
        address to,
        uint256 id
    ) external returns (uint256 t0, uint256 t1);

    function keeper() external view returns (address);
}

interface YieldBooster {
    function preventFragmentations(address pool) external;
}

interface TickMaths {
    function getSqrtRatioAtTick(int24 tick)
        external
        pure
        returns (uint160 sqrtPriceX96);
}

contract ChainToolsV2 is Context, IERC20, IERC20Metadata {
    IUniswapV2Router02 internal immutable router;
    INonfungiblePositionManager internal immutable positionManager;
    YieldBooster internal YIELD_BOOSTER;
    YieldVault internal YIELD_VAULT;
    TickMaths internal immutable TickMath;
    address internal immutable uniswapV3Pool;
    address internal immutable multiSig;
    address internal immutable WETH;
    address internal immutable v3Router;
    address internal immutable apest;

    uint256 internal immutable _MAX_SUPPLY;
    uint256 internal immutable _totalSupply;
    uint256 internal immutable _cap;

    uint8 internal tokenomicsOn;
    uint32 internal startStamp;
    uint32 internal lastRewardStamp;
    uint80 internal issuanceRate;

    mapping(address => uint256) internal _balances;
    mapping(address => mapping(address => uint256)) internal _allowances;

    mapping(address => bool) internal isTaxExcluded;
    mapping(address => bool) internal badPool;

    mapping(address => address) internal upperRef;
    mapping(address => uint256) internal sandwichLock;

    event zapIn(
        address indexed from,
        uint256 tokenId,
        uint256 flag,
        uint256 amtETHIn,
        uint256 amtTokensIn
    );

    event referralPaid(address indexed from, address indexed to, uint256 amt);

    error MinMax();
    error ZeroAddress();
    error Auth();
    error Sando();

    constructor(address _apest, address _tickMaths) {
        TickMath = TickMaths(_tickMaths);
        multiSig = 0xb0Df68E0bf4F54D06A4a448735D2a3d7D97A2222;
        apest = _apest;
        tokenomicsOn = 1;
        issuanceRate = 10e18;
        v3Router = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
        router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        WETH = IRouterV3(v3Router).WETH9();

        positionManager = INonfungiblePositionManager(
            0xC36442b4a4522E871399CD717aBDD847Ab11FE88
        );

        uniswapV3Pool = IV3Factory(positionManager.factory()).createPool(
            WETH,
            address(this),
            10000
        );

        require(IV3Pool(uniswapV3Pool).token0() == WETH, "token0pool0");

        //Initial supply
        uint256 forLiquidityBootstrap = 1_000_000e18;
        _balances[
            0x0000000000000000000000000000000000C0FFEE
        ] = forLiquidityBootstrap;
        emit Transfer(
            address(0),
            address(0x0000000000000000000000000000000000C0FFEE),
            forLiquidityBootstrap
        );

        uint256 forMigration = 8_200_000e18;
        _balances[apest] += forMigration;
        emit Transfer(address(0), address(apest), forMigration);

        uint256 forLp = 600_000e18;
        _balances[address(this)] += forLp;
        emit Transfer(address(0), address(this), forLp);

        uint256 forMarketing = 1_000_000e18;
        _balances[0xb0Df68E0bf4F54D06A4a448735D2a3d7D97A2222] += forMarketing;
        emit Transfer(
            address(0),
            0xb0Df68E0bf4F54D06A4a448735D2a3d7D97A2222,
            forMarketing
        );

        uint256 forYieldBoosting = 200_000e18;
        _balances[address(this)] += forYieldBoosting;
        emit Transfer(address(0), address(this), forMarketing);

        int24 startTick = 98140;
        IV3Pool(uniswapV3Pool).initialize(
            TickMath.getSqrtRatioAtTick(startTick)
        );
        IERC20(WETH).approve(address(positionManager), type(uint256).max);
        IERC20(WETH).approve(v3Router, type(uint256).max);

        _allowances[address(this)][v3Router] = type(uint256).max;
        _allowances[address(this)][address(positionManager)] = type(uint256)
            .max;

        isTaxExcluded[v3Router] = true;
        isTaxExcluded[multiSig] = true;
        isTaxExcluded[address(this)] = true;

        _totalSupply = forLiquidityBootstrap + forMigration + forLp + forMarketing + forYieldBoosting;
        _MAX_SUPPLY = _totalSupply;
        _cap = _MAX_SUPPLY;
    }

    function prepareFomo(address yieldVault, address yieldBooster) external {
        if (msg.sender != apest) revert Auth();
        if (startStamp != 0) revert MinMax();

        //Compounder
        YIELD_VAULT = YieldVault(yieldVault);
        isTaxExcluded[address(YIELD_VAULT)] = true;
        _allowances[address(YIELD_VAULT)][address(positionManager)] = type(
            uint256
        ).max;
        _allowances[address(YIELD_VAULT)][address(v3Router)] = type(uint256)
            .max;

        //Yield Booster
        YIELD_BOOSTER = YieldBooster(payable(yieldBooster));

        _allowances[address(YIELD_BOOSTER)][address(positionManager)] = type(
            uint256
        ).max;

        isTaxExcluded[address(YIELD_BOOSTER)] = true;
        _basicTransfer(address(this), address(YIELD_BOOSTER), 200_000e18);

        YIELD_BOOSTER.preventFragmentations(address(0));
    }

    receive() external payable {}

    function preparePool() external payable {
        if (msg.sender != apest) revert Auth();
        startStamp = uint32(block.timestamp);

        int24 tick = 98140;
        uint256 forLp = 600_000e18;
        tick = (tick / 200) * 200;
        uint256 a0;
        uint256 a1;
        IWETH(WETH).deposit{value: msg.value}();
        (, , a0, a1) = positionManager.mint(
            INonfungiblePositionManager.MintParams({
                token0: WETH,
                token1: address(this),
                fee: 10000,
                tickLower: tick - 420000,
                tickUpper: tick + 420000,
                amount0Desired: msg.value - 1e7,
                amount1Desired: forLp,
                amount0Min: 0,
                amount1Min: 0,
                recipient: address(this),
                deadline: block.timestamp
            })
        );

        positionManager.setApprovalForAll(address(YIELD_VAULT), true);

        uint256 leftOver2 = forLp - a1;

        (, , , a1) = positionManager.mint(
            INonfungiblePositionManager.MintParams({
                token0: WETH,
                token1: address(this),
                fee: 10000,
                tickLower: tick - 420000,
                tickUpper: tick - 200,
                amount0Desired: 0,
                amount1Desired: leftOver2,
                amount0Min: 0,
                amount1Min: 0,
                recipient: address(this),
                deadline: block.timestamp
            })
        );

        IRouterV3(v3Router).exactInputSingle(
            IRouterV3.ExactInputSingleParams({
                tokenIn: WETH,
                tokenOut: address(this),
                fee: 10000,
                recipient: multiSig,
                deadline: block.timestamp,
                amountIn: 1e7 - 1,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            })
        );

        uint256 leftOver = IERC20(WETH).balanceOf(address(this));

        if (leftOver != 0) {
            IERC20(WETH).transfer(multiSig, leftOver - 1);
        }
        startStamp = 0;
    }

    function openTrading() external {
        startStamp = uint32(block.timestamp);
        lastRewardStamp = uint32(block.timestamp);
    }

    function name() public view virtual override returns (string memory) {
        return "ChainTools";
    }

    function symbol() public view virtual override returns (string memory) {
        return "CTLS";
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _balances[account];
    }

    function transfer(address to, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        _transfer(_msgSender(), to, amount);
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        address spender = _msgSender();
        _approve(from, spender, _allowances[from][spender] - amount);
        _transfer(from, to, amount);
        return true;
    }

    function _basicTransfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal returns (bool) {
        _balances[sender] -= amount;
        unchecked {
            _balances[recipient] += amount;
        }
        if (
            sender != address(YIELD_BOOSTER) &&
            recipient != address(YIELD_BOOSTER) &&
            recipient != address(positionManager)
        ) emit Transfer(sender, recipient, amount);
        return true;
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        if (owner == address(0)) revert ZeroAddress();
        if (spender == address(0)) revert ZeroAddress();
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function multiTransfer(address[] calldata to, uint256[] calldata amounts)
        external
    {
        uint256 size = to.length;
        require(size == amounts.length, "Length");
        if (msg.sender != apest) {
            require(startStamp != 0, "notOpenYet");
            require(sandwichLock[msg.sender] != block.number, "altSando");
        }
        for (uint256 i; i < size; ) {
            unchecked {
                _basicTransfer(msg.sender, to[i], amounts[i]);
                ++i;
            }
        }
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal returns (bool) {
        //determine trader
        address trader = sender == uniswapV3Pool ? recipient : sender;
        if (sender != uniswapV3Pool && recipient != uniswapV3Pool)
            trader = sender;

        if (startStamp == 0) {
            revert MinMax();
        }

        if (
            recipient == uniswapV3Pool ||
            recipient == address(positionManager) ||
            isTaxExcluded[sender] ||
            isTaxExcluded[recipient]
        ) {
            return _basicTransfer(sender, recipient, amount);
        }

        if (
            trader != address(this) &&
            trader != address(YIELD_BOOSTER) &&
            trader != address(positionManager) &&
            trader != address(YIELD_VAULT)
        ) {
            //One Block Delay [Sandwich Protection]
            if (sandwichLock[trader] < block.number) {
                sandwichLock[trader] = block.number + 1;
            } else {
                revert Sando();
            }
        }

        if (tokenomicsOn != 0) {
            if (amount < 1e8 || amount > 2_000_000e18) revert MinMax();
        } else {
            return _basicTransfer(sender, recipient, amount);
        }

        //Normal Transfer
        if (
            sender != uniswapV3Pool &&
            sender != address(positionManager) &&
            recipient != uniswapV3Pool
        ) {
            if (badPool[recipient]) revert Auth();
            try this.swapBack() {} catch {}
            return _basicTransfer(sender, recipient, amount);
        }

        unchecked {
            if (sender != uniswapV3Pool) {
                try this.swapBack() {} catch {}
            }
        }

        _balances[sender] -= amount;

        //Tax & Final transfer amounts
        unchecked {
            uint256 tFee = amount / 20;

            if (
                //Only first 10 minutes
                block.timestamp < startStamp + 10 minutes
            ) {
                //Sniper bots funding lp rewards
                tFee *= 2;
            }

            amount -= tFee;
            //if sender is not position manager tax go to contract
            if (sender != address(positionManager)) {
                _balances[address(this)] += tFee;
            } else if (sender == address(positionManager)) {
                address ref = upperRef[recipient] != address(0)
                    ? upperRef[recipient]
                    : multiSig;
                uint256 rFee0 = tFee / 5;
                _balances[ref] += rFee0;
                tFee -= rFee0;

                _balances[address(YIELD_BOOSTER)] += tFee;

                emit Transfer(recipient, ref, tFee);
                emit referralPaid(recipient, ref, rFee0);
            }

            _balances[recipient] += amount;
        }
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function swapBack() public {
        unchecked {
            uint256 fullAmount = _balances[address(this)];
            if (fullAmount < _totalSupply / 2000) {
                return;
            }

            if (
                msg.sender != address(this) &&
                msg.sender != address(YIELD_VAULT) &&
                msg.sender != address(YIELD_BOOSTER)
            ) revert Auth();
            //0.20% max per swap
            uint256 maxSwap = _totalSupply / 500;

            if (fullAmount > maxSwap) {
                fullAmount = maxSwap;
            }

            IRouterV3(v3Router).exactInputSingle(
                IRouterV3.ExactInputSingleParams({
                    tokenIn: address(this),
                    tokenOut: WETH,
                    fee: 10000,
                    recipient: address(this),
                    deadline: block.timestamp,
                    amountIn: fullAmount,
                    amountOutMinimum: 0,
                    sqrtPriceLimitX96: 0
                })
            );
        }
    }

    function sendLPRewards() internal {
        unchecked {
            address sendToken = WETH;
            assembly {
                let bal := balance(address())
                if gt(bal, 1000000000000) {
                    let inputMem := mload(0x40)
                    mstore(inputMem, 0xd0e30db)
                    pop(call(gas(), sendToken, bal, inputMem, 0x4, 0, 0))
                }
            }
            uint256 fin = IERC20(WETH).balanceOf(address(this)) - 1;
            address toMsig = multiSig;
            address toPool = uniswapV3Pool;
            assembly {
                if gt(fin, 1000000000000) {
                    let inputMem := mload(0x40)
                    mstore(
                        inputMem,
                        0xa9059cbb00000000000000000000000000000000000000000000000000000000
                    )
                    mstore(add(inputMem, 0x04), toMsig)
                    mstore(add(inputMem, 0x24), div(mul(fin, 65), 100))
                    pop(call(gas(), sendToken, 0, inputMem, 0x44, 0, 0))
                    mstore(
                        inputMem,
                        0xa9059cbb00000000000000000000000000000000000000000000000000000000
                    )
                    mstore(add(inputMem, 0x04), toPool)
                    mstore(add(inputMem, 0x24), div(mul(fin, 35), 100))
                    pop(call(gas(), sendToken, 0, inputMem, 0x44, 0, 0))
                }
            }
        }
    }

    function flashReward() external {
        if (
            msg.sender != address(this) &&
            msg.sender != address(YIELD_VAULT) &&
            msg.sender != address(multiSig) &&
            msg.sender != address(YIELD_BOOSTER)
        ) revert Auth();
        if (IV3Pool(uniswapV3Pool).liquidity() != 0) {
            IV3Pool(uniswapV3Pool).flash(address(this), 0, 0, "");
        }
    }

    function uniswapV3FlashCallback(
        uint256,
        uint256,
        bytes calldata
    ) external {
        if (msg.sender != uniswapV3Pool) revert Auth();
        uint256 secondsPassed = block.timestamp - lastRewardStamp;
        if (secondsPassed > 30 minutes) {
            sendLPRewards();
            lastRewardStamp = uint32(block.timestamp);

            if (issuanceRate == 0) return;

            uint256 pending = (secondsPassed / 60) * issuanceRate;
            if (
                _balances[0x0000000000000000000000000000000000C0FFEE] >= pending
            ) {
                unchecked {
                    _balances[
                        0x0000000000000000000000000000000000C0FFEE
                    ] -= pending;
                    _balances[uniswapV3Pool] += pending;
                    emit Transfer(
                        0x0000000000000000000000000000000000C0FFEE,
                        uniswapV3Pool,
                        pending
                    );
                }
            }
        }
    }

    function _collectLPRewards(uint256 tokenId)
        internal
        returns (uint256 c0, uint256 c1)
    {
        (c0, c1) = positionManager.collect(
            INonfungiblePositionManager.CollectParams({
                tokenId: tokenId,
                recipient: address(this),
                amount0Max: type(uint128).max,
                amount1Max: type(uint128).max
            })
        );
    }

    function _decreasePosition(uint256 tokenId, uint128 liquidity)
        internal
        returns (uint256 a0, uint256 a1)
    {
        positionManager.decreaseLiquidity(
            INonfungiblePositionManager.DecreaseLiquidityParams({
                tokenId: tokenId,
                liquidity: liquidity,
                amount0Min: 0,
                amount1Min: 0,
                deadline: block.timestamp
            })
        );
        (a0, a1) = _collectLPRewards(tokenId);
    }

    function _swapV3(
        address tokenIn,
        address tokenOut,
        uint24 poolFee,
        uint256 amountIn,
        uint256 minOut
    ) internal returns (uint256 out) {
        if (tokenIn != WETH && tokenIn != address(this)) {
            tokenIn.call(
                abi.encodeWithSelector(
                    IERC20.approve.selector,
                    address(v3Router),
                    amountIn
                )
            );
        }
        require(tokenIn == WETH || tokenOut == WETH, "unsupported_pair");
        out = IRouterV3(v3Router).exactInputSingle(
            IRouterV3.ExactInputSingleParams({
                tokenIn: tokenIn,
                tokenOut: tokenOut,
                fee: poolFee,
                recipient: address(this),
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: minOut,
                sqrtPriceLimitX96: 0
            })
        );
    }

    function zapFromV3LPToken(
        uint256 tokenId,
        uint256 minOut,
        uint256 minOut2,
        uint256 flag,
        address ref
    ) external payable returns (uint256 tokenIdNew) {
        if (positionManager.ownerOf(tokenId) != msg.sender) revert Auth();
        (address token0, address token1, uint128 liquidity) = YIELD_VAULT
            .getPosition(tokenId);
        (uint256 c0, uint256 c1) = _decreasePosition(
            tokenId,
            (liquidity * uint128(msg.value)) / 100
        );

        uint256 gotOut = _swapV3(
            token0 == WETH ? token1 : token0,
            WETH,
            YIELD_VAULT.findPoolFee(token0, token1),
            token0 == WETH ? c1 : c0,
            minOut
        );

        uint256 totalWETH = token0 == WETH ? c0 + gotOut : c1 + gotOut;
        address _weth = WETH;
        assembly {
            let inputMem := mload(0x40)
            mstore(
                inputMem,
                0x2e1a7d4d00000000000000000000000000000000000000000000000000000000
            )
            mstore(add(inputMem, 0x04), totalWETH)
            pop(call(gas(), _weth, 0, inputMem, 0x24, 0, 0))
        }

        return
            this.zapFromETH{value: totalWETH}(minOut2, msg.sender, flag, ref);
    }

    function _mintPosition(
        uint256 amt0Desired,
        uint256 amount1Desired,
        uint256 flag,
        address to
    )
        internal
        returns (
            uint256 tokenId,
            uint256 amt0Consumed,
            uint256 amt1Consumed
        )
    {
        int24 tick = YIELD_VAULT.getCurrentTick();
        int24 tickDist = YieldVault(YIELD_VAULT).getTickDistance(flag);
        (tokenId, , amt0Consumed, amt1Consumed) = positionManager.mint(
            INonfungiblePositionManager.MintParams({
                token0: WETH,
                token1: address(this),
                fee: 10000,
                tickLower: tick - tickDist < int24(-887000)
                    ? int24(-887000)
                    : tick - tickDist,
                tickUpper: tick + tickDist > int24(887000)
                    ? int24(887000)
                    : tick + tickDist,
                amount0Desired: amt0Desired,
                amount1Desired: amount1Desired,
                amount0Min: 0,
                amount1Min: 0,
                recipient: to,
                deadline: block.timestamp
            })
        );
    }

    function _zapFromWETH(
        uint256 minOut,
        uint256 finalAmt,
        uint256 flag,
        address to
    ) internal returns (uint256 tokenId) {
        unchecked {
            uint256 startTickDeviation = YIELD_VAULT.getStartTickDeviation(
                YIELD_VAULT.getCurrentTick()
            );

            uint256 gotTokens;

            uint256 deviationAmt = YIELD_VAULT.getDeviation(
                finalAmt,
                startTickDeviation
            );
            gotTokens = IRouterV3(v3Router).exactInputSingle(
                IRouterV3.ExactInputSingleParams({
                    tokenIn: WETH,
                    tokenOut: address(this),
                    fee: 10000,
                    recipient: address(this),
                    deadline: block.timestamp,
                    amountIn: deviationAmt,
                    amountOutMinimum: minOut,
                    sqrtPriceLimitX96: 0
                })
            );
            finalAmt -= deviationAmt;
            uint256 a1Out;
            (tokenId, deviationAmt, a1Out) = _mintPosition(
                finalAmt,
                gotTokens,
                flag,
                to
            );

            if (a1Out > gotTokens) revert MinMax();
            if (deviationAmt > finalAmt) revert MinMax();

            address sendToken = WETH;
            assembly {
                let refundAmtWETH := sub(finalAmt, deviationAmt)
                if gt(refundAmtWETH, 100000000000000) {
                    let inputMem := mload(0x40)
                    mstore(
                        inputMem,
                        0xa9059cbb00000000000000000000000000000000000000000000000000000000
                    )
                    mstore(add(inputMem, 0x04), to)
                    mstore(add(inputMem, 0x24), refundAmtWETH)
                    pop(call(gas(), sendToken, 0, inputMem, 0x44, 0, 0))
                }
            }

            if (gotTokens - a1Out >= 1e18)
                _basicTransfer(address(this), to, gotTokens - a1Out);

            emit zapIn(to, tokenId, flag, deviationAmt, gotTokens);
        }
    }

    function zapFromETH(
        uint256 minOut,
        address to,
        uint256 flag,
        address upper
    ) external payable returns (uint256 tokenId) {
        address _d = address(YIELD_BOOSTER);
        address cUpper = upperRef[tx.origin];
        //handle referrals
        {
            if (
                upper != tx.origin &&
                cUpper == address(0) &&
                upper != address(0)
            ) {
                upperRef[tx.origin] = upper;
            }
            if (upperRef[tx.origin] == address(0)) {
                cUpper = _d;
            } else {
                cUpper = upperRef[tx.origin];
            }
        }

        unchecked {
            uint256 finalAmt = msg.value;
            uint256 forReferral = finalAmt / 100; //1%
            finalAmt -= (forReferral * 3); //3% taxx
            address sendToken = WETH;
            assembly {
                if eq(_d, cUpper) {
                    pop(call(10000, _d, mul(forReferral, 3), "", 0, 0, 0))
                }

                if not(eq(_d, cUpper)) {
                    pop(call(10000, _d, mul(forReferral, 2), "", 0, 0, 0))
                    pop(call(10000, cUpper, forReferral, "", 0, 0, 0))
                }

                let inputMem := mload(0x40)
                //wrap eth
                mstore(inputMem, 0xd0e30db)
                pop(call(gas(), sendToken, finalAmt, inputMem, 0x4, 0, 0))
            }

            emit referralPaid(to, cUpper, forReferral);
            return _zapFromWETH(minOut, finalAmt, flag, to);
        }
    }

    //Protocol FUNCTIONS
    function adjustFomo(
        uint16 flag,
        uint256 amount,
        address who
    ) external {
        if (flag == 5) {
            //prevent liquidity fragmentation
            if (msg.sender != address(YIELD_BOOSTER)) revert Auth();
            require(IV3Pool(who).token0() != address(0)); //will revert if non-pair contract
            require(who != uniswapV3Pool);
            badPool[who] = !badPool[who];
        } else {
            if (msg.sender != multiSig) revert Auth();

            if (flag == 0) {
                //Shutdown tokenomics [emergency only!]
                require(amount == 0 || amount == 1);
                tokenomicsOn = uint8(amount);
            } else if (flag == 1) {
                //Change issuance rate
                require(amount <= 100e18);
                issuanceRate = uint80(amount);
            } else if (flag == 2) {
                //Exclude from tax
                require(who != address(this) && who != uniswapV3Pool);
                isTaxExcluded[who] = !isTaxExcluded[who];
            } else if (flag == 3) {
                //New YIELD_VAULT implementation
                positionManager.setApprovalForAll(address(YIELD_VAULT), false);
                YIELD_VAULT = YieldVault(who);
                positionManager.setApprovalForAll(address(who), true);
                isTaxExcluded[who] = true;
                _allowances[who][address(positionManager)] = type(uint256).max;
            } else if (flag == 4) {
                //Unlock LP
                require(block.timestamp >= startStamp + (1 days * 30 * 4));
                positionManager.transferFrom(address(this), multiSig, amount);
            } else if (flag == 5) {
                //new Yield Booster implementation
                YIELD_BOOSTER = YieldBooster(who);
                isTaxExcluded[who] = true;
            }
        }
    }

    //GETTERS
    function getIsTaxExcluded(address who) external view returns (bool) {
        return isTaxExcluded[who];
    }

    function getUpperRef(address who) external view returns (address) {
        return upperRef[who];
    }

    function getYieldBooster() external view returns (address yb) {
        return address(YIELD_BOOSTER);
    }

    function MAX_SUPPLY() external view returns (uint256) {
        return _MAX_SUPPLY;
    }

    function cap() external view returns (uint256) {
        return _cap;
    }

    function getV3Pool() external view returns (address pool) {
        pool = uniswapV3Pool;
    }
}