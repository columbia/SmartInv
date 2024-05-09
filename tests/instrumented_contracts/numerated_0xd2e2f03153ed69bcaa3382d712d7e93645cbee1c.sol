1 pragma solidity ^0.4.18;
2 
3 contract ERC20Interface {
4   function transferFrom(address _from, address _to, uint _value) public returns (bool){}
5 }
6 contract Ownable {
7   address public owner;
8 
9   function Ownable() public {
10     owner = msg.sender;
11   }
12 
13   modifier onlyOwner()  {
14     require(msg.sender == owner);
15     _;
16   }
17 
18   function transferOwnership(address newOwner) public onlyOwner {
19 
20     if (newOwner != address(0)) {
21       owner = newOwner;
22     }
23   }
24 }
25 
26 
27 contract TokenAirDrop is Ownable {
28 
29   function airDrop ( address contractObj,
30                     address   tokenRepo,
31                     address[] airDropDesinationAddress,
32                     uint[] amounts) public onlyOwner{
33 
34     for( uint i = 0 ; i < airDropDesinationAddress.length ; i++ ) {
35 
36         ERC20Interface(contractObj).transferFrom( tokenRepo, airDropDesinationAddress[i],amounts[i]);
37     }
38    }
39 }