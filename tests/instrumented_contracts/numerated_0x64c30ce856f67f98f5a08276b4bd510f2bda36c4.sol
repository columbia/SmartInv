1 pragma solidity ^0.4.23;
2 
3 contract Ownable {
4 
5   address public owner;
6   event OwnershipRenounced(address indexed previousOwner);
7   event OwnershipTransferred(
8     address indexed previousOwner,
9     address indexed newOwner
10   );
11 
12   constructor() public {
13     owner = msg.sender;
14   }
15 
16   modifier onlyOwner() {
17     require(msg.sender == owner);
18     _;
19   }
20 
21   function transferOwnership(address newOwner) public onlyOwner {
22     require(newOwner != address(0));
23     emit OwnershipTransferred(owner, newOwner);
24     owner = newOwner;
25   }
26 
27   function renounceOwnership() public onlyOwner {
28     emit OwnershipRenounced(owner);
29     owner = address(0);
30   }
31 }
32 
33 contract RootInBlocks is Ownable {
34 
35   mapping(string => uint) map;
36 
37   event Added(
38     string hash,
39     uint time
40   );
41 
42   function put(string hash) public onlyOwner {
43     require(map[hash] == 0);
44     map[hash] = block.timestamp;
45     emit Added(hash, block.timestamp);
46   }
47 
48   function get(string hash) public constant returns(uint) {
49     return map[hash];
50   }
51 
52 }