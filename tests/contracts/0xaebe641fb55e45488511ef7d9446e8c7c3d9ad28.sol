// Copyright (c) 2018-2020 double jump.tokyo inc.
pragma solidity 0.5.16;

interface IERC721Converter /* is IERC721TokenReceiver */{
    function draftAliceToken(uint256 _aliceTokenId, uint256 _bobTokenId) external;
    function draftBobToken(uint256 _BobTokenId, uint256 _aliceTokenId) external;
    function getAliceTokenID(uint256 _bobTokenId) external view returns(uint256);
    function getBobTokenID(uint256 _aliceTokenId) external view returns(uint256);
    function convertFromAliceToBob(uint256 _tokenId) external;
    function convertFromBobToAlice(uint256 _tokenId) external;
}

library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

    function add(Role storage role, address account) internal {
        require(!has(role, account), "role already has the account");
        role.bearer[account] = true;
    }

    function remove(Role storage role, address account) internal {
        require(has(role, account), "role dosen't have the account");
        role.bearer[account] = false;
    }

    function has(Role storage role, address account) internal view returns (bool) {
        return role.bearer[account];
    }
}

interface IERC721TokenReceiver {
    /// @notice Handle the receipt of an NFT
    /// @dev The ERC721 smart contract calls this function on the recipient
    ///  after a `transfer`. This function MAY throw to revert and reject the
    ///  transfer. Return of other than the magic value MUST result in the
    ///  transaction being reverted.
    ///  Note: the contract address is always the message sender.
    /// @param _operator The address which called `safeTransferFrom` function
    /// @param _from The address which previously owned the token
    /// @param _tokenId The NFT identifier which is being transferred
    /// @param _data Additional data with no specified format
    /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
    ///  unless throwing
    function onERC721Received(
        address _operator,
        address _from,
        uint256 _tokenId,
        bytes calldata _data
    )
        external
        returns(bytes4);
}

interface IERC165 {
    function supportsInterface(bytes4 interfaceID) external view returns (bool);
}

/// @title ERC-165 Standard Interface Detection
/// @dev See https://eips.ethereum.org/EIPS/eip-165
contract ERC165 is IERC165 {
    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
    mapping(bytes4 => bool) private _supportedInterfaces;

    constructor () internal {
        _registerInterface(_INTERFACE_ID_ERC165);
    }

    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
        return _supportedInterfaces[interfaceId];
    }

    function _registerInterface(bytes4 interfaceId) internal {
        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
        _supportedInterfaces[interfaceId] = true;
    }
}

contract ERC721Holder is IERC721TokenReceiver {
    function onERC721Received(address, address, uint256, bytes memory) public returns (bytes4) {
        return this.onERC721Received.selector;
    }
}

interface IERC173 /* is ERC165 */ {
    /// @dev This emits when ownership of a contract changes.
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /// @notice Get the address of the owner
    /// @return The address of the owner.
    function owner() external view returns (address);

    /// @notice Set the address of the new owner of the contract
    /// @param _newOwner The address of the new owner of the contract
    function transferOwnership(address _newOwner) external;
}

contract ERC173 is IERC173, ERC165  {
    address private _owner;

    constructor() public {
        _registerInterface(0x7f5828d0);
        _transferOwnership(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner(), "Must be owner");
        _;
    }

    function owner() public view returns (address) {
        return _owner;
    }

    function transferOwnership(address _newOwner) public onlyOwner() {
        _transferOwnership(_newOwner);
    }

    function _transferOwnership(address _newOwner) internal {
        address previousOwner = owner();
	_owner = _newOwner;
        emit OwnershipTransferred(previousOwner, _newOwner);
    }
}

contract Operatable is ERC173 {
    using Roles for Roles.Role;

    event OperatorAdded(address indexed account);
    event OperatorRemoved(address indexed account);

    event Paused(address account);
    event Unpaused(address account);

    bool private _paused;
    Roles.Role private operators;

    constructor() public {
        operators.add(msg.sender);
        _paused = false;
    }

    modifier onlyOperator() {
        require(isOperator(msg.sender), "Must be operator");
        _;
    }

    modifier whenNotPaused() {
        require(!_paused, "Pausable: paused");
        _;
    }

    modifier whenPaused() {
        require(_paused, "Pausable: not paused");
        _;
    }

    function transferOwnership(address _newOwner) public onlyOperator() {
        _transferOwnership(_newOwner);
    }

    function isOperator(address account) public view returns (bool) {
        return operators.has(account);
    }

    function addOperator(address account) public onlyOperator() {
        operators.add(account);
        emit OperatorAdded(account);
    }

    function removeOperator(address account) public onlyOperator() {
        operators.remove(account);
        emit OperatorRemoved(account);
    }

    function paused() public view returns (bool) {
        return _paused;
    }

    function pause() public onlyOperator() whenNotPaused() {
        _paused = true;
        emit Paused(msg.sender);
    }

    function unpause() public onlyOperator() whenPaused() {
        _paused = false;
        emit Unpaused(msg.sender);
    }

    function withdrawEther() public onlyOperator() {
        msg.sender.transfer(address(this).balance);
    }

}

interface IMCHHero {
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
}

interface IERC721Mintable {
    function exist(uint256 _tokenId) external view returns (bool);
    function mint(address _owner, uint256 _tokenId) external;
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
}

contract ERC721ConverterWithMCHHero is IERC721Converter, ERC721Holder, Operatable {
    IMCHHero public Alice;
    IERC721Mintable public Bob;

    mapping (uint256 => uint256) private _idMapAliceToBob;
    mapping (uint256 => uint256) private _idMapBobToAlice;

    constructor() public {}

    function updateAlice(address _newAlice) external onlyOperator() {
        Alice = IMCHHero(_newAlice);
    }

    function updateBob(address _newBob) external onlyOperator() {
        Bob = IERC721Mintable(_newBob);
    }

    function draftAliceTokens(uint256[] memory _aliceTokenIds, uint256[] memory _bobTokenIds) public onlyOperator() {
        require(_aliceTokenIds.length == _bobTokenIds.length);
        for (uint256 i = 0; i < _aliceTokenIds.length; i++) {
            draftAliceToken(_aliceTokenIds[i], _bobTokenIds[i]);
        }
    }

    function draftBobTokens(uint256[] memory _bobTokenIds, uint256[] memory _aliceTokenIds) public onlyOperator() {
        require(_aliceTokenIds.length == _bobTokenIds.length);
        for (uint256 i = 0; i < _aliceTokenIds.length; i++) {
            draftBobToken(_bobTokenIds[i], _aliceTokenIds[i]);
        }
    }

    function draftAliceToken(uint256 _aliceTokenId, uint256 _bobTokenId) public onlyOperator() {
        require(_idMapAliceToBob[_aliceTokenId] == 0, "_aliceTokenId is already assignd");
        require(_idMapBobToAlice[_bobTokenId] == 0, "_bobTokenId is already assignd");

        _idMapAliceToBob[_aliceTokenId] = _bobTokenId;
        _idMapBobToAlice[_bobTokenId] = _aliceTokenId;
    }

    function draftBobToken(uint256 _bobTokenId, uint256 _aliceTokenId) public onlyOperator() {
        require(_idMapBobToAlice[_bobTokenId] == 0, "_bobTokenId is already assignd");
        require(_idMapAliceToBob[_aliceTokenId] == 0, "_aliceTokenId is already assignd");

        _idMapBobToAlice[_bobTokenId] = _aliceTokenId;
        _idMapAliceToBob[_aliceTokenId] = _bobTokenId;
    }

    function getBobTokenID(uint256 _aliceTokenId) public view returns(uint256) {
        return _idMapAliceToBob[_aliceTokenId];
    }

    function getAliceTokenID(uint256 _bobTokenId) public view returns(uint256) {
        return _idMapBobToAlice[_bobTokenId];
    }

    function convertFromAliceToBob(uint256 _tokenId) public whenNotPaused() {
        Alice.safeTransferFrom(msg.sender, address(this), _tokenId);

        uint256 convertTo = getBobTokenID(_tokenId);
        if (Bob.exist(convertTo)) {
            Bob.safeTransferFrom(address(this), msg.sender, convertTo);
        } else {
            Bob.mint(msg.sender, convertTo);
        }
    }

    function convertFromBobToAlice(uint256 _tokenId) public whenNotPaused() {
        Bob.safeTransferFrom(msg.sender, address(this), _tokenId);

        uint256 convertTo = getAliceTokenID(_tokenId);
        Alice.safeTransferFrom(address(this), msg.sender, convertTo);
    }
}