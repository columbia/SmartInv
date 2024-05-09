pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;
// version 1.14

contract ArtoryRecordStamper {
    event Stamped(bytes32 dataHash);
    event StampedRecord(bytes32 dataHash, string recordID);

    // Indexed strings are hashed to keep data of consistent length for searching, so partner is given twice,
    // once as a plain parameter and once as an indexed parameter
    event StampedPartnerRecord(bytes32 dataHash, string recordID, string partner, string indexed indexedPartner);

    event Message(string message);

    address private _owner;
    constructor() public {
        _owner = msg.sender;
    }

    modifier onlyOwner {
        require(
            msg.sender == _owner,
            "Sender not authorized"
        );
        _;
    }

    function stamp(bytes32 dataHash)
        public
        onlyOwner
    {
        emit Stamped(dataHash);
    }

    function stamp_array(bytes32[] memory dataHashes)
        public
        onlyOwner
    {
        require(dataHashes.length <= 255, "Stamps per transaction limited to 255");

        for (uint i = 0; i < dataHashes.length; i++) {
            emit Stamped(dataHashes[i]);
        }
    }

    function stamp_record(bytes32 dataHash, string memory recordID)
        public
        onlyOwner
    {
        emit StampedRecord(dataHash, recordID);
    }

    function stamp_record_array(bytes32[] memory dataHashes, string[] memory recordIDs)
        public
        onlyOwner
    {
        require(
            dataHashes.length <= 255,
            "Stamps per transaction limited to 255"
        );

        require(
            dataHashes.length == recordIDs.length,
            "Number of recordsIDs must match number of dataHashes"
        );

        for (uint i = 0; i < dataHashes.length; i++) {
            emit StampedRecord(dataHashes[i], recordIDs[i]);
        }
    }

    function stamp_partner_record(bytes32 dataHash, string memory recordID, string memory partner)
        public
        onlyOwner
    {
        emit StampedPartnerRecord(dataHash, recordID, partner, partner);
    }

    function stamp_partner_record_array(bytes32[] memory dataHashes, string[] memory recordIDs, string[] memory partners)
        public
        onlyOwner
    {
        require(
            dataHashes.length <= 255,
            "Stamps per transaction limited to 255"
        );

        require(
            dataHashes.length == recordIDs.length,
            "Number of recordsIDs must match number of dataHashes"
        );

        require(
            dataHashes.length == partners.length,
            "Number of partners must match number of dataHashes"
        );

        for (uint i = 0; i < dataHashes.length; i++) {
            emit StampedPartnerRecord(dataHashes[i], recordIDs[i], partners[i], partners[i]);
        }
    }

    function broadcast_message(string memory str)
        public
        onlyOwner
    {
        require(
            bytes(str).length <= 128,
            "Message must be shorter than 128 characters"
        );
        emit Message(str);
    }
}