pragma solidity ^0.6.7;

abstract contract DSValueLike {
    function getResultWithValidity() virtual external view returns (uint256, bool);
}

contract DSM {
    // --- Auth ---
    mapping (address => uint) public authorizedAccounts;
    /**
    * @notice Add auth to an account
    * @param account Account to add auth to
    */
    function addAuthorization(address account) external isAuthorized {
        authorizedAccounts[account] = 1;
        emit AddAuthorization(account);
    }
    /**
    * @notice Remove auth from an account
    * @param account Account to remove auth from
    */
    function removeAuthorization(address account) external isAuthorized {
        authorizedAccounts[account] = 0;
        emit RemoveAuthorization(account);
    }
    /**
    * @notice Checks whether msg.sender can call an authed function
    **/
    modifier isAuthorized {
        require(authorizedAccounts[msg.sender] == 1, "DSM/account-not-authorized");
        _;
    }

    // --- Stop ---
    uint256 public stopped;
    modifier stoppable { require(stopped == 0, "DSM/is-stopped"); _; }

    // --- Math ---
    function add(uint64 x, uint64 y) internal pure returns (uint64 z) {
        z = x + y;
        require(z >= x);
    }

    address public priceSource;
    uint16  public updateDelay = ONE_HOUR;      // [seconds]
    uint64  public lastUpdateTime;              // [timestamp]
    uint256 public newPriceDeviation;           // [wad]

    uint16  constant ONE_HOUR = uint16(3600);   // [seconds]
    uint256 public constant WAD = 10 ** 18;

    struct Feed {
        uint128 value;
        uint128 isValid;
    }

    Feed currentFeed;
    Feed nextFeed;

    // --- Events ---
    event AddAuthorization(address account);
    event RemoveAuthorization(address account);
    event Start();
    event Stop();
    event ChangePriceSource(address priceSource);
    event ChangeDeviation(uint deviation);
    event ChangeDelay(uint16 delay);
    event RestartValue();
    event UpdateResult(uint256 newMedian, uint256 lastUpdateTime);

    constructor (address priceSource_, uint256 deviation) public {
        require(both(deviation > 0, deviation < WAD), "DSM/invalid-deviation");
        authorizedAccounts[msg.sender] = 1;
        priceSource = priceSource_;
        newPriceDeviation = deviation;
        if (priceSource != address(0)) {
          (uint256 priceFeedValue, bool hasValidValue) = getPriceSourceUpdate();
          if (hasValidValue) {
            nextFeed = Feed(uint128(uint(priceFeedValue)), 1);
            currentFeed = nextFeed;
            lastUpdateTime = latestUpdateTime(currentTime());
            emit UpdateResult(uint(currentFeed.value), lastUpdateTime);
          }
        }
        emit AddAuthorization(msg.sender);
        emit ChangePriceSource(priceSource);
        emit ChangeDeviation(deviation);
    }

    // --- Boolean Logic ---
    function both(bool x, bool y) internal pure returns (bool z) {
        assembly{ z := and(x, y)}
    }

    // --- Math ---
    function subtract(uint x, uint y) public pure returns (uint z) {
        z = x - y;
        require(z <= x);
    }
    function multiply(uint x, uint y) public pure returns (uint z) {
        require(y == 0 || (z = x * y) / y == x);
    }
    function wmultiply(uint x, uint y) public pure returns (uint z) {
        z = multiply(x, y) / WAD;
    }

    // --- Administration ---
    function stop() external isAuthorized {
        stopped = 1;
        emit Stop();
    }
    function start() external isAuthorized {
        stopped = 0;
        emit Start();
    }

    function changePriceSource(address priceSource_) external isAuthorized {
        priceSource = priceSource_;
        emit ChangePriceSource(priceSource);
    }

    // --- Utils ---
    function currentTime() internal view returns (uint) {
        return block.timestamp;
    }

    function latestUpdateTime(uint timestamp) internal view returns (uint64) {
        require(updateDelay != 0, "DSM/update-delay-is-zero");
        return uint64(timestamp - (timestamp % updateDelay));
    }

    function changeNextPriceDeviation(uint deviation) external isAuthorized {
        require(both(deviation > 0, deviation < WAD), "DSM/invalid-deviation");
        newPriceDeviation = deviation;
        emit ChangeDeviation(deviation);
    }

    function changeDelay(uint16 delay) external isAuthorized {
        require(delay > 0, "DSM/delay-is-zero");
        updateDelay = delay;
        emit ChangeDelay(updateDelay);
    }

    function restartValue() external isAuthorized {
        currentFeed = nextFeed = Feed(0, 0);
        stopped = 1;
        emit RestartValue();
    }

    function passedDelay() public view returns (bool ok) {
        return currentTime() >= add(lastUpdateTime, updateDelay);
    }

    function updateResult() external stoppable {
        require(passedDelay(), "DSM/not-passed");
        (uint256 priceFeedValue, bool hasValidValue) = getPriceSourceUpdate();
        if (hasValidValue) {
            currentFeed.isValid = nextFeed.isValid;
            currentFeed.value   = getNextBoundedPrice();
            nextFeed            = Feed(uint128(priceFeedValue), 1);
            lastUpdateTime      = latestUpdateTime(currentTime());
            emit UpdateResult(uint(currentFeed.value), lastUpdateTime);
        }
    }

    // --- Getters ---
    function getPriceSourceUpdate() internal view returns (uint256, bool) {
        try DSValueLike(priceSource).getResultWithValidity() returns (uint256 priceFeedValue, bool hasValidValue) {
          return (priceFeedValue, hasValidValue);
        }
        catch(bytes memory) {
          return (0, false);
        }
    }

    function getNextBoundedPrice() public view returns (uint128 boundedPrice) {
        boundedPrice = nextFeed.value;
        if (currentFeed.value == 0) return boundedPrice;

        uint128 lowerBound = uint128(wmultiply(uint(currentFeed.value), newPriceDeviation));
        uint128 upperBound = uint128(wmultiply(uint(currentFeed.value), subtract(multiply(uint(2), WAD), newPriceDeviation)));

        if (nextFeed.value < lowerBound) {
          boundedPrice = lowerBound;
        } else if (nextFeed.value > upperBound) {
          boundedPrice = upperBound;
        }
    }

    function getNextPriceLowerBound() public view returns (uint128) {
        return uint128(wmultiply(uint(currentFeed.value), newPriceDeviation));
    }

    function getNextPriceUpperBound() public view returns (uint128) {
        return uint128(wmultiply(uint(currentFeed.value), subtract(multiply(uint(2), WAD), newPriceDeviation)));
    }

    function getResultWithValidity() external view returns (uint256, bool) {
        return (uint(currentFeed.value), currentFeed.isValid == 1);
    }

    function getNextResultWithValidity() external view returns (uint256, bool) {
        return (nextFeed.value, nextFeed.isValid == 1);
    }

    function read() external view returns (uint256) {
        require(currentFeed.isValid == 1, "DSM/no-current-value");
        return currentFeed.value;
    }
}