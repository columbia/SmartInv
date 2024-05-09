/**
 *Submitted for verification at Etherscan.io on 2019-11-07
*/

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol

pragma solidity ^0.4.24;


/**
 * @title ERC20Basic
 * @dev Simpler version of ERC20 interface
 * See https://github.com/ethereum/EIPs/issues/179
 */
contract ERC20Basic {
  function totalSupply() public view returns (uint256);
  function balanceOf(address _who) public view returns (uint256);
  function transfer(address _to, uint256 _value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol

pragma solidity ^0.4.24;



/**
 * @title ERC20 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 is ERC20Basic {
  function allowance(address _owner, address _spender)
    public view returns (uint256);

  function transferFrom(address _from, address _to, uint256 _value)
    public returns (bool);

  function approve(address _spender, uint256 _value) public returns (bool);
  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}

// File: openzeppelin-solidity/contracts/math/SafeMath.sol

pragma solidity ^0.4.24;


/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (_a == 0) {
      return 0;
    }

    c = _a * _b;
    assert(c / _a == _b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
    // assert(_b > 0); // Solidity automatically throws when dividing by 0
    // uint256 c = _a / _b;
    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
    return _a / _b;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
    assert(_b <= _a);
    return _a - _b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
    c = _a + _b;
    assert(c >= _a);
    return c;
  }
}

// File: contracts/Utils/Ownable.sol

pragma solidity ^0.4.24;

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipRenounced(address indexed previousOwner);
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner, "msg.sender not owner");
    _;
  }

  /**
   * @dev Allows the current owner to relinquish control of the contract.
   * @notice Renouncing to ownership will leave the contract without an owner.
   * It will not be possible to call the functions with the `onlyOwner`
   * modifier anymore.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipRenounced(owner);
    owner = address(0);
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function transferOwnership(address _newOwner) public onlyOwner {
    _transferOwnership(_newOwner);
  }

  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function _transferOwnership(address _newOwner) internal {
    require(_newOwner != address(0), "_newOwner == 0");
    emit OwnershipTransferred(owner, _newOwner);
    owner = _newOwner;
  }
}

// File: contracts/Utils/Destructible.sol

pragma solidity ^0.4.24;


/**
 * @title Destructible
 * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
 */
contract Destructible is Ownable {
  /**
   * @dev Transfers the current balance to the owner and terminates the contract.
   */
  function destroy() public onlyOwner {
    selfdestruct(owner);
  }

  function destroyAndSend(address _recipient) public onlyOwner {
    selfdestruct(_recipient);
  }
}

// File: contracts/Interfaces/IBadERC20.sol

pragma solidity ^0.4.24;

/**
 * @title Bad formed ERC20 token interface.
 * @dev The interface of the a bad formed ERC20 token.
 */
interface IBadERC20 {
    function transfer(address to, uint256 value) external;
    function approve(address spender, uint256 value) external;
    function transferFrom(
      address from,
      address to,
      uint256 value
    ) external;

    function totalSupply() external view returns (uint256);

    function balanceOf(
      address who
    ) external view returns (uint256);

    function allowance(
      address owner,
      address spender
    ) external view returns (uint256);

    event Transfer(
      address indexed from,
      address indexed to,
      uint256 value
    );
    event Approval(
      address indexed owner,
      address indexed spender,
      uint256 value
    );
}

// File: contracts/Utils/SafeTransfer.sol

pragma solidity ^0.4.24;


/**
 * @title SafeTransfer
 * @dev Transfer Bad ERC20 tokens
 */
library SafeTransfer {
/**
   * @dev Wrapping the ERC20 transferFrom function to avoid missing returns.
   * @param _tokenAddress The address of bad formed ERC20 token.
   * @param _from Transfer sender.
   * @param _to Transfer receiver.
   * @param _value Amount to be transfered.
   * @return Success of the safeTransferFrom.
   */

  function _safeTransferFrom(
    address _tokenAddress,
    address _from,
    address _to,
    uint256 _value
  )
    internal
    returns (bool result)
  {
    IBadERC20(_tokenAddress).transferFrom(_from, _to, _value);

    assembly {
      switch returndatasize()
      case 0 {                      // This is our BadToken
        result := not(0)            // result is true
      }
      case 32 {                     // This is our GoodToken
        returndatacopy(0, 0, 32)
        result := mload(0)          // result == returndata of external call
      }
      default {                     // This is not an ERC20 token
        revert(0, 0)
      }
    }
  }

  /**
   * @dev Wrapping the ERC20 transfer function to avoid missing returns.
   * @param _tokenAddress The address of bad formed ERC20 token.
   * @param _to Transfer receiver.
   * @param _amount Amount to be transfered.
   * @return Success of the safeTransfer.
   */
  function _safeTransfer(
    address _tokenAddress,
    address _to,
    uint _amount
  )
    internal
    returns (bool result)
  {
    IBadERC20(_tokenAddress).transfer(_to, _amount);

    assembly {
      switch returndatasize()
      case 0 {                      // This is our BadToken
        result := not(0)            // result is true
      }
      case 32 {                     // This is our GoodToken
        returndatacopy(0, 0, 32)
        result := mload(0)          // result == returndata of external call
      }
      default {                     // This is not an ERC20 token
        revert(0, 0)
      }
    }
  }

  function _safeApprove(
    address _token,
    address _spender,
    uint256 _value
  )
  internal
  returns (bool result)
  {
    IBadERC20(_token).approve(_spender, _value);

    assembly {
      switch returndatasize()
      case 0 {                      // This is our BadToken
        result := not(0)            // result is true
      }
      case 32 {                     // This is our GoodToken
        returndatacopy(0, 0, 32)
        result := mload(0)          // result == returndata of external call
      }
      default {                     // This is not an ERC20 token
        revert(0, 0)
      }
    }
  }
}

// File: contracts/Utils/Pausable.sol

pragma solidity ^0.4.24;



/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable is Ownable {
  event Pause();
  event Unpause();

  bool public paused = false;


  /**
   * @dev Modifier to make a function callable only when the contract is not paused.
   */
  modifier whenNotPaused() {
    require(!paused, "The contract is paused");
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is paused.
   */
  modifier whenPaused() {
    require(paused, "The contract is not paused");
    _;
  }

  /**
   * @dev called by the owner to pause, triggers stopped state
   */
  function pause() public onlyOwner whenNotPaused {
    paused = true;
    emit Pause();
  }

  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  function unpause() public onlyOwner whenPaused {
    paused = false;
    emit Unpause();
  }
}

// File: contracts/Interfaces/IErc20Swap.sol

pragma solidity ^0.4.0;

interface IErc20Swap {
    function getRate(address src, address dst, uint256 srcAmount) external view returns(uint expectedRate, uint slippageRate);  // real rate = returned value / 1e18
    function swap(address src, uint srcAmount, address dest, uint maxDestAmount, uint minConversionRate) external payable;
}

// File: contracts/Interfaces/IKyberNetwork.sol

pragma solidity >=0.4.21 <0.6.0;

interface IKyberNetwork {

    function getExpectedRate(address src, address dest, uint srcQty) external view
        returns (uint expectedRate, uint slippageRate);

    function trade(
        address src,
        uint srcAmount,
        address dest,
        address destAddress,
        uint maxDestAmount,
        uint minConversionRate,
        address walletId
    ) external payable returns(uint256);
}

// File: contracts/KyberTokenSwap.sol

pragma solidity ^0.4.24;








/**
 * @title TokenSwap.
 * @author Eidoo SAGL.
 * @dev A swap asset contract. The offerAmount and wantAmount are collected and sent into the contract itself.
 */
contract KyberTokenSwap is Pausable, Destructible, IErc20Swap
{
  using SafeMath for uint;
  using SafeTransfer for ERC20;
  address constant ETHER = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
  uint constant expScale = 1e18;
  uint constant rateDecimals = 18;
  uint constant rateUnit = 10 ** rateDecimals;

  IKyberNetwork public kyberNetwork;

  address public wallet;
  address public kyberFeeWallet;

  uint public spreadDefault;
  mapping (address => mapping (address => uint)) spreadCustom;
  uint constant spreadDecimals = 6;
  uint constant spreadUnit = 10 ** spreadDecimals;

  event LogWithdrawToken(
    address indexed _from,
    address indexed _token,
    uint amount
  );

  event LogTokenSwap(
    address indexed _userAddress,
    address indexed _userSentTokenAddress,
    uint _userSentTokenAmount,
    address indexed _userReceivedTokenAddress,
    uint _userReceivedTokenAmount
  );

  event LogFee(address token, uint amount);

  event UnexpectedIntialBalance(address token, uint amount);

  constructor(
    address _kyberNetwork,
    address _wallet,
    address _kyberFeeWallet,
    uint _spread
  )
    public
  {
    require(_wallet != address(0), "_wallet == address(0)");
    require(_kyberNetwork != address(0), "_kyberNetwork == address(0)");
    require(_spread < spreadUnit, "spread >= spreadUnit");
    wallet = _wallet;
    spreadDefault = _spread;
    kyberNetwork = IKyberNetwork(_kyberNetwork);
    kyberFeeWallet = _kyberFeeWallet;
  }

  function() external payable {
    // can receive ethers from KyberNetwork
  }

  function setWallet(address _wallet) public onlyOwner {
    require(_wallet != address(0), "_wallet == address(0)");
    wallet = _wallet;
  }

  function setKyberFeeWallet(address _wallet) public onlyOwner {
    kyberFeeWallet = _wallet;
  }

  function setSpreadDefault(uint _spread) public onlyOwner {
    require(_spread < spreadUnit, "spread >= spreadUnit");
    spreadDefault = _spread;
  }

  // spread value >= spreadUnit means no fee
  function setSpread(address tokenA, address tokenB, uint spread) public onlyOwner {
    uint value = spread > spreadUnit ? spreadUnit : spread;
    spreadCustom[tokenA][tokenB] = value;
    spreadCustom[tokenB][tokenA] = value;
  }

  function getSpread(address tokenA, address tokenB) public view returns(uint) {
    uint value = spreadCustom[tokenA][tokenB];
    if (value == 0) return spreadDefault;
    if (value >= spreadUnit) return 0;
    else return value;
  }

  /**
   * @dev Withdraw asset.
   * @param _tokenAddress Asset to be withdrawed.
   * @return bool.
   */
  function withdrawToken(address _tokenAddress)
    public
    onlyOwner
  {
    uint tokenBalance;
    if (_tokenAddress == ETHER || _tokenAddress == address(0)) {
      tokenBalance = address(this).balance;
      msg.sender.transfer(tokenBalance);
    } else {
      tokenBalance = ERC20(_tokenAddress).balanceOf(address(this));
      ERC20(_tokenAddress)._safeTransfer(msg.sender, tokenBalance);
    }
    emit LogWithdrawToken(msg.sender, _tokenAddress, tokenBalance);
  }

  /*******************  *******************/
  function getRate(address src, address dest, uint256 srcAmount) external view
    returns(uint expectedRate, uint slippageRate)
  {
    (uint256 kExpected, uint256 kSplippage) = kyberNetwork.getExpectedRate(src, dest, srcAmount);
    uint256 spread = getSpread(src, dest);
    expectedRate = kExpected.mul(spreadUnit - spread).div(spreadUnit);
    slippageRate = kSplippage.mul(spreadUnit - spread).div(spreadUnit);
  }

  function _freeUnexpectedTokens(address token) private {
    uint256 unexpectedBalance = token == ETHER
      ? address(this).balance.sub(msg.value)
      : ERC20(token).balanceOf(address(this));
    if (unexpectedBalance > 0) {
      _transfer(token, wallet, unexpectedBalance);
      emit UnexpectedIntialBalance(token, unexpectedBalance);
    }
  }

  function swap(address src, uint srcAmount, address dest, uint maxDestAmount, uint minConversionRate) public payable {
    require(src != dest, "src == dest");
    require(srcAmount > 0, "srcAmount == 0");

    // empty unexpected initial balances
    _freeUnexpectedTokens(src);
    _freeUnexpectedTokens(dest);

    if (src == ETHER) {
      require(msg.value == srcAmount, "msg.value != srcAmount");
    } else {
      require(
        ERC20(src).allowance(msg.sender, address(this)) >= srcAmount,
        "ERC20 allowance < srcAmount"
      );
      // get user's tokens
      require(
        ERC20(src)._safeTransferFrom(msg.sender, address(this), srcAmount),
        "cannot transfer src token from msg.sender to this"
      );
    }

//    (uint256 expectedRate, ) = kyberNetwork.getExpectedRate(src, dest, srcAmount);
//    require(expectedRate > 0, "expectedRate is 0, pair is not tradable");

    uint256 spread = getSpread(src, dest);

    uint256 destTradedAmount = _callKyberNetworkTrade(src, srcAmount, dest, maxDestAmount, minConversionRate, spread);

    uint256 notTraded = _myBalance(src);
    uint256 srcTradedAmount = srcAmount.sub(notTraded);
    require(srcTradedAmount > 0, "no traded tokens");
    require(
       _myBalance(dest) >= destTradedAmount,
       "No enough dest tokens after trade"
     );
    // pay fee and user
    uint256 toUserAmount = _payFee(dest, destTradedAmount, spread);
    _transfer(dest, msg.sender, toUserAmount);
    // returns not traded tokens if any
    if (notTraded > 0) {
      _transfer(src, msg.sender, notTraded);
    }

    emit LogTokenSwap(
      msg.sender,
      src,
      srcTradedAmount,
      dest,
      toUserAmount
    );
  }

  function _callKyberNetworkTrade(address src, uint srcAmount, address dest, uint maxDestAmount, uint minConversionRate, uint spread) private returns(uint256) {
    // calculate the minConversionRate and maxDestAmount keeping in mind the fee
    uint256 adaptedMinRate = minConversionRate.mul(spreadUnit).div(spreadUnit - spread);
    uint256 adaptedMaxDestAmount = maxDestAmount.mul(spreadUnit).div(spreadUnit - spread);
    if (src == ETHER) {
      return kyberNetwork.trade
        .value(srcAmount)(src, srcAmount, dest, address(this), adaptedMaxDestAmount, adaptedMinRate, kyberFeeWallet);
    } else {
      if (ERC20(src).allowance(address(this), address(kyberNetwork)) > 0) {
        ERC20(src)._safeApprove(address(kyberNetwork), 0);
      }
      ERC20(src)._safeApprove(address(kyberNetwork), srcAmount);
      return kyberNetwork.trade(src, srcAmount, dest, address(this), adaptedMaxDestAmount, adaptedMinRate, kyberFeeWallet);
    }
  }

  function _payFee(address token, uint destTradedAmount, uint spread) private returns(uint256 toUserAmount) {
    uint256 fee = destTradedAmount.mul(spread).div(spreadUnit);
    toUserAmount = destTradedAmount.sub(fee);
    // pay fee
    if (fee > 0) {
      _transfer(token, wallet, fee);
      emit LogFee(token, fee);
    }
  }

  function _myBalance(address token) private view returns(uint256) {
    return token == ETHER
      ? address(this).balance
      : ERC20(token).balanceOf(address(this));
  }

  function _transfer(address token, address recipient, uint256 amount) private {
    if (token == ETHER) {
      recipient.transfer(amount);
    } else {
      require(ERC20(token)._safeTransfer(recipient, amount), "cannot transfer tokens");
    }
  }

}