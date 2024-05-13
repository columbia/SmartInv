1 // SPDX-License-Identifier: LGPL-3.0-only
2 pragma solidity 0.8.11;
3 
4 import "@openzeppelin/contracts/utils/math/SafeMath.sol";
5 import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
6 import "./ERC721MinterBurnerPauser.sol";
7 
8 /**
9     @title Manages deposited ERC721s.
10     @author ChainSafe Systems.
11     @notice This contract is intended to be used with ERC721Handler contract.
12  */
13 contract ERC721Safe {
14     using SafeMath for uint256;
15 
16     /**
17         @notice Used to gain custoday of deposited token.
18         @param tokenAddress Address of ERC721 to transfer.
19         @param owner Address of current token owner.
20         @param recipient Address to transfer token to.
21         @param tokenID ID of token to transfer.
22      */
23     function lockERC721(address tokenAddress, address owner, address recipient, uint tokenID) internal {
24         IERC721 erc721 = IERC721(tokenAddress);
25         erc721.transferFrom(owner, recipient, tokenID);
26 
27     }
28 
29     /**
30         @notice Transfers custody of token to recipient.
31         @param tokenAddress Address of ERC721 to transfer.
32         @param owner Address of current token owner.
33         @param recipient Address to transfer token to.
34         @param tokenID ID of token to transfer.
35      */
36     function releaseERC721(address tokenAddress, address owner, address recipient, uint256 tokenID) internal {
37         IERC721 erc721 = IERC721(tokenAddress);
38         erc721.transferFrom(owner, recipient, tokenID);
39     }
40 
41     /**
42         @notice Used to create new ERC721s.
43         @param tokenAddress Address of ERC721 to mint.
44         @param recipient Address to mint token to.
45         @param tokenID ID of token to mint.
46         @param data Optional data to send along with mint call.
47      */
48     function mintERC721(address tokenAddress, address recipient, uint256 tokenID, bytes memory data) internal {
49         ERC721MinterBurnerPauser erc721 = ERC721MinterBurnerPauser(tokenAddress);
50         erc721.mint(recipient, tokenID, string(data));
51     }
52 
53     /**
54         @notice Used to burn ERC721s.
55         @param tokenAddress Address of ERC721 to burn.
56         @param tokenID ID of token to burn.
57      */
58     function burnERC721(address tokenAddress, address owner, uint256 tokenID) internal {
59         ERC721MinterBurnerPauser erc721 = ERC721MinterBurnerPauser(tokenAddress);
60         require(erc721.ownerOf(tokenID) == owner, 'Burn not from owner');
61         erc721.burn(tokenID);
62     }
63 
64 }
