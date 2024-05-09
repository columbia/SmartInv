1 // Verified using https://dapp.tools
2 
3 // hevm: flattened sources of src/RaceToNumber.sol
4 pragma solidity >=0.5.4 <0.6.0;
5 
6 ////// src/RaceToNumber.sol
7 /* pragma solidity ^0.5.4; */
8 
9 /**
10 * @title RaceToNumber
11 * @dev must have the password to play. Whoever calls the lucky transaction wins!
12 */
13 contract RaceToNumber {
14     bytes32 public constant passwordHash = 0xe6259607f8876d87cad42be003ee39649999430d825382960e3d25ca692d4fb0;
15     uint256 public constant callsToWin = 15;
16     uint256 public callCount;
17 
18     event Victory(
19         address winner,
20         uint payout
21     );
22 
23     function callMe(string memory password) public {
24         // check that user submitted the correct password
25         require(
26             keccak256(abi.encodePacked(password)) == passwordHash,
27             "incorrect password"
28         );
29 
30         // increment the call count
31         callCount++;
32 
33         // if we've reached the callsToWin, user wins!
34         if (callCount == callsToWin) {
35             callCount = 0;
36             uint payout = address(this).balance;
37             emit Victory(msg.sender, payout);
38             if (payout > 0) { 
39                 msg.sender.transfer(payout);
40             }
41         }
42     }
43 
44     // payable fallback so we can send in eth (the pot)
45     function () external payable {}
46 }
