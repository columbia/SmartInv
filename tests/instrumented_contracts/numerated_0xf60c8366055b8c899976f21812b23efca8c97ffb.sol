1 pragma solidity ^0.4.19;
2 
3 contract theCyberGatekeeperInterface {
4     function enter(bytes32 _passcode, bytes8 _gateKey) public returns (bool);
5 }
6 
7 contract theCyberKey {
8     address private gatekeeperAddress = 0x44919b8026f38D70437A8eB3BE47B06aB1c3E4Bf;
9 
10     function setGatekeeperAddress(address gatekeeper) public {
11         gatekeeperAddress = gatekeeper;
12     }
13 
14     function enter(bytes32 passcode) public returns (bool) {
15         bytes8 key = generateKey();
16         return theCyberGatekeeperInterface(gatekeeperAddress).enter(passcode, key);
17     }
18 
19     function generateKey() private returns (bytes8 key) {
20         // Below are the checks:
21         // require(uint32(_gateKey) == uint16(_gateKey));
22         // require(uint32(_gateKey) != uint64(_gateKey));
23         // require(uint32(_gateKey) == uint16(tx.origin));
24 
25         // Check 1:
26         //   the lower 4 bytes equal the lower 2 bytes; this can be implemented by padding the lower 2 bytes
27         //   with 0's for the upper 2 bytes: 00 00 XX XX
28         //   we'll start with initializing lower 4 to 0 to accomplish this;
29         uint32 lower4Bytes = 0;
30 
31         // Check 2:
32         //   Lower 4 bytes can't equal all bytes (which means upper 4 cannot equal 0)
33         //   Set upper 4 to 1
34         uint32 upper4Bytes = 1;
35 
36         // Check 3:
37         //  The lower 2 bytes of the original transmitter should equal to the lower 4 bytes of the key
38         //  This checks out with check 1 which says lower 4 bytes should have 2 upper zero bytes
39         uint16 lower2Bytes = uint16(tx.origin);
40 
41         // Assemble key
42         lower4Bytes |= lower2Bytes;
43         uint64 allBytes = lower4Bytes;
44         allBytes |= uint64(upper4Bytes) << 32;
45         key = bytes8(allBytes);
46 
47         return key;
48     }
49 }