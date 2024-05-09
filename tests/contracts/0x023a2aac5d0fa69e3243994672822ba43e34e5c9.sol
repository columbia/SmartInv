{{
  "language": "Solidity",
  "sources": {
    "src/l1/bridge.sol": {
      "content": "// SPDX-License-Identifier: MIT\n\npragma solidity ^0.8.0;\n\ninterface IERC20Like {\n    function transfer(address to, uint256 amount) external returns (bool);\n    function transferFrom(address from, address to, uint256 value) external returns (bool success);\n}\n\ninterface IStarknetCore {\n    /**\n      Sends a message to an L2 contract.\n\n      Returns the hash of the message.\n    */\n    function sendMessageToL2(\n        uint256 toAddress,\n        uint256 selector,\n        uint256[] calldata payload\n    ) external payable returns (bytes32);\n\n    /**\n      Consumes a message that was sent from an L2 contract.\n\n      Returns the hash of the message.\n    */\n    function consumeMessageFromL2(\n        uint256 fromAddress,\n        uint256[] calldata payload\n    ) external returns (bytes32);\n}\n\ncontract LordsL1Bridge {\n    /// @notice The Starknet Core contract address on L1\n    address public immutable starknet;\n\n    /// @notice The $LORDS ERC20 contract address on L1\n    address public immutable l1Token;\n\n    /// @notice The L2 address of the $LORDS bridge, the counterpart to this contract\n    uint256 public immutable l2Bridge;\n\n    event LogDeposit(\n        address indexed l1Sender,\n        uint256 amount,\n        uint256 l2Recipient\n    );\n    event LogWithdrawal(address indexed l1Recipient, uint256 amount);\n\n    // 2 ** 251 + 17 * 2 ** 192 + 1;\n    uint256 private constant CAIRO_PRIME =\n        3618502788666131213697322783095070105623107215331596699973092056135872020481;\n\n    // from starkware.starknet.compiler.compile import get_selector_from_name\n    // print(get_selector_from_name('handle_deposit'))\n    uint256 private constant DEPOSIT_SELECTOR =\n        1285101517810983806491589552491143496277809242732141897358598292095611420389;\n\n    // operation ID sent in the L2 -> L1 message\n    uint256 private constant PROCESS_WITHDRAWAL = 1;\n\n    function splitUint256(uint256 value)\n        internal\n        pure\n        returns (uint256, uint256)\n    {\n        uint256 low = value & ((1 << 128) - 1);\n        uint256 high = value >> 128;\n        return (low, high);\n    }\n\n    constructor(\n        address _starknet,\n        address _l1Token,\n        uint256 _l2Bridge\n    ) {\n        require(_l2Bridge < CAIRO_PRIME, \"Invalid L2 bridge address\");\n\n        starknet = _starknet;\n        l1Token = _l1Token;\n        l2Bridge = _l2Bridge;\n    }\n\n    /// @notice Function used to bridge $LORDS from L1 to L2\n    /// @param amount How many $LORDS to send from msg.sender\n    /// @param l2Recipient To which L2 address should we deposit the $LORDS to\n    /// @param fee Compulsory fee paid to the sequencer for passing on the message\n    function deposit(uint256 amount, uint256 l2Recipient, uint256 fee) external payable {\n        require(amount > 0, \"Amount is 0\");\n        require(\n            l2Recipient != 0 &&\n            l2Recipient != l2Bridge &&\n            l2Recipient < CAIRO_PRIME,\n            \"Invalid L2 recipient\"\n        );\n\n        uint256[] memory payload = new uint256[](3);\n        payload[0] = l2Recipient;\n        (payload[1], payload[2]) = splitUint256(amount);\n\n        IERC20Like(l1Token).transferFrom(msg.sender, address(this), amount);\n        IStarknetCore(starknet).sendMessageToL2{value: fee}(\n            l2Bridge,\n            DEPOSIT_SELECTOR,\n            payload\n        );\n\n        emit LogDeposit(msg.sender, amount, l2Recipient);\n    }\n\n    /// @notice Function to process the L2 withdrawal\n    /// @param amount How many $LORDS were sent from L2\n    /// @param l1Recipient Recipient of the (de)bridged $LORDS\n    function withdraw(uint256 amount, address l1Recipient) external {\n        uint256[] memory payload = new uint256[](4);\n        payload[0] = PROCESS_WITHDRAWAL;\n        payload[1] = uint256(uint160(l1Recipient));\n        (payload[2], payload[3]) = splitUint256(amount);\n\n        // The call to consumeMessageFromL2 will succeed only if a\n        // matching L2->L1 message exists and is ready for consumption.\n        IStarknetCore(starknet).consumeMessageFromL2(l2Bridge, payload);\n        IERC20Like(l1Token).transfer(l1Recipient, amount);\n\n        emit LogWithdrawal(l1Recipient, amount);\n    }\n}\n"
    }
  },
  "settings": {
    "remappings": [
      "create3-factory/=lib/create3-factory/src/",
      "ds-test/=lib/create3-factory/lib/forge-std/lib/ds-test/src/",
      "forge-std/=lib/create3-factory/lib/forge-std/src/",
      "solmate/=lib/create3-factory/lib/solmate/src/"
    ],
    "optimizer": {
      "enabled": true,
      "runs": 200
    },
    "metadata": {
      "bytecodeHash": "ipfs",
      "appendCBOR": true
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
    "evmVersion": "paris",
    "libraries": {}
  }
}}