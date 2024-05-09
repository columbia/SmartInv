1 pragma solidity ^0.5.3;
2 
3 contract JortecCTF {
4 	
5 	/*************
6 	 * STATE VARS
7 	 *************/
8 	 
9 	address winner;
10 	
11 	/************
12 	 * MODIFIERS
13 	 ************/
14 	
15     modifier checkpointOne(string memory identification) {
16         // I'm someone's ID
17         require(bytes4(keccak256(bytes(identification))) == hex"ba0bba40");
18         _;
19     }
20     
21     modifier checkpointTwo() {
22         // I'm super vain
23         require(bytes1(bytes20(address(this))) == bytes1(bytes20(msg.sender)));
24         
25         _;
26     }  
27     
28     modifier checkpointThree(int wackyInt) {
29         // I blame someone's complement
30         if(wackyInt < 0){
31             wackyInt = -wackyInt;
32         }
33         
34         require(wackyInt < 0);
35         
36         _;
37     }
38 	
39 	/**************
40 	 * CONSTRUCTOR
41 	 **************/
42     
43 	constructor () public payable {
44 	    require(msg.value == 0.5 ether);
45 	}
46 	
47 	/*******************
48 	 * PUBLIC FUNCTIONS
49 	 *******************/
50 
51 	function winSetup(string memory identification, int wackyInt) public checkpointOne(identification) checkpointTwo checkpointThree(wackyInt) {
52 		winner = msg.sender;
53 		
54 		msg.sender.transfer(address(this).balance);
55 	}
56 }