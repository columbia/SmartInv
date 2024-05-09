1 pragma solidity ^0.4.11;
2 
3 contract Ownable {
4   address public owner;
5 
6   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
7 
8   function Ownable() public {
9     owner = msg.sender;
10   }
11 
12   modifier onlyOwner() {
13     require(msg.sender == owner);
14     _;
15   }
16 
17   function transferOwnership(address newOwner) public onlyOwner {
18     require(newOwner != address(0));
19     emit OwnershipTransferred(owner, newOwner);
20     owner = newOwner;
21   }
22 }
23 
24 contract ERC20Basic {
25   function totalSupply() public view returns (uint256);
26   function balanceOf(address who) public view returns (uint256);
27   function transfer(address to, uint256 value) public returns (bool);
28   event Transfer(address indexed from, address indexed to, uint256 value);
29 }
30 
31 contract ERC20 is ERC20Basic {
32   function allowance(address owner, address spender) public view returns (uint256);
33   function transferFrom(address from, address to, uint256 value) public returns (bool);
34   function approve(address spender, uint256 value) public returns (bool);
35   event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37 
38 contract AirDrop is Ownable {
39 
40     function contractTokenBalance(address _tokenAddr) onlyOwner public constant returns(uint256) {
41        return  ERC20(_tokenAddr).balanceOf(msg.sender);
42     }
43     
44     function send(address _tokenAddr, address _to, uint256 amount) onlyOwner public returns(bool) {
45        return ERC20(_tokenAddr).transfer(_to, amount);
46     }
47     
48     function multisend(address _tokenAddr, address[] dests, uint256 amount) onlyOwner public returns(uint256) {
49       
50         uint256 i = 0;
51         while (i < dests.length) {
52           ERC20(_tokenAddr).transfer(dests[i], amount);
53           i += 1;
54         }
55         return(i);
56     }
57     
58     function () payable public {
59     }
60 }