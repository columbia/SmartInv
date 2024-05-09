1 pragma solidity ^0.4.24;
2 
3 contract Ownable {
4     address public owner;
5     mapping (address => bool) private distributors;
6 
7     constructor () internal {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner() {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     modifier onlyOwnerOrDistributor() {
17         require(distributors[msg.sender] == true || msg.sender == owner);
18         _;
19     }
20 
21     function transferOwnership(address newOwner) external onlyOwner {
22         require(newOwner != address(0));
23         owner = newOwner;
24     }
25 
26     function setDistributor(address _distributor, bool _allowed) external onlyOwner {
27         distributors[_distributor] = _allowed;
28     }
29 }
30 
31 contract Airdrop is Ownable {
32 
33     function () payable public {}
34 
35     function airdrop(address[] _to, uint256[] _values) external onlyOwnerOrDistributor {
36         require(_to.length == _values.length);
37         for (uint256 i = 0; i < _to.length; i++) {
38             _to[i].transfer(_values[i]);
39         }
40     }
41 }