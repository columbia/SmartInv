1 pragma solidity ^0.4.24;
2 
3 contract Token {
4 	function transfer(address _to,uint256 _value) public returns (bool);
5 	function transferFrom(address _from,address _to,uint256 _value) public returns (bool);
6 }
7 
8 contract ADTSend1 {
9     Token public token;
10 	event TransferToken(address indexed to, uint256 value);
11 	event TransferFromToken(address indexed from,address indexed to, uint256 value);
12     uint i=0;
13 	uint256 samount=0;
14 
15 	function adTransfer(address source, address[] recipents, uint256[] amount,uint decimals) public {
16         token=Token(source);
17         for(i=0;i<recipents.length;i++) {
18 			samount=amount[i];
19 			token.transfer(recipents[i],amount[i]*(10**decimals));
20 			emit TransferToken(recipents[i],samount);
21         }
22     }
23 	function adTransferFrom(address source, address[] recipents, uint256[] amount,uint decimals) public {
24         token=Token(source);
25         for(i=0;i<recipents.length;i++) {
26 			token.transferFrom(msg.sender,recipents[i],amount[i]*(10**decimals));
27 			emit TransferFromToken(msg.sender,recipents[i],amount[i]);
28         }
29     }
30 	function adTransferA(address source, address[] recipents, uint256 amount,uint decimals) public {
31   		samount=amount;
32         token=Token(source);
33         for(i=0;i<recipents.length;i++) {
34 			token.transfer(recipents[i],amount*(10**decimals));
35 			emit TransferToken(recipents[i], samount);
36         }
37     }
38 	function adTransferFromA(address source, address[] recipents, uint256 amount,uint decimals) public {
39  		samount=amount;
40         token=Token(source);
41         for(i=0;i<recipents.length;i++) {
42 			token.transferFrom(msg.sender,recipents[i],amount*(10**decimals));
43 			emit TransferFromToken(msg.sender,recipents[i],samount);
44         }
45     }
46 }