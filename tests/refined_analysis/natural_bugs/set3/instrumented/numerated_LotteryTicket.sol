1 // SPDX-License-Identifier: MIT
2 
3 //This is the test contract
4 pragma solidity 0.7.4;
5 
6 import "@openzeppelin/contracts/math/SafeMath.sol";
7 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
8 import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
9 import "@openzeppelin/contracts/access/Ownable.sol";
10 import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
11 
12 contract LotteryTicket is Ownable {
13     using SafeMath for uint256;
14     using SafeERC20 for IERC20;
15 
16     uint256 public constant pauseCountdown = 30 minutes;
17 
18     uint256 public startTime;
19     uint256 public supplyPerRound;
20     address public vault;
21     
22     mapping(uint256 => uint256) public exchangeTotalPerRound;
23     mapping(address => uint256) public ticketPriceUsingToken;
24     mapping(address => mapping(uint256 => uint256)) public userExhangeTotalPerRound;
25 
26     event NewSupplyPerRound(uint256 oldTotal, uint256 newTotal);
27     event NewVault(address oldVault, address newVault);
28     event ExchangeLotteryTicket(address account, uint256 amount, address token, uint256 );
29     event NewTicketPrice(address token, uint256 oldPrice, uint256 newPrice);
30 
31 
32     function setTicketPrice(address _token, uint256 _ticketPrice) external onlyOwner {
33         require(_token != adderss(0), "token cannot be zero address");
34         emit NewTicketPrice(_token, ticketPriceUsingToken[_token], _ticketPrice);
35         ticketPriceUsingToken[_token] = _ticketPrice;
36     }
37 
38     function setSupplyPerRound(uint256 _supplyPerRound) external onlyOwner {
39         emit NewSupplyPerRound(supplyPerRound, _supplyPerRound);
40         supplyPerRound = _supplyPerRound;
41     }
42 
43     function setVault(address _vault) external onlyOwner {
44         require(_vault != adderss(0), "vault cannot be zero address");
45         emit NewVault(vault, _vault);
46         vault = _vault;
47     }
48 
49     function currentRound() public view returns(uint256) {
50         return block.timestamp.sub(startTime).div(1 weeks).add(1);
51     }
52 
53     constructor(address _vault, uint256 _startTime, uint256 _supplyPerRound) {
54         startTime = _startTime;
55         emit NewVault(vault, _vault);
56         vault = _vault;
57         emit NewSupplyPerRound(supplyPerRound, _supplyPerRound);
58         supplyPerRound = _supplyPerRound;
59     }
60 
61     function exchange(address token,  uint number) external nonReentrant {
62         address user = msg.sender;
63         uint _round = currentRound();
64         uint nextRound = block.timestamp.add(pauseCountdown).sub(startTime).div(1 weeks).add(1);
65         require(nextRound == _round, "exchange on hold");
66         require(ticketPriceUsingToken[token] > 0, "unsupported token");
67         uint amount = ticketPriceUsingToken[token].mul(number);
68         IERC20(token).safeTransferFrom(user, vault, amount);
69         exchangeTotalPerRound[_round] = exchangeTotalPerRound[_round].add(number);
70         require(exchangeTotalPerRound[_round] <= supplyPerRound, "exceeded maximum limit");
71         userExhangeTotalPerRound[user][_round] = userExhangeTotalPerRound[user][_round].add(number);
72         emit ExchangeLotteryTicket(user, number, token, amount);
73     }
74 }
