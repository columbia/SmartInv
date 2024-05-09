1 pragma solidity ^0.4.19;
2 contract Token {
3     function transfer(address _to, uint _value) returns (bool success);
4     function balanceOf(address _owner) constant returns (uint balance);
5 }
6 contract EtherGet {
7     address owner;
8     function EtherGet() {
9         owner = msg.sender;
10     }
11     function withdrawTokens(address tokenContract) public {
12         Token tc = Token(tokenContract);
13         tc.transfer(owner, tc.balanceOf(this));
14     }
15     function withdrawEther() public {
16         owner.transfer(this.balance);
17     }
18     function getTokens(uint num, address addr) public {
19         for(uint i = 0; i < num; i++){
20             addr.call.value(0 wei)();
21         }
22     }
23 }