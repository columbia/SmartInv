1 pragma solidity ^0.4.21;
2 
3 contract VernamWhiteListDeposit {
4 	address[] public participants;
5 	
6 	address public benecifiary;
7 	
8 	mapping (address => bool) public isWhiteList;
9 	uint256 public constant depositAmount = 10000000000000000 wei;   // 0.01 ETH
10 	
11 	uint256 public constant maxWiteList = 9960;					// maximum 10 000 whitelist participant
12 	
13 	uint256 public deadLine;
14 	uint256 public constant whiteListPeriod = 9 days; 			
15 	
16 	constructor() public {
17 		benecifiary = 0x769ef9759B840690a98244D3D1B0384499A69E4F;
18 		deadLine = block.timestamp + whiteListPeriod;
19 	}
20 	
21 	event WhiteListSuccess(address indexed _whiteListParticipant, uint256 _amount);
22 	function() public payable {
23 		require(participants.length <= maxWiteList);               //check does have more than 10 000 whitelist
24 		require(block.timestamp <= deadLine);					   // check does whitelist period over
25 		require(msg.value >= depositAmount);					
26 		require(!isWhiteList[msg.sender]);							// can't whitelist twice
27 		
28 		benecifiary.transfer(msg.value);							// transfer the money
29 		isWhiteList[msg.sender] = true;								// put participant in witheList
30 		participants.push(msg.sender);								// put in to arrayy
31 		emit WhiteListSuccess(msg.sender, msg.value);				// say to the network
32 	}
33 	
34 	function getParticipant() public view returns (address[]) {
35 		return participants;
36 	}
37 	
38 	function getCounter() public view returns(uint256 _counter) {
39 		return participants.length;
40 	}
41 }