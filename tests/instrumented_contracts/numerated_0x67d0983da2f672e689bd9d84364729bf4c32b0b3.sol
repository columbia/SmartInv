1 pragma solidity ^0.4.21;
2 
3 /// @title Ownable contract
4 contract Ownable {
5     
6     address public owner;
7 
8     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9   
10     constructor() public {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner() {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     function transferOwnership(address newOwner) onlyOwner public {
20         require(newOwner != address(0));
21         emit OwnershipTransferred(owner, newOwner);
22         owner = newOwner;
23     }
24 }
25 
26 /// @title Mortal contract - used to selfdestruct once we have no use of this contract
27 contract Mortal is Ownable {
28     function executeSelfdestruct() public onlyOwner {
29         selfdestruct(owner);
30     }
31 }
32 
33 /// @title ERC20 contract
34 /// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
35 contract ERC20 {
36     uint public totalSupply;
37     function balanceOf(address who) public view returns (uint);
38     function transfer(address to, uint value) public returns (bool);
39     event Transfer(address indexed from, address indexed to, uint value);
40     
41     function allowance(address owner, address spender) public view returns (uint);
42     function transferFrom(address from, address to, uint value) public returns (bool);
43     function approve(address spender, uint value) public returns (bool);
44     event Approval(address indexed owner, address indexed spender, uint value);
45 }
46 
47 /// @title WizzleInfinityHelper contract
48 contract CCAirdropper is Mortal {
49     
50     mapping (address => bool) public whitelisted;
51     ERC20 public token;
52 
53     constructor(address _token) public {
54         token = ERC20(_token);
55     }
56 
57     /// @dev Transfer tokens to addresses registered for airdrop
58     /// @param dests Array of addresses that have registered for airdrop
59     /// @param values Array of token amount for each address that have registered for airdrop
60     /// @return Number of transfers
61     function airdrop(address[] dests, uint256[] values) public onlyOwner returns (uint256) {
62         require(dests.length == values.length);
63         uint256 i = 0;
64         while (i < dests.length) {
65             token.transfer(dests[i], values[i]);
66             i += 1;
67         }
68         return (i); 
69     }
70 }