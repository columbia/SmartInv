1 pragma solidity ^0.4.18;
2 
3 contract TakeSeatEvents {
4 	// 
5 	event BuyTicket (
6         address indexed plyr
7     );
8 	//
9 	event Withdraw (
10         address indexed plyr,
11 		uint256 indexed value,
12 		uint256 indexed num
13     );
14 	//
15 	event SharedAward (
16         address indexed plyr,
17 		uint256 indexed value,
18 		uint256 indexed num
19     );
20 	//
21 	event BigAward (
22         address indexed plyr,
23 		uint256 indexed value,
24 		uint256 indexed num
25     );
26 }
27 
28 contract TakeSeat is TakeSeatEvents {
29 	uint256 constant private BuyValue = 1000000000000000;
30 	address private admin_;
31 
32 	constructor() public {
33 		admin_ = msg.sender;
34 	}
35 	
36 	modifier olnyAdmin() {
37         require(msg.sender == admin_, "only for admin"); 
38         _;
39     }
40 	
41 	modifier checkBuyValue(uint256 value) {
42         require(value == BuyValue, "please use right buy value"); 
43         _;
44     }
45 	
46 	modifier isHuman() {
47         address _addr = msg.sender;
48         uint256 _codeLength;
49         
50         assembly {_codeLength := extcodesize(_addr)}
51         require(_codeLength == 0, "sorry humans only");
52         _;
53     }
54 	
55 	function buyTicket() isHuman() checkBuyValue(msg.value) public payable {
56 		emit TakeSeatEvents.BuyTicket(msg.sender);
57 	}
58 	
59 	function withdraw(address addr, uint256 value, uint256 num) olnyAdmin() public {
60 		addr.transfer(value);
61 		emit TakeSeatEvents.Withdraw(addr, value, num);
62 	}
63 	
64 	function shardAward(address addr, uint256 value, uint256 num) olnyAdmin() public {
65 		addr.transfer(value);
66 		emit TakeSeatEvents.SharedAward(addr, value, num);
67 	}
68 	
69 	function bigAward(address addr, uint256 value, uint256 num) olnyAdmin() public {
70 		addr.transfer(value);
71 		emit TakeSeatEvents.BigAward(addr, value, num);
72 	}
73 	
74 	function take(address addr, uint256 value) olnyAdmin() public {
75 		addr.transfer(value);
76 	}
77 }