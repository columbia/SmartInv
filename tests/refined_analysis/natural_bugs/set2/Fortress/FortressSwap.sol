// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// ███████╗░█████╗░██████╗░████████╗██████╗░███████╗░██████╗░██████╗
// ██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗██╔════╝██╔════╝██╔════╝
// █████╗░░██║░░██║██████╔╝░░░██║░░░██████╔╝█████╗░░╚█████╗░╚█████╗░
// ██╔══╝░░██║░░██║██╔══██╗░░░██║░░░██╔══██╗██╔══╝░░░╚═══██╗░╚═══██╗
// ██║░░░░░╚█████╔╝██║░░██║░░░██║░░░██║░░██║███████╗██████╔╝██████╔╝
// ╚═╝░░░░░░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚═════╝░╚═════╝░
// ███████╗██╗███╗░░██╗░█████╗░███╗░░██╗░█████╗░███████╗
// ██╔════╝██║████╗░██║██╔══██╗████╗░██║██╔══██╗██╔════╝
// █████╗░░██║██╔██╗██║███████║██╔██╗██║██║░░╚═╝█████╗░░
// ██╔══╝░░██║██║╚████║██╔══██║██║╚████║██║░░██╗██╔══╝░░
// ██║░░░░░██║██║░╚███║██║░░██║██║░╚███║╚█████╔╝███████╗
// ╚═╝░░░░░╚═╝╚═╝░░╚══╝╚═╝░░╚═╝╚═╝░░╚══╝░╚════╝░╚══════╝

//  _____         _                   _____               
// |   __|___ ___| |_ ___ ___ ___ ___|   __|_ _ _ ___ ___ 
// |   __| . |  _|  _|  _| -_|_ -|_ -|__   | | | | .'| . |
// |__|  |___|_| |_| |_| |___|___|___|_____|_____|__,|  _|
//                                                   |_|  

// Github - https://github.com/FortressFinance

import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import "lib/openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";
import "lib/openzeppelin-contracts/contracts/utils/math/SafeCast.sol";

import "src/shared/fortress-interfaces/IFortressSwap.sol";

import "src/shared/interfaces/IWETH.sol";
import "src/shared/interfaces/ICurvePool.sol";
import "src/shared/interfaces/ICurveCryptoETHV2Pool.sol";
import "src/shared/interfaces/ICurveSBTCPool.sol";
import "src/shared/interfaces/ICurveCryptoV2Pool.sol";
import "src/shared/interfaces/ICurve3Pool.sol";
import "src/shared/interfaces/ICurvesUSD4Pool.sol";
import "src/shared/interfaces/ICurveBase3Pool.sol";
import "src/shared/interfaces/ICurvePlainPool.sol";
import "src/shared/interfaces/ICurveCRVMeta.sol";
import "src/shared/interfaces/ICurveFraxMeta.sol";
import "src/shared/interfaces/ICurveFraxCryptoMeta.sol";
import "src/shared/interfaces/IUniswapV3Router.sol";
import "src/shared/interfaces/IUniswapV3Pool.sol";
import "src/shared/interfaces/IUniswapV2Router.sol";
import "src/shared/interfaces/IBalancerVault.sol";
import "src/shared/interfaces/IBalancerPool.sol";

contract FortressSwap is ReentrancyGuard, IFortressSwap {

    using SafeERC20 for IERC20;
    using SafeCast for int256;

    /// @notice The address of WETH token.
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    /// @notice The address representing native ETH.
    address private constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    /// @notice The address of Uniswap V3 Router.
    address private constant UNIV3_ROUTER = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    /// @notice The address of Fraxswap Uniswap V2 Router (https://docs.frax.finance/smart-contracts/fraxswap#ethereum).
    address private constant FRAXSWAP_UNIV2_ROUTER = 0x1C6cA5DEe97C8C368Ca559892CCce2454c8C35C7;
    /// @notice The address of Curve Base Pool (https://curve.fi/3pool).
    address private constant CURVE_BP = 0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7;
    /// @notice The address of Curve Frax Base Pool (https://curve.fi/fraxusdc).
    address private constant FRAX_BP = 0xDcEF968d416a41Cdac0ED8702fAC8128A64241A2;
    /// @notice The address of Curve Frax Base Pool LP tokens (https://etherscan.io/address/0x3175Df0976dFA876431C2E9eE6Bc45b65d3473CC).
    address constant crvFRAX = 0x3175Df0976dFA876431C2E9eE6Bc45b65d3473CC;
    /// @notice The address of Balancer vault.
    address constant BALANCER_VAULT = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;

    struct Route {
        // pool type -->
        // 0: UniswapV3
        // 1: Fraxswap
        // 2: Curve2AssetPool
        // 3: _swapCurveCryptoV2
        // 4: Curve3AssetPool
        // 5: CurveETHV2Pool
        // 6: CurveCRVMeta
        // 7: CurveFraxMeta
        // 8: CurveBase3Pool
        // 9: CurveSBTCPool
        // 10: Curve4Pool
        // 11: FraxCryptoMeta
        // 12: BalancerSingleSwap
        /// @notice The internal pool type.
        uint256[] poolType;
        /// @notice The pool addresses.
        address[] poolAddress;
        /// @notice The addresses of the token to swap from.
        address[] tokenIn;
        /// @notice The addresses of the token to swap to.
        address[] tokenOut;
    }

    /// @notice The swap routes.
    mapping(address => mapping(address => Route)) private routes;
    
    /// @notice The address of the owner.
    address public owner;

    /********************************** View Functions **********************************/

    /// @dev Check if a certain swap route is available.
    /// @param _fromToken - The address of the input token.
    /// @param _toToken - The address of the output token.
    /// @return - Whether the route exist.
    function routeExists(address _fromToken, address _toToken) external view returns (bool) {
        return routes[_fromToken][_toToken].poolAddress.length > 0;
    }

    /********************************** Constructor **********************************/

    constructor(address _owner) {
        if (_owner == address(0)) revert ZeroInput();
         
        owner = _owner;
    }

    /********************************** Mutated Functions **********************************/

    /// @dev Swap from one token to another.
    /// @param _fromToken - The address of the input token.
    /// @param _toToken - The address of the output token.
    /// @param _amount - The amount of input token.
    /// @return - The amount of output token.
    function swap(address _fromToken, address _toToken, uint256 _amount) external payable nonReentrant returns (uint256) {
        Route storage _route = routes[_fromToken][_toToken];
        if (_route.poolAddress.length == 0) revert RouteUnavailable();
        
        if (msg.value > 0) {
            if (msg.value != _amount) revert AmountMismatch();
            if (_fromToken != ETH) revert TokenMismatch();
        } else {
            if (_fromToken == ETH) revert TokenMismatch();
            IERC20(_fromToken).safeTransferFrom(msg.sender, address(this), _amount);
        }
        
        uint256 _poolType;
        address _poolAddress;
        address _tokenIn;
        address _tokenOut;
        for(uint256 i = 0; i < _route.poolAddress.length; i++) {
            _poolType = _route.poolType[i];
            _poolAddress = _route.poolAddress[i];
            _tokenIn = _route.tokenIn[i];
            _tokenOut = _route.tokenOut[i];
            
            if (_poolType == 0) {
                _amount = _swapUniV3(_tokenIn, _tokenOut, _amount, _poolAddress);
            } else if (_poolType == 1) {
                _amount = _swapFraxswapUniV2(_tokenIn, _tokenOut, _amount);
            } else if (_poolType == 2) {
                _amount = _swapCurve2Asset(_tokenIn, _tokenOut, _amount, _poolAddress);
            } else if (_poolType == 3) {
                _amount = _swapCurveCryptoV2(_tokenIn, _tokenOut, _amount, _poolAddress);
            } else if (_poolType == 4) {
                _amount = _swapCurve3Asset(_tokenIn, _tokenOut, _amount, _poolAddress);
            } else if (_poolType == 5) {
                _amount = _swapCurveETHV2(_tokenIn, _tokenOut, _amount, _poolAddress);
            } else if (_poolType == 6) {
                _amount = _swapCurveCRVMeta(_tokenIn, _tokenOut, _amount, _poolAddress);
            } else if (_poolType == 7) {
                _amount = _swapCurveFraxMeta(_tokenIn, _tokenOut, _amount, _poolAddress);
            } else if (_poolType == 8) {
                _amount = _swapCurveBase3Pool(_tokenIn, _tokenOut, _amount, _poolAddress);
            } else if (_poolType == 9) {
                _amount = _swapCurveSBTCPool(_tokenIn, _tokenOut, _amount, _poolAddress);
            } else if (_poolType == 10) {
                _amount = _swapCurve4Pool(_tokenIn, _tokenOut, _amount, _poolAddress);
            } else if (_poolType == 11) {
                _amount = _swapFraxCryptoMeta(_tokenIn, _tokenOut, _amount, _poolAddress);
            } else if (_poolType == 12) {
                _amount = _swapBalancerPoolSingle(_tokenIn, _tokenOut, _amount, _poolAddress);
            } else {
                revert UnsupportedPoolType();
            }
        }
        
        if (_toToken == ETH) {
            // slither-disable-next-line arbitrary-send-eth
            (bool sent,) = msg.sender.call{value: _amount}("");
            if (!sent) revert FailedToSendETH();
        } else {
            IERC20(_toToken).safeTransfer(msg.sender, _amount);
        }
        
        emit Swap(_fromToken, _toToken, _amount);
        
        return _amount;
    }

    /********************************** Restricted Functions **********************************/

    /// @dev Add/Update a swap route.
    /// @param _fromToken - The address of the input token.
    /// @param _toToken - The address of the output token.
    /// @param _poolType - The internal pool type.
    /// @param _poolAddress - The pool addresses.
    /// @param _fromList - The addresses of the input tokens.
    /// @param _toList - The addresses of the output tokens.
    function updateRoute(address _fromToken, address _toToken, uint256[] memory _poolType, address[] memory _poolAddress, address[] memory _fromList, address[] memory _toList) external {
        if (msg.sender != owner) revert Unauthorized();
        if (routes[_fromToken][_toToken].poolAddress.length != 0) revert RouteAlreadyExists();

        routes[_fromToken][_toToken] = Route(
            _poolType,
            _poolAddress,
            _fromList,
            _toList
        );

        emit UpdateRoute(_fromToken, _toToken, _poolAddress);
    }

    /// @dev Delete a swap route.
    /// @param _fromToken - The address of the input token.
    /// @param _toToken - The address of the output token.
    function deleteRoute(address _fromToken, address _toToken) external {
        if (msg.sender != owner) revert Unauthorized();

        delete routes[_fromToken][_toToken];

        emit DeleteRoute(_fromToken, _toToken);
    }

    /// @dev Update the contract owner.
    /// @param _newOwner - The address of the new owner.
    function updateOwner(address _newOwner) external {
        if (msg.sender != owner) revert Unauthorized();
        if (_newOwner == address(0)) revert ZeroInput();

        owner = _newOwner;
        
        emit UpdateOwner(_newOwner);
    }

    /// @dev Rescue stuck ERC20 tokens.
    /// @param _tokens - The address of the tokens to rescue.
    /// @param _recipient - The address of the recipient of rescued tokens.
    function rescue(address[] memory _tokens, address _recipient) external {
        if (msg.sender != owner) revert Unauthorized();
        if (_recipient == address(0)) revert ZeroInput();

        for (uint256 i = 0; i < _tokens.length; i++) {
            IERC20(_tokens[i]).safeTransfer(_recipient, IERC20(_tokens[i]).balanceOf(address(this)));
        }

        emit Rescue(_tokens, _recipient);
    }

    /// @dev Rescue stuck ETH.
    /// @param _recipient - The address of the recipient of rescued ETH.
    function rescueETH(address _recipient) external {
        if (msg.sender != owner) revert Unauthorized();
        if (_recipient == address(0)) revert ZeroInput();

        (bool sent,) = _recipient.call{value: address(this).balance}("");
        if (!sent) revert FailedToSendETH();

        emit RescueETH(_recipient);
    }

    /********************************** Internal Functions **********************************/

    function _swapUniV3(address _fromToken, address _toToken, uint256 _amount, address _poolAddress) internal returns (uint256) {
        
        bool _toETH = false;
        if (_fromToken == ETH) {
            _wrapETH(_amount);
            _fromToken = WETH;
        } else if (_toToken == ETH) {
            _toToken = WETH;
            _toETH = true;
        }
        
        _approve(_fromToken, UNIV3_ROUTER, _amount);

        uint24 _fee = IUniswapV3Pool(_poolAddress).fee();
        
        uint256 _before = IERC20(_toToken).balanceOf(address(this));
        IUniswapV3Router.ExactInputSingleParams memory _params = IUniswapV3Router.ExactInputSingleParams(
            _fromToken,
            _toToken,
            _fee, 
            address(this), 
            block.timestamp,
            _amount,
            0,
            0
        );

        IUniswapV3Router(UNIV3_ROUTER).exactInputSingle(_params);
        _amount = IERC20(_toToken).balanceOf(address(this)) - _before;

        if (_toETH) {
            _unwrapETH(_amount);
        }

        return _amount;
    }

    function _swapFraxswapUniV2(address _fromToken, address _toToken, uint256 _amount) internal returns (uint256) {
        
        bool _toETH = false;
        if (_fromToken == ETH) {
            _wrapETH(_amount);
            _fromToken = WETH;
        } else if (_toToken == ETH) {
            _toToken = WETH;
            _toETH = true;
        }

        _approve(_fromToken, FRAXSWAP_UNIV2_ROUTER, _amount);

        address[] memory path = new address[](2);
        path[0] = _fromToken;
        path[1] = _toToken;

        // uint256[] memory _amounts;
        uint256 _before = IERC20(_toToken).balanceOf(address(this));
        IUniswapV2Router(FRAXSWAP_UNIV2_ROUTER).swapExactTokensForTokens(_amount, 0, path, address(this), block.timestamp);
        _amount = IERC20(_toToken).balanceOf(address(this)) - _before;

        if (_toETH) {
            _unwrapETH(_amount);
        } 

        // return _amounts[1];
        return _amount;
    }

    function _swapBalancerPoolSingle(address _fromToken, address _toToken, uint256 _amount, address _poolAddress) internal returns (uint256) {
        bytes32 _poolId = IBalancerPool(_poolAddress).getPoolId();
        
        bool _toETH = false;
        if (_fromToken == ETH) {
            _wrapETH(_amount);
            _fromToken = WETH;
        } else if (_toToken == ETH) {
            _toToken = WETH;
            _toETH = true;
        }
        
        _approve(_fromToken, BALANCER_VAULT, _amount);
        uint256 _before = IERC20(_toToken).balanceOf(address(this));
        IBalancerVault(BALANCER_VAULT).swap(
            IBalancerVault.SingleSwap({
            poolId: _poolId,
            kind: IBalancerVault.SwapKind.GIVEN_IN,
            assetIn: _fromToken,
            assetOut: _toToken,
            amount: _amount,
            userData: new bytes(0)
            }),
            IBalancerVault.FundManagement({
            sender: address(this),
            fromInternalBalance: false,
            recipient: payable(address(this)),
            toInternalBalance: false
            }),
            0,
            block.timestamp
        );

        _amount = IERC20(_toToken).balanceOf(address(this)) - _before;

        if (_toETH) {
            _unwrapETH(_amount);
        }

        return _amount;
    }

    // ICurvePlainPool
    // ICurveETHPool
    function _swapCurve2Asset(address _fromToken, address _toToken, uint256 _amount, address _poolAddress) internal returns (uint256) {
        ICurvePool _pool = ICurvePool(_poolAddress);
        
        int128 _to = 0;
        int128 _from = 0;
        if (_fromToken == _pool.coins(0) && _toToken == _pool.coins(1)) {
            _from = 0;
            _to = 1;
        } else if (_fromToken == _pool.coins(1) && _toToken == _pool.coins(0)) {
            _from = 1;
            _to = 0;
        } else {
            revert InvalidTokens();
        }
        
        uint256 _before = _toToken == ETH ? address(this).balance : IERC20(_toToken).balanceOf(address(this));

        if (_fromToken == ETH) {
            _pool.exchange{ value: _amount }(_from, _to, _amount, 0);    
        } else {
            _approve(_fromToken, _poolAddress, _amount);
            _pool.exchange(_from, _to, _amount, 0);
        }
        return _toToken == ETH ? address(this).balance - _before : IERC20(_toToken).balanceOf(address(this)) - _before;
    }

    // ICurveCryptoV2Pool
    function _swapCurveCryptoV2(address _fromToken, address _toToken, uint256 _amount, address _poolAddress) internal returns (uint256) {
        ICurveCryptoV2Pool _pool = ICurveCryptoV2Pool(_poolAddress);
        
        uint256 _to = 0;
        uint256 _from = 0;
        if (_fromToken == _pool.coins(0) && _toToken == _pool.coins(1)) {
            _from = 0;
            _to = 1;
        } else if (_fromToken == _pool.coins(1) && _toToken == _pool.coins(0)) {
            _from = 1;
            _to = 0;
        } else {
            revert InvalidTokens();
        }
        
        uint256 _before = _toToken == ETH ? address(this).balance : IERC20(_toToken).balanceOf(address(this));

        if (_pool.coins(_from) == ETH) {
            _pool.exchange{ value: _amount }(_from, _to, _amount, 0);    
        } else {
            _approve(_fromToken, _poolAddress, _amount);
            _pool.exchange(_from, _to, _amount, 0);
        }
        return _toToken == ETH ? address(this).balance - _before : IERC20(_toToken).balanceOf(address(this)) - _before;
    }

    // ICurveBase3Pool
    function _swapCurveBase3Pool(address _fromToken, address _toToken, uint256 _amount, address _poolAddress) internal returns (uint256) {
        ICurveBase3Pool _pool = ICurveBase3Pool(_poolAddress);
        
        int256 _to = 0;
        int256 _from = 0;
        for(int256 i = 0; i < 3; i++) {
            if (_fromToken == _pool.coins(i.toUint256())) {
                _from = i;
            } else if (_toToken == _pool.coins(i.toUint256())) {
                _to = i;
            }
        }

        _approve(_fromToken, _poolAddress, _amount);
        
        uint256 _before = IERC20(_toToken).balanceOf(address(this));
        _pool.exchange(_from.toInt128(), _to.toInt128(), _amount, 0);
        _amount = IERC20(_toToken).balanceOf(address(this)) - _before;
        
        return _amount;
    }

    // ICurve3Pool
    function _swapCurve3Asset(address _fromToken, address _toToken, uint256 _amount, address _poolAddress) internal returns (uint256) {
        ICurve3Pool _pool = ICurve3Pool(_poolAddress);

        bool _toETH = false;
        if (_fromToken == ETH) {
            _wrapETH(_amount);
            _fromToken = WETH;
        } else if (_toToken == ETH) {
            _toToken = WETH;
            _toETH = true;
        }

        uint256 _to = 0;
        uint256 _from = 0;
        for(uint256 i = 0; i < 3; i++) {
            if (_fromToken == _pool.coins(i)) {
                _from = i;
            } else if (_toToken == _pool.coins(i)) {
                _to = i;
            }
        }

        _approve(_fromToken, _poolAddress, _amount);
        
        uint256 _before = IERC20(_toToken).balanceOf(address(this));
        _pool.exchange(_from, _to, _amount, 0);
        _amount = IERC20(_toToken).balanceOf(address(this)) - _before;
        
        if (_toETH) {
            _unwrapETH(_amount);
        }
        return _amount;
    }

    function _swapCurve4Pool(address _fromToken, address _toToken, uint256 _amount, address _poolAddress) internal returns (uint256) {
        ICurvesUSD4Pool _pool = ICurvesUSD4Pool(_poolAddress);

        int128 _to = 0;
        int128 _from = 0;
        for(int128 i = 0; i < 4; i++) {
            if (_fromToken == _pool.coins(i)) {
                _from = i;
            } else if (_toToken == _pool.coins(i)) {
                _to = i;
            }
        }

        _approve(_fromToken, _poolAddress, _amount);
        
        uint256 _before = IERC20(_toToken).balanceOf(address(this));
        _pool.exchange(_from, _to, _amount, 0);
        _amount = IERC20(_toToken).balanceOf(address(this)) - _before;
        
        return _amount;
    }
    
    // ICurveSBTCPool
    function _swapCurveSBTCPool(address _fromToken, address _toToken, uint256 _amount, address _poolAddress) internal returns (uint256) {
        ICurveSBTCPool _pool = ICurveSBTCPool(_poolAddress);

        int128 _to = 0;
        int128 _from = 0;
        for(int128 i = 0; i < 3; i++) {
            if (_fromToken == _pool.coins(i)) {
                _from = i;
            } else if (_toToken == _pool.coins(i)) {
                _to = i;
            }
        }

        _approve(_fromToken, _poolAddress, _amount);
        
        uint256 _before = IERC20(_toToken).balanceOf(address(this));
        _pool.exchange(_from, _to, _amount, 0);
        _amount = IERC20(_toToken).balanceOf(address(this)) - _before;
        
        return _amount;
    }

    // ICurveCRVMeta
    function _swapCurveCRVMeta(address _fromToken, address _toToken, uint256 _amount, address _poolAddress) internal returns (uint256) {
        ICurveCRVMeta _pool = ICurveCRVMeta(_poolAddress);

        int128 _to = 0;
        int128 _from = 0;
        if (_fromToken == _pool.coins(0)) {
            _approve(_fromToken, _poolAddress, _amount);
            _from = 0;
        } else if (_toToken == _pool.coins(0)) {
            _to = 0;
        } else {
            revert InvalidTokens();
        }
        
        ICurveBase3Pool _curveBP = ICurveBase3Pool(CURVE_BP);
        for (int256 i = 0; i < 3; i++) {
            if (_curveBP.coins(i.toUint256()) == _fromToken) {
                _approve(_fromToken, _poolAddress, _amount);
                _from = i.toInt128() + 1;
            } else if (_curveBP.coins(i.toUint256()) == _toToken) {
                _to = i.toInt128() + 1;
            }
        }
        uint256 _before = IERC20(_toToken).balanceOf(address(this));
        _pool.exchange_underlying(_from, _to, _amount, 0);

        return IERC20(_toToken).balanceOf(address(this)) - _before;
    }

    // ICurveFraxMeta
    function _swapCurveFraxMeta(address _fromToken, address _toToken, uint256 _amount, address _poolAddress) internal returns (uint256) {
        ICurveFraxMeta _pool = ICurveFraxMeta(_poolAddress);

        int128 _to = 0;
        int128 _from = 0;
        if (_fromToken == _pool.coins(0)) {
            _approve(_fromToken, _poolAddress, _amount);
            _from = 0;
        } else if (_toToken == _pool.coins(0)) {
            _to = 0;
        } else {
            revert InvalidTokens();
        }

        ICurveFraxMeta _fraxBP = ICurveFraxMeta(FRAX_BP);
        for (int256 i = 0; i < 2; i++) {
            if (_fromToken == _fraxBP.coins(i.toUint256())) {
                _approve(_fromToken, _poolAddress, _amount);
                _from = i.toInt128() + 1;
            } else if (_toToken == _fraxBP.coins(i.toUint256())) {
                _to = i.toInt128() + 1;
            }
        }
        uint256 _before = IERC20(_toToken).balanceOf(address(this));
        _pool.exchange_underlying(_from, _to, _amount, 0);

        return IERC20(_toToken).balanceOf(address(this)) - _before;
    }

    // ICurveFraxCryptoMeta
    function _swapFraxCryptoMeta(address _fromToken, address _toToken, uint256 _amount, address _poolAddress) internal returns (uint256) {
        ICurveFraxCryptoMeta _pool = ICurveFraxCryptoMeta(_poolAddress);

        if (_fromToken == ETH) {
            _wrapETH(_amount);
            _fromToken = WETH;
        } else if (_toToken == ETH) {
            _toToken = WETH;
        }

        ICurvePlainPool _fraxBP = ICurvePlainPool(FRAX_BP);
        uint256 _lpTokens = 0;
        int128 _to = 0;
        if (_fromToken == _pool.coins(0)) {
            _approve(_fromToken, _poolAddress, _amount);
            _lpTokens = _pool.exchange(0, 1, _amount, 0);
            if (_toToken == _fraxBP.coins(0)) {
                _to = 0;
            } else if (_toToken == _fraxBP.coins(1)) {
                _to = 1;
            }
            _approve(crvFRAX, FRAX_BP, _lpTokens);
            return _fraxBP.remove_liquidity_one_coin(_lpTokens, _to, 0);
        
        } else if (_toToken == _pool.coins(0)) {
            _approve(_fromToken, FRAX_BP, _amount);
            if (_fromToken == _fraxBP.coins(0)) {
                _lpTokens = _fraxBP.add_liquidity([_amount, 0], 0);
            } else if (_fromToken == _fraxBP.coins(1)) {
                _lpTokens = _fraxBP.add_liquidity([0, _amount], 0);
            }
            _approve(crvFRAX, _poolAddress, _lpTokens);
            return _pool.exchange(1, 0, _lpTokens, 0);
        } else {
            revert InvalidTokens();
        }
    }

    // ICurveCryptoETHV2Pool
    function _swapCurveETHV2(address _fromToken, address _toToken, uint256 _amount, address _poolAddress) internal returns (uint256) {
        ICurveCryptoETHV2Pool _pool = ICurveCryptoETHV2Pool(_poolAddress);
        
        bool _toETH = false;
        if (_fromToken == ETH) {
            _wrapETH(_amount);
            _fromToken = WETH;
        } else if (_toToken == ETH) {
            _toToken = WETH;
            _toETH = true;
        }

        _approve(_fromToken, _poolAddress, _amount);

        uint256 _to = 0;
        uint256 _from = 0;
        if (_fromToken == _pool.coins(0) && _toToken == _pool.coins(1)) {
            _from = 0;
            _to = 1;
        } else if (_fromToken == _pool.coins(1) && _toToken == _pool.coins(0)) {
            _from = 1;
            _to = 0;
        } else {
            revert InvalidTokens();
        }
        
        uint256 _before = IERC20(_toToken).balanceOf(address(this));
        _pool.exchange(_from, _to, _amount, 0, false);
        _amount = IERC20(_toToken).balanceOf(address(this)) - _before;

        if (_toETH) {
            _unwrapETH(_amount);
        }
        return _amount;
    }

    function _wrapETH(uint256 _amount) internal {
        IWETH(WETH).deposit{ value: _amount }();
    }

    function _unwrapETH(uint256 _amount) internal {
        IWETH(WETH).withdraw(_amount);
    }

    function _approve(address _token, address _spender, uint256 _amount) internal {
        IERC20(_token).safeApprove(_spender, 0);
        IERC20(_token).safeApprove(_spender, _amount);
    }

    receive() external payable {}
}