1 pragma solidity ^0.4.17;
2 
3 contract TinyProxy {
4   address public receiver;
5   uint public gasBudget;
6 
7   function TinyProxy(address toAddr, uint proxyGas) public {
8     receiver = toAddr;
9     gasBudget = proxyGas;
10   }
11 
12   function () payable public { }
13 
14   event FundsReleased(address to, uint amount);
15 
16   function release() public {
17     uint balance = address(this).balance;
18     if(gasBudget > 0){
19       require(receiver.call.gas(gasBudget).value(balance)());
20     } else {
21       require(receiver.send(balance));
22     }
23     FundsReleased(receiver, balance);
24   }
25 }
26 
27 contract TinyProxyFactory {
28   mapping(address => mapping(address => address)) public proxyFor;
29   mapping(address => address[]) public userProxies;
30 
31   function make(address to, uint gas, bool track) public returns(address proxy){
32     proxy = new TinyProxy(to, gas);
33     if(track) {
34       proxyFor[msg.sender][to] = proxy;
35       userProxies[msg.sender].push(proxy);
36     }
37     return proxy;
38   }
39 }