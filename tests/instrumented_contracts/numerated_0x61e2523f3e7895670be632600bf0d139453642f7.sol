1 pragma solidity ^0.4.18;
2 
3 contract ERC20Interface {
4     function balanceOf(address _owner) public constant returns (uint balance) {}
5     function transfer(address _to, uint _value) public returns (bool success) {}
6     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {}
7 }
8 
9 contract Exchanger {
10   // Decimals 18
11   ERC20Interface dai = ERC20Interface(0x89d24a6b4ccb1b6faa2625fe562bdd9a23260359);
12   // Decimals 6
13   ERC20Interface usdt = ERC20Interface(0xdac17f958d2ee523a2206206994597c13d831ec7);
14 
15   address creator = 0x34f1e87e890b5683ef7b011b16055113c7194c35;
16   uint feeDAI = 100000000000000; // 0.01 cent fee
17   uint feeUSDT = 100; // 0.01 cent fee
18 
19   function getDAI(uint _amountInDollars) public returns (bool) {
20     usdt.transferFrom(msg.sender, this, _amountInDollars * (10 ** 6));
21     dai.transfer(msg.sender, _amountInDollars * ((10 ** 18) - feeDAI ));
22     return true;
23   }
24 
25   function getUSDT(uint _amountInDollars) public returns (bool) {
26     dai.transferFrom(msg.sender, this, _amountInDollars * (10 ** 18));
27     usdt.transfer(msg.sender, _amountInDollars * ((10 ** 6) - feeUSDT ));
28     return true;
29   }
30 
31   function withdrawEquity(uint _amountInDollars, bool isUSDT) public returns (bool) {
32     require(msg.sender == creator);
33     if(isUSDT) {
34       usdt.transfer(creator, _amountInDollars * (10 ** 6));
35     } else {
36       dai.transfer(creator, _amountInDollars * (10 ** 18));
37     }
38     return true;
39   }
40 }