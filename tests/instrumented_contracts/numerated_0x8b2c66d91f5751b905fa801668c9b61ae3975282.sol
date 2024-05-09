1 pragma solidity ^0.4.11;
2 
3 contract EthTermDeposits{
4  mapping(address => uint) public deposits;
5  mapping(address => uint) public depositEndTime;
6 	
7 	function EthTermDeposits(){
8 
9 	}
10 	/*
11 	 @notice Creates or updates a deposit that is available for withdrawal after the specified number of weeks.
12 	 @dev
13 	 @param numberOfWeeks The number of weeks for which the deposit is being locked. After the specified number of weeks the deposit amount is being unlocked and available for withdrawal. If a deposit with the same name exists it appends the numberOfWeeks to current deposit due time.
14 	 @returns True on successful deposit.
15 	*/
16 	function Deposit(uint8 numberOfWeeks) payable returns(bool){
17 		address owner = msg.sender;
18 		uint amount = msg.value;
19 		uint _time = block.timestamp + numberOfWeeks * 1 weeks;
20 
21 		if(deposits[owner] > 0){
22 			_time = depositEndTime[owner] + numberOfWeeks * 1 weeks;
23 		}
24 		depositEndTime[owner] = _time;
25 		deposits[owner] += amount;
26 		return true;
27 	}
28 
29 	/*
30 		@notice Withdraws due deposit.
31 	*/
32 
33 	function Withdraw() returns(bool){
34 		address owner = msg.sender;
35 		if(depositEndTime[owner] > 0 &&
36 		   block.timestamp > depositEndTime[owner] &&
37 		   deposits[owner] > 0){
38 			uint amount = deposits[owner];
39 			deposits[owner] = 0;
40 			msg.sender.transfer(amount);
41 			return true;
42 		}else{
43 			/* deposit unavailable for withdrawal or already withdrawn. */
44 			return false;
45 		}
46 	}
47 	function () {
48 		revert();
49 	}
50 }