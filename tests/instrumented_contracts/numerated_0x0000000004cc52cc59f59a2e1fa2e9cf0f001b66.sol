1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.8.0;
3 contract Cashier {
4     address payable public coldWallet;
5     
6     constructor(address multiSigWallet) payable
7     {
8         coldWallet = payable(multiSigWallet);
9     }
10 
11     function execute(address protocalAddress, bytes calldata data, uint256 sumPrice) public payable
12     {
13         require(protocalAddress != address(0) && protocalAddress != address(this), "invalid protocol address");
14         require(msg.value >= sumPrice * 1005 / 1000, "platform fee required");
15 
16         coldWallet.transfer(sumPrice * 5 / 1000);
17 
18         (bool success, bytes memory result) = protocalAddress.call{value: sumPrice}(data);
19         if(!success)
20            _revertWithData(result); 
21         _returnWithData(result);
22     }
23 
24     receive() external payable {}
25 
26     function _revertWithData(bytes memory data) private pure {
27         assembly { revert(add(data, 32), mload(data)) }
28     }
29 
30     function _returnWithData(bytes memory data) private pure {
31         assembly { return(add(data, 32), mload(data)) }
32     }
33 }