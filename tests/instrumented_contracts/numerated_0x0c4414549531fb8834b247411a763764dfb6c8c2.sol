1 pragma solidity ^0.4.10;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract Crowdsale {
34 
35 	using SafeMath for uint256;
36 
37 	address public owner;
38 	address public multisig;
39 	uint256 public totalRaised;
40 	uint256 public constant hardCap = 20000 ether;
41 	mapping(address => bool) public whitelist;
42 
43 	modifier isWhitelisted() {
44 		require(whitelist[msg.sender]);
45 		_;
46 	}
47 
48 	modifier onlyOwner() {
49 		require(msg.sender == owner);
50 		_;
51 	}
52 
53 	modifier belowCap() {
54 		require(totalRaised < hardCap);
55 		_;
56 	}
57 
58 	function Crowdsale(address _multisig) {
59 		require (_multisig != 0);
60 		owner = msg.sender;
61 		multisig = _multisig;
62 	}
63 
64 	function whitelistAddress(address _user) onlyOwner {
65 		whitelist[_user] = true;
66 	}
67 
68 	function whitelistAddresses(address[] _users) onlyOwner {
69 		for (uint i = 0; i < _users.length; i++) {
70 			whitelist[_users[i]] = true;
71 		}
72 	}
73 	
74 	function() payable isWhitelisted belowCap {
75 		totalRaised = totalRaised.add(msg.value);
76 		uint contribution = msg.value;
77 		if (totalRaised > hardCap) {
78 			uint refundAmount = totalRaised.sub(hardCap);
79 			msg.sender.transfer(refundAmount);
80 			contribution = contribution.sub(refundAmount);
81 			refundAmount = 0;
82 			totalRaised = hardCap;
83 		}
84 		multisig.transfer(contribution);
85 	}
86 
87 	function withdrawStuck() onlyOwner {
88 		multisig.transfer(this.balance);
89 	}
90 
91 }