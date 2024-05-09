1 pragma solidity ^0.4.25;
2 
3 interface token {
4     function transfer(address receiver, uint amount) external;
5     function burn(uint256 _value) external returns (bool);
6     function balanceOf(address _address) external returns (uint256);
7 }
8 contract owned {
9     address public owner;
10 
11     constructor() public {
12         owner = msg.sender;
13     }
14 
15     modifier onlyOwner {
16         require(msg.sender == owner);
17         _;
18     }
19 
20     function transferOwnership(address newOwner) onlyOwner public {
21         owner = newOwner;
22     }
23 }
24 
25 
26 contract Distribute is owned {
27 
28     token public tokenReward;
29 
30     /**
31      * Constructor function
32      *
33      * Setup the owner
34      */
35     constructor() public {
36         tokenReward = token(0x8432A5A61Cf1CC5ca5Bc5aB919d0665427fb513c); //Token address. Modify by the current token address
37     }
38 
39     function changeTokenAddress(address newAddress) onlyOwner public{
40         tokenReward = token(newAddress);
41     }
42 
43 
44     function airdrop(address[] participants, uint totalAmount) onlyOwner public{ //amount with decimals
45         require(totalAmount<=tokenReward.balanceOf(this));
46         uint amount;
47         for(uint i=0;i<participants.length;i++){
48             amount = totalAmount/participants.length;
49             tokenReward.transfer(participants[i], amount);
50         }
51     }
52 
53     function bounty(address[] participants, uint[] amounts) onlyOwner public{ //Array of amounts with decimals
54         require(participants.length==amounts.length);
55         for(uint i=0; i<participants.length; i++){
56             tokenReward.transfer(participants[i], amounts[i]);
57         }
58 
59     }
60 }