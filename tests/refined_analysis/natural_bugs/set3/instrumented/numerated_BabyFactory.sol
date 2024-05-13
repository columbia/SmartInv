1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.5.16;
4 
5 import './BabyPair.sol';
6 import '../libraries/BabyLibrary.sol';
7 
8 contract BabyFactory {
9     bytes32 public constant INIT_CODE_PAIR_HASH = keccak256(abi.encodePacked(type(BabyPair).creationCode));
10 
11     address public feeTo;
12     address public feeToSetter;
13 
14     mapping(address => mapping(address => address)) public getPair;
15     address[] public allPairs;
16 
17     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
18 
19     constructor(address _feeToSetter) {
20         feeToSetter = _feeToSetter;
21     }
22 
23     function allPairsLength() external view returns (uint) {
24         return allPairs.length;
25     }
26 
27     function expectPairFor(address token0, address token1) public view returns (address) {
28         return BabyLibrary.pairFor(address(this), token0, token1);
29     }
30 
31     function createPair(address tokenA, address tokenB) external returns (address pair) {
32         require(tokenA != tokenB, 'Baby: IDENTICAL_ADDRESSES');
33         (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
34         require(token0 != address(0), 'Baby: ZERO_ADDRESS');
35         require(getPair[token0][token1] == address(0), 'Baby: PAIR_EXISTS'); // single check is sufficient
36         bytes memory bytecode = type(BabyPair).creationCode;
37         bytes32 salt = keccak256(abi.encodePacked(token0, token1));
38         assembly {
39             pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
40         }
41         IBabyPair(pair).initialize(token0, token1);
42         getPair[token0][token1] = pair;
43         getPair[token1][token0] = pair; // populate mapping in the reverse direction
44         allPairs.push(pair);
45         emit PairCreated(token0, token1, pair, allPairs.length);
46     }
47 
48     function setFeeTo(address _feeTo) external {
49         require(msg.sender == feeToSetter, 'Baby: FORBIDDEN');
50         feeTo = _feeTo;
51     }
52 
53     function setFeeToSetter(address _feeToSetter) external {
54         require(msg.sender == feeToSetter, 'Baby: FORBIDDEN');
55         feeToSetter = _feeToSetter;
56     }
57 }
