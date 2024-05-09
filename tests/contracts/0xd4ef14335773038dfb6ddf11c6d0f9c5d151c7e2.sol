pragma solidity ^0.5.11;


/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}



/**
 * @title Catalizr
 * @dev The Catalizr contract provide an easy way to proof the document is legit
 */
contract Catalizr is Ownable {

    mapping(bytes32 => bytes32) public operations;

    /**
    * @dev Allows the current owner to create a proof for an operation / document type
    * @param _mixedHash mixed hash of the operationId hash and document_type hash
    * @param _hashDocument hash of the document
    */
    function storeDocumentProof(bytes32 _mixedHash, bytes32 _hashDocument) public onlyOwner{
        operations[_mixedHash] = _hashDocument;
    }

    /**
    * @dev Allows the current owner to create proofs for many operation / documentType
    * @param _mixedHashes array of mixed hash of the operationId hash and document_type hash
    * @param _hashDocuments array of hash of the documents
    */
    function storeDocumentsProofs(bytes32[] memory _mixedHashes, bytes32[] memory _hashDocuments) public onlyOwner{
       for(uint i = 0; i < _mixedHashes.length; i++) {
        operations[_mixedHashes[i]] = _hashDocuments[i];
        }
    }

    /**
     * @dev Get the document hash from the hash of the operationId
     * @param _mixedHash mixed hash of the operationId hash and document_type hash
     */
    function getDocumentHashbyMixedHash(bytes32 _mixedHash) public view returns (bytes32) {
        return (operations[_mixedHash]);
    }

}