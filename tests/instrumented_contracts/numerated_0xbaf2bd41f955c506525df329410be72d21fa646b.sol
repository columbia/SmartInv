1 pragma solidity ^0.4.24;
2 
3 contract IERC20Token {
4     string public name;
5     string public symbol;
6     uint8 public decimals;
7     uint256 public totalSupply;
8 
9     function balanceOf(address _owner) public constant returns (uint256 balance);
10     function transfer(address _to, uint256 _value)  public returns (bool success);
11     function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success);
12     function approve(address _spender, uint256 _value)  public returns (bool success);
13     function allowance(address _owner, address _spender)  public constant returns (uint256 remaining);
14 
15     event Transfer(address indexed _from, address indexed _to, uint256 _value);
16     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17 }
18 
19 
20 contract Ownable {
21     address public owner;
22     address public newOwner;
23 
24     event OwnershipTransferred(address previousOwner, address newOwner);
25 
26     constructor(address _owner) public {
27         owner = _owner == address(0) ? msg.sender : _owner;
28     }
29 
30     modifier onlyOwner() {
31         require(msg.sender == owner);
32         _;
33     }
34 
35     function transferOwnership(address _newOwner) public onlyOwner {
36         require(_newOwner != owner);
37         newOwner = _newOwner;
38     }
39 
40     function confirmOwnership() public {
41         require(msg.sender == newOwner);
42         emit OwnershipTransferred(owner, newOwner);
43         owner = newOwner;
44         newOwner = 0x0;
45     }
46 }
47 
48 
49 contract AbyssBatchTransfer is Ownable {
50     IERC20Token public token;
51 
52     constructor(address tokenAddress, address ownerAddress) public Ownable(ownerAddress) {
53         token = IERC20Token(tokenAddress);
54     }
55 
56     function batchTransfer(address[] recipients, uint256[] amounts) public onlyOwner {
57         require(recipients.length == amounts.length);
58 
59         for(uint i = 0; i < recipients.length; i++) {
60             require(token.transfer(recipients[i], amounts[i]));
61         }
62     }
63 }