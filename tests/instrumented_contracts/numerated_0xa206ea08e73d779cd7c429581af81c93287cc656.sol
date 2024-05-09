1 pragma solidity ^0.4.20;
2 
3 contract hurra {
4     /* This creates an array with all licenses */
5     mapping (address => uint256) public licensesOf;  // all customer that have or had have a license
6 
7     address owner;										// Creator of this contract
8 
9     /* Initializes contract with maximum number of licenses to the creator of the contract */
10     constructor  (uint256 maxLicenses ) public {
11 		
12         licensesOf[msg.sender] = maxLicenses;              // Initial give the creator all licenses
13         owner = msg.sender;                                 // creator is owner
14     }
15 
16     /* Transfer license to customer account */
17 	/* Later, this function can be only called by creator of contract */
18     function transfer(address _to, uint256 _value) public returns (bool success) {
19 		require(msg.sender == owner);                        // only oner is allowed to call this function
20         require(licensesOf[msg.sender] >= _value);           // Check if the sender has enough
21         require(licensesOf[_to] + _value >= licensesOf[_to]); // Check for overflows
22         licensesOf[msg.sender] -= _value;                    // Subtract from owner
23         licensesOf[_to] += _value;                           // Add the same to the recipient
24         return true;
25     }
26 	
27     /* Burn license from customer account */
28 	/* Later, this function can be only called by creator of contract */
29     function burn(address _from, uint256 _value) public returns (bool success) {
30  		require(msg.sender == owner);                        // only oner is allowed to call this function
31         require(licensesOf[_from] >= _value);           // Check if the sender has enough
32         require(licensesOf[msg.sender] + _value >= licensesOf[_from]); // Check for overflows
33         licensesOf[msg.sender] += _value;                    // add to owner
34         licensesOf[_from] -= _value;                           // subtract from customer
35         return true;
36     }
37 	
38 	function deleteThisContract() public {
39 		require(msg.sender == owner);                        // only oner is allowed to call this function
40 		selfdestruct(msg.sender);								// destroy contract and send ether back to owner
41 																// no action allowed after this
42 	}
43 	
44 	
45 	
46 }