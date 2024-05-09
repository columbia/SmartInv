1 pragma solidity 0.5.4;
2 
3 interface IDGTXToken {
4     function transfer(address to, uint value) external returns (bool);
5     function balanceOf(address) external view returns (uint256);
6 }
7 
8 
9 interface ITreasury {
10     function phaseNum() external view returns (uint256);
11 }
12 
13 contract Treasury is ITreasury {
14     address public sale;
15     address public token;
16     uint256 internal constant SINGLE_RELEASE_AMOUNT = 1e25;
17 
18     uint256 public phaseNum;
19     uint256[] public phases = [
20         1551448800, //1 March 2019 14:00 (GMT)
21         1559397600, //1 June 2019 14:00 (GMT)
22         1567346400, //1 September 2019 14:00 (GMT)
23         1575208800, //1 December 2019 14:00 (GMT)
24         1583071200, //1 March 2020 14:00 (GMT)
25         1591020000, //1 June 2020 14:00 (GMT)
26         1598968800, //1 September 2020 14:00 (GMT)
27         1606831200, //1 December 2020 14:00 (GMT)
28         1614607200, //1 March 2021 14:00 (GMT)
29         1622556000  //1 June 2021 14:00 (GMT)
30     ];
31 
32     event PhaseStarted(uint256 newPhaseNum);
33 
34     constructor(address _token, address _sale) public {
35         require(_token != address(0) && _sale != address(0));
36 
37         token = _token;
38         sale = _sale;
39     }
40 
41     function tokenFallback(address, uint, bytes calldata) external {
42         require(msg.sender == token);
43         require(phaseNum == 0);
44         require(IDGTXToken(token).balanceOf(address(this)) == SINGLE_RELEASE_AMOUNT * 10);
45     }
46 
47     function startNewPhase() external {
48         require(now >= phases[phaseNum]);
49 
50         phaseNum += 1;
51 
52         require(IDGTXToken(token).transfer(sale, SINGLE_RELEASE_AMOUNT));
53 
54         emit PhaseStarted(phaseNum);
55     }
56 }