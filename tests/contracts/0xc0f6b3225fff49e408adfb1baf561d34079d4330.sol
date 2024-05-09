{{
  "language": "Solidity",
  "sources": {
    "/home/julian/betx/betx-contracts/contracts/impl/AffiliateRegistry.sol": {
      "keccak256": "0x282d411efd8cd1121974e6805a823f6ea2bc545e2f7c4598841764af2241d365",
      "content": "pragma solidity 0.5.16;\npragma experimental ABIEncoderV2;\n\nimport \"../interfaces/IAffiliateRegistry.sol\";\nimport \"../interfaces/permissions/IWhitelist.sol\";\n\n\ncontract AffiliateRegistry is IAffiliateRegistry {\n    uint256 public constant MAX_AFFILIATE_FEE = 3*(10**19);\n\n    IWhitelist private systemParamsWhitelist;\n\n    address private defaultAffiliate;\n    mapping (address => address) private addressToAffiliate;\n    mapping (address => uint256) private affiliateFeeFrac;\n\n    event AffiliateSet(\n        address member,\n        address affiliate\n    );\n\n    event AffiliateFeeFracSet(\n        address affiliate,\n        uint256 feeFrac\n    );\n\n    constructor(IWhitelist _systemParamsWhitelist) public {\n        systemParamsWhitelist = _systemParamsWhitelist;\n    }\n\n    /// @notice Throws if the caller is not a system params admin.\n    modifier onlySystemParamsAdmin() {\n        require(\n            systemParamsWhitelist.getWhitelisted(msg.sender),\n            \"NOT_SYSTEM_PARAM_ADMIN\"\n        );\n        _;\n    }\n\n    /// @notice Sets the affiliate for an address.\n    /// @param member The address to attach to the affiliate.\n    /// @param affiliate The affiliate address to attach.\n    function setAffiliate(address member, address affiliate)\n        public\n        onlySystemParamsAdmin\n    {\n        require(\n            affiliate != address(0),\n            \"AFFILIATE_ZERO_ADDRESS\"\n        );\n\n        addressToAffiliate[member] = affiliate;\n    }\n\n    /// @notice Sets the affiliate fee fraction for an address.\n    /// @param affiliate The affiliate whose fee fraction should be changed.\n    /// @param feeFrac The new fee fraction for this affiliate.\n    function setAffiliateFeeFrac(address affiliate, uint256 feeFrac)\n        public\n        onlySystemParamsAdmin\n    {\n        require(\n            feeFrac < MAX_AFFILIATE_FEE,\n            \"AFFILIATE_FEE_TOO_HIGH\"\n        );\n\n        affiliateFeeFrac[affiliate] = feeFrac;\n    }\n\n    /// @notice Sets the default affiliate if no affiliate is set for an address.\n    /// @param affiliate The new default affiliate.\n    function setDefaultAffiliate(address affiliate)\n        public\n        onlySystemParamsAdmin\n    {\n        require(\n            affiliate != address(0),\n            \"AFFILIATE_ZERO_ADDRESS\"\n        );\n\n        defaultAffiliate = affiliate;\n    }\n\n    /// @notice Gets the affiliate for an address. If no affiliate is set, it returns the\n    ///         default affiliate.\n    /// @param member The address to query.\n    /// @return The affiliate for this address.\n    function getAffiliate(address member)\n        public\n        view\n        returns (address)\n    {\n        address affiliate = addressToAffiliate[member];\n        if (affiliate == address(0)) {\n            return defaultAffiliate;\n        } else {\n            return affiliate;\n        }\n    }\n\n    function getAffiliateFeeFrac(address affiliate)\n        public\n        view\n        returns (uint256)\n    {\n        return affiliateFeeFrac[affiliate];\n    }\n\n    function getDefaultAffiliate()\n        public\n        view\n        returns (address)\n    {\n        return defaultAffiliate;\n    }\n\n}"
    },
    "/home/julian/betx/betx-contracts/contracts/interfaces/IAffiliateRegistry.sol": {
      "keccak256": "0x1e2cda12e6f16f08fbd4f8a599123cc5eb99e7ebad1484d25cdae0d9c6a4e295",
      "content": "pragma solidity 0.5.16;\n\ncontract IAffiliateRegistry {\n    function setAffiliate(address member, address affiliate) public;\n    function setAffiliateFeeFrac(address affiliate, uint256 fee) public;\n    function setDefaultAffiliate(address affiliate) public;\n    function getAffiliate(address member) public view returns (address);\n    function getAffiliateFeeFrac(address affiliate) public view returns (uint256);\n    function getDefaultAffiliate() public view returns (address);\n}\n"
    },
    "/home/julian/betx/betx-contracts/contracts/interfaces/permissions/IWhitelist.sol": {
      "keccak256": "0x43b8d9573b5d37864e6084472019925ff7947299dd39b9081dcef6df940fb76a",
      "content": "pragma solidity 0.5.16;\n\ncontract IWhitelist {\n    function addAddressToWhitelist(address) public;\n    function removeAddressFromWhitelist(address) public;\n    function getWhitelisted(address) public view returns (bool);\n}\n"
    }
  },
  "settings": {
    "evmVersion": "istanbul",
    "libraries": {},
    "optimizer": {
      "details": {
        "constantOptimizer": true,
        "cse": true,
        "deduplicate": true,
        "jumpdestRemover": true,
        "orderLiterals": true,
        "peephole": true,
        "yul": true,
        "yulDetails": {
          "stackAllocation": true
        }
      },
      "runs": 200
    },
    "remappings": [],
    "outputSelection": {
      "*": {
        "*": [
          "evm.bytecode",
          "evm.deployedBytecode",
          "abi"
        ]
      }
    }
  }
}}