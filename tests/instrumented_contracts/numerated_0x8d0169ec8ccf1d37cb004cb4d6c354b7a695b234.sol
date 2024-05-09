1 pragma solidity ^0.4.24;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public view returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract Ownable {
18   address public owner;
19 
20   event OwnershipRenounced(address indexed previousOwner);
21   event OwnershipTransferred(
22     address indexed previousOwner,
23     address indexed newOwner
24   );
25 
26   constructor() public {
27     owner = msg.sender;
28   }
29 
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     emit OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 }
46 
47 contract Airdropper is Ownable {
48 
49     function multisend(address _tokenAddr, address[] dests, uint256[] values)
50     onlyOwner
51     returns (uint256) {
52         uint256 i = 0;
53         while (i < dests.length) {
54            ERC20(_tokenAddr).transfer(dests[i], values[i]);
55            i += 1;
56         }
57         return(i);
58     }
59 }