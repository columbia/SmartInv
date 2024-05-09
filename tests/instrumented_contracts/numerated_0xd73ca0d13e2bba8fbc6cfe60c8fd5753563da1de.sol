1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 /**
26  * @dev Contract module which provides a basic access control mechanism, where
27  * there is an account (an owner) that can be granted exclusive access to
28  * specific functions.
29  *
30  * By default, the owner account will be the one that deploys the contract. This
31  * can later be changed with {transferOwnership}.
32  *
33  * This module is used through inheritance. It will make available the modifier
34  * `onlyOwner`, which can be applied to your functions to restrict their use to
35  * the owner.
36  */
37 abstract contract Ownable is Context {
38     address private _owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     /**
43      * @dev Initializes the contract setting the deployer as the initial owner.
44      */
45     constructor () {
46         address msgSender = _msgSender();
47         _owner = msgSender;
48         emit OwnershipTransferred(address(0), msgSender);
49     }
50 
51     /**
52      * @dev Returns the address of the current owner.
53      */
54     function owner() public view virtual returns (address) {
55         return _owner;
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         require(owner() == _msgSender(), "Ownable: caller is not the owner");
63         _;
64     }
65 
66     /**
67      * @dev Leaves the contract without owner. It will not be possible to call
68      * `onlyOwner` functions anymore. Can only be called by the current owner.
69      *
70      * NOTE: Renouncing ownership will leave the contract without an owner,
71      * thereby removing any functionality that is only available to the owner.
72      */
73     function renounceOwnership() public virtual onlyOwner {
74         emit OwnershipTransferred(_owner, address(0));
75         _owner = address(0);
76     }
77 
78     /**
79      * @dev Transfers ownership of the contract to a new account (`newOwner`).
80      * Can only be called by the current owner.
81      */
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(newOwner != address(0), "Ownable: new owner is the zero address");
84         emit OwnershipTransferred(_owner, newOwner);
85         _owner = newOwner;
86     }
87 }
88 
89 interface INFT {
90 	function mint(address _to) external;
91 	function mintBatch(address _to, uint _amount) external;
92 }
93 interface INftPresale {
94 	function buy(uint _amount, bytes memory _signature) external payable;
95 }
96 
97 contract NftPresale is INftPresale, Ownable {
98 
99 	uint public constant START_TIME = 1634929200;
100 	uint public constant FINISH_TIME = 1635015600;
101 	uint public constant PRE_SALE_PRICE = 0.2 ether;
102 
103 	INFT public nft;
104 	
105 	address public verifyAddress = 0x142581fda5769fe7f8d3b50794dBda454DA4F3ac;
106 	mapping(address => bool) public buyers;
107 	
108 	address payable public receiver;
109 
110 	constructor(address _nftAddress, address payable _receiverAddress) {
111 		nft = INFT(_nftAddress);
112 		
113 		//receiver - 0xD3db8094b50F2F094D164C1131BB9E604dfe0590
114 		receiver = _receiverAddress;
115 	}
116 
117 	/*
118 	 * @dev function to buy tokens. Can be bought only 1. 
119 	 * @param _amount how much tokens can be bought.
120 	 * @param _signature Signed message from verifyAddress private key
121 	 */
122 	function buy(uint _amount, bytes memory _signature) external override payable {
123 	    require(_amount == 1, "only 1 token can be bought on presale");
124 	    require(block.timestamp >= START_TIME && block.timestamp < FINISH_TIME, "not a presale time");
125 		require(msg.value == PRE_SALE_PRICE, "token price 0.2 ETH");
126 		require(!buyers[msg.sender], "only one token can be bought on presale");
127 		require(verify(_signature), "invalid signature");
128 		buyers[msg.sender] = true;
129 
130 		nft.mintBatch(msg.sender, _amount);
131 		(bool sent, ) = receiver.call{value: address(this).balance}("");
132         require(sent, "Something wrong with receiver");
133 	}
134 	
135 	/*
136 	 * @dev function to withdraw all tokens
137 	 * @param _to ETH receiver address
138 	 */
139 	function cashOut(address _to) public onlyOwner {
140         // Call returns a boolean value indicating success or failure.
141         // This is the current recommended method to use.
142         
143         (bool sent, ) = _to.call{value: address(this).balance}("");
144         require(sent, "Failed to send Ether");
145     }
146 
147 	/// signature methods.
148 	function verify(bytes memory _signature) internal view returns(bool) {
149 		bytes32 message = prefixed(keccak256(abi.encodePacked(msg.sender, address(this))));
150         return (recoverSigner(message, _signature) == verifyAddress);
151 	}
152 
153     function recoverSigner(bytes32 message, bytes memory sig)
154         internal
155         pure
156         returns (address)
157     {
158         (uint8 v, bytes32 r, bytes32 s) = abi.decode(sig, (uint8, bytes32, bytes32));
159 
160         return ecrecover(message, v, r, s);
161     }
162 
163     /// builds a prefixed hash to mimic the behavior of eth_sign.
164     function prefixed(bytes32 hash) internal pure returns (bytes32) {
165         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
166     }
167 }