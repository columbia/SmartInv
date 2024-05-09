1 pragma solidity ^0.4.21;
2 
3   contract MBLToken {
4     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
5     function balanceOf(address _tokenOwner) external view returns (uint balance);
6 
7  }
8 
9    contract passOnContract {
10 
11     address public owner;
12   	address public tokenAddress = 0x8D7dDaD45789a64c2AF9b4Ce031C774e277F1Cd4;
13 
14   	function passOnContract() public {
15 
16   		owner = msg.sender;
17   	}
18 
19     function () public payable {
20 
21     	owner.transfer(msg.value);
22     	MBLToken mblToken = MBLToken(tokenAddress);
23     	mblToken.transferFrom(owner, msg.sender, msg.value/250000000000000);
24 
25     }
26 
27 }