1 pragma solidity ^0.4.25;
2 
3 contract MyWishEosRegister {
4     event RegisterAdd(address indexed, string, bytes32);
5     mapping(address => bytes32) private register;
6     
7     function put(string _eosAccountName) external {
8         require(register[msg.sender] == 0, "address already bound");
9         bytes memory byteString = bytes(_eosAccountName);
10         require(byteString.length == 12, "worng length");
11 
12         for (uint i = 0; i < 12; i ++) {
13             byte b = byteString[i];
14             require((b >= 48 && b <= 53) || (b >= 97 && b <= 122), "wrong symbol");
15         }
16         bytes32 result;
17         assembly {
18             result := mload(add(byteString, 0x20))
19         }
20         register[msg.sender] = result;
21         emit RegisterAdd(msg.sender, _eosAccountName, result);
22     }
23 
24     
25     function get(address _addr) public view returns (string memory result) {
26         bytes32 eos = register[_addr];
27         if (eos == 0) {
28             return;
29         }
30         result = "............";
31         assembly {
32             mstore(add(result, 0x20), eos)
33         }
34     }
35 
36     
37     function get() public view returns (string memory) {
38         return get(msg.sender);
39     }
40 }