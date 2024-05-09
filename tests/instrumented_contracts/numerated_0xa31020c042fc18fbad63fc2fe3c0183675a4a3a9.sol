1 pragma solidity ^0.4.18;
2 
3 /**
4  * CoinCrowd Token (XCC) multi send contract. More info www.coincrowd.it
5  */
6  
7 contract Ownable {
8   address public owner;
9   
10   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
11 
12 
13   function Ownable() internal {
14     owner = msg.sender;
15   }
16 
17   modifier onlyOwner() {
18     require(msg.sender == owner);
19     _;
20   }
21 
22   function transferOwnership(address newOwner) onlyOwner public {
23     require(newOwner != address(0));
24     OwnershipTransferred(owner, newOwner);
25     owner = newOwner;
26   }
27 }
28  
29 contract tokenInterface {
30     function originTransfer(address _to, uint256 _value) public returns (bool);
31 }
32 
33 contract MultiSendCoinCrowd is Ownable {
34 	address public tokenAddress;
35 	
36 	function MultiSendCoinCrowd(address _tokenAddress) public {
37 		tokenAddress = _tokenAddress;
38 	}
39 	
40 	function updateTokenContract(address _tokenAddress) public onlyOwner {
41         tokenAddress = _tokenAddress;
42     }
43 	
44     function multisend(address[] _dests, uint256[] _values) public onlyOwner returns(uint256) {
45         uint256 i = 0;
46         while (i < _dests.length) {
47            tokenInterface(tokenAddress).originTransfer(_dests[i], _values[i]);
48            i += 1;
49         }
50         return(i);
51     }
52 	
53 	function airdrop( uint256 _value, address[] _dests ) public onlyOwner returns(uint256) {
54         uint256 i = 0;
55         while (i < _dests.length) {
56            tokenInterface(tokenAddress).originTransfer(_dests[i], _value);
57            i += 1;
58         }
59         return(i);
60     }
61 }