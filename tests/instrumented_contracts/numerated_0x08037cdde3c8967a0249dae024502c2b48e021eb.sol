1 pragma solidity ^0.5.10;
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
32     event Received(address payable[] addresses, uint256[] values);
33 
34     //function () payable external {}
35 
36     function airdrop(address payable[] calldata _to, uint256[] calldata _values) payable external onlyOwnerOrDistributor {
37         require(_to.length == _values.length);
38         for (uint256 i = 0; i < _to.length; i++) {
39             address(_to[i]).transfer(_values[i]);
40         }
41         emit Received(_to, _values);
42     }
43 }