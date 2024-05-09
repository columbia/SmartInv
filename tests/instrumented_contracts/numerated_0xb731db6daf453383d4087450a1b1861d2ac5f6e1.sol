1 pragma solidity ^0.4.19;
2 
3 contract GateKeeperI {
4   function enter(bytes32 _passcode, bytes8 _gateKey) public returns (bool);
5 }
6 
7 contract Entrant {
8   GateKeeperI gatekeeper;
9 
10   function Entrant(address _gatekeeper)
11     public
12   {
13     gatekeeper = GateKeeperI(_gatekeeper);
14   }
15 
16   function enter(bytes32 _passphrase)
17     public
18   {
19     //      7  6  5  4  3  2  1  0
20     //  0x 00 00 00 00 00 00 00 00
21     //                      |_____|
22     //                        msg.sender
23     //
24     //                |_____|
25     //                  zeroes
26     //
27     uint256 stipend;
28     uint256 offset;
29 
30     uint256 key;
31     uint256 upper;
32     uint256 lower;
33 
34     stipend = 500000;
35     stipend -= stipend % 8191;
36 
37     offset = 0x1e7b;
38     stipend -= offset;
39 
40     upper = uint256(bytes4("fnoo")) << 32;
41     lower = uint256(uint16(msg.sender));
42 
43     key = upper | lower;
44 
45     assert(uint32(key) == uint16(key));
46     assert(uint32(key) != uint64(key));
47     assert(uint32(key) == uint16(tx.origin));
48 
49     gatekeeper.enter.gas(stipend)(_passphrase, bytes8(key));
50   }
51 }