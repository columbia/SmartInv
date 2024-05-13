1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./OracleRef.sol";
5 import "./IUniRef.sol";
6 
7 /// @title A Reference to Uniswap
8 /// @author Fei Protocol
9 /// @notice defines some utilities around interacting with Uniswap
10 /// @dev the uniswap pair should be FEI and another asset
11 abstract contract UniRef is IUniRef, OracleRef {
12     /// @notice the referenced Uniswap pair contract
13     IUniswapV2Pair public override pair;
14 
15     /// @notice the address of the non-fei underlying token
16     address public override token;
17 
18     /// @notice UniRef constructor
19     /// @param _core Fei Core to reference
20     /// @param _pair Uniswap pair to reference
21     /// @param _oracle oracle to reference
22     /// @param _backupOracle backup oracle to reference
23     constructor(
24         address _core,
25         address _pair,
26         address _oracle,
27         address _backupOracle
28     ) OracleRef(_core, _oracle, _backupOracle, 0, false) {
29         _setupPair(_pair);
30         _setDecimalsNormalizerFromToken(_token());
31     }
32 
33     /// @notice set the new pair contract
34     /// @param newPair the new pair
35     function setPair(address newPair) external virtual override onlyGovernor {
36         _setupPair(newPair);
37     }
38 
39     /// @notice pair reserves with fei listed first
40     function getReserves() public view override returns (uint256 feiReserves, uint256 tokenReserves) {
41         address token0 = pair.token0();
42         (uint256 reserve0, uint256 reserve1, ) = pair.getReserves();
43         (feiReserves, tokenReserves) = address(fei()) == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
44         return (feiReserves, tokenReserves);
45     }
46 
47     function _setupPair(address newPair) internal {
48         require(newPair != address(0), "UniRef: zero address");
49 
50         address oldPair = address(pair);
51         pair = IUniswapV2Pair(newPair);
52         emit PairUpdate(oldPair, newPair);
53 
54         token = _token();
55     }
56 
57     function _token() internal view returns (address) {
58         address token0 = pair.token0();
59         if (address(fei()) == token0) {
60             return pair.token1();
61         }
62         return token0;
63     }
64 }
