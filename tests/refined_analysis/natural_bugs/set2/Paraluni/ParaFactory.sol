pragma solidity =0.5.16;

import './interfaces/IParaFactory.sol';
import './ParaPair.sol';

contract ParaFactory is IParaFactory {
    bytes32 public constant INIT_CODE_PAIR_HASH = keccak256(abi.encodePacked(type(ParaPair).creationCode));

    address public feeTo;
    address public feeToSetter;
    address public feeDistributor;            // Handling fee allocation contract address

    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    constructor(address _feeToSetter) public {
        feeToSetter = _feeToSetter;
    }

    function allPairsLength() external view returns (uint) {
        return allPairs.length;
    }

    function createPair(address tokenA, address tokenB) external returns (address pair) {
        require(tokenA != tokenB, 'Paraluni: IDENTICAL_ADDRESSES');
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'Paraluni: ZERO_ADDRESS');
        require(getPair[token0][token1] == address(0), 'Paraluni: PAIR_EXISTS'); // single check is sufficient
        bytes memory bytecode = type(ParaPair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        IParaPair(pair).initialize(token0, token1);
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);
        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeToSetter, 'Paraluni: FORBIDDEN');
        feeTo = _feeTo;
    }

    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, 'Paraluni: FORBIDDEN');
        feeToSetter = _feeToSetter;
    }

    function setFeeDistributor(address _newAddress) external {
        require(msg.sender == feeToSetter, 'Paraluni: FORBIDDEN');
        require(_newAddress != feeDistributor, "Need a different fee distributor address");
        feeDistributor = _newAddress;
    }
}
