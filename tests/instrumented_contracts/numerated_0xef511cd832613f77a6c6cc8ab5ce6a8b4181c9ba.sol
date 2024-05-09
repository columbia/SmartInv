1 pragma solidity ^0.4.13;
2 
3 /*
4 Proxy Buyer
5 ========================
6 */
7 
8 // ERC20 Interface: https://github.com/ethereum/EIPs/issues/20
9 contract ERC20 {
10   function transfer(address _to, uint256 _value) returns (bool success);
11   function balanceOf(address _owner) constant returns (uint256 balance);
12 }
13 
14 contract ICOBuyer {
15 
16   // Emergency kill switch in case a critical bug is found.
17   address public developer = 0xF23B127Ff5a6a8b60CC4cbF937e5683315894DDA;
18   // The crowdsale address.  Settable by the developer.
19   address public sale = 0x0;
20   // The token address.  Settable by the developer.
21   ERC20 public token;
22   
23   // Allows the developer to set the crowdsale and token addresses.
24   function set_addresses(address _sale, address _token) {
25     // Only allow the developer to set the sale and token addresses.
26     require(msg.sender == developer);
27     // Only allow setting the addresses once.
28     // Set the crowdsale and token addresses.
29     sale = _sale;
30     token = ERC20(_token);
31   }
32   
33   
34   // Withdraws all ETH deposited or tokens purchased by the given user and rewards the caller.
35 
36   
37   function withdrawToken(address _token){
38       require(msg.sender == developer);
39       require(token.transfer(developer, ERC20(_token).balanceOf(address(this))));
40   }
41   
42   function withdrawETH(){
43       require(msg.sender == developer);
44       developer.transfer(this.balance);
45   }
46   
47   // Buys tokens in the crowdsale and rewards the caller, callable by anyone.
48   function buy(){
49     require(sale != 0x0);
50     require(sale.call.value(this.balance)());
51     
52   }
53   
54   function buyWithFunction(bytes4 methodId){
55       require(sale != 0x0);
56       require(sale.call.value(this.balance)(methodId));
57   }
58   
59   function buyWithAddress(address _ICO){
60       require(msg.sender == developer);
61       require(_ICO != 0x0);
62       require(_ICO.call.value(this.balance)());
63   }
64   
65   function buyWithAddressAndFunction(address _ICO, bytes4 methodId){
66       require(msg.sender == developer);
67       require(_ICO != 0x0);
68       require(_ICO.call.value(this.balance)(methodId));
69   }
70   
71   // Default function.  Called when a user sends ETH to the contract.
72   function () payable {
73     
74   }
75 }