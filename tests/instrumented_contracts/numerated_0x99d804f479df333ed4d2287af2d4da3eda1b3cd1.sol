1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title EthealSplit
5  * @dev Split ether evenly on the fly.
6  * @author thesved, viktor.tabori at etheal.com
7  */
8 contract EthealSplit {
9     /// @dev Split evenly among addresses, no safemath is needed for divison
10     function split(address[] _to) public payable {
11         uint256 _val = msg.value / _to.length;
12         for (uint256 i=0; i < _to.length; i++) {
13             _to[i].send(_val);
14         }
15 
16         if (address(this).balance > 0) {
17             msg.sender.transfer(address(this).balance);
18         }
19     }
20 }