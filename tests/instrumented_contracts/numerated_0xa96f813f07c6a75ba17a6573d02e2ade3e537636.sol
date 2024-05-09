1 pragma solidity ^0.5.8;
2 // allow array of string
3 pragma experimental ABIEncoderV2;
4 
5 /**
6  * @title smart contract that allows IMQ to register its certificates in blockchain
7  * @author nya1, lepidotteri
8  * @dev Optimized for gas cost and time, allows to enter multiple hashes in a single tx
9  */
10 contract RegistrationEvent {
11 	/**
12 	 * Event to be emitted
13 	 */
14     event Registration(bytes32 indexed hash, string description, address indexed authority);
15 
16     /**
17      * @param _hashList Array of hashes (sha256 hash prefixed with 0x)
18      * @param _descList Array of strings
19      * @notice Will check if both arrays have the same length and emit
20      * a `Registration` event
21      */
22     function register(bytes32[] memory _hashList, string[] memory _descList) public {
23         require(_hashList.length == _descList.length, "Hash list and description list must have equal length");
24         for(uint i = 0; i < _hashList.length; i++) {
25             emit Registration(_hashList[i], _descList[i], msg.sender);
26         }
27     }
28 }