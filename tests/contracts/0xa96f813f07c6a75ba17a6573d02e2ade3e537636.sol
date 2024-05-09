pragma solidity ^0.5.8;
// allow array of string
pragma experimental ABIEncoderV2;

/**
 * @title smart contract that allows IMQ to register its certificates in blockchain
 * @author nya1, lepidotteri
 * @dev Optimized for gas cost and time, allows to enter multiple hashes in a single tx
 */
contract RegistrationEvent {
	/**
	 * Event to be emitted
	 */
    event Registration(bytes32 indexed hash, string description, address indexed authority);

    /**
     * @param _hashList Array of hashes (sha256 hash prefixed with 0x)
     * @param _descList Array of strings
     * @notice Will check if both arrays have the same length and emit
     * a `Registration` event
     */
    function register(bytes32[] memory _hashList, string[] memory _descList) public {
        require(_hashList.length == _descList.length, "Hash list and description list must have equal length");
        for(uint i = 0; i < _hashList.length; i++) {
            emit Registration(_hashList[i], _descList[i], msg.sender);
        }
    }
}