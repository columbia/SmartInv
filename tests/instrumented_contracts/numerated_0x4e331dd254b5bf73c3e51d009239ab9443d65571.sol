1 pragma solidity ^0.4.0;
2 
3 // Affiliate deposit contract for https://game-eth.com
4 // game contract address = 0xbd2BD1bD6396E69112D1f51Cbaa57842cd1586C4
5 // GameEthAffiliateContract transfer some % to affiliate owner address, and remaining sum transfer to game
6 
7 contract GameEthAffiliateContract{
8 
9 address gameContract;
10 address affiliateAddress; 
11 uint256 affiliatePercent;
12 uint256 minWeiDeposit = 40000000000000000; // default 0.04 ether
13 
14 	constructor(address _gameContract, address _affiliateAddress, uint256 _affiliatePercent) public {
15 		gameContract = _gameContract;
16 		require (_affiliatePercent>=0 && _affiliatePercent <=3); // check affiliate percent range
17 		affiliateAddress = _affiliateAddress;
18 		affiliatePercent = _affiliatePercent;
19 		
20 	}
21 	
22 	function () public payable{
23 		uint256 affiliateCom = msg.value/100*affiliatePercent; // affiliate % commission
24 		uint256 amount = msg.value - affiliateCom; // deposit amount is amount - commission
25 		require(amount >= minWeiDeposit);
26 		if (!gameContract.call.value(amount)(bytes4(keccak256("depositForRecipent(address)")), msg.sender)){
27 			revert();
28 		}
29 		affiliateAddress.transfer(affiliateCom); // transfer affiliate commission
30 	}
31 	
32 	// change affiliateAddress
33 	// only affiliate commission receiver can change affiliate address
34 	function changeAffiliate(address _affiliateAddress, uint256 _affiliatePercent) public {
35 		require (msg.sender == affiliateAddress); // check is message sender is current affiliate commission receiver 
36 		require (_affiliatePercent>=0 && _affiliatePercent <=3); // check affiliate percent range
37 		affiliateAddress =  _affiliateAddress;
38 		affiliatePercent = _affiliatePercent;
39 		
40 	}
41 
42 }