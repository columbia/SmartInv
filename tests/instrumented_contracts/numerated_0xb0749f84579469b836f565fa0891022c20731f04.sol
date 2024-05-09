1 pragma solidity ^0.4.23;
2 
3 contract CYBRPurchaseAddress {
4 
5 	address public wallet = 0x22C19409BB811FcfD2c575F24f21D7D5a6174DB1;
6 
7 	function () external payable {
8 		wallet.transfer(msg.value);
9 	}
10 }