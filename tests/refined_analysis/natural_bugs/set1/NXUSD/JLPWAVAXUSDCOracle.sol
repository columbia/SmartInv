// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;
import "../interfaces/IOracle.sol";

// Chainlink Aggregator

interface IAggregator {
    function latestAnswer() external view returns (int256 answer);
}

interface IJoePair {
    function getReserves() external view returns ( uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast);
    function totalSupply() external view returns (uint256);
}

contract JLPWAVAXUSDCOracle is IOracle {
    IJoePair constant public joePair = IJoePair(0xf4003F4efBE8691B60249E6afbD307aBE7758adb);
    IAggregator constant public AVAX = IAggregator(0x0A77230d17318075983913bC2145DB16C7366156);
    IAggregator constant public USDC = IAggregator(0xF096872672F44d6EBA71458D74fe67F9a77a23B9);

    function _get() internal view returns (uint256) {

        uint256 usdcPrice = uint256(USDC.latestAnswer());
        uint256 avaxPrice = uint256(AVAX.latestAnswer());
        (uint112 wavaxReserve, uint112 usdcReserve, ) = joePair.getReserves();

        uint256 price = (wavaxReserve * avaxPrice + usdcReserve * usdcPrice * 1e12) / uint256(joePair.totalSupply());

        return 1e26 / price;
    }

    // Get the latest exchange rate
    /// @inheritdoc IOracle
    function get(bytes calldata) public view override returns (bool, uint256) {
        return (true, _get());
    }

    // Check the last exchange rate without any state changes
    /// @inheritdoc IOracle
    function peek(bytes calldata) public view override returns (bool, uint256) {
        return (true, _get());
    }

    // Check the current spot exchange rate without any state changes
    /// @inheritdoc IOracle
    function peekSpot(bytes calldata data) external view override returns (uint256 rate) {
        (, rate) = peek(data);
    }

    /// @inheritdoc IOracle
    function name(bytes calldata) public pure override returns (string memory) {
        return "Chainlink WAVAX-USDC JLP";
    }

    /// @inheritdoc IOracle
    function symbol(bytes calldata) public pure override returns (string memory) {
        return "WAVAX-USDC JLP/USD";
    }
}
