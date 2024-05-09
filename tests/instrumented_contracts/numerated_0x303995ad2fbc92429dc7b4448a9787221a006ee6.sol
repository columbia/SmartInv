1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10   event OwnershipTransferred(
11     address indexed previousOwner,
12     address indexed newOwner
13   );
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor() public {
21     owner = msg.sender;
22   }
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
35    * @param _newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address _newOwner) public onlyOwner {
38     _transferOwnership(_newOwner);
39   }
40 
41   /**
42    * @dev Transfers control of the contract to a newOwner.
43    * @param _newOwner The address to transfer ownership to.
44    */
45   function _transferOwnership(address _newOwner) internal {
46     require(_newOwner != address(0));
47     emit OwnershipTransferred(owner, _newOwner);
48     owner = _newOwner;
49   }
50 }
51 
52 
53 contract CFunIPBase is Ownable{
54 
55     struct Copyright 
56     {
57         uint256 copyrightID;
58         string fingerprint; 
59         string title;
60         uint256 recordDate;
61         address author;
62         address recorder;
63 
64     }
65     event Pause();
66     event Unpause();
67     event SaveCopyright(string fingerprint,string title,string author);
68 
69     Copyright[]  public copyrights;
70 
71     bool public paused = false;
72 
73 
74     function saveCopyright(string fingerprint,string title,address author) public whenNotPaused {
75         require(!isContract(author));
76         Copyright memory _c = Copyright(
77         {
78             copyrightID:copyrights.length,
79             fingerprint:fingerprint,
80             title:title,
81             recordDate:block.timestamp,
82             author:author,
83             recorder:msg.sender
84         }
85         );
86         copyrights.push(_c);
87         emit SaveCopyright(fingerprint,title,toString(author));
88 
89     }
90     function copyrightCount() public  view  returns(uint256){
91         return copyrights.length;
92 
93     }
94 
95 
96     /**
97     * @dev Modifier to make a function callable only when the contract is not paused.
98     */
99     modifier whenNotPaused() {
100         require(!paused);
101         _;
102     }
103 
104     /**
105     * @dev Modifier to make a function callable only when the contract is paused.
106     */
107     modifier whenPaused() {
108         require(paused);
109         _;
110     }
111 
112     /**
113     * @dev called by the owner to pause, triggers stopped state
114     */
115     function pause() public onlyOwner whenNotPaused {
116         paused = true;
117         emit Pause();
118     }
119 
120     /**
121     * @dev called by the owner to unpause, returns to normal state
122     */
123     function unpause() public onlyOwner whenPaused {
124         paused = false;
125         emit Unpause();
126     }
127 
128     /**
129     * Returns whether the target address is a contract
130     * @dev This function will return false if invoked during the constructor of a contract,
131     * as the code is not actually created until after the constructor finishes.
132     * @param _account address of the account to check
133     * @return whether the target address is a contract
134     */
135   function isContract(address _account) internal view returns (bool) {
136     uint256 size;
137     assembly { size := extcodesize(_account) }
138     return size > 0;
139   }
140   
141    /**
142     * Returns address of string type
143     * @dev This function will return  address of string type
144     * @param _addr address 
145     * @return address of string type
146     */
147   function toString(address _addr) private pure returns (string) {
148       bytes memory b = new bytes(20);
149       for (uint i = 0; i < 20; i++)
150           b[i] = byte(uint8(uint(_addr) / (2**(8*(19 - i)))));
151       return string(b);
152   }
153 
154 }