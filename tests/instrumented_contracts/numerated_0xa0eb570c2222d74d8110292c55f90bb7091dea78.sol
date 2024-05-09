1 {{
2   "language": "Solidity",
3   "sources": {
4     "/home/dave/proof/proof-seller/contracts/redemption/src/RankingRedeemer.sol": {
5       "content": "// SPDX-License-Identifier: MIT\n// Copyright 2023 PROOF Holdings Inc\npragma solidity ^0.8.0;\n\nimport {IRedeemableToken} from \"./interfaces/IRedeemableToken.sol\";\n\ninterface RankingRedeemerEvents {\n    /**\n     * @notice Emitted on redemption.\n     */\n    event VoucherRedeemedAndRankingCommited(\n        address indexed sender, IRedeemableToken indexed voucher, uint256 indexed tokenId, uint8[] ranking\n    );\n}\n\n/**\n * @notice Redeemes a token with a submitted ranking of choices, emitting an event containing the ranking as proof.\n * @dev The choices are numbered from 0 to `numChoices - 1`.\n */\ncontract RankingRedeemer is RankingRedeemerEvents {\n    /**\n     * @notice Thrown when the ranking length is not equal to the number of choices.\n     */\n    error InvalidRankingLength(Redemption, uint256 actual, uint256 expected);\n\n    /**\n     * @notice Thrown if not all choices were included in a given ranking.\n     */\n    error InvalidRanking(Redemption, uint256 choicesBitmask);\n\n    /**\n     * @notice The number of choices.\n     */\n    uint8 internal immutable _numChoices;\n\n    /**\n     * @notice The bitmask containing all choices.\n     */\n    uint256 internal immutable _happyBitmask;\n\n    constructor(uint8 numChoices) {\n        _numChoices = numChoices;\n        _happyBitmask = (1 << numChoices) - 1;\n    }\n\n    /**\n     * @notice Redeems a redeemable voucher and emits an event containing the ranking of choices as proof.\n     * @dev The ranking must contain all choices exactly once, reverts otherwise.\n     */\n    function _redeem(Redemption calldata r) internal virtual {\n        if (r.ranking.length != _numChoices) {\n            revert InvalidRankingLength(r, r.ranking.length, _numChoices);\n        }\n\n        uint256 choicesBitmask;\n        for (uint256 i; i < r.ranking.length; ++i) {\n            choicesBitmask |= 1 << r.ranking[i];\n        }\n\n        if (choicesBitmask != _happyBitmask) {\n            revert InvalidRanking(r, choicesBitmask);\n        }\n\n        emit VoucherRedeemedAndRankingCommited(msg.sender, r.redeemable, r.tokenId, r.ranking);\n        r.redeemable.redeem(msg.sender, r.tokenId);\n    }\n\n    struct Redemption {\n        IRedeemableToken redeemable;\n        uint256 tokenId;\n        uint8[] ranking;\n    }\n\n    /**\n     * @notice Redeems multiple vouchers and emits events containing the rankings as proof.\n     */\n    function redeem(Redemption[] calldata redemptions) public virtual {\n        for (uint256 i; i < redemptions.length; ++i) {\n            _redeem(redemptions[i]);\n        }\n    }\n}\n"
6     },
7     "/home/dave/proof/proof-seller/contracts/redemption/src/interfaces/IRedeemableToken.sol": {
8       "content": "// SPDX-License-Identifier: MIT\n// Copyright 2023 PROOF Holdings Inc\npragma solidity ^0.8.0;\n\n/**\n * @notice Interface for a redeemable Voucher token preventing double spending\n * through internal book-keeping (e.g. burning the token, token property, etc.).\n * @dev Voucher tokens are intendent to be redeemed through a redeemer contract.\n */\ninterface IRedeemableToken {\n    /**\n     * @notice Thrown if the redemption caller is not allowed to spend a given\n     * voucher.\n     */\n    error RedeemerCallerNotAllowedToSpendVoucher(address sender, uint256 tokenId);\n\n    /**\n     * @notice Interface through which a `IRedeemer` contract informs the\n     * voucher about its redemption.\n     * @param sender The address that initiate the redemption on the\n     * redeemer contract.\n     * @param tokenId The voucher token to be redeemed.\n     * @dev This function MUST be called by redeemer contracts.\n     * @dev MUST revert with `RedeemerNotApproved` if the calling redeemer\n     * contract is not approved to spend this voucher.\n     * @dev MUST revert with `RedeemerCallerNotAllowedToSpendVoucher` if\n     * sender is not allowed to spend tokenId.\n     */\n    function redeem(address sender, uint256 tokenId) external;\n}\n"
9     }
10   },
11   "settings": {
12     "remappings": [
13       "@divergencetech/ethier/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/ethier_0-55-0/",
14       "@openzeppelin-4-7-0/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/openzeppelin-contracts_4-7-0_exact_remap/",
15       "@openzeppelin-4.7/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/openzeppelin-contracts_4-7-0_exact_remap/",
16       "@openzeppelin/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/openzeppelin-contracts_4-8-1/",
17       "ERC721A/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/ERC721A_4-2-3/contracts/",
18       "ERC721A_root/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/ERC721A_4-2-3/",
19       "artblocks-contracts/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/artblocks-contracts_fa1dc466/contracts/",
20       "artblocks-contracts_root/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/artblocks-contracts_fa1dc466/",
21       "delegation-registry/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/delegation-registry_2d1a158b/src/",
22       "delegation-registry_root/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/delegation-registry_2d1a158b/",
23       "ds-test/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/ds-test_013e6c64/src/",
24       "ds-test_root/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/ds-test_013e6c64/",
25       "erc721a/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/ERC721A_4-2-3/",
26       "ethier/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/ethier_0-55-0/contracts/",
27       "ethier_root/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/ethier_0-55-0/",
28       "forge-std/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/forge-std_1-4-0/src/",
29       "openzeppelin-contracts-4-7-0/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/openzeppelin-contracts_4-7-0_exact_remap/contracts/",
30       "openzeppelin-contracts/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/openzeppelin-contracts_4-8-1/contracts/",
31       "openzeppelin-contracts/contracts/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/openzeppelin-contracts_4-8-1/contracts/",
32       "openzeppelin-contracts_root-4-7-0/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/openzeppelin-contracts_4-7-0_exact_remap/",
33       "openzeppelin-contracts_root/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/openzeppelin-contracts_4-8-1/",
34       "operator-filter-registry/src/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/operator-filter-registry_1-4-1/src/",
35       "operator-filter-registry_root/=/home/dave/.cache/bazel/_bazel_dave/b9a57168317213f9241a484d2ee2d038/external/operator-filter-registry_1-4-1/",
36       "proof/artblocks/=/home/dave/proof/proof-seller/contracts/artblocks/src/",
37       "proof/constants/=/home/dave/proof/proof-seller/contracts/constants/src/",
38       "proof/redemption/=/home/dave/proof/proof-seller/contracts/redemption/src/",
39       "proof/sellers/=/home/dave/proof/proof-seller/contracts/sellers/src/"
40     ],
41     "optimizer": {
42       "enabled": true,
43       "runs": 9999
44     },
45     "metadata": {
46       "bytecodeHash": "ipfs"
47     },
48     "outputSelection": {
49       "*": {
50         "*": [
51           "evm.bytecode",
52           "evm.deployedBytecode",
53           "devdoc",
54           "userdoc",
55           "metadata",
56           "abi"
57         ]
58       }
59     },
60     "evmVersion": "london",
61     "libraries": {}
62   }
63 }}