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
              
//  _____                 _____                 _   _             
// |     |_ _ ___ _ _ ___|     |___ ___ ___ ___| |_|_|___ ___ ___ 
// |   --| | |  _| | | -_|  |  | . | -_|  _| .'|  _| | . |   |_ -|
// |_____|___|_|  \_/|___|_____|  _|___|_| |__,|_| |_|___|_|_|___|
//                             |_|                                

// Github - https://github.com/FortressFinance

import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

import "src/shared/interfaces/IWETH.sol";
import "src/shared/interfaces/ICurvePool.sol";
import "src/shared/interfaces/ICurve3Pool.sol";
import "src/shared/interfaces/ICurvesUSD4Pool.sol";
import "src/shared/interfaces/ICurveETHPool.sol";
import "src/shared/interfaces/ICurveCryptoETHV2Pool.sol";
import "src/shared/interfaces/ICurveCRVMeta.sol";
import "src/shared/interfaces/ICurveFraxMeta.sol";
import "src/shared/interfaces/ICurveBase3Pool.sol";
import "src/shared/interfaces/ICurveFraxCryptoMeta.sol";
import "src/shared/interfaces/ICurveCryptoV2Pool.sol";
import "src/shared/interfaces/ICurveMetaRegistry.sol";

contract CurveOperations {

    using SafeERC20 for IERC20;
    
    /// @notice The address of WETH token.
    address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    /// @notice The address representing ETH in Curve V1.
    address private constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    /// @notice The address of Curve Base Pool (https://curve.fi/3pool).
    address internal constant CURVE_BP = 0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7;
    /// @notice The address of Curve's Frax Base Pool (https://curve.fi/fraxusdc).
    address internal constant FRAX_BP = 0xDcEF968d416a41Cdac0ED8702fAC8128A64241A2;
    /// @notice The address of crvFRAX LP token (Frax BP).
    address internal constant CRV_FRAX = 0x3175Df0976dFA876431C2E9eE6Bc45b65d3473CC;
    /// @notice The address of 3CRV LP token (Curve BP).
    address internal constant TRI_CRV = 0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490;
    
    /// @notice The address of Curve MetaRegistry.
    ICurveMetaRegistry internal immutable metaRegistry = ICurveMetaRegistry(0xF98B45FA17DE75FB1aD0e7aFD971b0ca00e379fC);
    
    // The type of the pool:
    // 0 - 3Pool
    // 1 - PlainPool
    // 2 - CryptoV2Pool
    // 3 - CrvMetaPool
    // 4 - FraxMetaPool
    // 5 - ETHPool
    // 6 - ETHV2Pool
    // 7 - Base3Pool
    // 8 - FraxCryptoMetaPool
    // 9 - sUSD 4Pool
    function _addLiquidity(address _poolAddress, uint256 _poolType, address _token, uint256 _amount) internal returns (uint256) {
        address _lpToken = metaRegistry.get_lp_token(_poolAddress);
        uint256 _before = IERC20(_lpToken).balanceOf(address(this));
        if (_poolType == 0) {
            _addLiquidity3AssetPool(_poolAddress, _token, _amount);
        } else if (_poolType == 1 || _poolType == 2) {
            _addLiquidity2AssetPool(_poolAddress, _token, _amount);
        } else if (_poolType == 3) {
            _addLiquidityCrvMetaPool(_poolAddress, _token, _amount);
        } else if (_poolType == 4) {
            _addLiquidityFraxMetaPool(_poolAddress, _token, _amount);
        } else if (_poolType == 5) {
            _addLiquidityETHPool(_poolAddress, _token, _amount);
        } else if (_poolType == 6) {
            _addLiquidityETHV2Pool(_poolAddress, _token, _amount);
        } else if (_poolType == 7) {
            _addLiquidityCurveBase3Pool(_poolAddress, _token, _amount);
        } else if (_poolType == 8) {
            _addLiquidityFraxCryptoMetaPool(_poolAddress, _token, _amount);
        } else if (_poolType == 9) {
            _addLiquiditysUSD4Pool(_poolAddress, _token, _amount);
        } else {
            revert InvalidPoolType();
        }
        return (IERC20(_lpToken).balanceOf(address(this)) - _before);
    }

    // ICurvesUSD4Pool
    function _addLiquiditysUSD4Pool(address _poolAddress, address _token, uint256 _amount) internal {
        ICurvesUSD4Pool _pool = ICurvesUSD4Pool(_poolAddress);

        _approveOperations(_token, _poolAddress, _amount);

        if (_token == _pool.coins(0)) {
            _pool.add_liquidity([_amount, 0, 0, 0], 0);
        } else if (_token == _pool.coins(1)) {
            _pool.add_liquidity([0, _amount, 0, 0], 0);
        } else if (_token == _pool.coins(2)) {
            _pool.add_liquidity([0, 0, _amount, 0], 0);
        } else if (_token == _pool.coins(3)) {
            _pool.add_liquidity([0, 0, 0, _amount], 0);
        } else {
            revert InvalidToken();
        }
    }

    // ICurveBase3Pool
    function _addLiquidityCurveBase3Pool(address _poolAddress, address _token, uint256 _amount) internal {
        ICurveBase3Pool _pool = ICurveBase3Pool(_poolAddress);

        _approveOperations(_token, _poolAddress, _amount);
        
        if (_token == _pool.coins(0)) {
            _pool.add_liquidity([_amount, 0, 0], 0);
        } else if (_token == _pool.coins(1)) {
            _pool.add_liquidity([0, _amount, 0], 0);
        } else if (_token == _pool.coins(2)) {
            _pool.add_liquidity([0, 0, _amount], 0);
        } else {
            revert InvalidToken();
        }
    }

    // ICurve3Pool
    // ICurveSBTCPool
    function _addLiquidity3AssetPool(address _poolAddress, address _token, uint256 _amount) internal {
        ICurve3Pool _pool = ICurve3Pool(_poolAddress);

        if (_token == ETH) {
            _wrapETH(_amount);
            _token = WETH;
        }
        _approveOperations(_token, _poolAddress, _amount);

        if (_token == _pool.coins(0)) {  
            _pool.add_liquidity([_amount, 0, 0], 0);
        } else if (_token == _pool.coins(1)) {
            _pool.add_liquidity([0, _amount, 0], 0);
        } else if (_token == _pool.coins(2)) {
            _pool.add_liquidity([0, 0, _amount], 0);
        } else {
            revert InvalidToken();
        }
    }

    // ICurveCryptoV2Pool
    // ICurvePlainPool
    function _addLiquidity2AssetPool(address _poolAddress, address _token, uint256 _amount) internal {
        ICurvePool _pool = ICurvePool(_poolAddress);
        
        _approveOperations(_token, _poolAddress, _amount);
        if (_token == _pool.coins(0)) {
            _pool.add_liquidity([_amount, 0], 0);
        } else if (_token == _pool.coins(1)) {
            _pool.add_liquidity([0, _amount], 0);
        } else {
            revert InvalidToken();
        }
    }

    // ICurveCRVMeta - CurveBP
    function _addLiquidityCrvMetaPool(address _poolAddress, address _token, uint256 _amount) internal {
        ICurveCRVMeta _pool = ICurveCRVMeta(_poolAddress);
         
        if (_token == _pool.coins(0)) {
            _approveOperations(_token, _poolAddress, _amount);
            _pool.add_liquidity([_amount, 0], 0);
        } else {
            _addLiquidityCurveBase3Pool(CURVE_BP, _token, _amount);
            _amount = IERC20(TRI_CRV).balanceOf(address(this));
            _approveOperations(TRI_CRV, _poolAddress, _amount);
            _pool.add_liquidity([0, _amount], 0);
        }
    }

    // ICurveFraxMeta - FraxBP
    function _addLiquidityFraxMetaPool(address _poolAddress, address _token, uint256 _amount) internal {
        ICurveFraxMeta _pool = ICurveFraxMeta(_poolAddress);
        
        if (_token == _pool.coins(0)) {
            _approveOperations(_token, _poolAddress, _amount);
            _pool.add_liquidity([_amount, 0], 0);
        } else {
            _addLiquidity2AssetPool(FRAX_BP, _token, _amount);
            _amount = IERC20(CRV_FRAX).balanceOf(address(this));
            _approveOperations(CRV_FRAX, _poolAddress, _amount);
            _pool.add_liquidity([0, _amount], 0);
        }
    }

    // ICurveFraxCryptoMeta - FraxBP/Crypto
    function _addLiquidityFraxCryptoMetaPool(address _poolAddress, address _token, uint256 _amount) internal {
        ICurveFraxCryptoMeta _pool = ICurveFraxCryptoMeta(_poolAddress);
        
        if (_token == _pool.coins(0)) {
            _approveOperations(_token, _poolAddress, _amount);
            _pool.add_liquidity([_amount, 0], 0);
        } else {
            _addLiquidity2AssetPool(FRAX_BP, _token, _amount);
            _amount = IERC20(CRV_FRAX).balanceOf(address(this));
            _approveOperations(CRV_FRAX, _poolAddress, _amount);
            _pool.add_liquidity([0, _amount], 0);
        }
    }

    // ICurveETHPool
    function _addLiquidityETHPool(address _poolAddress, address _token, uint256 _amount) internal {
        ICurveETHPool _pool = ICurveETHPool(_poolAddress);

        if (_pool.coins(0) == _token) {
            _pool.add_liquidity{ value: _amount }([_amount, 0], 0);
        } else if (_pool.coins(1) == _token) {
            _approveOperations(_token, _poolAddress, _amount);
            _pool.add_liquidity([0, _amount], 0);
        } else {
            revert InvalidToken();
        }
    }

    // ICurveCryptoETHV2Pool
    function _addLiquidityETHV2Pool(address _poolAddress, address _token, uint256 _amount) internal {
        ICurveCryptoETHV2Pool _pool = ICurveCryptoETHV2Pool(_poolAddress);

        if (_token == ETH) {
            _pool.add_liquidity{ value: _amount }([_amount, 0], 0, true);
        } else if (_token == _pool.coins(0)) {
            _approveOperations(_token, _poolAddress, _amount);
            _pool.add_liquidity([_amount, 0], 0, false);
        } else if (_token == _pool.coins(1)) {
            _approveOperations(_token, _poolAddress, _amount);
            _pool.add_liquidity([0, _amount], 0, false);
        } else {
            revert InvalidToken();
        }
    }

    // The type of the pool:
    // 0 - 3Pool
    // 1 - PlainPool
    // 2 - CryptoV2Pool
    // 3 - CrvMetaPool
    // 4 - FraxMetaPool
    // 5 - ETHPool
    // 6 - ETHV2Pool
    // 7 - Base3Pool
    // 8 - FraxCryptoMetaPool
    // 9 - sUSD 4Pool
    function _removeLiquidity(address _poolAddress, uint256 _poolType, address _token, uint256 _amount) internal returns (uint256) {
        uint256 _before;
        if (_token == ETH) {
            _before = address(this).balance;
        } else {
            _before = IERC20(_token).balanceOf(address(this));
        }
        
        if (_poolType == 0) {
            _removeLiquidity3AssetPool(_poolAddress, _token, _amount);
        } else if (_poolType == 1 || _poolType == 5) {
            _removeLiquidity2AssetPool(_poolAddress, _token, _amount);
        } else if (_poolType == 2) {
            _removeLiquidityCryptoV2Pool(_poolAddress, _token, _amount);
        } else if (_poolType == 3) {
            _removeLiquidityCrvMetaPool(_poolAddress, _token, _amount);
        } else if (_poolType == 4) {
            _removeLiquidityFraxMetaPool(_poolAddress, _token, _amount);
        } else if (_poolType == 6) {
            _removeLiquidityETHV2Pool(_poolAddress, _token, _amount);
        } else if (_poolType == 7) {
            _removeLiquidityBase3Pool(_poolAddress, _token, _amount);
        } else if (_poolType == 8) {
            _removeLiquidityFraxMetaCryptoPool(_poolAddress, _token, _amount);
        } else if (_poolType == 9) {
            _removeLiquiditysUSD4Pool(_poolAddress, _token, _amount);
        } else {
            revert InvalidPoolType();
        }

        if (_token == ETH) {
            return address(this).balance - _before;
        } else {
            return IERC20(_token).balanceOf(address(this)) - _before;
        }
    }

    // ICurvesUSD4Pool
    function _removeLiquiditysUSD4Pool(address _poolAddress, address _token, uint256 _amount) internal {
        ICurvesUSD4Pool _poolWrapper = ICurvesUSD4Pool(address(0xFCBa3E75865d2d561BE8D220616520c171F12851));
        ICurvesUSD4Pool _pool = ICurvesUSD4Pool(_poolAddress);

        _approveOperations(address(0xC25a3A3b969415c80451098fa907EC722572917F), address(_poolWrapper), _amount);
        
        if (_token == _pool.coins(0)) {
            _poolWrapper.remove_liquidity_one_coin(_amount, 0, 0);
        } else if (_token == _pool.coins(1)) {
            _poolWrapper.remove_liquidity_one_coin(_amount, 1, 0);
        } else if (_token == _pool.coins(2)) {
            _poolWrapper.remove_liquidity_one_coin(_amount, 2, 0);
        } else if (_token == _pool.coins(3)) {
            _poolWrapper.remove_liquidity_one_coin(_amount, 3, 0);
        } else {
            revert InvalidToken();
        }
    }

    // ICurve3Pool
    function _removeLiquidity3AssetPool(address _poolAddress, address _token, uint256 _amount) internal {
        ICurve3Pool _pool = ICurve3Pool(_poolAddress);
        
        if (_token == ETH) {
            _token = WETH;
        }

        uint256 _before = IERC20(_token).balanceOf(address(this));
        if (_token == _pool.coins(0)) {
             _pool.remove_liquidity_one_coin(_amount, 0, 0);
        } else if (_token == _pool.coins(1)) {
            _pool.remove_liquidity_one_coin(_amount, 1, 0);
        } else if (_token == _pool.coins(2)) {
            _pool.remove_liquidity_one_coin(_amount, 2, 0);
        } else {
            revert InvalidToken();
        }

        if (_token == WETH) {
            _unwrapETH(IERC20(_token).balanceOf(address(this)) - _before);
        }
    }

    // ICurveBase3Pool
    // ICurveSBTCPool
    function _removeLiquidityBase3Pool(address _poolAddress, address _token, uint256 _amount) internal {
        ICurveBase3Pool _pool = ICurveBase3Pool(_poolAddress);

        if (_token == _pool.coins(0)) {
            _pool.remove_liquidity_one_coin(_amount, 0, 0);
        } else if (_token == _pool.coins(1)) {
            _pool.remove_liquidity_one_coin(_amount, 1, 0);
        } else if (_token == _pool.coins(2)) {
            _pool.remove_liquidity_one_coin(_amount, 2, 0);
        } else {
            revert InvalidToken();
        }
    }

    // ICurveETHPool
    // ICurvePlainPool
    function _removeLiquidity2AssetPool(address _poolAddress, address _token, uint256 _amount) internal {
        ICurvePool _pool = ICurvePool(_poolAddress);

        if (_token == _pool.coins(0)) {
            _pool.remove_liquidity_one_coin(_amount, 0, 0);
        } else if (_token == _pool.coins(1)) {
            _pool.remove_liquidity_one_coin(_amount, 1, 0);
        } else {
            revert InvalidToken();
        }
    }

    // ICurveCryptoV2Pool
    function _removeLiquidityCryptoV2Pool(address _poolAddress, address _token, uint256 _amount) internal {
        ICurveCryptoV2Pool _pool = ICurveCryptoV2Pool(_poolAddress);

        if (_token == _pool.coins(0)) {
            _pool.remove_liquidity_one_coin(_amount, 0, 0);
        } else if (_token == _pool.coins(1)) {
            _pool.remove_liquidity_one_coin(_amount, 1, 0);
        } else {
            revert InvalidToken();
        }
    }

    // ICurveCryptoETHV2Pool
    function _removeLiquidityETHV2Pool(address _poolAddress, address _token, uint256 _amount) internal {
        ICurveCryptoETHV2Pool _pool = ICurveCryptoETHV2Pool(_poolAddress);
        
        if (_token == ETH) {
            _pool.remove_liquidity_one_coin(_amount, 0, 0, true);
        } else if (_token == _pool.coins(0)) {
            _pool.remove_liquidity_one_coin(_amount, 0, 0, false);
        } else if (_token == _pool.coins(1)) {
            _pool.remove_liquidity_one_coin(_amount, 1, 0, false);
        } else {
            revert InvalidToken();
        }
    }

    // ICurveCRVMeta - CurveBP
    function _removeLiquidityCrvMetaPool(address _poolAddress, address _token, uint256 _amount) internal {
        ICurveCRVMeta _pool = ICurveCRVMeta(_poolAddress);
        
        if (_token == _pool.coins(0)) {
            _pool.remove_liquidity_one_coin(_amount, 0, 0);
        } else {
            _amount = _pool.remove_liquidity_one_coin(_amount, 1, 0);
            _removeLiquidityBase3Pool(CURVE_BP, _token, _amount);
        }
    }

    // ICurveFraxMeta - FraxBP/Stable
    function _removeLiquidityFraxMetaPool(address _poolAddress, address _token, uint256 _amount) internal {
        ICurveFraxMeta _pool = ICurveFraxMeta(_poolAddress);
        
        if (_token == _pool.coins(0)) {
            _pool.remove_liquidity_one_coin(_amount, 0, 0);
        } else {
            _amount = _pool.remove_liquidity_one_coin(_amount, 1, 0);
            _removeLiquidity2AssetPool(FRAX_BP, _token, _amount);
        }
    }

    // ICurveFraxCryptoMeta - FraxBP/Crypto
    function _removeLiquidityFraxMetaCryptoPool(address _poolAddress, address _token, uint256 _amount) internal {
        ICurveFraxCryptoMeta _pool = ICurveFraxCryptoMeta(_poolAddress);
        
        if (_token == _pool.coins(0)) {
            _pool.remove_liquidity_one_coin(_amount, 0, 0);
        } else {
            _amount = _pool.remove_liquidity_one_coin(_amount, 1, 0);
            _removeLiquidity2AssetPool(FRAX_BP, _token, _amount);
        }
    }

    function _wrapETH(uint256 _amount) internal {
        IWETH(WETH).deposit{ value: _amount }();
    }

    function _unwrapETH(uint256 _amount) internal {
        IWETH(WETH).withdraw(_amount);
    }

    function _approveOperations(address _token, address _spender, uint256 _amount) internal virtual {
        IERC20(_token).safeApprove(_spender, 0);
        IERC20(_token).safeApprove(_spender, _amount);
    }

    /********************************** Errors **********************************/

    error InvalidToken();
    error InvalidPoolType();
}