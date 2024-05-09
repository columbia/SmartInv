1 pragma solidity ^0.4.16;
2 
3 /**
4 * Safe math library for division
5 **/
6 library SafeMath {
7 	function mul(uint256 a, uint256 b) internal returns (uint256) {
8 		uint256 c = a * b;
9 		assert(a == 0 || c / a == b);
10 		return c;
11   	}
12 
13   	function div(uint256 a, uint256 b) internal returns (uint256) {
14 		uint256 c = a / b;
15 		return c;
16   	}
17 
18 	function sub(uint256 a, uint256 b) internal returns (uint256) {
19 		assert(b <= a);
20 		return a - b;
21 	}
22 
23 	function add(uint256 a, uint256 b) internal returns (uint256) {
24 		 uint256 c = a + b;
25 		 assert(c >= a);
26 		 return c;
27 	}
28 }
29 
30 /**
31 * Contract that will split any incoming Ether to its creator
32 **/
33 contract Forwarder  {
34 	using SafeMath for uint256;
35 	// Addresses to which any funds sent to this contract will be forwarded
36 	address public destinationAddress80;
37 	address public destinationAddress20;
38 
39 	/**
40 	* Create the contract, and set the destination addresses
41 	**/
42 	function Forwarder() {
43 		// This is the escrow/ICO address for refunds
44 		destinationAddress20 = 0xf6962cfe3b9618374097d51bc6691efb3974d06f;
45 		// All other funds to be used per whitepaper guidelines
46 		destinationAddress80 = 0xf030541A54e89cB22b3653a090b233A209E44F38;
47 	}
48 
49 	/**
50 	* Default function; Gets called when Ether is deposited, and forwards it to destination addresses
51 	**/
52 	function () payable {
53 		if (msg.value > 0) {
54 			uint256 totalAmount = msg.value;
55 			uint256 tokenValueAmount = totalAmount.div(5);
56 			uint256 restAmount = totalAmount.sub(tokenValueAmount);
57 			if (!destinationAddress20.send(tokenValueAmount)) revert();
58 			if (!destinationAddress80.send(restAmount)) revert();
59 		}
60 	}
61 }