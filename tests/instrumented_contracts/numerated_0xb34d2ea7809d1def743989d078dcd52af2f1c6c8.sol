1 pragma solidity 0.5.2;
2 
3 contract ERC20 {
4   event Transfer(address indexed from, address indexed to, uint256 value);
5   event Approval(address indexed owner, address indexed spender, uint256 value);
6 
7   function totalSupply() public view returns (uint256);
8   function balanceOf(address who) public view returns (uint256);
9   function transfer(address to, uint256 value) public returns (bool);
10   function allowance(address owner, address spender) public view returns (uint256);
11   function transferFrom(address from, address to, uint256 value) public returns (bool);
12   function approve(address spender, uint256 value) public returns (bool);
13 }
14 
15 
16 contract Ownable {
17   event OwnershipTransferred(address indexed oldone, address indexed newone);
18   event ERC20TragetChanged(address indexed oldToken, address indexed newToken);
19 
20   address public owner;
21   address public tokenAddr;
22 
23   constructor () public {
24     owner = msg.sender;
25     tokenAddr = address(0);
26   }
27 
28   modifier onlyOwner () {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   function transferOwnership (address newOwner) public returns (bool);
34   function setERC20 (address newTokenAddr) public returns (bool);
35 }
36 
37 
38 
39 contract TokenMerge is Ownable {
40 
41   function takeStock(address[] memory tokenFrom, uint256[] memory amounts, address[] memory tokenTo) public onlyOwner {
42     ERC20 token = ERC20(tokenAddr);
43     require(tokenFrom.length == amounts.length);
44 
45     if (tokenTo.length == 1){
46       for(uint i = 0; i < tokenFrom.length; i++) {
47         require(token.transferFrom(tokenFrom[i], tokenTo[0], amounts[i]));
48       }
49     }
50     else {
51       require(tokenFrom.length == tokenTo.length);
52       for(uint i = 0; i < tokenFrom.length; i++) {
53         require(token.transferFrom(tokenFrom[i], tokenTo[i], amounts[i]));
54       }
55     }
56   }
57 
58 
59   function flushStock(address[] memory tokenFrom, address tokenTo) public onlyOwner {
60     ERC20 token = ERC20(tokenAddr);
61     require(tokenFrom.length > 0 );
62 
63     for(uint i = 0; i < tokenFrom.length; i++) {
64       require(token.transferFrom(tokenFrom[i], tokenTo, token.balanceOf(tokenFrom[i])));
65     }
66   } 
67 
68 
69   function multiSendEth(address payable[] memory addresses) public payable{
70     uint addressesLength = addresses.length;
71     require(addressesLength > 0);
72       for(uint i = 0; i < addressesLength; i++) {
73         addresses[i].transfer(msg.value / addressesLength);
74       }
75     msg.sender.transfer(address(this).balance);
76   }
77 
78 
79   function transferOwnership (address newOwner) public onlyOwner returns (bool) {
80     require(newOwner != address(0));
81     require(newOwner != owner);
82 
83     address oldOwner = owner;
84     owner = newOwner;
85     emit OwnershipTransferred(oldOwner, newOwner);
86     
87     return true;
88   }
89 
90 
91   function setERC20 (address newTokenAddr) public onlyOwner returns (bool) {
92     require(newTokenAddr != tokenAddr);
93 
94     address oldTokenAddr = tokenAddr;
95     tokenAddr = newTokenAddr;
96     emit ERC20TragetChanged(oldTokenAddr, newTokenAddr);
97     
98     return true;
99   }
100 }