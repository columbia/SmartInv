pragma solidity ^0.5.3;

/**
 * @title SafeMath
 * @dev Unsigned math operations with safety checks that revert on error
 */
library SafeMath {
    /**
     * @dev Multiplies two unsigned integers, reverts on overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b);

        return c;
    }

    /**
     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Adds two unsigned integers, reverts on overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);

        return c;
    }

    /**
     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
     * reverts when dividing by zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0);
        return a % b;
    }
}

/// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
contract ERC721 {
    // Required methods
    function totalSupply() public view returns (uint256 total);
    function balanceOf(address _owner) public view returns (uint256 balance);
    function ownerOf(uint256 _tokenId) external view returns (address owner);
    function approve(address _to, uint256 _tokenId) external;
    function transfer(address _to, uint256 _tokenId) external;
    function transferFrom(address _from, address _to, uint256 _tokenId) external;

    // Events
    event Transfer(address from, address to, uint256 tokenId);
    event Approval(address owner, address approved, uint256 tokenId);

    // Optional
    // function name() public view returns (string name);
    // function symbol() public view returns (string symbol);
    // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
    // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);

    // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
    function supportsInterface(bytes4 _interfaceID) external view returns (bool);
}

contract KittyCoreInterface is ERC721  {
    uint256 public autoBirthFee;
    address public saleAuction;
    address public siringAuction;
    function breedWithAuto(uint256 _matronId, uint256 _sireId) public payable;
    function createSaleAuction(uint256 _kittyId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration) external;
    function createSiringAuction(uint256 _kittyId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration) external;
    function supportsInterface(bytes4 _interfaceID) external view returns (bool);
}

contract AuctionInterface {
    function cancelAuction(uint256 _tokenId) external;
}

contract Ownable {
  address payable public owner;

  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );

  constructor(address payable _owner) public {
    if(_owner == address(0)) {
      owner = msg.sender;
    } else {
      owner = _owner;
    }
  }

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  function transferOwnership(address payable _newOwner) public onlyOwner {
    _transferOwnership(_newOwner);
  }

  function _transferOwnership(address payable _newOwner) internal {
    require(_newOwner != address(0));
    emit OwnershipTransferred(owner, _newOwner);
    owner = _newOwner;
  }

  function destroy() public onlyOwner {
    selfdestruct(owner);
  }

  function destroyAndSend(address payable _recipient) public onlyOwner {
    selfdestruct(_recipient);
  }
}

contract Pausable is Ownable {
    event Pause();
    event Unpause();

    bool public paused = false;

    constructor(address payable _owner) Ownable(_owner) public {}

    modifier whenNotPaused() {
        require(!paused, "Contract paused");
        _;
    }

    modifier whenPaused() {
        require(paused, "Contract should be paused");
        _;
    }

    function pause() public onlyOwner whenNotPaused {
        paused = true;
        emit Pause();
    }

    function unpause() public onlyOwner whenPaused {
        paused = false;
        emit Unpause();
    }
}

contract CKProxy is Pausable {
  KittyCoreInterface public kittyCore;
  AuctionInterface public saleAuction;
  AuctionInterface public siringAuction;

constructor(address payable _owner, address _kittyCoreAddress) Pausable(_owner) public {
    require(_kittyCoreAddress != address(0));
    kittyCore = KittyCoreInterface(_kittyCoreAddress);
    require(kittyCore.supportsInterface(0x9a20483d));

    saleAuction = AuctionInterface(kittyCore.saleAuction());
    siringAuction = AuctionInterface(kittyCore.siringAuction());
  }

  /**
   * Owner can transfer kitty
   */
  function transferKitty(address _to, uint256 _kittyId) external onlyOwner {
    kittyCore.transfer(_to, _kittyId);
  }

  /**
   * Owner can transfer kitty
   */
  function transferKittyBulk(address _to, uint256[] calldata _kittyIds) external onlyOwner {
    for(uint256 i = 0; i < _kittyIds.length; i++) {
      kittyCore.transfer(_to, _kittyIds[i]);
    }
  }

  /**
   * Owner can transferFrom kitty
   */
  function transferKittyFrom(address _from, address _to, uint256 _kittyId) external onlyOwner {
    kittyCore.transferFrom(_from, _to, _kittyId);
  }

  /**
   * Owner can approve kitty
   */
  function approveKitty(address _to, uint256 _kittyId) external  onlyOwner {
    kittyCore.approve(_to, _kittyId);
  }

  /**
   * Owner can start sales auction for kitty owned by contract
   */
  function createSaleAuction(uint256 _kittyId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration) external onlyOwner {
    kittyCore.createSaleAuction(_kittyId, _startingPrice, _endingPrice, _duration);
  }

  /**
   * Owner can cancel sales auction for kitty owned by contract
   */
  function cancelSaleAuction(uint256 _kittyId) external onlyOwner {
    saleAuction.cancelAuction(_kittyId);
  }

  /**
   * Owner can start siring auction for kitty owned by contract
   */
  function createSiringAuction(uint256 _kittyId, uint256 _startingPrice, uint256 _endingPrice, uint256 _duration) external onlyOwner {
    kittyCore.createSiringAuction(_kittyId, _startingPrice, _endingPrice, _duration);
  }

  /**
   * Owner can cancel siring auction for kitty owned by contract
   */
  function cancelSiringAuction(uint256 _kittyId) external onlyOwner {
    siringAuction.cancelAuction(_kittyId);
  }
}

 /**
 * @title SimpleBreeding
 * @dev Simple breeding contract allows dedicated breeder to breed kitties on behalf of owner, while owner retains control over funds and kitties.
 * Breeder gets reward per each successful breed. Breeder can breed when contract is not paused.
 * Owner should transfer kitties and funds to contact to breeding starts and withdraw afterwards.
 * Breeder can only breed kitties owned by contract and cannot transfer funds or kitties itself.
 */

contract SimpleBreeding is CKProxy {
  address payable public breeder;
  uint256 public breederReward;
  uint256 public originalBreederReward;
  uint256 public maxBreedingFee;

  event Breed(address breeder, uint256 matronId, uint256 sireId, uint256 reward);
  event MaxBreedingFeeChange(uint256 oldBreedingFee, uint256 newBreedingFee);
  event BreederRewardChange(uint256 oldBreederReward, uint256 newBreederReward);

  constructor(address payable _owner, address payable _breeder, address _kittyCoreAddress, uint256 _breederReward) CKProxy(_owner, _kittyCoreAddress) public {
    require(_breeder != address(0));
    breeder = _breeder;
    maxBreedingFee = kittyCore.autoBirthFee();
    breederReward = _breederReward;
    originalBreederReward = _breederReward;
  }

  /**
   * Contract funds are used to cover breeding fees and pay callee
   */
  function () external payable {}

  /**
   * Owner can withdraw funds from contract
   */
  function withdraw(uint256 amount) external onlyOwner {
    owner.transfer(amount);
  }

  /**
   * Owner can adjust breedering fee if needed
   */
  function setMaxBreedingFee(
    uint256 _maxBreedingFee
  ) external onlyOwner {
    emit MaxBreedingFeeChange(maxBreedingFee, _maxBreedingFee);
    maxBreedingFee = _maxBreedingFee;
  }

   /**
   * Owner or breeder can change breeder's reward if needed.
   * Breeder can lower reward to make more attractive offer, it cannot set more than was originally agreed.
   * Owner can increase reward to motivate breeder to breed during high gas price, it cannot set less than was set by breeder.
   */
  function setBreederReward(
    uint256 _breederReward
  ) external {
    require(msg.sender == breeder || msg.sender == owner);
    
    if(msg.sender == owner) {
      require(_breederReward >= originalBreederReward || _breederReward > breederReward, 'Reward value is less than required');
    } else if(msg.sender == breeder) {
      require(_breederReward <= originalBreederReward, 'Reward value is more than original');
    }

    emit BreederRewardChange(breederReward, _breederReward);
    breederReward = _breederReward;
  }

  /**
   * Breeder can call this function to breed kitties on behalf of owner
   * Owner can breed as well
   */
  function breed(uint256 _matronId, uint256 _sireId) external whenNotPaused {
    require(msg.sender == breeder || msg.sender == owner);
    uint256 fee = kittyCore.autoBirthFee();
    require(fee <= maxBreedingFee);
    kittyCore.breedWithAuto.value(fee)(_matronId, _sireId);

    uint256 reward = 0;
    // breeder can reenter but that's OK, since breeder is payed per successful breed
    if(msg.sender == breeder) {
      reward = breederReward;
      breeder.transfer(reward);
    }

    emit Breed(msg.sender, _matronId, _sireId, reward);
  }

  function destroy() public onlyOwner {
    require(kittyCore.balanceOf(address(this)) == 0, 'Contract has tokens');
    selfdestruct(owner);
  }

  function destroyAndSend(address payable _recipient) public onlyOwner {
    require(kittyCore.balanceOf(address(this)) == 0, 'Contract has tokens');
    selfdestruct(_recipient);
  }
}