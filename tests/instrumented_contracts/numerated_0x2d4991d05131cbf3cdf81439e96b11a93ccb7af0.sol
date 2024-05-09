1 pragma solidity ^0.4.4;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() {
21     owner = msg.sender;
22   }
23 
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) onlyOwner public {
39     require(newOwner != address(0));
40     OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 }
44 
45 contract GoFreakingDoIt is Ownable {
46     struct Goal {
47     	bytes32 hash;
48         address owner; // goal owner addr
49         string description; // set goal description
50         uint amount; // set goal amount
51         string supervisorEmail; // email of friend
52         string creatorEmail; // email of friend
53         string deadline;
54         bool emailSent;
55         bool completed;
56     }
57 
58     // address owner;
59 	mapping (bytes32 => Goal) public goals;
60 	Goal[] public activeGoals;
61 
62 	// Events
63     event setGoalEvent (
64     	address _owner,
65         string _description,
66         uint _amount,
67         string _supervisorEmail,
68         string _creatorEmail,
69         string _deadline,
70         bool _emailSent,
71         bool _completed
72     );
73 
74     event setGoalSucceededEvent(bytes32 hash, bool _completed);
75     event setGoalFailedEvent(bytes32 hash, bool _completed);
76 
77 	// app.setGoal("Finish cleaning", "hello@karolisram.com", "hello@karolisram.com", "2017-12-12", {value: web3.toWei(11.111, 'ether')})
78 	// app.setGoal("Finish cleaning", "hello@karolisram.com", "hello@karolisram.com", "2017-12-12", {value: web3.toWei(11.111, 'ether'), from: web3.eth.accounts[1]})
79 	function setGoal(string _description, string _supervisorEmail, string _creatorEmail, string _deadline) payable returns (bytes32, address, string, uint, string, string, string) {
80 		require(msg.value > 0);
81 		require(keccak256(_description) != keccak256(''));
82 		require(keccak256(_creatorEmail) != keccak256(''));
83 		require(keccak256(_deadline) != keccak256(''));
84 
85 		bytes32 hash = keccak256(msg.sender, _description, msg.value, _deadline);
86 
87 		Goal memory goal = Goal({
88 			hash: hash,
89 			owner: msg.sender,
90 			description: _description,
91 			amount: msg.value,
92 			supervisorEmail: _supervisorEmail,
93 			creatorEmail: _creatorEmail,
94 			deadline: _deadline,
95 			emailSent: false,
96 			completed: false
97 		});
98 
99 		goals[hash] = goal;
100 		activeGoals.push(goal);
101 
102 		setGoalEvent(goal.owner, goal.description, goal.amount, goal.supervisorEmail, goal.creatorEmail, goal.deadline, goal.emailSent, goal.completed);
103 
104 		return (hash, goal.owner, goal.description, goal.amount, goal.supervisorEmail, goal.creatorEmail, goal.deadline);
105 	}
106 
107 	function getGoalsCount() constant returns (uint count) {
108 	    return activeGoals.length;
109 	}
110 
111 	// app.setEmailSent("0x00f2484d16ad04b395c6261b978fb21f0c59210d98e9ac361afc4772ab811393", {from: web3.eth.accounts[1]})
112 	function setEmailSent(uint _index, bytes32 _hash) onlyOwner {
113 		assert(goals[_hash].amount > 0);
114 
115 		goals[_hash].emailSent = true;
116 		activeGoals[_index].emailSent = true;
117 	}
118 
119 	function setGoalSucceeded(uint _index, bytes32 _hash) onlyOwner {
120 		assert(goals[_hash].amount > 0);
121 
122 		goals[_hash].completed = true;
123 		activeGoals[_index].completed = true;
124 
125 		goals[_hash].owner.transfer(goals[_hash].amount); // send ether back to person who set the goal
126 
127 		setGoalSucceededEvent(_hash, true);
128 	}
129 
130 	// app.setGoalFailed(0, '0xf7a1a8aa52aeaaaa353ab49ab5cd735f3fd02598b4ff861b314907a414121ba4')
131 	function setGoalFailed(uint _index, bytes32 _hash) {
132 		assert(goals[_hash].amount > 0);
133 		// assert(goals[_hash].emailSent == true);
134 
135 		goals[_hash].completed = false;
136 		activeGoals[_index].completed = false;
137 
138 		owner.transfer(goals[_hash].amount); // send ether to contract owner
139 
140 		setGoalFailedEvent(_hash, false);
141 	}
142 
143 	// Fallback function in case someone sends ether to the contract so it doesn't get lost
144 	function() payable {}
145 
146     function kill() onlyOwner { 
147     	selfdestruct(owner);
148     }
149 }