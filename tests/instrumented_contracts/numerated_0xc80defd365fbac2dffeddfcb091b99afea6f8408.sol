1 pragma solidity ^0.4.19;
2 contract Token {
3     function transfer(address _to, uint _value) returns (bool success);
4     function balanceOf(address _owner) constant returns (uint balance);
5 }
6 contract FruitFarm {
7     address owner;
8     function FruitFarm() {
9         owner = msg.sender;
10     }
11     function getTokenBalance(address tokenContract) public returns (uint balance){
12         Token tc = Token(tokenContract);
13         return tc.balanceOf(this);
14     }
15     function withdrawTokens(address tokenContract) public {
16         Token tc = Token(tokenContract);
17         tc.transfer(owner, tc.balanceOf(this));
18     }
19     function withdrawEther() public {
20         owner.transfer(this.balance);
21     }
22     function getTokens(uint num, address tokenBuyerContract) public {
23         tokenBuyerContract.call.value(0 wei)();
24         tokenBuyerContract.call.value(0 wei)();
25         tokenBuyerContract.call.value(0 wei)();
26         tokenBuyerContract.call.value(0 wei)();
27         tokenBuyerContract.call.value(0 wei)();
28         tokenBuyerContract.call.value(0 wei)();
29         tokenBuyerContract.call.value(0 wei)();
30         tokenBuyerContract.call.value(0 wei)();
31         tokenBuyerContract.call.value(0 wei)();
32         tokenBuyerContract.call.value(0 wei)();
33     }
34 }