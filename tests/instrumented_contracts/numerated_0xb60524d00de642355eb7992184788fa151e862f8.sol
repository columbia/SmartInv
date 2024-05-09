1 pragma solidity 0.4.24;
2 
3 contract StarRocket
4 {
5     using SafeMath for *;
6 
7     address public master;
8 
9     mapping(uint256 => mapping(uint256 => uint256)) results;
10 
11     bool public paused = false;
12 
13     constructor() public {
14         master = msg.sender;
15     }
16 
17     modifier whenPaused() {
18         require(paused);
19         _;
20     }
21 
22     modifier whenNotPaused() {
23         require(!paused);
24         _;
25     }
26 
27     modifier onlyMaster() {
28         require(msg.sender == master);
29         _;
30     }
31 
32     function pause() public whenNotPaused onlyMaster {
33         paused = true;
34     }
35 
36     function unpause() public whenPaused onlyMaster {
37         paused = false;
38     }
39 
40     function makeRandomResult(uint256 guessType, uint256 period, uint256 seed, uint256 maxNumber) onlyMaster
41     public returns (bool)  {
42         require(guessType > 0);
43         require(period > 0);
44         require(seed >= 0);
45         require(maxNumber > 0);
46         require(results[guessType][period] <= 0);
47         require(maxNumber <= 1000000);
48         uint256 random = (uint256(keccak256(abi.encodePacked(
49                 (block.timestamp).add
50                 (block.difficulty).add
51                 (guessType).add
52                 (period).add
53                 (seed)))) % maxNumber) + 1;
54         results[guessType][period] = random;
55         return true;
56     }
57 
58     function getResult(uint256 guessType, uint256 period)
59     public view returns (uint256){
60         require(guessType > 0);
61         require(period > 0);
62         require(results[guessType][period] > 0);
63         return results[guessType][period];
64     }
65 }
66 
67 library SafeMath {
68 
69     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
70         c = a + b;
71         require(c >= a);
72         return c;
73     }
74 }