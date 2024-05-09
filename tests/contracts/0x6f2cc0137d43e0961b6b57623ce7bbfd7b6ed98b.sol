// File: contracts/interfaces/IAaveOracle.sol

pragma solidity ^0.5.0;

interface IAaveOracle {
    // TODO rename back to getOracleProphecy
    function getAssetPrice(address _asset) external view returns (uint256);
    function prophecies(address _asset) external view returns (uint64, uint96, uint96);
    function submitProphecy(address _asset, uint96 _sybilProphecy, uint96 _oracleProphecy) external;
    function isSybilWhitelisted(address _sybil) external view returns (bool);
}

// File: contracts/interfaces/IChainlinkAggregator.sol

pragma solidity ^0.5.0;

interface IChainlinkAggregator {
  function latestAnswer() external view returns (int256);
}

// File: contracts/AaveOracle.sol

pragma solidity ^0.5.0;



contract AaveOracle is IAaveOracle {
    struct TimestampedProphecy {
        uint64 timestamp;
        uint96 sybilProphecy;
        uint96 oracleProphecy;
    }

    event ProphecySubmitted(
        address indexed _sybil,
        address indexed _asset,
        uint96 _sybilProphecy,
        uint96 _oracleProphecy
    );

    event SybilWhitelisted(address sybil);

    address constant public USD_ETH_CHAINLINK_AGGREGATOR = address(0x59b826c214aBa7125bFA52970d97736c105Cc375);

    address constant public MOCK_USD = address(0x10F7Fc1F91Ba351f9C629c5947AD69bD03C05b96);

    // Asset => price prophecy
    mapping(address => TimestampedProphecy) public prophecies;

    // Whitelisted sybils allowed to submit prices
    mapping(address => bool) private sybils;

    modifier onlySybil {
        require(isSybilWhitelisted(msg.sender), "INVALID_SYBIL");
        _;
    }

    constructor(address[] memory _sybils) public {
        internalWhitelistSybils(_sybils);
    }

    /// @notice Internal function to whitelist a list of sybils
    /// @param _sybils The addresses of the sybils
    function internalWhitelistSybils(address[] memory _sybils) internal {
        for (uint256 i = 0; i < _sybils.length; i++) {
            sybils[_sybils[i]] = true;
            emit SybilWhitelisted(_sybils[i]);
        }
    }

    /// @notice Submits a new prophecy for an asset
    /// - Only callable by whitelisted sybils
    /// @param _asset The asset address
    /// @param _sybilProphecy The new individual prophecy of the sybil
    /// @param _oracleProphecy The offchain calculated prophecy from all the currently valid ones
    function submitProphecy(address _asset, uint96 _sybilProphecy, uint96 _oracleProphecy) external onlySybil {
        prophecies[_asset] = TimestampedProphecy(uint64(block.timestamp), _sybilProphecy, _oracleProphecy);
        emit ProphecySubmitted(msg.sender, _asset, _sybilProphecy, _oracleProphecy);
    }

    /// @notice Gets the current prophecy for an asset
    /// @param _asset The asset address
    function getAssetPrice(address _asset) external view returns (uint256) {
        if (_asset == address(MOCK_USD)) {
            return getUsdPriceFromChainlink();
        } else {
            return uint256(prophecies[_asset].oracleProphecy);
        }
    }

    /// @notice Gets the data of the current prophecy for an asset
    /// @param _asset The asset address
    function getProphecy(address _asset) external view returns (uint64, uint96, uint96) {
        // For USD/ETH, use the Chainlink aggregator. The latestAnswer() gives price of ETH in USD,
        // as we need price of USD in ETH, needs to be reversed, using 1e18. The mult by 1e8 is needed because
        // the price of ETH in USD is multiplied by 1e8 on Chainlink side
        if (_asset == address(MOCK_USD)) {
            uint256 _price = getUsdPriceFromChainlink();
            return (uint64(block.timestamp), uint96(_price), uint96(_price));
        } else {
            TimestampedProphecy memory _prophecy = prophecies[_asset];
            return (_prophecy.timestamp, _prophecy.sybilProphecy, _prophecy.oracleProphecy);
        }
    }

    /// @notice Return a bool with the whitelisting state of a sybil
    /// @param _sybil The address of the sybil
    function isSybilWhitelisted(address _sybil) public view returns (bool) {
        return sybils[_sybil];
    }

    function getUsdPriceFromChainlink() internal view returns (uint256) {
        return uint256(1e8 * 1e18 / IChainlinkAggregator(USD_ETH_CHAINLINK_AGGREGATOR).latestAnswer());
    }

}