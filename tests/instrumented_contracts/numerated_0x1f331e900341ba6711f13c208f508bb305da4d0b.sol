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
14 }
15 
16 contract TakeSeat is TakeSeatEvents {
17 	uint256 constant private BuyValue = 1000000000000000000;
18 	address private admin_;
19 
20 	constructor() public {
21 		admin_ = msg.sender;
22 	}
23 	
24 	modifier olnyAdmin() {
25         require(msg.sender == admin_, "only for admin"); 
26         _;
27     }
28 	
29 	modifier checkBuyValue(uint256 value) {
30         require(value == BuyValue, "please use right buy value"); 
31         _;
32     }
33 	
34 	modifier isHuman() {
35         address _addr = msg.sender;
36         uint256 _codeLength;
37         
38         assembly {_codeLength := extcodesize(_addr)}
39         require(_codeLength == 0, "sorry humans only");
40         _;
41     }
42 	
43 	function buyTicket() isHuman() checkBuyValue(msg.value) public payable {
44 		emit TakeSeatEvents.BuyTicket(msg.sender);
45 	}
46 	
47 	function withdraw(address addr, uint256 value, uint256 num) olnyAdmin() public {
48 		addr.transfer(value);
49 		emit TakeSeatEvents.Withdraw(addr, value, num);
50 	}
51 }