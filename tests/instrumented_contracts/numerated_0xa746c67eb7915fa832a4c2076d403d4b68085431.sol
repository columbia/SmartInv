1 pragma solidity 0.6.10;
2 pragma experimental ABIEncoderV2;
3 
4 
5 abstract contract YToken {
6     function getPricePerFullShare() external view virtual returns (uint256);
7 }
8 
9 contract ZapDelegator {
10     address[] public _coins;
11     address[] public _underlying_coins;
12     address public curve;
13     address public token;
14     
15     constructor(address[4] memory _coinsIn, address[4] memory _underlying_coinsIn, address _curve, address _pool_token) public {
16         for (uint i = 0; i < 4; i++) {
17             require(_underlying_coinsIn[i] != address(0));
18             require(_coinsIn[i] != address(0));
19             _coins.push(_coinsIn[i]);
20             _underlying_coins.push(_underlying_coinsIn[i]);
21         }
22         curve = _curve;
23         token = _pool_token;
24     }
25     
26     function coins(int128 i) public view returns (address) {
27         return _coins[uint256(i)];
28     }
29     
30     function underlying_coins(int128 i) public view returns (address) {
31         return _underlying_coins[uint256(i)];
32     }
33 
34     fallback() external payable {
35         address _target = 0xFCBa3E75865d2d561BE8D220616520c171F12851;
36 
37         assembly {
38             let _calldataMemOffset := mload(0x40)
39             let _callDataSZ := calldatasize()
40             let _size := and(add(_callDataSZ, 0x1f), not(0x1f))
41             mstore(0x40, add(_calldataMemOffset, _size))
42             calldatacopy(_calldataMemOffset, 0x0, _callDataSZ)
43             let _retval := delegatecall(gas(), _target, _calldataMemOffset, _callDataSZ, 0, 0)
44             switch _retval
45             case 0 {
46                 revert(0,0)
47             } default {
48                 let _returndataMemoryOff := mload(0x40)
49                 mstore(0x40, add(_returndataMemoryOff, returndatasize()))
50                 returndatacopy(_returndataMemoryOff, 0x0, returndatasize())
51                 return(_returndataMemoryOff, returndatasize())
52             }
53         }
54     }
55 }