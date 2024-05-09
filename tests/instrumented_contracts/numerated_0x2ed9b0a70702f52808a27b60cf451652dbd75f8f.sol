1 pragma solidity ^0.4.18;
2 
3 
4  /// @title Ownable contract - base contract with an owner
5 contract Ownable {
6   address public owner;
7 
8   function Ownable() public {
9     owner = msg.sender;
10   }
11 
12   modifier onlyOwner() {
13     require(msg.sender == owner);
14     _;
15   }
16 
17   function transferOwnership(address newOwner) public onlyOwner {
18     if (newOwner != address(0)) {
19       owner = newOwner;
20     }
21   }
22 }
23 
24 
25  /// @title ERC20 interface see https://github.com/ethereum/EIPs/issues/20
26 contract ERC20 {
27   uint public totalSupply;
28   function balanceOf(address who) public constant returns (uint);
29   function allowance(address owner, address spender) public constant returns (uint);
30   function transfer(address to, uint value) public returns (bool ok);
31   function transferFrom(address from, address to, uint value) public returns (bool ok);
32   function approve(address spender, uint value) public returns (bool ok);
33   function decimals() public constant returns (uint);
34   event Transfer(address indexed from, address indexed to, uint value);
35   event Approval(address indexed owner, address indexed spender, uint value);
36 }
37 
38 
39 /*
40 The SilentNotary Smart-Contract is specifically developed and designed to provide users 
41 the opportunity to fix any fact of evidence in a variety of many digital forms, including 
42 but not limited: photo, video, sound recording, chat, multi-user chat by uploading hash of 
43 the User’s data to the Ethereum blockchain.
44 */
45 /// @title SilentNotary contract - store SHA-384 file hash in blockchain
46 contract SilentNotary is Ownable {
47 	uint public price;
48 	ERC20 public token;
49 
50 	struct Entry {
51 		uint blockNumber;
52 		uint timestamp;
53 	}
54 
55 	mapping (bytes32 => Entry) public entryStorage;
56 
57 	event EntryAdded(bytes32 hash, uint blockNumber, uint timestamp);
58 	event EntryExistAlready(bytes32 hash, uint timestamp);
59 
60 	/// Fallback method
61 	function () public {
62 	  	// If ether is sent to this address, send it back
63 	  	revert();
64 	}
65 
66 	/// @dev Set price in SNTR tokens for storing
67 	/// @param _price price in SNTR tokens
68 	function setRegistrationPrice(uint _price) public onlyOwner {
69 		price = _price;
70 	}
71 
72 	/// @dev Set SNTR token address
73 	/// @param _token Address SNTR tokens contract
74 		function setTokenAddress(address _token) public onlyOwner {
75 		    token = ERC20(_token);
76 	}
77 
78 	/// @dev Register file hash in contract, web3 integration
79 	/// @param hash SHA-256 file hash
80 	function makeRegistration(bytes32 hash) onlyOwner public {
81 			makeRegistrationInternal(hash);
82 	}
83 
84 	/// @dev Payable registration in SNTR tokens
85 	/// @param hash SHA-256 file hash
86 	function makePayableRegistration(bytes32 hash) public {
87 		address sender = msg.sender;
88 	    uint allowed = token.allowance(sender, owner);
89 	    assert(allowed >= price);
90 
91 	    if(!token.transferFrom(sender, owner, price))
92           revert();
93 			makeRegistrationInternal(hash);
94 	}
95 
96 	/// @dev Internal registation method
97 	/// @param hash SHA-256 file hash
98 	function makeRegistrationInternal(bytes32 hash) internal {
99 			uint timestamp = now;
100 	    // Checks documents isn't already registered
101 	    if (exist(hash)) {
102 	        EntryExistAlready(hash, timestamp);
103 	        revert();
104 	    }
105 	    // Registers the proof with the timestamp of the block
106 	    entryStorage[hash] = Entry(block.number, timestamp);
107 	    // Triggers a EntryAdded event
108 	    EntryAdded(hash, block.number, timestamp);
109 	}
110 
111 	/// @dev Check hash existance
112 	/// @param hash SHA-256 file hash
113 	/// @return Returns true if hash exist
114 	function exist(bytes32 hash) internal constant returns (bool) {
115 	    return entryStorage[hash].blockNumber != 0;
116 	}
117 }