1 pragma solidity 0.4.24;
2 
3 contract ERC20Interface {
4     function transfer(address _to, uint _value) public returns (bool) {}
5 }
6 
7 contract DropFunnel {
8     
9     ERC20Interface token = ERC20Interface(0xd7E7a876058D8e67efb26aD7B10a4007d90396bC);
10     address owner = 0x53F64794758406C6e8355d22ee4d32926e75dCC6;
11     uint dropAmount = 500000000000000000000;
12   
13 	event PaymentFailure(
14 		address payee
15 	);
16 
17 	function dropVotes(address[] receivers) public {
18 	    require(msg.sender == owner);
19 	    for (uint i = 0; i < receivers.length; i++){
20 	        if (!token.transfer(receivers[i],dropAmount)) {
21 	            emit PaymentFailure(receivers[i]);
22 	        }
23 	    }
24 	}
25 }