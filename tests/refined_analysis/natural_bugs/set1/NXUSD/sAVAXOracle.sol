// SPDX-License-Identifier: None
pragma solidity 0.6.12;
import "@boringcrypto/boring-solidity/contracts/libraries/BoringMath.sol";
import "../interfaces/IOracle.sol";

// Chainlink Aggregator

interface IAggregator {
    function latestAnswer() external view returns (int256 answer);
}

interface IStakedAvax {
    // The total amount of AVAX controlled by the contract
    function totalPooledAvax() external view returns (uint256 total);
    // The total number of sAVAX shares
    function totalShares() external view returns (uint256 total);
}

contract sAVAXOracle is IOracle {
    using BoringMath for uint256; // Keep everything in uint256

    IAggregator public constant aggregatorProxy = IAggregator(0x0A77230d17318075983913bC2145DB16C7366156);
    IStakedAvax public constant stakedAvax = IStakedAvax(0x2b2C81e08f1Af8835a78Bb2A90AE924ACE0eA4bE);

    // Calculates the latest exchange rate
    // Uses both divide and multiply only for tokens not supported directly by Chainlink, for example MKR/USD
    function _get() internal view returns (uint256) {
        uint256 sAvaxPrice =  uint256(stakedAvax.totalPooledAvax()) * uint256(aggregatorProxy.latestAnswer()) / uint256(stakedAvax.totalShares()) ;

        return 1e26 / sAvaxPrice;
    }

    // Get the latest exchange rate
    /// @inheritdoc IOracle
    function get(bytes calldata) public override returns (bool, uint256) {
        return (true, _get());
    }

    // Check the last exchange rate without any state changes
    /// @inheritdoc IOracle
    function peek(bytes calldata ) public view override returns (bool, uint256) {
        return (true, _get());
    }

    // Check the current spot exchange rate without any state changes
    /// @inheritdoc IOracle
    function peekSpot(bytes calldata data) external view override returns (uint256 rate) {
        (, rate) = peek(data);
    }

    /// @inheritdoc IOracle
    function name(bytes calldata) public view override returns (string memory) {
        return "sAVAX Chainlink";
    }

    /// @inheritdoc IOracle
    function symbol(bytes calldata) public view override returns (string memory) {
        return "sAVAX/USD";
    }
}
