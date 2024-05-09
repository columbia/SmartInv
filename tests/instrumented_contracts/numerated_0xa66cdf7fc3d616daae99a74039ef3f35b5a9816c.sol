1 pragma solidity ^0.4.23;
2 
3 /**
4  * CoinCrowd Multi Send Contract. More info www.coincrowd.me
5  */
6  
7 contract Ownable {
8 	address public owner;
9 	address public newOwner;
10 
11 	event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);
12 
13 	constructor() public {
14 		owner = msg.sender;
15 		newOwner = address(0);
16 	}
17 
18 	modifier onlyOwner() {
19 		require(msg.sender == owner, "msg.sender == owner");
20 		_;
21 	}
22 
23 	function transferOwnership(address _newOwner) public onlyOwner {
24 		require(address(0) != _newOwner, "address(0) != _newOwner");
25 		newOwner = _newOwner;
26 	}
27 
28 	function acceptOwnership() public {
29 		require(msg.sender == newOwner, "msg.sender == newOwner");
30 		emit OwnershipTransferred(owner, msg.sender);
31 		owner = msg.sender;
32 		newOwner = address(0);
33 	}
34 }
35  
36 contract tokenInterface {
37     function transfer(address _to, uint256 _value) public returns (bool);
38 }
39 
40 contract MultiSendCoinCrowd is Ownable {
41 	tokenInterface public tokenContract;
42 	
43 	function updateTokenContract(address _tokenAddress) public onlyOwner {
44         tokenContract = tokenInterface(_tokenAddress);
45     }
46 	
47     function multisend(address[] _dests, uint256[] _values) public onlyOwner returns(uint256) {
48         require(_dests.length == _values.length, "_dests.length == _values.length");
49         uint256 i = 0;
50         while (i < _dests.length) {
51            tokenContract.transfer(_dests[i], _values[i]);
52            i += 1;
53         }
54         return(i);
55     }
56 	
57 	function airdrop( uint256 _value, address[] _dests ) public onlyOwner returns(uint256) {
58         uint256 i = 0;
59         while (i < _dests.length) {
60             tokenContract.transfer(_dests[i], _value);
61            i += 1;
62         }
63         return(i);
64     }
65 	
66 	function withdrawTokens(address to, uint256 value) public onlyOwner returns (bool) {
67         return tokenContract.transfer(to, value);
68     }
69 }