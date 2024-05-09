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
12   event FundsReceived(uint amount);
13   event FundsReleased(address to, uint amount);
14 
15   function () payable public {
16     emit FundsReceived(msg.value);
17   }
18 
19   function release() public {
20     uint balance = address(this).balance;
21     if(gasBudget > 0){
22       require(receiver.call.gas(gasBudget).value(balance)());
23     } else {
24       require(receiver.send(balance));
25     }
26     emit FundsReleased(receiver, balance);
27   }
28 }
29 
30 contract TinyProxyFactory {
31   mapping(address => mapping(uint => address)) public proxyFor;
32   mapping(address => address[]) public userProxies;
33 
34   event ProxyDeployed(address to, uint gas);
35   function make(address to, uint gas, bool track) public returns(address proxy){
36     proxy = proxyFor[to][gas];
37     if(proxy == 0x0) {
38       proxy = new TinyProxy(to, gas);
39       proxyFor[to][gas] = proxy;
40       emit ProxyDeployed(to, gas);
41     }
42     if(track) {
43       userProxies[msg.sender].push(proxy);
44     }
45     return proxy;
46   }
47 
48   function untrack(uint index) public {
49     uint lastProxy = userProxies[msg.sender].length - 1;
50     userProxies[msg.sender][index] = userProxies[msg.sender][lastProxy];
51     delete userProxies[msg.sender][lastProxy];
52   }
53 }