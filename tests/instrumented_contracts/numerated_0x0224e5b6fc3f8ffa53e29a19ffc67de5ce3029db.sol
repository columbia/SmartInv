1 // version 0.8
2 
3 pragma solidity ^0.4.15;
4 
5 //abstract of token interface
6 contract ERC20Basic {
7     uint256 public totalSupply;
8     function balanceOf(address who) public constant returns (uint256);
9     function transfer(address to, uint256 value) public returns (bool);
10     event Transfer(address indexed from, address indexed to, uint256 value);
11 }
12 
13 contract Dist{
14 
15     // public    
16     address public owner;
17     address public tokenAddress; // 0x6781a0F84c7E9e846DCb84A9a5bd49333067b104 ZAP token mainnet address
18     uint public unlockTime;
19 
20     // internal
21     ERC20Basic token;
22 
23     modifier onlyOwner{
24         require(msg.sender == owner);
25         _;
26     }
27     
28     // 01/01/2019 @ 12:00am (UTC) = 1546300800
29     // ex.
30     // "0xca35b7d915458ef540ade6068dfe2f44e8fa733c",1514411898,"0x6781a0F84c7E9e846DCb84A9a5bd49333067b104"
31     
32     function Dist(address _owner, uint _unlockTime, address _tokenAddress){
33         owner = _owner;
34         tokenAddress = _tokenAddress;
35         token = ERC20Basic(_tokenAddress);
36         unlockTime = _unlockTime;
37     }
38 
39     function balance() constant returns(uint _balance){
40     
41         return token.balanceOf(this);
42     }
43 
44     function isLocked() constant returns (bool) {
45 
46         return (now < unlockTime);       
47     }
48 
49     function withdraw() onlyOwner {
50 
51         if(!isLocked()){        
52             token.transfer(owner, balance());
53         }
54     }
55 
56 }