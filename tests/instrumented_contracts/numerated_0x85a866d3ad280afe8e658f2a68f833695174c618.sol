1 pragma solidity ^0.4.18;
2 
3 contract ZperPreSale {
4 
5 	uint256 public totalContributed;
6 	uint256 public startTime;
7 	uint256 public endTime;
8 	uint256 public hardCap;
9 	address public owner;
10 
11 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
12 
13 	function ZperPreSale (address _owner, uint256 _start, uint256 _end, uint256 _cap) public {
14 		owner = _owner;
15 		startTime = _start;
16 		endTime = _end;
17 		hardCap = _cap * (10 ** 18);
18 	}
19 
20 	function () external payable {
21 		require(now >= startTime && now <= endTime);
22 		require(hardCap >= msg.value + totalContributed);
23 		totalContributed += msg.value;
24 	}
25 
26 	modifier onlyOwner() {
27 		assert(msg.sender == owner);
28 		_;
29 	}
30 
31 	function showContributed() public constant returns (uint256 total) {
32 		return totalContributed;
33 	}
34 
35 	function forwardFunds(address _to, uint256 _value) onlyOwner public returns (bool success) {
36 		require(_to != address(0));
37 		_to.transfer(_value);
38 		Transfer(address(0), _to, _value);
39 		return true;
40 	}
41 
42 }