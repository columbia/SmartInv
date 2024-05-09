1 pragma solidity ^0.4.18;
2 
3 
4 // ----------------------------------------------------------------------------
5 
6 // ContractOwnershipBurn
7 
8 // Burn Ownership of a Smart Contract
9 
10 // Can only call the Accept Ownership method, nothing else
11 
12 // ----------------------------------------------------------------------------
13 
14 
15 
16 contract OwnableContractInterface {
17 
18     event OwnershipTransferred(address indexed _from, address indexed _to);
19 
20     function transferOwnership(address _newOwner) public ;
21     function acceptOwnership() public;
22 
23 }
24 
25 
26 
27 
28 
29 
30 // ----------------------------------------------------------------------------
31 
32 contract ContractOwnershipBurn {
33 
34 
35 
36     // ------------------------------------------------------------------------
37 
38     // Constructor
39 
40     // ------------------------------------------------------------------------
41 
42     function ContractOwnershipBurn() public  {
43 
44 
45     }
46 
47 
48 
49 
50     function burnOwnership(address contractAddress ) public   {
51 
52         OwnableContractInterface(contractAddress).acceptOwnership() ;
53 
54     }
55 
56 }