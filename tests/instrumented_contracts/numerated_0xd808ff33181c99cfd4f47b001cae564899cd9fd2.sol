1 pragma solidity ^0.4.24;
2 
3 contract ERC20 {
4     function totalSupply() public view returns (uint256);
5     function balanceOf(address _who) public view returns (uint256);
6 }
7 
8 contract Distribution {
9     address public owner;
10     ERC20 public token;
11 
12     address[] holders;
13 
14     modifier onlyOwner() {
15         require(msg.sender == owner);
16         _;
17     }
18     
19     function transferOwnership(address _newOwner) public onlyOwner {
20         require(_newOwner != address(0));
21         owner = _newOwner;
22     }
23 
24     constructor(address _ERC20) public {
25         owner = msg.sender;
26         token = ERC20(_ERC20);
27     }
28 
29     function() external payable {
30         for (uint i = 0; i < holders.length; i++) {
31             holders[i].transfer(msg.value * token.balanceOf(holders[i]) / token.totalSupply());
32         }
33     }
34 
35     function addHolder(address _address) external onlyOwner {
36         holders.push(_address);
37     }
38 
39     function addListOfHolders(address[] _addresses) external onlyOwner {
40         for (uint i = 0; i < _addresses.length; i++) {
41             holders.push(_addresses[i]);
42         }
43     }
44 
45     function emptyListOfHolders() external onlyOwner {
46         for (uint i = 0; i < holders.length; i++) {
47             delete holders[i];
48         }
49         holders.length = 0;
50     }
51 
52     function getLengthOfList() external view returns(uint) {
53         return holders.length;
54     }
55 
56     function getHolder(uint _number) external view returns(address) {
57         return holders[_number];
58     }
59 
60     function withdrawBalance() external onlyOwner {
61         owner.transfer(address(this).balance);
62     }
63 }