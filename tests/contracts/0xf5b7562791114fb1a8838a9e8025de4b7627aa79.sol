{{
  "language": "Solidity",
  "sources": {
    "contracts/TellorProvider.sol": {
      "content": "pragma solidity 0.4.24;\n\nimport \"./ITellorGetters.sol\";\nimport \"./IMedianOracle.sol\";\n\ncontract TellorProvider{\n\n    ITellorGetters public tellor;\n    IMedianOracle public medianOracle;\n\n    \n    struct TellorTimes{\n        uint128 time0;\n        uint128 time1;\n    }\n    TellorTimes public tellorReport;\n    uint256 constant TellorID = 10;\n\n\n    constructor(address _tellor, address _medianOracle) public {\n        tellor = ITellorGetters(_tellor);\n        medianOracle = IMedianOracle(_medianOracle);\n    }\n\n    function pushTellor() external {\n        (bool retrieved, uint256 value, uint256 _time) = getTellorData(); \n        //Saving _time in a storage value to quickly verify disputes later\n        if(tellorReport.time0 >= tellorReport.time1) {\n            tellorReport.time1 = uint128(_time);\n        } else {\n            tellorReport.time0 = uint128(_time);\n        }\n        medianOracle.pushReport(value);\n    }\n\n    function verifyTellorReports() external {\n        //most recent tellor report is in dispute, so let's purge it\n        if(tellor.retrieveData(TellorID, tellorReport.time0) == 0 || tellor.retrieveData(TellorID,tellorReport.time1) == 0){\n            medianOracle.purgeReports();\n        }\n    }\n\n    function getTellorData() internal view returns(bool, uint256, uint256){\n        uint256 _count = tellor.getNewValueCountbyRequestId(TellorID);\n        if(_count > 0) {\n            uint256 _time = tellor.getTimestampbyRequestIDandIndex(TellorID, _count - 1);\n            uint256 _value = tellor.retrieveData(TellorID, _time);\n            return(true, _value, _time);\n        }\n        return (false, 0, 0);\n    }\n\n}\n"
    },
    "contracts/ITellorGetters.sol": {
      "content": "\npragma solidity 0.4.24;\n\n\n/**\n* @title Tellor Getters\n* @dev Oracle contract with all tellor getter functions. The logic for the functions on this contract \n* is saved on the TellorGettersLibrary, TellorTransfer, TellorGettersLibrary, and TellorStake\n*/\ninterface ITellorGetters {\n    function getNewValueCountbyRequestId(uint _requestId) external view returns(uint);\n    function getTimestampbyRequestIDandIndex(uint _requestID, uint _index) external view returns(uint);\n    function retrieveData(uint _requestId, uint _timestamp) external view returns (uint);\n}\n"
    },
    "contracts/IMedianOracle.sol": {
      "content": "\npragma solidity 0.4.24;\n\ninterface IMedianOracle{\n\n    //  // The number of seconds after which the report is deemed expired.\n    // uint256 public reportExpirationTimeSec;\n\n    // // The number of seconds since reporting that has to pass before a report\n    // // is usable.\n    // uint256 public reportDelaySec;\n    function reportDelaySec() external returns(uint256);\n    function reportExpirationTimeSec() external returns(uint256);\n    function pushReport(uint256 payload) external;\n    function purgeReports() external;\n}\n"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": true,
      "runs": 300
    },
    "outputSelection": {
      "*": {
        "*": [
          "evm.bytecode",
          "evm.deployedBytecode",
          "devdoc",
          "userdoc",
          "metadata",
          "abi"
        ]
      }
    },
    "libraries": {}
  }
}}