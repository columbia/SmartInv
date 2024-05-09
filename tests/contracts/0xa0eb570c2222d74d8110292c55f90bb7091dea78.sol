{{
  "language": "Solidity",
  "sources": {
    "/home/dave/proof/proof-seller/contracts/redemption/src/RankingRedeemer.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// Copyright 2023 PROOF Holdings Inc\npragma solidity ^0.8.0;\n\nimport {IRedeemableToken} from \"./interfaces/IRedeemableToken.sol\";\n\ninterface RankingRedeemerEvents {\n    /**\n     * @notice Emitted on redemption.\n     */\n    event VoucherRedeemedAndRankingCommited(\n        address indexed sender, IRedeemableToken indexed voucher, uint256 indexed tokenId, uint8[] ranking\n    );\n}\n\n/**\n * @notice Redeemes a token with a submitted ranking of choices, emitting an event containing the ranking as proof.\n * @dev The choices are numbered from 0 to `numChoices - 1`.\n */\ncontract RankingRedeemer is RankingRedeemerEvents {\n    /**\n     * @notice Thrown when the ranking length is not equal to the number of choices.\n     */\n    error InvalidRankingLength(Redemption, uint256 actual, uint256 expected);\n\n    /**\n     * @notice Thrown if not all choices were included in a given ranking.\n     */\n    error InvalidRanking(Redemption, uint256 choicesBitmask);\n\n    /**\n     * @notice The number of choices.\n     */\n    uint8 internal immutable _numChoices;\n\n    /**\n     * @notice The bitmask containing all choices.\n     */\n    uint256 internal immutable _happyBitmask;\n\n    constructor(uint8 numChoices) {\n        _numChoices = numChoices;\n        _happyBitmask = (1 << numChoices) - 1;\n    }\n\n    /**\n     * @notice Redeems a redeemable voucher and emits an event containing the ranking of choices as proof.\n     * @dev The ranking must contain all choices exactly once, reverts otherwise.\n     */\n    function _redeem(Redemption calldata r) internal virtual {\n        if (r.ranking.length != _numChoices) {\n            revert InvalidRankingLength(r, r.ranking.length, _numChoices);\n        }\n\n        uint256 choicesBitmask;\n        for (uint256 i; i < r.ranking.length; ++i) {\n            choicesBitmask |= 1 << r.ranking[i];\n        }\n\n        if (choicesBitmask != _happyBitmask) {\n            revert InvalidRanking(r, choicesBitmask);\n        }\n\n        emit VoucherRedeemedAndRankingCommited(msg.sender, r.redeemable, r.tokenId, r.ranking);\n        r.redeemable.redeem(msg.sender, r.tokenId);\n    }\n\n    struct Redemption {\n        IRedeemableToken redeemable;\n        uint256 tokenId;\n        uint8[] ranking;\n    }\n\n    /**\n     * @notice Redeems multiple vouchers and emits events containing the rankings as proof.\n     */\n    function redeem(Redemption[] calldata redemptions) public virtual {\n        for (uint256 i; i < redemptions.length; ++i) {\n            _redeem(redemptions[i]);\n        }\n    }\n}\n"
    },
    "/home/dave/proof/proof-seller/contracts/redemption/src/interfaces/IRedeemableToken.sol": {
      "content": "// SPDX-License-Identifier: MIT\n// Copyright 2023 PROOF Holdings Inc\npragma solidity ^0.8.0;\n\n/**\n * @notice Interface for a redeemable Voucher token preventing double spending\n * through internal book-keeping (e.g. burning the token, token property, etc.).\n * @dev Voucher tokens are intendent to be redeemed through a redeemer contract.\n */\ninterface IRedeemableToken {\n    /**\n     * @notice Thrown if the redemption caller is not allowed to spend a given\n     * voucher.\n     */\n    error RedeemerCallerNotAllowedToSpendVoucher(address sender, uint256 tokenId);\n\n    /**\n     * @notice Interface through which a `IRedeemer` contract informs the\n     * voucher about its redemption.\n     * @param sender The address that initiate the redemption on the\n     * redeemer contract.\n     * @param tokenId The voucher token to be redeemed.\n     * @dev This function MUST be called by redeemer contracts.\n     * @dev MUST revert with `RedeemerNotApproved` if the calling redeemer\n     * contract is not approved to spend this voucher.\n     * @dev MUST revert with `RedeemerCallerNotAllowedToSpendVoucher` if\n     * sender is not allowed to spend tokenId.\n     */\n    function redeem(address sender, uint256 tokenId) external;\n}\n"
    }
  },
  "settings": {
    "remappings": [
      "@divergencetech/ethier/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/ethier_0-55-0/",
      "@openzeppelin-4-7-0/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/openzeppelin-contracts_4-7-0_exact_remap/",
      "@openzeppelin-4.7/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/openzeppelin-contracts_4-7-0_exact_remap/",
      "@openzeppelin/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/openzeppelin-contracts_4-8-1/",
      "ERC721A/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/ERC721A_4-2-3/contracts/",
      "ERC721A_root/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/ERC721A_4-2-3/",
      "artblocks-contracts/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/artblocks-contracts_fa1dc466/contracts/",
      "artblocks-contracts_root/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/artblocks-contracts_fa1dc466/",
      "delegation-registry/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/delegation-registry_2d1a158b/src/",
      "delegation-registry_root/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/delegation-registry_2d1a158b/",
      "ds-test/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/ds-test_013e6c64/src/",
      "ds-test_root/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/ds-test_013e6c64/",
      "erc721a/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/ERC721A_4-2-3/",
      "ethier/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/ethier_0-55-0/contracts/",
      "ethier_root/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/ethier_0-55-0/",
      "forge-std/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/forge-std_1-4-0/src/",
      "openzeppelin-contracts-4-7-0/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/openzeppelin-contracts_4-7-0_exact_remap/contracts/",
      "openzeppelin-contracts/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/openzeppelin-contracts_4-8-1/contracts/",
      "openzeppelin-contracts/contracts/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/openzeppelin-contracts_4-8-1/contracts/",
      "openzeppelin-contracts_root-4-7-0/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/openzeppelin-contracts_4-7-0_exact_remap/",
      "openzeppelin-contracts_root/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/openzeppelin-contracts_4-8-1/",
      "operator-filter-registry/src/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/operator-filter-registry_1-4-1/src/",
      "operator-filter-registry_root/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/operator-filter-registry_1-4-1/",
      "proof/artblocks/=/home/dave/proof/proof-seller/contracts/artblocks/src/",
      "proof/constants/=/home/dave/proof/proof-seller/contracts/constants/src/",
      "proof/redemption/=/home/dave/proof/proof-seller/contracts/redemption/src/",
      "proof/sellers/=/home/dave/proof/proof-seller/contracts/sellers/src/"
    ],
    "optimizer": {
      "enabled": true,
      "runs": 9999
    },
    "metadata": {
      "bytecodeHash": "ipfs"
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
    "evmVersion": "london",
    "libraries": {}
  }
}}