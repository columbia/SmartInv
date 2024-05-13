1 pragma solidity ^0.8.0;
2 
3 import "./PCVSplitter.sol";
4 
5 /// @title ERC20Splitter
6 /// @notice a contract to split token held to multiple locations
7 contract ERC20Splitter is PCVSplitter {
8     /// @notice token to split
9     IERC20 public token;
10 
11     /**
12         @notice constructor for ERC20Splitter
13         @param _core the Core address to reference
14         @param _token the ERC20 token instance to split
15         @param _pcvDeposits the locations to send tokens
16         @param _ratios the relative ratios of how much tokens to send each location, in basis points
17     */
18     constructor(
19         address _core,
20         IERC20 _token,
21         address[] memory _pcvDeposits,
22         uint256[] memory _ratios
23     ) CoreRef(_core) PCVSplitter(_pcvDeposits, _ratios) {
24         token = _token;
25     }
26 
27     /// @notice distribute held TRIBE
28     function allocate() external whenNotPaused {
29         _allocate(token.balanceOf(address(this)));
30     }
31 
32     function _allocateSingle(uint256 amount, address pcvDeposit) internal override {
33         token.transfer(pcvDeposit, amount);
34     }
35 }
