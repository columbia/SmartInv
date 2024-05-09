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
     
//  _____         _                   _____     _   _ _____               
// |   __|___ ___| |_ ___ ___ ___ ___|  _  |___| |_|_|   __|_ _ _ ___ ___ 
// |   __| . |  _|  _|  _| -_|_ -|_ -|     |  _| . | |__   | | | | .'| . |
// |__|  |___|_| |_| |_| |___|___|___|__|__|_| |___|_|_____|_____|__,|  _|
//                                                                   |_|  

// Github - https://github.com/FortressFinance

import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuard} from "lib/openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";
import {SafeCast} from "lib/openzeppelin-contracts/contracts/utils/math/SafeCast.sol";
import {Address} from "lib/openzeppelin-contracts/contracts/utils/Address.sol";

import {IFortressSwap} from "src/shared/fortress-interfaces/IFortressSwap.sol";

import {IUniswapV3RouterArbi} from "src/arbitrum/interfaces/IUniswapV3RouterArbi.sol";
import {IGMXRouter} from "src/arbitrum/interfaces/IGMXRouter.sol";
import {IWETH} from "src/shared/interfaces/IWETH.sol";
import {ICurvePool} from "src/shared/interfaces/ICurvePool.sol";
import {ICurveCryptoETHV2Pool} from "src/shared/interfaces/ICurveCryptoETHV2Pool.sol";
import {ICurveSBTCPool} from "src/shared/interfaces/ICurveSBTCPool.sol";
import {ICurveCryptoV2Pool} from "src/shared/interfaces/ICurveCryptoV2Pool.sol";
import {ICurve3Pool} from "src/shared/interfaces/ICurve3Pool.sol";
import {ICurvesUSD4Pool} from "src/shared/interfaces/ICurvesUSD4Pool.sol";
import {ICurveBase3Pool} from "src/shared/interfaces/ICurveBase3Pool.sol";
import {ICurvePlainPool} from "src/shared/interfaces/ICurvePlainPool.sol";
import {ICurveCRVMeta} from "src/shared/interfaces/ICurveCRVMeta.sol";
import {ICurveFraxMeta} from "src/shared/interfaces/ICurveFraxMeta.sol";
import {ICurveFraxCryptoMeta} from "src/shared/interfaces/ICurveFraxCryptoMeta.sol";
import {IUniswapV3Pool} from "src/shared/interfaces/IUniswapV3Pool.sol";
import {IUniswapV2Router} from "src/shared/interfaces/IUniswapV2Router.sol";
import {IBalancerVault} from "src/shared/interfaces/IBalancerVault.sol";
import {IBalancerPool} from "src/shared/interfaces/IBalancerPool.sol";

contract FortressArbiSwap is ReentrancyGuard, IFortressSwap {

    using SafeERC20 for IERC20;
    using SafeCast for int256;
    using Address for address payable;

    /// @notice The address of WETH token (Arbitrum)
    address private constant WETH = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;
    /// @notice The address representing native ETH.
    address private constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    /// @notice The address of Uniswap V3 Router (Arbitrum).
    address private constant UNIV3_ROUTER = 0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45;
    /// @notice The address of Balancer vault (Arbitrum).
    address constant BALANCER_VAULT = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    // The address of Sushi Swap Router (Arbitrum).
    address constant SUSHI_ARB_ROUTER = 0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506;
    /// @notice The address of Fraxswap Uniswap V2 Router Arbitrum (https://docs.frax.finance/smart-contracts/fraxswap#arbitrum-1).
    address private constant FRAXSWAP_UNIV2_ROUTER = 0xc2544A32872A91F4A553b404C6950e89De901fdb;
    /// @notice The address of GMX Swap Router.
    address constant GMX_ROUTER = 0xaBBc5F99639c9B6bCb58544ddf04EFA6802F4064;

    struct Route {
        // pool type -->
        // 0: UniswapV3
        // 1: Fraxswap
        // 2: Curve2AssetPool
        // 3: _swapCurveCryptoV2
        // 4: Curve3AssetPool
        // 5: CurveETHV2Pool
        // 6: CurveCRVMeta - N/A
        // 7: CurveFraxMeta - N/A
        // 8: CurveBase3Pool
        // 9: CurveSBTCPool
        // 10: Curve4Pool
        // 11: FraxCryptoMeta - N/A
        // 12: BalancerSingleSwap
        // 13: SushiSwap
        // 14: GMXSwap
        
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
            } else if (_poolType == 8) {
                _amount = _swapCurveBase3Pool(_tokenIn, _tokenOut, _amount, _poolAddress);
            } else if (_poolType == 9) {
                _amount = _swapCurveSBTCPool(_tokenIn, _tokenOut, _amount, _poolAddress);
            } else if (_poolType == 10) {
                _amount = _swapCurve4Pool(_tokenIn, _tokenOut, _amount, _poolAddress);
            } else if (_poolType == 12) {
                _amount = _swapBalancerPoolSingle(_tokenIn, _tokenOut, _amount, _poolAddress);
            } else if (_poolType == 13) {
                _amount = _swapSushiPool(_tokenIn, _tokenOut, _amount);
            } else if (_poolType == 14) {
                _amount = _swapGMX(_tokenIn, _tokenOut, _amount);
            } else {
                revert UnsupportedPoolType();
            }
        }
        
        if (_toToken == ETH) {
            payable(msg.sender).sendValue(_amount);
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
        
        payable(_recipient).sendValue(address(this).balance);

        emit RescueETH(_recipient);
    }

    /********************************** Internal Functions **********************************/

    function _swapGMX(address _fromToken, address _toToken, uint256 _amount) internal returns (uint256) {

        bool _toETH = false;
        if (_fromToken == ETH) {
            _wrapETH(_amount);
            _fromToken = WETH;
        } else if (_toToken == ETH) {
            _toToken = WETH;
            _toETH = true;
        }

        address _router = GMX_ROUTER;
        _approve(_fromToken, _router, _amount);

        address[] memory _path = new address[](2);
        _path[0] = _fromToken;
        _path[1] = _toToken; 

        uint256 _before = IERC20(_toToken).balanceOf(address(this));
        IGMXRouter(_router).swap(_path, _amount, 0, address(this));
        _amount = IERC20(_toToken).balanceOf(address(this)) - _before;

        if (_toETH) {
            _unwrapETH(_amount);
        }
        
        return _amount;
    }

    function _swapUniV3(address _fromToken, address _toToken, uint256 _amount, address _poolAddress) internal returns (uint256) {
        
        bool _toETH = false;
        if (_fromToken == ETH) {
            _wrapETH(_amount);
            _fromToken = WETH;
        } else if (_toToken == ETH) {
            _toToken = WETH;
            _toETH = true;
        }
        
        address _router = UNIV3_ROUTER;
        _approve(_fromToken, _router, _amount);

        uint24 _fee = IUniswapV3Pool(_poolAddress).fee();
        
        uint256 _before = IERC20(_toToken).balanceOf(address(this));
        IUniswapV3RouterArbi.ExactInputSingleParams memory _params = IUniswapV3RouterArbi.ExactInputSingleParams(
            _fromToken,
            _toToken,
            _fee, 
            address(this), 
            _amount,
            0,
            0
        );

        IUniswapV3RouterArbi(_router).exactInputSingle(_params);
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
            payable(address(_pool)).functionCallWithValue(abi.encodeWithSignature("exchange(address,address,uint256,uint256)", _from, _to, _amount, 0), _amount);
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
            payable(address(_pool)).functionCallWithValue(abi.encodeWithSignature("exchange(address,address,uint256,uint256)", _from, _to, _amount, 0), _amount);
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

    // SushiPool
    function _swapSushiPool(address _fromToken, address _toToken, uint256 _amount) internal returns (uint256) {
        
        bool _toETH = false;
        if (_fromToken == ETH) {
            _wrapETH(_amount);
            _fromToken = WETH;
        } else if (_toToken == ETH) {
            _toToken = WETH;
            _toETH = true;
        }
        
        address _router = SUSHI_ARB_ROUTER;
        _approve(_fromToken, _router, _amount);

        address[] memory path = new address[](2);
        path[0] = _fromToken;
        path[1] = _toToken;

        uint256 _before = IERC20(_toToken).balanceOf(address(this));
        IUniswapV2Router(_router).swapExactTokensForTokens(_amount, 0, path, address(this), block.timestamp);
        _amount = IERC20(_toToken).balanceOf(address(this)) - _before;

        if (_toETH) {
            _unwrapETH(_amount);
        }

        return _amount;
    }

    function _wrapETH(uint256 _amount) internal {
        payable(WETH).functionCallWithValue(abi.encodeWithSignature("deposit()"), _amount);
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