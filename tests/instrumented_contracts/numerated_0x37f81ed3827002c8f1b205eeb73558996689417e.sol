1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() {
15     owner = msg.sender;
16   }
17 
18   /**
19    * @dev revert()s if called by any account other than the owner.
20    */
21   modifier onlyOwner() {
22     if (msg.sender != owner) {
23       revert();
24     }
25     _;
26   }
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) onlyOwner {
33     if (newOwner != address(0)) {
34       owner = newOwner;
35     }
36   }
37 }
38 
39 /**
40  * @title Pausable
41  * @dev Base contract which allows children to implement an emergency stop mechanism.
42  */
43 contract Pausable is Ownable {
44   event Pause();
45   event Unpause();
46 
47   bool public paused = false;
48 
49   /**
50    * @dev modifier to allow actions only when the contract IS paused
51    */
52   modifier whenNotPaused() {
53     if (paused) revert();
54     _;
55   }
56 
57   /**
58    * @dev modifier to allow actions only when the contract IS NOT paused
59    */
60   modifier whenPaused {
61     if (!paused) revert();
62     _;
63   }
64 
65   /**
66    * @dev called by the owner to pause, triggers stopped state
67    */
68   function pause() onlyOwner whenNotPaused returns (bool) {
69     paused = true;
70     emit Pause();
71     return true;
72   }
73 
74   /**
75    * @dev called by the owner to unpause, returns to normal state
76    */
77   function unpause() onlyOwner whenPaused returns (bool) {
78     paused = false;
79     emit Unpause();
80     return true;
81   }
82 }
83 
84 
85 /**
86  * Pausable token
87  * Simple ERC20 Token example, with pausable token creation
88  **/
89 
90 contract News is Pausable {
91   string[] public news;
92 
93   function addNews(string msg) onlyOwner public {
94     news.push(msg);
95   }
96 }