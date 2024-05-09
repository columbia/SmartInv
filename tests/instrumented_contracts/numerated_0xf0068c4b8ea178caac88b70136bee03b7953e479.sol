1 pragma solidity ^0.4.24;
2 
3 
4 contract TheDivine{
5 
6     /* Randomness value */
7     bytes32 immotal;
8 
9     /* Address nonce */
10     mapping (address => uint256) internal nonce;
11 
12     /* Event */
13     event NewRand(address _sender, uint256 _complex, bytes32 _randomValue);
14        
15     /**
16     * Construct function
17     */
18     constructor() public {
19         immotal = keccak256(abi.encode(this));
20     }
21     
22     /**
23     * Get result from PRNG
24     */
25     function rand() public returns(bytes32 result){
26         uint256 complex = (nonce[msg.sender] % 11) + 10;
27         result = keccak256(abi.encode(immotal, nonce[msg.sender]++));
28         // Calculate digest by complex times
29         for(uint256 c = 0; c < complex; c++){
30             result = keccak256(abi.encode(result));
31         }
32         //Update new immotal result
33         immotal = result;
34         emit NewRand(msg.sender, complex, result);
35         return;
36     }
37 
38     /**
39     * No Ethereum will be trapped
40     */
41     function () public payable {
42         revert();
43     }
44 
45 }