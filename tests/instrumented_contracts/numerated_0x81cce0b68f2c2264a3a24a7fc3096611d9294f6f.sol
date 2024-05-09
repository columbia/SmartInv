1 pragma solidity ^0.4.24;
2 
3 /// @title Smart contract for forwarding ETH to a pre-defined recipient in the passive mode i.e. someone has to trigger the transfer.
4 /// It also allows recipient to call any smart contracts. For example: Calling Trustcoin smart contract to transfer TRST.
5 /// @author WeTrustPlatform
6 contract PassiveForwarder {
7   /// @dev recipient must be a normal account or a smart contract with the standard payable fallback method.
8   /// Otherwise, fund will be stuck!
9   address public recipient;
10 
11   event Received(address indexed sender, uint256 value);
12 
13   constructor(address _recipient) public {
14     recipient = _recipient;
15   }
16 
17   function () public payable {
18     require(msg.value > 0);
19     emit Received(msg.sender, msg.value);
20   }
21 
22   function sweep() public {
23     recipient.transfer(address(this).balance);
24   }
25 
26   /// @dev Courtesy of https://github.com/gnosis/MultiSigWallet/blob/master/contracts/MultiSigWallet.sol
27   /// This method allows the pre-defined recipient to call other smart contracts.
28   function externalCall(address destination, uint256 value, bytes data) public returns (bool) {
29     require(msg.sender == recipient, "Sender must be the recipient.");
30     uint256 dataLength = data.length;
31     bool result;
32     assembly {
33       let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
34       let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
35       result := call(
36         sub(gas, 34710),     // 34710 is the value that solidity is currently emitting
37                              // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
38                              // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
39         destination,
40         value,
41         d,
42         dataLength,          // Size of the input (in bytes) - this is what fixes the padding problem
43         x,
44         0                    // Output is ignored, therefore the output size is zero
45       )
46     }
47     return result;
48   }
49 }
50 
51 
52 /// @dev This contract is used for creating the Forwarder.
53 /// It also keeps track of all the Forwarders and their recipients
54 contract PassiveForwarderFactory {
55 
56   address public owner;
57 
58   /// @dev This will generate a public getter with two parameters
59   /// recipient address and contract index
60   mapping(address => address[]) public recipients;
61 
62   event Created(address indexed recipient, address indexed newContract);
63 
64   constructor(address _owner) public {
65     owner = _owner;
66   }
67 
68   function create(address recipient) public returns (address){
69     require(msg.sender == owner, "Sender must be the owner.");
70 
71     PassiveForwarder pf = new PassiveForwarder(recipient);
72     recipients[recipient].push(pf);
73     emit Created(recipient, pf);
74     return pf;
75   }
76 
77   /// @dev This method helps iterate through the recipients mapping
78   function getNumberOfContracts(address recipient) public view returns (uint256) {
79     return recipients[recipient].length;
80   }
81 }