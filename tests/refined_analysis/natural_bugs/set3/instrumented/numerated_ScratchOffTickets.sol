1 // SPDX-License-Identifier: MIT
2 
3 //This is the test contract
4 pragma solidity 0.7.4;
5 
6 import "@openzeppelin/contracts/math/SafeMath.sol";
7 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
8 import "@openzeppelin/contracts/access/Ownable.sol";
9 import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
10 
11 contract ScratchOffTickets is Ownable,ReentrancyGuard {
12     using SafeMath for uint256;
13     
14     uint256 public constant pauseCountdown = 1 hours;
15 
16     address public verifier;
17     mapping(address => uint256) public exhangeTotalPerUser;
18     uint256 public startTime;
19     uint256 public supplyPerRound;
20     uint256 public ticketPrice;
21     mapping(uint256 => uint256) public exhangeTotalPerRound;
22 
23     event NewSupplyPerRound(uint256 oldTotal, uint256 newTotal);
24     event NewVerifier(address oldVerifier, address newVerifier);
25     event ExchangeScratchOff(address account, uint256 amount);
26     event NewTicketPrice(uint256 oldPrice, uint256 newPrice);
27 
28     function setVerifier(address _verifier) external onlyOwner {
29         emit NewVerifier(verifier, _verifier);
30         verifier = _verifier;
31     }
32 
33     function setTicketPrice(uint256 _ticketPrice) external onlyOwner {
34         emit NewTicketPrice(ticketPrice, _ticketPrice);
35         ticketPrice = _ticketPrice;
36     }
37 
38     function setSupplyPerRound(uint256 _supplyPerRound) external onlyOwner {
39         emit NewSupplyPerRound(supplyPerRound, _supplyPerRound);
40         supplyPerRound = _supplyPerRound;
41     }
42 
43     function currentRound() public view returns(uint256) {
44         return block.timestamp.sub(startTime).div(1 weeks).add(1);
45     }
46 
47     constructor(uint256 _ticketPrice, uint256 _startTime, uint256 _supplyPerRound, address _verifier) {
48         startTime = _startTime;
49         emit NewTicketPrice(ticketPrice, _ticketPrice);
50         ticketPrice = _ticketPrice;
51         emit NewSupplyPerRound(supplyPerRound, _supplyPerRound);
52         supplyPerRound = _supplyPerRound;
53         emit NewVerifier(verifier, _verifier);
54         verifier = _verifier;
55     }
56 
57     function getEncodePacked(address user, uint balance) public pure returns (bytes memory) {
58         return abi.encodePacked(user, balance);
59     }
60 
61     function getHash(address user, uint balance) external pure returns (bytes32) {
62         return keccak256(abi.encodePacked(user, balance));
63     }
64 
65     function getHashToSign(address user, uint balance) external pure returns (bytes32) {
66         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(abi.encodePacked(user, balance))));
67     }
68 
69     function verify(address user, uint balance, uint8 v, bytes32 r, bytes32 s) public view returns (bool) {
70         return ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(abi.encodePacked(user, balance)))), v, r, s) == verifier;
71     }
72 
73     function exchange(uint balance, uint number, uint8 v, bytes32 r, bytes32 s) external {
74         address user = msg.sender;
75         require(verify(user, balance, v, r, s), "illegal verifier");
76         uint _round = currentRound();
77         uint nextRound = block.timestamp.add(pauseCountdown).sub(startTime).div(1 weeks).add(1);
78         require(nextRound == _round, "exchange on hold");
79         uint amount = ticketPrice.mul(number);
80         exhangeTotalPerRound[_round] = exhangeTotalPerRound[_round].add(number);
81         require(exhangeTotalPerRound[_round] <= supplyPerRound, "exceeded maximum limit");
82         require(exhangeTotalPerUser[user].add(amount) <= balance, "insufficient balance");
83         exhangeTotalPerUser[user] = exhangeTotalPerUser[user].add(amount);
84         emit ExchangeScratchOff(user, number);
85     }
86 }
