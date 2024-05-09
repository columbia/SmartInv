1 pragma solidity ^0.4.19;
2 
3 // the call we make
4 interface KittyCoreI {
5     function giveBirth(uint256 _matronId) public;
6 }
7 
8 /**
9  * @title Ownable
10  * @dev The Ownable contract has an owner address, and provides basic authorization control
11  * functions, this simplifies the implementation of "user permissions".
12  */
13 contract Ownable {
14     address public owner;
15 
16     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17 
18     /**
19      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20      * account.
21      */
22     function Ownable() public {
23         owner = msg.sender;
24     }
25 
26 
27     /**
28      * @dev Throws if called by any account other than the owner.
29      */
30     modifier onlyOwner() {
31         require(msg.sender == owner);
32         _;
33     }
34 
35 
36     /**
37      * @dev Allows the current owner to transfer control of the contract to a newOwner.
38      * @param newOwner The address to transfer ownership to.
39      */
40     function transferOwnership(address newOwner) public onlyOwner {
41         require(newOwner != address(0));
42         OwnershipTransferred(owner, newOwner);
43         owner = newOwner;
44     }
45 }
46 
47 contract KittyBirther is Ownable {
48     KittyCoreI constant kittyCore = KittyCoreI(0x06012c8cf97BEaD5deAe237070F9587f8E7A266d);
49 
50     function KittyBirther() public {}
51 
52     function withdraw() public onlyOwner {
53         owner.transfer(this.balance);
54     }
55 
56     function birth(uint blockNumber, uint64[] kittyIds) public {
57         if (blockNumber < block.number) {
58             return;
59         }
60 
61         if (kittyIds.length == 0) {
62             return;
63         }
64 
65         for (uint i = 0; i < kittyIds.length; i ++) {
66             kittyCore.giveBirth(kittyIds[i]);
67         }
68     }
69 }