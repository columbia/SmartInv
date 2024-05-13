1 pragma solidity =0.5.16;
2 
3 import './interfaces/IParaFactory.sol';
4 import './ParaPair.sol';
5 
6 contract ParaFactory is IParaFactory {
7     bytes32 public constant INIT_CODE_PAIR_HASH = keccak256(abi.encodePacked(type(ParaPair).creationCode));
8 
9     address public feeTo;
10     address public feeToSetter;
11     address public feeDistributor;            // Handling fee allocation contract address
12 
13     mapping(address => mapping(address => address)) public getPair;
14     address[] public allPairs;
15 
16     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
17 
18     constructor(address _feeToSetter) public {
19         feeToSetter = _feeToSetter;
20     }
21 
22     function allPairsLength() external view returns (uint) {
23         return allPairs.length;
24     }
25 
26     function createPair(address tokenA, address tokenB) external returns (address pair) {
27         require(tokenA != tokenB, 'Paraluni: IDENTICAL_ADDRESSES');
28         (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
29         require(token0 != address(0), 'Paraluni: ZERO_ADDRESS');
30         require(getPair[token0][token1] == address(0), 'Paraluni: PAIR_EXISTS'); // single check is sufficient
31         bytes memory bytecode = type(ParaPair).creationCode;
32         bytes32 salt = keccak256(abi.encodePacked(token0, token1));
33         assembly {
34             pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
35         }
36         IParaPair(pair).initialize(token0, token1);
37         getPair[token0][token1] = pair;
38         getPair[token1][token0] = pair; // populate mapping in the reverse direction
39         allPairs.push(pair);
40         emit PairCreated(token0, token1, pair, allPairs.length);
41     }
42 
43     function setFeeTo(address _feeTo) external {
44         require(msg.sender == feeToSetter, 'Paraluni: FORBIDDEN');
45         feeTo = _feeTo;
46     }
47 
48     function setFeeToSetter(address _feeToSetter) external {
49         require(msg.sender == feeToSetter, 'Paraluni: FORBIDDEN');
50         feeToSetter = _feeToSetter;
51     }
52 
53     function setFeeDistributor(address _newAddress) external {
54         require(msg.sender == feeToSetter, 'Paraluni: FORBIDDEN');
55         require(_newAddress != feeDistributor, "Need a different fee distributor address");
56         feeDistributor = _newAddress;
57     }
58 }
