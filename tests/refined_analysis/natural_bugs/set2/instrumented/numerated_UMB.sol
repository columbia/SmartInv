1 //SPDX-License-Identifier: MIT
2 pragma solidity 0.7.5;
3 
4 // import "@nomiclabs/buidler/console.sol";
5 
6 // Inheritance
7 import "@openzeppelin/contracts/math/SafeMath.sol";
8 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
9 
10 import "./interfaces/SwappableToken.sol";
11 import "./interfaces/MintableToken.sol";
12 import "./interfaces/ISwapReceiver.sol";
13 import "./interfaces/Airdrop.sol";
14 
15 
16 /// @title   Umbrella Rewards contract
17 /// @author  umb.network
18 /// @notice  This is main UMB token
19 ///
20 /// @dev     Owner (multisig) can set list of rewards tokens rUMB. rUMBs can be swapped to UMB.
21 ///          This token can be mint by owner eg we need UMB for auction. After that we can burn the key
22 ///          so nobody can mint anymore.
23 ///          It has limit for max total supply, so we need to make sure, total amount of rUMBs fit this limit.
24 contract UMB is MintableToken, Airdrop, ISwapReceiver {
25     using SafeMath for uint256;
26 
27     // ========== STATE VARIABLES ========== //
28 
29     mapping(address => bool) rewardsTokens;
30 
31     // ========== CONSTRUCTOR ========== //
32 
33     constructor (
34         address _owner,
35         address _initialHolder,
36         uint _initialBalance,
37         uint256 _maxAllowedTotalSupply,
38         string memory _name,
39         string memory _symbol
40     )
41     Owned(_owner)
42     ERC20(_name, _symbol)
43     MintableToken(_maxAllowedTotalSupply) {
44         if (_initialHolder != address(0) && _initialBalance != 0) {
45             _mint(_initialHolder, _initialBalance);
46         }
47     }
48 
49     // ========== MODIFIERS ========== //
50 
51     // ========== MUTATIVE FUNCTIONS ========== //
52 
53     // ========== PRIVATE / INTERNAL ========== //
54 
55     // ========== RESTRICTED FUNCTIONS ========== //
56 
57     function setRewardTokens(address[] calldata _tokens, bool[] calldata _statuses)
58     external
59     onlyOwner {
60         require(_tokens.length > 0, "please pass a positive number of reward tokens");
61         require(_tokens.length == _statuses.length, "please pass same number of tokens and statuses");
62 
63         for (uint i = 0; i < _tokens.length; i++) {
64             rewardsTokens[_tokens[i]] = _statuses[i];
65         }
66 
67         emit LogSetRewardTokens(_tokens, _statuses);
68     }
69 
70     function swapMint(address _holder, uint256 _amount) public override assertMaxSupply(_amount) {
71         require(rewardsTokens[_msgSender()], "only reward token can be swapped");
72 
73         _mint(_holder, _amount);
74     }
75 
76     // ========== EVENTS ========== //
77 
78     event LogSetRewardTokens(address[] tokens, bool[] statuses);
79 }
