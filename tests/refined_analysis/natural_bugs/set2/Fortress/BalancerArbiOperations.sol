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

//  _____     _                     _____                 _   _             
// | __  |___| |___ ___ ___ ___ ___|     |___ ___ ___ ___| |_|_|___ ___ ___ 
// | __ -| .'| | .'|   |  _| -_|  _|  |  | . | -_|  _| .'|  _| | . |   |_ -|
// |_____|__,|_|__,|_|_|___|___|_| |_____|  _|___|_| |__,|_| |_|___|_|_|___|
//                                       |_|                                

// Github - https://github.com/FortressFinance

import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

import "src/shared/fortress-interfaces/IFortressSwap.sol";
import "src/shared/interfaces/IWETH.sol";

import "src/shared/interfaces/IBalancerVault.sol";
import "src/shared/interfaces/IBalancerPool.sol";

contract BalancerArbiOperations {

    using SafeERC20 for IERC20;
    using Address for address payable;
    
    /// @notice The address of the owner
    address public owner;

    /// @notice The mapping of whitelisted addresses, which are Fortress Vaults
    mapping(address => bool) public whitelist;

    /// @notice The address of Balancer vault.
    address internal constant BALANCER_VAULT = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    /// @notice The address representing ETH.
    address private constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    /// @notice The address of WETH.
    address internal constant WETH = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;
        
    /********************************** Constructor **********************************/

    constructor(address _owner) {
        owner = _owner;
    }

    /********************************** Restricted Functions **********************************/

    function updateWhitelist(address _vault, bool _whitelisted) external {
        if (msg.sender != owner) revert OnlyOwner();

        whitelist[_vault] = _whitelisted;
    }

    function updateOwner(address _owner) external {
        if (msg.sender != owner) revert OnlyOwner();

        owner = _owner;
    }

    /********************************** Restricted Functions **********************************/

    function addLiquidity(address _poolAddress, address _asset, uint256 _amount) external returns (uint256 _assets) {
        if (!whitelist[msg.sender]) revert Unauthorized_();
        
        bytes32 _poolId = IBalancerPool(_poolAddress).getPoolId();
        IBalancerVault _vault = IBalancerVault(BALANCER_VAULT);

        (address[] memory _tokens,,) = _vault.getPoolTokens(_poolId);

        uint256 _before = IERC20(_poolAddress).balanceOf(address(this));
        
        if (_asset == ETH) {
            _wrapETH(_amount);
            _asset = WETH;
        }
        IERC20(_asset).safeTransferFrom(msg.sender, address(this), _amount);

        uint256[] memory _amounts = new uint256[](_tokens.length);
        for (uint256 _i = 0; _i < _tokens.length; _i++) {
            if (_tokens[_i] == _asset) {
                _amounts[_i] = _amount;

                uint256[] memory _noBptAmounts = _isComposablePool(_tokens, _poolAddress) ? _dropBptItem(_tokens, _amounts, _poolAddress) : _amounts;
                
                _approveOperations(_tokens[_i], address(_vault), _amount);
                // _approveOperations(_tokens[_i], BALANCER_VAULT, _amount);
                _vault.joinPool(
                    _poolId,
                    address(this), // sender
                    address(this), // recipient
                    IBalancerVault.JoinPoolRequest({
                        assets: _tokens,
                        maxAmountsIn: _amounts,
                        userData: abi.encode(
                            IBalancerVault.JoinKind.EXACT_TOKENS_IN_FOR_BPT_OUT,
                            _noBptAmounts, // amountsIn
                            0 // minimumBPT
                        ),
                        fromInternalBalance: false
                    })
                );
                break;
            }
        }
        _assets = IERC20(_poolAddress).balanceOf(address(this)) - _before;
        IERC20(_poolAddress).safeTransfer(msg.sender, _assets);
        
        return _assets;
    }

    function removeLiquidity(address _poolAddress, address _asset, uint256 _bptAmountIn) external returns (uint256 _underlyingAmount) {
        if (!whitelist[msg.sender]) revert Unauthorized_();
        
        bytes32 _poolId = IBalancerPool(_poolAddress).getPoolId();
        IBalancerVault _vault = IBalancerVault(BALANCER_VAULT);

        (address[] memory _tokens,,) = _vault.getPoolTokens(_poolId);
        uint256 _before = IERC20(_asset).balanceOf(address(this));
        
        IERC20(_poolAddress).safeTransferFrom(msg.sender, address(this), _bptAmountIn);

        uint256[] memory _amounts = new uint256[](_tokens.length);
        for (uint256 _i = 0; _i < _tokens.length; _i++) {
            if (_tokens[_i] == _asset) {
                _vault.exitPool(
                    _poolId,
                    address(this), // sender
                    payable(address(this)), // recipient
                    IBalancerVault.ExitPoolRequest({
                        assets: _tokens,
                        minAmountsOut: _amounts,
                        userData: abi.encode(
                            IBalancerVault.ExitKind.EXACT_BPT_IN_FOR_ONE_TOKEN_OUT,
                            _bptAmountIn, // bptAmountIn
                            _i // enterTokenIndex
                        ),
                        toInternalBalance: false
                    })
                );
                break;
            }
        }
        _underlyingAmount = IERC20(_asset).balanceOf(address(this)) - _before;
        IERC20(_asset).safeTransfer(msg.sender, _underlyingAmount);

        return _underlyingAmount;
    }

    /********************************** Internal Functions **********************************/

    function _isComposablePool(address[] memory _tokens, address _poolAddress) internal pure returns (bool) {
        for(uint256 i = 0; i < _tokens.length; i++) {
            if (_tokens[i] == _poolAddress) {
                return true;
            }
        }
        return false;
    }
    
    function _dropBptItem(address[] memory _tokens, uint256[] memory _amounts, address _poolAddress) internal pure returns (uint256[] memory) {
        uint256[] memory _noBPTAmounts = new uint256[](_tokens.length - 1);
        uint256 _j = 0;
        for(uint256 _i = 0; _i < _tokens.length; _i++) {
            if (_tokens[_i] != _poolAddress) {
                _noBPTAmounts[_j] = _amounts[_i];
                _j++;
            }
        }
        return _noBPTAmounts;
    }

    function _approveOperations(address _token, address _spender, uint256 _amount) internal virtual {
        IERC20(_token).safeApprove(_spender, 0);
        IERC20(_token).safeApprove(_spender, _amount);
    }

    function _wrapETH(uint256 _amount) internal {
        IWETH(WETH).deposit{ value: _amount }();
    }

    // receive() external payable {}

/********************************** Errors **********************************/

    error OnlyOwner();
    error Unauthorized_();

}
