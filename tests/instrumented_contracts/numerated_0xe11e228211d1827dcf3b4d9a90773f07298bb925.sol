1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4     
5   address public owner;
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9   function Ownable() public {
10     owner = msg.sender;
11   }
12 
13   modifier onlyOwner() {
14     require(msg.sender == owner);
15     _;
16   }
17 
18   function transferOwnership(address newOwner) public onlyOwner {
19     require(newOwner != address(0));
20     OwnershipTransferred(owner, newOwner);
21     owner = newOwner;
22   }
23 
24 }
25 
26 contract MintTokensInterface {
27     
28    function mintTokensExternal(address to, uint tokens) public;
29     
30 }
31 
32 contract TokenDistributor is Ownable {
33     
34   MintTokensInterface public crowdsale = MintTokensInterface(0x8DD9034f7cCC805bDc4D593A01f6A2E2EB94A67a);
35     
36   function mintBatch(address[] wallets, uint[] tokens) public onlyOwner {
37     require(wallets.length == tokens.length);
38     for(uint i=0; i<wallets.length; i++) crowdsale.mintTokensExternal(wallets[i], tokens[i]);
39   }
40     
41 }