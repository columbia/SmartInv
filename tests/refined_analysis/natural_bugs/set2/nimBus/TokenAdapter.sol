// SPDX-License-Identifier: MIT

pragma solidity 0.5.17;
pragma experimental ABIEncoderV2;

struct TokenMetadata {
    address token;
    string name;
    string symbol;
    uint8 decimals;
}

struct Component {
    address token;
    string tokenType;  // "ERC20" by default
    uint rate;  // price per full share (1e18)
}

interface IERC20 {
    function approve(address, uint256) external returns (bool);

    function transfer(address, uint256) external returns (bool);

    function transferFrom(
        address,
        address,
        uint256
    ) external returns (bool);

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address) external view returns (uint256);

    function allowance(address, address) external view returns (uint256);
}

interface TokenAdapter {
    function getMetadata(address token) external view returns (TokenMetadata memory);
    function getComponents(address token) external view returns (Component[] memory);
}

interface IPair {
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
}

abstract contract ProtocolAdapter {
    function getBalance(address token, address account) public virtual returns (int256);
}

contract ERC20ProtocolAdapter is ProtocolAdapter {
    
    IPair public pair;
    IERC20 public nbu; // 0xa4d872235dde5694af92a1d0df20d723e8e9e5fc
    IERC20 public usdt;

    string public constant adapterType = "Asset";
    string public constant tokenType = "ERC20";
    
    constructor(address pairAddress) {
        pair = IPair(pairAddress); // 0x7496Bfbdf1B26eFf11B9311900Ab5cC0FEe4c16C gnbu/wbnb
    }

    function getMetadata(address token) external view returns (TokenMetadata memory) {
        return TokenMetadata({
            token: token,
            name: IERC20(token).name(),
            symbol: IERC20(token).symbol(),
            decimals: IERC20(token).decimals()
        });
    }
    
    function getComponents(address token) external view returns (Component[] memory) {
        
        (uint256 reserve0,uint256 reserve1,) = pair.getReserves();
        
        uint rate = ((reserve0 * 10 ** 30) / (reserve1* 10 ** 18)) * 10 ** 18;
        
        Component[] memory components = new Component[](1);
        
        components[0] = Component({
            token: token,
            tokenType: "ERC20",
            rate: rate
        });
        
        return components;
    }

    function getBalance(address token, address account) public view override returns (int256) {
        return int256(IERC20(token).balanceOf(account));
    }
    
}









