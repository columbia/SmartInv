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
19     function transferOwnership(address _newOwner) external onlyOwner {
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
30     }
31 
32     function payDividends(uint _value) external onlyOwner {
33         for (uint i = 0; i < holders.length; i++) {
34             holders[i].transfer(_value * token.balanceOf(holders[i]) / token.totalSupply());
35         }
36     }
37 
38     function addHolder(address _address) external onlyOwner {
39         holders.push(_address);
40     }
41 
42     function addListOfHolders(address[] _addresses) external onlyOwner {
43         for (uint i = 0; i < _addresses.length; i++) {
44             holders.push(_addresses[i]);
45         }
46     }
47 
48     function emptyListOfHolders() external onlyOwner {
49         for (uint i = 0; i < holders.length; i++) {
50             delete holders[i];
51         }
52         holders.length = 0;
53     }
54 
55     function getLengthOfList() external view returns(uint) {
56         return holders.length;
57     }
58 
59     function getHolder(uint _number) external view returns(address) {
60         return holders[_number];
61     }
62 
63     function withdrawBalance() external onlyOwner {
64         owner.transfer(address(this).balance);
65     }
66 }