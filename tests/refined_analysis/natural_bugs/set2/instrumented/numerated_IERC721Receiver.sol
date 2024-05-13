1 // This is a file copied from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/solc-0.6/contracts/token/ERC721/IERC721Receiver.sol
2 // SPDX-License-Identifier: MIT
3 
4 pragma solidity 0.7.6;
5 
6 /**
7  * @title ERC721 token receiver interface
8  * @dev Interface for any contract that wants to support safeTransfers
9  * from ERC721 asset contracts.
10  */
11 interface IERC721Receiver {
12     /**
13      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
14      * by `operator` from `from`, this function is called.
15      *
16      * It must return its Solidity selector to confirm the token transfer.
17      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
18      *
19      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
20      */
21     function onERC721Received(
22         address operator,
23         address from,
24         uint256 tokenId,
25         bytes calldata data
26     ) external returns (bytes4);
27 }
