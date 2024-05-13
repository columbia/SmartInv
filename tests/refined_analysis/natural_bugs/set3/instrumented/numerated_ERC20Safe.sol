1 // SPDX-License-Identifier: LGPL-3.0-only
2 pragma solidity 0.8.11;
3 
4 import "@openzeppelin/contracts/utils/math/SafeMath.sol";
5 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
6 import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";
7 import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
8 
9 /**
10     @title Manages deposited ERC20s.
11     @author ChainSafe Systems.
12     @notice This contract is intended to be used with ERC20Handler contract.
13  */
14 contract ERC20Safe {
15     using SafeMath for uint256;
16 
17     /**
18         @notice Used to gain custody of deposited token.
19         @param tokenAddress Address of ERC20 to transfer.
20         @param owner Address of current token owner.
21         @param recipient Address to transfer tokens to.
22         @param amount Amount of tokens to transfer.
23      */
24     function lockERC20(address tokenAddress, address owner, address recipient, uint256 amount) internal {
25         IERC20 erc20 = IERC20(tokenAddress);
26         _safeTransferFrom(erc20, owner, recipient, amount);
27     }
28 
29     /**
30         @notice Transfers custody of token to recipient.
31         @param tokenAddress Address of ERC20 to transfer.
32         @param recipient Address to transfer tokens to.
33         @param amount Amount of tokens to transfer.
34      */
35     function releaseERC20(address tokenAddress, address recipient, uint256 amount) internal {
36         IERC20 erc20 = IERC20(tokenAddress);
37         _safeTransfer(erc20, recipient, amount);
38     }
39 
40     /**
41         @notice Used to create new ERC20s.
42         @param tokenAddress Address of ERC20 to transfer.
43         @param recipient Address to mint token to.
44         @param amount Amount of token to mint.
45      */
46     function mintERC20(address tokenAddress, address recipient, uint256 amount) internal {
47         ERC20PresetMinterPauser erc20 = ERC20PresetMinterPauser(tokenAddress);
48         erc20.mint(recipient, amount);
49 
50     }
51 
52     /**
53         @notice Used to burn ERC20s.
54         @param tokenAddress Address of ERC20 to burn.
55         @param owner Current owner of tokens.
56         @param amount Amount of tokens to burn.
57      */
58     function burnERC20(address tokenAddress, address owner, uint256 amount) internal {
59         ERC20Burnable erc20 = ERC20Burnable(tokenAddress);
60         erc20.burnFrom(owner, amount);
61     }
62 
63     /**
64         @notice used to transfer ERC20s safely
65         @param token Token instance to transfer
66         @param to Address to transfer token to
67         @param value Amount of token to transfer
68      */
69     function _safeTransfer(IERC20 token, address to, uint256 value) private {
70         _safeCall(token, abi.encodeWithSelector(token.transfer.selector, to, value));
71     }
72 
73 
74     /**
75         @notice used to transfer ERC20s safely
76         @param token Token instance to transfer
77         @param from Address to transfer token from
78         @param to Address to transfer token to
79         @param value Amount of token to transfer
80      */
81     function _safeTransferFrom(IERC20 token, address from, address to, uint256 value) private {
82         _safeCall(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
83     }
84 
85     /**
86         @notice used to make calls to ERC20s safely
87         @param token Token instance call targets
88         @param data encoded call data
89      */
90     function _safeCall(IERC20 token, bytes memory data) private {
91         uint256 tokenSize;
92         assembly {
93             tokenSize := extcodesize(token)
94         }         
95         require(tokenSize > 0, "ERC20: not a contract");
96 
97         (bool success, bytes memory returndata) = address(token).call(data);
98         require(success, "ERC20: call failed");
99 
100         if (returndata.length > 0) {
101 
102             require(abi.decode(returndata, (bool)), "ERC20: operation did not succeed");
103         }
104     }
105 
106 }
