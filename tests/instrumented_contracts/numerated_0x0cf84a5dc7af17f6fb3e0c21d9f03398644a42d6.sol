1 pragma solidity ^0.4.21;
2 
3 interface token {
4   function transfer(address receiver, uint amount) external;
5 }
6 
7 contract IOXDistribution {
8     
9     address public owner;
10     mapping(uint256 => bool) public claimers;
11     token public ioxToken;
12     
13     event Signer(address signer); 
14     
15     function IOXDistribution(address tokenAddress) public {
16         owner = msg.sender;
17         ioxToken = token(tokenAddress);
18     }
19     
20     function claim(uint256 claimer, uint256 amount, bytes sig) public {
21         bytes32 message = prefixed(keccak256(claimer, amount, this));
22         emit Signer(ecrecovery(message, sig));
23         require(ecverify(message, sig, owner));
24         require(!claimers[claimer]);
25         claimers[claimer] = true;    
26         ioxToken.transfer(msg.sender, amount *10**18);
27     }
28 
29     // Destroy contract and reclaim leftover funds.
30     function kill() public {
31         require(msg.sender == owner);
32         selfdestruct(msg.sender);
33     }
34 
35     // Builds a prefixed hash to mimic the behavior of eth_sign.
36     function prefixed(bytes32 hash) internal pure returns (bytes32) {
37         return keccak256("\x19Ethereum Signed Message:\n32", hash);
38     }
39     
40     function ecrecovery(bytes32 hash, bytes sig) internal pure returns (address) {
41       bytes32 r;
42       bytes32 s;
43       uint8 v;
44 
45       require(sig.length == 65);
46 
47       assembly {
48         r := mload(add(sig, 32))
49         s := mload(add(sig, 64))
50         v := and(mload(add(sig, 65)), 255)
51       }
52 
53       if (v < 27) {
54         v += 27;
55       }
56 
57       if (v != 27 && v != 28) {
58         return 0;
59       }
60 
61       return ecrecover(hash, v, r, s);
62     }
63 
64     function ecverify(bytes32 hash, bytes sig, address signer) internal pure returns (bool) {
65       return signer == ecrecovery(hash, sig);
66     }
67 
68 }