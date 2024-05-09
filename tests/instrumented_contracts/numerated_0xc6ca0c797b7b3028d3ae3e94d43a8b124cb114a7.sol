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
93 
94 contract NftSale is Ownable {
95 
96 	uint public constant MAX_UNITS_PER_TRANSACTION = 5;
97 	uint public constant MAX_NFT_TO_SELL = 7444;
98 	
99 	uint public constant INITIAL_PRICE = 3.3 ether;
100 	uint public constant FINAL_PRICE = 0.3 ether;
101 	uint public constant PRICE_DROP = 0.1 ether;
102 	uint public constant PRICE_DROP_TIME = 5 minutes;
103 	uint public constant START_TIME = 1634853600;
104 	
105 	address payable public receiver;
106 	
107 	INFT public nft;
108 	uint public tokensSold;
109 
110 	constructor(address _nftAddress, address payable _receiverAddress) {
111 		nft = INFT(_nftAddress);
112 		
113 		//receiver - 0xD3db8094b50F2F094D164C1131BB9E604dfe0590
114 		receiver = _receiverAddress;
115 	}
116 	
117 	/*
118 	 * @dev calculate NFT price on current time. 
119 	 */
120 	function getCurrentPrice() public view returns(uint) {
121 		return getPriceOnTime(block.timestamp);
122 	}
123 	
124 	/*
125 	 * @dev calculate NFT price on exact time. 
126 	 * @param _time time for calculation
127 	 */
128 	function getPriceOnTime(uint _time) public pure returns(uint) {
129 		if(_time < START_TIME) {
130 			return 0;
131 		}
132 		uint maxRange = (INITIAL_PRICE - FINAL_PRICE) / PRICE_DROP;
133 		uint currentRange = (_time - START_TIME) / PRICE_DROP_TIME;
134 
135 		if(currentRange >= maxRange) {
136 			return FINAL_PRICE;
137 		}
138         
139 		return INITIAL_PRICE - (currentRange * PRICE_DROP);
140 	}
141 
142 	/*
143 	 * @dev function to buy tokens. 
144 	 * @param _amount how much tokens can be bought.
145 	 */
146 	function buyBatch(uint _amount) external payable {
147 		require(block.timestamp >= START_TIME, "sale is not started yet");
148 		require(tokensSold + _amount <= MAX_NFT_TO_SELL, "exceed sell limit");
149 		require(_amount > 0, "empty input");
150 		require(_amount <= MAX_UNITS_PER_TRANSACTION, "exceed MAX_UNITS_PER_TRANSACTION");
151 
152 		uint currentPrice = getCurrentPrice() * _amount;
153 		require(msg.value >= currentPrice, "too low value");
154 		if(msg.value > currentPrice) {
155 			//send the rest back
156 			(bool sent, ) = payable(msg.sender).call{value: msg.value - currentPrice}("");
157         	require(sent, "Failed to send Ether");
158 		}
159 		
160 		tokensSold += _amount;
161 		nft.mintBatch(msg.sender, _amount);
162 		
163 		(bool sent, ) = receiver.call{value: address(this).balance}("");
164         require(sent, "Something wrong with receiver");
165 	}
166 
167 	function cashOut(address _to) public onlyOwner {
168         // Call returns a boolean value indicating success or failure.
169         // This is the current recommended method to use.
170         require(_to != address(0), "invalid address");
171         
172         (bool sent, ) = _to.call{value: address(this).balance}("");
173         require(sent, "Failed to send Ether");
174     }
175 }