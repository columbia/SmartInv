pragma solidity ^0.5.0;

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract Context {
    constructor () internal { }

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this;
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface ISmartexOracle {
  function currentETHPrice() external view returns (uint256);
  function lastETHPriceUpdate() external view returns (uint256);

  function currentTokenPrice() external view returns (uint256);
  function lastTokenPriceUpdate() external view returns (uint256);

  function setETHPrice(uint256 price) external;
  function updateTokenPrice() external;

  event ETHPriceUpdated(uint256 price, uint256 timestamp);
  event TokenPriceUpdated(uint256 price, uint256 timestamp);
}

contract SmartexOracle is ISmartexOracle, Ownable {
  using SafeMath for uint256;

  mapping (address => bool) public authorizedCallers;

  uint256 constant private TOKEN_PRICE_UPDATE_PERIOD = 7 days;

  uint256 private _currentTokenPrice;
  uint256 private _lastTokenPriceUpdate;

  uint256 private _currentETHPrice;
  uint256 private _lastETHPriceUpdate;

  modifier onlyAuthorizedCaller() {
    require(_msgSender() == owner() || authorizedCallers[_msgSender()], "SmartexOracle: caller is not authorized");
    _;
  }

  constructor() public {
    _currentTokenPrice = 10 ** 8;
    _lastTokenPriceUpdate = now;
  }

  function currentETHPrice() public view returns (uint256) {
    return _currentETHPrice;
  }

  function currentTokenPrice() public view returns (uint256) {
    return _currentTokenPrice;
  }

  function lastETHPriceUpdate() public view returns (uint256) {
    return _lastETHPriceUpdate;
  }

  function lastTokenPriceUpdate() public view returns (uint256) {
    return _lastTokenPriceUpdate;
  }

  function setAuthorizedCaller(address caller, bool allowed) public onlyOwner {
    authorizedCallers[caller] = allowed;
  }

  function setETHPrice(uint256 price) external onlyAuthorizedCaller {
    require(price > 0, "Price cannot be 0");

    _lastETHPriceUpdate = now;
    _currentETHPrice = price;

    emit ETHPriceUpdated(_currentETHPrice, _lastETHPriceUpdate);
  }

  function updateTokenPrice() external onlyAuthorizedCaller {
    require(_lastTokenPriceUpdate + TOKEN_PRICE_UPDATE_PERIOD <= now, "Token price can be changed once within a period");

    _lastTokenPriceUpdate = now;

    _currentTokenPrice = _currentTokenPrice.mul(120).div(100);

    emit TokenPriceUpdated(_currentTokenPrice, _lastTokenPriceUpdate);
  }
}