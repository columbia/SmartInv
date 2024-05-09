1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4 	address public owner;
5 	address public newOwner;
6 
7 	event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);
8 
9 	constructor() public {
10 		owner = msg.sender;
11 		newOwner = address(0);
12 	}
13 
14 	modifier onlyOwner() {
15 		require(msg.sender == owner, "msg.sender == owner");
16 		_;
17 	}
18 
19 	function transferOwnership(address _newOwner) public onlyOwner {
20 		require(address(0) != _newOwner, "address(0) != _newOwner");
21 		newOwner = _newOwner;
22 	}
23 
24 	function acceptOwnership() public {
25 		require(msg.sender == newOwner, "msg.sender == newOwner");
26 		emit OwnershipTransferred(owner, msg.sender);
27 		owner = msg.sender;
28 		newOwner = address(0);
29 	}
30 }
31 
32 contract tokenInterface {
33 	function balanceOf(address _owner) public constant returns (uint256 balance);
34 	function transfer(address _to, uint256 _value) public returns (bool);
35 }
36 
37 contract Timelock is Ownable {
38 	tokenInterface public tokenContract;
39 
40 	uint256 public releaseTime;
41 
42 	constructor(address _tokenAddress, uint256 _releaseTime) public {
43 		tokenContract = tokenInterface(_tokenAddress);
44 		releaseTime = _releaseTime;
45 	}
46 
47 	function () public {
48 	    if ( msg.sender == newOwner ) acceptOwnership();
49 		claim();
50 	}
51 	
52 	function claim() onlyOwner private {
53 	    require ( now > releaseTime, "now > releaseTime" );
54 	    
55 	    uint256 tknToSend = tokenContract.balanceOf(this);
56 		require(tknToSend > 0,"tknToSend > 0");
57 			
58 		require ( tokenContract.transfer(msg.sender, tknToSend) );
59 	}
60 	
61 	function unlocked() view public returns(bool) {
62 	    return now > releaseTime;
63 	}
64 }