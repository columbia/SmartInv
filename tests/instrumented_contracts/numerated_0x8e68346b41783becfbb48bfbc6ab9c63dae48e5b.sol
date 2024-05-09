1 pragma solidity 0.4.21;
2 
3 contract ERC20Interface {
4     function transfer(address _to, uint _value) public returns (bool) {}
5 }
6 
7 contract WhitelistInterface {
8 
9     modifier onlyAdmins() {
10         require(isAdmin(msg.sender));
11         _;
12     }
13 
14     function register(address[] newUsers) public onlyAdmins {}
15   
16     function isAdmin(address _admin) public view returns(bool) {}
17 
18 }
19 
20 contract NecFunnel {
21     
22     ERC20Interface token = ERC20Interface(0xCc80C051057B774cD75067Dc48f8987C4Eb97A5e);
23     WhitelistInterface list = WhitelistInterface(0x0E55c54249F25f70D519b7Fb1c20e3331e7Ba76d);
24 
25     modifier onlyAdmins() {
26         require(list.isAdmin(msg.sender));
27         _;
28     }
29   
30 	event PaymentFailure(
31 		address payee,
32 		uint value
33 	);
34 
35 	function dropNectar(address[] receivers, uint[] values) public onlyAdmins {
36 	    list.register(receivers);
37 	    for (uint i = 0; i < receivers.length; i++){
38 	        if (!token.transfer(receivers[i],values[i])) {
39 	            emit PaymentFailure(receivers[i], values[i]);
40 	        }
41 	    }
42 	}
43 }