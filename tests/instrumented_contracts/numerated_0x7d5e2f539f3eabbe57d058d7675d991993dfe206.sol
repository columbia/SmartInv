1 pragma solidity >=0.4.22 <0.6.0;
2 contract Bounty {
3     uint public counter = 0;
4     uint public currentNumber = 1;
5     string internal base64this;
6     mapping(address => bool) internal winners; 
7     
8     constructor(string memory _base64) public {
9         base64this = _base64;
10     }
11     
12     function claim(uint guessCurrentNumber, uint setNextNumber) public {
13         require(counter < 10, "All prizes collected");
14         require(winners[msg.sender] == false, "Cannot participate twice. But feel free to sybil us");
15         require(currentNumber == guessCurrentNumber);
16         currentNumber = setNextNumber;
17         counter += 1;
18         winners[msg.sender] = true;
19     }
20     
21     function getPrize() public view returns (string memory){
22         require(winners[msg.sender]);
23         return base64this;
24     }
25     
26     function isWinner(address _address) public view returns(bool){
27         return winners[_address];
28     }
29     
30 }