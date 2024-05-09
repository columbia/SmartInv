1 pragma solidity ^0.5.0;
2 
3 	/* contract can send to others - we verify there is not a contract
4 	at address we are sending to. This prevents security issues
5 	*/
6 	
7 contract TriviaChain {
8 
9 	/* Owner of the contract -- this is US */
10 	address payable public owner;
11 	
12 	/* Unix timestamp of when contract is valid from */
13 	uint256 public startdate = 1560737700;	
14 	
15 	/* Unix timestamp of when contract is valid until */
16 	uint256 public enddate = 1560737758;
17 
18 
19 	/* this is the question ID - needs to match with database question ID */
20 	int constant question_id = 18;
21 
22 	/* Answer Hash to verify the user put in the correct answer - sha256
23 		It is the hash of the correct answer
24 	*/
25 	bytes correctAnswerHash = bytes('0x1670F2E42FEFA5044D59A65349E47C566009488FC57D7B4376DD5787B59E3C57'); //need to verify that same as toHEx
26 
27 	
28 	/* constructor called whenever we initialize a contract sender will be us */
29 	constructor() public {owner = msg.sender; }
30 
31 	/* standard modifier to only allow owner */
32 	modifier onlyOwner {
33 	require (msg.sender == owner);
34 	_;
35 	}
36 
37 	
38 	/* fallback function so contract can recieve ether */
39 	
40 	function() external payable { }
41 	
42 	/* function to check there is no code at site we are sending funds to 
43 	   The contract holds the funds so users can see the pot payout and then 
44 	   the value after payout
45 	*/
46 	function checkAnswer(string memory answer) private view returns (bool) {
47 	
48 	bytes32 answerHash = sha256(abi.encodePacked(answer));
49 	
50 	/* this will cost gas on the blockchain 
51 	
52 	if(keccak256(answerHash) == keccak256(correctAnswerHash)) {
53 	this.correctAnswer = true;
54 	}
55 	
56 	*/
57 	
58 	if(keccak256(abi.encode(answerHash)) == keccak256(abi.encode(correctAnswerHash)))  {
59 	return true;
60 	}
61 	
62 	return false;
63 	
64 	}
65 	
66 	/* functinon to pay the correct recipients requires the owner to send*/
67 	
68 	function sendEtherToWinner(address payable recipient, uint amount) public payable onlyOwner() {
69 		recipient.transfer(amount);
70 	}
71 	
72 	/* gets the start time*/
73 	function get_startdate() public view  returns (uint256) {
74         return startdate;
75     }
76 	
77 	/* gets the time end*/
78 	function get_enddate() public view  returns (uint256) {
79         return enddate;
80     }
81 	
82 	/* gets the question id */
83 	
84 	function get_Id() public pure  returns (int) {
85         return question_id;
86     }
87 	
88 	function get_answer_hash() public view  returns (string memory) {
89         return string(correctAnswerHash);
90     }
91 	
92 	function getSha256(string memory input) public pure returns (bytes32) {
93 
94         bytes32 hash = sha256(abi.encodePacked(input));
95 
96         return (hash);
97     }
98 	
99 }