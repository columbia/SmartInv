1 pragma solidity ^0.4.18;
2 
3 contract MainSale {
4 
5 	uint256 public totalContributed;
6 	uint256 public startTime;
7 	uint256 public endTime;
8 	uint256 public hardCap;
9 	address public owner;
10 
11 	function MainSale (address _owner, uint256 _start, uint256 _end, uint256 _cap) public {
12 		owner = _owner;
13 		startTime = _start;
14 		endTime = _end;
15 		hardCap = _cap * (10 ** 18);
16 	}
17 
18 	function () external payable {
19 		require(now >= startTime && now <= endTime);
20 		require(hardCap >= msg.value + totalContributed);
21 		require(msg.value >= 10 ** 17);
22 		totalContributed += msg.value;
23 	}
24 
25 	modifier onlyOwner() {
26 		assert(msg.sender == owner);
27 		_;
28 	}
29 
30 	function forwardFunds(address _to, uint256 _value) onlyOwner public returns (bool success) {
31 		require(_to != address(0));
32 		_to.transfer(_value);
33 		return true;
34 	}
35 
36 }