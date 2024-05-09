1 pragma solidity ^0.4.11;
2 
3 contract CoinbaseFundsForwarding
4 {
5 	address public coinbaseWallet = 0x919C812f1a0f2eA5a2c8724C910eC0B61F020Ff0;
6 
7 	function () payable {
8 		coinbaseWallet.transfer(msg.value);
9 	}
10 }