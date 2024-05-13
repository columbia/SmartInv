1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.5.16;
4 
5 import '../interfaces/IBabyERC20.sol';
6 import '../libraries/SafeMath.sol';
7 import './SafeBEP20.sol';
8 import './BEP20.sol';
9 
10 contract TokenLocker {
11     using SafeMath for uint256;
12 
13     ///@notice every block cast 3 seconds
14     uint256 public constant SECONDS_PER_BLOCK = 3;
15 
16     ///@notice the token to lock
17     IBEP20 public immutable token;
18 
19     ///@notice who will receive this token
20     address public immutable receiver;
21 
22     ///@notice the blockNum of last release, the init value would be the timestamp the contract created
23     uint256 public lastReleaseAt;
24 
25     ///@notice how many block must be passed before next release
26     uint256 public immutable interval;
27 
28     ///@notice the amount of one release time
29     uint256 public immutable releaseAmount;
30 
31     ///@notice the total amount till now
32     uint256 public totalReleasedAmount;
33 
34     constructor(
35         address _token, address _receiver, uint256 _intervalSeconds, uint256 _releaseAmount
36     ) {
37         require(_token != address(0), "illegal token");
38         token = IBEP20(_token);
39         receiver = _receiver; 
40         //lastReleaseAt = block.number;
41         require(_intervalSeconds > SECONDS_PER_BLOCK, 'illegal interval');
42         uint256 interval_ = _intervalSeconds.add(SECONDS_PER_BLOCK).sub(1).div(SECONDS_PER_BLOCK);
43         interval = interval_;
44         uint256 lastReleaseAt_ = block.number.sub(interval_);
45         lastReleaseAt = lastReleaseAt_;
46         require(_releaseAmount > 0, 'illegal releaseAmount');
47         releaseAmount = _releaseAmount;
48     }
49 
50     function getClaimInfo() internal view returns (uint256, uint256) {
51         uint currentBlockNum = block.number;
52         uint intervalBlockNum = currentBlockNum - lastReleaseAt;
53         if (intervalBlockNum < interval) {
54             return (0, 0);
55         }
56         uint times = intervalBlockNum.div(interval);
57         uint amount = releaseAmount.mul(times);
58         if (token.balanceOf(address(this)) < amount) {
59             amount = token.balanceOf(address(this));
60         }
61         return (amount, times);
62     }
63 
64     function claim() external {
65         (uint amount, uint times) = getClaimInfo();
66         if (amount == 0 || times == 0) {
67             return;
68         }
69         lastReleaseAt = lastReleaseAt.add(interval.mul(times));
70         totalReleasedAmount = totalReleasedAmount.add(amount);
71         SafeBEP20.safeTransfer(token, receiver, amount);
72     }
73 
74     ///@notice return the amount we can claim now, and the next timestamp we can claim next time
75     function lockInfo() external view returns (uint256 amount, uint256 timestamp) {
76         (amount, ) = getClaimInfo();
77         if (amount == 0) {
78             timestamp = block.timestamp.add(interval.sub(block.number.sub(lastReleaseAt)).mul(SECONDS_PER_BLOCK));
79         }
80     }
81 }
