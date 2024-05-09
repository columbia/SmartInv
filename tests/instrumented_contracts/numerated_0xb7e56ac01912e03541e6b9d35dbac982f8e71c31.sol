1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() {
20     owner = msg.sender;
21   }
22 
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) onlyOwner public {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 /**
46  * @title Stoppable
47  * @dev Base contract which allows children to implement a permanent stop mechanism.
48  */
49 contract Stoppable is Ownable {
50   event Stop();  
51 
52   bool public stopped = false;
53 
54   /**
55    * @dev Modifier to make a function callable only when the contract is not stopped.
56    */
57   modifier whenNotStopped() {
58     require(!stopped);
59     _;
60   }
61 
62   /**
63    * @dev Modifier to make a function callable only when the contract is stopped.
64    */
65   modifier whenStopped() {
66     require(stopped);
67     _;
68   }
69 
70   /**
71    * @dev called by the owner to pause, triggers stopped state
72    */
73   function stop() onlyOwner whenNotStopped public {
74     stopped = true;
75     Stop();
76   }
77 }
78 
79 contract SpaceRegistry is Stoppable {
80     
81     event Add();
82     mapping(uint => uint) spaces;
83 
84     function addSpace(uint spaceId, uint userHash, bytes orderData) 
85         onlyOwner whenNotStopped {
86 
87         require(spaceId > 0);
88         require(userHash > 0);
89         require(orderData.length > 0);
90         require(spaces[spaceId] == 0);
91         spaces[spaceId] = userHash;
92         Add();
93     }
94 
95     function addSpaces(uint[] spaceIds, uint[] userHashes, bytes orderData)
96         onlyOwner whenNotStopped {
97 
98         var count = spaceIds.length;
99         require(count > 0);
100         require(userHashes.length == count);
101         require(orderData.length > 0);
102 
103         for (uint i = 0; i < count; i++) {
104             var spaceId = spaceIds[i];
105             var userHash = userHashes[i];
106             require(spaceId > 0);
107             require(userHash > 0);
108             require(spaces[spaceId] == 0);
109             spaces[spaceId] = userHash;
110         }
111 
112         Add();
113     }
114 
115     function getSpaceById(uint spaceId) 
116         external constant returns (uint userHash) {
117 
118         require(spaceId > 0);
119         return spaces[spaceId];
120     }
121 
122     function isSpaceExist(uint spaceId) 
123         external constant returns (bool) {
124             
125         require(spaceId > 0);
126         return spaces[spaceId] > 0;
127     }
128 }