{{
  "language": "Solidity",
  "sources": {
    "contracts/megapoker1.sol": {
      "content": "/**\n *Submitted for verification at Etherscan.io on 2022-12-12\n*/\n\n// SPDX-License-Identifier: AGPL-3.0\n// The MegaPoker\n//\n// Copyright (C) 2020 Maker Ecosystem Growth Holdings, INC.\n//\n// This program is free software: you can redistribute it and/or modify\n// it under the terms of the GNU Affero General Public License as published by\n// the Free Software Foundation, either version 3 of the License, or\n// (at your option) any later version.\n//\n// This program is distributed in the hope that it will be useful,\n// but WITHOUT ANY WARRANTY; without even the implied warranty of\n// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n// GNU Affero General Public License for more details.\n//\n// You should have received a copy of the GNU Affero General Public License\n// along with this program.  If not, see <https://www.gnu.org/licenses/>.\n\npragma solidity ^0.6.12;\n\ncontract PokingAddresses {\n    // OSMs and Spotter addresses\n    address constant eth            = 0x7990A2B7CAe97B8052b0051327CA734df0081A0d;\n    address constant spotter        = 0xBe1A5F387AFd5bf41c352335c998fa15DC0E1708;\n}\n\ncontract MegaPoker is PokingAddresses {\n\n    function poke() external {\n        bool ok;\n\n        // poke() = 0x18178358\n        (ok,) = eth.call(abi.encodeWithSelector(0x18178358));\n\n\n        // poke(bytes32) = 0x1504460f\n        (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32(\"ETH-A\")));\n        (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32(\"ETH-B\")));\n    }\n}"
    }
  },
  "settings": {
    "optimizer": {
      "enabled": true,
      "runs": 200
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
    }
  }
}}