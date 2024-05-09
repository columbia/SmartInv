1 /**
2  * Ludum - mean "For gaming" in Latin. Play, earn, live full of life. In Game.
3  * LDM will show you new generation of Gaming.
4  * LDM is in-game cyrrency of Privateers.Life game.
5  * https://privateers.life
6  */
7 
8 
9 pragma solidity ^0.4.18;
10 
11 
12 contract Ownable {
13 
14 	address public owner;
15 
16 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17 
18 	function Ownable() public {
19 		owner = msg.sender;
20 	}
21 
22 	modifier onlyOwner() {
23 		require(msg.sender == owner);
24 		_;
25 	}
26 
27 	function transferOwnership(address newOwner) public onlyOwner {
28 		require(newOwner != address(0));
29 		OwnershipTransferred(owner, newOwner);
30 		owner = newOwner;
31 	}
32 
33 }
34 
35 
36 interface Token {
37 
38 	function transfer(address _to, uint256 _value) public returns (bool);
39 	function balanceOf(address _owner) public constant returns (uint256 balance);
40 
41 }
42 
43 
44 contract LudumAirdrop is Ownable {
45 
46 	Token token;
47 
48 	event TransferredToken(address indexed to, uint256 value);
49 	event FailedTransfer(address indexed to, uint256 value);
50 
51 	modifier whenDropIsActive() {
52 		assert(isActive());
53 		_;
54 	}
55 
56 	function LudumAirdrop () public {
57 	    address _tokenAddr = 0x28a40acF39b1D3C932f42dD8068ad00A5Ad6448F;
58 	    token = Token(_tokenAddr);
59 	}
60 
61 	function isActive() public constant returns (bool) {
62 		return (
63 			tokensAvailable() > 0 // Tokens must be available to send
64 		);
65 	}
66 
67 	//below function can be used when you want to send every recipeint with different number of tokens
68 	function sendLudumToMany(address[] dests, uint256[] values) whenDropIsActive onlyOwner external {
69 		uint256 i = 0;
70 		while (i < dests.length) {
71 			//uint256 toSend = values[i] * 10**18;
72 			uint256 toSend = values[i];
73 			sendInternally(dests[i] , toSend, values[i]);
74 			i++;
75 		}
76 	}
77 
78 	// this function can be used when you want to send same number of tokens to all the recipients
79 	function sendLudumToSingle(address[] dests, uint256 value) whenDropIsActive onlyOwner external {
80 		uint256 i = 0;
81 		//uint256 toSend = value * 10**18;
82 		uint256 toSend = value;
83 		while (i < dests.length) {
84 			sendInternally(dests[i] , toSend, value);
85 			i++;
86 		}
87 	}  
88 
89 	function sendInternally(address recipient, uint256 tokensToSend, uint256 valueToPresent) internal {
90 		if(recipient == address(0)) return;
91 
92 		if(tokensAvailable() >= tokensToSend) {
93 			token.transfer(recipient, tokensToSend);
94 			TransferredToken(recipient, valueToPresent);
95 		} else {
96 			FailedTransfer(recipient, valueToPresent); 
97 		}
98 	}   
99 
100 
101 	function tokensAvailable() public constant returns (uint256) {
102 		return token.balanceOf(this);
103 	}
104 
105 	function sendRemainsToOwner() public onlyOwner {
106 		uint256 balance = tokensAvailable();
107 		require (balance > 0);
108 		token.transfer(owner, balance);
109 		//selfdestruct(owner);
110 	}
111 
112 }