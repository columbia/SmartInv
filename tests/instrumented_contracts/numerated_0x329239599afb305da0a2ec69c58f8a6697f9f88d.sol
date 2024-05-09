1 pragma solidity 0.6.10;
2 pragma experimental ABIEncoderV2;
3 
4 
5 contract YPoolDelegator {
6     address[] public _coins;
7     address[] public _underlying_coins;
8     uint256[] public _balances;
9     uint256 public A;
10     uint256 public fee;
11     uint256 public admin_fee;
12     uint256 constant max_admin_fee = 5 * 10 ** 9;
13     address public owner;
14     address token;
15     uint256 public admin_actions_deadline;
16     uint256 public transfer_ownership_deadline;
17     uint256 public future_A;
18     uint256 public future_fee;
19     uint256 public future_admin_fee;
20     address public future_owner;
21     
22     uint256 kill_deadline;
23     uint256 constant kill_deadline_dt = 2 * 30 * 86400;
24     bool is_killed;
25     
26     constructor(address[4] memory _coinsIn, address[4] memory _underlying_coinsIn, address _pool_token, uint256 _A, uint256 _fee) public {
27         for (uint i = 0; i < 4; i++) {
28             require(_coinsIn[i] != address(0));
29             require(_underlying_coinsIn[i] != address(0));
30             _balances.push(0);
31             _coins.push(_coinsIn[i]);
32             _underlying_coins.push(_underlying_coinsIn[i]);
33         }
34         A = _A;
35         fee = _fee;
36         admin_fee = 0;
37         owner = msg.sender;
38         kill_deadline = block.timestamp + kill_deadline_dt;
39         is_killed = false;
40         token = _pool_token;
41     }
42     
43     function balances(int128 i) public view returns (uint256) {
44         return _balances[uint256(i)];
45     }
46     
47     function coins(int128 i) public view returns (address) {
48         return _coins[uint256(i)];
49     }
50     
51     function underlying_coins(int128 i) public view returns (address) {
52         return _underlying_coins[uint256(i)];
53     }
54 
55     fallback() external payable {
56         address _target = 0xA5407eAE9Ba41422680e2e00537571bcC53efBfD;
57 
58         assembly {
59             let _calldataMemOffset := mload(0x40)
60             let _callDataSZ := calldatasize()
61             let _size := and(add(_callDataSZ, 0x1f), not(0x1f))
62             mstore(0x40, add(_calldataMemOffset, _size))
63             calldatacopy(_calldataMemOffset, 0x0, _callDataSZ)
64             let _retval := delegatecall(gas(), _target, _calldataMemOffset, _callDataSZ, 0, 0)
65             switch _retval
66             case 0 {
67                 revert(0,0)
68             } default {
69                 let _returndataMemoryOff := mload(0x40)
70                 mstore(0x40, add(_returndataMemoryOff, returndatasize()))
71                 returndatacopy(_returndataMemoryOff, 0x0, returndatasize())
72                 return(_returndataMemoryOff, returndatasize())
73             }
74         }
75     }
76 }