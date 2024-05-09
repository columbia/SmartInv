1 pragma solidity ^0.4.19;
2 
3 contract SafetherStorage {
4     struct Depositor {
5         bytes8      _token;
6         uint256     _limit;
7         uint256     _deposit;
8     }
9     
10     mapping (address=>Depositor) internal _depositor;
11 }
12 
13 contract SafetherModifier is SafetherStorage {
14     modifier isRegisterd {
15         require(_depositor[msg.sender]._token != 0x0000000000000000);
16         _;
17     }
18     
19     modifier isNotRegisterd {
20         require(_depositor[msg.sender]._token == 0x0000000000000000);
21         _;
22     }
23     
24     modifier isValidDepositor(address depositor, bytes8 token) {
25         require(_depositor[depositor]._token != 0x0000000000000000);
26         require(_depositor[depositor]._deposit > 0);
27         require(_depositor[depositor]._token == token);
28         require(block.number >= _depositor[depositor]._limit);
29         _;
30     }
31 }
32 
33 contract SafetherAbstract {
34     function getDepositor() public constant returns(bytes8, uint256, uint256);
35     
36     function register() public;
37     function deposit(uint256 period) public payable;
38     function withdraw(address depositor, bytes8 token) public payable;
39     function cancel() public payable;
40 }
41 
42 contract Safether is SafetherModifier, SafetherAbstract {
43     function getDepositor() public constant returns(bytes8, uint256, uint256) {
44         return (_depositor[msg.sender]._token, 
45                 _depositor[msg.sender]._limit,
46                 _depositor[msg.sender]._deposit);
47     }
48     
49     function register() public isNotRegisterd {
50         _depositor[msg.sender]._token = bytes8(keccak256(block.number, msg.sender));
51     }
52     
53     function deposit(uint256 period) public payable isRegisterd {
54         _depositor[msg.sender]._deposit += msg.value;
55         _depositor[msg.sender]._limit = block.number + period;
56     }
57     
58     function withdraw(address depositor, bytes8 token) public payable isValidDepositor(depositor, token) {
59         uint256 tempDeposit = _depositor[depositor]._deposit;
60          _depositor[depositor]._deposit = 0;
61          msg.sender.transfer(tempDeposit + msg.value);
62     }
63     
64     function cancel() public payable isRegisterd {
65         uint256 tempDeposit = _depositor[msg.sender]._deposit;
66         delete _depositor[msg.sender];
67         msg.sender.transfer(tempDeposit + msg.value);
68     }
69 }