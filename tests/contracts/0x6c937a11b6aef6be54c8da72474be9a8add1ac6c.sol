pragma solidity 0.5.1;

/**
 * @title Roles
 * @dev Library for managing addresses assigned to a Role.
 */
library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

    /**
     * @dev Give an account access to this role.
     */
    function add(Role storage role, address account) internal {
        require(!has(role, account), "Roles: account already has role");
        role.bearer[account] = true;
    }

    /**
     * @dev Remove an account's access to this role.
     */
    function remove(Role storage role, address account) internal {
        require(has(role, account), "Roles: account does not have role");
        role.bearer[account] = false;
    }

    /**
     * @dev Check if an account has this role.
     * @return bool
     */
    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0), "Roles: account is the zero address");
        return role.bearer[account];
    }
}


/**
 * @title WhitelistAdminRole
 * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
 */
contract WhitelistAdminRole {
    using Roles for Roles.Role;

    event WhitelistAdminAdded(address indexed account);
    event WhitelistAdminRemoved(address indexed account);

    Roles.Role private _whitelistAdmins;

    constructor () internal {
        _addWhitelistAdmin(msg.sender);
    }

    modifier onlyWhitelistAdmin() {
        require(isWhitelistAdmin(msg.sender), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
        _;
    }

    function isWhitelistAdmin(address account) public view returns (bool) {
        return _whitelistAdmins.has(account);
    }

    function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
        _addWhitelistAdmin(account);
    }

    function renounceWhitelistAdmin() public {
        _removeWhitelistAdmin(msg.sender);
    }

    function _addWhitelistAdmin(address account) internal {
        _whitelistAdmins.add(account);
        emit WhitelistAdminAdded(account);
    }

    function _removeWhitelistAdmin(address account) internal {
        _whitelistAdmins.remove(account);
        emit WhitelistAdminRemoved(account);
    }
}


/**
 * @title IpfsHashRecord
 * @dev Record IPFS hash to Ethereum contract by emitting log.
 */
contract IpfsHashRecord is WhitelistAdminRole {

  // eventSig is the first 4 bytes of the Keccak256 hash of event name
  // auction_bidding: 0x636fe49e
  // auction_receipt: 0x4997644b
  // bancor_trading: 0x285a30e1
  event Recorded (bytes4 indexed eventSig, uint256 indexed createdAt, bytes32 ipfsHash);

  /**
   * @dev Write ipfsHash as log
   */
  function writeHash(bytes4 _eventSig, bytes32 _ipfsHash) public onlyWhitelistAdmin {
    emit Recorded(_eventSig, uint256(now), _ipfsHash);
  }

  /**
   * @dev Add admin
   */
  function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
    super.addWhitelistAdmin(account);
  }

  /**
   * @dev Renounce admin
   */
  function renounceWhitelistAdmin() public {
    super.renounceWhitelistAdmin();
  }

  /**
   * @dev Check whether address is admin or not
   */
  function isWhitelistAdmin(address account) public view returns (bool) {
    return super.isWhitelistAdmin(account);
  }
}