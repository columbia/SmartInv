1 pragma solidity 0.4.18;
2 
3 contract Ownable {
4     address public owner;
5     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6 
7     function Ownable() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner() {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address newOwner) onlyOwner public {
17         require(newOwner != address(0));
18         OwnershipTransferred(owner, newOwner);
19         owner = newOwner;
20     }
21 }
22 
23 contract ERC20Interface {
24     // Send _value amount of tokens to address _to
25     function transfer(address _to, uint256 _value) returns (bool success);
26     // Get the account balance of another account with address _owner
27     function balanceOf(address _owner) constant returns (uint256 balance);
28 }
29 
30 contract Distributor is Ownable {
31     ERC20Interface token;
32 
33     function Distributor (address _tokenAddress) public {
34         token = ERC20Interface(_tokenAddress);
35     }
36 
37     function batchTransfer (address[] _to, uint256 _value) public onlyOwner {
38         for (uint i = 0; i < _to.length; i++) {
39             token.transfer(_to[i], _value);
40         }
41     }
42 
43 }